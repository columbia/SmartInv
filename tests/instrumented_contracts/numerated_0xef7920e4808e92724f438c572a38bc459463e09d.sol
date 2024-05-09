1 // https://nhentai.net/g/177978/
2 //⠄⠄⠄⢰⣧⣼⣯⠄⣸⣠⣶⣶⣦⣾⠄⠄⠄⠄⡀⠄⢀⣿⣿⠄⠄⠄⢸⡇⠄⠄
3 //⠄⠄⠄⣾⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄
4 //⠄⠄⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄
5 //⠄⠄⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄
6 //⠄⢀⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰
7 //⠄⣼⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤
8 //⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗
9 //⢀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄
10 //⢸⣿⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄
11 //⠘⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃⠄
12 //⠄⠘⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃⠄⠄
13 //⠄⠄⠈⠻⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁⠄⠄⠄
14 //⠄⠄⠄⠄⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛⠁⠄⠄⠄⠄⠄
15 //⠄⠄⠄⠄⠄⠄⠄⠉⠻⣿⣿⣾⣦⡙⠻⣷⣾⣿⠃⠿⠋⠁⠄⠄⠄⠄⠄⢀⣠⣴
16 //⣿⣿⣿⣶⣶⣮⣥⣒⠲⢮⣝⡿⣿⣿⡆⣿⡿⠃⠄⠄⠄⠄⠄⠄⠄⣠⣴⣿⣿⣿
17 
18 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity ^0.6.0;
23 
24 /**
25  * @dev These functions deal with verification of Merkle trees (hash trees),
26  */
27 library MerkleProof {
28     /**
29      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
30      * defined by `root`. For this, a `proof` must be provided, containing
31      * sibling hashes on the branch from the leaf to the root of the tree. Each
32      * pair of leaves and each pair of pre-images are assumed to be sorted.
33      */
34     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
35         bytes32 computedHash = leaf;
36 
37         for (uint256 i = 0; i < proof.length; i++) {
38             bytes32 proofElement = proof[i];
39 
40             if (computedHash <= proofElement) {
41                 // Hash(current computed hash + current element of the proof)
42                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
43             } else {
44                 // Hash(current element of the proof + current computed hash)
45                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
46             }
47         }
48 
49         // Check if the computed hash (root) is equal to the provided root
50         return computedHash == root;
51     }
52 }
53 
54 // File: contracts/redeem/IERC20.sol
55 
56 pragma solidity 0.6.0;
57 
58 interface IERC20 {
59   event Approval(address indexed src, address indexed dst, uint amt);
60   event Transfer(address indexed src, address indexed dst, uint amt);
61 
62   function totalSupply() external view returns (uint);
63   function balanceOf(address whom) external view returns (uint);
64   function allowance(address src, address dst) external view returns (uint);
65 
66   function approve(address dst, uint amt) external returns (bool);
67   function transfer(address dst, uint amt) external returns (bool);
68   function transferFrom(
69     address src, address dst, uint amt
70   ) external returns (bool);
71 }
72 
73 // File: contracts/redeem/ISwapXToken.sol
74 
75 pragma solidity >=0.5.0;
76 
77 interface ISwapXToken {
78     function initialize(string calldata name, string calldata sym, uint maxSupply) external;
79 
80     function transferOwnership(address newOwner) external;
81 
82     function verify(bool verified) external;
83 
84     function verified() external returns (bool);
85 
86     function addIssuer(address _addr) external returns (bool);
87 
88     function removeIssuer(address _addr) external returns (bool);
89 
90     function issue(address account, uint256 amount) external returns (bool);
91 }
92 
93 // File: contracts/redeem/MerkleRedeem.sol
94 
95 pragma solidity 0.6.0;
96 pragma experimental ABIEncoderV2;
97 
98 
99 
100 
101 contract MerkleRedeem {
102     address public tokenAddress;
103     address public owner;
104 
105     event Claimed(address _claimant, address _token, uint256 _balance);
106     event VerifiedToken(address _token);
107 
108     // Recorded epochs
109     uint256 latestEpoch;
110     mapping(uint256 => bytes32) public epochMerkleRoots;
111     mapping(uint256 => uint256) public epochTimestamps;
112     mapping(uint256 => bytes32) public epochBlockHashes;
113     mapping(uint256 => mapping(address => mapping(address => bool)))
114         public claimed;
115 
116     address[] public _verifiedTokens;
117 
118     constructor() public {
119         owner = msg.sender;
120     }
121 
122     modifier onlyOwner() {
123         require(msg.sender == owner, "Must be the contract owner");
124         _;
125     }
126 
127     modifier requireEpochInPast(uint256 epoch) {
128         require(epoch <= latestEpoch, "Epoch cannot be in the future");
129         _;
130     }
131 
132     modifier requireEpochRecorded(uint256 _epoch) {
133         require(epochTimestamps[_epoch] != 0);
134         require(epochBlockHashes[_epoch] != 0);
135         _;
136     }
137 
138     modifier requireMerkleRootUnset(uint256 _epoch) {
139         require(epochMerkleRoots[_epoch] == bytes32(0));
140         _;
141     }
142 
143     modifier requireUnverified(address _token) {
144         require(verified(_token) == false);
145         _;
146     }
147 
148     function verify(address _token)
149         external
150         onlyOwner
151         requireUnverified(_token)
152     {
153         ISwapXToken(_token).verify(true);
154         _verifiedTokens.push(_token);
155         emit VerifiedToken(_token);
156     }
157 
158     function verified(address _token) public view returns (bool) {
159         for (uint256 i = 0; i < _verifiedTokens.length; i++) {
160             if (_token == _verifiedTokens[i]) {
161                 return true;
162             }
163         }
164         return false;
165     }
166 
167     function verifiedTokens() public view returns (address[] memory) {
168         address[] memory result = new address[](1);
169         if (0 == _verifiedTokens.length) {
170             delete result;
171             return result;
172         }
173         uint256 len = _verifiedTokens.length;
174         address[] memory results = new address[](len);
175         for (uint256 i = 0; i < _verifiedTokens.length; i++) {
176             results[i] = _verifiedTokens[i];
177         }
178 
179         return results;
180     }
181 
182     function issue(address _token, uint256 amount) external onlyOwner {
183         if (amount > 0) {
184             ISwapXToken(_token).issue(address(this), amount);
185         } else {
186             revert("No amount would be minted - not gonna waste your gas");
187         }
188     }
189 
190     function disburse(
191         address _liquidityProvider,
192         address _token,
193         uint256 _balance
194     ) private {
195         if (_balance > 0) {
196             IERC20(_token).transfer(_liquidityProvider, _balance);
197             emit Claimed(_liquidityProvider, _token, _balance);
198         } else {
199             revert("No balance would be transfered - not gonna waste your gas");
200         }
201     }
202 
203     function offsetRequirementMet(address user, uint256 _epoch)
204         public
205         view
206         returns (bool)
207     {
208         bytes32 blockHash = epochBlockHashes[_epoch];
209         uint256 timestamp = epochTimestamps[_epoch];
210         uint256 offsetSeconds = userEpochOffset(user, blockHash);
211 
212         uint256 earliestClaimableTimestamp = timestamp + offsetSeconds;
213         return earliestClaimableTimestamp < block.timestamp;
214     }
215 
216     function claimEpoch(
217         address _liquidityProvider,
218         uint256 _epoch,
219         address _token,
220         uint256 _claimedBalance,
221         bytes32[] memory _merkleProof
222     ) public requireEpochInPast(_epoch) requireEpochRecorded(_epoch) {
223         // if trying to claim for the current epoch
224         if (_epoch == latestEpoch) {
225             require(
226                 offsetRequirementMet(_liquidityProvider, latestEpoch),
227                 "It is too early to claim for the current epoch"
228             );
229         }
230 
231         require(!claimed[_epoch][_liquidityProvider][_token]);
232         require(
233             verifyClaim(
234                 _liquidityProvider,
235                 _epoch,
236                 _token,
237                 _claimedBalance,
238                 _merkleProof
239             ),
240             "Incorrect merkle proof"
241         );
242 
243         claimed[_epoch][_liquidityProvider][_token] = true;
244         disburse(_liquidityProvider, _token, _claimedBalance);
245     }
246 
247     struct Claim {
248         uint256 epoch;
249         address token;
250         uint256 balance;
251         bytes32[] merkleProof;
252     }
253 
254     mapping(address => uint256) tokenTotalBalances; //temp mapping
255 
256     function claimEpochs(address _liquidityProvider, Claim[] memory claims)
257         public
258     {
259         Claim memory claim;
260         address[] memory _tokens;
261         for (uint256 i = 0; i < claims.length; i++) {
262             claim = claims[i];
263             require(
264                 claim.epoch <= latestEpoch,
265                 "Epoch cannot be in the future"
266             );
267             require(epochTimestamps[claim.epoch] != 0);
268             require(epochBlockHashes[claim.epoch] != 0);
269 
270             // if trying to claim for the current epoch
271             if (claim.epoch == latestEpoch) {
272                 require(
273                     offsetRequirementMet(_liquidityProvider, latestEpoch),
274                     "It is too early to claim for the current epoch"
275                 );
276             }
277 
278             require(!claimed[claim.epoch][_liquidityProvider][claim.token]);
279             require(
280                 verifyClaim(
281                     _liquidityProvider,
282                     claim.epoch,
283                     claim.token,
284                     claim.balance,
285                     claim.merkleProof
286                 ),
287                 "Incorrect merkle proof"
288             );
289 
290             if (tokenTotalBalances[claim.token] == uint256(0)) {
291                 _tokens[_tokens.length] = claim.token;
292             }
293 
294             tokenTotalBalances[claim.token] += claim.balance;
295 
296             claimed[claim.epoch][_liquidityProvider][claim.token] = true;
297         }
298 
299         for (uint256 i = 0; i < _tokens.length; i++) {
300             disburse(
301                 _liquidityProvider,
302                 _tokens[i],
303                 tokenTotalBalances[_tokens[i]]
304             );
305 
306             delete tokenTotalBalances[_tokens[i]];
307         }
308         delete _tokens;
309     }
310 
311     function claimStatus(
312         address _liquidityProvider,
313         address _token,
314         uint256 _begin,
315         uint256 _end
316     ) public view returns (bool[] memory) {
317         uint256 size = 1 + _end - _begin;
318         bool[] memory arr = new bool[](size);
319         for (uint256 i = 0; i < size; i++) {
320             arr[i] = claimed[_begin + i][_liquidityProvider][_token];
321         }
322         return arr;
323     }
324 
325     function merkleRoots(uint256 _begin, uint256 _end)
326         public
327         view
328         returns (bytes32[] memory)
329     {
330         uint256 size = 1 + _end - _begin;
331         bytes32[] memory arr = new bytes32[](size);
332         for (uint256 i = 0; i < size; i++) {
333             arr[i] = epochMerkleRoots[_begin + i];
334         }
335         return arr;
336     }
337 
338     function verifyClaim(
339         address _liquidityProvider,
340         uint256 _epoch,
341         address _token,
342         uint256 _claimedBalance,
343         bytes32[] memory _merkleProof
344     ) public view returns (bool valid) {
345         bytes32 leaf = keccak256(
346             abi.encodePacked(_liquidityProvider, _token, _claimedBalance)
347         );
348         return MerkleProof.verify(_merkleProof, epochMerkleRoots[_epoch], leaf);
349     }
350 
351     function userEpochOffset(
352         address _liquidityProvider,
353         bytes32 _epochBlockHash
354     ) public pure returns (uint256 offset) {
355         bytes32 hash = keccak256(
356             abi.encodePacked(_liquidityProvider, _epochBlockHash)
357         );
358         assembly {
359             offset := mod(
360                 hash,
361                 86400 // seconds in a epoch
362             )
363         }
364         return offset;
365     }
366 
367     function finishEpoch(
368         uint256 _epoch,
369         uint256 _timestamp,
370         bytes32 _blockHash
371     ) public onlyOwner {
372         epochTimestamps[_epoch] = _timestamp;
373         epochBlockHashes[_epoch] = _blockHash;
374         if (_epoch > latestEpoch) {
375             // just in case we get these out of order
376             latestEpoch = _epoch;
377         }
378     }
379 
380     function seedAllocations(uint256 _epoch, bytes32 _merkleRoot)
381         external
382         requireEpochRecorded(_epoch)
383         requireMerkleRootUnset(_epoch)
384         onlyOwner
385     {
386         require(
387             epochMerkleRoots[_epoch] == bytes32(0),
388             "cannot rewrite merkle root"
389         );
390         epochMerkleRoots[_epoch] = _merkleRoot;
391     }
392 }