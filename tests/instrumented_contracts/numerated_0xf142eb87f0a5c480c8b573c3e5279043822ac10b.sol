1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
81  *
82  * These functions can be used to verify that a message was signed by the holder
83  * of the private keys of a given address.
84  */
85 library ECDSA {
86     /**
87      * @dev Returns the address that signed a hashed message (`hash`) with
88      * `signature`. This address can then be used for verification purposes.
89      *
90      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
91      * this function rejects them by requiring the `s` value to be in the lower
92      * half order, and the `v` value to be either 27 or 28.
93      *
94      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
95      * verification to be secure: it is possible to craft signatures that
96      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
97      * this is by receiving a hash of the original message (which may otherwise
98      * be too long), and then calling {toEthSignedMessageHash} on it.
99      */
100     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
101         // Check the signature length
102         if (signature.length != 65) {
103             revert("ECDSA: invalid signature length");
104         }
105 
106         // Divide the signature in r, s and v variables
107         bytes32 r;
108         bytes32 s;
109         uint8 v;
110 
111         // ecrecover takes the signature parameters, and the only way to get them
112         // currently is to use assembly.
113         // solhint-disable-next-line no-inline-assembly
114         assembly {
115             r := mload(add(signature, 0x20))
116             s := mload(add(signature, 0x40))
117             v := byte(0, mload(add(signature, 0x60)))
118         }
119 
120         return recover(hash, v, r, s);
121     }
122 
123     /**
124      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
125      * `r` and `s` signature fields separately.
126      */
127     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
128         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
129         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
130         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
131         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
132         //
133         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
134         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
135         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
136         // these malleable signatures as well.
137         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
138         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
139 
140         // If the signature is valid (and not malleable), return the signer address
141         address signer = ecrecover(hash, v, r, s);
142         require(signer != address(0), "ECDSA: invalid signature");
143 
144         return signer;
145     }
146 
147     /**
148      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
149      * replicates the behavior of the
150      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
151      * JSON-RPC method.
152      *
153      * See {recover}.
154      */
155     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
156         // 32 is the length in bytes of hash,
157         // enforced by the type signature above
158         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
159     }
160 }
161 
162 /**
163  * @dev Taraxa Claim Contract
164  *
165  * The Claim Contract is used to distribute tokens from public sales and bounties.
166  *
167  * The signature contains the address of the participant, the number of tokens and
168  * a nonce.
169  *
170  * The contract uses ecrecover to verify that the signature was created by our
171  * trusted account.
172  *
173  * If the signature is valid, the contract will transfer the tokens from a Taraxa
174  * owned wallet to the participant.
175  */
176 contract Claim {
177     IERC20 token;
178 
179     address trustedAccountAddress;
180     address walletAddress;
181 
182     mapping(bytes32 => uint256) claimed;
183 
184     /**
185      * @dev Sets the values for {token}, {trustedAccountAddress} and
186      * {walletAddress}.
187      *
188      * All three of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor(
192         address _tokenAddress,
193         address _trustedAccountAddress,
194         address _walletAddress
195     ) {
196         token = IERC20(_tokenAddress);
197 
198         trustedAccountAddress = _trustedAccountAddress;
199         walletAddress = _walletAddress;
200     }
201 
202     /**
203      * @dev Returns the number of tokens that have been claimed by the
204      * participant.
205      *
206      * Used by the Claim UI app.
207      */
208     function getClaimedAmount(
209         address _address,
210         uint256 _value,
211         uint256 _nonce
212     ) public view returns (uint256) {
213         bytes32 hash = _hash(_address, _value, _nonce);
214         return claimed[hash];
215     }
216 
217     /**
218      * @dev Transfers the tokens from a Taraxa owned wallet to the participant.
219      *
220      * Emits a {Claimed} event.
221      */
222     function claim(
223         address _address,
224         uint256 _value,
225         uint256 _nonce,
226         bytes memory _sig
227     ) public {
228         bytes32 hash = _hash(_address, _value, _nonce);
229 
230         require(ECDSA.recover(hash, _sig) == trustedAccountAddress, 'Claim: Invalid signature');
231         require(claimed[hash] == 0, 'Claim: Already claimed');
232 
233         claimed[hash] = _value;
234         token.transferFrom(walletAddress, _address, _value);
235 
236         emit Claimed(_address, _nonce, _value);
237     }
238 
239     function _hash(
240         address _address,
241         uint256 _value,
242         uint256 _nonce
243     ) internal pure returns (bytes32) {
244         return keccak256(abi.encodePacked(_address, _value, _nonce));
245     }
246 
247     /**
248      * @dev Emitted after the tokens have been transfered to the participant.
249      */
250     event Claimed(address indexed _address, uint256 indexed _nonce, uint256 _value);
251 }