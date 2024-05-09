1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
6  *
7  * These functions can be used to verify that a message was signed by the holder
8  * of the private keys of a given address.
9  */
10 library ECDSA {
11     /**
12      * @dev Returns the address that signed a hashed message (`hash`) with
13      * `signature`. This address can then be used for verification purposes.
14      *
15      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
16      * this function rejects them by requiring the `s` value to be in the lower
17      * half order, and the `v` value to be either 27 or 28.
18      *
19      * NOTE: This call _does not revert_ if the signature is invalid, or
20      * if the signer is otherwise unable to be retrieved. In those scenarios,
21      * the zero address is returned.
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
32             return (address(0));
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
59             return address(0);
60         }
61 
62         if (v != 27 && v != 28) {
63             return address(0);
64         }
65 
66         // If the signature is valid (and not malleable), return the signer address
67         return ecrecover(hash, v, r, s);
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
85 
86 /**
87  * @dev Contract module which provides a basic access control mechanism, where
88  * there is an account (an owner) that can be granted exclusive access to
89  * specific functions.
90  *
91  * This module is used through inheritance. It will make available the modifier
92  * `onlyOwner`, which can be applied to your functions to restrict their use to
93  * the owner.
94  */
95 contract Ownable {
96     address private _owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     /**
101      * @dev Initializes the contract setting the deployer as the initial owner.
102      */
103     constructor () internal {
104         _owner = msg.sender;
105         emit OwnershipTransferred(address(0), _owner);
106     }
107 
108     /**
109      * @dev Returns the address of the current owner.
110      */
111     function owner() public view returns (address) {
112         return _owner;
113     }
114 
115     /**
116      * @dev Throws if called by any account other than the owner.
117      */
118     modifier onlyOwner() {
119         require(isOwner(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     /**
124      * @dev Returns true if the caller is the current owner.
125      */
126     function isOwner() public view returns (bool) {
127         return msg.sender == _owner;
128     }
129 
130     /**
131      * @dev Leaves the contract without owner. It will not be possible to call
132      * `onlyOwner` functions anymore. Can only be called by the current owner.
133      *
134      * NOTE: Renouncing ownership will leave the contract without an owner,
135      * thereby removing any functionality that is only available to the owner.
136      */
137     function renounceOwnership() public onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142     /**
143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
144      * Can only be called by the current owner.
145      */
146     function transferOwnership(address newOwner) public onlyOwner {
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      */
153     function _transferOwnership(address newOwner) internal {
154         require(newOwner != address(0), "Ownable: new owner is the zero address");
155         emit OwnershipTransferred(_owner, newOwner);
156         _owner = newOwner;
157     }
158 }
159 
160 contract CampaignBank is Ownable {
161     using ECDSA for bytes32;
162 
163     mapping(address => bool) public trustedSigner;
164     mapping(bytes32 => bool) public alreadySent;
165 
166     event RegisteredSigner(
167         address indexed sender,
168         address indexed signer,
169         uint256 indexed date
170     );
171     event RemovedSigner(
172         address indexed sender,
173         address indexed signer,
174         uint256 indexed date
175     );
176     event Rewarded(
177         address indexed targetContract,
178         bytes32 indexed hashedSig,
179         bytes payload,
180         uint256 signedTimestamp,
181         bytes signature,
182         address sender
183     );
184 
185     constructor() public Ownable() {}
186 
187     function registerTrustedSigner(address target, bool allowed)
188         public
189         onlyOwner
190     {
191         if (allowed && !trustedSigner[target]) {
192             trustedSigner[target] = true;
193             emit RegisteredSigner(msg.sender, target, block.timestamp);
194         } else if (!allowed && trustedSigner[target]) {
195             trustedSigner[target] = false;
196             emit RemovedSigner(msg.sender, target, block.timestamp);
197         }
198     }
199 
200     event TransactionRelayed(
201         address indexed sender,
202         address indexed targetContract,
203         bytes payload,
204         uint256 value,
205         bytes signature
206     );
207 
208     function claimManyRewards(
209         address[] memory targetContract,
210         bytes[] memory payload,
211         uint256[] memory expirationTimestamp,
212         bytes[] memory signature
213     ) public {
214         require(
215             targetContract.length == payload.length,
216             "Arrays should be of the same size"
217         );
218         require(
219             targetContract.length == expirationTimestamp.length,
220             "Arrays should be of the same size"
221         );
222         require(
223             targetContract.length == signature.length,
224             "Arrays should be of the same size"
225         );
226         uint256 length = targetContract.length;
227 
228         for (uint256 i = 0; i < length; i++) {
229             if (
230                 !claimReward(
231                     targetContract[i],
232                     payload[i],
233                     expirationTimestamp[i],
234                     signature[i]
235                 )
236             ) {
237                 revert("Transaction failed");
238             }
239         }
240     }
241 
242     function claimReward(
243         address targetContract,
244         bytes memory payload,
245         uint256 expirationTimestamp,
246         bytes memory signature
247     ) public returns (bool) {
248         require(block.timestamp < expirationTimestamp, "Signature too old");
249 
250         bytes memory blob = abi.encode(
251             targetContract,
252             payload,
253             expirationTimestamp
254         );
255         bytes32 signed = keccak256(blob);
256         bytes32 verify = signed.toEthSignedMessageHash();
257         require(!alreadySent[signed], "Already sent!");
258 
259         require(
260             trustedSigner[verify.recover(signature)],
261             "Invalid signature provided"
262         );
263 
264         alreadySent[signed] = true;
265 
266         bool result;
267         (result,) = targetContract.call(payload);
268         if (!result) {
269             revert("Failed call");
270         }
271 
272         emit Rewarded(
273             targetContract,
274             signed,
275             payload,
276             expirationTimestamp,
277             signature,
278             msg.sender
279         );
280 
281         return true;
282     }
283 
284     function halt() public onlyOwner {
285         selfdestruct(address(uint256(owner())));
286     }
287 }