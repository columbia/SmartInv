1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
7  *
8  * These functions can be used to verify that a message was signed by the holder
9  * of the private keys of a given address.
10  */
11 library ECDSA {
12     /**
13      * @dev Returns the address that signed a hashed message (`hash`) with
14      * `signature`. This address can then be used for verification purposes.
15      *
16      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
17      * this function rejects them by requiring the `s` value to be in the lower
18      * half order, and the `v` value to be either 27 or 28.
19      *
20      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
21      * verification to be secure: it is possible to craft signatures that
22      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
23      * this is by receiving a hash of the original message (which may otherwise
24      * be too long), and then calling {toEthSignedMessageHash} on it.
25      */
26     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
27         // Check the signature length
28         if (signature.length != 65) {
29             revert("ECDSA: invalid signature length");
30         }
31 
32         // Divide the signature in r, s and v variables
33         bytes32 r;
34         bytes32 s;
35         uint8 v;
36 
37         // ecrecover takes the signature parameters, and the only way to get them
38         // currently is to use assembly.
39         // solhint-disable-next-line no-inline-assembly
40         assembly {
41             r := mload(add(signature, 0x20))
42             s := mload(add(signature, 0x40))
43             v := byte(0, mload(add(signature, 0x60)))
44         }
45 
46         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
47         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
48         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
49         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
50         //
51         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
52         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
53         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
54         // these malleable signatures as well.
55         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
56             revert("ECDSA: invalid signature 's' value");
57         }
58 
59         if (v != 27 && v != 28) {
60             revert("ECDSA: invalid signature 'v' value");
61         }
62 
63         // If the signature is valid (and not malleable), return the signer address
64         address signer = ecrecover(hash, v, r, s);
65         require(signer != address(0), "ECDSA: invalid signature");
66 
67         return signer;
68     }
69 
70     /**
71      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
72      * replicates the behavior of the
73      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
74      * JSON-RPC method.
75      *
76      * See {recover}.
77      */
78     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
79         // 32 is the length in bytes of hash,
80         // enforced by the type signature above
81         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
82     }
83 }
84 
85 library String {
86     /// @notice Convert a uint value to its decimal string representation
87     // solium-disable-next-line security/no-assign-params
88     function fromUint(uint _i) internal pure returns (string memory) {
89         if (_i == 0) {
90             return "0";
91         }
92         uint j = _i;
93         uint len;
94         while (j != 0) {
95             len++;
96             j /= 10;
97         }
98         bytes memory bstr = new bytes(len);
99         uint k = len - 1;
100         while (_i != 0) {
101             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
102             _i /= 10;
103         }
104         return string(bstr);
105     }
106 
107     /// @notice Convert a bytes32 value to its hex string representation.
108     function fromBytes32(bytes32 _value) internal pure returns (string memory) {
109         bytes memory alphabet = "0123456789abcdef";
110 
111         bytes memory str = new bytes(32 * 2 + 2);
112         str[0] = "0";
113         str[1] = "x";
114         for (uint i = 0; i < 32; i++) {
115             str[2 + i * 2] = alphabet[uint(uint8(_value[i] >> 4))];
116             str[3 + i * 2] = alphabet[uint(uint8(_value[i] & 0x0f))];
117         }
118         return string(str);
119     }
120 
121     /// @notice Convert an address to its hex string representation.
122     function fromAddress(address _addr) internal pure returns (string memory) {
123         bytes32 value = bytes32(uint(_addr));
124         bytes memory alphabet = "0123456789abcdef";
125 
126         bytes memory str = new bytes(20 * 2 + 2);
127         str[0] = "0";
128         str[1] = "x";
129         for (uint i = 0; i < 20; i++) {
130             str[2 + i * 2] = alphabet[uint(uint8(value[i + 12] >> 4))];
131             str[3 + i * 2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
132         }
133         return string(str);
134     }
135 
136     /// @notice Append eight strings.
137     function add8(
138         string memory a,
139         string memory b,
140         string memory c,
141         string memory d,
142         string memory e,
143         string memory f,
144         string memory g,
145         string memory h
146     ) internal pure returns (string memory) {
147         return string(abi.encodePacked(a, b, c, d, e, f, g, h));
148     }
149 }
150 
151 /*
152  * @dev Provides information about the current execution context, including the
153  * sender of the transaction and its data. While these are generally available
154  * via msg.sender and msg.data, they should not be accessed in such a direct
155  * manner, since when dealing with GSN meta-transactions the account sending and
156  * paying for execution may not be the actual sender (as far as an application
157  * is concerned).
158  *
159  * This contract is only required for intermediate, library-like contracts.
160  */
161 abstract contract Context {
162     function _msgSender() internal view virtual returns (address payable) {
163         return msg.sender;
164     }
165 
166     function _msgData() internal view virtual returns (bytes memory) {
167         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
168         return msg.data;
169     }
170 }
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor () internal {
193         address msgSender = _msgSender();
194         _owner = msgSender;
195         emit OwnershipTransferred(address(0), msgSender);
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(_owner == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         emit OwnershipTransferred(_owner, address(0));
222         _owner = address(0);
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         emit OwnershipTransferred(_owner, newOwner);
232         _owner = newOwner;
233     }
234 }
235 
236 /**
237  * @title Initializable
238  *
239  * @dev Helper contract to support initializer functions. To use it, replace
240  * the constructor with a function that has the `initializer` modifier.
241  * WARNING: Unlike constructors, initializer functions must be manually
242  * invoked. This applies both to deploying an Initializable contract, as well
243  * as extending an Initializable contract via inheritance.
244  * WARNING: When used with inheritance, manual care must be taken to not invoke
245  * a parent initializer twice, or ensure that all initializers are idempotent,
246  * because this is not dealt with automatically as with constructors.
247  */
248 contract Initializable {
249 
250   /**
251    * @dev Indicates that the contract has been initialized.
252    */
253   bool private initialized;
254 
255   /**
256    * @dev Indicates that the contract is in the process of being initialized.
257    */
258   bool private initializing;
259 
260   /**
261    * @dev Modifier to use in the initializer function of a contract.
262    */
263   modifier initializer() {
264     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
265 
266     bool isTopLevelCall = !initializing;
267     if (isTopLevelCall) {
268       initializing = true;
269       initialized = true;
270     }
271 
272     _;
273 
274     if (isTopLevelCall) {
275       initializing = false;
276     }
277   }
278 
279   /// @dev Returns true if and only if the function is running in the constructor
280   function isConstructor() private view returns (bool) {
281     // extcodesize checks the size of the code stored in an address, and
282     // address returns the current address. Since the code is still not
283     // deployed when running a constructor, any checks on its code size will
284     // yield zero, making it an effective way to detect if a contract is
285     // under construction or not.
286     address self = address(this);
287     uint256 cs;
288     assembly { cs := extcodesize(self) }
289     return cs == 0;
290   }
291 
292   // Reserved storage space to allow for layout changes in the future.
293   uint256[50] private ______gap;
294 }
295 
296 /*
297  * @dev Provides information about the current execution context, including the
298  * sender of the transaction and its data. While these are generally available
299  * via msg.sender and msg.data, they should not be accessed in such a direct
300  * manner, since when dealing with GSN meta-transactions the account sending and
301  * paying for execution may not be the actual sender (as far as an application
302  * is concerned).
303  *
304  * This contract is only required for intermediate, library-like contracts.
305  */
306 contract ContextUpgradeSafe is Initializable {
307     // Empty internal constructor, to prevent people from mistakenly deploying
308     // an instance of this contract, which should be used via inheritance.
309 
310     function __Context_init() internal initializer {
311         __Context_init_unchained();
312     }
313 
314     function __Context_init_unchained() internal initializer {
315 
316 
317     }
318 
319 
320     function _msgSender() internal view virtual returns (address payable) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes memory) {
325         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
326         return msg.data;
327     }
328 
329     uint256[50] private __gap;
330 }
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Emitted when `value` tokens are moved from one account (`from`) to
393      * another (`to`).
394      *
395      * Note that `value` may be zero.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     /**
400      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
401      * a call to {approve}. `value` is the new allowance.
402      */
403     event Approval(address indexed owner, address indexed spender, uint256 value);
404 }
405 
406 /**
407  * @dev Wrappers over Solidity's arithmetic operations with added overflow
408  * checks.
409  *
410  * Arithmetic operations in Solidity wrap on overflow. This can easily result
411  * in bugs, because programmers usually assume that an overflow raises an
412  * error, which is the standard behavior in high level programming languages.
413  * `SafeMath` restores this intuition by reverting the transaction when an
414  * operation overflows.
415  *
416  * Using this library instead of the unchecked operations eliminates an entire
417  * class of bugs, so it's recommended to use it always.
418  */
419 library SafeMath {
420     /**
421      * @dev Returns the addition of two unsigned integers, reverting on
422      * overflow.
423      *
424      * Counterpart to Solidity's `+` operator.
425      *
426      * Requirements:
427      * - Addition cannot overflow.
428      */
429     function add(uint256 a, uint256 b) internal pure returns (uint256) {
430         uint256 c = a + b;
431         require(c >= a, "SafeMath: addition overflow");
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the subtraction of two unsigned integers, reverting on
438      * overflow (when the result is negative).
439      *
440      * Counterpart to Solidity's `-` operator.
441      *
442      * Requirements:
443      * - Subtraction cannot overflow.
444      */
445     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446         return sub(a, b, "SafeMath: subtraction overflow");
447     }
448 
449     /**
450      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
451      * overflow (when the result is negative).
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      * - Subtraction cannot overflow.
457      */
458     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
459         require(b <= a, errorMessage);
460         uint256 c = a - b;
461 
462         return c;
463     }
464 
465     /**
466      * @dev Returns the multiplication of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `*` operator.
470      *
471      * Requirements:
472      * - Multiplication cannot overflow.
473      */
474     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
475         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
476         // benefit is lost if 'b' is also tested.
477         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
478         if (a == 0) {
479             return 0;
480         }
481 
482         uint256 c = a * b;
483         require(c / a == b, "SafeMath: multiplication overflow");
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the integer division of two unsigned integers. Reverts on
490      * division by zero. The result is rounded towards zero.
491      *
492      * Counterpart to Solidity's `/` operator. Note: this function uses a
493      * `revert` opcode (which leaves remaining gas untouched) while Solidity
494      * uses an invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      * - The divisor cannot be zero.
498      */
499     function div(uint256 a, uint256 b) internal pure returns (uint256) {
500         return div(a, b, "SafeMath: division by zero");
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
505      * division by zero. The result is rounded towards zero.
506      *
507      * Counterpart to Solidity's `/` operator. Note: this function uses a
508      * `revert` opcode (which leaves remaining gas untouched) while Solidity
509      * uses an invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      * - The divisor cannot be zero.
513      */
514     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         // Solidity only automatically asserts when dividing by 0
516         require(b > 0, errorMessage);
517         uint256 c = a / b;
518         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
519 
520         return c;
521     }
522 
523     /**
524      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
525      * Reverts when dividing by zero.
526      *
527      * Counterpart to Solidity's `%` operator. This function uses a `revert`
528      * opcode (which leaves remaining gas untouched) while Solidity uses an
529      * invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      * - The divisor cannot be zero.
533      */
534     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
535         return mod(a, b, "SafeMath: modulo by zero");
536     }
537 
538     /**
539      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
540      * Reverts with custom message when dividing by zero.
541      *
542      * Counterpart to Solidity's `%` operator. This function uses a `revert`
543      * opcode (which leaves remaining gas untouched) while Solidity uses an
544      * invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      * - The divisor cannot be zero.
548      */
549     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
550         require(b != 0, errorMessage);
551         return a % b;
552     }
553 }
554 
555 /**
556  * @dev Collection of functions related to the address type
557  */
558 library Address {
559     /**
560      * @dev Returns true if `account` is a contract.
561      *
562      * [IMPORTANT]
563      * ====
564      * It is unsafe to assume that an address for which this function returns
565      * false is an externally-owned account (EOA) and not a contract.
566      *
567      * Among others, `isContract` will return false for the following
568      * types of addresses:
569      *
570      *  - an externally-owned account
571      *  - a contract in construction
572      *  - an address where a contract will be created
573      *  - an address where a contract lived, but was destroyed
574      * ====
575      */
576     function isContract(address account) internal view returns (bool) {
577         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
578         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
579         // for accounts without code, i.e. `keccak256('')`
580         bytes32 codehash;
581         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
582         // solhint-disable-next-line no-inline-assembly
583         assembly { codehash := extcodehash(account) }
584         return (codehash != accountHash && codehash != 0x0);
585     }
586 
587     /**
588      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
589      * `recipient`, forwarding all available gas and reverting on errors.
590      *
591      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
592      * of certain opcodes, possibly making contracts go over the 2300 gas limit
593      * imposed by `transfer`, making them unable to receive funds via
594      * `transfer`. {sendValue} removes this limitation.
595      *
596      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
597      *
598      * IMPORTANT: because control is transferred to `recipient`, care must be
599      * taken to not create reentrancy vulnerabilities. Consider using
600      * {ReentrancyGuard} or the
601      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
602      */
603     function sendValue(address payable recipient, uint256 amount) internal {
604         require(address(this).balance >= amount, "Address: insufficient balance");
605 
606         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
607         (bool success, ) = recipient.call{ value: amount }("");
608         require(success, "Address: unable to send value, recipient may have reverted");
609     }
610 }
611 
612 /**
613  * @dev Implementation of the {IERC20} interface.
614  *
615  * This implementation is agnostic to the way tokens are created. This means
616  * that a supply mechanism has to be added in a derived contract using {_mint}.
617  * For a generic mechanism see {ERC20MinterPauser}.
618  *
619  * TIP: For a detailed writeup see our guide
620  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
621  * to implement supply mechanisms].
622  *
623  * We have followed general OpenZeppelin guidelines: functions revert instead
624  * of returning `false` on failure. This behavior is nonetheless conventional
625  * and does not conflict with the expectations of ERC20 applications.
626  *
627  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
628  * This allows applications to reconstruct the allowance for all accounts just
629  * by listening to said events. Other implementations of the EIP may not emit
630  * these events, as it isn't required by the specification.
631  *
632  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
633  * functions have been added to mitigate the well-known issues around setting
634  * allowances. See {IERC20-approve}.
635  */
636 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
637     using SafeMath for uint256;
638     using Address for address;
639 
640     mapping (address => uint256) private _balances;
641 
642     mapping (address => mapping (address => uint256)) private _allowances;
643 
644     uint256 private _totalSupply;
645 
646     string private _name;
647     string private _symbol;
648     uint8 private _decimals;
649 
650     /**
651      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
652      * a default value of 18.
653      *
654      * To select a different value for {decimals}, use {_setupDecimals}.
655      *
656      * All three of these values are immutable: they can only be set once during
657      * construction.
658      */
659 
660     function __ERC20_init(string memory name, string memory symbol) internal initializer {
661         __Context_init_unchained();
662         __ERC20_init_unchained(name, symbol);
663     }
664 
665     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
666 
667 
668         _name = name;
669         _symbol = symbol;
670         _decimals = 18;
671 
672     }
673 
674 
675     /**
676      * @dev Returns the name of the token.
677      */
678     function name() public view returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @dev Returns the symbol of the token, usually a shorter version of the
684      * name.
685      */
686     function symbol() public view returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev Returns the number of decimals used to get its user representation.
692      * For example, if `decimals` equals `2`, a balance of `505` tokens should
693      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
694      *
695      * Tokens usually opt for a value of 18, imitating the relationship between
696      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
697      * called.
698      *
699      * NOTE: This information is only used for _display_ purposes: it in
700      * no way affects any of the arithmetic of the contract, including
701      * {IERC20-balanceOf} and {IERC20-transfer}.
702      */
703     function decimals() public view returns (uint8) {
704         return _decimals;
705     }
706 
707     /**
708      * @dev See {IERC20-totalSupply}.
709      */
710     function totalSupply() public view override returns (uint256) {
711         return _totalSupply;
712     }
713 
714     /**
715      * @dev See {IERC20-balanceOf}.
716      */
717     function balanceOf(address account) public view override returns (uint256) {
718         return _balances[account];
719     }
720 
721     /**
722      * @dev See {IERC20-transfer}.
723      *
724      * Requirements:
725      *
726      * - `recipient` cannot be the zero address.
727      * - the caller must have a balance of at least `amount`.
728      */
729     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
730         _transfer(_msgSender(), recipient, amount);
731         return true;
732     }
733 
734     /**
735      * @dev See {IERC20-allowance}.
736      */
737     function allowance(address owner, address spender) public view virtual override returns (uint256) {
738         return _allowances[owner][spender];
739     }
740 
741     /**
742      * @dev See {IERC20-approve}.
743      *
744      * Requirements:
745      *
746      * - `spender` cannot be the zero address.
747      */
748     function approve(address spender, uint256 amount) public virtual override returns (bool) {
749         _approve(_msgSender(), spender, amount);
750         return true;
751     }
752 
753     /**
754      * @dev See {IERC20-transferFrom}.
755      *
756      * Emits an {Approval} event indicating the updated allowance. This is not
757      * required by the EIP. See the note at the beginning of {ERC20};
758      *
759      * Requirements:
760      * - `sender` and `recipient` cannot be the zero address.
761      * - `sender` must have a balance of at least `amount`.
762      * - the caller must have allowance for ``sender``'s tokens of at least
763      * `amount`.
764      */
765     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
766         _transfer(sender, recipient, amount);
767         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
768         return true;
769     }
770 
771     /**
772      * @dev Atomically increases the allowance granted to `spender` by the caller.
773      *
774      * This is an alternative to {approve} that can be used as a mitigation for
775      * problems described in {IERC20-approve}.
776      *
777      * Emits an {Approval} event indicating the updated allowance.
778      *
779      * Requirements:
780      *
781      * - `spender` cannot be the zero address.
782      */
783     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
784         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
785         return true;
786     }
787 
788     /**
789      * @dev Atomically decreases the allowance granted to `spender` by the caller.
790      *
791      * This is an alternative to {approve} that can be used as a mitigation for
792      * problems described in {IERC20-approve}.
793      *
794      * Emits an {Approval} event indicating the updated allowance.
795      *
796      * Requirements:
797      *
798      * - `spender` cannot be the zero address.
799      * - `spender` must have allowance for the caller of at least
800      * `subtractedValue`.
801      */
802     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
803         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
804         return true;
805     }
806 
807     /**
808      * @dev Moves tokens `amount` from `sender` to `recipient`.
809      *
810      * This is internal function is equivalent to {transfer}, and can be used to
811      * e.g. implement automatic token fees, slashing mechanisms, etc.
812      *
813      * Emits a {Transfer} event.
814      *
815      * Requirements:
816      *
817      * - `sender` cannot be the zero address.
818      * - `recipient` cannot be the zero address.
819      * - `sender` must have a balance of at least `amount`.
820      */
821     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
822         require(sender != address(0), "ERC20: transfer from the zero address");
823         require(recipient != address(0), "ERC20: transfer to the zero address");
824 
825         _beforeTokenTransfer(sender, recipient, amount);
826 
827         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
828         _balances[recipient] = _balances[recipient].add(amount);
829         emit Transfer(sender, recipient, amount);
830     }
831 
832     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
833      * the total supply.
834      *
835      * Emits a {Transfer} event with `from` set to the zero address.
836      *
837      * Requirements
838      *
839      * - `to` cannot be the zero address.
840      */
841     function _mint(address account, uint256 amount) internal virtual {
842         require(account != address(0), "ERC20: mint to the zero address");
843 
844         _beforeTokenTransfer(address(0), account, amount);
845 
846         _totalSupply = _totalSupply.add(amount);
847         _balances[account] = _balances[account].add(amount);
848         emit Transfer(address(0), account, amount);
849     }
850 
851     /**
852      * @dev Destroys `amount` tokens from `account`, reducing the
853      * total supply.
854      *
855      * Emits a {Transfer} event with `to` set to the zero address.
856      *
857      * Requirements
858      *
859      * - `account` cannot be the zero address.
860      * - `account` must have at least `amount` tokens.
861      */
862     function _burn(address account, uint256 amount) internal virtual {
863         require(account != address(0), "ERC20: burn from the zero address");
864 
865         _beforeTokenTransfer(account, address(0), amount);
866 
867         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
868         _totalSupply = _totalSupply.sub(amount);
869         emit Transfer(account, address(0), amount);
870     }
871 
872     /**
873      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
874      *
875      * This is internal function is equivalent to `approve`, and can be used to
876      * e.g. set automatic allowances for certain subsystems, etc.
877      *
878      * Emits an {Approval} event.
879      *
880      * Requirements:
881      *
882      * - `owner` cannot be the zero address.
883      * - `spender` cannot be the zero address.
884      */
885     function _approve(address owner, address spender, uint256 amount) internal virtual {
886         require(owner != address(0), "ERC20: approve from the zero address");
887         require(spender != address(0), "ERC20: approve to the zero address");
888 
889         _allowances[owner][spender] = amount;
890         emit Approval(owner, spender, amount);
891     }
892 
893     /**
894      * @dev Sets {decimals} to a value other than the default one of 18.
895      *
896      * WARNING: This function should only be called from the constructor. Most
897      * applications that interact with token contracts will not expect
898      * {decimals} to ever change, and may work incorrectly if it does.
899      */
900     function _setupDecimals(uint8 decimals_) internal {
901         _decimals = decimals_;
902     }
903 
904     /**
905      * @dev Hook that is called before any transfer of tokens. This includes
906      * minting and burning.
907      *
908      * Calling conditions:
909      *
910      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
911      * will be to transferred to `to`.
912      * - when `from` is zero, `amount` tokens will be minted for `to`.
913      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
914      * - `from` and `to` are never both zero.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
919 
920     uint256[44] private __gap;
921 }
922 
923 contract ERC20WithPermit is Initializable, ERC20UpgradeSafe {
924     using SafeMath for uint;
925 
926     mapping(address => uint) public nonces;
927 
928     // If the token is redeployed, the version is increased to prevent a permit
929     // signature being used on both token instances.
930     string public version;
931 
932     // --- EIP712 niceties ---
933     bytes32 public DOMAIN_SEPARATOR;
934     // PERMIT_TYPEHASH is the value returned from
935     // keccak256("Permit(address holder,address spender,uint nonce,uint expiry,bool allowed)")
936     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
937 
938     function initialize(
939         uint _chainId,
940         string memory _version,
941         string memory _name,
942         string memory _symbol,
943         uint8 _decimals
944     ) public initializer {
945         __ERC20_init(_name, _symbol);
946         _setupDecimals(_decimals);
947         version = _version;
948         DOMAIN_SEPARATOR = keccak256(
949             abi.encode(
950                 keccak256(
951                     "EIP712Domain(string name,string version,uint chainId,address verifyingContract)"
952                 ),
953                 keccak256(bytes(name())),
954                 keccak256(bytes(version)),
955                 _chainId,
956                 address(this)
957             )
958         );
959     }
960 
961     // --- Approve by signature ---
962     function permit(
963         address holder,
964         address spender,
965         uint nonce,
966         uint expiry,
967         bool allowed,
968         uint8 v,
969         bytes32 r,
970         bytes32 s
971     ) external {
972         bytes32 digest = keccak256(
973             abi.encodePacked(
974                 "\x19\x01",
975                 DOMAIN_SEPARATOR,
976                 keccak256(
977                     abi.encode(
978                         PERMIT_TYPEHASH,
979                         holder,
980                         spender,
981                         nonce,
982                         expiry,
983                         allowed
984                     )
985                 )
986             )
987         );
988 
989         require(holder != address(0), "ERC20WithRate: address must not be 0x0");
990         require(
991             holder == ecrecover(digest, v, r, s),
992             "ERC20WithRate: invalid signature"
993         );
994         require(
995             expiry == 0 || now <= expiry,
996             "ERC20WithRate: permit has expired"
997         );
998         require(nonce == nonces[holder]++, "ERC20WithRate: invalid nonce");
999         uint amount = allowed ? uint(-1) : 0;
1000         _approve(holder, spender, amount);
1001     }
1002 }
1003 
1004 /**
1005  * @title SafeERC20
1006  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1007  * contract returns false). Tokens that return no value (and instead revert or
1008  * throw on failure) are also supported, non-reverting calls are assumed to be
1009  * successful.
1010  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1011  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1012  */
1013 library SafeERC20 {
1014     using SafeMath for uint256;
1015     using Address for address;
1016 
1017     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1018         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1019     }
1020 
1021     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1022         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1023     }
1024 
1025     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1026         // safeApprove should only be called when setting an initial allowance,
1027         // or when resetting it to zero. To increase and decrease it, use
1028         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1029         // solhint-disable-next-line max-line-length
1030         require((value == 0) || (token.allowance(address(this), spender) == 0),
1031             "SafeERC20: approve from non-zero to non-zero allowance"
1032         );
1033         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1034     }
1035 
1036     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1037         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1038         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1039     }
1040 
1041     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1042         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1043         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1044     }
1045 
1046     /**
1047      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1048      * on the return value: the return value is optional (but if data is returned, it must not be false).
1049      * @param token The token targeted by the call.
1050      * @param data The call data (encoded using abi.encode or one of its variants).
1051      */
1052     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1053         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1054         // we're implementing it ourselves.
1055 
1056         // A Solidity high level call has three parts:
1057         //  1. The target address is checked to verify it contains contract code
1058         //  2. The call itself is made, and success asserted
1059         //  3. The return value is decoded, which in turn checks the size of the returned data.
1060         // solhint-disable-next-line max-line-length
1061         require(address(token).isContract(), "SafeERC20: call to non-contract");
1062 
1063         // solhint-disable-next-line avoid-low-level-calls
1064         (bool success, bytes memory returndata) = address(token).call(data);
1065         require(success, "SafeERC20: low-level call failed");
1066 
1067         if (returndata.length > 0) { // Return data is optional
1068             // solhint-disable-next-line max-line-length
1069             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1070         }
1071     }
1072 }
1073 
1074 /**
1075  * @title Claimable
1076  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
1077  * This allows the new owner to accept the transfer.
1078  */
1079 contract Claimable is Initializable {
1080     address private _owner;
1081     address public pendingOwner;
1082 
1083     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1084 
1085     function initialize(address _nextOwner) public virtual initializer {
1086         _owner = _nextOwner;
1087     }
1088 
1089     /**
1090      * @dev Returns the address of the current owner.
1091      */
1092     function owner() public view returns (address) {
1093         return _owner;
1094     }
1095 
1096     /**
1097      * @dev Throws if called by any account other than the owner.
1098      */
1099     modifier onlyOwner() {
1100         require(_owner == msg.sender, "Ownable: caller is not the owner");
1101         _;
1102     }
1103 
1104     modifier onlyPendingOwner() {
1105         require(
1106             msg.sender == pendingOwner,
1107             "Claimable: caller is not the pending owner"
1108         );
1109         _;
1110     }
1111 
1112     /**
1113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1114      * Can only be called by the current owner.
1115      */
1116     function transferOwnership(address newOwner) public onlyOwner {
1117         require(
1118             newOwner != pendingOwner,
1119             "Claimable: invalid new owner"
1120         );
1121         pendingOwner = newOwner;
1122     }
1123 
1124     /**
1125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1126      * Can only be called by the current owner.
1127      */
1128     function _transferOwnership(address newOwner) internal {
1129         emit OwnershipTransferred(_owner, newOwner);
1130         _owner = newOwner;
1131     }
1132 
1133     function claimOwnership() public onlyPendingOwner {
1134         _transferOwnership(pendingOwner);
1135         delete pendingOwner;
1136     }
1137 }
1138 
1139 contract CanReclaimTokens is Claimable {
1140     using SafeERC20 for ERC20UpgradeSafe;
1141 
1142     mapping(address => bool) private recoverableTokensBlacklist;
1143 
1144     function initialize(address _nextOwner) public override initializer {
1145         Claimable.initialize(_nextOwner);
1146     }
1147 
1148     function blacklistRecoverableToken(address _token) public onlyOwner {
1149         recoverableTokensBlacklist[_token] = true;
1150     }
1151 
1152     /// @notice Allow the owner of the contract to recover funds accidentally
1153     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
1154     function recoverTokens(address _token) external onlyOwner {
1155         require(
1156             !recoverableTokensBlacklist[_token],
1157             "CanReclaimTokens: token is not recoverable"
1158         );
1159 
1160         if (_token == address(0x0)) {
1161             msg.sender.transfer(address(this).balance);
1162         } else {
1163             ERC20UpgradeSafe(_token).safeTransfer(
1164                 msg.sender, ERC20UpgradeSafe(_token).balanceOf(address(this))
1165             );
1166         }
1167     }
1168 }
1169 
1170 /**
1171  * @dev Wrapped BFI on Ethereum
1172  *
1173  * Read more about its tokenomic here: https://bearn-defi.medium.com/bearn-fi-introduction-9e65f6395dfc
1174  *
1175  * Total 12,500 BFI issued (minted) on Ethereum:
1176  * - 500 BFIE for initial supply (Uniswap and Value Liquid)
1177  * - 3000 BFIE for UNIv2 BFIE-ETH (50/50) mining incentive (4 months)
1178  * - 7000 BFIE for ValueLiquid VLP BFIE-VALUE (70/30) mining incentive (18 months)
1179  * - 2000 BFIE reserve for public mint (from BFI Bsc)
1180  */
1181 contract BearnTokenERC20 is
1182     ERC20WithPermit,
1183     CanReclaimTokens {
1184 
1185     uint public cap = 12500 ether;
1186 
1187     function initialize(
1188         uint _chainId,
1189         address _nextOwner,
1190         string memory _version,
1191         string memory _name,
1192         string memory _symbol,
1193         uint8 _decimals
1194     ) public initializer {
1195         __ERC20_init(_name, _symbol);
1196         _setupDecimals(_decimals);
1197         ERC20WithPermit.initialize(
1198             _chainId,
1199             _version,
1200             _name,
1201             _symbol,
1202             _decimals
1203         );
1204         CanReclaimTokens.initialize(_nextOwner);
1205         _mint(msg.sender, cap.sub(2000 ether)); // first mint to setup liquidity
1206     }
1207 
1208     // Can be called by only Gateway
1209     function mint(address _to, uint _amount) external onlyOwner {
1210         _mint(_to, _amount);
1211     }
1212 
1213     // Can be called by only Gateway
1214     function burn(uint _amount) external onlyOwner {
1215         _burn(msg.sender, _amount);
1216     }
1217 
1218     function transfer(address recipient, uint amount) public override returns (bool) {
1219         require(
1220             recipient != address(this),
1221             "BEARN ERC20UpgradeSafe: can't transfer to token address"
1222         );
1223         return super.transfer(recipient, amount);
1224     }
1225 
1226     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
1227         require(
1228             recipient != address(this),
1229             "BEARN ERC20UpgradeSafe: can't transfer to stoken address"
1230         );
1231         return super.transferFrom(sender, recipient, amount);
1232     }
1233 
1234     /**
1235      * @dev See {ERC20-_beforeTokenTransfer}.
1236      *
1237      * Requirements:
1238      *
1239      * - minted tokens must not cause the total supply to go over the cap.
1240      */
1241     function _beforeTokenTransfer(address from, address to, uint amount) internal virtual override {
1242         super._beforeTokenTransfer(from, to, amount);
1243 
1244         if (from == address(0)) { // When minting tokens
1245             require(totalSupply().add(amount) <= cap, "ERC20Capped: cap exceeded");
1246         }
1247     }
1248 }
1249 
1250 contract GatewayState {
1251     uint constant BIPS_DENOMINATOR = 10000;
1252     uint public minimumBurnAmount;
1253 
1254     /// @notice Each Gateway is tied to a specific BearnTokenERC20 token.
1255     BearnTokenERC20 public token;
1256 
1257     /// @notice The mintAuthority is an address that can sign mint requests.
1258     address public mintAuthority;
1259 
1260     /// @dev feeRecipient is assumed to be an address (or a contract) that can
1261     /// accept erc20 payments it cannot be 0x0.
1262     /// @notice When tokens are mint or burnt, a portion of the tokens are
1263     /// forwarded to a fee recipient.
1264     address public feeRecipient;
1265 
1266     /// @notice The mint fee in bips.
1267     uint16 public mintFee;
1268 
1269     /// @notice The burn fee in bips.
1270     uint16 public burnFee;
1271 
1272     /// @notice Each signature can only be seen once.
1273     mapping(bytes32 => bool) public status;
1274 
1275     // LogMint and LogBurn contain a unique `n` that identifies
1276     // the mint or burn event.
1277     uint public nextN = 0;
1278 }
1279 
1280 /// @notice Gateway handles verifying mint and burn requests. A mintAuthority
1281 /// approves new assets to be minted by providing a digital signature. An ownernpm
1282 /// of an asset can request for it to be burnt.
1283 contract BearnTokenGateway is
1284     CanReclaimTokens,
1285     GatewayState {
1286     using SafeMath for uint;
1287 
1288     event LogMintAuthorityUpdated(address indexed _newMintAuthority);
1289     event LogMint(
1290         address indexed _to,
1291         uint _amount,
1292         uint indexed _n,
1293         bytes32 indexed _signedMessageHash
1294     );
1295     event LogBurn(
1296         bytes _to,
1297         uint _amount,
1298         uint indexed _n,
1299         bytes indexed _indexedTo
1300     );
1301 
1302     /// @notice Only allow the Darknode Payment contract.
1303     modifier onlyOwnerOrMintAuthority() {
1304         require(
1305             msg.sender == mintAuthority || msg.sender == owner(),
1306             "Gateway: caller is not the owner or mint authority"
1307         );
1308         _;
1309     }
1310 
1311     /// @param _token The BearnTokenERC20 this Gateway is responsible for.
1312     /// @param _feeRecipient The recipient of burning and minting fees.
1313     /// @param _mintAuthority The address of the key that can sign mint
1314     ///        requests.
1315     /// @param _mintFee The amount subtracted each mint request and
1316     ///        forwarded to the feeRecipient. In BIPS.
1317     /// @param _burnFee The amount subtracted each burn request and
1318     ///        forwarded to the feeRecipient. In BIPS.
1319     function initialize(
1320         BearnTokenERC20 _token,
1321         address _feeRecipient,
1322         address _mintAuthority,
1323         uint16 _mintFee,
1324         uint16 _burnFee,
1325         uint _minimumBurnAmount
1326     ) public initializer {
1327         CanReclaimTokens.initialize(msg.sender);
1328         minimumBurnAmount = _minimumBurnAmount;
1329         token = _token;
1330         mintFee = _mintFee;
1331         burnFee = _burnFee;
1332         updateMintAuthority(_mintAuthority);
1333         updateFeeRecipient(_feeRecipient);
1334     }
1335 
1336     // Public functions ////////////////////////////////////////////////////////
1337 
1338     /// @notice Claims ownership of the token passed in to the constructor.
1339     /// `transferStoreOwnership` must have previously been called.
1340     /// Anyone can call this function.
1341     function claimTokenOwnership() public {
1342         token.claimOwnership();
1343     }
1344 
1345     /// @notice Allow the owner to update the owner of the BearnTokenERC20 token.
1346     function transferTokenOwnership(BearnTokenGateway _nextTokenOwner)
1347     public
1348     onlyOwner
1349     {
1350         token.transferOwnership(address(_nextTokenOwner));
1351         _nextTokenOwner.claimTokenOwnership();
1352     }
1353 
1354     /// @notice Allow the owner to update the fee recipient.
1355     ///
1356     /// @param _nextMintAuthority The address to start paying fees to.
1357     function updateMintAuthority(address _nextMintAuthority)
1358     public
1359     onlyOwnerOrMintAuthority
1360     {
1361         // The mint authority should not be set to 0, which is the result
1362         // returned by ecrecover for an invalid signature.
1363         require(
1364             _nextMintAuthority != address(0),
1365             "Gateway: mintAuthority cannot be set to address zero"
1366         );
1367         mintAuthority = _nextMintAuthority;
1368         emit LogMintAuthorityUpdated(mintAuthority);
1369     }
1370 
1371     /// @notice Allow the owner to update the minimum burn amount.
1372     ///
1373     /// @param _minimumBurnAmount The new min burn amount.
1374     function updateMinimumBurnAmount(uint _minimumBurnAmount)
1375     public
1376     onlyOwner
1377     {
1378         minimumBurnAmount = _minimumBurnAmount;
1379     }
1380 
1381     /// @notice Allow the owner to update the fee recipient.
1382     ///
1383     /// @param _nextFeeRecipient The address to start paying fees to.
1384     function updateFeeRecipient(address _nextFeeRecipient) public onlyOwner {
1385         // 'mint' and 'burn' will fail if the feeRecipient is 0x0
1386         require(
1387             _nextFeeRecipient != address(0x0),
1388             "Gateway: fee recipient cannot be 0x0"
1389         );
1390 
1391         feeRecipient = _nextFeeRecipient;
1392     }
1393 
1394     /// @notice Allow the owner to update the 'mint' fee.
1395     ///
1396     /// @param _nextMintFee The new fee for minting and burning.
1397     function updateMintFee(uint16 _nextMintFee) public onlyOwner {
1398         mintFee = _nextMintFee;
1399     }
1400 
1401     /// @notice Allow the owner to update the burn fee.
1402     ///
1403     /// @param _nextBurnFee The new fee for minting and burning.
1404     function updateBurnFee(uint16 _nextBurnFee) public onlyOwner {
1405         burnFee = _nextBurnFee;
1406     }
1407 
1408     function mint(
1409         string calldata _symbol,
1410         address _recipient,
1411         uint _amount,
1412         bytes32 _nHash,
1413         bytes calldata _sig
1414     ) external {
1415         bytes32 payloadHash = keccak256(abi.encode(_symbol, _recipient));
1416         // Verify signature
1417         bytes32 signedMessageHash = hashForSignature(
1418             _symbol,
1419             _recipient,
1420             _amount,
1421             msg.sender,
1422             _nHash
1423         );
1424         require(
1425             status[signedMessageHash] == false,
1426             "Gateway: nonce hash already spent"
1427         );
1428         if (!verifySignature(signedMessageHash, _sig)) {
1429             // Return a detailed string containing the hash and recovered
1430             // signer. This is somewhat costly but is only run in the revert
1431             // branch.
1432             revert(
1433                 String.add8(
1434                     "Gateway: invalid signature. pHash: ",
1435                     String.fromBytes32(payloadHash),
1436                     ", amount: ",
1437                     String.fromUint(_amount),
1438                     ", msg.sender: ",
1439                     String.fromAddress(msg.sender),
1440                     ", _nHash: ",
1441                     String.fromBytes32(_nHash)
1442                 )
1443             );
1444         }
1445         status[signedMessageHash] = true;
1446 
1447         // Mint `amount - fee` for the recipient and mint `fee` for the minter
1448         uint absoluteFee = _amount.mul(mintFee).div(
1449             BIPS_DENOMINATOR
1450         );
1451         uint receivedAmount = _amount.sub(
1452             absoluteFee,
1453             "Gateway: fee exceeds amount"
1454         );
1455 
1456         // Mint amount minus the fee
1457         token.mint(_recipient, receivedAmount);
1458         // Mint the fee
1459         token.mint(feeRecipient, absoluteFee);
1460 
1461         emit LogMint(
1462             _recipient,
1463             receivedAmount,
1464             nextN,
1465             signedMessageHash
1466         );
1467         nextN += 1;
1468     }
1469 
1470     /// @notice burn destroys tokens after taking a fee for the `_feeRecipient`,
1471     ///         allowing the associated assets to be released on their native
1472     ///         chain.
1473     ///
1474     /// @param _to The address to receive the un-bridged asset. The format of
1475     ///        this address should be of the destination chain.
1476     ///        For example, when burning to Bitcoin, _to should be a
1477     ///        Bitcoin address.
1478     /// @param _amount The amount of the token being burnt, in its
1479     ///        smallest value. (e.g. satoshis for BTC)
1480     function burn(bytes calldata _to, uint _amount)
1481     external {
1482         //    function burn(bytes memory _to, uint _amount) public returns (uint) {
1483         require(
1484             token.transferFrom(msg.sender, address(this), _amount),
1485             "token transfer failed"
1486         );
1487         // The recipient must not be empty. Better validation is possible,
1488         // but would need to be customized for each destination ledger.
1489         require(_to.length != 0, "Gateway: to address is empty");
1490 
1491         // Calculate fee, subtract it from amount being burnt.
1492         uint fee = _amount.mul(burnFee).div(BIPS_DENOMINATOR);
1493         uint amountAfterFee = _amount.sub(
1494             fee,
1495             "Gateway: fee exceeds amount"
1496         );
1497 
1498         // Burn the whole amount, and then re-mint the fee.
1499         token.burn(_amount);
1500         token.mint(feeRecipient, fee);
1501 
1502         require(
1503         // Must be strictly greater, to that the release transaction is of
1504         // at least one unit.
1505             amountAfterFee > minimumBurnAmount,
1506             "Gateway: amount is less than the minimum burn amount"
1507         );
1508 
1509         emit LogBurn(_to, amountAfterFee, nextN, _to);
1510         nextN += 1;
1511     }
1512 
1513     /// @notice verifySignature checks the the provided signature matches the provided
1514     /// parameters.
1515     function verifySignature(bytes32 _signedMessageHash, bytes memory _sig)
1516     public
1517     view
1518     returns (bool)
1519     {
1520         bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(_signedMessageHash);
1521         address signer = ECDSA.recover(ethSignedMessageHash, _sig);
1522         return mintAuthority == signer;
1523     }
1524 
1525     /// @notice hashForSignature hashes the parameters so that they can be signed.
1526     function hashForSignature(
1527         string memory _symbol,
1528         address _recipient,
1529         uint _amount,
1530         address _caller,
1531         bytes32 _nHash
1532     ) public view returns (bytes32) {
1533         bytes32 payloadHash = keccak256(abi.encode(_symbol, _recipient));
1534         return
1535         keccak256(abi.encode(payloadHash, _amount, address(token), _caller, _nHash));
1536     }
1537 }