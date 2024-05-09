1 pragma solidity^0.5.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 contract Context {
170     // Empty internal constructor, to prevent people from mistakenly deploying
171     // an instance of this contract, which should be used via inheritance.
172     constructor () internal { }
173     // solhint-disable-previous-line no-empty-blocks
174 
175     function _msgSender() internal view returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 /**
186  * @dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor () internal {
203         address msgSender = _msgSender();
204         _owner = msgSender;
205         emit OwnershipTransferred(address(0), msgSender);
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(isOwner(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Returns true if the caller is the current owner.
225      */
226     function isOwner() public view returns (bool) {
227         return _msgSender() == _owner;
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public onlyOwner {
238         emit OwnershipTransferred(_owner, address(0));
239         _owner = address(0);
240     }
241 
242     /**
243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
244      * Can only be called by the current owner.
245      */
246     function transferOwnership(address newOwner) public onlyOwner {
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      */
253     function _transferOwnership(address newOwner) internal {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 /**
261  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
262  * the optional functions; to access them see {ERC20Detailed}.
263  */
264 interface IERC20 {
265     /**
266      * @dev Returns the amount of tokens in existence.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns the amount of tokens owned by `account`.
272      */
273     function balanceOf(address account) external view returns (uint256);
274 
275     /**
276      * @dev Moves `amount` tokens from the caller's account to `recipient`.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transfer(address recipient, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender) external view returns (uint256);
292 
293     /**
294      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * IMPORTANT: Beware that changing an allowance with this method brings the risk
299      * that someone may use both the old and the new allowance by unfortunate
300      * transaction ordering. One possible solution to mitigate this race
301      * condition is to first reduce the spender's allowance to 0 and set the
302      * desired value afterwards:
303      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304      *
305      * Emits an {Approval} event.
306      */
307     function approve(address spender, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Moves `amount` tokens from `sender` to `recipient` using the
311      * allowance mechanism. `amount` is then deducted from the caller's
312      * allowance.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Emitted when `value` tokens are moved from one account (`from`) to
322      * another (`to`).
323      *
324      * Note that `value` may be zero.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 value);
327 
328     /**
329      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
330      * a call to {approve}. `value` is the new allowance.
331      */
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 }
334 
335 /**
336  * @dev Implementation of the {IERC20} interface.
337  *
338  * This implementation is agnostic to the way tokens are created. This means
339  * that a supply mechanism has to be added in a derived contract using {_mint}.
340  * For a generic mechanism see {ERC20Mintable}.
341  *
342  * TIP: For a detailed writeup see our guide
343  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
344  * to implement supply mechanisms].
345  *
346  * We have followed general OpenZeppelin guidelines: functions revert instead
347  * of returning `false` on failure. This behavior is nonetheless conventional
348  * and does not conflict with the expectations of ERC20 applications.
349  *
350  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
351  * This allows applications to reconstruct the allowance for all accounts just
352  * by listening to said events. Other implementations of the EIP may not emit
353  * these events, as it isn't required by the specification.
354  *
355  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
356  * functions have been added to mitigate the well-known issues around setting
357  * allowances. See {IERC20-approve}.
358  */
359 contract ERC20 is Context, IERC20 {
360     using SafeMath for uint256;
361 
362     mapping (address => uint256) private _balances;
363 
364     mapping (address => mapping (address => uint256)) private _allowances;
365 
366     uint256 private _totalSupply;
367 
368     /**
369      * @dev See {IERC20-totalSupply}.
370      */
371     function totalSupply() public view returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See {IERC20-balanceOf}.
377      */
378     function balanceOf(address account) public view returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See {IERC20-transfer}.
384      *
385      * Requirements:
386      *
387      * - `recipient` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address recipient, uint256 amount) public returns (bool) {
391         _transfer(_msgSender(), recipient, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-allowance}.
397      */
398     function allowance(address owner, address spender) public view returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See {IERC20-approve}.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 amount) public returns (bool) {
410         _approve(_msgSender(), spender, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-transferFrom}.
416      *
417      * Emits an {Approval} event indicating the updated allowance. This is not
418      * required by the EIP. See the note at the beginning of {ERC20};
419      *
420      * Requirements:
421      * - `sender` and `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      * - the caller must have allowance for `sender`'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically increases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to {approve} that can be used as a mitigation for
453      * problems described in {IERC20-approve}.
454      *
455      * Emits an {Approval} event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
465         return true;
466     }
467 
468     /**
469      * @dev Moves tokens `amount` from `sender` to `recipient`.
470      *
471      * This is internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(address sender, address recipient, uint256 amount) internal {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
487         _balances[recipient] = _balances[recipient].add(amount);
488         emit Transfer(sender, recipient, amount);
489     }
490 
491     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492      * the total supply.
493      *
494      * Emits a {Transfer} event with `from` set to the zero address.
495      *
496      * Requirements
497      *
498      * - `to` cannot be the zero address.
499      */
500     function _mint(address account, uint256 amount) internal {
501         require(account != address(0), "ERC20: mint to the zero address");
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
523         _totalSupply = _totalSupply.sub(amount);
524         emit Transfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
529      *
530      * This is internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(address owner, address spender, uint256 amount) internal {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
550      * from the caller's allowance.
551      *
552      * See {_burn} and {_approve}.
553      */
554     function _burnFrom(address account, uint256 amount) internal {
555         _burn(account, amount);
556         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
557     }
558 }
559 
560 /**
561  * @dev Optional functions from the ERC20 standard.
562  */
563 contract ERC20Detailed is IERC20 {
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567 
568     /**
569      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
570      * these values are immutable: they can only be set once during
571      * construction.
572      */
573     constructor (string memory name, string memory symbol, uint8 decimals) public {
574         _name = name;
575         _symbol = symbol;
576         _decimals = decimals;
577     }
578 
579     /**
580      * @dev Returns the name of the token.
581      */
582     function name() public view returns (string memory) {
583         return _name;
584     }
585 
586     /**
587      * @dev Returns the symbol of the token, usually a shorter version of the
588      * name.
589      */
590     function symbol() public view returns (string memory) {
591         return _symbol;
592     }
593 
594     /**
595      * @dev Returns the number of decimals used to get its user representation.
596      * For example, if `decimals` equals `2`, a balance of `505` tokens should
597      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
598      *
599      * Tokens usually opt for a value of 18, imitating the relationship between
600      * Ether and Wei.
601      *
602      * NOTE: This information is only used for _display_ purposes: it in
603      * no way affects any of the arithmetic of the contract, including
604      * {IERC20-balanceOf} and {IERC20-transfer}.
605      */
606     function decimals() public view returns (uint8) {
607         return _decimals;
608     }
609 }
610 
611 /**
612  * @dev Extension of {ERC20} that allows token holders to destroy both their own
613  * tokens and those that they have an allowance for, in a way that can be
614  * recognized off-chain (via event analysis).
615  */
616 contract ERC20Burnable is Context, ERC20 {
617     /**
618      * @dev Destroys `amount` tokens from the caller.
619      *
620      * See {ERC20-_burn}.
621      */
622     function burn(uint256 amount) public {
623         _burn(_msgSender(), amount);
624     }
625 
626     /**
627      * @dev See {ERC20-_burnFrom}.
628      */
629     function burnFrom(address account, uint256 amount) public {
630         _burnFrom(account, amount);
631     }
632 }
633 
634 // Dummy contract only used to emit to end-user they are using wrong solc
635 contract solcChecker {
636 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
637 }
638 
639 contract OraclizeI {
640 
641     address public cbAddress;
642 
643     function setProofType(byte _proofType) external;
644     function setCustomGasPrice(uint _gasPrice) external;
645     function getPrice(string memory _datasource) public returns (uint _dsprice);
646     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
647     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
648     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
649     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
650     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
651     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
652     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
653     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
654 }
655 
656 contract OraclizeAddrResolverI {
657     function getAddress() public returns (address _address);
658 }
659 /*
660 Begin solidity-cborutils
661 https://github.com/smartcontractkit/solidity-cborutils
662 MIT License
663 Copyright (c) 2018 SmartContract ChainLink, Ltd.
664 Permission is hereby granted, free of charge, to any person obtaining a copy
665 of this software and associated documentation files (the "Software"), to deal
666 in the Software without restriction, including without limitation the rights
667 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
668 copies of the Software, and to permit persons to whom the Software is
669 furnished to do so, subject to the following conditions:
670 The above copyright notice and this permission notice shall be included in all
671 copies or substantial portions of the Software.
672 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
673 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
674 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
675 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
676 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
677 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
678 SOFTWARE.
679 */
680 library Buffer {
681 
682     struct buffer {
683         bytes buf;
684         uint capacity;
685     }
686 
687     function init(buffer memory _buf, uint _capacity) internal pure {
688         uint capacity = _capacity;
689         if (capacity % 32 != 0) {
690             capacity += 32 - (capacity % 32);
691         }
692         _buf.capacity = capacity; // Allocate space for the buffer data
693         assembly {
694             let ptr := mload(0x40)
695             mstore(_buf, ptr)
696             mstore(ptr, 0)
697             mstore(0x40, add(ptr, capacity))
698         }
699     }
700 
701     function resize(buffer memory _buf, uint _capacity) private pure {
702         bytes memory oldbuf = _buf.buf;
703         init(_buf, _capacity);
704         append(_buf, oldbuf);
705     }
706 
707     function max(uint _a, uint _b) private pure returns (uint _max) {
708         if (_a > _b) {
709             return _a;
710         }
711         return _b;
712     }
713     /**
714       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
715       *      would exceed the capacity of the buffer.
716       * @param _buf The buffer to append to.
717       * @param _data The data to append.
718       * @return The original buffer.
719       *
720       */
721     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
722         if (_data.length + _buf.buf.length > _buf.capacity) {
723             resize(_buf, max(_buf.capacity, _data.length) * 2);
724         }
725         uint dest;
726         uint src;
727         uint len = _data.length;
728         assembly {
729             let bufptr := mload(_buf) // Memory address of the buffer data
730             let buflen := mload(bufptr) // Length of existing buffer data
731             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
732             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
733             src := add(_data, 32)
734         }
735         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
736             assembly {
737                 mstore(dest, mload(src))
738             }
739             dest += 32;
740             src += 32;
741         }
742         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
743         assembly {
744             let srcpart := and(mload(src), not(mask))
745             let destpart := and(mload(dest), mask)
746             mstore(dest, or(destpart, srcpart))
747         }
748         return _buf;
749     }
750     /**
751       *
752       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
753       * exceed the capacity of the buffer.
754       * @param _buf The buffer to append to.
755       * @param _data The data to append.
756       * @return The original buffer.
757       *
758       */
759     function append(buffer memory _buf, uint8 _data) internal pure {
760         if (_buf.buf.length + 1 > _buf.capacity) {
761             resize(_buf, _buf.capacity * 2);
762         }
763         assembly {
764             let bufptr := mload(_buf) // Memory address of the buffer data
765             let buflen := mload(bufptr) // Length of existing buffer data
766             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
767             mstore8(dest, _data)
768             mstore(bufptr, add(buflen, 1)) // Update buffer length
769         }
770     }
771     /**
772       *
773       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
774       * exceed the capacity of the buffer.
775       * @param _buf The buffer to append to.
776       * @param _data The data to append.
777       * @return The original buffer.
778       *
779       */
780     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
781         if (_len + _buf.buf.length > _buf.capacity) {
782             resize(_buf, max(_buf.capacity, _len) * 2);
783         }
784         uint mask = 256 ** _len - 1;
785         assembly {
786             let bufptr := mload(_buf) // Memory address of the buffer data
787             let buflen := mload(bufptr) // Length of existing buffer data
788             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
789             mstore(dest, or(and(mload(dest), not(mask)), _data))
790             mstore(bufptr, add(buflen, _len)) // Update buffer length
791         }
792         return _buf;
793     }
794 }
795 
796 library CBOR {
797 
798     using Buffer for Buffer.buffer;
799 
800     uint8 private constant MAJOR_TYPE_INT = 0;
801     uint8 private constant MAJOR_TYPE_MAP = 5;
802     uint8 private constant MAJOR_TYPE_BYTES = 2;
803     uint8 private constant MAJOR_TYPE_ARRAY = 4;
804     uint8 private constant MAJOR_TYPE_STRING = 3;
805     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
806     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
807 
808     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
809         if (_value <= 23) {
810             _buf.append(uint8((_major << 5) | _value));
811         } else if (_value <= 0xFF) {
812             _buf.append(uint8((_major << 5) | 24));
813             _buf.appendInt(_value, 1);
814         } else if (_value <= 0xFFFF) {
815             _buf.append(uint8((_major << 5) | 25));
816             _buf.appendInt(_value, 2);
817         } else if (_value <= 0xFFFFFFFF) {
818             _buf.append(uint8((_major << 5) | 26));
819             _buf.appendInt(_value, 4);
820         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
821             _buf.append(uint8((_major << 5) | 27));
822             _buf.appendInt(_value, 8);
823         }
824     }
825 
826     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
827         _buf.append(uint8((_major << 5) | 31));
828     }
829 
830     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
831         encodeType(_buf, MAJOR_TYPE_INT, _value);
832     }
833 
834     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
835         if (_value >= 0) {
836             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
837         } else {
838             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
839         }
840     }
841 
842     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
843         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
844         _buf.append(_value);
845     }
846 
847     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
848         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
849         _buf.append(bytes(_value));
850     }
851 
852     function startArray(Buffer.buffer memory _buf) internal pure {
853         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
854     }
855 
856     function startMap(Buffer.buffer memory _buf) internal pure {
857         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
858     }
859 
860     function endSequence(Buffer.buffer memory _buf) internal pure {
861         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
862     }
863 }
864 /*
865 End solidity-cborutils
866 */
867 contract usingOraclize {
868 
869     using CBOR for Buffer.buffer;
870 
871     OraclizeI oraclize;
872     OraclizeAddrResolverI OAR;
873 
874     uint constant day = 60 * 60 * 24;
875     uint constant week = 60 * 60 * 24 * 7;
876     uint constant month = 60 * 60 * 24 * 30;
877 
878     byte constant proofType_NONE = 0x00;
879     byte constant proofType_Ledger = 0x30;
880     byte constant proofType_Native = 0xF0;
881     byte constant proofStorage_IPFS = 0x01;
882     byte constant proofType_Android = 0x40;
883     byte constant proofType_TLSNotary = 0x10;
884 
885     string oraclize_network_name;
886     uint8 constant networkID_auto = 0;
887     uint8 constant networkID_morden = 2;
888     uint8 constant networkID_mainnet = 1;
889     uint8 constant networkID_testnet = 2;
890     uint8 constant networkID_consensys = 161;
891 
892     mapping(bytes32 => bytes32) oraclize_randomDS_args;
893     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
894 
895     modifier oraclizeAPI {
896         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
897             oraclize_setNetwork(networkID_auto);
898         }
899         if (address(oraclize) != OAR.getAddress()) {
900             oraclize = OraclizeI(OAR.getAddress());
901         }
902         _;
903     }
904 
905     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
906         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
907         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
908         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
909         require(proofVerified);
910         _;
911     }
912 
913     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
914       _networkID; // NOTE: Silence the warning and remain backwards compatible
915       return oraclize_setNetwork();
916     }
917 
918     function oraclize_setNetworkName(string memory _network_name) internal {
919         oraclize_network_name = _network_name;
920     }
921 
922     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
923         return oraclize_network_name;
924     }
925 
926     function oraclize_setNetwork() internal returns (bool _networkSet) {
927         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
928             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
929             oraclize_setNetworkName("eth_mainnet");
930             return true;
931         }
932         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
933             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
934             oraclize_setNetworkName("eth_ropsten3");
935             return true;
936         }
937         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
938             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
939             oraclize_setNetworkName("eth_kovan");
940             return true;
941         }
942         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
943             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
944             oraclize_setNetworkName("eth_rinkeby");
945             return true;
946         }
947         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
948             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
949             oraclize_setNetworkName("eth_goerli");
950             return true;
951         }
952         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
953             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
954             return true;
955         }
956         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
957             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
958             return true;
959         }
960         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
961             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
962             return true;
963         }
964         return false;
965     }
966     /**
967      * @dev The following `__callback` functions are just placeholders ideally
968      *      meant to be defined in child contract when proofs are used.
969      *      The function bodies simply silence compiler warnings.
970      */
971     function __callback(bytes32 _myid, string memory _result) public {
972         __callback(_myid, _result, new bytes(0));
973     }
974 
975     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
976       _myid; _result; _proof;
977       oraclize_randomDS_args[bytes32(0)] = bytes32(0);
978     }
979 
980     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
981         return oraclize.getPrice(_datasource);
982     }
983 
984     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
985         return oraclize.getPrice(_datasource, _gasLimit);
986     }
987 
988     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
989         uint price = oraclize.getPrice(_datasource);
990         if (price > 1 ether + tx.gasprice * 200000) {
991             return 0; // Unexpectedly high price
992         }
993         return oraclize.query.value(price)(0, _datasource, _arg);
994     }
995 
996     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
997         uint price = oraclize.getPrice(_datasource);
998         if (price > 1 ether + tx.gasprice * 200000) {
999             return 0; // Unexpectedly high price
1000         }
1001         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
1002     }
1003 
1004     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1005         uint price = oraclize.getPrice(_datasource,_gasLimit);
1006         if (price > 1 ether + tx.gasprice * _gasLimit) {
1007             return 0; // Unexpectedly high price
1008         }
1009         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
1010     }
1011 
1012     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1013         uint price = oraclize.getPrice(_datasource, _gasLimit);
1014         if (price > 1 ether + tx.gasprice * _gasLimit) {
1015            return 0; // Unexpectedly high price
1016         }
1017         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
1018     }
1019 
1020     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
1021         uint price = oraclize.getPrice(_datasource);
1022         if (price > 1 ether + tx.gasprice * 200000) {
1023             return 0; // Unexpectedly high price
1024         }
1025         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
1026     }
1027 
1028     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
1029         uint price = oraclize.getPrice(_datasource);
1030         if (price > 1 ether + tx.gasprice * 200000) {
1031             return 0; // Unexpectedly high price
1032         }
1033         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
1034     }
1035 
1036     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1037         uint price = oraclize.getPrice(_datasource, _gasLimit);
1038         if (price > 1 ether + tx.gasprice * _gasLimit) {
1039             return 0; // Unexpectedly high price
1040         }
1041         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
1042     }
1043 
1044     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1045         uint price = oraclize.getPrice(_datasource, _gasLimit);
1046         if (price > 1 ether + tx.gasprice * _gasLimit) {
1047             return 0; // Unexpectedly high price
1048         }
1049         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
1050     }
1051 
1052     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1053         uint price = oraclize.getPrice(_datasource);
1054         if (price > 1 ether + tx.gasprice * 200000) {
1055             return 0; // Unexpectedly high price
1056         }
1057         bytes memory args = stra2cbor(_argN);
1058         return oraclize.queryN.value(price)(0, _datasource, args);
1059     }
1060 
1061     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1062         uint price = oraclize.getPrice(_datasource);
1063         if (price > 1 ether + tx.gasprice * 200000) {
1064             return 0; // Unexpectedly high price
1065         }
1066         bytes memory args = stra2cbor(_argN);
1067         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1068     }
1069 
1070     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1071         uint price = oraclize.getPrice(_datasource, _gasLimit);
1072         if (price > 1 ether + tx.gasprice * _gasLimit) {
1073             return 0; // Unexpectedly high price
1074         }
1075         bytes memory args = stra2cbor(_argN);
1076         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1077     }
1078 
1079     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1080         uint price = oraclize.getPrice(_datasource, _gasLimit);
1081         if (price > 1 ether + tx.gasprice * _gasLimit) {
1082             return 0; // Unexpectedly high price
1083         }
1084         bytes memory args = stra2cbor(_argN);
1085         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1086     }
1087 
1088     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1089         string[] memory dynargs = new string[](1);
1090         dynargs[0] = _args[0];
1091         return oraclize_query(_datasource, dynargs);
1092     }
1093 
1094     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1095         string[] memory dynargs = new string[](1);
1096         dynargs[0] = _args[0];
1097         return oraclize_query(_timestamp, _datasource, dynargs);
1098     }
1099 
1100     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1101         string[] memory dynargs = new string[](1);
1102         dynargs[0] = _args[0];
1103         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1104     }
1105 
1106     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1107         string[] memory dynargs = new string[](1);
1108         dynargs[0] = _args[0];
1109         return oraclize_query(_datasource, dynargs, _gasLimit);
1110     }
1111 
1112     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1113         string[] memory dynargs = new string[](2);
1114         dynargs[0] = _args[0];
1115         dynargs[1] = _args[1];
1116         return oraclize_query(_datasource, dynargs);
1117     }
1118 
1119     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1120         string[] memory dynargs = new string[](2);
1121         dynargs[0] = _args[0];
1122         dynargs[1] = _args[1];
1123         return oraclize_query(_timestamp, _datasource, dynargs);
1124     }
1125 
1126     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1127         string[] memory dynargs = new string[](2);
1128         dynargs[0] = _args[0];
1129         dynargs[1] = _args[1];
1130         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1131     }
1132 
1133     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1134         string[] memory dynargs = new string[](2);
1135         dynargs[0] = _args[0];
1136         dynargs[1] = _args[1];
1137         return oraclize_query(_datasource, dynargs, _gasLimit);
1138     }
1139 
1140     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1141         string[] memory dynargs = new string[](3);
1142         dynargs[0] = _args[0];
1143         dynargs[1] = _args[1];
1144         dynargs[2] = _args[2];
1145         return oraclize_query(_datasource, dynargs);
1146     }
1147 
1148     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1149         string[] memory dynargs = new string[](3);
1150         dynargs[0] = _args[0];
1151         dynargs[1] = _args[1];
1152         dynargs[2] = _args[2];
1153         return oraclize_query(_timestamp, _datasource, dynargs);
1154     }
1155 
1156     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1157         string[] memory dynargs = new string[](3);
1158         dynargs[0] = _args[0];
1159         dynargs[1] = _args[1];
1160         dynargs[2] = _args[2];
1161         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1162     }
1163 
1164     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1165         string[] memory dynargs = new string[](3);
1166         dynargs[0] = _args[0];
1167         dynargs[1] = _args[1];
1168         dynargs[2] = _args[2];
1169         return oraclize_query(_datasource, dynargs, _gasLimit);
1170     }
1171 
1172     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1173         string[] memory dynargs = new string[](4);
1174         dynargs[0] = _args[0];
1175         dynargs[1] = _args[1];
1176         dynargs[2] = _args[2];
1177         dynargs[3] = _args[3];
1178         return oraclize_query(_datasource, dynargs);
1179     }
1180 
1181     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1182         string[] memory dynargs = new string[](4);
1183         dynargs[0] = _args[0];
1184         dynargs[1] = _args[1];
1185         dynargs[2] = _args[2];
1186         dynargs[3] = _args[3];
1187         return oraclize_query(_timestamp, _datasource, dynargs);
1188     }
1189 
1190     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1191         string[] memory dynargs = new string[](4);
1192         dynargs[0] = _args[0];
1193         dynargs[1] = _args[1];
1194         dynargs[2] = _args[2];
1195         dynargs[3] = _args[3];
1196         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1197     }
1198 
1199     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1200         string[] memory dynargs = new string[](4);
1201         dynargs[0] = _args[0];
1202         dynargs[1] = _args[1];
1203         dynargs[2] = _args[2];
1204         dynargs[3] = _args[3];
1205         return oraclize_query(_datasource, dynargs, _gasLimit);
1206     }
1207 
1208     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1209         string[] memory dynargs = new string[](5);
1210         dynargs[0] = _args[0];
1211         dynargs[1] = _args[1];
1212         dynargs[2] = _args[2];
1213         dynargs[3] = _args[3];
1214         dynargs[4] = _args[4];
1215         return oraclize_query(_datasource, dynargs);
1216     }
1217 
1218     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1219         string[] memory dynargs = new string[](5);
1220         dynargs[0] = _args[0];
1221         dynargs[1] = _args[1];
1222         dynargs[2] = _args[2];
1223         dynargs[3] = _args[3];
1224         dynargs[4] = _args[4];
1225         return oraclize_query(_timestamp, _datasource, dynargs);
1226     }
1227 
1228     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1229         string[] memory dynargs = new string[](5);
1230         dynargs[0] = _args[0];
1231         dynargs[1] = _args[1];
1232         dynargs[2] = _args[2];
1233         dynargs[3] = _args[3];
1234         dynargs[4] = _args[4];
1235         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1236     }
1237 
1238     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1239         string[] memory dynargs = new string[](5);
1240         dynargs[0] = _args[0];
1241         dynargs[1] = _args[1];
1242         dynargs[2] = _args[2];
1243         dynargs[3] = _args[3];
1244         dynargs[4] = _args[4];
1245         return oraclize_query(_datasource, dynargs, _gasLimit);
1246     }
1247 
1248     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1249         uint price = oraclize.getPrice(_datasource);
1250         if (price > 1 ether + tx.gasprice * 200000) {
1251             return 0; // Unexpectedly high price
1252         }
1253         bytes memory args = ba2cbor(_argN);
1254         return oraclize.queryN.value(price)(0, _datasource, args);
1255     }
1256 
1257     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1258         uint price = oraclize.getPrice(_datasource);
1259         if (price > 1 ether + tx.gasprice * 200000) {
1260             return 0; // Unexpectedly high price
1261         }
1262         bytes memory args = ba2cbor(_argN);
1263         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1264     }
1265 
1266     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1267         uint price = oraclize.getPrice(_datasource, _gasLimit);
1268         if (price > 1 ether + tx.gasprice * _gasLimit) {
1269             return 0; // Unexpectedly high price
1270         }
1271         bytes memory args = ba2cbor(_argN);
1272         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1273     }
1274 
1275     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1276         uint price = oraclize.getPrice(_datasource, _gasLimit);
1277         if (price > 1 ether + tx.gasprice * _gasLimit) {
1278             return 0; // Unexpectedly high price
1279         }
1280         bytes memory args = ba2cbor(_argN);
1281         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1282     }
1283 
1284     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1285         bytes[] memory dynargs = new bytes[](1);
1286         dynargs[0] = _args[0];
1287         return oraclize_query(_datasource, dynargs);
1288     }
1289 
1290     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1291         bytes[] memory dynargs = new bytes[](1);
1292         dynargs[0] = _args[0];
1293         return oraclize_query(_timestamp, _datasource, dynargs);
1294     }
1295 
1296     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1297         bytes[] memory dynargs = new bytes[](1);
1298         dynargs[0] = _args[0];
1299         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1300     }
1301 
1302     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1303         bytes[] memory dynargs = new bytes[](1);
1304         dynargs[0] = _args[0];
1305         return oraclize_query(_datasource, dynargs, _gasLimit);
1306     }
1307 
1308     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1309         bytes[] memory dynargs = new bytes[](2);
1310         dynargs[0] = _args[0];
1311         dynargs[1] = _args[1];
1312         return oraclize_query(_datasource, dynargs);
1313     }
1314 
1315     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1316         bytes[] memory dynargs = new bytes[](2);
1317         dynargs[0] = _args[0];
1318         dynargs[1] = _args[1];
1319         return oraclize_query(_timestamp, _datasource, dynargs);
1320     }
1321 
1322     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1323         bytes[] memory dynargs = new bytes[](2);
1324         dynargs[0] = _args[0];
1325         dynargs[1] = _args[1];
1326         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1327     }
1328 
1329     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1330         bytes[] memory dynargs = new bytes[](2);
1331         dynargs[0] = _args[0];
1332         dynargs[1] = _args[1];
1333         return oraclize_query(_datasource, dynargs, _gasLimit);
1334     }
1335 
1336     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1337         bytes[] memory dynargs = new bytes[](3);
1338         dynargs[0] = _args[0];
1339         dynargs[1] = _args[1];
1340         dynargs[2] = _args[2];
1341         return oraclize_query(_datasource, dynargs);
1342     }
1343 
1344     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1345         bytes[] memory dynargs = new bytes[](3);
1346         dynargs[0] = _args[0];
1347         dynargs[1] = _args[1];
1348         dynargs[2] = _args[2];
1349         return oraclize_query(_timestamp, _datasource, dynargs);
1350     }
1351 
1352     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1353         bytes[] memory dynargs = new bytes[](3);
1354         dynargs[0] = _args[0];
1355         dynargs[1] = _args[1];
1356         dynargs[2] = _args[2];
1357         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1358     }
1359 
1360     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1361         bytes[] memory dynargs = new bytes[](3);
1362         dynargs[0] = _args[0];
1363         dynargs[1] = _args[1];
1364         dynargs[2] = _args[2];
1365         return oraclize_query(_datasource, dynargs, _gasLimit);
1366     }
1367 
1368     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1369         bytes[] memory dynargs = new bytes[](4);
1370         dynargs[0] = _args[0];
1371         dynargs[1] = _args[1];
1372         dynargs[2] = _args[2];
1373         dynargs[3] = _args[3];
1374         return oraclize_query(_datasource, dynargs);
1375     }
1376 
1377     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1378         bytes[] memory dynargs = new bytes[](4);
1379         dynargs[0] = _args[0];
1380         dynargs[1] = _args[1];
1381         dynargs[2] = _args[2];
1382         dynargs[3] = _args[3];
1383         return oraclize_query(_timestamp, _datasource, dynargs);
1384     }
1385 
1386     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1387         bytes[] memory dynargs = new bytes[](4);
1388         dynargs[0] = _args[0];
1389         dynargs[1] = _args[1];
1390         dynargs[2] = _args[2];
1391         dynargs[3] = _args[3];
1392         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1393     }
1394 
1395     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1396         bytes[] memory dynargs = new bytes[](4);
1397         dynargs[0] = _args[0];
1398         dynargs[1] = _args[1];
1399         dynargs[2] = _args[2];
1400         dynargs[3] = _args[3];
1401         return oraclize_query(_datasource, dynargs, _gasLimit);
1402     }
1403 
1404     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1405         bytes[] memory dynargs = new bytes[](5);
1406         dynargs[0] = _args[0];
1407         dynargs[1] = _args[1];
1408         dynargs[2] = _args[2];
1409         dynargs[3] = _args[3];
1410         dynargs[4] = _args[4];
1411         return oraclize_query(_datasource, dynargs);
1412     }
1413 
1414     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1415         bytes[] memory dynargs = new bytes[](5);
1416         dynargs[0] = _args[0];
1417         dynargs[1] = _args[1];
1418         dynargs[2] = _args[2];
1419         dynargs[3] = _args[3];
1420         dynargs[4] = _args[4];
1421         return oraclize_query(_timestamp, _datasource, dynargs);
1422     }
1423 
1424     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1425         bytes[] memory dynargs = new bytes[](5);
1426         dynargs[0] = _args[0];
1427         dynargs[1] = _args[1];
1428         dynargs[2] = _args[2];
1429         dynargs[3] = _args[3];
1430         dynargs[4] = _args[4];
1431         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1432     }
1433 
1434     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1435         bytes[] memory dynargs = new bytes[](5);
1436         dynargs[0] = _args[0];
1437         dynargs[1] = _args[1];
1438         dynargs[2] = _args[2];
1439         dynargs[3] = _args[3];
1440         dynargs[4] = _args[4];
1441         return oraclize_query(_datasource, dynargs, _gasLimit);
1442     }
1443 
1444     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
1445         return oraclize.setProofType(_proofP);
1446     }
1447 
1448 
1449     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
1450         return oraclize.cbAddress();
1451     }
1452 
1453     function getCodeSize(address _addr) view internal returns (uint _size) {
1454         assembly {
1455             _size := extcodesize(_addr)
1456         }
1457     }
1458 
1459     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
1460         return oraclize.setCustomGasPrice(_gasPrice);
1461     }
1462 
1463     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
1464         return oraclize.randomDS_getSessionPubKeyHash();
1465     }
1466 
1467     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
1468         bytes memory tmp = bytes(_a);
1469         uint160 iaddr = 0;
1470         uint160 b1;
1471         uint160 b2;
1472         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
1473             iaddr *= 256;
1474             b1 = uint160(uint8(tmp[i]));
1475             b2 = uint160(uint8(tmp[i + 1]));
1476             if ((b1 >= 97) && (b1 <= 102)) {
1477                 b1 -= 87;
1478             } else if ((b1 >= 65) && (b1 <= 70)) {
1479                 b1 -= 55;
1480             } else if ((b1 >= 48) && (b1 <= 57)) {
1481                 b1 -= 48;
1482             }
1483             if ((b2 >= 97) && (b2 <= 102)) {
1484                 b2 -= 87;
1485             } else if ((b2 >= 65) && (b2 <= 70)) {
1486                 b2 -= 55;
1487             } else if ((b2 >= 48) && (b2 <= 57)) {
1488                 b2 -= 48;
1489             }
1490             iaddr += (b1 * 16 + b2);
1491         }
1492         return address(iaddr);
1493     }
1494 
1495     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1496         bytes memory a = bytes(_a);
1497         bytes memory b = bytes(_b);
1498         uint minLength = a.length;
1499         if (b.length < minLength) {
1500             minLength = b.length;
1501         }
1502         for (uint i = 0; i < minLength; i ++) {
1503             if (a[i] < b[i]) {
1504                 return -1;
1505             } else if (a[i] > b[i]) {
1506                 return 1;
1507             }
1508         }
1509         if (a.length < b.length) {
1510             return -1;
1511         } else if (a.length > b.length) {
1512             return 1;
1513         } else {
1514             return 0;
1515         }
1516     }
1517 
1518     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1519         bytes memory h = bytes(_haystack);
1520         bytes memory n = bytes(_needle);
1521         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1522             return -1;
1523         } else if (h.length > (2 ** 128 - 1)) {
1524             return -1;
1525         } else {
1526             uint subindex = 0;
1527             for (uint i = 0; i < h.length; i++) {
1528                 if (h[i] == n[0]) {
1529                     subindex = 1;
1530                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1531                         subindex++;
1532                     }
1533                     if (subindex == n.length) {
1534                         return int(i);
1535                     }
1536                 }
1537             }
1538             return -1;
1539         }
1540     }
1541 
1542     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1543         return strConcat(_a, _b, "", "", "");
1544     }
1545 
1546     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1547         return strConcat(_a, _b, _c, "", "");
1548     }
1549 
1550     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1551         return strConcat(_a, _b, _c, _d, "");
1552     }
1553 
1554     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1555         bytes memory _ba = bytes(_a);
1556         bytes memory _bb = bytes(_b);
1557         bytes memory _bc = bytes(_c);
1558         bytes memory _bd = bytes(_d);
1559         bytes memory _be = bytes(_e);
1560         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1561         bytes memory babcde = bytes(abcde);
1562         uint k = 0;
1563         uint i = 0;
1564         for (i = 0; i < _ba.length; i++) {
1565             babcde[k++] = _ba[i];
1566         }
1567         for (i = 0; i < _bb.length; i++) {
1568             babcde[k++] = _bb[i];
1569         }
1570         for (i = 0; i < _bc.length; i++) {
1571             babcde[k++] = _bc[i];
1572         }
1573         for (i = 0; i < _bd.length; i++) {
1574             babcde[k++] = _bd[i];
1575         }
1576         for (i = 0; i < _be.length; i++) {
1577             babcde[k++] = _be[i];
1578         }
1579         return string(babcde);
1580     }
1581 
1582     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1583         return safeParseInt(_a, 0);
1584     }
1585 
1586     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1587         bytes memory bresult = bytes(_a);
1588         uint mint = 0;
1589         bool decimals = false;
1590         for (uint i = 0; i < bresult.length; i++) {
1591             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1592                 if (decimals) {
1593                    if (_b == 0) break;
1594                     else _b--;
1595                 }
1596                 mint *= 10;
1597                 mint += uint(uint8(bresult[i])) - 48;
1598             } else if (uint(uint8(bresult[i])) == 46) {
1599                 require(!decimals, 'More than one decimal encountered in string!');
1600                 decimals = true;
1601             } else {
1602                 revert("Non-numeral character encountered in string!");
1603             }
1604         }
1605         if (_b > 0) {
1606             mint *= 10 ** _b;
1607         }
1608         return mint;
1609     }
1610 
1611     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1612         return parseInt(_a, 0);
1613     }
1614 
1615     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1616         bytes memory bresult = bytes(_a);
1617         uint mint = 0;
1618         bool decimals = false;
1619         for (uint i = 0; i < bresult.length; i++) {
1620             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1621                 if (decimals) {
1622                    if (_b == 0) {
1623                        break;
1624                    } else {
1625                        _b--;
1626                    }
1627                 }
1628                 mint *= 10;
1629                 mint += uint(uint8(bresult[i])) - 48;
1630             } else if (uint(uint8(bresult[i])) == 46) {
1631                 decimals = true;
1632             }
1633         }
1634         if (_b > 0) {
1635             mint *= 10 ** _b;
1636         }
1637         return mint;
1638     }
1639 
1640     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1641         if (_i == 0) {
1642             return "0";
1643         }
1644         uint j = _i;
1645         uint len;
1646         while (j != 0) {
1647             len++;
1648             j /= 10;
1649         }
1650         bytes memory bstr = new bytes(len);
1651         uint k = len - 1;
1652         while (_i != 0) {
1653             bstr[k--] = byte(uint8(48 + _i % 10));
1654             _i /= 10;
1655         }
1656         return string(bstr);
1657     }
1658 
1659     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1660         safeMemoryCleaner();
1661         Buffer.buffer memory buf;
1662         Buffer.init(buf, 1024);
1663         buf.startArray();
1664         for (uint i = 0; i < _arr.length; i++) {
1665             buf.encodeString(_arr[i]);
1666         }
1667         buf.endSequence();
1668         return buf.buf;
1669     }
1670 
1671     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1672         safeMemoryCleaner();
1673         Buffer.buffer memory buf;
1674         Buffer.init(buf, 1024);
1675         buf.startArray();
1676         for (uint i = 0; i < _arr.length; i++) {
1677             buf.encodeBytes(_arr[i]);
1678         }
1679         buf.endSequence();
1680         return buf.buf;
1681     }
1682 
1683     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1684         require((_nbytes > 0) && (_nbytes <= 32));
1685         _delay *= 10; // Convert from seconds to ledger timer ticks
1686         bytes memory nbytes = new bytes(1);
1687         nbytes[0] = byte(uint8(_nbytes));
1688         bytes memory unonce = new bytes(32);
1689         bytes memory sessionKeyHash = new bytes(32);
1690         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1691         assembly {
1692             mstore(unonce, 0x20)
1693             /*
1694              The following variables can be relaxed.
1695              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1696              for an idea on how to override and replace commit hash variables.
1697             */
1698             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1699             mstore(sessionKeyHash, 0x20)
1700             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1701         }
1702         bytes memory delay = new bytes(32);
1703         assembly {
1704             mstore(add(delay, 0x20), _delay)
1705         }
1706         bytes memory delay_bytes8 = new bytes(8);
1707         copyBytes(delay, 24, 8, delay_bytes8, 0);
1708         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1709         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1710         bytes memory delay_bytes8_left = new bytes(8);
1711         assembly {
1712             let x := mload(add(delay_bytes8, 0x20))
1713             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1714             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1715             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1716             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1717             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1718             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1719             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1720             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1721         }
1722         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1723         return queryId;
1724     }
1725 
1726     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1727         oraclize_randomDS_args[_queryId] = _commitment;
1728     }
1729 
1730     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1731         bool sigok;
1732         address signer;
1733         bytes32 sigr;
1734         bytes32 sigs;
1735         bytes memory sigr_ = new bytes(32);
1736         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1737         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1738         bytes memory sigs_ = new bytes(32);
1739         offset += 32 + 2;
1740         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1741         assembly {
1742             sigr := mload(add(sigr_, 32))
1743             sigs := mload(add(sigs_, 32))
1744         }
1745         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1746         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1747             return true;
1748         } else {
1749             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1750             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1751         }
1752     }
1753 
1754     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1755         bool sigok;
1756         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1757         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1758         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1759         bytes memory appkey1_pubkey = new bytes(64);
1760         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1761         bytes memory tosign2 = new bytes(1 + 65 + 32);
1762         tosign2[0] = byte(uint8(1)); //role
1763         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1764         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1765         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1766         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1767         if (!sigok) {
1768             return false;
1769         }
1770         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1771         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1772         bytes memory tosign3 = new bytes(1 + 65);
1773         tosign3[0] = 0xFE;
1774         copyBytes(_proof, 3, 65, tosign3, 1);
1775         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1776         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1777         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1778         return sigok;
1779     }
1780 
1781     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1782         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1783         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1784             return 1;
1785         }
1786         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1787         if (!proofVerified) {
1788             return 2;
1789         }
1790         return 0;
1791     }
1792 
1793     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1794         bool match_ = true;
1795         require(_prefix.length == _nRandomBytes);
1796         for (uint256 i = 0; i< _nRandomBytes; i++) {
1797             if (_content[i] != _prefix[i]) {
1798                 match_ = false;
1799             }
1800         }
1801         return match_;
1802     }
1803 
1804     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1805         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1806         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1807         bytes memory keyhash = new bytes(32);
1808         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1809         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1810             return false;
1811         }
1812         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1813         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1814         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1815         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1816             return false;
1817         }
1818         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1819         // This is to verify that the computed args match with the ones specified in the query.
1820         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1821         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1822         bytes memory sessionPubkey = new bytes(64);
1823         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1824         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1825         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1826         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1827             delete oraclize_randomDS_args[_queryId];
1828         } else return false;
1829         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1830         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1831         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1832         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1833             return false;
1834         }
1835         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1836         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1837             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1838         }
1839         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1840     }
1841     /*
1842      The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
1843     */
1844     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1845         uint minLength = _length + _toOffset;
1846         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1847         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1848         uint j = 32 + _toOffset;
1849         while (i < (32 + _fromOffset + _length)) {
1850             assembly {
1851                 let tmp := mload(add(_from, i))
1852                 mstore(add(_to, j), tmp)
1853             }
1854             i += 32;
1855             j += 32;
1856         }
1857         return _to;
1858     }
1859     /*
1860      The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
1861      Duplicate Solidity's ecrecover, but catching the CALL return value
1862     */
1863     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1864         /*
1865          We do our own memory management here. Solidity uses memory offset
1866          0x40 to store the current end of memory. We write past it (as
1867          writes are memory extensions), but don't update the offset so
1868          Solidity will reuse it. The memory used here is only needed for
1869          this context.
1870          FIXME: inline assembly can't access return values
1871         */
1872         bool ret;
1873         address addr;
1874         assembly {
1875             let size := mload(0x40)
1876             mstore(size, _hash)
1877             mstore(add(size, 32), _v)
1878             mstore(add(size, 64), _r)
1879             mstore(add(size, 96), _s)
1880             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1881             addr := mload(size)
1882         }
1883         return (ret, addr);
1884     }
1885     /*
1886      The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
1887     */
1888     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1889         bytes32 r;
1890         bytes32 s;
1891         uint8 v;
1892         if (_sig.length != 65) {
1893             return (false, address(0));
1894         }
1895         /*
1896          The signature format is a compact form of:
1897            {bytes32 r}{bytes32 s}{uint8 v}
1898          Compact means, uint8 is not padded to 32 bytes.
1899         */
1900         assembly {
1901             r := mload(add(_sig, 32))
1902             s := mload(add(_sig, 64))
1903             /*
1904              Here we are loading the last 32 bytes. We exploit the fact that
1905              'mload' will pad with zeroes if we overread.
1906              There is no 'mload8' to do this, but that would be nicer.
1907             */
1908             v := byte(0, mload(add(_sig, 96)))
1909             /*
1910               Alternative solution:
1911               'byte' is not working due to the Solidity parser, so lets
1912               use the second best option, 'and'
1913               v := and(mload(add(_sig, 65)), 255)
1914             */
1915         }
1916         /*
1917          albeit non-transactional signatures are not specified by the YP, one would expect it
1918          to match the YP range of [27, 28]
1919          geth uses [0, 1] and some clients have followed. This might change, see:
1920          https://github.com/ethereum/go-ethereum/issues/2053
1921         */
1922         if (v < 27) {
1923             v += 27;
1924         }
1925         if (v != 27 && v != 28) {
1926             return (false, address(0));
1927         }
1928         return safer_ecrecover(_hash, v, r, s);
1929     }
1930 
1931     function safeMemoryCleaner() internal pure {
1932         assembly {
1933             let fmem := mload(0x40)
1934             codecopy(fmem, codesize, sub(msize, fmem))
1935         }
1936     }
1937 }
1938 
1939 contract OkschainBank is usingOraclize, Ownable {
1940     using SafeMath for uint256;
1941 
1942     uint256 constant public TIME_AFTER_12_MONTHS = 1613779200; // 20.02.2021
1943 
1944     OkschainToken public token;
1945 
1946     struct Queries {
1947         address payable seller;
1948         uint256 tokens;
1949         uint256 time;
1950     }
1951     mapping(bytes32 => Queries) public queries;
1952     mapping(address => uint256) public tokens_for_sell;
1953 
1954     function () external payable {}
1955 
1956     function sell_tokens() external {
1957         require(tokens_for_sell[msg.sender] > 0);
1958         uint256 tokens = tokens_for_sell[msg.sender];
1959         tokens_for_sell[msg.sender] = 0;
1960         get_ethusd_price(msg.sender, tokens);
1961     }
1962 
1963     function set_token_address(address token_address) external onlyOwner {
1964         token = OkschainToken(token_address);
1965     }
1966 
1967     function send_ether(
1968         address payable recipient,
1969         uint256 tokens
1970     )
1971         public
1972         returns (bool)
1973     {
1974         require(msg.sender == address(token));
1975         get_ethusd_price(recipient, tokens);
1976         return true;
1977     }
1978 
1979     function __callback(
1980         bytes32 _myid,
1981         string memory _result
1982     )
1983         public
1984     {
1985         require(msg.sender == oraclize_cbAddress());
1986         uint256 ethusd_price = string_to_uint(_result);
1987         uint256 eth_amount = get_eth_value(
1988             queries[_myid].tokens,
1989             ethusd_price,
1990             queries[_myid].time
1991         );
1992         if (eth_amount > 0 && address(this).balance >= eth_amount) {
1993             queries[_myid].seller.transfer(eth_amount);
1994         } else {
1995             tokens_for_sell[queries[_myid].seller] =
1996                 tokens_for_sell[queries[_myid].seller].add(
1997                     queries[_myid].tokens
1998                 );
1999         }
2000     }
2001 
2002     function get_ethusd_price
2003     (
2004         address payable recipient,
2005         uint256 tokens
2006     )
2007         private
2008         returns (bool)
2009     {
2010         require(address(this).balance > oraclize_getPrice("URL"));
2011         bytes32 query_id = oraclize_query(
2012             "URL",
2013             "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price"
2014         );
2015         queries[query_id].seller = recipient;
2016         queries[query_id].tokens = tokens;
2017         queries[query_id].time = block.timestamp;
2018     }
2019 
2020     function get_eth_value
2021     (
2022         uint256 tokens,
2023         uint256 ethusd_price,
2024         uint256 time
2025     )
2026         private
2027         pure
2028         returns (uint256 sell_eth_price)
2029     {
2030         uint256 usd_buy_amount = tokens.mul(3).div(10 ** 2);
2031         uint256 sell_usd_price;
2032         if (time < TIME_AFTER_12_MONTHS) {
2033             sell_usd_price = usd_buy_amount.div(2).add(usd_buy_amount);
2034         } else {
2035             sell_usd_price = usd_buy_amount.mul(2);
2036         }
2037         sell_eth_price = sell_usd_price.div(ethusd_price);
2038     }
2039 
2040     function string_to_uint
2041     (
2042         string memory s
2043     )
2044         private
2045         pure
2046         returns (uint256 result)
2047     {
2048         bytes memory b = bytes(s);
2049         uint256 i;
2050         result = 0;
2051         for (i = 0; i < b.length; i++) {
2052             uint256 c = uint256(uint8(b[i]));
2053             if (c >= 48 && c <= 57) {
2054                 result = result * 10 + (c - 48);
2055             } else {
2056                 break;
2057             }
2058         }
2059     }
2060 }
2061 
2062 contract OkschainToken is ERC20Burnable, ERC20Detailed, Ownable {
2063     using SafeMath for uint256;
2064 
2065     uint256 constant public UNLOCK_TIME = 1600560000; // 20.09.2020
2066     uint256 constant public STOP_ALL_LOCKS_TIME = 1764547200; // 01.12.2025
2067     uint256 constant public STOP_SELL_TIME = 1764547200; // 01.12.2025
2068 
2069     uint256 public team_tokens;
2070     uint256 public marketing_tokens;
2071     uint256 public reserve_tokens;
2072     uint256 public seed_tokens;
2073     uint256 public private_tokens;
2074     uint256 public public_tokens;
2075 
2076     address public tokens_holder;
2077     address public team;
2078     address public marketing;
2079     address public reserve;
2080 
2081     OkschainBank public bank;
2082 
2083     mapping(address => uint256) public seed_balance;
2084     mapping(address => uint256) public private_balance;
2085     mapping(address => uint256) public seed_bonus;
2086     mapping(address => uint256) public private_bonus;
2087     mapping(address => bool) public seed_locked;
2088     mapping(address => bool) public private_locked;
2089     mapping(address => uint256) public tokens_for_sell;
2090 
2091     modifier only_tokens_holder() {
2092         require(
2093             msg.sender == tokens_holder,
2094             "Sender must be a tokens holder"
2095         );
2096         _;
2097     }
2098 
2099     modifier after_unlock_time() {
2100         require(
2101             block.timestamp >= UNLOCK_TIME,
2102             "The time must be longer than the unlock time"
2103         );
2104         _;
2105     }
2106 
2107     constructor(
2108         address _tokens_holder,
2109         address _team,
2110         address _marketing,
2111         address _reserve
2112     )
2113         public
2114         ERC20Detailed("Okschain Token", "OKS", 18)
2115     {
2116         tokens_holder = _tokens_holder;
2117         seed_tokens = 5580000000 * (10 ** uint256(decimals()));
2118         private_tokens = 7130000000 * (10 ** uint256(decimals()));
2119         public_tokens = 1240000000 * (10 ** uint256(decimals()));
2120         _mint(tokens_holder, seed_tokens + private_tokens + public_tokens);
2121         team = _team;
2122         team_tokens = 1240000000 * (10 ** uint256(decimals()));
2123         _mint(team, team_tokens);
2124         marketing = _marketing;
2125         marketing_tokens = 310000000 * (10 ** uint256(decimals()));
2126         _mint(marketing, marketing_tokens);
2127         reserve = _reserve;
2128         reserve_tokens = 1860000000 * (10 ** uint256(decimals()));
2129         _mint(reserve, reserve_tokens);
2130     }
2131 
2132     function transfer_from_bank(
2133         address recipient,
2134         uint256 amount
2135     )
2136         external
2137         onlyOwner
2138     {
2139         super._transfer(address(bank), recipient, amount);
2140     }
2141 
2142     function unlock_seed() external after_unlock_time {
2143         require(
2144             seed_locked[msg.sender],
2145             "Tokens must be locked"
2146         );
2147         require(
2148             block.timestamp < STOP_SELL_TIME,
2149             "The time must be less than the stop sell time"
2150         );
2151         seed_locked[msg.sender] = false;
2152         tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
2153             seed_balance[msg.sender].sub(
2154                 get_available_seed_balance(msg.sender)
2155             )
2156         );
2157         seed_balance[msg.sender] = 0;
2158         tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
2159             seed_bonus[msg.sender].sub(
2160                 get_available_seed_bonus(msg.sender)
2161             )
2162         );
2163         seed_bonus[msg.sender] = 0;
2164     }
2165 
2166     function unlock_private() external after_unlock_time {
2167         require(
2168             private_locked[msg.sender],
2169             "Tokens must be locked"
2170         );
2171         require(
2172             block.timestamp < STOP_SELL_TIME,
2173             "The time must be less than the stop sell time"
2174         );
2175         private_locked[msg.sender] = false;
2176         tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
2177             private_balance[msg.sender].sub(
2178                 get_available_private_balance(msg.sender)
2179             )
2180         );
2181         private_balance[msg.sender] = 0;
2182         tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
2183             private_bonus[msg.sender].sub(
2184                 get_available_private_bonus(msg.sender)
2185             )
2186         );
2187         private_bonus[msg.sender] = 0;
2188     }
2189 
2190     function burn_seed_tokens() external only_tokens_holder {
2191         _burn(tokens_holder, seed_tokens);
2192         seed_tokens = 0;
2193     }
2194 
2195     function burn_private_tokens() external only_tokens_holder {
2196         _burn(tokens_holder, private_tokens);
2197         private_tokens = 0;
2198     }
2199 
2200     function burn_public_tokens() external only_tokens_holder {
2201         _burn(tokens_holder, public_tokens);
2202         public_tokens = 0;
2203     }
2204 
2205     function set_bank(address payable bank_address) external onlyOwner {
2206         bank = OkschainBank(bank_address);
2207     }
2208 
2209     function transfer(
2210         address recipient,
2211         uint256 amount
2212     )
2213         public
2214         returns (bool)
2215     {
2216         _transfer(msg.sender, recipient, amount);
2217         return true;
2218     }
2219 
2220     function transferFrom(
2221         address sender,
2222         address recipient,
2223         uint256 amount
2224     )
2225         public
2226         returns (bool)
2227     {
2228         _transfer(sender, recipient, amount);
2229         _approve(
2230             sender,
2231             msg.sender,
2232             allowance(sender, msg.sender).sub(amount)
2233         );
2234         return true;
2235     }
2236 
2237     function send_seed_tokens(
2238         address recipient,
2239         uint256 amount
2240     )
2241         public
2242         only_tokens_holder
2243         returns (bool)
2244     {
2245         require(
2246             seed_tokens > 0,
2247             "Tokens are over or sale is ended"
2248         );
2249         seed_balance[recipient] = seed_balance[recipient].add(amount);
2250         uint256 bonus_amount = amount.mul(2000).div(10000);
2251         seed_bonus[recipient] = seed_bonus[recipient].add(bonus_amount);
2252         seed_locked[recipient] = true;
2253         seed_tokens = seed_tokens.sub(amount).sub(bonus_amount);
2254         return super.transfer(recipient, amount.add(bonus_amount));
2255     }
2256 
2257     function send_private_tokens(
2258         address recipient,
2259         uint256 amount
2260     )
2261         public
2262         only_tokens_holder
2263         returns (bool)
2264     {
2265         require(
2266             private_tokens > 0,
2267             "Tokens are over or sale is ended"
2268         );
2269         private_balance[recipient] = private_balance[recipient].add(amount);
2270         uint256 bonus_amount = amount.mul(1496).div(1000);
2271         private_bonus[recipient] = private_bonus[recipient].add(bonus_amount);
2272         private_locked[recipient] = true;
2273         private_tokens = private_tokens.sub(amount).sub(bonus_amount);
2274         return super.transfer(recipient, amount.add(bonus_amount));
2275     }
2276 
2277     function send_public_tokens(
2278         address recipient,
2279         uint256 amount
2280     )
2281         public
2282         only_tokens_holder
2283         returns (bool)
2284     {
2285         require(
2286             public_tokens > 0,
2287             "Tokens are over or sale is ended"
2288         );
2289         public_tokens = public_tokens.sub(amount);
2290         return super.transfer(recipient, amount);
2291     }
2292 
2293     function get_available_balance(
2294         address sender
2295     )
2296         public
2297         view
2298         returns (uint256)
2299     {
2300         uint256 available_balance = balanceOf(sender);
2301         if (sender == team) {
2302             available_balance = available_balance.sub(
2303                 team_tokens.sub(
2304                     get_available_team_balance()
2305                 )
2306             );
2307         }
2308         if (sender == marketing) {
2309             available_balance = available_balance.sub(
2310                 marketing_tokens.sub(
2311                     get_available_marketing_balance()
2312                 )
2313             );
2314         }
2315         if (sender == reserve) {
2316             available_balance = available_balance.sub(
2317                     reserve_tokens.sub(
2318                         get_available_reserve_balance()
2319                     )
2320             );
2321         }
2322         if (seed_locked[sender]) {
2323             available_balance = available_balance.sub(
2324                 seed_balance[sender].sub(
2325                     get_available_seed_balance(sender)
2326                 )
2327             );
2328             available_balance = available_balance.sub(
2329                 seed_bonus[sender].sub(
2330                     get_available_seed_bonus(sender)
2331                 )
2332             );
2333         }
2334         if (private_locked[sender]) {
2335             available_balance = available_balance.sub(
2336                 private_balance[sender].sub(
2337                     get_available_private_balance(sender)
2338                 )
2339             );
2340             available_balance = available_balance.sub(
2341                 private_bonus[sender].sub(
2342                     get_available_private_bonus(sender)
2343                 )
2344             );
2345         }
2346         available_balance = available_balance.sub(tokens_for_sell[sender]);
2347         return (available_balance);
2348     }
2349 
2350     function get_available_team_balance()
2351         public
2352         view
2353         returns (uint256)
2354     {
2355         if (block.timestamp < 1605830400) { // 20.11.2020
2356             return 0;
2357         } else if (block.timestamp < 1614556800) { // 01.03.2021
2358             return team_tokens.mul(10).div(100);
2359         } else if (block.timestamp < 1646092800) { // 01.03.2022
2360             return team_tokens.mul(20).div(100);
2361         } else if (block.timestamp < 1669852800) { // 01.12.2022
2362             return team_tokens.mul(30).div(100);
2363         } else if (block.timestamp < 1677628800) { // 01.03.2023
2364             return team_tokens.mul(35).div(100);
2365         } else if (block.timestamp < 1690848000) { // 01.08.2023
2366             return team_tokens.mul(40).div(100);
2367         } else if (block.timestamp < 1706745600) { // 01.02.2024
2368             return team_tokens.mul(45).div(100);
2369         } else if (block.timestamp < 1711929600) { // 01.04.2024
2370             return team_tokens.mul(50).div(100);
2371         } else if (block.timestamp < 1722470400) { // 01.08.2024
2372             return team_tokens.mul(55).div(100);
2373         } else if (block.timestamp < 1727740800) { // 01.10.2024
2374             return team_tokens.mul(60).div(100);
2375         } else if (block.timestamp < 1733011200) { // 01.12.2024
2376             return team_tokens.mul(65).div(100);
2377         } else if (block.timestamp < 1740787200) { // 01.03.2025
2378             return team_tokens.mul(70).div(100);
2379         } else if (block.timestamp < 1751328000) { // 01.07.2025
2380             return team_tokens.mul(80).div(100);
2381         } else if (block.timestamp < 1764547200) { // 01.12.2025
2382             return team_tokens.mul(90).div(100);
2383         } else {
2384             return team_tokens;
2385         }
2386     }
2387 
2388     function get_available_marketing_balance()
2389         public
2390         view
2391         returns (uint256)
2392     {
2393         if (block.timestamp < 1603152000) { // 20.10.2020
2394             return 0;
2395         } else if (block.timestamp < 1614556800) { // 01.03.2021
2396             return marketing_tokens.mul(10).div(100);
2397         } else if (block.timestamp < 1648771200) { // 01.04.2022
2398             return marketing_tokens.mul(20).div(100);
2399         } else if (block.timestamp < 1656633600) { // 01.07.2022
2400             return marketing_tokens.mul(30).div(100);
2401         } else if (block.timestamp < 1669852800) { // 01.12.2022
2402             return marketing_tokens.mul(35).div(100);
2403         } else if (block.timestamp < 1682899200) { // 01.05.2023
2404             return marketing_tokens.mul(40).div(100);
2405         } else if (block.timestamp < 1690848000) { // 01.08.2023
2406             return marketing_tokens.mul(50).div(100);
2407         } else if (block.timestamp < 1711929600) { // 01.04.2024
2408             return marketing_tokens.mul(55).div(100);
2409         } else if (block.timestamp < 1722470400) { // 01.08.2024
2410             return marketing_tokens.mul(60).div(100);
2411         } else if (block.timestamp < 1733011200) { // 01.12.2024
2412             return marketing_tokens.mul(65).div(100);
2413         } else if (block.timestamp < 1743465600) { // 01.04.2025
2414             return marketing_tokens.mul(70).div(100);
2415         } else if (block.timestamp < 1754006400) { // 01.08.2025
2416             return marketing_tokens.mul(80).div(100);
2417         } else if (block.timestamp < 1764547200) { // 01.12.2025
2418             return marketing_tokens.mul(90).div(100);
2419         } else {
2420             return marketing_tokens;
2421         }
2422     }
2423 
2424     function get_available_reserve_balance()
2425         public
2426         view
2427         returns (uint256)
2428     {
2429         if (block.timestamp < 1608422400) { // 20.12.2020
2430             return 0;
2431         } else if (block.timestamp < 1619827200) { // 01.05.2021
2432             return reserve_tokens.mul(10).div(100);
2433         } else if (block.timestamp < 1630454400) { // 01.09.2021
2434             return reserve_tokens.mul(15).div(100);
2435         } else if (block.timestamp < 1654041600) { // 01.06.2022
2436             return reserve_tokens.mul(20).div(100);
2437         } else if (block.timestamp < 1664582400) { // 01.10.2022
2438             return reserve_tokens.mul(25).div(100);
2439         } else if (block.timestamp < 1682899200) { // 01.05.2023
2440             return reserve_tokens.mul(30).div(100);
2441         } else if (block.timestamp < 1690848000) { // 01.08.2023
2442             return reserve_tokens.mul(40).div(100);
2443         } else if (block.timestamp < 1714521600) { // 01.05.2024
2444             return reserve_tokens.mul(45).div(100);
2445         } else if (block.timestamp < 1719792000) { // 01.07.2024
2446             return reserve_tokens.mul(55).div(100);
2447         } else if (block.timestamp < 1727740800) { // 01.10.2024
2448             return reserve_tokens.mul(60).div(100);
2449         } else if (block.timestamp < 1733011200) { // 01.12.2024
2450             return reserve_tokens.mul(65).div(100);
2451         } else if (block.timestamp < 1746057600) { // 01.05.2025
2452             return reserve_tokens.mul(70).div(100);
2453         } else if (block.timestamp < 1756684800) { // 01.09.2025
2454             return reserve_tokens.mul(80).div(100);
2455         } else if (block.timestamp < 1764547200) { // 01.12.2025
2456             return reserve_tokens.mul(90).div(100);
2457         } else {
2458             return reserve_tokens;
2459         }
2460     }
2461 
2462     function get_available_seed_balance(
2463         address sender
2464     )
2465         public
2466         view
2467         returns (uint256)
2468     {
2469         if (block.timestamp < 1592611200) { // 20.06.2020
2470             return 0;
2471         } else if (block.timestamp < 1597881600) { // 20.08.2020
2472             return seed_balance[sender].mul(20).div(100);
2473         } else if (block.timestamp < 1608422400) { // 20.12.2020
2474             return seed_balance[sender].mul(30).div(100);
2475         } else if (block.timestamp < 1617235200) { // 01.04.2021
2476             return seed_balance[sender].mul(50).div(100);
2477         } else if (block.timestamp < 1625097600) { // 01.07.2021
2478             return seed_balance[sender].mul(60).div(100);
2479         } else if (block.timestamp < 1633046400) { // 01.10.2021
2480             return seed_balance[sender].mul(70).div(100);
2481         } else if (block.timestamp < 1638316800) { // 01.12.2021
2482             return seed_balance[sender].mul(80).div(100);
2483         } else if (block.timestamp < 1646092800) { // 01.03.2022
2484             return seed_balance[sender].mul(90).div(100);
2485         } else if (block.timestamp < 1654041600) { // 01.06.2022
2486             return seed_balance[sender].mul(95).div(100);
2487         } else {
2488             return seed_balance[sender];
2489         }
2490     }
2491 
2492     function get_available_private_balance(
2493         address sender
2494     )
2495         public
2496         view
2497         returns (uint256)
2498     {
2499         if (block.timestamp < 1592611200) { // 20.06.2020
2500             return 0;
2501         } else if (block.timestamp < 1580515200) { // 20.07.2020
2502             return private_balance[sender].mul(15).div(100);
2503         } else if (block.timestamp < 1603152000) { // 20.10.2020
2504             return private_balance[sender].mul(25).div(100);
2505         } else if (block.timestamp < 1608422400) { // 20.12.2020
2506             return private_balance[sender].mul(35).div(100);
2507         } else if (block.timestamp < 1617235200) { // 01.04.2021
2508             return private_balance[sender].mul(45).div(100);
2509         } else if (block.timestamp < 1619827200) { // 01.05.2021
2510             return private_balance[sender].mul(55).div(100);
2511         } else if (block.timestamp < 1627776000) { // 01.08.2021
2512             return private_balance[sender].mul(65).div(100);
2513         } else if (block.timestamp < 1638316800) { // 01.12.2021
2514             return private_balance[sender].mul(75).div(100);
2515         } else if (block.timestamp < 1646092800) { // 01.03.2022
2516             return private_balance[sender].mul(85).div(100);
2517         } else if (block.timestamp < 1656633600) { // 01.07.2022
2518             return private_balance[sender].mul(90).div(100);
2519         } else if (block.timestamp < 1664582400) { // 01.10.2022
2520             return private_balance[sender].mul(95).div(100);
2521         } else {
2522             return private_balance[sender];
2523         }
2524     }
2525 
2526     function get_available_seed_bonus(
2527         address sender
2528     )
2529         public
2530         view
2531         returns (uint256)
2532     {
2533         uint256 available_bonus = seed_bonus[sender].div(9);
2534         if (block.timestamp < 1592611200) { // 20.06.2020
2535             return 0;
2536         } else if (block.timestamp < 1597881600) { // 20.08.2020
2537             return available_bonus;
2538         } else if (block.timestamp < 1608422400) { // 20.12.2020
2539             return available_bonus.mul(2);
2540         } else if (block.timestamp < 1617235200) { // 01.04.2021
2541             return available_bonus.mul(3);
2542         } else if (block.timestamp < 1625097600) { // 01.07.2021
2543             return available_bonus.mul(4);
2544         } else if (block.timestamp < 1633046400) { // 01.10.2021
2545             return available_bonus.mul(5);
2546         } else if (block.timestamp < 1638316800) { // 01.12.2021
2547             return available_bonus.mul(6);
2548         } else if (block.timestamp < 1646092800) { // 01.03.2022
2549             return available_bonus.mul(7);
2550         } else if (block.timestamp < 1654041600) { // 01.06.2022
2551             return available_bonus.mul(8);
2552         } else {
2553             return seed_bonus[sender];
2554         }
2555     }
2556 
2557     function get_available_private_bonus(
2558         address sender
2559     )
2560         public
2561         view
2562         returns (uint256)
2563     {
2564         uint256 available_bonus = private_bonus[sender].div(11);
2565         if (block.timestamp < 1592611200) { // 20.06.2020
2566             return 0;
2567         } else if (block.timestamp < 1580515200) { // 20.07.2020
2568             return available_bonus;
2569         } else if (block.timestamp < 1603152000) { // 20.10.2020
2570             return available_bonus.mul(2);
2571         } else if (block.timestamp < 1608422400) { // 20.12.2020
2572             return available_bonus.mul(3);
2573         } else if (block.timestamp < 1617235200) { // 01.04.2021
2574             return available_bonus.mul(4);
2575         } else if (block.timestamp < 1619827200) { // 01.05.2021
2576             return available_bonus.mul(5);
2577         } else if (block.timestamp < 1627776000) { // 01.08.2021
2578             return available_bonus.mul(6);
2579         } else if (block.timestamp < 1638316800) { // 01.12.2021
2580             return available_bonus.mul(7);
2581         } else if (block.timestamp < 1646092800) { // 01.03.2022
2582             return available_bonus.mul(8);
2583         } else if (block.timestamp < 1656633600) { // 01.07.2022
2584             return available_bonus.mul(9);
2585         } else if (block.timestamp < 1664582400) { // 01.10.2022
2586             return available_bonus.mul(10);
2587         } else {
2588             return private_bonus[sender];
2589         }
2590     }
2591 
2592     function _transfer(
2593         address sender,
2594         address recipient,
2595         uint256 amount
2596     )
2597         internal
2598     {
2599         if (block.timestamp < STOP_ALL_LOCKS_TIME) {
2600             if (recipient == address(bank)) {
2601                 require(
2602                     tokens_for_sell[sender] >= amount,
2603                     "Tokens must be unlocked"
2604                 );
2605                 require(
2606                     block.timestamp < STOP_SELL_TIME,
2607                     "The time must be less than the stop sell time"
2608                 );
2609                 require(
2610                     bank.send_ether(
2611                         address(uint160(sender)),
2612                         amount
2613                     ),
2614                     "Bank problem"
2615                 );
2616                 tokens_for_sell[sender] = tokens_for_sell[sender].sub(
2617                     amount
2618                 );
2619             } else {
2620                 require(
2621                     amount <= get_available_balance(sender),
2622                     "No available balance"
2623                 );
2624             }
2625         }
2626         super._transfer(sender, recipient, amount);
2627     }
2628 }