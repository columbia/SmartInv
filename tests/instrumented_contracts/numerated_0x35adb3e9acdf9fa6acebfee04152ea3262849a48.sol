1 // File: contracts/interfaces/IMerkleDistributor.sol
2 
3 
4 
5 pragma solidity >=0.5.0;
6 
7 
8 
9 // Allows anyone to claim a token if they exist in a merkle root.
10 
11 interface IMerkleDistributor {
12 
13     // Returns the address of the token distributed by this contract.
14 
15     function token() external view returns (address);
16 
17     // Returns the merkle root of the merkle tree containing account balances available to claim.
18 
19     function merkleRoot() external view returns (bytes32);
20 
21     // Returns true if the index has been marked claimed.
22 
23     function isClaimed(uint256 index) external view returns (bool);
24 
25     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
26 
27     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
28 
29 
30 
31     // This event is triggered whenever a call to #claim succeeds.
32 
33     event Claimed(uint256 index, address account, uint256 amount);
34 
35 }
36 // File: contracts/interfaces/IMerkleExchanger.sol
37 
38 
39 
40 pragma solidity >=0.5.0;
41 
42 
43 
44 
45 // Allows anyone to claim a token if they exist in a merkle root.
46 
47 interface IMerkleExchanger is IMerkleDistributor {
48 
49     // Returns the address of the token distributed by this contract.
50 
51     function oldToken() external view returns (address);
52 
53 }
54 // File: contracts/interfaces/MerkleProof.sol
55 
56 
57 
58 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
59 
60 
61 
62 pragma solidity ^0.8.0;
63 
64 
65 
66 /**
67 
68  * @dev These functions deal with verification of Merkle Trees proofs.
69 
70  *
71 
72  * The proofs can be generated using the JavaScript library
73 
74  * https://github.com/miguelmota/merkletreejs[merkletreejs].
75 
76  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
77 
78  *
79 
80  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
81 
82  */
83 
84 library MerkleProof {
85 
86     /**
87 
88      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
89 
90      * defined by `root`. For this, a `proof` must be provided, containing
91 
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93 
94      * pair of leaves and each pair of pre-images are assumed to be sorted.
95 
96      */
97 
98     function verify(
99 
100         bytes32[] memory proof,
101 
102         bytes32 root,
103 
104         bytes32 leaf
105 
106     ) internal pure returns (bool) {
107 
108         return processProof(proof, leaf) == root;
109 
110     }
111 
112 
113 
114     /**
115 
116      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
117 
118      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
119 
120      * hash matches the root of the tree. When processing the proof, the pairs
121 
122      * of leafs & pre-images are assumed to be sorted.
123 
124      *
125 
126      * _Available since v4.4._
127 
128      */
129 
130     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
131 
132         bytes32 computedHash = leaf;
133 
134         for (uint256 i = 0; i < proof.length; i++) {
135 
136             bytes32 proofElement = proof[i];
137 
138             if (computedHash <= proofElement) {
139 
140                 // Hash(current computed hash + current element of the proof)
141 
142                 computedHash = _efficientHash(computedHash, proofElement);
143 
144             } else {
145 
146                 // Hash(current element of the proof + current computed hash)
147 
148                 computedHash = _efficientHash(proofElement, computedHash);
149 
150             }
151 
152         }
153 
154         return computedHash;
155 
156     }
157 
158 
159 
160     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
161 
162         assembly {
163 
164             mstore(0x00, a)
165 
166             mstore(0x20, b)
167 
168             value := keccak256(0x00, 0x40)
169 
170         }
171 
172     }
173 
174 }
175 
176 
177 // File: contracts/interfaces/IERC20.sol
178 
179 
180 
181 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
182 
183 
184 
185 pragma solidity ^0.8.0;
186 
187 
188 
189 /**
190 
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192 
193  */
194 
195 interface IERC20 {
196 
197     /**
198 
199      * @dev Returns the amount of tokens in existence.
200 
201      */
202 
203     function totalSupply() external view returns (uint256);
204 
205 
206 
207     /**
208 
209      * @dev Returns the amount of tokens owned by `account`.
210 
211      */
212 
213     function balanceOf(address account) external view returns (uint256);
214 
215 
216 
217     /**
218 
219      * @dev Moves `amount` tokens from the caller's account to `to`.
220 
221      *
222 
223      * Returns a boolean value indicating whether the operation succeeded.
224 
225      *
226 
227      * Emits a {Transfer} event.
228 
229      */
230 
231     function transfer(address to, uint256 amount) external returns (bool);
232 
233 
234 
235     /**
236 
237      * @dev Returns the remaining number of tokens that `spender` will be
238 
239      * allowed to spend on behalf of `owner` through {transferFrom}. This is
240 
241      * zero by default.
242 
243      *
244 
245      * This value changes when {approve} or {transferFrom} are called.
246 
247      */
248 
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251 
252 
253     /**
254 
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256 
257      *
258 
259      * Returns a boolean value indicating whether the operation succeeded.
260 
261      *
262 
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264 
265      * that someone may use both the old and the new allowance by unfortunate
266 
267      * transaction ordering. One possible solution to mitigate this race
268 
269      * condition is to first reduce the spender's allowance to 0 and set the
270 
271      * desired value afterwards:
272 
273      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
274 
275      *
276 
277      * Emits an {Approval} event.
278 
279      */
280 
281     function approve(address spender, uint256 amount) external returns (bool);
282 
283 
284 
285     /**
286 
287      * @dev Moves `amount` tokens from `from` to `to` using the
288 
289      * allowance mechanism. `amount` is then deducted from the caller's
290 
291      * allowance.
292 
293      *
294 
295      * Returns a boolean value indicating whether the operation succeeded.
296 
297      *
298 
299      * Emits a {Transfer} event.
300 
301      */
302 
303     function transferFrom(
304 
305         address from,
306 
307         address to,
308 
309         uint256 amount
310 
311     ) external returns (bool);
312 
313 
314 
315     /**
316 
317      * @dev Emitted when `value` tokens are moved from one account (`from`) to
318 
319      * another (`to`).
320 
321      *
322 
323      * Note that `value` may be zero.
324 
325      */
326 
327     event Transfer(address indexed from, address indexed to, uint256 value);
328 
329 
330 
331     /**
332 
333      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
334 
335      * a call to {approve}. `value` is the new allowance.
336 
337      */
338 
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 
341 }
342 
343 
344 // File: contracts/MerkleExchanger.sol
345 
346 
347 
348 pragma solidity ^0.8.13;
349 
350 
351 
352 
353 
354 
355 contract MerkleExchanger is IMerkleExchanger {
356 
357     address public immutable override token;
358 
359     bytes32 public immutable override merkleRoot;
360 
361     address public immutable override oldToken;
362 
363 
364 
365     address private immutable holdingAccount;
366 
367 
368 
369     // This is a packed array of booleans.
370 
371     mapping(uint256 => uint256) private claimedBitMap;
372 
373 
374 
375     constructor(address token_, bytes32 merkleRoot_, address oldToken_, address holdingAccount_) {
376 
377         token = token_;
378 
379         merkleRoot = merkleRoot_;
380 
381         oldToken = oldToken_;
382 
383         holdingAccount = holdingAccount_;
384 
385     }
386 
387 
388 
389     function isClaimed(uint256 index) public view override returns (bool) {
390 
391         uint256 claimedWordIndex = index / 256;
392 
393         uint256 claimedBitIndex = index % 256;
394 
395         uint256 claimedWord = claimedBitMap[claimedWordIndex];
396 
397         uint256 mask = (1 << claimedBitIndex);
398 
399         return claimedWord & mask == mask;
400 
401     }
402 
403 
404 
405     function _setClaimed(uint256 index) private {
406 
407         uint256 claimedWordIndex = index / 256;
408 
409         uint256 claimedBitIndex = index % 256;
410 
411         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
412 
413     }
414 
415 
416 
417     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
418 
419         require(!isClaimed(index), "MerkleExchanger: Drop already claimed.");
420 
421 
422 
423         // Verify the merkle proof.
424 
425         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
426 
427         require(MerkleProof.verify(merkleProof, merkleRoot, node), "MerkleExchanger: Invalid proof.");
428 
429 
430 
431         // Verify the account holds the required number of old tokens and has approved their use.
432 
433         uint256 allowance = IERC20(oldToken).allowance(account, address(this));
434 
435         
436 
437         require(allowance >= amount, "MerkleExchanger: Token allowance too small.");
438 
439 
440 
441         require(IERC20(oldToken).balanceOf(account) >= amount, "MerkleExchanger: Account does not hold enough tokens.");
442 
443 
444 
445         // Mark it claimed and exchange the tokens.
446 
447         _setClaimed(index);
448 
449 
450 
451         uint256 oldTokenBalance = IERC20(oldToken).balanceOf(account);
452 
453 
454 
455         if (oldTokenBalance > amount) {
456 
457             require(IERC20(oldToken).transferFrom(account, holdingAccount, amount), "MerkleExchanger: Transfer of old tokens failed.");
458 
459             require(IERC20(token).transfer(account, amount), "MerkleExchanger: Transfer of new tokens failed.");
460 
461             emit Claimed(index, account, amount);
462 
463         } else {
464 
465             require(IERC20(oldToken).transferFrom(account, holdingAccount, oldTokenBalance), "MerkleExchanger: Transfer of old tokens failed.");
466 
467             require(IERC20(token).transfer(account, oldTokenBalance), "MerkleExchanger: Transfer of new tokens failed.");
468 
469             emit Claimed(index, account, oldTokenBalance);
470 
471         }
472 
473     }
474 
475 
476 
477     function withdrawOld() public {
478 
479       require(IERC20(oldToken).transfer(holdingAccount, IERC20(oldToken).balanceOf(address(this))), "MerkleExchanger::withdrawOld: Withdraw failed.");
480 
481     }
482 
483 }