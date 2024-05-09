1 // File: @openzeppelin/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: contracts/ProxyReceiver/IERC1538.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /// @title ERC1538 Transparent Contract Standard
84 /// @dev Required interface
85 ///  Note: the ERC-165 identifier for this interface is 0x61455567
86 interface IERC1538 {
87 
88     /// @dev This emits when one or a set of functions are updated in a transparent contract.
89     ///  The message string should give a short description of the change and why
90     ///  the change was made.
91     event CommitMessage(string message);
92 
93     /// @dev This emits for each function that is updated in a transparent contract.
94     ///  functionId is the bytes4 of the keccak256 of the function signature.
95     ///  oldDelegate is the delegate contract address of the old delegate contract if
96     ///  the function is being replaced or removed.
97     ///  oldDelegate is the zero value address(0) if a function is being added for the
98     ///  first time.
99     ///  newDelegate is the delegate contract address of the new delegate contract if
100     ///  the function is being added for the first time or if the function is being
101     ///  replaced.
102     ///  newDelegate is the zero value address(0) if the function is being removed.
103     event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
104 
105     /// @notice Updates functions in a transparent contract.
106     /// @dev If the value of _delegate is zero then the functions specified
107     ///  in _functionSignatures are removed.
108     ///  If the value of _delegate is a delegate contract address then the functions
109     ///  specified in _functionSignatures will be delegated to that address.
110     /// @param _delegate The address of a delegate contract to delegate to or zero
111     ///        to remove functions.
112     /// @param _functionSignatures A list of function signatures listed one after the other
113     /// @param _commitMessage A short description of the change and why it is made
114     ///        This message is passed to the CommitMessage event.
115     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) external;
116 }
117 
118 // File: contracts/ProxyReceiver/ProxyBaseStorage.sol
119 
120 pragma solidity ^0.5.0;
121 
122 ///////////////////////////////////////////////////////////////////////////////////////////////////
123 /**
124  * @title ProxyBaseStorage
125  * @dev Defining base storage for the proxy contract.
126  */
127 ///////////////////////////////////////////////////////////////////////////////////////////////////
128 
129 contract ProxyBaseStorage {
130 
131     //////////////////////////////////////////// VARS /////////////////////////////////////////////
132 
133     // maps functions to the delegate contracts that execute the functions.
134     // funcId => delegate contract
135     mapping(bytes4 => address) public delegates;
136   
137     // array of function signatures supported by the contract.
138     bytes[] internal funcSignatures;
139 
140     // maps each function signature to its position in the funcSignatures array.
141     // signature => index+1
142     mapping(bytes => uint256) internal funcSignatureToIndex;
143 
144     // proxy address of itself, can be used for cross-delegate calls but also safety checking.
145     address proxy;
146 
147     ///////////////////////////////////////////////////////////////////////////////////////////////
148 
149 }
150 
151 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
152 
153 pragma solidity ^0.5.0;
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
230 // File: @openzeppelin/contracts/math/SafeMath.sol
231 
232 pragma solidity ^0.5.0;
233 
234 /**
235  * @dev Wrappers over Solidity's arithmetic operations with added overflow
236  * checks.
237  *
238  * Arithmetic operations in Solidity wrap on overflow. This can easily result
239  * in bugs, because programmers usually assume that an overflow raises an
240  * error, which is the standard behavior in high level programming languages.
241  * `SafeMath` restores this intuition by reverting the transaction when an
242  * operation overflows.
243  *
244  * Using this library instead of the unchecked operations eliminates an entire
245  * class of bugs, so it's recommended to use it always.
246  */
247 library SafeMath {
248     /**
249      * @dev Returns the addition of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `+` operator.
253      *
254      * Requirements:
255      * - Addition cannot overflow.
256      */
257     function add(uint256 a, uint256 b) internal pure returns (uint256) {
258         uint256 c = a + b;
259         require(c >= a, "SafeMath: addition overflow");
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting on
266      * overflow (when the result is negative).
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      * - Subtraction cannot overflow.
272      */
273     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
274         require(b <= a, "SafeMath: subtraction overflow");
275         uint256 c = a - b;
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the multiplication of two unsigned integers, reverting on
282      * overflow.
283      *
284      * Counterpart to Solidity's `*` operator.
285      *
286      * Requirements:
287      * - Multiplication cannot overflow.
288      */
289     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
291         // benefit is lost if 'b' is also tested.
292         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
293         if (a == 0) {
294             return 0;
295         }
296 
297         uint256 c = a * b;
298         require(c / a == b, "SafeMath: multiplication overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the integer division of two unsigned integers. Reverts on
305      * division by zero. The result is rounded towards zero.
306      *
307      * Counterpart to Solidity's `/` operator. Note: this function uses a
308      * `revert` opcode (which leaves remaining gas untouched) while Solidity
309      * uses an invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      * - The divisor cannot be zero.
313      */
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         // Solidity only automatically asserts when dividing by 0
316         require(b > 0, "SafeMath: division by zero");
317         uint256 c = a / b;
318         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
335         require(b != 0, "SafeMath: modulo by zero");
336         return a % b;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
341 
342 pragma solidity ^0.5.0;
343 
344 
345 
346 /**
347  * @dev Implementation of the `IERC20` interface.
348  *
349  * This implementation is agnostic to the way tokens are created. This means
350  * that a supply mechanism has to be added in a derived contract using `_mint`.
351  * For a generic mechanism see `ERC20Mintable`.
352  *
353  * *For a detailed writeup see our guide [How to implement supply
354  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
355  *
356  * We have followed general OpenZeppelin guidelines: functions revert instead
357  * of returning `false` on failure. This behavior is nonetheless conventional
358  * and does not conflict with the expectations of ERC20 applications.
359  *
360  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
361  * This allows applications to reconstruct the allowance for all accounts just
362  * by listening to said events. Other implementations of the EIP may not emit
363  * these events, as it isn't required by the specification.
364  *
365  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
366  * functions have been added to mitigate the well-known issues around setting
367  * allowances. See `IERC20.approve`.
368  */
369 contract ERC20 is IERC20 {
370     using SafeMath for uint256;
371 
372     mapping (address => uint256) private _balances;
373 
374     mapping (address => mapping (address => uint256)) private _allowances;
375 
376     uint256 private _totalSupply;
377 
378     /**
379      * @dev See `IERC20.totalSupply`.
380      */
381     function totalSupply() public view returns (uint256) {
382         return _totalSupply;
383     }
384 
385     /**
386      * @dev See `IERC20.balanceOf`.
387      */
388     function balanceOf(address account) public view returns (uint256) {
389         return _balances[account];
390     }
391 
392     /**
393      * @dev See `IERC20.transfer`.
394      *
395      * Requirements:
396      *
397      * - `recipient` cannot be the zero address.
398      * - the caller must have a balance of at least `amount`.
399      */
400     function transfer(address recipient, uint256 amount) public returns (bool) {
401         _transfer(msg.sender, recipient, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See `IERC20.allowance`.
407      */
408     function allowance(address owner, address spender) public view returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     /**
413      * @dev See `IERC20.approve`.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function approve(address spender, uint256 value) public returns (bool) {
420         _approve(msg.sender, spender, value);
421         return true;
422     }
423 
424     /**
425      * @dev See `IERC20.transferFrom`.
426      *
427      * Emits an `Approval` event indicating the updated allowance. This is not
428      * required by the EIP. See the note at the beginning of `ERC20`;
429      *
430      * Requirements:
431      * - `sender` and `recipient` cannot be the zero address.
432      * - `sender` must have a balance of at least `value`.
433      * - the caller must have allowance for `sender`'s tokens of at least
434      * `amount`.
435      */
436     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
439         return true;
440     }
441 
442     /**
443      * @dev Atomically increases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to `approve` that can be used as a mitigation for
446      * problems described in `IERC20.approve`.
447      *
448      * Emits an `Approval` event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      */
454     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
455         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
456         return true;
457     }
458 
459     /**
460      * @dev Atomically decreases the allowance granted to `spender` by the caller.
461      *
462      * This is an alternative to `approve` that can be used as a mitigation for
463      * problems described in `IERC20.approve`.
464      *
465      * Emits an `Approval` event indicating the updated allowance.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      * - `spender` must have allowance for the caller of at least
471      * `subtractedValue`.
472      */
473     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
474         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
475         return true;
476     }
477 
478     /**
479      * @dev Moves tokens `amount` from `sender` to `recipient`.
480      *
481      * This is internal function is equivalent to `transfer`, and can be used to
482      * e.g. implement automatic token fees, slashing mechanisms, etc.
483      *
484      * Emits a `Transfer` event.
485      *
486      * Requirements:
487      *
488      * - `sender` cannot be the zero address.
489      * - `recipient` cannot be the zero address.
490      * - `sender` must have a balance of at least `amount`.
491      */
492     function _transfer(address sender, address recipient, uint256 amount) internal {
493         require(sender != address(0), "ERC20: transfer from the zero address");
494         require(recipient != address(0), "ERC20: transfer to the zero address");
495 
496         _balances[sender] = _balances[sender].sub(amount);
497         _balances[recipient] = _balances[recipient].add(amount);
498         emit Transfer(sender, recipient, amount);
499     }
500 
501     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
502      * the total supply.
503      *
504      * Emits a `Transfer` event with `from` set to the zero address.
505      *
506      * Requirements
507      *
508      * - `to` cannot be the zero address.
509      */
510     function _mint(address account, uint256 amount) internal {
511         require(account != address(0), "ERC20: mint to the zero address");
512 
513         _totalSupply = _totalSupply.add(amount);
514         _balances[account] = _balances[account].add(amount);
515         emit Transfer(address(0), account, amount);
516     }
517 
518      /**
519      * @dev Destoys `amount` tokens from `account`, reducing the
520      * total supply.
521      *
522      * Emits a `Transfer` event with `to` set to the zero address.
523      *
524      * Requirements
525      *
526      * - `account` cannot be the zero address.
527      * - `account` must have at least `amount` tokens.
528      */
529     function _burn(address account, uint256 value) internal {
530         require(account != address(0), "ERC20: burn from the zero address");
531 
532         _totalSupply = _totalSupply.sub(value);
533         _balances[account] = _balances[account].sub(value);
534         emit Transfer(account, address(0), value);
535     }
536 
537     /**
538      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
539      *
540      * This is internal function is equivalent to `approve`, and can be used to
541      * e.g. set automatic allowances for certain subsystems, etc.
542      *
543      * Emits an `Approval` event.
544      *
545      * Requirements:
546      *
547      * - `owner` cannot be the zero address.
548      * - `spender` cannot be the zero address.
549      */
550     function _approve(address owner, address spender, uint256 value) internal {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = value;
555         emit Approval(owner, spender, value);
556     }
557 
558     /**
559      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
560      * from the caller's allowance.
561      *
562      * See `_burn` and `_approve`.
563      */
564     function _burnFrom(address account, uint256 amount) internal {
565         _burn(account, amount);
566         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
567     }
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 /**
576  * @dev Optional functions from the ERC20 standard.
577  */
578 contract ERC20Detailed is IERC20 {
579     string private _name;
580     string private _symbol;
581     uint8 private _decimals;
582 
583     /**
584      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
585      * these values are immutable: they can only be set once during
586      * construction.
587      */
588     constructor (string memory name, string memory symbol, uint8 decimals) public {
589         _name = name;
590         _symbol = symbol;
591         _decimals = decimals;
592     }
593 
594     /**
595      * @dev Returns the name of the token.
596      */
597     function name() public view returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev Returns the symbol of the token, usually a shorter version of the
603      * name.
604      */
605     function symbol() public view returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev Returns the number of decimals used to get its user representation.
611      * For example, if `decimals` equals `2`, a balance of `505` tokens should
612      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
613      *
614      * Tokens usually opt for a value of 18, imitating the relationship between
615      * Ether and Wei.
616      *
617      * > Note that this information is only used for _display_ purposes: it in
618      * no way affects any of the arithmetic of the contract, including
619      * `IERC20.balanceOf` and `IERC20.transfer`.
620      */
621     function decimals() public view returns (uint8) {
622         return _decimals;
623     }
624 }
625 
626 // File: contracts/ProxyToken.sol
627 
628 pragma solidity ^0.5.0;
629 
630 
631 
632 
633 
634 
635 
636 contract ProxyToken is
637     ERC20,
638     ERC20Detailed,
639     Ownable,
640     ProxyBaseStorage,
641     IERC1538
642 {
643     mapping(address => mapping(bytes4 => bool)) public WhiteListedCaller;
644 
645     mapping(bytes4 => bool) public nonWhiteListed;
646 
647     address balanceOfDelegate;
648 
649     event balanceOfDelegateUpdated(address newDelegate);
650 
651     constructor() public ERC20Detailed("Hercules", "HERC", 18) {
652         _mint(0x1a2a618f83e89efBD9C9C120AB38C1C2eC9c4E76, 234259085000000000000000000);
653     }
654 
655     function updateBalanceDelegate(address _a) public onlyOwner() {
656         balanceOfDelegate = _a;
657         emit balanceOfDelegateUpdated(_a);
658     }
659     function WhiteListCaller(address a, bytes4 _function) public onlyOwner() {
660         WhiteListedCaller[a][_function] = true;
661     }
662     function deWhiteListCaller(address a, bytes4 _function) public onlyOwner() {
663         WhiteListedCaller[a][_function] = false;
664     }
665 
666     function toggleFunctionWhiteListing(bytes4 _function) public onlyOwner() {
667         nonWhiteListed[_function] = !nonWhiteListed[_function];
668     }
669 
670     function burn(uint256 _amount) public {
671         _burn(msg.sender, _amount);
672     }
673 
674     function balanceOf(address _user, uint256 _id) public returns (uint256) {
675         bytes memory encoded = abi.encodeWithSelector(0x00fdd58e, _user, _id);
676         bool b;
677         bytes memory data;
678         (b, data) = balanceOfDelegate.delegatecall(encoded);
679         return abi.decode(data, (uint256));
680     }
681     function() external payable {
682         address delegate = delegates[msg.sig];
683 
684         require(delegate != address(0), "Function does not exist.");
685 
686         if (nonWhiteListed[msg.sig] == false) {
687             require(
688                 WhiteListedCaller[msg.sender][msg.sig] == true,
689                 "user needs to be whitelist to trigger external call"
690             );
691         }
692 
693         assembly {
694             let ptr := mload(0x40)
695             calldatacopy(ptr, 0, calldatasize)
696             let result := delegatecall(gas, delegate, ptr, calldatasize, 0, 0)
697             let size := returndatasize
698             returndatacopy(ptr, 0, size)
699             switch result
700                 case 0 {
701                     revert(ptr, size)
702                 }
703                 default {
704                     return(ptr, size)
705                 }
706         }
707     }
708 
709     ///////////////////////////////////////////////////////////////////////////////////////////////
710 
711     /// @notice Updates functions in a transparent contract.
712     /// @dev If the value of _delegate is zero then the functions specified
713     ///  in _functionSignatures are removed.
714     ///  If the value of _delegate is a delegate contract address then the functions
715     ///  specified in _functionSignatures will be delegated to that address.
716     /// @param _delegate The address of a delegate contract to delegate to or zero
717     /// @param _functionSignatures A list of function signatures listed one after the other
718     /// @param _commitMessage A short description of the change and why it is made
719     ///        This message is passed to the CommitMessage event.
720     function updateContract(
721         address _delegate,
722         string calldata _functionSignatures,
723         string calldata _commitMessage
724     ) external onlyOwner() {
725         // ***
726         // NEEDS SECURITY ADDING HERE, SUGGEST MULTI-ADDRESS APPROVAL SYSTEM OR EQUIVALENT.
727         // ***
728 
729         // pos is first used to check the size of the delegate contract.
730         // After that pos is the current memory location of _functionSignatures.
731         // It is used to move through the characters of _functionSignatures
732         uint256 pos;
733 
734         if (_delegate != address(0)) {
735             assembly {
736                 pos := extcodesize(_delegate)
737             }
738             require(
739                 pos > 0,
740                 "_delegate address is not a contract and is not address(0)"
741             );
742         }
743 
744         // creates a bytes version of _functionSignatures
745         bytes memory signatures = bytes(_functionSignatures);
746 
747         // stores the position in memory where _functionSignatures ends.
748         uint256 signaturesEnd;
749 
750         // stores the starting position of a function signature in _functionSignatures
751         uint256 start;
752 
753         assembly {
754             pos := add(signatures, 32)
755             start := pos
756             signaturesEnd := add(pos, mload(signatures))
757         }
758         // the function id of the current function signature
759         bytes4 funcId;
760 
761         // the delegate address that is being replaced or address(0) if removing functions
762         address oldDelegate;
763 
764         // the length of the current function signature in _functionSignatures
765         uint256 num;
766 
767         // the current character in _functionSignatures
768         uint256 char;
769 
770         // the position of the current function signature in the funcSignatures array
771         uint256 index;
772 
773         // the last position in the funcSignatures array
774         uint256 lastIndex;
775 
776         // parse the _functionSignatures string and handle each function
777 
778         for (; pos < signaturesEnd; pos++) {
779             assembly {
780                 char := byte(0, mload(pos))
781             }
782             // 0x29 == )
783             if (char == 0x29) {
784                 pos++;
785                 num = (pos - start);
786                 start = pos;
787                 assembly {
788                     mstore(signatures, num)
789                 }
790                 funcId = bytes4(keccak256(signatures));
791                 oldDelegate = delegates[funcId];
792                 if (_delegate == address(0)) {
793                     index = funcSignatureToIndex[signatures];
794                     require(index != 0, "Function does not exist.");
795                     index--;
796                     lastIndex = funcSignatures.length - 1;
797                     if (index != lastIndex) {
798                         funcSignatures[index] = funcSignatures[lastIndex];
799                         funcSignatureToIndex[funcSignatures[lastIndex]] =
800                             index +
801                             1;
802                     }
803                     funcSignatures.length--;
804                     delete funcSignatureToIndex[signatures];
805                     delete delegates[funcId];
806                     emit FunctionUpdate(
807                         funcId,
808                         oldDelegate,
809                         address(0),
810                         string(signatures)
811                     );
812                 } else if (funcSignatureToIndex[signatures] == 0) {
813                     require(oldDelegate == address(0), "FuncId clash.");
814                     delegates[funcId] = _delegate;
815                     funcSignatures.push(signatures);
816                     funcSignatureToIndex[signatures] = funcSignatures.length;
817                     emit FunctionUpdate(
818                         funcId,
819                         address(0),
820                         _delegate,
821                         string(signatures)
822                     );
823                 } else if (delegates[funcId] != _delegate) {
824                     delegates[funcId] = _delegate;
825                     emit FunctionUpdate(
826                         funcId,
827                         oldDelegate,
828                         _delegate,
829                         string(signatures)
830                     );
831 
832                 }
833 
834                 WhiteListedCaller[msg.sender][funcId] = true;
835 
836                 assembly {
837                     signatures := add(signatures, num)
838                 }
839 
840             }
841         }
842         emit CommitMessage(_commitMessage);
843     }
844 }