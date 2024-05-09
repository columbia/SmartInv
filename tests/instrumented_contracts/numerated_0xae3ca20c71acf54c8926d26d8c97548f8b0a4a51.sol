1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3 */
4 
5 // File: contracts/LiteSig.sol
6 
7 pragma solidity 0.6.12;
8 
9 /**
10  * LiteSig is a lighter weight multisig based on https://github.com/christianlundkvist/simple-multisig
11  * Owners aggregate signatures offline and then broadcast a transaction with the required number of signatures.
12  * Unlike other multisigs, this is meant to have minimal administration functions and other features in order
13  * to reduce the footprint and attack surface.
14  */
15 contract LiteSig {
16 
17     //  Events triggered for incoming and outgoing transactions
18     event Deposit(address indexed source, uint value);
19     event Execution(uint indexed transactionId, address indexed destination, uint value, bytes data);
20     event ExecutionFailure(uint indexed transactionId, address indexed destination, uint value, bytes data);
21 
22     // List of owner addresses - for external readers convenience only
23     address[] public owners;
24 
25     // Mapping of owner address to keep track for lookups
26     mapping(address => bool) ownersMap;
27 
28     // Nonce increments by one on each broadcast transaction to prevent replays
29     uint public nonce = 0;
30 
31     // Number of required signatures from the list of owners
32     uint public requiredSignatures = 0;
33 
34     // EIP712 Precomputed hashes:
35     // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
36     bytes32 constant EIP712DOMAINTYPE_HASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;
37 
38     // keccak256("LiteSig")
39     bytes32 constant NAME_HASH = 0x3308695f49e3f28122810c848e1569a04488ca4f6a11835568450d7a38a86120;
40 
41     // keccak256("1")
42     bytes32 constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
43 
44     // keccak256("MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address txOrigin)")
45     bytes32 constant TXTYPE_HASH = 0x81336c6b66e18c614f29c0c96edcbcbc5f8e9221f35377412f0ea5d6f428918e;
46 
47     // keccak256("TOKENSOFT")
48     bytes32 constant SALT = 0x9c360831104e550f13ec032699c5f1d7f17190a31cdaf5c83945a04dfd319eea;
49 
50     // Hash for EIP712, computed from data and contract address - ensures it can't be replayed against
51     // other contracts or chains
52     bytes32 public DOMAIN_SEPARATOR;
53 
54     // Track init state
55     bool initialized = false;
56 
57     // The init function inputs a list of owners and the number of signatures that
58     //   are required before a transaction is executed.
59     // Owners list must be in ascending address order.
60     // Required sigs must be greater than 0 and less than or equal to number of owners.
61     // Chain ID prevents replay across chains
62     // This function can only be run one time
63     function init(address[] memory _owners, uint _requiredSignatures, uint chainId) public {
64         // Verify it can't be initialized again
65         require(!initialized, "Init function can only be run once");
66         initialized = true;
67 
68         // Verify the lengths of values being passed in
69         require(_owners.length > 0 && _owners.length <= 10, "Owners List min is 1 and max is 10");
70         require(
71             _requiredSignatures > 0 && _requiredSignatures <= _owners.length,
72             "Required signatures must be in the proper range"
73         );
74 
75         // Verify the owners list is valid and in order
76         // No 0 addresses or duplicates
77         address lastAdd = address(0);
78         for (uint i = 0; i < _owners.length; i++) {
79             require(_owners[i] > lastAdd, "Owner addresses must be unique and in order");
80             ownersMap[_owners[i]] = true;
81             lastAdd = _owners[i];
82         }
83 
84         // Save off owner list and required sig.
85         owners = _owners;
86         requiredSignatures = _requiredSignatures;
87 
88         DOMAIN_SEPARATOR = keccak256(
89             abi.encode(EIP712DOMAINTYPE_HASH,
90             NAME_HASH,
91             VERSION_HASH,
92             chainId,
93             address(this),
94             SALT)
95         );
96     }
97 
98     /**
99      * This function is adapted from the OpenZeppelin libarary but instead of passing in bytes
100      * array, it already has the sig fields broken down.
101      *
102      * @dev Returns the address that signed a hashed message (`hash`) with
103      * `signature`. This address can then be used for verification purposes.
104      *
105      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
106      * this function rejects them by requiring the `s` value to be in the lower
107      * half order, and the `v` value to be either 27 or 28.
108      *
109      * (.note) This call _does not revert_ if the signature is invalid, or
110      * if the signer is otherwise unable to be retrieved. In those scenarios,
111      * the zero address is returned.
112      *
113      * (.warning) `hash` _must_ be the result of a hash operation for the
114      * verification to be secure: it is possible to craft signatures that
115      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
116      * this is by receiving a hash of the original message (which may otherwise)
117      * be too long), and then calling `toEthSignedMessageHash` on it.
118      */
119     function safeRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
120 
121         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
122         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
123         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
124         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
125         //
126         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
127         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
128         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
129         // these malleable signatures as well.
130         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
131             return address(0);
132         }
133 
134         if (v != 27 && v != 28) {
135             return address(0);
136         }
137 
138         // If the signature is valid (and not malleable), return the signer address
139         return ecrecover(hash, v, r, s);
140     }
141 
142     /**
143      * Once the owners of the multisig have signed across the payload, they can submit it to this function.
144      * This will verify enough signatures were aggregated and then broadcast the transaction.
145      * It can be used to send ETH or trigger a function call against another address (or both).
146      *
147      * Signatures must be in the correct ascending order (according to associated addresses)
148      */
149     function submit(
150         uint8[] memory sigV,
151         bytes32[] memory sigR,
152         bytes32[] memory sigS,
153         address destination,
154         uint value,
155         bytes memory data
156     ) public returns (bool)
157     {
158         // Verify initialized
159         require(initialized, "Initialization must be complete");
160 
161         // Verify signature lengths
162         require(sigR.length == sigS.length && sigR.length == sigV.length, "Sig arrays not the same lengths");
163         require(sigR.length == requiredSignatures, "Signatures list is not the expected length");
164 
165         // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
166         // Note that the nonce is always included from the contract state to prevent replay attacks
167         // Note that tx.origin is included to ensure only a predetermined account can broadcast
168         bytes32 txInputHash = keccak256(abi.encode(TXTYPE_HASH, destination, value, keccak256(data), nonce, tx.origin));
169         bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, txInputHash));
170 
171         // Add in the ETH specific prefix
172         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
173         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, totalHash));
174 
175         // Iterate and verify signatures are from owners
176         address lastAdd = address(0); // cannot have address(0) as an owner
177         for (uint i = 0; i < requiredSignatures; i++) {
178 
179             // Recover the address from the signature - if anything is wrong, this will return 0
180             address recovered = safeRecover(prefixedHash, sigV[i], sigR[i], sigS[i]);
181 
182             // Ensure the signature is from an owner address and there are no duplicates
183             // Also verifies error of 0 returned
184             require(ownersMap[recovered], "Signature must be from an owner");
185             require(recovered > lastAdd, "Signature must be unique");
186             lastAdd = recovered;
187         }
188 
189         // Increment the nonce before making external call
190         nonce = nonce + 1;
191         (bool success, ) = address(destination).call{value: value}(data);
192         if(success) {
193             emit Execution(nonce, destination, value, data);
194         } else {
195             emit ExecutionFailure(nonce, destination, value, data);
196         }
197 
198         return success;
199     }
200 
201     // Allow ETH to be sent to this contract
202     receive () external payable {
203         emit Deposit(msg.sender, msg.value);
204     }
205 
206 }
207 
208 // File: @openzeppelin/contracts/GSN/Context.sol
209 
210 
211 pragma solidity ^0.6.0;
212 
213 /*
214  * @dev Provides information about the current execution context, including the
215  * sender of the transaction and its data. While these are generally available
216  * via msg.sender and msg.data, they should not be accessed in such a direct
217  * manner, since when dealing with GSN meta-transactions the account sending and
218  * paying for execution may not be the actual sender (as far as an application
219  * is concerned).
220  *
221  * This contract is only required for intermediate, library-like contracts.
222  */
223 abstract contract Context {
224     function _msgSender() internal view virtual returns (address payable) {
225         return msg.sender;
226     }
227 
228     function _msgData() internal view virtual returns (bytes memory) {
229         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
230         return msg.data;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/access/Ownable.sol
235 
236 
237 
238 pragma solidity ^0.6.0;
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor () internal {
261         address msgSender = _msgSender();
262         _owner = msgSender;
263         emit OwnershipTransferred(address(0), msgSender);
264     }
265 
266     /**
267      * @dev Returns the address of the current owner.
268      */
269     function owner() public view returns (address) {
270         return _owner;
271     }
272 
273     /**
274      * @dev Throws if called by any account other than the owner.
275      */
276     modifier onlyOwner() {
277         require(_owner == _msgSender(), "Ownable: caller is not the owner");
278         _;
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public virtual onlyOwner {
289         emit OwnershipTransferred(_owner, address(0));
290         _owner = address(0);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Can only be called by the current owner.
296      */
297     function transferOwnership(address newOwner) public virtual onlyOwner {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         emit OwnershipTransferred(_owner, newOwner);
300         _owner = newOwner;
301     }
302 }
303 
304 // File: contracts/Administratable.sol
305 
306 pragma solidity 0.6.12;
307 
308 
309 /**
310 This contract allows a list of administrators to be tracked.  This list can then be enforced
311 on functions with administrative permissions.  Only the owner of the contract should be allowed
312 to modify the administrator list.
313  */
314 contract Administratable is Ownable {
315 
316     // The mapping to track administrator accounts - true is reserved for admin addresses.
317     mapping (address => bool) public administrators;
318 
319     // Events to allow tracking add/remove.
320     event AdminAdded(address indexed addedAdmin, address indexed addedBy);
321     event AdminRemoved(address indexed removedAdmin, address indexed removedBy);
322 
323     /**
324     Function modifier to enforce administrative permissions.
325      */
326     modifier onlyAdministrator() {
327         require(isAdministrator(msg.sender), "Calling account is not an administrator.");
328         _;
329     }
330 
331     /**
332     Determine if the message sender is in the administrators list.
333      */
334     function isAdministrator(address addressToTest) public view returns (bool) {
335         return administrators[addressToTest];
336     }
337 
338     /**
339     Add an admin to the list.  This should only be callable by the owner of the contract.
340      */
341     function addAdmin(address adminToAdd) public onlyOwner {
342         // Verify the account is not already an admin
343         require(administrators[adminToAdd] == false, "Account to be added to admin list is already an admin");
344 
345         // Set the address mapping to true to indicate it is an administrator account.
346         administrators[adminToAdd] = true;
347 
348         // Emit the event for any watchers.
349         emit AdminAdded(adminToAdd, msg.sender);
350     }
351 
352     /**
353     Remove an admin from the list.  This should only be callable by the owner of the contract.
354      */
355     function removeAdmin(address adminToRemove) public onlyOwner {
356         // Verify the account is an admin
357         require(administrators[adminToRemove] == true, "Account to be removed from admin list is not already an admin");
358 
359         // Set the address mapping to false to indicate it is NOT an administrator account.
360         administrators[adminToRemove] = false;
361 
362         // Emit the event for any watchers.
363         emit AdminRemoved(adminToRemove, msg.sender);
364     }
365 }
366 
367 // File: contracts/Proxy.sol
368 
369 pragma solidity 0.6.12;
370 
371 contract Proxy {
372     
373     // Code position in storage is:
374     // keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
375     uint256 constant PROXIABLE_SLOT = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
376 
377     constructor(address contractLogic) public {
378         // Verify a valid address was passed in
379         require(contractLogic != address(0), "Contract Logic cannot be 0x0");
380 
381         // save the code address
382         assembly { // solium-disable-line
383             sstore(PROXIABLE_SLOT, contractLogic)
384         }
385     }
386 
387     fallback() external payable {
388         assembly { // solium-disable-line
389             let contractLogic := sload(PROXIABLE_SLOT)
390             let ptr := mload(0x40)
391             calldatacopy(ptr, 0x0, calldatasize())
392             let success := delegatecall(gas(), contractLogic, ptr, calldatasize(), 0, 0)
393             let retSz := returndatasize()
394             returndatacopy(ptr, 0, retSz)
395             switch success
396             case 0 {
397                 revert(ptr, retSz)
398             }
399             default {
400                 return(ptr, retSz)
401             }
402         }
403     }
404 }
405 
406 // File: contracts/LiteSigFactory.sol
407 
408 pragma solidity 0.6.12;
409 
410 
411 
412 
413 /**
414  * LiteSig Factory creates new instances of the proxy class pointing to the multisig 
415  * contract and triggers an event for listeners to see the new contract.
416  */
417 contract LiteSigFactory is Administratable {
418 
419   // Event to track deployments
420   event Deployed(address indexed deployedAddress);
421 
422   // Address where LiteSig logic contract lives
423   address public liteSigLogicAddress;
424 
425   // Constructor for the factory
426   constructor(address _liteSigLogicAddress) public {
427     // Add the deployer as an admin by default
428     Administratable.addAdmin(msg.sender);
429 
430     // Save the logic address
431     liteSigLogicAddress = _liteSigLogicAddress;
432   }
433 
434   /**
435    * Function called by external addresses to create a new multisig contract
436    * Caller must be whitelisted as an admin - this is to prevent someone from sniping the address
437    * (the standard approach to locking in the sender addr into the salt was not chosen in case a long time
438    * passes before the contract is created and a new deployment account is required for some unknown reason)
439    */
440   function createLiteSig(bytes32 salt, address[] memory _owners, uint _requiredSignatures, uint chainId)
441     public onlyAdministrator returns (address) {
442     // Track the address for the new contract
443     address payable deployedAddress;
444 
445     // Get the creation code from the Proxy class
446     bytes memory code = type(Proxy).creationCode;
447 
448     // Pack the constructor arg for the proxy initialization
449     bytes memory deployCode = abi.encodePacked(code, abi.encode(liteSigLogicAddress));
450 
451     // Drop into assembly to deploy with create2
452     assembly {
453       deployedAddress := create2(0, add(deployCode, 0x20), mload(deployCode), salt)
454       if iszero(extcodesize(deployedAddress)) { revert(0, 0) }
455     }
456 
457     // Initialize the contract with this master's address
458     LiteSig(deployedAddress).init(_owners, _requiredSignatures, chainId);
459 
460     // Trigger the event for any listeners
461     emit Deployed(deployedAddress);
462 
463     // Return address back to caller if applicable
464     return deployedAddress;
465   }
466 }