1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: 272d917
6 Repository: https://github.com/renproject/darknode-sol
7 Issues: https://github.com/renproject/darknode-sol/issues
8 
9 Licenses
10 openzeppelin-solidity: (MIT) https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
11 darknode-sol: (GNU GPL V3) https://github.com/renproject/darknode-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity ^0.5.12;
16 
17 /**
18  * @title Claimable
19  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
20  * This allows the new owner to accept the transfer.
21  */
22 contract Claimable {
23     address private _pendingOwner;
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30      * account.
31      */
32     constructor () internal {
33         _owner = msg.sender;
34         emit OwnershipTransferred(address(0), _owner);
35     }
36 
37     /**
38      * @return the address of the owner.
39      */
40     function owner() public view returns (address) {
41         return _owner;
42     }
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(isOwner(), "Claimable: caller is not the owner");
49         _;
50     }
51 
52     /**
53     * @dev Modifier throws if called by any account other than the pendingOwner.
54     */
55     modifier onlyPendingOwner() {
56       require(msg.sender == _pendingOwner, "Claimable: caller is not the pending owner");
57       _;
58     }
59 
60     /**
61      * @return true if `msg.sender` is the owner of the contract.
62      */
63     function isOwner() public view returns (bool) {
64         return msg.sender == _owner;
65     }
66 
67     /**
68      * @dev Allows the current owner to relinquish control of the contract.
69      * It will not be possible to call the functions with the `onlyOwner`
70      * modifier anymore.
71      * @notice Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80     * @dev Allows the current owner to set the pendingOwner address.
81     * @param newOwner The address to transfer ownership to.
82     */
83     function transferOwnership(address newOwner) public onlyOwner {
84       _pendingOwner = newOwner;
85     }
86 
87     /**
88     * @dev Allows the pendingOwner address to finalize the transfer.
89     */
90     function claimOwnership() public onlyPendingOwner {
91       emit OwnershipTransferred(_owner, _pendingOwner);
92       _owner = _pendingOwner;
93       _pendingOwner = address(0);
94     }
95 }
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations with added overflow
99  * checks.
100  *
101  * Arithmetic operations in Solidity wrap on overflow. This can easily result
102  * in bugs, because programmers usually assume that an overflow raises an
103  * error, which is the standard behavior in high level programming languages.
104  * `SafeMath` restores this intuition by reverting the transaction when an
105  * operation overflows.
106  *
107  * Using this library instead of the unchecked operations eliminates an entire
108  * class of bugs, so it's recommended to use it always.
109  */
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      * - Subtraction cannot overflow.
148      *
149      * _Available since v2.4.0._
150      */
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      *
207      * _Available since v2.4.0._
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         // Solidity only automatically asserts when dividing by 0
211         require(b > 0, errorMessage);
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      * - The divisor cannot be zero.
243      *
244      * _Available since v2.4.0._
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 /*
253  * @dev Provides information about the current execution context, including the
254  * sender of the transaction and its data. While these are generally available
255  * via msg.sender and msg.data, they should not be accessed in such a direct
256  * manner, since when dealing with GSN meta-transactions the account sending and
257  * paying for execution may not be the actual sender (as far as an application
258  * is concerned).
259  *
260  * This contract is only required for intermediate, library-like contracts.
261  */
262 contract Context {
263     // Empty internal constructor, to prevent people from mistakenly deploying
264     // an instance of this contract, which should be used via inheritance.
265     constructor () internal { }
266     // solhint-disable-previous-line no-empty-blocks
267 
268     function _msgSender() internal view returns (address payable) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view returns (bytes memory) {
273         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
274         return msg.data;
275     }
276 }
277 
278 /**
279  * @dev Contract module which provides a basic access control mechanism, where
280  * there is an account (an owner) that can be granted exclusive access to
281  * specific functions.
282  *
283  * This module is used through inheritance. It will make available the modifier
284  * `onlyOwner`, which can be applied to your functions to restrict their use to
285  * the owner.
286  */
287 contract Ownable is Context {
288     address private _owner;
289 
290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
291 
292     /**
293      * @dev Initializes the contract setting the deployer as the initial owner.
294      */
295     constructor () internal {
296         _owner = _msgSender();
297         emit OwnershipTransferred(address(0), _owner);
298     }
299 
300     /**
301      * @dev Returns the address of the current owner.
302      */
303     function owner() public view returns (address) {
304         return _owner;
305     }
306 
307     /**
308      * @dev Throws if called by any account other than the owner.
309      */
310     modifier onlyOwner() {
311         require(isOwner(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     /**
316      * @dev Returns true if the caller is the current owner.
317      */
318     function isOwner() public view returns (bool) {
319         return _msgSender() == _owner;
320     }
321 
322     /**
323      * @dev Leaves the contract without owner. It will not be possible to call
324      * `onlyOwner` functions anymore. Can only be called by the current owner.
325      *
326      * NOTE: Renouncing ownership will leave the contract without an owner,
327      * thereby removing any functionality that is only available to the owner.
328      */
329     function renounceOwnership() public onlyOwner {
330         emit OwnershipTransferred(_owner, address(0));
331         _owner = address(0);
332     }
333 
334     /**
335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
336      * Can only be called by the current owner.
337      */
338     function transferOwnership(address newOwner) public onlyOwner {
339         _transferOwnership(newOwner);
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      */
345     function _transferOwnership(address newOwner) internal {
346         require(newOwner != address(0), "Ownable: new owner is the zero address");
347         emit OwnershipTransferred(_owner, newOwner);
348         _owner = newOwner;
349     }
350 }
351 
352 /**
353  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
354  *
355  * These functions can be used to verify that a message was signed by the holder
356  * of the private keys of a given address.
357  */
358 library ECDSA {
359     /**
360      * @dev Returns the address that signed a hashed message (`hash`) with
361      * `signature`. This address can then be used for verification purposes.
362      *
363      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
364      * this function rejects them by requiring the `s` value to be in the lower
365      * half order, and the `v` value to be either 27 or 28.
366      *
367      * NOTE: This call _does not revert_ if the signature is invalid, or
368      * if the signer is otherwise unable to be retrieved. In those scenarios,
369      * the zero address is returned.
370      *
371      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
372      * verification to be secure: it is possible to craft signatures that
373      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
374      * this is by receiving a hash of the original message (which may otherwise
375      * be too long), and then calling {toEthSignedMessageHash} on it.
376      */
377     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
378         // Check the signature length
379         if (signature.length != 65) {
380             revert("signature's length is invalid");
381         }
382 
383         // Divide the signature in r, s and v variables
384         bytes32 r;
385         bytes32 s;
386         uint8 v;
387 
388         // ecrecover takes the signature parameters, and the only way to get them
389         // currently is to use assembly.
390         // solhint-disable-next-line no-inline-assembly
391         assembly {
392             r := mload(add(signature, 0x20))
393             s := mload(add(signature, 0x40))
394             v := byte(0, mload(add(signature, 0x60)))
395         }
396 
397         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
398         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
399         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
400         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
401         //
402         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
403         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
404         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
405         // these malleable signatures as well.
406         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
407             revert("signature's s is in the wrong range");
408         }
409 
410         if (v != 27 && v != 28) {
411             revert("signature's v is in the wrong range");
412         }
413 
414         // If the signature is valid (and not malleable), return the signer address
415         return ecrecover(hash, v, r, s);
416     }
417 
418     /**
419      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
420      * replicates the behavior of the
421      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
422      * JSON-RPC method.
423      *
424      * See {recover}.
425      */
426     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
427         // 32 is the length in bytes of hash,
428         // enforced by the type signature above
429         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
430     }
431 }
432 
433 library String {
434 
435     /// @notice Convert a uint value to its decimal string representation
436     // solium-disable-next-line security/no-assign-params
437     function fromUint(uint _i) internal pure returns (string memory) {
438         if (_i == 0) {
439             return "0";
440         }
441         uint j = _i;
442         uint len;
443         while (j != 0) {
444             len++;
445             j /= 10;
446         }
447         bytes memory bstr = new bytes(len);
448         uint k = len - 1;
449         while (_i != 0) {
450             bstr[k--] = byte(uint8(48 + _i % 10));
451             _i /= 10;
452         }
453         return string(bstr);
454     }
455 
456     /// @notice Convert a bytes32 value to its hex string representation
457     function fromBytes32(bytes32 _value) internal pure returns(string memory) {
458         bytes32 value = bytes32(uint256(_value));
459         bytes memory alphabet = "0123456789abcdef";
460 
461         bytes memory str = new bytes(32 * 2 + 2);
462         str[0] = '0';
463         str[1] = 'x';
464         for (uint i = 0; i < 32; i++) {
465             str[2+i*2] = alphabet[uint(uint8(value[i] >> 4))];
466             str[3+i*2] = alphabet[uint(uint8(value[i] & 0x0f))];
467         }
468         return string(str);
469     }
470 
471     /// @notice Convert an address to its hex string representation
472     function fromAddress(address _addr) internal pure returns(string memory) {
473         bytes32 value = bytes32(uint256(_addr));
474         bytes memory alphabet = "0123456789abcdef";
475 
476         bytes memory str = new bytes(20 * 2 + 2);
477         str[0] = '0';
478         str[1] = 'x';
479         for (uint i = 0; i < 20; i++) {
480             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
481             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
482         }
483         return string(str);
484     }
485 
486     /// @notice Append four strings
487     function add4(string memory a, string memory b, string memory c, string memory d) internal pure returns (string memory) {
488         return string(abi.encodePacked(a, b, c, d));
489     }
490 }
491 
492 /**
493  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
494  * the optional functions; to access them see {ERC20Detailed}.
495  */
496 interface IERC20 {
497     /**
498      * @dev Returns the amount of tokens in existence.
499      */
500     function totalSupply() external view returns (uint256);
501 
502     /**
503      * @dev Returns the amount of tokens owned by `account`.
504      */
505     function balanceOf(address account) external view returns (uint256);
506 
507     /**
508      * @dev Moves `amount` tokens from the caller's account to `recipient`.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transfer(address recipient, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Returns the remaining number of tokens that `spender` will be
518      * allowed to spend on behalf of `owner` through {transferFrom}. This is
519      * zero by default.
520      *
521      * This value changes when {approve} or {transferFrom} are called.
522      */
523     function allowance(address owner, address spender) external view returns (uint256);
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * IMPORTANT: Beware that changing an allowance with this method brings the risk
531      * that someone may use both the old and the new allowance by unfortunate
532      * transaction ordering. One possible solution to mitigate this race
533      * condition is to first reduce the spender's allowance to 0 and set the
534      * desired value afterwards:
535      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address spender, uint256 amount) external returns (bool);
540 
541     /**
542      * @dev Moves `amount` tokens from `sender` to `recipient` using the
543      * allowance mechanism. `amount` is then deducted from the caller's
544      * allowance.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
551 
552     /**
553      * @dev Emitted when `value` tokens are moved from one account (`from`) to
554      * another (`to`).
555      *
556      * Note that `value` may be zero.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 value);
559 
560     /**
561      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
562      * a call to {approve}. `value` is the new allowance.
563      */
564     event Approval(address indexed owner, address indexed spender, uint256 value);
565 }
566 
567 /**
568  * @dev Implementation of the {IERC20} interface.
569  *
570  * This implementation is agnostic to the way tokens are created. This means
571  * that a supply mechanism has to be added in a derived contract using {_mint}.
572  * For a generic mechanism see {ERC20Mintable}.
573  *
574  * TIP: For a detailed writeup see our guide
575  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
576  * to implement supply mechanisms].
577  *
578  * We have followed general OpenZeppelin guidelines: functions revert instead
579  * of returning `false` on failure. This behavior is nonetheless conventional
580  * and does not conflict with the expectations of ERC20 applications.
581  *
582  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
583  * This allows applications to reconstruct the allowance for all accounts just
584  * by listening to said events. Other implementations of the EIP may not emit
585  * these events, as it isn't required by the specification.
586  *
587  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
588  * functions have been added to mitigate the well-known issues around setting
589  * allowances. See {IERC20-approve}.
590  */
591 contract ERC20 is Context, IERC20 {
592     using SafeMath for uint256;
593 
594     mapping (address => uint256) private _balances;
595 
596     mapping (address => mapping (address => uint256)) private _allowances;
597 
598     uint256 private _totalSupply;
599 
600     /**
601      * @dev See {IERC20-totalSupply}.
602      */
603     function totalSupply() public view returns (uint256) {
604         return _totalSupply;
605     }
606 
607     /**
608      * @dev See {IERC20-balanceOf}.
609      */
610     function balanceOf(address account) public view returns (uint256) {
611         return _balances[account];
612     }
613 
614     /**
615      * @dev See {IERC20-transfer}.
616      *
617      * Requirements:
618      *
619      * - `recipient` cannot be the zero address.
620      * - the caller must have a balance of at least `amount`.
621      */
622     function transfer(address recipient, uint256 amount) public returns (bool) {
623         _transfer(_msgSender(), recipient, amount);
624         return true;
625     }
626 
627     /**
628      * @dev See {IERC20-allowance}.
629      */
630     function allowance(address owner, address spender) public view returns (uint256) {
631         return _allowances[owner][spender];
632     }
633 
634     /**
635      * @dev See {IERC20-approve}.
636      *
637      * Requirements:
638      *
639      * - `spender` cannot be the zero address.
640      */
641     function approve(address spender, uint256 amount) public returns (bool) {
642         _approve(_msgSender(), spender, amount);
643         return true;
644     }
645 
646     /**
647      * @dev See {IERC20-transferFrom}.
648      *
649      * Emits an {Approval} event indicating the updated allowance. This is not
650      * required by the EIP. See the note at the beginning of {ERC20};
651      *
652      * Requirements:
653      * - `sender` and `recipient` cannot be the zero address.
654      * - `sender` must have a balance of at least `amount`.
655      * - the caller must have allowance for `sender`'s tokens of at least
656      * `amount`.
657      */
658     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
659         _transfer(sender, recipient, amount);
660         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
661         return true;
662     }
663 
664     /**
665      * @dev Atomically increases the allowance granted to `spender` by the caller.
666      *
667      * This is an alternative to {approve} that can be used as a mitigation for
668      * problems described in {IERC20-approve}.
669      *
670      * Emits an {Approval} event indicating the updated allowance.
671      *
672      * Requirements:
673      *
674      * - `spender` cannot be the zero address.
675      */
676     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
677         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
678         return true;
679     }
680 
681     /**
682      * @dev Atomically decreases the allowance granted to `spender` by the caller.
683      *
684      * This is an alternative to {approve} that can be used as a mitigation for
685      * problems described in {IERC20-approve}.
686      *
687      * Emits an {Approval} event indicating the updated allowance.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      * - `spender` must have allowance for the caller of at least
693      * `subtractedValue`.
694      */
695     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
696         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
697         return true;
698     }
699 
700     /**
701      * @dev Moves tokens `amount` from `sender` to `recipient`.
702      *
703      * This is internal function is equivalent to {transfer}, and can be used to
704      * e.g. implement automatic token fees, slashing mechanisms, etc.
705      *
706      * Emits a {Transfer} event.
707      *
708      * Requirements:
709      *
710      * - `sender` cannot be the zero address.
711      * - `recipient` cannot be the zero address.
712      * - `sender` must have a balance of at least `amount`.
713      */
714     function _transfer(address sender, address recipient, uint256 amount) internal {
715         require(sender != address(0), "ERC20: transfer from the zero address");
716         require(recipient != address(0), "ERC20: transfer to the zero address");
717 
718         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
719         _balances[recipient] = _balances[recipient].add(amount);
720         emit Transfer(sender, recipient, amount);
721     }
722 
723     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
724      * the total supply.
725      *
726      * Emits a {Transfer} event with `from` set to the zero address.
727      *
728      * Requirements
729      *
730      * - `to` cannot be the zero address.
731      */
732     function _mint(address account, uint256 amount) internal {
733         require(account != address(0), "ERC20: mint to the zero address");
734 
735         _totalSupply = _totalSupply.add(amount);
736         _balances[account] = _balances[account].add(amount);
737         emit Transfer(address(0), account, amount);
738     }
739 
740      /**
741      * @dev Destroys `amount` tokens from `account`, reducing the
742      * total supply.
743      *
744      * Emits a {Transfer} event with `to` set to the zero address.
745      *
746      * Requirements
747      *
748      * - `account` cannot be the zero address.
749      * - `account` must have at least `amount` tokens.
750      */
751     function _burn(address account, uint256 amount) internal {
752         require(account != address(0), "ERC20: burn from the zero address");
753 
754         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
755         _totalSupply = _totalSupply.sub(amount);
756         emit Transfer(account, address(0), amount);
757     }
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
761      *
762      * This is internal function is equivalent to `approve`, and can be used to
763      * e.g. set automatic allowances for certain subsystems, etc.
764      *
765      * Emits an {Approval} event.
766      *
767      * Requirements:
768      *
769      * - `owner` cannot be the zero address.
770      * - `spender` cannot be the zero address.
771      */
772     function _approve(address owner, address spender, uint256 amount) internal {
773         require(owner != address(0), "ERC20: approve from the zero address");
774         require(spender != address(0), "ERC20: approve to the zero address");
775 
776         _allowances[owner][spender] = amount;
777         emit Approval(owner, spender, amount);
778     }
779 
780     /**
781      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
782      * from the caller's allowance.
783      *
784      * See {_burn} and {_approve}.
785      */
786     function _burnFrom(address account, uint256 amount) internal {
787         _burn(account, amount);
788         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
789     }
790 }
791 
792 /**
793  * @dev Optional functions from the ERC20 standard.
794  */
795 contract ERC20Detailed is IERC20 {
796     string private _name;
797     string private _symbol;
798     uint8 private _decimals;
799 
800     /**
801      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
802      * these values are immutable: they can only be set once during
803      * construction.
804      */
805     constructor (string memory name, string memory symbol, uint8 decimals) public {
806         _name = name;
807         _symbol = symbol;
808         _decimals = decimals;
809     }
810 
811     /**
812      * @dev Returns the name of the token.
813      */
814     function name() public view returns (string memory) {
815         return _name;
816     }
817 
818     /**
819      * @dev Returns the symbol of the token, usually a shorter version of the
820      * name.
821      */
822     function symbol() public view returns (string memory) {
823         return _symbol;
824     }
825 
826     /**
827      * @dev Returns the number of decimals used to get its user representation.
828      * For example, if `decimals` equals `2`, a balance of `505` tokens should
829      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
830      *
831      * Tokens usually opt for a value of 18, imitating the relationship between
832      * Ether and Wei.
833      *
834      * NOTE: This information is only used for _display_ purposes: it in
835      * no way affects any of the arithmetic of the contract, including
836      * {IERC20-balanceOf} and {IERC20-transfer}.
837      */
838     function decimals() public view returns (uint8) {
839         return _decimals;
840     }
841 }
842 
843 /// @notice ERC20Shifted represents a digital asset that has been bridged on to
844 /// the Ethereum ledger. It exposes mint and burn functions that can only be
845 /// called by it's associated Shifter.
846 contract ERC20Shifted is ERC20, ERC20Detailed, Claimable {
847 
848     /* solium-disable-next-line no-empty-blocks */
849     constructor(string memory _name, string memory _symbol, uint8 _decimals) public ERC20Detailed(_name, _symbol, _decimals) {}
850 
851     /// @notice Allow the owner of the contract to recover funds accidentally
852     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
853     function recoverTokens(address _token) external onlyOwner {
854         if (_token == address(0x0)) {
855             msg.sender.transfer(address(this).balance);
856         } else {
857             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
858         }
859     }
860 
861     function burn(address _from, uint256 _amount) public onlyOwner {
862         _burn(_from, _amount);
863     }
864 
865     function mint(address _to, uint256 _amount) public onlyOwner {
866         _mint(_to, _amount);
867     }
868 }
869 
870 /// @dev The following are not necessary for deploying zBTC or zZEC contracts,
871 /// but are used to track deployments.
872 
873 /* solium-disable-next-line no-empty-blocks */
874 contract zBTC is ERC20Shifted("Shifted BTC", "zBTC", 8) {}
875 
876 /* solium-disable-next-line no-empty-blocks */
877 contract zZEC is ERC20Shifted("Shifted ZEC", "zZEC", 8) {}
878 
879 /* solium-disable-next-line no-empty-blocks */
880 contract zBCH is ERC20Shifted("Shifted BCH", "zBCH", 8) {}
881 
882 /// @notice Shifter handles verifying mint and burn requests. A mintAuthority
883 /// approves new assets to be minted by providing a digital signature. An owner
884 /// of an asset can request for it to be burnt.
885 contract Shifter is Claimable {
886     using SafeMath for uint256;
887 
888     uint8 public version = 2;
889 
890     uint256 constant BIPS_DENOMINATOR = 10000;
891     uint256 public minShiftAmount;
892 
893     /// @notice Each Shifter token is tied to a specific shifted token.
894     ERC20Shifted public token;
895 
896     /// @notice The mintAuthority is an address that can sign mint requests.
897     address public mintAuthority;
898 
899     /// @dev feeRecipient is assumed to be an address (or a contract) that can
900     /// accept erc20 payments it cannot be 0x0.
901     /// @notice When tokens are mint or burnt, a portion of the tokens are
902     /// forwarded to a fee recipient.
903     address public feeRecipient;
904 
905     /// @notice The shiftIn fee in bips.
906     uint16 public shiftInFee;
907 
908     /// @notice The shiftOut fee in bips.
909     uint16 public shiftOutFee;
910 
911     /// @notice Each nHash can only be seen once.
912     mapping (bytes32=>bool) public status;
913 
914     // LogShiftIn and LogShiftOut contain a unique `shiftID` that identifies
915     // the mint or burn event.
916     uint256 public nextShiftID = 0;
917 
918     event LogShiftIn(
919         address indexed _to,
920         uint256 _amount,
921         uint256 indexed _shiftID,
922         bytes32 indexed _signedMessageHash
923     );
924     event LogShiftOut(
925         bytes _to,
926         uint256 _amount,
927         uint256 indexed _shiftID,
928         bytes indexed _indexedTo
929     );
930 
931     /// @param _token The ERC20Shifted this Shifter is responsible for.
932     /// @param _feeRecipient The recipient of burning and minting fees.
933     /// @param _mintAuthority The address of the key that can sign mint
934     ///        requests.
935     /// @param _shiftInFee The amount subtracted each shiftIn request and
936     ///        forwarded to the feeRecipient. In BIPS.
937     /// @param _shiftOutFee The amount subtracted each shiftOut request and
938     ///        forwarded to the feeRecipient. In BIPS.
939     constructor(ERC20Shifted _token, address _feeRecipient, address _mintAuthority, uint16 _shiftInFee, uint16 _shiftOutFee, uint256 _minShiftOutAmount) public {
940         minShiftAmount = _minShiftOutAmount;
941         token = _token;
942         mintAuthority = _mintAuthority;
943         shiftInFee = _shiftInFee;
944         shiftOutFee = _shiftOutFee;
945         updateFeeRecipient(_feeRecipient);
946     }
947 
948     /// @notice Allow the owner of the contract to recover funds accidentally
949     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
950     function recoverTokens(address _token) external onlyOwner {
951         if (_token == address(0x0)) {
952             msg.sender.transfer(address(this).balance);
953         } else {
954             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
955         }
956     }
957 
958     // Public functions ////////////////////////////////////////////////////////
959 
960     /// @notice Claims ownership of the token passed in to the constructor.
961     /// `transferStoreOwnership` must have previously been called.
962     /// Anyone can call this function.
963     function claimTokenOwnership() public {
964         token.claimOwnership();
965     }
966 
967     /// @notice Allow the owner to update the owner of the ERC20Shifted token.
968     function transferTokenOwnership(Shifter _nextTokenOwner) public onlyOwner {
969         token.transferOwnership(address(_nextTokenOwner));
970         _nextTokenOwner.claimTokenOwnership();
971     }
972 
973     /// @notice Allow the owner to update the fee recipient.
974     ///
975     /// @param _nextMintAuthority The address to start paying fees to.
976     function updateMintAuthority(address _nextMintAuthority) public onlyOwner {
977         mintAuthority = _nextMintAuthority;
978     }
979 
980     /// @notice Allow the owner to update the minimum shiftOut amount.
981     ///
982     /// @param _minShiftOutAmount The new min shiftOut amount.
983     function updateMinimumShiftOutAmount(uint256 _minShiftOutAmount) public onlyOwner {
984         minShiftAmount = _minShiftOutAmount;
985     }
986 
987     /// @notice Allow the owner to update the fee recipient.
988     ///
989     /// @param _nextFeeRecipient The address to start paying fees to.
990     function updateFeeRecipient(address _nextFeeRecipient) public onlyOwner {
991         // ShiftIn and ShiftOut will fail if the feeRecipient is 0x0
992         require(_nextFeeRecipient != address(0x0), "Shifter: fee recipient cannot be 0x0");
993 
994         feeRecipient = _nextFeeRecipient;
995     }
996 
997     /// @notice Allow the owner to update the shiftIn fee.
998     ///
999     /// @param _nextFee The new fee for minting and burning.
1000     function updateShiftInFee(uint16 _nextFee) public onlyOwner {
1001         shiftInFee = _nextFee;
1002     }
1003 
1004     /// @notice Allow the owner to update the shiftOut fee.
1005     ///
1006     /// @param _nextFee The new fee for minting and burning.
1007     function updateShiftOutFee(uint16 _nextFee) public onlyOwner {
1008         shiftOutFee = _nextFee;
1009     }
1010 
1011     /// @notice shiftIn mints tokens after taking a fee for the `_feeRecipient`.
1012     ///
1013     /// @param _pHash (payload hash) The hash of the payload associated with the
1014     ///        shift.
1015     /// @param _amount The amount of the token being shifted int, in its
1016     ///        smallest value. (e.g. satoshis for BTC)
1017     /// @param _nHash (nonce hash) The hash of the nonce, amount and pHash.
1018     /// @param _sig The signature of the hash of the following values:
1019     ///        (pHash, amount, msg.sender, nHash), signed by the mintAuthority.
1020     function shiftIn(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes memory _sig) public returns (uint256) {
1021         // Verify signature
1022         bytes32 signedMessageHash = hashForSignature(_pHash, _amount, msg.sender, _nHash);
1023         require(status[signedMessageHash] == false, "Shifter: nonce hash already spent");
1024         if (!verifySignature(signedMessageHash, _sig)) {
1025             // Return a detailed string containing the hash and recovered
1026             // signer. This is a costly operation but is only run in the revert
1027             // branch.
1028             revert(
1029                 String.add4(
1030                     "Shifter: invalid signature - hash: ",
1031                     String.fromBytes32(signedMessageHash),
1032                     ", signer: ",
1033                     String.fromAddress(ECDSA.recover(signedMessageHash, _sig))
1034                 )
1035             );
1036         }
1037         status[signedMessageHash] = true;
1038 
1039         // Mint `amount - fee` for the recipient and mint `fee` for the minter
1040         uint256 absoluteFee = (_amount.mul(shiftInFee)).div(BIPS_DENOMINATOR);
1041         uint256 receivedAmount = _amount.sub(absoluteFee);
1042         token.mint(msg.sender, receivedAmount);
1043         token.mint(feeRecipient, absoluteFee);
1044 
1045         // Emit a log with a unique shift ID
1046         emit LogShiftIn(msg.sender, receivedAmount, nextShiftID, signedMessageHash);
1047         nextShiftID += 1;
1048 
1049         return receivedAmount;
1050     }
1051 
1052     /// @notice shiftOut burns tokens after taking a fee for the `_feeRecipient`.
1053     ///
1054     /// @param _to The address to receive the unshifted digital asset. The
1055     ///        format of this address should be of the destination chain.
1056     ///        For example, when shifting out to Bitcoin, _to should be a
1057     ///        Bitcoin address.
1058     /// @param _amount The amount of the token being shifted out, in its
1059     ///        smallest value. (e.g. satoshis for BTC)
1060     function shiftOut(bytes memory _to, uint256 _amount) public returns (uint256) {
1061         // The recipient must not be empty. Better validation is possible,
1062         // but would need to be customized for each destination ledger.
1063         require(_to.length != 0, "Shifter: to address is empty");
1064         require(_amount >= minShiftAmount, "Shifter: amount is less than the minimum shiftOut amount");
1065 
1066         // Burn full amount and mint fee
1067         uint256 absoluteFee = (_amount.mul(shiftOutFee)).div(BIPS_DENOMINATOR);
1068         token.burn(msg.sender, _amount);
1069         token.mint(feeRecipient, absoluteFee);
1070 
1071         // Emit a log with a unique shift ID
1072         uint256 receivedValue = _amount.sub(absoluteFee);
1073         emit LogShiftOut(_to, receivedValue, nextShiftID, _to);
1074         nextShiftID += 1;
1075 
1076         return receivedValue;
1077     }
1078 
1079     /// @notice verifySignature checks the the provided signature matches the provided
1080     /// parameters.
1081     function verifySignature(bytes32 _signedMessageHash, bytes memory _sig) public view returns (bool) {
1082         return mintAuthority == ECDSA.recover(_signedMessageHash, _sig);
1083     }
1084 
1085     /// @notice hashForSignature hashes the parameters so that they can be signed.
1086     function hashForSignature(bytes32 _pHash, uint256 _amount, address _to, bytes32 _nHash) public view returns (bytes32) {
1087         return keccak256(abi.encode(_pHash, _amount, address(token), _to, _nHash));
1088     }
1089 }
1090 
1091 /// @dev The following are not necessary for deploying BTCShifter or ZECShifter
1092 /// contracts, but are used to track deployments.
1093 contract BTCShifter is Shifter {
1094     constructor(ERC20Shifted _token, address _feeRecipient, address _mintAuthority, uint16 _shiftInFee, uint16 _shiftOutFee, uint256 _minShiftOutAmount)
1095         Shifter(_token, _feeRecipient, _mintAuthority, _shiftInFee, _shiftOutFee, _minShiftOutAmount) public {
1096         }
1097 }
1098 
1099 contract ZECShifter is Shifter {
1100     constructor(ERC20Shifted _token, address _feeRecipient, address _mintAuthority, uint16 _shiftInFee, uint16 _shiftOutFee, uint256 _minShiftOutAmount)
1101         Shifter(_token, _feeRecipient, _mintAuthority, _shiftInFee, _shiftOutFee, _minShiftOutAmount) public {
1102         }
1103 }
1104 
1105 contract BCHShifter is Shifter {
1106     constructor(ERC20Shifted _token, address _feeRecipient, address _mintAuthority, uint16 _shiftInFee, uint16 _shiftOutFee, uint256 _minShiftOutAmount)
1107         Shifter(_token, _feeRecipient, _mintAuthority, _shiftInFee, _shiftOutFee, _minShiftOutAmount) public {
1108         }
1109 }
1110 
1111 /**
1112  * @dev Collection of functions related to the address type
1113  */
1114 library Address {
1115     /**
1116      * @dev Returns true if `account` is a contract.
1117      *
1118      * This test is non-exhaustive, and there may be false-negatives: during the
1119      * execution of a contract's constructor, its address will be reported as
1120      * not containing a contract.
1121      *
1122      * IMPORTANT: It is unsafe to assume that an address for which this
1123      * function returns false is an externally-owned account (EOA) and not a
1124      * contract.
1125      */
1126     function isContract(address account) internal view returns (bool) {
1127         // This method relies in extcodesize, which returns 0 for contracts in
1128         // construction, since the code is only stored at the end of the
1129         // constructor execution.
1130 
1131         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1132         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1133         // for accounts without code, i.e. `keccak256('')`
1134         bytes32 codehash;
1135         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1136         // solhint-disable-next-line no-inline-assembly
1137         assembly { codehash := extcodehash(account) }
1138         return (codehash != 0x0 && codehash != accountHash);
1139     }
1140 
1141     /**
1142      * @dev Converts an `address` into `address payable`. Note that this is
1143      * simply a type cast: the actual underlying value is not changed.
1144      *
1145      * _Available since v2.4.0._
1146      */
1147     function toPayable(address account) internal pure returns (address payable) {
1148         return address(uint160(account));
1149     }
1150 
1151     /**
1152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1153      * `recipient`, forwarding all available gas and reverting on errors.
1154      *
1155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1157      * imposed by `transfer`, making them unable to receive funds via
1158      * `transfer`. {sendValue} removes this limitation.
1159      *
1160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1161      *
1162      * IMPORTANT: because control is transferred to `recipient`, care must be
1163      * taken to not create reentrancy vulnerabilities. Consider using
1164      * {ReentrancyGuard} or the
1165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1166      *
1167      * _Available since v2.4.0._
1168      */
1169     function sendValue(address payable recipient, uint256 amount) internal {
1170         require(address(this).balance >= amount, "Address: insufficient balance");
1171 
1172         // solhint-disable-next-line avoid-call-value
1173         (bool success, ) = recipient.call.value(amount)("");
1174         require(success, "Address: unable to send value, recipient may have reverted");
1175     }
1176 }
1177 
1178 /**
1179  * @title SafeERC20
1180  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1181  * contract returns false). Tokens that return no value (and instead revert or
1182  * throw on failure) are also supported, non-reverting calls are assumed to be
1183  * successful.
1184  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1185  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1186  */
1187 library SafeERC20 {
1188     using SafeMath for uint256;
1189     using Address for address;
1190 
1191     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1192         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1193     }
1194 
1195     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1196         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1197     }
1198 
1199     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1200         // safeApprove should only be called when setting an initial allowance,
1201         // or when resetting it to zero. To increase and decrease it, use
1202         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1203         // solhint-disable-next-line max-line-length
1204         require((value == 0) || (token.allowance(address(this), spender) == 0),
1205             "SafeERC20: approve from non-zero to non-zero allowance"
1206         );
1207         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1208     }
1209 
1210     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1211         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1212         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1213     }
1214 
1215     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1216         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1217         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1218     }
1219 
1220     /**
1221      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1222      * on the return value: the return value is optional (but if data is returned, it must not be false).
1223      * @param token The token targeted by the call.
1224      * @param data The call data (encoded using abi.encode or one of its variants).
1225      */
1226     function callOptionalReturn(IERC20 token, bytes memory data) private {
1227         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1228         // we're implementing it ourselves.
1229 
1230         // A Solidity high level call has three parts:
1231         //  1. The target address is checked to verify it contains contract code
1232         //  2. The call itself is made, and success asserted
1233         //  3. The return value is decoded, which in turn checks the size of the returned data.
1234         // solhint-disable-next-line max-line-length
1235         require(address(token).isContract(), "SafeERC20: call to non-contract");
1236 
1237         // solhint-disable-next-line avoid-low-level-calls
1238         (bool success, bytes memory returndata) = address(token).call(data);
1239         require(success, "SafeERC20: low-level call failed");
1240 
1241         if (returndata.length > 0) { // Return data is optional
1242             // solhint-disable-next-line max-line-length
1243             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1244         }
1245     }
1246 }
1247 
1248 /// @title DEXReserve
1249 /// @notice The DEX Reserve holds the liquidity for a single token pair for the
1250 /// DEX. Anyone can add liquidity, receiving in return a token representing
1251 /// a share in the funds held by the reserve.
1252 contract DEXReserve is ERC20, ERC20Detailed, Ownable {
1253     using SafeMath for uint256;
1254     using SafeERC20 for ERC20;
1255 
1256     uint256 public feeInBIPS;
1257     uint256 public pendingFeeInBIPS;
1258     uint256 public feeChangeBlock;
1259 
1260     ERC20 public baseToken;
1261     ERC20 public token;
1262     event LogAddLiquidity(address _liquidityProvider, uint256 _tokenAmount, uint256 _baseTokenAmount);
1263     event LogDebug(uint256 _rcvAmount);
1264     event LogFeesChanged(uint256 _previousFeeInBIPS, uint256 _newFeeInBIPS);
1265 
1266     constructor (string memory _name, string memory _symbol, uint8 _decimals, ERC20 _baseToken, ERC20 _token, uint256 _feeInBIPS) public ERC20Detailed(_name, _symbol, _decimals) {
1267         baseToken = _baseToken;
1268         token = _token;
1269         feeInBIPS = _feeInBIPS;
1270         pendingFeeInBIPS = _feeInBIPS;
1271     }
1272 
1273     /// @notice Allow anyone to recover funds accidentally sent to the contract.
1274     function recoverTokens(address _token) external onlyOwner {
1275         require(ERC20(_token) != baseToken && ERC20(_token) != token, "not allowed to recover reserve tokens");
1276         ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
1277     }
1278 
1279     /// @notice Allow the reserve manager too update the contract fees.
1280     /// There is a 10 block delay to reduce the chance of front-running trades.
1281     function updateFee(uint256 _pendingFeeInBIPS) external onlyOwner {
1282         if (_pendingFeeInBIPS == pendingFeeInBIPS) {
1283             require(block.number >= feeChangeBlock, "must wait 100 blocks before updating the fee");
1284             emit LogFeesChanged(feeInBIPS, pendingFeeInBIPS);
1285             feeInBIPS = pendingFeeInBIPS;
1286         } else {
1287             // @dev 500 was chosen as an arbitrary limit - the fee should be
1288             // well below that.
1289             require(_pendingFeeInBIPS < 500, "fee must not exceed hard-coded limit");
1290             feeChangeBlock = block.number + 100;
1291             pendingFeeInBIPS = _pendingFeeInBIPS;
1292         }
1293     }
1294 
1295     function buy(address _to, address _from, uint256 _baseTokenAmount) external returns (uint256)  {
1296         require(totalSupply() != 0, "reserve has no funds");
1297         uint256 rcvAmount = calculateBuyRcvAmt(_baseTokenAmount);
1298         baseToken.safeTransferFrom(_from, address(this), _baseTokenAmount);
1299         token.safeTransfer(_to, rcvAmount);
1300         return rcvAmount;
1301     }
1302 
1303     function sell(address _to, address _from, uint256 _tokenAmount) external returns (uint256) {
1304         require(totalSupply() != 0, "reserve has no funds");
1305         uint256 rcvAmount = calculateSellRcvAmt(_tokenAmount);
1306         token.safeTransferFrom(_from, address(this), _tokenAmount);
1307         baseToken.safeTransfer(_to, rcvAmount);
1308         return rcvAmount;
1309     }
1310 
1311     function calculateBuyRcvAmt(uint256 _sendAmt) public view returns (uint256) {
1312         uint256 baseReserve = baseToken.balanceOf(address(this));
1313         uint256 tokenReserve = token.balanceOf(address(this));
1314         uint256 finalQuoteTokenAmount = (baseReserve.mul(tokenReserve)).div(baseReserve.add(_sendAmt));
1315         uint256 rcvAmt = tokenReserve.sub(finalQuoteTokenAmount);
1316         return _removeFees(rcvAmt);
1317     }
1318 
1319     function calculateSellRcvAmt(uint256 _sendAmt) public view returns (uint256) {
1320         uint256 baseReserve = baseToken.balanceOf(address(this));
1321         uint256 tokenReserve = token.balanceOf(address(this));
1322         uint256 finalBaseTokenAmount = (baseReserve.mul(tokenReserve)).div(tokenReserve.add(_sendAmt));
1323         uint256 rcvAmt = baseReserve.sub(finalBaseTokenAmount);
1324         return _removeFees(rcvAmt);
1325     }
1326 
1327     function removeLiquidity(uint256 _liquidity) external returns (uint256, uint256) {
1328         require(balanceOf(msg.sender) >= _liquidity, "insufficient balance");
1329         uint256 baseTokenAmount = calculateBaseTokenValue(_liquidity);
1330         uint256 quoteTokenAmount = calculateQuoteTokenValue(_liquidity);
1331         _burn(msg.sender, _liquidity);
1332         baseToken.safeTransfer(msg.sender, baseTokenAmount);
1333         token.safeTransfer(msg.sender, quoteTokenAmount);
1334         return (baseTokenAmount, quoteTokenAmount);
1335     }
1336 
1337     function addLiquidity(
1338         address _liquidityProvider, uint256 _maxBaseToken, uint256 _tokenAmount, uint256 _deadline
1339         ) external returns (uint256) {
1340         require(block.number <= _deadline, "addLiquidity request expired");
1341         uint256 liquidity = calculateExpectedLiquidity(_tokenAmount); 
1342         if (totalSupply() > 0) {
1343             require(_tokenAmount > 0, "token amount is less than allowed min amount");
1344             uint256 baseAmount = expectedBaseTokenAmount(_tokenAmount);
1345             require(baseAmount <= _maxBaseToken, "calculated base amount exceeds the maximum amount set");
1346             baseToken.safeTransferFrom(_liquidityProvider, address(this), baseAmount);
1347             emit LogAddLiquidity(_liquidityProvider, _tokenAmount, baseAmount);
1348         } else {
1349             baseToken.safeTransferFrom(_liquidityProvider, address(this), _maxBaseToken);
1350             emit LogAddLiquidity(_liquidityProvider, _tokenAmount, _maxBaseToken);
1351         }
1352         token.safeTransferFrom(msg.sender, address(this), _tokenAmount);
1353         _mint(_liquidityProvider, liquidity);
1354         return liquidity;
1355     }
1356 
1357     function calculateBaseTokenValue(uint256 _liquidity) public view returns (uint256) {
1358         require(totalSupply() != 0, "division by zero");
1359         uint256 baseReserve = baseToken.balanceOf(address(this));
1360         return (_liquidity * baseReserve)/totalSupply();
1361     }
1362 
1363     function calculateQuoteTokenValue(uint256 _liquidity) public view returns (uint256) {
1364         require(totalSupply() != 0,  "division by zero");
1365         uint256 tokenReserve = token.balanceOf(address(this));
1366         return (_liquidity * tokenReserve)/totalSupply();
1367     }
1368 
1369     function expectedBaseTokenAmount(uint256 _quoteTokenAmount) public view returns (uint256) {
1370         uint256 baseReserve = baseToken.balanceOf(address(this));
1371         uint256 tokenReserve = token.balanceOf(address(this));
1372         return (_quoteTokenAmount * baseReserve)/tokenReserve;
1373     }
1374 
1375     function calculateExpectedLiquidity(uint256 _tokenAmount) public view returns (uint256) {
1376         if (totalSupply() == 0) {
1377             return _tokenAmount*2;
1378         }
1379         return ((totalSupply()*_tokenAmount)/token.balanceOf(address(this)));
1380     }
1381 
1382     function _removeFees(uint256 _amount) internal view returns (uint256) {
1383         return (_amount * (10000 - feeInBIPS))/10000;
1384     }
1385 }
1386 
1387 /* solhint-disable-next-line */ /* solium-disable-next-line */
1388 contract BTC_DAI_Reserve is DEXReserve {
1389     constructor (ERC20 _baseToken, ERC20 _token, uint256 _feeInBIPS) public DEXReserve("Bitcoin Liquidity Token", "BTCLT", 8, _baseToken, _token, _feeInBIPS) {
1390     }
1391 }
1392 
1393 /* solhint-disable-next-line */ /* solium-disable-next-line */
1394 contract ZEC_DAI_Reserve is DEXReserve {
1395     constructor (ERC20 _baseToken, ERC20 _token, uint256 _feeInBIPS) public DEXReserve("ZCash Liquidity Token", "ZECLT", 8, _baseToken, _token, _feeInBIPS) {
1396     }
1397 }
1398 
1399 /* solhint-disable-next-line */ /* solium-disable-next-line */
1400 contract BCH_DAI_Reserve is DEXReserve {
1401     constructor (ERC20 _baseToken, ERC20 _token, uint256 _feeInBIPS) public DEXReserve("BitcoinCash Liquidity Token", "BCHLT", 8, _baseToken, _token, _feeInBIPS) {
1402     }
1403 }
1404 
1405 /// @title DEX
1406 /// @notice The DEX contract stores the reserves for each token pair and
1407 /// provides functions for interacting with them:
1408 ///   1) the view-function `calculateReceiveAmount` for calculating how much
1409 ///      the user will receive in exchange for their tokens
1410 ///   2) the function `trade` for executing a swap. If one of the tokens is the
1411 ///      base token, this will only talk to one reserve. If neither of the
1412 ///      tokens are, then the trade will settle across two reserves.
1413 ///
1414 /// The DEX is ownable, allowing a DEX operator to register new reserves.
1415 /// Once a reserve has been registered, it can't be updated.
1416 contract DEX is Claimable {
1417     mapping (address=>DEXReserve) public reserves;
1418     address public baseToken;
1419 
1420     event LogTrade(address _src, address _dst, uint256 _sendAmount, uint256 _recvAmount);
1421 
1422     /// @param _baseToken The reserves must all have a common base token.
1423     constructor(address _baseToken) public {
1424         baseToken = _baseToken;
1425     }
1426 
1427     /// @notice Allow the owner to recover funds accidentally sent to the
1428     /// contract. To withdraw ETH, the token should be set to `0x0`.
1429     function recoverTokens(address _token) external onlyOwner {
1430         if (_token == address(0x0)) {
1431             msg.sender.transfer(address(this).balance);
1432         } else {
1433             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
1434         }
1435     }
1436 
1437     /// @notice The DEX operator is able to register new reserves.
1438     /// @param _erc20 The token that can be traded against the base token.
1439     /// @param _reserve The address of the reserve contract. It must follow the
1440     ///        DEXReserve interface.
1441     function registerReserve(address _erc20, DEXReserve _reserve) external onlyOwner {
1442         require(reserves[_erc20] == DEXReserve(0x0), "token reserve already registered");
1443         reserves[_erc20] = _reserve;
1444     }
1445 
1446     /// @notice The main trade function to execute swaps.
1447     /// @param _to The address at which the DST tokens should be sent to.
1448     /// @param _src The address of the token being spent.
1449     /// @param _dst The address of the token being received.
1450     /// @param _sendAmount The amount of the source token being traded.
1451     function trade(address _to, address _src, address _dst, uint256 _sendAmount) public returns (uint256) {
1452         uint256 recvAmount;
1453         if (_src == baseToken) {
1454             require(reserves[_dst] != DEXReserve(0x0), "unsupported token");
1455             recvAmount = reserves[_dst].buy(_to, msg.sender, _sendAmount);
1456         } else if (_dst == baseToken) {
1457             require(reserves[_src] != DEXReserve(0x0), "unsupported token");
1458             recvAmount = reserves[_src].sell(_to, msg.sender, _sendAmount);
1459         } else {
1460             require(reserves[_src] != DEXReserve(0x0) && reserves[_dst] != DEXReserve(0x0), "unsupported token");
1461             uint256 intermediteAmount = reserves[_src].sell(address(this), msg.sender, _sendAmount);
1462             ERC20(baseToken).approve(address(reserves[_dst]), intermediteAmount);
1463             recvAmount = reserves[_dst].buy(_to, address(this), intermediteAmount);
1464         }
1465         emit LogTrade(_src, _dst, _sendAmount, recvAmount);
1466         return recvAmount;
1467     }
1468 
1469     /// @notice A read-only function to estimate the amount of DST tokens the
1470     /// trader would receive for the send amount.
1471     /// @param _src The address of the token being spent.
1472     /// @param _dst The address of the token being received.
1473     /// @param _sendAmount The amount of the source token being traded.
1474     function calculateReceiveAmount(address _src, address _dst, uint256 _sendAmount) public view returns (uint256) {
1475         if (_src == baseToken) {
1476             return reserves[_dst].calculateBuyRcvAmt(_sendAmount);
1477         }
1478         if (_dst == baseToken) {
1479             return reserves[_src].calculateSellRcvAmt(_sendAmount);
1480         }
1481         return reserves[_dst].calculateBuyRcvAmt(reserves[_src].calculateSellRcvAmt(_sendAmount));
1482     }
1483 }
1484 
1485 /**
1486  * @notice LinkedList is a library for a circular double linked list.
1487  */
1488 library LinkedList {
1489 
1490     /*
1491     * @notice A permanent NULL node (0x0) in the circular double linked list.
1492     * NULL.next is the head, and NULL.previous is the tail.
1493     */
1494     address public constant NULL = address(0);
1495 
1496     /**
1497     * @notice A node points to the node before it, and the node after it. If
1498     * node.previous = NULL, then the node is the head of the list. If
1499     * node.next = NULL, then the node is the tail of the list.
1500     */
1501     struct Node {
1502         bool inList;
1503         address previous;
1504         address next;
1505     }
1506 
1507     /**
1508     * @notice LinkedList uses a mapping from address to nodes. Each address
1509     * uniquely identifies a node, and in this way they are used like pointers.
1510     */
1511     struct List {
1512         mapping (address => Node) list;
1513     }
1514 
1515     /**
1516     * @notice Insert a new node before an existing node.
1517     *
1518     * @param self The list being used.
1519     * @param target The existing node in the list.
1520     * @param newNode The next node to insert before the target.
1521     */
1522     function insertBefore(List storage self, address target, address newNode) internal {
1523         require(!isInList(self, newNode), "LinkedList: already in list");
1524         require(isInList(self, target) || target == NULL, "LinkedList: not in list");
1525 
1526         // It is expected that this value is sometimes NULL.
1527         address prev = self.list[target].previous;
1528 
1529         self.list[newNode].next = target;
1530         self.list[newNode].previous = prev;
1531         self.list[target].previous = newNode;
1532         self.list[prev].next = newNode;
1533 
1534         self.list[newNode].inList = true;
1535     }
1536 
1537     /**
1538     * @notice Insert a new node after an existing node.
1539     *
1540     * @param self The list being used.
1541     * @param target The existing node in the list.
1542     * @param newNode The next node to insert after the target.
1543     */
1544     function insertAfter(List storage self, address target, address newNode) internal {
1545         require(!isInList(self, newNode), "LinkedList: already in list");
1546         require(isInList(self, target) || target == NULL, "LinkedList: not in list");
1547 
1548         // It is expected that this value is sometimes NULL.
1549         address n = self.list[target].next;
1550 
1551         self.list[newNode].previous = target;
1552         self.list[newNode].next = n;
1553         self.list[target].next = newNode;
1554         self.list[n].previous = newNode;
1555 
1556         self.list[newNode].inList = true;
1557     }
1558 
1559     /**
1560     * @notice Remove a node from the list, and fix the previous and next
1561     * pointers that are pointing to the removed node. Removing anode that is not
1562     * in the list will do nothing.
1563     *
1564     * @param self The list being using.
1565     * @param node The node in the list to be removed.
1566     */
1567     function remove(List storage self, address node) internal {
1568         require(isInList(self, node), "LinkedList: not in list");
1569         if (node == NULL) {
1570             return;
1571         }
1572         address p = self.list[node].previous;
1573         address n = self.list[node].next;
1574 
1575         self.list[p].next = n;
1576         self.list[n].previous = p;
1577 
1578         // Deleting the node should set this value to false, but we set it here for
1579         // explicitness.
1580         self.list[node].inList = false;
1581         delete self.list[node];
1582     }
1583 
1584     /**
1585     * @notice Insert a node at the beginning of the list.
1586     *
1587     * @param self The list being used.
1588     * @param node The node to insert at the beginning of the list.
1589     */
1590     function prepend(List storage self, address node) internal {
1591         // isInList(node) is checked in insertBefore
1592 
1593         insertBefore(self, begin(self), node);
1594     }
1595 
1596     /**
1597     * @notice Insert a node at the end of the list.
1598     *
1599     * @param self The list being used.
1600     * @param node The node to insert at the end of the list.
1601     */
1602     function append(List storage self, address node) internal {
1603         // isInList(node) is checked in insertBefore
1604 
1605         insertAfter(self, end(self), node);
1606     }
1607 
1608     function swap(List storage self, address left, address right) internal {
1609         // isInList(left) and isInList(right) are checked in remove
1610 
1611         address previousRight = self.list[right].previous;
1612         remove(self, right);
1613         insertAfter(self, left, right);
1614         remove(self, left);
1615         insertAfter(self, previousRight, left);
1616     }
1617 
1618     function isInList(List storage self, address node) internal view returns (bool) {
1619         return self.list[node].inList;
1620     }
1621 
1622     /**
1623     * @notice Get the node at the beginning of a double linked list.
1624     *
1625     * @param self The list being used.
1626     *
1627     * @return A address identifying the node at the beginning of the double
1628     * linked list.
1629     */
1630     function begin(List storage self) internal view returns (address) {
1631         return self.list[NULL].next;
1632     }
1633 
1634     /**
1635     * @notice Get the node at the end of a double linked list.
1636     *
1637     * @param self The list being used.
1638     *
1639     * @return A address identifying the node at the end of the double linked
1640     * list.
1641     */
1642     function end(List storage self) internal view returns (address) {
1643         return self.list[NULL].previous;
1644     }
1645 
1646     function next(List storage self, address node) internal view returns (address) {
1647         require(isInList(self, node), "LinkedList: not in list");
1648         return self.list[node].next;
1649     }
1650 
1651     function previous(List storage self, address node) internal view returns (address) {
1652         require(isInList(self, node), "LinkedList: not in list");
1653         return self.list[node].previous;
1654     }
1655 
1656 }
1657 
1658 interface IShifter {
1659     function shiftIn(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes calldata _sig) external returns (uint256);
1660     function shiftOut(bytes calldata _to, uint256 _amount) external returns (uint256);
1661     function shiftInFee() external view returns (uint256);
1662     function shiftOutFee() external view returns (uint256);
1663 }
1664 
1665 /// @notice ShifterRegistry is a mapping from assets to their associated
1666 /// ERC20Shifted and Shifter contracts.
1667 contract ShifterRegistry is Claimable {
1668 
1669     /// @dev The symbol is included twice because strings have to be hashed
1670     /// first in order to be used as a log index/topic.
1671     event LogShifterRegistered(string _symbol, string indexed _indexedSymbol, address indexed _tokenAddress, address indexed _shifterAddress);
1672     event LogShifterDeregistered(string _symbol, string indexed _indexedSymbol, address indexed _tokenAddress, address indexed _shifterAddress);
1673     event LogShifterUpdated(address indexed _tokenAddress, address indexed _currentShifterAddress, address indexed _newShifterAddress);
1674 
1675     /// @notice The number of shifters registered
1676     uint256 numShifters = 0;
1677 
1678     /// @notice A list of shifter contracts
1679     LinkedList.List private shifterList;
1680 
1681     /// @notice A list of shifted token contracts
1682     LinkedList.List private shiftedTokenList;
1683 
1684     /// @notice A map of token addresses to canonical shifter addresses
1685     mapping (address=>address) private shifterByToken;
1686 
1687     /// @notice A map of token symbols to canonical shifter addresses
1688     mapping (string=>address) private tokenBySymbol;
1689 
1690     /// @notice Allow the owner of the contract to recover funds accidentally
1691     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
1692     function recoverTokens(address _token) external onlyOwner {
1693         if (_token == address(0x0)) {
1694             msg.sender.transfer(address(this).balance);
1695         } else {
1696             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
1697         }
1698     }
1699 
1700     /// @notice Allow the owner to set the shifter address for a given
1701     ///         ERC20Shifted token contract.
1702     ///
1703     /// @param _tokenAddress The address of the ERC20Shifted token contract.
1704     /// @param _shifterAddress The address of the Shifter contract.
1705     function setShifter(address _tokenAddress, address _shifterAddress) external onlyOwner {
1706         // Check that token, shifter and symbol haven't already been registered
1707         require(!LinkedList.isInList(shifterList, _shifterAddress), "ShifterRegistry: shifter already registered");
1708         require(shifterByToken[_tokenAddress] == address(0x0), "ShifterRegistry: token already registered");
1709         string memory symbol = ERC20Shifted(_tokenAddress).symbol();
1710         require(tokenBySymbol[symbol] == address(0x0), "ShifterRegistry: symbol already registered");
1711 
1712         // Add to list of shifters
1713         LinkedList.append(shifterList, _shifterAddress);
1714 
1715         // Add to list of shifted tokens
1716         LinkedList.append(shiftedTokenList, _tokenAddress);
1717 
1718         tokenBySymbol[symbol] = _tokenAddress;
1719         shifterByToken[_tokenAddress] = _shifterAddress;
1720         numShifters += 1;
1721 
1722         emit LogShifterRegistered(symbol, symbol, _tokenAddress, _shifterAddress);
1723     }
1724 
1725     /// @notice Allow the owner to update the shifter address for a given
1726     ///         ERC20Shifted token contract.
1727     ///
1728     /// @param _tokenAddress The address of the ERC20Shifted token contract.
1729     /// @param _newShifterAddress The updated address of the Shifter contract.
1730     function updateShifter(address _tokenAddress, address _newShifterAddress) external onlyOwner {
1731         // Check that token, shifter are registered
1732         address currentShifter = shifterByToken[_tokenAddress];
1733         require(shifterByToken[_tokenAddress] != address(0x0), "ShifterRegistry: token not registered");
1734 
1735         // Remove to list of shifters
1736         LinkedList.remove(shifterList, currentShifter);
1737 
1738         // Add to list of shifted tokens
1739         LinkedList.append(shifterList, _newShifterAddress);
1740 
1741         shifterByToken[_tokenAddress] = _newShifterAddress;
1742 
1743         emit LogShifterUpdated(_tokenAddress, currentShifter, _newShifterAddress);
1744     }
1745 
1746     /// @notice Allows the owner to remove the shifter address for a given
1747     ///         ERC20shifter token contract.
1748     ///
1749     /// @param _symbol The symbol of the token to deregister.
1750     function removeShifter(string calldata _symbol) external onlyOwner {
1751         // Look up token address
1752         address tokenAddress = tokenBySymbol[_symbol];
1753         require(tokenAddress != address(0x0), "ShifterRegistry: symbol not registered");
1754 
1755         // Look up shifter address
1756         address shifterAddress = shifterByToken[tokenAddress];
1757 
1758         // Remove token and shifter
1759         shifterByToken[tokenAddress] = address(0x0);
1760         tokenBySymbol[_symbol] = address(0x0);
1761         LinkedList.remove(shifterList, shifterAddress);
1762         LinkedList.remove(shiftedTokenList, tokenAddress);
1763         numShifters -= 1;
1764 
1765         emit LogShifterDeregistered(_symbol, _symbol, tokenAddress, shifterAddress);
1766     }
1767 
1768     /// @dev To get all the registered shifters use count = 0.
1769     function getShifters(address _start, uint256 _count) external view returns (address[] memory) {
1770         uint256 count;
1771         if (_count == 0) {
1772             count = numShifters;
1773         } else {
1774             count = _count;
1775         }
1776 
1777         address[] memory shifters = new address[](count);
1778 
1779         // Begin with the first node in the list
1780         uint256 n = 0;
1781         address next = _start;
1782         if (next == address(0)) {
1783             next = LinkedList.begin(shifterList);
1784         }
1785 
1786         while (n < count) {
1787             if (next == address(0)) {
1788                 break;
1789             }
1790             shifters[n] = next;
1791             next = LinkedList.next(shifterList, next);
1792             n += 1;
1793         }
1794         return shifters;
1795     }
1796 
1797     /// @dev To get all the registered shifted tokens use count = 0.
1798     function getShiftedTokens(address _start, uint256 _count) external view returns (address[] memory) {
1799         uint256 count;
1800         if (_count == 0) {
1801             count = numShifters;
1802         } else {
1803             count = _count;
1804         }
1805 
1806         address[] memory shiftedTokens = new address[](count);
1807 
1808         // Begin with the first node in the list
1809         uint256 n = 0;
1810         address next = _start;
1811         if (next == address(0)) {
1812             next = LinkedList.begin(shiftedTokenList);
1813         }
1814 
1815         while (n < count) {
1816             if (next == address(0)) {
1817                 break;
1818             }
1819             shiftedTokens[n] = next;
1820             next = LinkedList.next(shiftedTokenList, next);
1821             n += 1;
1822         }
1823         return shiftedTokens;
1824     }
1825 
1826     /// @notice Returns the Shifter address for the given ERC20Shifted token
1827     ///         contract address.
1828     ///
1829     /// @param _tokenAddress The address of the ERC20Shifted token contract.
1830     function getShifterByToken(address _tokenAddress) external view returns (IShifter) {
1831         return IShifter(shifterByToken[_tokenAddress]);
1832     }
1833 
1834     /// @notice Returns the Shifter address for the given ERC20Shifted token
1835     ///         symbol.
1836     ///
1837     /// @param _tokenSymbol The symbol of the ERC20Shifted token contract.
1838     function getShifterBySymbol(string calldata _tokenSymbol) external view returns (IShifter) {
1839         return IShifter(shifterByToken[tokenBySymbol[_tokenSymbol]]);
1840     }
1841 
1842     /// @notice Returns the ERC20Shifted address for the given token symbol.
1843     ///
1844     /// @param _tokenSymbol The symbol of the ERC20Shifted token contract to
1845     ///        lookup.
1846     function getTokenBySymbol(string calldata _tokenSymbol) external view returns (address) {
1847         return tokenBySymbol[_tokenSymbol];
1848     }
1849 }
1850 
1851 contract DEXAdapter {
1852     using SafeERC20 for ERC20;
1853 
1854     DEX public dex;
1855     ShifterRegistry public shifterRegistry;
1856 
1857     event LogTransferIn(address src, uint256 amount);
1858     event LogTransferOut(address dst, uint256 amount);
1859 
1860     constructor(DEX _dex, ShifterRegistry _shifterRegistry) public {
1861         shifterRegistry = _shifterRegistry;
1862         dex = _dex;
1863     }
1864 
1865     /// @notice Allow anyone to recover funds accidentally sent to the contract.
1866     /// To withdraw ETH, the token should be set to `0x0`.
1867     function recoverTokens(address _token) external {
1868         if (_token == address(0x0)) {
1869             msg.sender.transfer(address(this).balance);
1870         } else {
1871             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
1872         }
1873     }
1874 
1875     // TODO: Fix "Stack too deep" error!
1876     uint256 transferredAmt;
1877 
1878     function trade(
1879         // Payload
1880         /*uint256 _relayerFee,*/ address _src, address _dst, uint256 _minDstAmt, bytes calldata _to,
1881         uint256 _refundBN, bytes calldata _refundAddress,
1882         // Required
1883         uint256 _amount, bytes32 _nHash, bytes calldata _sig
1884     ) external {
1885         transferredAmt;
1886         bytes32 pHash = hashTradePayload(_src, _dst, _minDstAmt, _to, _refundBN, _refundAddress);
1887         // Handle refunds if the refund block number has passed
1888         if (block.number >= _refundBN) {
1889             IShifter shifter = shifterRegistry.getShifterByToken(address(_src));
1890             if (shifter != IShifter(0x0)) {
1891                 transferredAmt = shifter.shiftIn(pHash, _amount, _nHash, _sig);
1892                 shifter.shiftOut(_refundAddress, transferredAmt);
1893             }
1894             return;
1895         }
1896 
1897         transferredAmt = _transferIn(_src, _amount, _nHash, pHash, _sig);
1898         emit LogTransferIn(_src, transferredAmt);
1899         _doTrade(_src, _dst, _minDstAmt, _to, transferredAmt);
1900     }
1901 
1902     function hashTradePayload(
1903         /*uint256 _relayerFee,*/ address _src, address _dst, uint256 _minDstAmt, bytes memory _to,
1904         uint256 _refundBN, bytes memory _refundAddress
1905     ) public pure returns (bytes32) {
1906         return keccak256(abi.encode(_src, _dst, _minDstAmt, _to, _refundBN, _refundAddress));
1907     }
1908 
1909     function hashLiquidityPayload(
1910         address _liquidityProvider,  uint256 _maxBaseToken, address _token,
1911         uint256 _refundBN, bytes memory _refundAddress
1912     ) public pure returns (bytes32) {
1913         return keccak256(abi.encode(_liquidityProvider, _maxBaseToken, _token, _refundBN, _refundAddress));
1914     }
1915 
1916     function addLiquidity(
1917         address _liquidityProvider,  uint256 _maxBaseToken, address _token, uint256 _deadline, bytes calldata _refundAddress,
1918         uint256 _amount, bytes32 _nHash, bytes calldata _sig
1919         ) external returns (uint256) {
1920             DEXReserve reserve = dex.reserves(_token);
1921             require(reserve != DEXReserve(0x0), "unsupported token");
1922             bytes32 lpHash = hashLiquidityPayload(_liquidityProvider, _maxBaseToken, _token, _deadline, _refundAddress);
1923             if (block.number > _deadline) {
1924                 uint256 shiftedAmount = shifterRegistry.getShifterByToken(_token).shiftIn(lpHash, _amount, _nHash, _sig);
1925                 shifterRegistry.getShifterByToken(_token).shiftOut(_refundAddress, shiftedAmount);
1926                 return 0;
1927             }
1928             require(ERC20(dex.baseToken()).allowance(_liquidityProvider, address(reserve)) >= _maxBaseToken,
1929                 "insufficient base token allowance");
1930             uint256 transferredAmount = _transferIn(_token, _amount, _nHash, lpHash, _sig);
1931             ERC20(_token).approve(address(reserve), transferredAmount);
1932             return reserve.addLiquidity(_liquidityProvider, _maxBaseToken, transferredAmount, _deadline);
1933     }
1934 
1935     function removeLiquidity(address _token, uint256 _liquidity, bytes calldata _tokenAddress) external {
1936         DEXReserve reserve = dex.reserves(_token);
1937         require(reserve != DEXReserve(0x0), "unsupported token");
1938         ERC20(reserve).safeTransferFrom(msg.sender, address(this), _liquidity);
1939         (uint256 baseTokenAmount, uint256 quoteTokenAmount) = reserve.removeLiquidity(_liquidity);
1940         reserve.baseToken().safeTransfer(msg.sender, baseTokenAmount);
1941         shifterRegistry.getShifterByToken(address(reserve.token())).shiftOut(_tokenAddress, quoteTokenAmount);
1942     }
1943 
1944     function _doTrade(
1945         address _src, address _dst, uint256 _minDstAmt, bytes memory _to, uint256 _amount
1946     ) internal {
1947         uint256 recvAmt;
1948         address to;
1949         IShifter shifter = shifterRegistry.getShifterByToken(address(_dst));
1950 
1951         if (shifter != IShifter(0x0)) {
1952             to = address(this);
1953         } else {
1954             to = _bytesToAddress(_to);
1955         }
1956 
1957         if (_src == dex.baseToken()) {
1958             ERC20(_src).approve(address(dex.reserves(_dst)), _amount);
1959         } else {
1960             ERC20(_src).approve(address(dex.reserves(_src)), _amount);
1961         }
1962         recvAmt = dex.trade(to, _src, _dst, _amount);
1963 
1964         require(recvAmt > 0 && recvAmt >= _minDstAmt, "invalid receive amount");
1965         if (shifter != IShifter(0x0)) {
1966             shifter.shiftOut(_to, recvAmt);
1967         }
1968         emit LogTransferOut(_dst, recvAmt);
1969     }
1970 
1971     function _transferIn(
1972         /*uint256 _relayerFee,*/ address _src, uint256 _amount,
1973         bytes32 _nHash, bytes32 _pHash, bytes memory _sig
1974     ) internal returns (uint256) {
1975         IShifter shifter = shifterRegistry.getShifterByToken(address(_src));
1976         if (shifter != IShifter(0x0)) {
1977             return shifter.shiftIn(_pHash, _amount, _nHash, _sig);
1978         } else {
1979             ERC20(_src).safeTransferFrom(msg.sender, address(this), _amount);
1980             return _amount;
1981         }
1982     }
1983 
1984     function _bytesToAddress(bytes memory _addr) internal pure returns (address) {
1985         address addr;
1986         /* solhint-disable-next-line */ /* solium-disable-next-line */
1987         assembly {
1988             addr := mload(add(_addr, 20))
1989         }
1990         return addr;
1991     }
1992 
1993     function calculateReceiveAmount(address _src, address _dst, uint256 _sendAmount) public view returns (uint256) {
1994         uint256 sendAmount = _sendAmount;
1995 
1996         // Remove shift-in fees
1997         IShifter srcShifter = shifterRegistry.getShifterByToken(_dst);
1998         if (srcShifter != IShifter(0x0)) {
1999             sendAmount = removeFee(_sendAmount, srcShifter.shiftInFee());
2000         }
2001 
2002         uint256 receiveAmount = dex.calculateReceiveAmount(_src, _dst, sendAmount);
2003 
2004         // Remove shift-out fees
2005         IShifter dstShifter = shifterRegistry.getShifterByToken(_dst);
2006         if (dstShifter != IShifter(0x0)) {
2007             receiveAmount = removeFee(receiveAmount, dstShifter.shiftOutFee());
2008         }
2009 
2010         return receiveAmount;
2011     }
2012 
2013     function removeFee(uint256 _amount, uint256 _feeInBips) private view returns (uint256) {
2014         return _amount - (_amount * _feeInBips)/10000;
2015     }
2016 }