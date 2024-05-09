1 // Sources flattened with hardhat v2.0.6 https://hardhat.org
2 
3 // File contracts/ERC20/IERC20.sol
4 
5 // SPDX-License-Identifier: No License
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 
16     function balanceOf(address account) external view returns (uint256);
17     function totalSupply() external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
24     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
25 }
26 
27 
28 pragma solidity 0.8.0;
29 
30 /**
31  * @dev Implementation of the {IERC20} interface.
32  *
33  * This implementation is agnostic to the way tokens are created. This means
34  * that a supply mechanism has to be added in a derived contract using {_mint}.
35  * For a generic mechanism see {ERC20PresetMinterPauser}.
36  *
37  * TIP: For a detailed writeup see our guide
38  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
39  * to implement supply mechanisms].
40  *
41  * We have followed general OpenZeppelin guidelines: functions revert instead
42  * of returning `false` on failure. This behavior is nonetheless conventional
43  * and does not conflict with the expectations of ERC20 applications.
44  *
45  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
46  * This allows applications to reconstruct the allowance for all accounts just
47  * by listening to said events. Other implementations of the EIP may not emit
48  * these events, as it isn't required by the specification.
49  *
50  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
51  * functions have been added to mitigate the well-known issues around setting
52  * allowances. See {IERC20-approve}.
53  */
54 contract ERC20 is IERC20 {
55 
56   mapping (address => uint256) private _balances;
57 
58   mapping (address => mapping (address => uint256)) private _allowances;
59 
60   uint256 private _totalSupply;
61 
62   string public name;
63   uint8 public decimals;
64   string public symbol;
65 
66   constructor (string memory name_, string memory symbol_) {
67     name = name_;
68     symbol = symbol_;
69     decimals = 18;
70   }
71 
72   function balanceOf(address account) external view override returns (uint256) {
73     return _balances[account];
74   }
75 
76   function totalSupply() external view override returns (uint256) {
77     return _totalSupply;
78   }
79 
80   function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
81     _transfer(msg.sender, recipient, amount);
82     return true;
83   }
84 
85   function allowance(address owner, address spender) external view virtual override returns (uint256) {
86     return _allowances[owner][spender];
87   }
88 
89   function approve(address spender, uint256 amount) external virtual override returns (bool) {
90     _approve(msg.sender, spender, amount);
91     return true;
92   }
93 
94   function transferFrom(address sender, address recipient, uint256 amount)
95     external virtual override returns (bool)
96   {
97     _transfer(sender, recipient, amount);
98     _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
99     return true;
100   }
101 
102   function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
103     _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
104     return true;
105   }
106 
107   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
108     _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
109     return true;
110   }
111 
112   function _mint(address _account, uint256 _amount) internal virtual {
113     require(_account != address(0), "ERC20: mint to the zero address");
114 
115     _totalSupply = _totalSupply + _amount;
116     _balances[_account] = _balances[_account] + _amount;
117     emit Transfer(address(0), _account, _amount);
118   }
119 
120   function _approve(address owner, address spender, uint256 amount) internal {
121     require(owner != address(0), "ERC20: approve from the zero address");
122     require(spender != address(0), "ERC20: approve to the zero address");
123 
124     _allowances[owner][spender] = amount;
125     emit Approval(owner, spender, amount);
126   }
127 
128   function _transfer(address sender, address recipient, uint256 amount) internal {
129     require(sender != address(0), "ERC20: transfer from the zero address");
130     require(recipient != address(0), "ERC20: transfer to the zero address");
131 
132     _balances[sender] = _balances[sender] - amount;
133     _balances[recipient] = _balances[recipient] + amount;
134     emit Transfer(sender, recipient, amount);
135   }
136 
137   function _burn(address account, uint256 amount) internal {
138     require(account != address(0), "ERC20: burn from the zero address");
139 
140     _balances[account] = _balances[account] - amount;
141     _totalSupply = _totalSupply - amount;
142     emit Transfer(account, address(0), amount);
143   }
144 }
145 
146 
147 pragma solidity 0.8.0;
148 
149 /**
150  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
151  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
152  *
153  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
154  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
155  * need to send a transaction, and thus is not required to hold Ether at all.
156  */
157 interface IERC20Permit {
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
160      * given `owner`'s signed approval.
161      *
162      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
163      * ordering also apply here.
164      *
165      * Emits an {Approval} event.
166      *
167      * Requirements:
168      *
169      * - `spender` cannot be the zero address.
170      * - `deadline` must be a timestamp in the future.
171      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
172      * over the EIP712-formatted function arguments.
173      * - the signature must use ``owner``'s current nonce (see {nonces}).
174      *
175      * For more information on the signature format, see the
176      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
177      * section].
178      */
179     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
180 
181     /**
182      * @dev Returns the current nonce for `owner`. This value must be
183      * included whenever a signature is generated for {permit}.
184      *
185      * Every successful call to {permit} increases ``owner``'s nonce by one. This
186      * prevents a signature from being used multiple times.
187      */
188     function nonces(address owner) external view returns (uint256);
189 
190     /**
191      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
192      */
193     // solhint-disable-next-line func-name-mixedcase
194     function DOMAIN_SEPARATOR() external view returns (bytes32);
195 }
196 
197 /**
198  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
199  *
200  * These functions can be used to verify that a message was signed by the holder
201  * of the private keys of a given address.
202  */
203 library ECDSA {
204     /**
205      * @dev Returns the address that signed a hashed message (`hash`) with
206      * `signature`. This address can then be used for verification purposes.
207      *
208      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
209      * this function rejects them by requiring the `s` value to be in the lower
210      * half order, and the `v` value to be either 27 or 28.
211      *
212      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
213      * verification to be secure: it is possible to craft signatures that
214      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
215      * this is by receiving a hash of the original message (which may otherwise
216      * be too long), and then calling {toEthSignedMessageHash} on it.
217      */
218     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
219         // Check the signature length
220         if (signature.length != 65) {
221             revert("ECDSA: invalid signature length");
222         }
223 
224         // Divide the signature in r, s and v variables
225         bytes32 r;
226         bytes32 s;
227         uint8 v;
228 
229         // ecrecover takes the signature parameters, and the only way to get them
230         // currently is to use assembly.
231         // solhint-disable-next-line no-inline-assembly
232         assembly {
233             r := mload(add(signature, 0x20))
234             s := mload(add(signature, 0x40))
235             v := byte(0, mload(add(signature, 0x60)))
236         }
237 
238         return recover(hash, v, r, s);
239     }
240 
241     /**
242      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
243      * `r` and `s` signature fields separately.
244      */
245     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
246         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
247         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
248         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
249         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
250         //
251         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
252         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
253         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
254         // these malleable signatures as well.
255         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
256         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
257 
258         // If the signature is valid (and not malleable), return the signer address
259         address signer = ecrecover(hash, v, r, s);
260         require(signer != address(0), "ECDSA: invalid signature");
261 
262         return signer;
263     }
264 
265     /**
266      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
267      * replicates the behavior of the
268      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
269      * JSON-RPC method.
270      *
271      * See {recover}.
272      */
273     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
274         // 32 is the length in bytes of hash,
275         // enforced by the type signature above
276         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
277     }
278 }
279 
280 pragma solidity 0.8.0;
281 
282 /**
283  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
284  *
285  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
286  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
287  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
288  *
289  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
290  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
291  * ({_hashTypedDataV4}).
292  *
293  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
294  * the chain id to protect against replay attacks on an eventual fork of the chain.
295  *
296  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
297  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
298  *
299  */
300 abstract contract EIP712 {
301     /* solhint-disable var-name-mixedcase */
302     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
303     // invalidate the cached domain separator if the chain id changes.
304     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
305     uint256 private immutable _CACHED_CHAIN_ID;
306 
307     bytes32 private immutable _HASHED_NAME;
308     bytes32 private immutable _HASHED_VERSION;
309     bytes32 private immutable _TYPE_HASH;
310     /* solhint-enable var-name-mixedcase */
311 
312     /**
313      * @dev Initializes the domain separator and parameter caches.
314      *
315      * The meaning of `name` and `version` is specified in
316      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
317      *
318      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
319      * - `version`: the current major version of the signing domain.
320      *
321      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
322      * contract upgrade].
323      */
324     constructor(string memory name, string memory version) {
325         bytes32 hashedName = keccak256(bytes(name));
326         bytes32 hashedVersion = keccak256(bytes(version));
327         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"); 
328         _HASHED_NAME = hashedName;
329         _HASHED_VERSION = hashedVersion;
330         _CACHED_CHAIN_ID = _getChainId();
331         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
332         _TYPE_HASH = typeHash;
333     }
334 
335     /**
336      * @dev Returns the domain separator for the current chain.
337      */
338     function _domainSeparatorV4() internal view returns (bytes32) {
339         if (_getChainId() == _CACHED_CHAIN_ID) {
340             return _CACHED_DOMAIN_SEPARATOR;
341         } else {
342             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
343         }
344     }
345 
346     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
347         return keccak256(
348             abi.encode(
349                 typeHash,
350                 name,
351                 version,
352                 _getChainId(),
353                 address(this)
354             )
355         );
356     }
357 
358     /**
359      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
360      * function returns the hash of the fully encoded EIP712 message for this domain.
361      *
362      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
363      *
364      * ```solidity
365      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
366      *     keccak256("Mail(address to,string contents)"),
367      *     mailTo,
368      *     keccak256(bytes(mailContents))
369      * )));
370      * address signer = ECDSA.recover(digest, signature);
371      * ```
372      */
373     function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
374         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
375     }
376 
377     function _getChainId() private view returns (uint256 chainId) {
378         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
379         // solhint-disable-next-line no-inline-assembly
380         assembly {
381             chainId := chainid()
382         }
383     }
384 }
385 
386 /**
387  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
388  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
389  *
390  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
391  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
392  * need to send a transaction, and thus is not required to hold Ether at all.
393  */
394 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
395 
396     mapping (address => uint256) private _nonces;
397 
398     // solhint-disable-next-line var-name-mixedcase
399     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
400 
401     /**
402      * @dev Initializes the {EIP712} domain separator using the `symbol` parameter (since symbol is more unique for Cover), and setting `version` to `"1"`.
403      *
404      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
405      */
406     constructor(string memory name) EIP712(name, "1") {
407     }
408 
409     /**
410      * @dev See {IERC20Permit-permit}.
411      */
412     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
413         // solhint-disable-next-line not-rely-on-time
414         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
415 
416         bytes32 structHash = keccak256(
417             abi.encode(
418                 _PERMIT_TYPEHASH,
419                 owner,
420                 spender,
421                 amount,
422                 _nonces[owner],
423                 deadline
424             )
425         );
426 
427         bytes32 hash = _hashTypedDataV4(structHash);
428 
429         address signer = ECDSA.recover(hash, v, r, s);
430         require(signer == owner, "ERC20Permit: invalid signature");
431 
432         _nonces[owner]++;
433         _approve(owner, spender, amount);
434     }
435 
436     /**
437      * @dev See {IERC20Permit-nonces}.
438      */
439     function nonces(address owner) public view override returns (uint256) {
440         return _nonces[owner];
441     }
442 
443     /**
444      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
445      */
446     // solhint-disable-next-line func-name-mixedcase
447     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
448         return _domainSeparatorV4();
449     }
450 }
451 
452 
453 /**
454  * @dev Contract module which provides a basic access control mechanism, where
455  * there is an account (an owner) that can be granted exclusive access to
456  * specific functions.
457  * @author crypto-pumpkin@github
458  *
459  * By initialization, the owner account will be the one that called initializeOwner. This
460  * can later be changed with {transferOwnership}.
461  *
462  * This module is used through inheritance. It will make available the modifier
463  * `onlyOwner`, which can be applied to your functions to restrict their use to
464  * the owner.
465  */
466 contract Ownable {
467     address private _owner;
468 
469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470 
471     /**
472      * @dev COVER: Initializes the contract setting the deployer as the initial owner.
473      */
474     constructor () {
475         _owner = msg.sender;
476         emit OwnershipTransferred(address(0), _owner);
477     }
478 
479     /**
480      * @dev Returns the address of the current owner.
481      */
482     function owner() public view returns (address) {
483         return _owner;
484     }
485 
486     /**
487      * @dev Throws if called by any account other than the owner.
488      */
489     modifier onlyOwner() {
490         require(_owner == msg.sender, "Ownable: caller is not the owner");
491         _;
492     }
493 
494     /**
495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
496      * Can only be called by the current owner.
497      */
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(newOwner != address(0), "Ownable: new owner is the zero address");
500         emit OwnershipTransferred(_owner, newOwner);
501         _owner = newOwner;
502     }
503 }
504 
505 
506 /**
507  * @title Cover Protocol Governance Token contract
508  * @author crypto-pumpkin
509  */
510 contract COVER is ERC20Permit, Ownable {
511 
512   address public distributor; // cover distributor
513 
514   constructor (
515     string memory _name,
516     string memory _symbol
517   ) ERC20(_name, _symbol) ERC20Permit(_name) {
518   }
519 
520   function mint(address _account, uint256 _amount) public {
521     require(msg.sender == distributor, "COVER: caller not distributor");
522     _mint(_account, _amount);
523   }
524 
525   function setDistributor(address _distributor) external onlyOwner {
526     distributor = _distributor;
527   }
528 }