1 // File: contracts/thirdParty/ECDSA.sol
2 
3 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
4 // Line 60 added to original source in accordance with recommendation on accepting signatures with 0/1 for v
5 
6 pragma solidity ^0.6.0;
7 
8 /**
9  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
10  *
11  * These functions can be used to verify that a message was signed by the holder
12  * of the private keys of a given address.
13  */
14 library ECDSA {
15     /**
16      * @dev Returns the address that signed a hashed message (`hash`) with
17      * `signature`. This address can then be used for verification purposes.
18      *
19      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
20      * this function rejects them by requiring the `s` value to be in the lower
21      * half order, and the `v` value to be either 27 or 28.
22      *
23      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
24      * verification to be secure: it is possible to craft signatures that
25      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
26      * this is by receiving a hash of the original message (which may otherwise
27      * be too long), and then calling {toEthSignedMessageHash} on it.
28      */
29     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
30         // Check the signature length
31         if (signature.length != 65) {
32             revert("ECDSA: invalid signature length");
33         }
34 
35         // Divide the signature in r, s and v variables
36         bytes32 r;
37         bytes32 s;
38         uint8 v;
39 
40         // ecrecover takes the signature parameters, and the only way to get them
41         // currently is to use assembly.
42         // solhint-disable-next-line no-inline-assembly
43         assembly {
44             r := mload(add(signature, 0x20))
45             s := mload(add(signature, 0x40))
46             v := byte(0, mload(add(signature, 0x60)))
47         }
48 
49         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
50         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
51         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
52         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
53         //
54         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
55         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
56         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
57         // these malleable signatures as well.
58         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
59             revert("ECDSA: invalid signature 's' value");
60         }
61 
62         if (v < 27) v += 27;
63 
64         if (v != 27 && v != 28) {
65             revert("ECDSA: invalid signature 'v' value");
66         }
67 
68         // If the signature is valid (and not malleable), return the signer address
69         address signer = ecrecover(hash, v, r, s);
70         require(signer != address(0), "ECDSA: invalid signature");
71 
72         return signer;
73     }
74 
75     /**
76      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
77      * replicates the behavior of the
78      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
79      * JSON-RPC method.
80      *
81      * See {recover}.
82      */
83     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
84         // 32 is the length in bytes of hash,
85         // enforced by the type signature above
86         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
87     }
88 }
89 
90 // File: contracts/interfaces/IERC777.sol
91 
92 pragma solidity 0.6.7;
93 
94 // As defined in https://eips.ethereum.org/EIPS/eip-777
95 interface IERC777 {
96   event Sent(address indexed operator, address indexed from, address indexed to, uint256 amount, bytes data,
97       bytes operatorData);
98   event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
99   event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
100   event AuthorizedOperator(address indexed operator,address indexed holder);
101   event RevokedOperator(address indexed operator, address indexed holder);
102 
103   function name() external view returns (string memory);
104   function symbol() external view returns (string memory);
105   function totalSupply() external view returns (uint256);
106   function balanceOf(address holder) external view returns (uint256);
107   function granularity() external view returns (uint256);
108   function defaultOperators() external view returns (address[] memory);
109   function isOperatorFor(address operator, address holder) external view returns (bool);
110   function authorizeOperator(address operator) external;
111   function revokeOperator(address operator) external;
112   function send(address to, uint256 amount, bytes calldata data) external;
113   function operatorSend(address from, address to, uint256 amount, bytes calldata data, bytes calldata operatorData) external;
114   function burn(uint256 amount, bytes calldata data) external;
115   function operatorBurn( address from, uint256 amount, bytes calldata data, bytes calldata operatorData) external;
116 }
117 
118 // File: contracts/interfaces/IERC20.sol
119 
120 pragma solidity 0.6.7;
121 
122 // As described in https://eips.ethereum.org/EIPS/eip-20
123 interface IERC20 {
124   event Transfer(address indexed from, address indexed to, uint256 value);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 
127   function name() external view returns (string memory); // optional method - see eip spec
128   function symbol() external view returns (string memory); // optional method - see eip spec
129   function decimals() external view returns (uint8); // optional method - see eip spec
130   function totalSupply() external view returns (uint256);
131   function balanceOf(address owner) external view returns (uint256);
132   function transfer(address to, uint256 value) external returns (bool);
133   function transferFrom(address from, address to, uint256 value) external returns (bool);
134   function approve(address spender, uint256 value) external returns (bool);
135   function allowance(address owner, address spender) external view returns (uint256);
136 }
137 
138 // File: contracts/thirdParty/interfaces/IERC1820Registry.sol
139 
140 // From open https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/introspection/IERC1820Registry.sol
141 
142 pragma solidity ^0.6.0;
143 
144 /**
145  * @dev Interface of the global ERC1820 Registry, as defined in the
146  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
147  * implementers for interfaces in this registry, as well as query support.
148  *
149  * Implementers may be shared by multiple accounts, and can also implement more
150  * than a single interface for each account. Contracts can implement interfaces
151  * for themselves, but externally-owned accounts (EOA) must delegate this to a
152  * contract.
153  *
154  * {IERC165} interfaces can also be queried via the registry.
155  *
156  * For an in-depth explanation and source code analysis, see the EIP text.
157  */
158 interface IERC1820Registry {
159     /**
160      * @dev Sets `newManager` as the manager for `account`. A manager of an
161      * account is able to set interface implementers for it.
162      *
163      * By default, each account is its own manager. Passing a value of `0x0` in
164      * `newManager` will reset the manager to this initial state.
165      *
166      * Emits a {ManagerChanged} event.
167      *
168      * Requirements:
169      *
170      * - the caller must be the current manager for `account`.
171      */
172     function setManager(address account, address newManager) external;
173 
174     /**
175      * @dev Returns the manager for `account`.
176      *
177      * See {setManager}.
178      */
179     function getManager(address account) external view returns (address);
180 
181     /**
182      * @dev Sets the `implementer` contract as ``account``'s implementer for
183      * `interfaceHash`.
184      *
185      * `account` being the zero address is an alias for the caller's address.
186      * The zero address can also be used in `implementer` to remove an old one.
187      *
188      * See {interfaceHash} to learn how these are created.
189      *
190      * Emits an {InterfaceImplementerSet} event.
191      *
192      * Requirements:
193      *
194      * - the caller must be the current manager for `account`.
195      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
196      * end in 28 zeroes).
197      * - `implementer` must implement {IERC1820Implementer} and return true when
198      * queried for support, unless `implementer` is the caller. See
199      * {IERC1820Implementer-canImplementInterfaceForAddress}.
200      */
201     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
202 
203     /**
204      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
205      * implementer is registered, returns the zero address.
206      *
207      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
208      * zeroes), `account` will be queried for support of it.
209      *
210      * `account` being the zero address is an alias for the caller's address.
211      */
212     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
213 
214     /**
215      * @dev Returns the interface hash for an `interfaceName`, as defined in the
216      * corresponding
217      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
218      */
219     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
220 
221     /**
222      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
223      *  @param account Address of the contract for which to update the cache.
224      *  @param interfaceId ERC165 interface for which to update the cache.
225      */
226     function updateERC165Cache(address account, bytes4 interfaceId) external;
227 
228     /**
229      *  @notice Checks whether a contract implements an ERC165 interface or not.
230      *  If the result is not cached a direct lookup on the contract address is performed.
231      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
232      *  {updateERC165Cache} with the contract address.
233      *  @param account Address of the contract to check.
234      *  @param interfaceId ERC165 interface to check.
235      *  @return True if `account` implements `interfaceId`, false otherwise.
236      */
237     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
238 
239     /**
240      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
241      *  @param account Address of the contract to check.
242      *  @param interfaceId ERC165 interface to check.
243      *  @return True if `account` implements `interfaceId`, false otherwise.
244      */
245     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
246 
247     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
248 
249     event ManagerChanged(address indexed account, address indexed newManager);
250 }
251 
252 // File: contracts/interfaces/IERC777Sender.sol
253 
254 pragma solidity 0.6.7;
255 
256 // As defined in the 'ERC777TokensSender And The tokensToSend Hook' section of https://eips.ethereum.org/EIPS/eip-777
257 interface IERC777Sender {
258   function tokensToSend(address operator, address from, address to, uint256 amount, bytes calldata data,
259       bytes calldata operatorData) external;
260 }
261 
262 // File: contracts/interfaces/IERC777Recipient.sol
263 
264 pragma solidity 0.6.7;
265 
266 // As defined in the 'ERC777TokensRecipient And The tokensReceived Hook' section of https://eips.ethereum.org/EIPS/eip-777
267 interface IERC777Recipient {
268   function tokensReceived(address operator, address from, address to, uint256 amount, bytes calldata data,
269       bytes calldata operatorData) external;
270 }
271 
272 // File: contracts/thirdParty/SafeMath.sol
273 
274 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
275 
276 pragma solidity ^0.6.0;
277 
278 /**
279  * @dev Wrappers over Solidity's arithmetic operations with added overflow
280  * checks.
281  *
282  * Arithmetic operations in Solidity wrap on overflow. This can easily result
283  * in bugs, because programmers usually assume that an overflow raises an
284  * error, which is the standard behavior in high level programming languages.
285  * `SafeMath` restores this intuition by reverting the transaction when an
286  * operation overflows.
287  *
288  * Using this library instead of the unchecked operations eliminates an entire
289  * class of bugs, so it's recommended to use it always.
290  */
291 library SafeMath {
292     /**
293      * @dev Returns the addition of two unsigned integers, reverting on
294      * overflow.
295      *
296      * Counterpart to Solidity's `+` operator.
297      *
298      * Requirements:
299      * - Addition cannot overflow.
300      */
301     function add(uint256 a, uint256 b) internal pure returns (uint256) {
302         uint256 c = a + b;
303         require(c >= a, "SafeMath: addition overflow");
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the subtraction of two unsigned integers, reverting on
310      * overflow (when the result is negative).
311      *
312      * Counterpart to Solidity's `-` operator.
313      *
314      * Requirements:
315      * - Subtraction cannot overflow.
316      */
317     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318         return sub(a, b, "SafeMath: subtraction overflow");
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      * - Subtraction cannot overflow.
329      *
330      * _Available since v2.4.0._
331      */
332     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b <= a, errorMessage);
334         uint256 c = a - b;
335 
336         return c;
337     }
338 
339     /**
340      * @dev Returns the multiplication of two unsigned integers, reverting on
341      * overflow.
342      *
343      * Counterpart to Solidity's `*` operator.
344      *
345      * Requirements:
346      * - Multiplication cannot overflow.
347      */
348     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
349         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350         // benefit is lost if 'b' is also tested.
351         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
352         if (a == 0) {
353             return 0;
354         }
355 
356         uint256 c = a * b;
357         require(c / a == b, "SafeMath: multiplication overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers. Reverts on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      * - The divisor cannot be zero.
372      */
373     function div(uint256 a, uint256 b) internal pure returns (uint256) {
374         return div(a, b, "SafeMath: division by zero");
375     }
376 
377     /**
378      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
379      * division by zero. The result is rounded towards zero.
380      *
381      * Counterpart to Solidity's `/` operator. Note: this function uses a
382      * `revert` opcode (which leaves remaining gas untouched) while Solidity
383      * uses an invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      * - The divisor cannot be zero.
387      *
388      * _Available since v2.4.0._
389      */
390     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
391         // Solidity only automatically asserts when dividing by 0
392         require(b > 0, errorMessage);
393         uint256 c = a / b;
394         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
395 
396         return c;
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
401      * Reverts when dividing by zero.
402      *
403      * Counterpart to Solidity's `%` operator. This function uses a `revert`
404      * opcode (which leaves remaining gas untouched) while Solidity uses an
405      * invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      * - The divisor cannot be zero.
409      */
410     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
411         return mod(a, b, "SafeMath: modulo by zero");
412     }
413 
414     /**
415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416      * Reverts with custom message when dividing by zero.
417      *
418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
419      * opcode (which leaves remaining gas untouched) while Solidity uses an
420      * invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      * - The divisor cannot be zero.
424      *
425      * _Available since v2.4.0._
426      */
427     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
428         require(b != 0, errorMessage);
429         return a % b;
430     }
431 }
432 
433 // File: contracts/libraries/LToken.sol
434 
435 pragma solidity 0.6.7;
436 
437 
438 
439 
440 
441 struct TokenState {
442   uint256 totalSupply;
443   mapping(address => uint256) balances;
444   mapping(address => mapping(address => uint256)) approvals;
445   mapping(address => mapping(address => bool)) authorizedOperators;
446   address[] defaultOperators;
447   mapping(address => bool) defaultOperatorIsRevoked;
448   mapping(address => bool) minters;
449 }
450 
451 library LToken {
452   using SafeMath for uint256;
453 
454   event Transfer(address indexed from, address indexed to, uint256 value);
455   event Approval(address indexed owner, address indexed spender, uint256 value);
456   event Sent(address indexed operator, address indexed from, address indexed to, uint256 amount, bytes data,
457       bytes operatorData);
458   event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
459   event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
460   event AuthorizedOperator(address indexed operator, address indexed holder);
461   event RevokedOperator(address indexed operator, address indexed holder);
462 
463   // Universal address as defined in Registry Contract Address section of https://eips.ethereum.org/EIPS/eip-1820
464   IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
465   // precalculated hashes - see https://github.com/ethereum/solidity/issues/4024
466   // keccak256("ERC777TokensSender")
467   bytes32 constant internal ERC777_TOKENS_SENDER_HASH = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
468   // keccak256("ERC777TokensRecipient")
469   bytes32 constant internal ERC777_TOKENS_RECIPIENT_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
470 
471   modifier checkSenderNotOperator(address _operator) {
472     require(_operator != msg.sender, "Cannot be operator for self");
473     _;
474   }
475 
476   function initState(TokenState storage _tokenState, uint8 _decimals, uint256 _initialSupply)
477     external
478   {
479     _tokenState.defaultOperators.push(address(this));
480     _tokenState.totalSupply = _initialSupply.mul(10**uint256(_decimals));
481     _tokenState.balances[msg.sender] = _tokenState.totalSupply;
482   }
483 
484   function transferFrom(TokenState storage _tokenState, address _from, address _to, uint256 _value)
485     external
486   {
487     _tokenState.approvals[_from][msg.sender] = _tokenState.approvals[_from][msg.sender].sub(_value, "Amount not approved");
488     doSend(_tokenState, msg.sender, _from, _to, _value, "", "", false);
489   }
490 
491   function approve(TokenState storage _tokenState, address _spender, uint256 _value)
492     external
493   {
494     require(_spender != address(0), "Cannot approve to zero address");
495     _tokenState.approvals[msg.sender][_spender] = _value;
496     emit Approval(msg.sender, _spender, _value);
497   }
498 
499   function authorizeOperator(TokenState storage _tokenState, address _operator)
500     checkSenderNotOperator(_operator)
501     external
502   {
503     if (_operator == address(this))
504       _tokenState.defaultOperatorIsRevoked[msg.sender] = false;
505     else
506       _tokenState.authorizedOperators[_operator][msg.sender] = true;
507     emit AuthorizedOperator(_operator, msg.sender);
508   }
509 
510   function revokeOperator(TokenState storage _tokenState, address _operator)
511     checkSenderNotOperator(_operator)
512     external
513   {
514     if (_operator == address(this))
515       _tokenState.defaultOperatorIsRevoked[msg.sender] = true;
516     else
517       _tokenState.authorizedOperators[_operator][msg.sender] = false;
518     emit RevokedOperator(_operator, msg.sender);
519   }
520 
521   function authorizeMinter(TokenState storage _tokenState, address _minter)
522     external
523   {
524     _tokenState.minters[_minter] = true;
525   }
526 
527   function revokeMinter(TokenState storage _tokenState, address _minter)
528     external
529   {
530     _tokenState.minters[_minter] = false;
531   }
532 
533   function doMint(TokenState storage _tokenState, address _to, uint256 _amount)
534     external
535   {
536     assert(_to != address(0));
537 
538     _tokenState.totalSupply = _tokenState.totalSupply.add(_amount);
539     _tokenState.balances[_to] = _tokenState.balances[_to].add(_amount);
540 
541     // From ERC777: The token contract MUST call the tokensReceived hook after updating the state.
542     receiveHook(address(this), address(0), _to, _amount, "", "", true);
543 
544     emit Minted(address(this), _to, _amount, "", "");
545     emit Transfer(address(0), _to, _amount);
546   }
547 
548   function doBurn(TokenState storage _tokenState, address _operator, address _from, uint256 _amount, bytes calldata _data,
549       bytes calldata _operatorData)
550     external
551   {
552     assert(_from != address(0));
553     // From ERC777: The token contract MUST call the tokensToSend hook before updating the state.
554     sendHook(_operator, _from, address(0), _amount, _data, _operatorData);
555 
556     _tokenState.balances[_from] = _tokenState.balances[_from].sub(_amount, "Cannot burn more than balance");
557     _tokenState.totalSupply = _tokenState.totalSupply.sub(_amount);
558 
559     emit Burned(_operator, _from, _amount, _data, _operatorData);
560     emit Transfer(_from, address(0), _amount);
561   }
562 
563   function doSend(TokenState storage _tokenState, address _operator, address _from, address _to, uint256 _amount,
564       bytes memory _data, bytes memory _operatorData, bool _enforceERC777)
565     public
566   {
567     assert(_from != address(0));
568 
569     require(_to != address(0), "Cannot send funds to 0 address");
570     // From ERC777: The token contract MUST call the tokensToSend hook before updating the state.
571     sendHook(_operator, _from, _to, _amount, _data, _operatorData);
572 
573     _tokenState.balances[_from] = _tokenState.balances[_from].sub(_amount, "Amount exceeds available funds");
574     _tokenState.balances[_to] = _tokenState.balances[_to].add(_amount);
575 
576     emit Sent(_operator, _from, _to, _amount, _data, _operatorData);
577     emit Transfer(_from, _to, _amount);
578 
579     // From ERC777: The token contract MUST call the tokensReceived hook after updating the state.
580     receiveHook(_operator, _from, _to, _amount, _data, _operatorData, _enforceERC777);
581   }
582 
583   function receiveHook(address _operator, address _from, address _to, uint256 _amount, bytes memory _data,
584       bytes memory _operatorData, bool _enforceERC777)
585     public
586   {
587     address implementer = ERC1820_REGISTRY.getInterfaceImplementer(_to, ERC777_TOKENS_RECIPIENT_HASH);
588     if (implementer != address(0))
589       IERC777Recipient(implementer).tokensReceived(_operator, _from, _to, _amount, _data, _operatorData);
590     else if (_enforceERC777)
591       require(!isContract(_to), "Must be registered with ERC1820");
592   }
593 
594   function sendHook(address _operator, address _from, address _to, uint256 _amount, bytes memory _data,
595       bytes memory _operatorData)
596     public
597   {
598     address implementer = ERC1820_REGISTRY.getInterfaceImplementer(_from, ERC777_TOKENS_SENDER_HASH);
599     if (implementer != address(0))
600       IERC777Sender(implementer).tokensToSend(_operator, _from, _to, _amount, _data, _operatorData);
601   }
602 
603   function isContract(address _account)
604     private
605     view
606     returns (bool isContract_)
607   {
608     uint256 size;
609 
610     assembly {
611       size := extcodesize(_account)
612     }
613 
614     isContract_ = size != 0;
615   }
616 }
617 
618 // File: contracts/Token.sol
619 
620 pragma solidity 0.6.7;
621 
622 
623 
624 
625 /**
626  * Implements ERC777 with ERC20 as defined in https://eips.ethereum.org/EIPS/eip-777, with minting support.
627  * NOTE: Minting is internal only: derive from this contract according to usage.
628  */
629 contract Token is IERC777, IERC20 {
630 
631   string private tokenName;
632   string private tokenSymbol;
633   uint8 constant private tokenDecimals = 18;
634   uint256 constant private tokenGranularity = 1;
635   TokenState public tokenState;
636 
637   // Universal address as defined in Registry Contract Address section of https://eips.ethereum.org/EIPS/eip-1820
638   IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
639   // keccak256("ERC777Token")
640   bytes32 constant internal ERC777_TOKEN_HASH = 0xac7fbab5f54a3ca8194167523c6753bfeb96a445279294b6125b68cce2177054;
641   // keccak256("ERC20Token")
642   bytes32 constant internal ERC20_TOKEN_HASH = 0xaea199e31a596269b42cdafd93407f14436db6e4cad65417994c2eb37381e05a;
643 
644   event AuthorizedMinter(address minter);
645   event RevokedMinter(address minter);
646 
647   constructor(string memory _name, string memory _symbol, uint256 _initialSupply)
648     internal
649   {
650     require(bytes(_name).length != 0, "Needs a name");
651     require(bytes(_symbol).length != 0, "Needs a symbol");
652     tokenName = _name;
653     tokenSymbol = _symbol;
654     LToken.initState(tokenState, tokenDecimals, _initialSupply);
655 
656     ERC1820_REGISTRY.setInterfaceImplementer(address(this), ERC777_TOKEN_HASH, address(this));
657     ERC1820_REGISTRY.setInterfaceImplementer(address(this), ERC20_TOKEN_HASH, address(this));
658   }
659 
660   modifier onlyOperator(address _holder) {
661     require(isOperatorFor(msg.sender, _holder), "Not an operator");
662     _;
663   }
664 
665   modifier onlyMinter {
666     require(tokenState.minters[msg.sender], "onlyMinter");
667     _;
668   }
669 
670   function name()
671     external
672     view
673     override(IERC777, IERC20)
674     returns (string memory name_)
675   {
676     name_ = tokenName;
677   }
678 
679   function symbol()
680     external
681     view
682     override(IERC777, IERC20)
683     returns (string memory symbol_)
684   {
685     symbol_ = tokenSymbol;
686   }
687 
688   function decimals()
689     external
690     view
691     override
692     returns (uint8 decimals_)
693   {
694     decimals_ = tokenDecimals;
695   }
696 
697   function granularity()
698     external
699     view
700     override
701     returns (uint256 granularity_)
702   {
703     granularity_ = tokenGranularity;
704   }
705 
706   function balanceOf(address _holder)
707     external
708     override(IERC777, IERC20)
709     view
710     returns (uint256 balance_)
711   {
712     balance_ = tokenState.balances[_holder];
713   }
714 
715   function transfer(address _to, uint256 _value)
716     external
717     override
718     returns (bool success_)
719   {
720     doSend(msg.sender, msg.sender, _to, _value, "", "", false);
721     success_ = true;
722   }
723 
724   function transferFrom(address _from, address _to, uint256 _value)
725     external
726     override
727     returns (bool success_)
728   {
729     LToken.transferFrom(tokenState, _from, _to, _value);
730     success_ = true;
731   }
732 
733   function approve(address _spender, uint256 _value)
734     external
735     override
736     returns (bool success_)
737   {
738     LToken.approve(tokenState, _spender, _value);
739     success_ = true;
740   }
741 
742   function allowance(address _holder, address _spender)
743     external
744     view
745     override
746     returns (uint256 remaining_)
747   {
748     remaining_ = tokenState.approvals[_holder][_spender];
749   }
750 
751   function defaultOperators()
752     external
753     view
754     override
755     returns (address[] memory)
756   {
757     return tokenState.defaultOperators;
758   }
759 
760   function authorizeOperator(address _operator)
761     external
762     override
763   {
764     LToken.authorizeOperator(tokenState, _operator);
765   }
766 
767   function revokeOperator(address _operator)
768     external
769     override
770   {
771     LToken.revokeOperator(tokenState, _operator);
772   }
773 
774   function send(address _to, uint256 _amount, bytes calldata _data)
775     external
776     override
777   {
778     doSend(msg.sender, msg.sender, _to, _amount, _data, "", true);
779   }
780 
781   function operatorSend(address _from, address _to, uint256 _amount, bytes calldata _data, bytes calldata _operatorData)
782     external
783     override
784     onlyOperator(_from)
785   {
786     doSend(msg.sender, _from, _to, _amount, _data, _operatorData, true);
787   }
788 
789   function burn(uint256 _amount, bytes calldata _data)
790     external
791     override
792   {
793     doBurn(msg.sender, msg.sender, _amount, _data, "");
794   }
795 
796   function operatorBurn(address _from, uint256 _amount, bytes calldata _data, bytes calldata _operatorData)
797     external
798     override
799     onlyOperator(_from)
800   {
801     doBurn(msg.sender, _from, _amount, _data, _operatorData);
802   }
803 
804   function mint(address _to, uint256 _amount)
805     external
806     onlyMinter
807   {
808     LToken.doMint(tokenState, _to, _amount);
809   }
810 
811   function totalSupply()
812     external
813     view
814     override(IERC777, IERC20)
815     returns (uint256 totalSupply_)
816   {
817     totalSupply_ = tokenState.totalSupply;
818   }
819 
820   function isOperatorFor(address _operator, address _holder)
821     public
822     view
823     override
824     returns (bool isOperatorFor_)
825   {
826     isOperatorFor_ = (_operator == _holder || tokenState.authorizedOperators[_operator][_holder]
827         || _operator == address(this) && !tokenState.defaultOperatorIsRevoked[_holder]);
828   }
829 
830   function doSend(address _operator, address _from, address _to, uint256 _amount, bytes memory _data,
831       bytes memory _operatorData, bool _enforceERC777)
832     internal
833     virtual
834   {
835     LToken.doSend(tokenState, _operator, _from, _to, _amount, _data, _operatorData, _enforceERC777);
836   }
837 
838   function doBurn(address _operator, address _from, uint256 _amount, bytes memory _data, bytes memory _operatorData)
839     internal
840   {
841     LToken.doBurn(tokenState, _operator, _from, _amount, _data, _operatorData);
842   }
843 
844   function authorizeMinter(address _minter)
845     internal
846   {
847     LToken.authorizeMinter(tokenState, _minter);
848 
849     emit AuthorizedMinter(_minter);
850   }
851 
852   function revokeMinter(address _minter)
853     internal
854   {
855     LToken.revokeMinter(tokenState, _minter);
856 
857     emit RevokedMinter(_minter);
858   }
859 }
860 
861 // File: contracts/Owned.sol
862 
863 pragma solidity 0.6.7;
864 
865 contract Owned {
866 
867   address public owner = msg.sender;
868 
869   event LogOwnershipTransferred(address indexed owner, address indexed newOwner);
870 
871   modifier onlyOwner {
872     require(msg.sender == owner, "Sender must be owner");
873     _;
874   }
875 
876   function setOwner(address _owner)
877     external
878     onlyOwner
879   {
880     require(_owner != address(0), "Owner cannot be zero address");
881     emit LogOwnershipTransferred(owner, _owner);
882     owner = _owner;
883   }
884 }
885 
886 // File: contracts/VOWToken.sol
887 
888 pragma solidity 0.6.7;
889 
890 
891 
892 
893 /**
894  * ERC777/20 contract which also:
895  * - is owned
896  * - supports proxying of own tokens (only if signed correctly)
897  * - supports partner contracts, keyed by hash
898  * - supports minting (only by owner approved contracts)
899  * - has a USD price
900  */
901 contract VOWToken is Token, IERC777Recipient, Owned {
902 
903   mapping (bytes32 => bool) public proxyProofs;
904   uint256[2] public usdRate;
905   address public usdRateSetter;
906   mapping(bytes32 => address payable) public partnerContracts;
907 
908   // precalculated hash - see https://github.com/ethereum/solidity/issues/4024
909   // keccak256("ERC777TokensRecipient")
910   bytes32 constant internal ERC777_TOKENS_RECIPIENT_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
911 
912   event LogUSDRateSetterSet(address indexed usdRateSetter);
913   event LogUSDRateSet(uint256 numTokens, uint256 numUSD);
914   event LogProxiedTokens(address indexed from, address indexed to, uint256 amount, bytes data, uint256 nonce, bytes proof);
915   event LogPartnerContractSet(bytes32 indexed keyHash, address indexed partnerContract);
916   event LogMintPermissionSet(address indexed contractAddress, bool canMint);
917 
918   constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint256[2] memory _initialUSDRate)
919     public
920     Token(_name, _symbol, _initialSupply)
921   {
922     doSetUSDRate(_initialUSDRate[0], _initialUSDRate[1]);
923 
924     ERC1820_REGISTRY.setInterfaceImplementer(address(this), ERC777_TOKENS_RECIPIENT_HASH, address(this));
925   }
926 
927   modifier onlyUSDRateSetter() {
928     require(msg.sender == usdRateSetter, "onlyUSDRateSetter");
929     _;
930   }
931 
932   modifier onlyOwnTokens {
933     require(msg.sender == address(this), "onlyOwnTokens");
934     _;
935   }
936 
937   modifier addressNotNull(address _address) {
938     require(_address != address(0), "Address cannot be null");
939     _;
940   }
941 
942   function tokensReceived(address /* _operator */, address /* _from */, address /* _to */, uint256 _amount,
943       bytes calldata _data, bytes calldata /* _operatorData */)
944     external
945     override
946     onlyOwnTokens
947   {
948     (address from, address to, uint256 amount, bytes memory data, uint256 nonce, bytes memory proof) =
949         abi.decode(_data, (address, address, uint256, bytes, uint256, bytes));
950     checkProxying(from, to, amount, data, nonce, proof);
951 
952     if (_amount != 0)
953       this.send(from, _amount, "");
954 
955     this.operatorSend(from, to, amount, data, _data);
956 
957     emit LogProxiedTokens(from, to, amount, data, nonce, proof);
958   }
959 
960   function setPartnerContract(bytes32 _keyHash, address payable _partnerContract)
961     external
962     onlyOwner
963     addressNotNull(_partnerContract)
964   {
965     require(_keyHash != bytes32(0), "Missing key hash");
966     partnerContracts[_keyHash] = _partnerContract;
967 
968     emit LogPartnerContractSet(_keyHash, _partnerContract);
969   }
970 
971   function setUSDRateSetter(address _usdRateSetter)
972     external
973     onlyOwner
974     addressNotNull(_usdRateSetter)
975   {
976     usdRateSetter = _usdRateSetter;
977 
978     emit LogUSDRateSetterSet(_usdRateSetter);
979   }
980 
981   function setUSDRate(uint256 _numTokens, uint256 _numUSD)
982     external
983     onlyUSDRateSetter
984   {
985     doSetUSDRate(_numTokens, _numUSD);
986 
987     emit LogUSDRateSet(_numTokens, _numUSD);
988   }
989 
990   function setMintPermission(address _contract, bool _canMint)
991     external
992     onlyOwner
993     addressNotNull(_contract)
994   {
995     if (_canMint)
996       authorizeMinter(_contract);
997     else
998       revokeMinter(_contract);
999 
1000     emit LogMintPermissionSet(_contract, _canMint);
1001   }
1002 
1003   function doSetUSDRate(uint256 _numTokens, uint256 _numUSD)
1004     private
1005   {
1006     require(_numTokens != 0, "numTokens cannot be zero");
1007     require(_numUSD != 0, "numUSD cannot be zero");
1008     usdRate = [_numTokens, _numUSD];
1009   }
1010 
1011   function checkProxying(address _from, address _to, uint256 _amount, bytes memory _data, uint256 _nonce, bytes memory _proof)
1012     private
1013   {
1014     require(!proxyProofs[keccak256(_proof)], "Proxy proof not unique");
1015     proxyProofs[keccak256(_proof)] = true;
1016     bytes32 hash = keccak256(abi.encodePacked(address(this), _from, _to, _amount, _data, _nonce));
1017     address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(hash), _proof);
1018     require(signer == _from, "Bad signer");
1019   }
1020 }