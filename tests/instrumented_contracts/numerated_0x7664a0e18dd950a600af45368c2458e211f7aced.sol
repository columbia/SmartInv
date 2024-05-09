1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
96 
97 pragma solidity ^0.5.0;
98 
99 /**
100  * @title Elliptic curve signature operations
101  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
102  * TODO Remove this library once solidity supports passing a signature to ecrecover.
103  * See https://github.com/ethereum/solidity/issues/864
104  */
105 
106 library ECDSA {
107     /**
108      * @dev Recover signer address from a message by using their signature
109      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
110      * @param signature bytes signature, the signature is generated using web3.eth.sign()
111      */
112     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
113         bytes32 r;
114         bytes32 s;
115         uint8 v;
116 
117         // Check the signature length
118         if (signature.length != 65) {
119             return (address(0));
120         }
121 
122         // Divide the signature in r, s and v variables
123         // ecrecover takes the signature parameters, and the only way to get them
124         // currently is to use assembly.
125         // solhint-disable-next-line no-inline-assembly
126         assembly {
127             r := mload(add(signature, 0x20))
128             s := mload(add(signature, 0x40))
129             v := byte(0, mload(add(signature, 0x60)))
130         }
131 
132         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
133         if (v < 27) {
134             v += 27;
135         }
136 
137         // If the version is correct return the signer address
138         if (v != 27 && v != 28) {
139             return (address(0));
140         } else {
141             return ecrecover(hash, v, r, s);
142         }
143     }
144 
145     /**
146      * toEthSignedMessageHash
147      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
148      * and hash the result
149      */
150     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
151         // 32 is the length in bytes of hash,
152         // enforced by the type signature above
153         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
154     }
155 }
156 
157 // File: contracts/IndexedMerkleProof.sol
158 
159 pragma solidity ^0.5.5;
160 
161 
162 library IndexedMerkleProof {
163     function compute(bytes memory proof, uint160 leaf) internal pure returns (uint160 root, uint256 index) {
164         uint160 computedHash = leaf;
165 
166         for (uint256 i = 0; i < proof.length; i++) {
167             uint160 proofElement;
168             // solium-disable-next-line security/no-inline-assembly
169             assembly {
170                 proofElement := div(mload(add(proof, 32)), 0x1000000000000000000000000)
171             }
172 
173             if (computedHash < proofElement) {
174                 // Hash(current computed hash + current element of the proof)
175                 computedHash = uint160(uint256(keccak256(abi.encodePacked(computedHash, proofElement))));
176                 index |= (1 << i);
177             } else {
178                 // Hash(current element of the proof + current computed hash)
179                 computedHash = uint160(uint256(keccak256(abi.encodePacked(proofElement, computedHash))));
180             }
181         }
182 
183         return (computedHash, index);
184     }
185 }
186 
187 // File: contracts/QRToken.sol
188 
189 pragma solidity ^0.5.5;
190 
191 
192 
193 
194 
195 
196 contract QRToken {
197     using SafeMath for uint;
198     using ECDSA for bytes;
199     using IndexedMerkleProof for bytes;
200 
201     uint256 constant public MAX_CODES_COUNT = 1024;
202     uint256 constant public MAX_WORDS_COUNT = (MAX_CODES_COUNT + 31) / 32;
203 
204     struct Distribution {
205         IERC20 token;
206         uint256 sumAmount;
207         uint256 codesCount;
208         uint256 deadline;
209         address sponsor;
210         uint256[32] bitMask; // MAX_WORDS_COUNT
211     }
212 
213     mapping(uint160 => Distribution) public distributions;
214 
215     event Created();
216     event Redeemed(uint160 root, uint256 index, address receiver);
217 
218     function create(
219         IERC20 token,
220         uint256 sumTokenAmount,
221         uint256 codesCount,
222         uint160 root,
223         uint256 deadline
224     ) public {
225         require(0 < sumTokenAmount);
226         require(0 < codesCount && codesCount <= MAX_CODES_COUNT);
227         require(deadline > now);
228 
229         require(token.transferFrom(msg.sender, address(this), sumTokenAmount));
230         Distribution storage distribution = distributions[root];
231         distribution.token = token;
232         distribution.sumAmount = sumTokenAmount;
233         distribution.codesCount = codesCount;
234         distribution.deadline = deadline;
235         distribution.sponsor = msg.sender;
236     }
237 
238     function redeem(
239         address receiver,
240         bytes calldata signature,
241         bytes calldata merkleProof
242     )
243         external
244     {
245         bytes32 messageHash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(receiver)));
246         address signer = ECDSA.recover(messageHash, signature);
247         (uint160 root, uint256 index) = merkleProof.compute(uint160(signer));
248         Distribution storage distribution = distributions[root];
249         require(distribution.bitMask[index / 32] & (1 << (index % 32)) == 0);
250 
251         distribution.bitMask[index / 32] = distribution.bitMask[index / 32] | (1 << (index % 32));
252         require(distribution.token.transfer(receiver, distribution.sumAmount.div(distribution.codesCount)));
253         emit Redeemed(root, index, receiver);
254     }
255 
256     function abort(uint160 root) public {
257         Distribution storage distribution = distributions[root];
258         require(now > distribution.deadline);
259 
260         uint256 count = 0;
261         for (uint i = 0; i < 1024; i++) {
262             if (distribution.bitMask[i / 32] & (1 << (i % 32)) != 0) {
263                 count += distribution.sumAmount / distribution.codesCount;
264             }
265         }
266         require(distribution.token.transfer(distribution.sponsor, distribution.sumAmount.sub(count)));
267         delete distributions[root];
268     }
269 }