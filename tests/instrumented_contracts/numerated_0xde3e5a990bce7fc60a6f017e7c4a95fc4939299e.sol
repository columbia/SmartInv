1 // SPDX-License-Identifier: AGPL-3.0-only
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: GTCErc20
8 
9 /** 
10  * @title - A retroactive ERC20 token distribution contract 
11  * @author - zk@WolfDefi
12  * @notice - Provided an EIP712 compliant signed message & token claim, distributes GTC tokens 
13  **/
14 
15 /**
16 * @notice interface for interacting with GTCToken delegate function
17 */
18 interface GTCErc20 {
19     function delegateOnDist(address, address) external;
20 }
21 
22 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ECDSA
23 
24 /**
25  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
26  *
27  * These functions can be used to verify that a message was signed by the holder
28  * of the private keys of a given address.
29  */
30 library ECDSA {
31     /**
32      * @dev Returns the address that signed a hashed message (`hash`) with
33      * `signature`. This address can then be used for verification purposes.
34      *
35      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
36      * this function rejects them by requiring the `s` value to be in the lower
37      * half order, and the `v` value to be either 27 or 28.
38      *
39      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
40      * verification to be secure: it is possible to craft signatures that
41      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
42      * this is by receiving a hash of the original message (which may otherwise
43      * be too long), and then calling {toEthSignedMessageHash} on it.
44      */
45     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
46         // Check the signature length
47         if (signature.length != 65) {
48             revert("ECDSA: invalid signature length");
49         }
50 
51         // Divide the signature in r, s and v variables
52         bytes32 r;
53         bytes32 s;
54         uint8 v;
55 
56         // ecrecover takes the signature parameters, and the only way to get them
57         // currently is to use assembly.
58         // solhint-disable-next-line no-inline-assembly
59         assembly {
60             r := mload(add(signature, 0x20))
61             s := mload(add(signature, 0x40))
62             v := byte(0, mload(add(signature, 0x60)))
63         }
64 
65         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
66         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
67         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
68         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
69         //
70         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
71         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
72         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
73         // these malleable signatures as well.
74         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
75             revert("ECDSA: invalid signature 's' value");
76         }
77 
78         if (v != 27 && v != 28) {
79             revert("ECDSA: invalid signature 'v' value");
80         }
81 
82         // If the signature is valid (and not malleable), return the signer address
83         address signer = ecrecover(hash, v, r, s);
84         require(signer != address(0), "ECDSA: invalid signature");
85 
86         return signer;
87     }
88 
89     /**
90      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
91      * replicates the behavior of the
92      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
93      * JSON-RPC method.
94      *
95      * See {recover}.
96      */
97     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
98         // 32 is the length in bytes of hash,
99         // enforced by the type signature above
100         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
101     }
102 }
103 
104 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/MerkleProof
181 
182 /**
183  * @dev These functions deal with verification of Merkle trees (hash trees),
184  */
185 library MerkleProof {
186     /**
187      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
188      * defined by `root`. For this, a `proof` must be provided, containing
189      * sibling hashes on the branch from the leaf to the root of the tree. Each
190      * pair of leaves and each pair of pre-images are assumed to be sorted.
191      */
192     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
193         bytes32 computedHash = leaf;
194 
195         for (uint256 i = 0; i < proof.length; i++) {
196             bytes32 proofElement = proof[i];
197 
198             if (computedHash <= proofElement) {
199                 // Hash(current computed hash + current element of the proof)
200                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
201             } else {
202                 // Hash(current element of the proof + current computed hash)
203                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
204             }
205         }
206 
207         // Check if the computed hash (root) is equal to the provided root
208         return computedHash == root;
209     }
210 }
211 
212 // File: TokenDistributor.sol
213 
214 contract TokenDistributor{ 
215     
216     address immutable public signer;
217     address immutable public token; 
218     uint immutable public deployTime;
219     address immutable public timeLockContract;
220     bytes32 immutable public merkleRoot;
221 
222     // hash of the domain separator
223     bytes32 DOMAIN_SEPARATOR;
224 
225     // This is a packed array of booleans.
226     mapping(uint256 => uint256) private claimedBitMap;
227     
228     // EIP712 domain struct 
229     struct EIP712Domain {
230         string  name;
231         string  version;
232         uint256 chainId;
233         address verifyingContract;
234     }
235 
236     // How long will this contract process token claims? 30 days
237     uint public constant CONTRACT_ACTIVE = 30 days;
238 
239     // as required by EIP712, we create type hash that will be rolled up into the final signed message
240     bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
241         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
242     );
243 
244     // typehash for our token claim - matches the Claim struct  
245     bytes32 constant GTC_TOKEN_CLAIM_TYPEHASH = keccak256(
246         "Claim(uint32 user_id,address user_address,uint256 user_amount,address delegate_address,bytes32 leaf)"
247     );
248     
249     // This event is triggered when a call to ClaimTokens succeeds.
250     event Claimed(uint256 user_id, address account, uint256 amount, bytes32 leaf);
251 
252     // This event is triggered when unclaimed drops are moved to Timelock after CONTRACT_ACTIVE period 
253     event TransferUnclaimed(uint256 amount);
254 
255     /**
256      * @notice Construct a new TokenDistribution contract 
257      * @param _signer - public key matching the private key that will be signing claims
258      * @param _token - address of ERC20 that claims will be distributed from
259      * @param _timeLock - address of the timelock contract where unclaimed funds will be swept   
260      **/
261     constructor(address _token, address _signer, address _timeLock, bytes32 _merkleRoot) public {
262         signer = _signer;
263         token = _token;
264         merkleRoot = _merkleRoot;
265         timeLockContract = _timeLock;
266         deployTime = block.timestamp; 
267         
268         DOMAIN_SEPARATOR = hash(EIP712Domain({
269             name: "GTC",
270             version: '1.0.0',
271             chainId: 1,
272             verifyingContract: address(this)
273         }));
274 
275     }
276     
277     /**
278     * @notice process incoming token claims, must be signed by <signer>  
279     * @param user_id - serves as nonce - only one claim per user_id
280     * @param user_address - ethereum account token claim will be transfered too
281     * @param user_amount - amount user will receive, in wei
282     * @param delegate_address - address token claim will be deletaged too 
283     * @param eth_signed_message_hash_hex - EIP712 pre-signed message hash payload
284     * @param eth_signed_signature_hex = eth_sign style, EIP712 compliant, signed message
285     * @param merkleProof - proof hashes for leaf
286     * @param leaf - leaf hash for user claim in merkle tree    
287     **/
288     function claimTokens(
289         uint32 user_id, 
290         address user_address, 
291         uint256 user_amount,
292         address delegate_address, 
293         bytes32 eth_signed_message_hash_hex, 
294         bytes memory eth_signed_signature_hex,
295         bytes32[] calldata merkleProof,
296         bytes32 leaf
297 
298         ) external {
299 
300         // only accept claim if msg.sender address is in signed claim   
301         require(msg.sender == user_address, 'TokenDistributor: Must be msg sender.');
302 
303         // one claim per user  
304         require(!isClaimed(user_id), 'TokenDistributor: Tokens already claimed.');
305         
306         // claim must provide a message signed by defined <signer>  
307         require(isSigned(eth_signed_message_hash_hex, eth_signed_signature_hex), 'TokenDistributor: Valid Signature Required.');
308         
309         bytes32 hashed_base_claim = keccak256(abi.encode( 
310             GTC_TOKEN_CLAIM_TYPEHASH,
311             user_id,
312             user_address,
313             user_amount, 
314             delegate_address, 
315             leaf
316         ));
317 
318         bytes32 digest = keccak256(abi.encodePacked(
319             "\x19\x01",
320             DOMAIN_SEPARATOR,
321             hashed_base_claim
322         ));
323 
324         // can we reproduce the same hash from the raw claim metadata? 
325         require(digest == eth_signed_message_hash_hex, 'TokenDistributor: Claim Hash Mismatch.');
326         
327         // can we repoduce leaf hash included in the claim?
328         bytes32 leaf_hash = keccak256(abi.encode(keccak256(abi.encode(user_id, user_amount))));
329         require(leaf == leaf_hash, 'TokenDistributor: Leaf Hash Mismatch.');
330 
331         // does the leaf exist on our tree? 
332         require(MerkleProof.verify(merkleProof, merkleRoot, leaf), 'TokenDistributor: Valid Proof Required.');
333         
334         // process token claim !! 
335         _delegateTokens(user_address, delegate_address); 
336         _setClaimed(user_id);
337    
338         require(IERC20(token).transfer(user_address, user_amount), 'TokenDistributor: Transfer failed.');
339         emit Claimed(user_id, user_address, user_amount, leaf);
340     }
341     
342     /**
343     * @notice checks claimedBitMap to see if if user_id is 0/1
344     * @dev fork from uniswap merkle distributor, unmodified
345     * @return - boolean  
346     **/
347     function isClaimed(uint256 index) public view returns (bool) {
348         uint256 claimedWordIndex = index / 256;
349         uint256 claimedBitIndex = index % 256;
350         uint256 claimedWord = claimedBitMap[claimedWordIndex];
351         uint256 mask = (1 << claimedBitIndex);
352         return claimedWord & mask == mask;
353     }
354     
355     /**
356     * @notice used to move any remaining tokens out of the contract after expiration   
357     **/
358     function transferUnclaimed() public {
359         require(block.timestamp >= deployTime + CONTRACT_ACTIVE, 'TokenDistributor: Contract is still active.');
360         // transfer all GTC to TimeLock
361         uint remainingBalance = IERC20(token).balanceOf(address(this));
362         require(IERC20(token).transfer(timeLockContract, remainingBalance), 'TokenDistributor: Transfer unclaimed failed.');
363         emit TransferUnclaimed(remainingBalance);
364     }
365 
366     /**
367     * @notice verify that a message was signed by the holder of the private keys of a given address
368     * @return true if message was signed by signer designated on contstruction, else false 
369     **/
370     function isSigned(bytes32 eth_signed_message_hash_hex, bytes memory eth_signed_signature_hex) internal view returns (bool) {
371         address untrusted_signer = ECDSA.recover(eth_signed_message_hash_hex, eth_signed_signature_hex);
372         return untrusted_signer == signer;
373     }
374 
375     /**
376     * @notice - function can be used to create DOMAIN_SEPARATORs
377     * @dev - from EIP712 spec, unmodified 
378     **/
379     function hash(EIP712Domain memory eip712Domain) internal pure returns (bytes32) {
380         return keccak256(abi.encode(
381             EIP712DOMAIN_TYPEHASH,
382             keccak256(bytes(eip712Domain.name)),
383             keccak256(bytes(eip712Domain.version)),
384             eip712Domain.chainId,
385             eip712Domain.verifyingContract
386         ));
387     }
388 
389     /**
390     * @notice Sets a given user_id to claimed 
391     * @dev taken from uniswap merkle distributor, unmodified
392     **/
393     function _setClaimed(uint256 index) private {
394         uint256 claimedWordIndex = index / 256;
395         uint256 claimedBitIndex = index % 256;
396         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
397     }
398 
399     /**
400     * @notice execute call on token contract to delegate tokens   
401     */
402     function _delegateTokens(address delegator, address delegatee) private {
403          GTCErc20  GTCToken = GTCErc20(token);
404          GTCToken.delegateOnDist(delegator, delegatee);
405     } 
406 }
