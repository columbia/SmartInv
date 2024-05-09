1 pragma solidity ^0.5.12;
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
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
31 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
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
153 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
224      * @dev Emitted when `value` tokens burn from account (`from`)
225      *
226      * Note that `value` may be zero.
227      */
228     event Burn(address indexed from, uint256 value);
229 
230     /**
231      * @dev Emitted when `value` tokens mint to account (`to`) 
232      *
233      * Note that `value` may be zero.
234      */
235     event Mint(address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to `approve`. `value` is the new allowance.
240      */
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 // File: @openzeppelin/contracts/math/SafeMath.sol
245 
246 /**
247  * @dev Wrappers over Solidity's arithmetic operations with added overflow
248  * checks.
249  *
250  * Arithmetic operations in Solidity wrap on overflow. This can easily result
251  * in bugs, because programmers usually assume that an overflow raises an
252  * error, which is the standard behavior in high level programming languages.
253  * `SafeMath` restores this intuition by reverting the transaction when an
254  * operation overflows.
255  *
256  * Using this library instead of the unchecked operations eliminates an entire
257  * class of bugs, so it's recommended to use it always.
258  */
259 library SafeMath {
260     /**
261      * @dev Returns the addition of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `+` operator.
265      *
266      * Requirements:
267      * - Addition cannot overflow.
268      */
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         uint256 c = a + b;
271         require(c >= a, "SafeMath: addition overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the subtraction of two unsigned integers, reverting on
278      * overflow (when the result is negative).
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      * - Subtraction cannot overflow.
284      */
285     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286         require(b <= a, "SafeMath: subtraction overflow");
287         uint256 c = a - b;
288 
289         return c;
290     }
291 
292     /**
293      * @dev Returns the multiplication of two unsigned integers, reverting on
294      * overflow.
295      *
296      * Counterpart to Solidity's `*` operator.
297      *
298      * Requirements:
299      * - Multiplication cannot overflow.
300      */
301     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
302         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
303         // benefit is lost if 'b' is also tested.
304         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
305         if (a == 0) {
306             return 0;
307         }
308 
309         uint256 c = a * b;
310         require(c / a == b, "SafeMath: multiplication overflow");
311 
312         return c;
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers. Reverts on
317      * division by zero. The result is rounded towards zero.
318      *
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      * - The divisor cannot be zero.
325      */
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         // Solidity only automatically asserts when dividing by 0
328         require(b > 0, "SafeMath: division by zero");
329         uint256 c = a / b;
330         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * Reverts when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      * - The divisor cannot be zero.
345      */
346     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
347         require(b != 0, "SafeMath: modulo by zero");
348         return a % b;
349     }
350 }
351 
352 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
353 
354 /**
355  * @dev Implementation of the `IERC20` interface.
356  *
357  * This implementation is agnostic to the way tokens are created. This means
358  * that a supply mechanism has to be added in a derived contract using `_mint`.
359  * For a generic mechanism see `ERC20Mintable`.
360  *
361  * *For a detailed writeup see our guide [How to implement supply
362  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
363  *
364  * We have followed general OpenZeppelin guidelines: functions revert instead
365  * of returning `false` on failure. This behavior is nonetheless conventional
366  * and does not conflict with the expectations of ERC20 applications.
367  *
368  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
369  * This allows applications to reconstruct the allowance for all accounts just
370  * by listening to said events. Other implementations of the EIP may not emit
371  * these events, as it isn't required by the specification.
372  *
373  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
374  * functions have been added to mitigate the well-known issues around setting
375  * allowances. See `IERC20.approve`.
376  */
377 contract ERC20 is IERC20 {
378     using SafeMath for uint256;
379 
380     mapping (address => uint256) private _balances;
381 
382     mapping (address => mapping (address => uint256)) private _allowances;
383 
384     uint256 private _totalSupply;
385 
386     /**
387      * @dev See `IERC20.totalSupply`.
388      */
389     function totalSupply() public view returns (uint256) {
390         return _totalSupply;
391     }
392 
393     /**
394      * @dev See `IERC20.balanceOf`.
395      */
396     function balanceOf(address account) public view returns (uint256) {
397         return _balances[account];
398     }
399 
400     /**
401      * @dev See `IERC20.transfer`.
402      *
403      * Requirements:
404      *
405      * - `recipient` cannot be the zero address.
406      * - the caller must have a balance of at least `amount`.
407      */
408     function transfer(address recipient, uint256 amount) public returns (bool) {
409         _transfer(msg.sender, recipient, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See `IERC20.allowance`.
415      */
416     function allowance(address owner, address spender) public view returns (uint256) {
417         return _allowances[owner][spender];
418     }
419 
420     /**
421      * @dev See `IERC20.approve`.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function approve(address spender, uint256 value) public returns (bool) {
428         _approve(msg.sender, spender, value);
429         return true;
430     }
431 
432     /**
433      * @dev See `IERC20.transferFrom`.
434      *
435      * Emits an `Approval` event indicating the updated allowance. This is not
436      * required by the EIP. See the note at the beginning of `ERC20`;
437      *
438      * Requirements:
439      * - `sender` and `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `value`.
441      * - the caller must have allowance for `sender`'s tokens of at least
442      * `amount`.
443      */
444     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
445         _transfer(sender, recipient, amount);
446         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically increases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to `approve` that can be used as a mitigation for
454      * problems described in `IERC20.approve`.
455      *
456      * Emits an `Approval` event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      */
462     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
463         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
464         return true;
465     }
466 
467     /**
468      * @dev Atomically decreases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to `approve` that can be used as a mitigation for
471      * problems described in `IERC20.approve`.
472      *
473      * Emits an `Approval` event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      * - `spender` must have allowance for the caller of at least
479      * `subtractedValue`.
480      */
481     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
482         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
483         return true;
484     }
485 
486     /**
487      * @dev Moves tokens `amount` from `sender` to `recipient`.
488      *
489      * This is internal function is equivalent to `transfer`, and can be used to
490      * e.g. implement automatic token fees, slashing mechanisms, etc.
491      *
492      * Emits a `Transfer` event.
493      *
494      * Requirements:
495      *
496      * - `sender` cannot be the zero address.
497      * - `recipient` cannot be the zero address.
498      * - `sender` must have a balance of at least `amount`.
499      */
500     function _transfer(address sender, address recipient, uint256 amount) internal {
501         require(sender != address(0), "ERC20: transfer from the zero address");
502         require(recipient != address(0), "ERC20: transfer to the zero address");
503 
504         _balances[sender] = _balances[sender].sub(amount);
505         _balances[recipient] = _balances[recipient].add(amount);
506         emit Transfer(sender, recipient, amount);
507     }
508 
509     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
510      * the total supply.
511      *
512      * Emits a `Mint` event with `from` set to the zero address.
513      *
514      * Requirements
515      *
516      * - `to` cannot be the zero address.
517      */
518     function _mint(address account, uint256 amount) internal {
519         require(account != address(0), "ERC20: mint to the zero address");
520 
521         _totalSupply = _totalSupply.add(amount);
522         _balances[account] = _balances[account].add(amount);
523         emit Transfer(address(0), account, amount);
524         emit Mint(account, amount);
525     }
526 
527      /**
528      * @dev Destoys `amount` tokens from `account`, reducing the
529      * total supply.
530      *
531      * Emits a `Burn` event with `to` set to the zero address.
532      *
533      * Requirements
534      *
535      * - `account` cannot be the zero address.
536      * - `account` must have at least `amount` tokens.
537      */
538     function _burn(address account, uint256 value) internal {
539         require(account != address(0), "ERC20: burn from the zero address");
540 
541         _totalSupply = _totalSupply.sub(value);
542         _balances[account] = _balances[account].sub(value);
543         emit Transfer(account, address(0), value);
544         emit Burn(account, value);
545     }
546 
547     /**
548      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
549      *
550      * This is internal function is equivalent to `approve`, and can be used to
551      * e.g. set automatic allowances for certain subsystems, etc.
552      *
553      * Emits an `Approval` event.
554      *
555      * Requirements:
556      *
557      * - `owner` cannot be the zero address.
558      * - `spender` cannot be the zero address.
559      */
560     function _approve(address owner, address spender, uint256 value) internal {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563 
564         _allowances[owner][spender] = value;
565         emit Approval(owner, spender, value);
566     }
567 
568     /**
569      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
570      * from the caller's allowance.
571      *
572      * See `_burn` and `_approve`.
573      */
574     function _burnFrom(address account, uint256 amount) internal {
575         _burn(account, amount);
576         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
577     }
578 }
579 
580 // File: @openzeppelin/contracts/introspection/IERC165.sol
581 
582 /**
583  * @dev Interface of the ERC165 standard, as defined in the
584  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
585  *
586  * Implementers can declare support of contract interfaces, which can then be
587  * queried by others (`ERC165Checker`).
588  *
589  * For an implementation, see `ERC165`.
590  */
591 interface IERC165 {
592     /**
593      * @dev Returns true if this contract implements the interface defined by
594      * `interfaceId`. See the corresponding
595      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
596      * to learn more about how these ids are created.
597      *
598      * This function call must use less than 30 000 gas.
599      */
600     function supportsInterface(bytes4 interfaceId) external view returns (bool);
601 }
602 
603 // File: @openzeppelin/contracts/introspection/ERC165.sol
604 
605 /**
606  * @dev Implementation of the `IERC165` interface.
607  *
608  * Contracts may inherit from this and call `_registerInterface` to declare
609  * their support of an interface.
610  */
611 contract ERC165 is IERC165 {
612     /*
613      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
614      */
615     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
616 
617     /**
618      * @dev Mapping of interface ids to whether or not it's supported.
619      */
620     mapping(bytes4 => bool) private _supportedInterfaces;
621 
622     constructor () internal {
623         // Derived contracts need only register support for their own interfaces,
624         // we register support for ERC165 itself here
625         _registerInterface(_INTERFACE_ID_ERC165);
626     }
627 
628     /**
629      * @dev See `IERC165.supportsInterface`.
630      *
631      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
632      */
633     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
634         return _supportedInterfaces[interfaceId];
635     }
636 
637     /**
638      * @dev Registers the contract as an implementer of the interface defined by
639      * `interfaceId`. Support of the actual ERC165 interface is automatic and
640      * registering its interface id is not required.
641      *
642      * See `IERC165.supportsInterface`.
643      *
644      * Requirements:
645      *
646      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
647      */
648     function _registerInterface(bytes4 interfaceId) internal {
649         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
650         _supportedInterfaces[interfaceId] = true;
651     }
652 }
653 
654 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
655 
656 /**
657  * @title IERC1363 Interface
658  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
659  * @dev Interface for a Payable Token contract as defined in
660  *  https://github.com/ethereum/EIPs/issues/1363
661  */
662 contract IERC1363 is IERC20, ERC165 {
663     /*
664      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
665      * 0x4bbee2df ===
666      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
667      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
668      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
669      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
670      */
671 
672     /*
673      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
674      * 0xfb9ec8ce ===
675      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
676      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
677      */
678 
679     /**
680      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
681      * @param to address The address which you want to transfer to
682      * @param value uint256 The amount of tokens to be transferred
683      * @return true unless throwing
684      */
685     function transferAndCall(address to, uint256 value) public returns (bool);
686 
687     /**
688      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
689      * @param to address The address which you want to transfer to
690      * @param value uint256 The amount of tokens to be transferred
691      * @param data bytes Additional data with no specified format, sent in call to `to`
692      * @return true unless throwing
693      */
694     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
695 
696     /**
697      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
698      * @param from address The address which you want to send tokens from
699      * @param to address The address which you want to transfer to
700      * @param value uint256 The amount of tokens to be transferred
701      * @return true unless throwing
702      */
703     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
704 
705 
706     /**
707      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
708      * @param from address The address which you want to send tokens from
709      * @param to address The address which you want to transfer to
710      * @param value uint256 The amount of tokens to be transferred
711      * @param data bytes Additional data with no specified format, sent in call to `to`
712      * @return true unless throwing
713      */
714     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
715 
716     /**
717      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
718      * and then call `onApprovalReceived` on spender.
719      * Beware that changing an allowance with this method brings the risk that someone may use both the old
720      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
721      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
722      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
723      * @param spender address The address which will spend the funds
724      * @param value uint256 The amount of tokens to be spent
725      */
726     function approveAndCall(address spender, uint256 value) public returns (bool);
727 
728     /**
729      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
730      * and then call `onApprovalReceived` on spender.
731      * Beware that changing an allowance with this method brings the risk that someone may use both the old
732      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
733      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
734      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
735      * @param spender address The address which will spend the funds
736      * @param value uint256 The amount of tokens to be spent
737      * @param data bytes Additional data with no specified format, sent in call to `spender`
738      */
739     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
740 }
741 
742 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
743 
744 /**
745  * @title IERC1363Receiver Interface
746  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
747  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
748  *  from ERC1363 token contracts as defined in
749  *  https://github.com/ethereum/EIPs/issues/1363
750  */
751 contract IERC1363Receiver {
752     /*
753      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
754      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
755      */
756 
757     /**
758      * @notice Handle the receipt of ERC1363 tokens
759      * @dev Any ERC1363 smart contract calls this function on the recipient
760      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
761      * transfer. Return of other than the magic value MUST result in the
762      * transaction being reverted.
763      * Note: the token contract address is always the message sender.
764      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
765      * @param from address The address which are token transferred from
766      * @param value uint256 The amount of tokens transferred
767      * @param data bytes Additional data with no specified format
768      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
769      *  unless throwing
770      */
771     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
772 }
773 
774 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
775 
776 /**
777  * @title IERC1363Spender Interface
778  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
779  * @dev Interface for any contract that wants to support approveAndCall
780  *  from ERC1363 token contracts as defined in
781  *  https://github.com/ethereum/EIPs/issues/1363
782  */
783 contract IERC1363Spender {
784     /*
785      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
786      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
787      */
788 
789     /**
790      * @notice Handle the approval of ERC1363 tokens
791      * @dev Any ERC1363 smart contract calls this function on the recipient
792      * after an `approve`. This function MAY throw to revert and reject the
793      * approval. Return of other than the magic value MUST result in the
794      * transaction being reverted.
795      * Note: the token contract address is always the message sender.
796      * @param owner address The address which called `approveAndCall` function
797      * @param value uint256 The amount of tokens to be spent
798      * @param data bytes Additional data with no specified format
799      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
800      *  unless throwing
801      */
802     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
803 }
804 
805 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
806 
807 /**
808  * @title ERC1363
809  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
810  * @dev Implementation of an ERC1363 interface
811  */
812 contract ERC1363 is ERC20, IERC1363 {
813     using Address for address;
814 
815     /*
816      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
817      * 0x4bbee2df ===
818      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
819      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
820      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
821      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
822      */
823     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
824 
825     /*
826      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
827      * 0xfb9ec8ce ===
828      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
829      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
830      */
831     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
832 
833     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
834     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
835     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
836 
837     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
838     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
839     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
840 
841     constructor() public {
842         // register the supported interfaces to conform to ERC1363 via ERC165
843         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
844         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
845     }
846 
847     function transferAndCall(address to, uint256 value) public returns (bool) {
848         return transferAndCall(to, value, "");
849     }
850 
851     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
852         require(transfer(to, value));
853         require(_checkAndCallTransfer(msg.sender, to, value, data));
854         return true;
855     }
856 
857     function transferFromAndCall(address from, address to, uint256 value) public returns (bool) {
858         return transferFromAndCall(from, to, value, "");
859     }
860 
861     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool) {
862         require(transferFrom(from, to, value));
863         require(_checkAndCallTransfer(from, to, value, data));
864         return true;
865     }
866 
867     function approveAndCall(address spender, uint256 value) public returns (bool) {
868         return approveAndCall(spender, value, "");
869     }
870 
871     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
872         approve(spender, value);
873         require(_checkAndCallApprove(spender, value, data));
874         return true;
875     }
876 
877     /**
878      * @dev Internal function to invoke `onTransferReceived` on a target address
879      *  The call is not executed if the target address is not a contract
880      * @param from address Representing the previous owner of the given token value
881      * @param to address Target address that will receive the tokens
882      * @param value uint256 The amount mount of tokens to be transferred
883      * @param data bytes Optional data to send along with the call
884      * @return whether the call correctly returned the expected magic value
885      */
886     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
887         if (!to.isContract()) {
888             return false;
889         }
890         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
891             msg.sender, from, value, data
892         );
893         return (retval == _ERC1363_RECEIVED);
894     }
895 
896     /**
897      * @dev Internal function to invoke `onApprovalReceived` on a target address
898      *  The call is not executed if the target address is not a contract
899      * @param spender address The address which will spend the funds
900      * @param value uint256 The amount of tokens to be spent
901      * @param data bytes Optional data to send along with the call
902      * @return whether the call correctly returned the expected magic value
903      */
904     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
905         if (!spender.isContract()) {
906             return false;
907         }
908         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
909             msg.sender, value, data
910         );
911         return (retval == _ERC1363_APPROVED);
912     }
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
916 
917 /**
918  * @dev Optional functions from the ERC20 standard.
919  */
920 contract ERC20Detailed is IERC20 {
921     string private _name;
922     string private _symbol;
923     uint8 private _decimals;
924 
925     /**
926      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
927      * these values are immutable: they can only be set once during
928      * construction.
929      */
930     constructor (string memory name, string memory symbol, uint8 decimals) public {
931         _name = name;
932         _symbol = symbol;
933         _decimals = decimals;
934     }
935 
936     /**
937      * @dev Returns the name of the token.
938      */
939     function name() public view returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev Returns the symbol of the token, usually a shorter version of the
945      * name.
946      */
947     function symbol() public view returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev Returns the number of decimals used to get its user representation.
953      * For example, if `decimals` equals `2`, a balance of `505` tokens should
954      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
955      *
956      * Tokens usually opt for a value of 18, imitating the relationship between
957      * Ether and Wei.
958      *
959      * > Note that this information is only used for _display_ purposes: it in
960      * no way affects any of the arithmetic of the contract, including
961      * `IERC20.balanceOf` and `IERC20.transfer`.
962      */
963     function decimals() public view returns (uint8) {
964         return _decimals;
965     }
966 }
967 
968 // File: @openzeppelin/contracts/access/Roles.sol
969 
970 /**
971  * @title Roles
972  * @dev Library for managing addresses assigned to a Role.
973  */
974 library Roles {
975     struct Role {
976         mapping (address => bool) bearer;
977     }
978 
979     /**
980      * @dev Give an account access to this role.
981      */
982     function add(Role storage role, address account) internal {
983         require(!has(role, account), "Roles: account already has role");
984         role.bearer[account] = true;
985     }
986 
987     /**
988      * @dev Remove an account's access to this role.
989      */
990     function remove(Role storage role, address account) internal {
991         require(has(role, account), "Roles: account does not have role");
992         role.bearer[account] = false;
993     }
994 
995     /**
996      * @dev Check if an account has this role.
997      * @return bool
998      */
999     function has(Role storage role, address account) internal view returns (bool) {
1000         require(account != address(0), "Roles: account is the zero address");
1001         return role.bearer[account];
1002     }
1003 }
1004 
1005 // File: @openzeppelin/contracts/ownership/Ownable.sol
1006 
1007 /**
1008  * @dev Contract module which provides a basic access control mechanism, where
1009  * there is an account (an owner) that can be granted exclusive access to
1010  * specific functions.
1011  *
1012  * This module is used through inheritance. It will make available the modifier
1013  * `onlyOwner`, which can be aplied to your functions to restrict their use to
1014  * the owner.
1015  */
1016 contract Ownable {
1017     address private _owner;
1018 
1019     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1020 
1021     /**
1022      * @dev Initializes the contract setting the deployer as the initial owner.
1023      */
1024     constructor () internal {
1025         _owner = msg.sender;
1026         emit OwnershipTransferred(address(0), _owner);
1027     }
1028 
1029     /**
1030      * @dev Returns the address of the current owner.
1031      */
1032     function owner() public view returns (address) {
1033         return _owner;
1034     }
1035 
1036     /**
1037      * @dev Throws if called by any account other than the owner.
1038      */
1039     modifier onlyOwner() {
1040         require(isOwner(), "Ownable: caller is not the owner");
1041         _;
1042     }
1043 
1044     /**
1045      * @dev Returns true if the caller is the current owner.
1046      */
1047     function isOwner() public view returns (bool) {
1048         return msg.sender == _owner;
1049     }
1050 
1051     /**
1052      * @dev Leaves the contract without owner. It will not be possible to call
1053      * `onlyOwner` functions anymore. Can only be called by the current owner.
1054      *
1055      * > Note: Renouncing ownership will leave the contract without an owner,
1056      * thereby removing any functionality that is only available to the owner.
1057      */
1058     function renounceOwnership() public onlyOwner {
1059         emit OwnershipTransferred(_owner, address(0));
1060         _owner = address(0);
1061     }
1062 
1063     /**
1064      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1065      * Can only be called by the current owner.
1066      */
1067     function transferOwnership(address newOwner) public onlyOwner {
1068         _transferOwnership(newOwner);
1069     }
1070 
1071     /**
1072      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1073      */
1074     function _transferOwnership(address newOwner) internal {
1075         require(newOwner != address(0), "Ownable: new owner is the zero address");
1076         emit OwnershipTransferred(_owner, newOwner);
1077         _owner = newOwner;
1078     }
1079 }
1080 
1081 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
1082 
1083 contract MinterRole is Ownable {
1084     using Roles for Roles.Role;
1085 
1086     event MinterAdded(address indexed account);
1087     event MinterRemoved(address indexed account);
1088 
1089     Roles.Role private _minters;
1090 
1091     constructor () internal {
1092         _addMinter(msg.sender);
1093     }
1094 
1095     modifier onlyMinter() {
1096         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
1097         _;
1098     }
1099 
1100     function isMinter(address account) public view returns (bool) {
1101         return _minters.has(account);
1102     }
1103 
1104     function addMinter(address account) public onlyOwner {
1105         _addMinter(account);
1106     }
1107 
1108     function renounceMinter() public {
1109         _removeMinter(msg.sender);
1110     }
1111 
1112     function _addMinter(address account) internal {
1113         _minters.add(account);
1114         emit MinterAdded(account);
1115     }
1116 
1117     function _removeMinter(address account) internal {
1118         _minters.remove(account);
1119         emit MinterRemoved(account);
1120     }
1121 }
1122 
1123 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
1124 
1125 /**
1126  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
1127  * which have permission to mint (create) new tokens as they see fit.
1128  *
1129  * At construction, the deployer of the contract is the only minter.
1130  */
1131 contract ERC20Mintable is ERC20, MinterRole {
1132     /**
1133      * @dev See `ERC20._mint`.
1134      *
1135      * Requirements:
1136      *
1137      * - the caller must have the `MinterRole`.
1138      */
1139     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1140         _mint(account, amount);
1141         return true;
1142     }
1143 }
1144 
1145 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1146 
1147 /**
1148  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
1149  */
1150 contract ERC20Capped is ERC20Mintable {
1151     uint256 private _cap;
1152 
1153     /**
1154      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1155      * set once during construction.
1156      */
1157     constructor (uint256 cap) public {
1158         require(cap > 0, "ERC20Capped: cap is 0");
1159         _cap = cap;
1160     }
1161 
1162     /**
1163      * @dev Returns the cap on the token's total supply.
1164      */
1165     function cap() public view returns (uint256) {
1166         return _cap;
1167     }
1168 
1169     /**
1170      * @dev See `ERC20Mintable.mint`.
1171      *
1172      * Requirements:
1173      *
1174      * - `value` must not cause the total supply to go over the cap.
1175      */
1176     function _mint(address account, uint256 value) internal {
1177         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
1178         super._mint(account, value);
1179     }
1180 }
1181 
1182 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1183 
1184 /**
1185  * @dev Extension of `ERC20` that allows token holders to destroy both their own
1186  * tokens and those that they have an allowance for, in a way that can be
1187  * recognized off-chain (via event analysis).
1188  */
1189 contract ERC20Burnable is ERC20 {
1190     /**
1191      * @dev Destoys `amount` tokens from the caller.
1192      *
1193      * See `ERC20._burn`.
1194      */
1195     function burn(uint256 amount) public {
1196         _burn(msg.sender, amount);
1197     }
1198 
1199     /**
1200      * @dev See `ERC20._burnFrom`.
1201      */
1202     function burnFrom(address account, uint256 amount) public {
1203         _burnFrom(account, amount);
1204     }
1205 }
1206 
1207 
1208 
1209 // File: eth-token-recover/contracts/TokenRecover.sol
1210 
1211 /**
1212  * @title TokenRecover
1213  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
1214  * @dev Allow to recover any ERC20 sent into the contract for error
1215  */
1216 contract TokenRecover is Ownable {
1217 
1218     /**
1219      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1220      * @param tokenAddress The token contract address
1221      * @param tokenAmount Number of tokens to be sent
1222      */
1223     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1224         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1225     }
1226 }
1227 
1228 // File: ico-maker/contracts/access/roles/OperatorRole.sol
1229 
1230 contract OperatorRole is Ownable {
1231     using Roles for Roles.Role;
1232 
1233     event OperatorAdded(address indexed account);
1234     event OperatorRemoved(address indexed account);
1235 
1236     Roles.Role private _operators;
1237 
1238     constructor() internal {
1239         _addOperator(msg.sender);
1240     }
1241 
1242     modifier onlyOperator() {
1243         require(isOperator(msg.sender));
1244         _;
1245     }
1246 
1247     function isOperator(address account) public view returns (bool) {
1248         return _operators.has(account);
1249     }
1250 
1251     function addOperator(address account) public onlyOwner {
1252         _addOperator(account);
1253     }
1254 
1255     function renounceOperator() public {
1256         _removeOperator(msg.sender);
1257     }
1258 
1259     function _addOperator(address account) internal {
1260         _operators.add(account);
1261         emit OperatorAdded(account);
1262     }
1263 
1264     function _removeOperator(address account) internal {
1265         _operators.remove(account);
1266         emit OperatorRemoved(account);
1267     }
1268 }
1269 
1270 // File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol
1271 
1272 /**
1273  * @title BaseERC20Token
1274  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
1275  * @dev Implementation of the BaseERC20Token
1276  */
1277 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
1278 
1279     event MintFinished();
1280     event TransferEnabled();
1281 
1282     // indicates if minting is finished
1283     bool private _mintingFinished = false;
1284 
1285     // indicates if transfer is enabled
1286     bool private _transferEnabled = false;
1287 
1288     /**
1289      * @dev Tokens can be minted only before minting finished.
1290      */
1291     modifier canMint() {
1292         require(!_mintingFinished);
1293         _;
1294     }
1295 
1296     /**
1297      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1298      */
1299     modifier canTransfer(address from) {
1300         require(_transferEnabled || isOperator(from));
1301         _;
1302     }
1303 
1304     /**
1305      * @param name Name of the token
1306      * @param symbol A symbol to be used as ticker
1307      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1308      * @param cap Maximum number of tokens mintable
1309      * @param initialSupply Initial token supply
1310      */
1311     constructor(
1312         string memory name,
1313         string memory symbol,
1314         uint8 decimals,
1315         uint256 cap,
1316         uint256 initialSupply
1317     )
1318         public
1319         ERC20Detailed(name, symbol, decimals)
1320         ERC20Capped(cap)
1321     {
1322         if (initialSupply > 0) {
1323             _mint(owner(), initialSupply);
1324         }
1325     }
1326 
1327     /**
1328      * @return if minting is finished or not.
1329      */
1330     function mintingFinished() public view returns (bool) {
1331         return _mintingFinished;
1332     }
1333 
1334     /**
1335      * @return if transfer is enabled or not.
1336      */
1337     function transferEnabled() public view returns (bool) {
1338         return _transferEnabled;
1339     }
1340 
1341     /**
1342      * @dev Function to mint tokens
1343      * @param to The address that will receive the minted tokens.
1344      * @param value The amount of tokens to mint.
1345      * @return A boolean that indicates if the operation was successful.
1346      */
1347     function mint(address to, uint256 value) public canMint returns (bool) {
1348         return super.mint(to, value);
1349     }
1350 
1351     /**
1352      * @dev Transfer token to a specified address
1353      * @param to The address to transfer to.
1354      * @param value The amount to be transferred.
1355      * @return A boolean that indicates if the operation was successful.
1356      */
1357     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
1358         return super.transfer(to, value);
1359     }
1360 
1361     /**
1362      * @dev Transfer tokens from one address to another.
1363      * @param from address The address which you want to send tokens from
1364      * @param to address The address which you want to transfer to
1365      * @param value uint256 the amount of tokens to be transferred
1366      * @return A boolean that indicates if the operation was successful.
1367      */
1368     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
1369         return super.transferFrom(from, to, value);
1370     }
1371 
1372     /**
1373      * @dev Function to stop minting new tokens.
1374      */
1375     function finishMinting() public onlyOwner canMint {
1376         _mintingFinished = true;
1377 
1378         emit MintFinished();
1379     }
1380 
1381     /**
1382    * @dev Function to enable transfers.
1383    */
1384     function enableTransfer() public onlyOwner {
1385         _transferEnabled = true;
1386 
1387         emit TransferEnabled();
1388     }
1389 
1390     /**
1391      * @dev remove the `operator` role from address
1392      * @param account Address you want to remove role
1393      */
1394     function removeOperator(address account) public onlyOwner {
1395         _removeOperator(account);
1396     }
1397 
1398     /**
1399      * @dev remove the `minter` role from address
1400      * @param account Address you want to remove role
1401      */
1402     function removeMinter(address account) public onlyOwner {
1403         _removeMinter(account);
1404     }
1405 }
1406 
1407 // File: ico-maker/contracts/token/ERC1363/BaseERC1363Token.sol
1408 
1409 /**
1410  * @title BaseERC1363Token
1411  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
1412  * @dev Implementation of the BaseERC20Token with ERC1363 behaviours
1413  */
1414 contract BaseERC1363Token is BaseERC20Token, ERC1363 {
1415 
1416     /**
1417      * @param name Name of the token
1418      * @param symbol A symbol to be used as ticker
1419      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1420      * @param cap Maximum number of tokens mintable
1421      * @param initialSupply Initial token supply
1422      */
1423     constructor(
1424         string memory name,
1425         string memory symbol,
1426         uint8 decimals,
1427         uint256 cap,
1428         uint256 initialSupply
1429     )
1430         public
1431         BaseERC20Token(name, symbol, decimals, cap, initialSupply)
1432     {} // solhint-disable-line no-empty-blocks
1433 }
1434 
1435 // File: contracts/ERC20Token.sol
1436 
1437 /**
1438  * @title KarvuonToken
1439  * @author Zolbayar Odonsuren (https://gitlab.com/zolbayar)
1440  * @dev Implementation of a BaseERC1363Token
1441  */
1442 contract Karvuon is BaseERC1363Token {
1443 
1444     string public builtOn = "https://gitlab.com/zolbayar/karvuon-erc20";
1445 
1446     constructor(
1447         string memory name,
1448         string memory symbol,
1449         uint8 decimals,
1450         uint256 cap,
1451         uint256 initialSupply,
1452         bool transferEnabled
1453     )
1454         public
1455         BaseERC1363Token(name, symbol, decimals, cap, initialSupply)
1456     {
1457         if (transferEnabled) {
1458             enableTransfer();
1459         }
1460     }
1461 }