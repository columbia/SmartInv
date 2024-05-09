1 // Sources flattened with buidler v1.4.3 https://buidler.dev
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 // File @openzeppelin/contracts/cryptography/ECDSA.sol@v3.1.0
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
106  *
107  * These functions can be used to verify that a message was signed by the holder
108  * of the private keys of a given address.
109  */
110 library ECDSA {
111     /**
112      * @dev Returns the address that signed a hashed message (`hash`) with
113      * `signature`. This address can then be used for verification purposes.
114      *
115      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
116      * this function rejects them by requiring the `s` value to be in the lower
117      * half order, and the `v` value to be either 27 or 28.
118      *
119      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
120      * verification to be secure: it is possible to craft signatures that
121      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
122      * this is by receiving a hash of the original message (which may otherwise
123      * be too long), and then calling {toEthSignedMessageHash} on it.
124      */
125     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
126         // Check the signature length
127         if (signature.length != 65) {
128             revert("ECDSA: invalid signature length");
129         }
130 
131         // Divide the signature in r, s and v variables
132         bytes32 r;
133         bytes32 s;
134         uint8 v;
135 
136         // ecrecover takes the signature parameters, and the only way to get them
137         // currently is to use assembly.
138         // solhint-disable-next-line no-inline-assembly
139         assembly {
140             r := mload(add(signature, 0x20))
141             s := mload(add(signature, 0x40))
142             v := byte(0, mload(add(signature, 0x60)))
143         }
144 
145         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
146         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
147         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
148         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
149         //
150         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
151         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
152         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
153         // these malleable signatures as well.
154         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
155             revert("ECDSA: invalid signature 's' value");
156         }
157 
158         if (v != 27 && v != 28) {
159             revert("ECDSA: invalid signature 'v' value");
160         }
161 
162         // If the signature is valid (and not malleable), return the signer address
163         address signer = ecrecover(hash, v, r, s);
164         require(signer != address(0), "ECDSA: invalid signature");
165 
166         return signer;
167     }
168 
169     /**
170      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
171      * replicates the behavior of the
172      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
173      * JSON-RPC method.
174      *
175      * See {recover}.
176      */
177     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
178         // 32 is the length in bytes of hash,
179         // enforced by the type signature above
180         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
181     }
182 }
183 
184 
185 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0
186 
187 /*
188 https://github.com/OpenZeppelin/openzeppelin-contracts
189 
190 The MIT License (MIT)
191 
192 Copyright (c) 2016-2019 zOS Global Limited
193 
194 Permission is hereby granted, free of charge, to any person obtaining
195 a copy of this software and associated documentation files (the
196 "Software"), to deal in the Software without restriction, including
197 without limitation the rights to use, copy, modify, merge, publish,
198 distribute, sublicense, and/or sell copies of the Software, and to
199 permit persons to whom the Software is furnished to do so, subject to
200 the following conditions:
201 
202 The above copyright notice and this permission notice shall be included
203 in all copies or substantial portions of the Software.
204 
205 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
206 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
207 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
208 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
209 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
210 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
211 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
212 */
213 
214 pragma solidity 0.6.8;
215 
216 /**
217  * @dev Interface of the ERC20 standard as defined in the EIP.
218  */
219 interface IERC20 {
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(
228         address indexed _from,
229         address indexed _to,
230         uint256 _value
231     );
232 
233     /**
234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
235      * a call to {approve}. `value` is the new allowance.
236      */
237     event Approval(
238         address indexed _owner,
239         address indexed _spender,
240         uint256 _value
241     );
242 
243     /**
244      * @dev Returns the amount of tokens in existence.
245      */
246     function totalSupply() external view returns (uint256);
247 
248     /**
249      * @dev Returns the amount of tokens owned by `account`.
250      */
251     function balanceOf(address account) external view returns (uint256);
252 
253     /**
254      * @dev Moves `amount` tokens from the caller's account to `recipient`.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transfer(address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Returns the remaining number of tokens that `spender` will be
264      * allowed to spend on behalf of `owner` through {transferFrom}. This is
265      * zero by default.
266      *
267      * This value changes when {approve} or {transferFrom} are called.
268      */
269     function allowance(address owner, address spender) external view returns (uint256);
270 
271     /**
272      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * IMPORTANT: Beware that changing an allowance with this method brings the risk
277      * that someone may use both the old and the new allowance by unfortunate
278      * transaction ordering. One possible solution to mitigate this race
279      * condition is to first reduce the spender's allowance to 0 and set the
280      * desired value afterwards:
281      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282      *
283      * Emits an {Approval} event.
284      */
285     function approve(address spender, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Moves `amount` tokens from `sender` to `recipient` using the
289      * allowance mechanism. `amount` is then deducted from the caller's
290      * allowance.
291      *
292      * Returns a boolean value indicating whether the operation succeeded.
293      *
294      * Emits a {Transfer} event.
295      */
296     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
297 }
298 
299 
300 // File @animoca/f1dt-ethereum-contracts/contracts/metadata/Crates2020RNGLib.sol@v1.0.0
301 
302 pragma solidity 0.6.8;
303 
304 library Crates2020RNGLib {
305 
306     struct Metadata {
307         uint256 tokenType;
308         uint256 tokenSubType;
309         uint256 model;
310         uint256 team;
311         uint256 tokenRarity;
312         uint256 label;
313         uint256 driver;
314         uint256 stat1;
315         uint256 stat2;
316         uint256 stat3;
317         uint256 counter;
318     }
319 
320     uint256 constant CRATE_TIER_LEGENDARY = 0;
321     uint256 constant CRATE_TIER_EPIC = 1;
322     uint256 constant CRATE_TIER_RARE = 2;
323     uint256 constant CRATE_TIER_COMMON = 3;
324 
325     //============================================================================================/
326     //================================== Metadata Mappings  ======================================/
327     //============================================================================================/
328 
329     uint256 internal constant _NF_FLAG = 1 << 255;
330 
331     uint256 internal constant _SEASON_ID_2020 = 3;
332 
333     uint256 internal constant _TYPE_ID_CAR = 1;
334     uint256 internal constant _TYPE_ID_DRIVER = 2;
335     uint256 internal constant _TYPE_ID_PART = 3;
336     uint256 internal constant _TYPE_ID_GEAR = 4;
337     uint256 internal constant _TYPE_ID_TYRES = 5;
338 
339     uint256 internal constant _TEAM_ID_ALFA_ROMEO_RACING = 1;
340     uint256 internal constant _TEAM_ID_SCUDERIA_FERRARI = 2;
341     uint256 internal constant _TEAM_ID_HAAS_F1_TEAM = 3;
342     uint256 internal constant _TEAM_ID_MCLAREN_F1_TEAM = 4;
343     uint256 internal constant _TEAM_ID_MERCEDES_AMG_PETRONAS_MOTORSPORT = 5;
344     uint256 internal constant _TEAM_ID_SPSCORE_RACING_POINT_F1_TEAM = 6;
345     uint256 internal constant _TEAM_ID_ASTON_MARTIN_RED_BULL_RACING = 7;
346     uint256 internal constant _TEAM_ID_RENAULT_F1_TEAM = 8;
347     uint256 internal constant _TEAM_ID_RED_BULL_TORO_ROSSO_HONDA = 9;
348     uint256 internal constant _TEAM_ID_ROKIT_WILLIAMS_RACING = 10;
349 
350     uint256 internal constant _DRIVER_ID_KIMI_RAIKKONEN = 7;
351     uint256 internal constant _DRIVER_ID_ANTONIO_GIOVINAZZI = 99;
352     uint256 internal constant _DRIVER_ID_SEBASTIAN_VETTEL = 5;
353     uint256 internal constant _DRIVER_ID_CHARLES_LECLERC = 16;
354     uint256 internal constant _DRIVER_ID_ROMAIN_GROSJEAN = 8;
355     uint256 internal constant _DRIVER_ID_KEVIN_MAGNUSSEN = 20;
356     uint256 internal constant _DRIVER_ID_LANDO_NORRIS = 4;
357     uint256 internal constant _DRIVER_ID_CARLOS_SAINZ = 55;
358     uint256 internal constant _DRIVER_ID_LEWIS_HAMILTON = 44;
359     uint256 internal constant _DRIVER_ID_VALTTERI_BOTTAS = 77;
360     uint256 internal constant _DRIVER_ID_SERGIO_PEREZ = 11;
361     uint256 internal constant _DRIVER_ID_LANCE_STROLL = 18;
362     uint256 internal constant _DRIVER_ID_PIERRE_GASLY = 10;
363     uint256 internal constant _DRIVER_ID_MAX_VERSTAPPEN = 33;
364     uint256 internal constant _DRIVER_ID_DANIEL_RICCIARDO = 3;
365     // uint256 internal constant _DRIVER_ID_NICO_HULKENBERG = 27;
366     uint256 internal constant _DRIVER_ID_ALEXANDER_ALBON = 23;
367     uint256 internal constant _DRIVER_ID_DANIIL_KVYAT = 26;
368     uint256 internal constant _DRIVER_ID_GEORGE_RUSSEL = 63;
369     // uint256 internal constant _DRIVER_ID_ROBERT_KUBICA = 88;
370     uint256 internal constant _DRIVER_ID_ESTEBAN_OCON = 31;
371     uint256 internal constant _DRIVER_ID_NICHOLAS_LATIFI = 6;
372 
373 
374     //============================================================================================/
375     //================================ Racing Stats Min/Max  =====================================/
376     //============================================================================================/
377 
378     uint256 internal constant _RACING_STATS_T1_RARITY_1_MIN = 800;
379     uint256 internal constant _RACING_STATS_T1_RARITY_1_MAX = 900;
380     uint256 internal constant _RACING_STATS_T1_RARITY_2_MIN = 710;
381     uint256 internal constant _RACING_STATS_T1_RARITY_2_MAX = 810;
382     uint256 internal constant _RACING_STATS_T1_RARITY_3_MIN = 680;
383     uint256 internal constant _RACING_STATS_T1_RARITY_3_MAX = 780;
384     uint256 internal constant _RACING_STATS_T1_RARITY_4_MIN = 610;
385     uint256 internal constant _RACING_STATS_T1_RARITY_4_MAX = 710;
386     uint256 internal constant _RACING_STATS_T1_RARITY_5_MIN = 570;
387     uint256 internal constant _RACING_STATS_T1_RARITY_5_MAX = 680;
388     uint256 internal constant _RACING_STATS_T1_RARITY_6_MIN = 540;
389     uint256 internal constant _RACING_STATS_T1_RARITY_6_MAX = 650;
390     uint256 internal constant _RACING_STATS_T1_RARITY_7_MIN = 500;
391     uint256 internal constant _RACING_STATS_T1_RARITY_7_MAX = 580;
392     uint256 internal constant _RACING_STATS_T1_RARITY_8_MIN = 480;
393     uint256 internal constant _RACING_STATS_T1_RARITY_8_MAX = 550;
394     uint256 internal constant _RACING_STATS_T1_RARITY_9_MIN = 450;
395     uint256 internal constant _RACING_STATS_T1_RARITY_9_MAX = 540;
396 
397     uint256 internal constant _RACING_STATS_T2_RARITY_1_MIN = 500;
398     uint256 internal constant _RACING_STATS_T2_RARITY_1_MAX = 600;
399     uint256 internal constant _RACING_STATS_T2_RARITY_2_MIN = 420;
400     uint256 internal constant _RACING_STATS_T2_RARITY_2_MAX = 520;
401     uint256 internal constant _RACING_STATS_T2_RARITY_3_MIN = 380;
402     uint256 internal constant _RACING_STATS_T2_RARITY_3_MAX = 480;
403     uint256 internal constant _RACING_STATS_T2_RARITY_4_MIN = 340;
404     uint256 internal constant _RACING_STATS_T2_RARITY_4_MAX = 440;
405     uint256 internal constant _RACING_STATS_T2_RARITY_5_MIN = 330;
406     uint256 internal constant _RACING_STATS_T2_RARITY_5_MAX = 430;
407     uint256 internal constant _RACING_STATS_T2_RARITY_6_MIN = 290;
408     uint256 internal constant _RACING_STATS_T2_RARITY_6_MAX = 390;
409     uint256 internal constant _RACING_STATS_T2_RARITY_7_MIN = 250;
410     uint256 internal constant _RACING_STATS_T2_RARITY_7_MAX = 350;
411     uint256 internal constant _RACING_STATS_T2_RARITY_8_MIN = 240;
412     uint256 internal constant _RACING_STATS_T2_RARITY_8_MAX = 340;
413     uint256 internal constant _RACING_STATS_T2_RARITY_9_MIN = 200;
414     uint256 internal constant _RACING_STATS_T2_RARITY_9_MAX = 300;
415 
416     uint256 internal constant _RACING_STATS_T3_RARITY_1_MIN = 500;
417     uint256 internal constant _RACING_STATS_T3_RARITY_1_MAX = 600;
418     uint256 internal constant _RACING_STATS_T3_RARITY_2_MIN = 420;
419     uint256 internal constant _RACING_STATS_T3_RARITY_2_MAX = 520;
420     uint256 internal constant _RACING_STATS_T3_RARITY_3_MIN = 380;
421     uint256 internal constant _RACING_STATS_T3_RARITY_3_MAX = 480;
422     uint256 internal constant _RACING_STATS_T3_RARITY_4_MIN = 340;
423     uint256 internal constant _RACING_STATS_T3_RARITY_4_MAX = 440;
424     uint256 internal constant _RACING_STATS_T3_RARITY_5_MIN = 330;
425     uint256 internal constant _RACING_STATS_T3_RARITY_5_MAX = 430;
426     uint256 internal constant _RACING_STATS_T3_RARITY_6_MIN = 290;
427     uint256 internal constant _RACING_STATS_T3_RARITY_6_MAX = 390;
428     uint256 internal constant _RACING_STATS_T3_RARITY_7_MIN = 250;
429     uint256 internal constant _RACING_STATS_T3_RARITY_7_MAX = 350;
430     uint256 internal constant _RACING_STATS_T3_RARITY_8_MIN = 240;
431     uint256 internal constant _RACING_STATS_T3_RARITY_8_MAX = 340;
432     uint256 internal constant _RACING_STATS_T3_RARITY_9_MIN = 200;
433     uint256 internal constant _RACING_STATS_T3_RARITY_9_MAX = 300;
434 
435     //============================================================================================/
436     //================================== Types Drop Rates  =======================================/
437     //============================================================================================/
438 
439     uint256 internal constant _TYPE_DROP_RATE_THRESH_COMPONENT = 82500;
440 
441     //============================================================================================/
442     //================================== Rarity Drop Rates  ======================================/
443     //============================================================================================/
444 
445     uint256 internal constant _COMMON_CRATE_DROP_RATE_THRESH_COMMON = 98.899 * 1000;
446     uint256 internal constant _COMMON_CRATE_DROP_RATE_THRESH_RARE = 1 * 1000 + _COMMON_CRATE_DROP_RATE_THRESH_COMMON;
447     uint256 internal constant _COMMON_CRATE_DROP_RATE_THRESH_EPIC = 0.1 * 1000 + _COMMON_CRATE_DROP_RATE_THRESH_RARE;
448 
449     uint256 internal constant _RARE_CRATE_DROP_RATE_THRESH_COMMON = 96.490 * 1000;
450     uint256 internal constant _RARE_CRATE_DROP_RATE_THRESH_RARE = 2.5 * 1000 + _RARE_CRATE_DROP_RATE_THRESH_COMMON;
451     uint256 internal constant _RARE_CRATE_DROP_RATE_THRESH_EPIC = 1 * 1000 + _RARE_CRATE_DROP_RATE_THRESH_RARE;
452 
453     uint256 internal constant _EPIC_CRATE_DROP_RATE_THRESH_COMMON = 92.4 * 1000;
454     uint256 internal constant _EPIC_CRATE_DROP_RATE_THRESH_RARE = 5 * 1000 + _EPIC_CRATE_DROP_RATE_THRESH_COMMON;
455     uint256 internal constant _EPIC_CRATE_DROP_RATE_THRESH_EPIC = 2.5 * 1000 + _EPIC_CRATE_DROP_RATE_THRESH_RARE;
456 
457     uint256 internal constant _LEGENDARY_CRATE_DROP_RATE_THRESH_COMMON = 84 * 1000;
458     uint256 internal constant _LEGENDARY_CRATE_DROP_RATE_THRESH_RARE = 10 * 1000 + _LEGENDARY_CRATE_DROP_RATE_THRESH_COMMON;
459     uint256 internal constant _LEGENDARY_CRATE_DROP_RATE_THRESH_EPIC = 5 * 1000 + _LEGENDARY_CRATE_DROP_RATE_THRESH_RARE;
460 
461     // Uses crateSeed bits [0;10[
462     function generateCrate(uint256 crateSeed, uint256 crateTier, uint256 counter) internal pure returns (uint256[] memory tokens) {
463         tokens = new uint256[](5);
464         if (crateTier == CRATE_TIER_COMMON) {
465             uint256 guaranteedRareDropIndex = crateSeed % 5;
466 
467             for (uint256 i = 0; i != 5; ++i) {
468                 uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
469                 tokens[i] = _makeTokenId(
470                     _generateMetadata(
471                         tokenSeed,
472                         crateTier,
473                         counter,
474                         i,
475                         i == guaranteedRareDropIndex? CRATE_TIER_RARE: CRATE_TIER_COMMON
476                     )
477                 );
478             }
479         } else if (crateTier == CRATE_TIER_RARE) {
480             (
481                 uint256 guaranteedRareDropIndex1,
482                 uint256 guaranteedRareDropIndex2,
483                 uint256 guaranteedRareDropIndex3
484             ) = _generateThreeTokenIndices(crateSeed);
485 
486             for (uint256 i = 0; i != 5; ++i) {
487                 uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
488                 tokens[i] = _makeTokenId(
489                     _generateMetadata(
490                         tokenSeed,
491                         crateTier,
492                         counter,
493                         i,
494                         (
495                             i == guaranteedRareDropIndex1 ||
496                             i == guaranteedRareDropIndex2 ||
497                             i == guaranteedRareDropIndex3
498                         ) ? CRATE_TIER_RARE: CRATE_TIER_COMMON
499                     )
500                 );
501             }
502         } else if (crateTier == CRATE_TIER_EPIC) {
503             (
504                 uint256 guaranteedRareDropIndex,
505                 uint256 guaranteedEpicDropIndex
506             ) = _generateTwoTokenIndices(crateSeed);
507 
508             for (uint256 i = 0; i != 5; ++i) {
509                 uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
510                 uint256 minRarityTier = CRATE_TIER_COMMON;
511                 if (i == guaranteedRareDropIndex) {
512                     minRarityTier = CRATE_TIER_RARE;
513                 } else if (i == guaranteedEpicDropIndex) {
514                     minRarityTier = CRATE_TIER_EPIC;
515                 }
516                 tokens[i] = _makeTokenId(
517                     _generateMetadata(
518                         tokenSeed,
519                         crateTier,
520                         counter,
521                         i,
522                         minRarityTier
523                     )
524                 );
525             }
526         } else if (crateTier == CRATE_TIER_LEGENDARY) {
527             (
528                 uint256 guaranteedRareDropIndex,
529                 uint256 guaranteedLegendaryDropIndex
530             ) = _generateTwoTokenIndices(crateSeed);
531 
532             for (uint256 i = 0; i != 5; ++i) {
533                 uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
534                 uint256 minRarityTier = CRATE_TIER_COMMON;
535                 if (i == guaranteedRareDropIndex) {
536                     minRarityTier = CRATE_TIER_RARE;
537                 } else if (i == guaranteedLegendaryDropIndex) {
538                     minRarityTier = CRATE_TIER_LEGENDARY;
539                 }
540                 tokens[i] = _makeTokenId(
541                     _generateMetadata(
542                         tokenSeed,
543                         crateTier,
544                         counter,
545                         i,
546                         minRarityTier
547                     )
548                 );
549             }
550         } else {
551             revert("Crates2020RNG: wrong crate tier");
552         }
553     }
554 
555     /**
556      * Select one index, then another
557     */ 
558     function _generateTwoTokenIndices(uint256 crateSeed) internal pure returns (uint256, uint256) {
559         uint256 firstIndex = crateSeed % 5;
560         return(
561             firstIndex,
562             (firstIndex + 1 + ((crateSeed >> 4) % 4)) % 5
563         );
564     }
565 
566     /**
567      * To generate 3 random indices in a 5-size array, there are 10 possibilities:
568      * value  ->  positions  ->  indices
569      *   0        O O X X X     (2, 3, 4)
570      *   1        O X O X X     (1, 3, 4)
571      *   2        O X X O X     (1, 2, 4)
572      *   3        O X X X O     (1, 2, 3)
573      *   4        X O O X X     (0, 3, 4)
574      *   5        X O X O X     (0, 2, 4)
575      *   6        X O X X O     (0, 2, 3)
576      *   7        X X O O X     (0, 1, 4)
577      *   8        X X O X O     (0, 1, 3)
578      *   9        X X X O O     (0, 1, 2)
579      */
580     function _generateThreeTokenIndices(uint256 crateSeed) internal pure returns (uint256, uint256, uint256) {
581         uint256 value = crateSeed % 10;
582         if (value == 0) return (2, 3, 4);
583         if (value == 1) return (1, 3, 4);
584         if (value == 2) return (1, 2, 4);
585         if (value == 3) return (1, 2, 3);
586         if (value == 4) return (0, 3, 4);
587         if (value == 5) return (0, 2, 4);
588         if (value == 6) return (0, 2, 3);
589         if (value == 7) return (0, 1, 4);
590         if (value == 8) return (0, 1, 3);
591         if (value == 9) return (0, 1, 2);
592     }
593 
594     function _generateMetadata(
595         uint256 tokenSeed,
596         uint256 crateTier,
597         uint256 counter,
598         uint256 index,
599         uint256 minRarityTier
600     ) private pure returns (Metadata memory metadata) {
601         (uint256 tokenType, uint256 tokenSubType) = _generateType(tokenSeed >> 4, index); // Uses tokenSeed bits [4;41[
602         metadata.tokenType = tokenType;
603         if (tokenSubType != 0) {
604             metadata.tokenSubType = tokenSubType;
605         }
606 
607         uint256 tokenRarity = _generateRarity(tokenSeed >> 41, crateTier, minRarityTier); // Uses tokenSeed bits [41;73[
608         metadata.tokenRarity = tokenRarity;
609 
610         if (tokenType == _TYPE_ID_CAR || tokenType == _TYPE_ID_DRIVER) {
611             if (tokenRarity > 3) {
612                 metadata.model = _generateModel(tokenSeed >> 73); // Uses tokenSeed bits [73;81[
613             } else {
614                 uint256 team = _generateTeam(tokenSeed >> 73); // Uses tokenSeed bits [73;81[
615                 metadata.team = team;
616                 if (tokenType == _TYPE_ID_DRIVER) {
617                     metadata.driver = _generateDriver(tokenSeed >> 81, team); // Uses tokenSeed bits [81;82[;
618                 }
619             }
620         }
621 
622         (metadata.stat1, metadata.stat2, metadata.stat3) = _generateRacingStats(
623             tokenSeed >> 128,
624             tokenType,
625             tokenRarity
626         ); // Uses tokenSeed bits [128;170[
627         metadata.counter = counter + index;
628     }
629 
630     function _generateType(uint256 seed, uint256 index)
631         private
632         pure
633         returns (uint256 tokenType, uint256 tokenSubType)
634     {
635         if (index == 0) {
636             tokenType = 1 + (seed % 2); // Types {1, 2} = {Car, Driver}, using 1 bit
637             tokenSubType = 0;
638         } else {
639             uint256 seedling = seed % 100000; // using > 16 bits, reserve 32
640             if (seedling < _TYPE_DROP_RATE_THRESH_COMPONENT) {
641                 uint256 componentTypeSeed = (seed >> 32) % 3; // Type {3, 4} = {Gear, Part}, using 2 bits
642                 if (componentTypeSeed == 1) { // 1 chance out of 3
643                     tokenType = _TYPE_ID_GEAR;
644                     tokenSubType = 1 + ((seed >> 34) % 4); // Subtype [1-4], using 2 bits
645                 } else { // 2 chances out of 3
646                     tokenType = _TYPE_ID_PART;
647                     tokenSubType = 1 + ((seed >> 34) % 8); // Subtype [1-8], using 3 bits
648                 }
649             } else {
650                 tokenType = _TYPE_ID_TYRES;
651                 tokenSubType = 1 + ((seed >> 32) % 5); // Subtype [1-5], using 3 bits
652             }
653         }
654     }
655 
656     function _generateRarity(
657         uint256 seed,
658         uint256 crateTier,
659         uint256 minRarityTier
660     ) private pure returns (uint256 tokenRarity) {
661         uint256 seedling = seed % 100000; // > 16 bits, reserve 32
662 
663         if (crateTier == CRATE_TIER_COMMON) {
664             if (minRarityTier == CRATE_TIER_COMMON && seedling < _COMMON_CRATE_DROP_RATE_THRESH_COMMON) {
665                 return 7 + (seedling % 3); // Rarity [7-9]
666             }
667             if (seedling < _COMMON_CRATE_DROP_RATE_THRESH_RARE) {
668                 return 4 + (seedling % 3); // Rarity [4-6]
669             }
670             if (seedling < _COMMON_CRATE_DROP_RATE_THRESH_EPIC) {
671                 return 2 + (seedling % 2); // Rarity [2-3]
672             }
673             return 1;
674         }
675 
676         if (crateTier == CRATE_TIER_RARE) {
677             if (minRarityTier == CRATE_TIER_COMMON && seedling < _RARE_CRATE_DROP_RATE_THRESH_COMMON) {
678                 return 7 + (seedling % 3); // Rarity [7-9]
679             }
680             if (seedling < _RARE_CRATE_DROP_RATE_THRESH_RARE) {
681                 return 4 + (seedling % 3); // Rarity [4-6]
682             }
683             if (seedling < _RARE_CRATE_DROP_RATE_THRESH_EPIC) {
684                 return 2 + (seedling % 2); // Rarity [2-3]
685             }
686             return 1;
687         }
688 
689         if (crateTier == CRATE_TIER_EPIC) {
690             if (minRarityTier == CRATE_TIER_COMMON && seedling < _EPIC_CRATE_DROP_RATE_THRESH_COMMON) {
691                 return 7 + (seedling % 3); // Rarity [7-9]
692             }
693             if (
694                 (minRarityTier == CRATE_TIER_COMMON || minRarityTier == CRATE_TIER_RARE)
695                 && seedling < _EPIC_CRATE_DROP_RATE_THRESH_RARE
696             ) {
697                 return 4 + (seedling % 3); // Rarity [4-6]
698             }
699             if (seedling < _EPIC_CRATE_DROP_RATE_THRESH_EPIC) {
700                 return 2 + (seedling % 2); // Rarity [2-3]
701             }
702             return 1;
703         }
704 
705         if (crateTier == CRATE_TIER_LEGENDARY) {
706             if (minRarityTier == CRATE_TIER_COMMON && seedling < _LEGENDARY_CRATE_DROP_RATE_THRESH_COMMON) {
707                 return 7 + (seedling % 3); // Rarity [7-9]
708             }
709             if (minRarityTier == CRATE_TIER_COMMON || minRarityTier == CRATE_TIER_RARE) {
710                 if (seedling < _LEGENDARY_CRATE_DROP_RATE_THRESH_RARE) {
711                     return 4 + (seedling % 3); // Rarity [4-6]
712                 }
713                 if (seedling < _LEGENDARY_CRATE_DROP_RATE_THRESH_EPIC) {
714                     return 2 + (seedling % 2); // Rarity [2-3]
715                 }
716             }
717             return 1;
718         }
719     }
720 
721     function _generateModel(uint256 seed) private pure returns (uint256 model) {
722         model = 1 + (seed % 10);
723     }
724 
725     function _generateTeam(uint256 seed) private pure returns (uint256 team) {
726         team = 1 + (seed % 10);
727     }
728 
729     function _generateDriver(uint256 seed, uint256 team) private pure returns (uint256 driver) {
730         uint256 index = (seed) % 2;
731 
732         if (team == _TEAM_ID_ALFA_ROMEO_RACING) {
733             driver = [
734                 _DRIVER_ID_KIMI_RAIKKONEN,
735                 _DRIVER_ID_ANTONIO_GIOVINAZZI
736             ][index];
737         } else if (team == _TEAM_ID_SCUDERIA_FERRARI) {
738             driver = [
739                 _DRIVER_ID_SEBASTIAN_VETTEL,
740                 _DRIVER_ID_CHARLES_LECLERC
741             ][index];
742         } else if (team == _TEAM_ID_HAAS_F1_TEAM) {
743             driver = [
744                 _DRIVER_ID_ROMAIN_GROSJEAN,
745                 _DRIVER_ID_KEVIN_MAGNUSSEN
746             ][index];
747         } else if (team == _TEAM_ID_MCLAREN_F1_TEAM) {
748             driver = [
749                 _DRIVER_ID_LANDO_NORRIS,
750                 _DRIVER_ID_CARLOS_SAINZ
751             ][index];
752         } else if (team == _TEAM_ID_MERCEDES_AMG_PETRONAS_MOTORSPORT) {
753             driver = [
754                 _DRIVER_ID_LEWIS_HAMILTON,
755                 _DRIVER_ID_VALTTERI_BOTTAS
756             ][index];
757         } else if (team == _TEAM_ID_SPSCORE_RACING_POINT_F1_TEAM) {
758             driver = [
759                 _DRIVER_ID_SERGIO_PEREZ,
760                 _DRIVER_ID_LANCE_STROLL
761             ][index];
762         } else if (team == _TEAM_ID_ASTON_MARTIN_RED_BULL_RACING) {
763             driver = [
764                 _DRIVER_ID_ALEXANDER_ALBON,
765                 _DRIVER_ID_MAX_VERSTAPPEN
766             ][index];
767         } else if (team == _TEAM_ID_RENAULT_F1_TEAM) {
768             driver = [
769                 _DRIVER_ID_DANIEL_RICCIARDO,
770                 _DRIVER_ID_ESTEBAN_OCON
771             ][index];
772         } else if (team == _TEAM_ID_RED_BULL_TORO_ROSSO_HONDA) {
773             driver = [
774                 _DRIVER_ID_PIERRE_GASLY,
775                 _DRIVER_ID_DANIIL_KVYAT
776             ][index];
777         } else if (team == _TEAM_ID_ROKIT_WILLIAMS_RACING) {
778             driver = [
779                 _DRIVER_ID_GEORGE_RUSSEL,
780                 _DRIVER_ID_NICHOLAS_LATIFI
781             ][index];
782         }
783     }
784 
785     function _generateRacingStats(
786         uint256 seed,
787         uint256 tokenType,
788         uint256 tokenRarity
789     )
790         private
791         pure
792         returns (
793             uint256 stat1,
794             uint256 stat2,
795             uint256 stat3
796         )
797     {
798         uint256 min;
799         uint256 max;
800         if (tokenType == _TYPE_ID_CAR || tokenType == _TYPE_ID_DRIVER) {
801             if (tokenRarity == 1) {
802                 (min, max) = (_RACING_STATS_T1_RARITY_1_MIN, _RACING_STATS_T1_RARITY_1_MAX);
803             } else if (tokenRarity == 2) {
804                 (min, max) = (_RACING_STATS_T1_RARITY_2_MIN, _RACING_STATS_T1_RARITY_2_MAX);
805             } else if (tokenRarity == 3) {
806                 (min, max) = (_RACING_STATS_T1_RARITY_3_MIN, _RACING_STATS_T1_RARITY_3_MAX);
807             } else if (tokenRarity == 4) {
808                 (min, max) = (_RACING_STATS_T1_RARITY_4_MIN, _RACING_STATS_T1_RARITY_4_MAX);
809             } else if (tokenRarity == 5) {
810                 (min, max) = (_RACING_STATS_T1_RARITY_5_MIN, _RACING_STATS_T1_RARITY_5_MAX);
811             } else if (tokenRarity == 6) {
812                 (min, max) = (_RACING_STATS_T1_RARITY_6_MIN, _RACING_STATS_T1_RARITY_6_MAX);
813             } else if (tokenRarity == 7) {
814                 (min, max) = (_RACING_STATS_T1_RARITY_7_MIN, _RACING_STATS_T1_RARITY_7_MAX);
815             } else if (tokenRarity == 8) {
816                 (min, max) = (_RACING_STATS_T1_RARITY_8_MIN, _RACING_STATS_T1_RARITY_8_MAX);
817             } else if (tokenRarity == 9) {
818                 (min, max) = (_RACING_STATS_T1_RARITY_9_MIN, _RACING_STATS_T1_RARITY_9_MAX);
819             } else {
820                 revert("Wrong token rarity");
821             }
822         } else if (tokenType == _TYPE_ID_GEAR || tokenType == _TYPE_ID_PART) {
823             if (tokenRarity == 1) {
824                 (min, max) = (_RACING_STATS_T2_RARITY_1_MIN, _RACING_STATS_T2_RARITY_1_MAX);
825             } else if (tokenRarity == 2) {
826                 (min, max) = (_RACING_STATS_T2_RARITY_2_MIN, _RACING_STATS_T2_RARITY_2_MAX);
827             } else if (tokenRarity == 3) {
828                 (min, max) = (_RACING_STATS_T2_RARITY_3_MIN, _RACING_STATS_T2_RARITY_3_MAX);
829             } else if (tokenRarity == 4) {
830                 (min, max) = (_RACING_STATS_T2_RARITY_4_MIN, _RACING_STATS_T2_RARITY_4_MAX);
831             } else if (tokenRarity == 5) {
832                 (min, max) = (_RACING_STATS_T2_RARITY_5_MIN, _RACING_STATS_T2_RARITY_5_MAX);
833             } else if (tokenRarity == 6) {
834                 (min, max) = (_RACING_STATS_T2_RARITY_6_MIN, _RACING_STATS_T2_RARITY_6_MAX);
835             } else if (tokenRarity == 7) {
836                 (min, max) = (_RACING_STATS_T2_RARITY_7_MIN, _RACING_STATS_T2_RARITY_7_MAX);
837             } else if (tokenRarity == 8) {
838                 (min, max) = (_RACING_STATS_T2_RARITY_8_MIN, _RACING_STATS_T2_RARITY_8_MAX);
839             } else if (tokenRarity == 9) {
840                 (min, max) = (_RACING_STATS_T2_RARITY_9_MIN, _RACING_STATS_T2_RARITY_9_MAX);
841             } else {
842                 revert("Wrong token rarity");
843             }
844         } else if (tokenType == _TYPE_ID_TYRES) {
845             if (tokenRarity == 1) {
846                 (min, max) = (_RACING_STATS_T3_RARITY_1_MIN, _RACING_STATS_T3_RARITY_1_MAX);
847             } else if (tokenRarity == 2) {
848                 (min, max) = (_RACING_STATS_T3_RARITY_2_MIN, _RACING_STATS_T3_RARITY_2_MAX);
849             } else if (tokenRarity == 3) {
850                 (min, max) = (_RACING_STATS_T3_RARITY_3_MIN, _RACING_STATS_T3_RARITY_3_MAX);
851             } else if (tokenRarity == 4) {
852                 (min, max) = (_RACING_STATS_T3_RARITY_4_MIN, _RACING_STATS_T3_RARITY_4_MAX);
853             } else if (tokenRarity == 5) {
854                 (min, max) = (_RACING_STATS_T3_RARITY_5_MIN, _RACING_STATS_T3_RARITY_5_MAX);
855             } else if (tokenRarity == 6) {
856                 (min, max) = (_RACING_STATS_T3_RARITY_6_MIN, _RACING_STATS_T3_RARITY_6_MAX);
857             } else if (tokenRarity == 7) {
858                 (min, max) = (_RACING_STATS_T3_RARITY_7_MIN, _RACING_STATS_T3_RARITY_7_MAX);
859             } else if (tokenRarity == 8) {
860                 (min, max) = (_RACING_STATS_T3_RARITY_8_MIN, _RACING_STATS_T3_RARITY_8_MAX);
861             } else if (tokenRarity == 9) {
862                 (min, max) = (_RACING_STATS_T3_RARITY_9_MIN, _RACING_STATS_T3_RARITY_9_MAX);
863             } else {
864                 revert("Wrong token rarity");
865             }
866         } else {
867             revert("Wrong token type");
868         }
869         uint256 delta = max - min;
870         stat1 = min + (seed % delta);
871         stat2 = min + ((seed >> 16) % delta);
872         stat3 = min + ((seed >> 32) % delta);
873     }
874 
875     function _makeTokenId(Metadata memory metadata) private pure returns (uint256 tokenId) {
876         tokenId = _NF_FLAG;
877         tokenId |= (metadata.tokenType << 240);
878         tokenId |= (metadata.tokenSubType << 232);
879         tokenId |= (_SEASON_ID_2020 << 224);
880         tokenId |= (metadata.model << 192);
881         tokenId |= (metadata.team << 184);
882         tokenId |= (metadata.tokenRarity << 176);
883         tokenId |= (metadata.label << 152);
884         tokenId |= (metadata.driver << 136);
885         tokenId |= (metadata.stat1 << 120);
886         tokenId |= (metadata.stat2 << 104);
887         tokenId |= (metadata.stat3 << 88);
888         tokenId |= metadata.counter;
889     }
890 }
891 
892 
893 // File @animoca/f1dt-ethereum-contracts/contracts/game/Crates2020.sol@v1.0.0
894 
895 pragma solidity ^0.6.8;
896 
897 
898 
899 interface IF1DTBurnableCrateKey {
900     /**
901      * Destroys `amount` of token.
902      * @dev Reverts if called by any other than the contract owner.
903      * @dev Reverts is `amount` is zero.
904      * @param amount Amount of token to burn.
905      */
906     function burn(uint256 amount) external;
907 
908     /**
909      * See {IERC20-transferFrom(address,address,uint256)}.
910      */
911     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
912 
913     /**
914      * @dev Transfers ownership of the contract to a new account (`newOwner`).
915      * Can only be called by the current owner.
916      */
917     function transferOwnership(address newOwner) external;
918 }
919 
920 interface IF1DTInventory {
921     /**
922      * @dev Public function to mint a batch of new tokens
923      * Reverts if some the given token IDs already exist
924      * @param to address[] List of addresses that will own the minted tokens
925      * @param ids uint256[] List of ids of the tokens to be minted
926      * @param uris bytes32[] Concatenated metadata URIs of nfts to be minted
927      * @param values uint256[] List of quantities of ft to be minted
928      */
929     function batchMint(address[] calldata to, uint256[] calldata ids, bytes32[] calldata uris, uint256[] calldata values, bool safe) external;
930 }
931 
932 contract Crates2020 is Ownable {
933     using Crates2020RNGLib for uint256;
934 
935     IF1DTInventory immutable public INVENTORY;
936     IF1DTBurnableCrateKey immutable public CRATE_KEY_COMMON;
937     IF1DTBurnableCrateKey immutable public CRATE_KEY_RARE;
938     IF1DTBurnableCrateKey immutable public CRATE_KEY_EPIC;
939     IF1DTBurnableCrateKey immutable public CRATE_KEY_LEGENDARY;
940 
941     uint256 public counter;
942 
943     constructor(
944         IF1DTInventory INVENTORY_,
945         IF1DTBurnableCrateKey CRATE_KEY_COMMON_,
946         IF1DTBurnableCrateKey CRATE_KEY_RARE_,
947         IF1DTBurnableCrateKey CRATE_KEY_EPIC_,
948         IF1DTBurnableCrateKey CRATE_KEY_LEGENDARY_,
949         uint256 counter_
950     ) public {
951         require(
952             address(INVENTORY_) != address(0) &&
953             address(CRATE_KEY_COMMON_) != address(0) &&
954             address(CRATE_KEY_EPIC_) != address(0) &&
955             address(CRATE_KEY_LEGENDARY_) != address(0),
956             "Crates: zero address"
957         );
958         INVENTORY = INVENTORY_;
959         CRATE_KEY_COMMON = CRATE_KEY_COMMON_;
960         CRATE_KEY_RARE = CRATE_KEY_RARE_;
961         CRATE_KEY_EPIC = CRATE_KEY_EPIC_;
962         CRATE_KEY_LEGENDARY = CRATE_KEY_LEGENDARY_;
963         counter = counter_;
964     }
965 
966     function transferCrateKeyOwnership(uint256 crateTier, address newOwner) external onlyOwner {
967         IF1DTBurnableCrateKey crateKey = _getCrateKey(crateTier);
968         crateKey.transferOwnership(newOwner);
969     }
970 
971     /**
972      * Burn some keys in order to mint 2020 season crates.
973      * @dev Reverts if `quantity` is zero.
974      * @dev Reverts if `crateTier` is not supported.
975      * @dev Reverts if the transfer of the crate key to this contract fails (missing approval or insufficient balance).
976      * @dev Reverts if this contract is not owner of the `crateTier`-related contract.
977      * @dev Reverts if this contract is not minter of the DeltaTimeInventory contract.
978      * @param crateTier The tier identifier for the crates to open.
979      * @param quantity The number of crates to open.
980      * @param seed The seed used for the metadata RNG.
981      */
982     function _openCrates(uint256 crateTier, uint256 quantity, uint256 seed) internal {
983         require(quantity != 0, "Crates: zero quantity");
984         IF1DTBurnableCrateKey crateKey = _getCrateKey(crateTier);
985 
986         address sender = _msgSender();
987         uint256 amount = quantity * 1000000000000000000;
988 
989         crateKey.transferFrom(sender, address(this), amount);
990         crateKey.burn(amount);
991 
992         bytes32[] memory uris = new bytes32[](5);
993         uint256[] memory values = new uint256[](5);
994         address[] memory to = new address[](5);
995         for (uint256 i; i != 5; ++i) {
996             values[i] = 1;
997             to[i] = sender;
998         }
999 
1000         uint256 counter_ = counter;
1001         for (uint256 i; i != quantity; ++i) {
1002             if (i != 0) {
1003                 seed = uint256(keccak256(abi.encode(seed)));
1004             }
1005             uint256[] memory tokens = seed.generateCrate(crateTier, counter_);
1006             INVENTORY.batchMint(to, tokens, uris, values, false);
1007             counter_ += 5;
1008         }
1009         counter = counter_;
1010     }
1011 
1012     function _getCrateKey(uint256 crateTier) view internal returns (IF1DTBurnableCrateKey) {
1013         if (crateTier == Crates2020RNGLib.CRATE_TIER_COMMON) {
1014             return CRATE_KEY_COMMON;
1015         } else if (crateTier == Crates2020RNGLib.CRATE_TIER_RARE) {
1016             return CRATE_KEY_RARE;
1017         } else if (crateTier == Crates2020RNGLib.CRATE_TIER_EPIC) {
1018             return CRATE_KEY_EPIC;
1019         } else if (crateTier == Crates2020RNGLib.CRATE_TIER_LEGENDARY) {
1020             return CRATE_KEY_LEGENDARY;
1021         } else {
1022             revert("Crates: wrong crate tier");
1023         }
1024     }
1025 }
1026 
1027 
1028 // File @animoca/f1dt-ethereum-contracts/contracts/game/Crates2020Locksmith.sol@v1.0.0
1029 
1030 pragma solidity ^0.6.8;
1031 
1032 
1033 
1034 
1035 
1036 contract Crates2020Locksmith is Crates2020 {
1037     using ECDSA for bytes32;
1038 
1039     // account => crateTier => nonce
1040     mapping(address => mapping(uint256 => uint256)) public nonces;
1041 
1042     address public signerKey;
1043 
1044     constructor(
1045         IF1DTInventory INVENTORY_,
1046         IF1DTBurnableCrateKey COMMON_CRATE_,
1047         IF1DTBurnableCrateKey RARE_CRATE_,
1048         IF1DTBurnableCrateKey EPIC_CRATE_,
1049         IF1DTBurnableCrateKey LEGENDARY_CRATE_,
1050         uint256 counter_
1051     ) public Crates2020(INVENTORY_, COMMON_CRATE_, RARE_CRATE_, EPIC_CRATE_, LEGENDARY_CRATE_, counter_) {}
1052 
1053     function setSignerKey(address signerKey_) external onlyOwner {
1054         signerKey = signerKey_;
1055     }
1056 
1057     /**
1058      * Burn some keys in order to mint 2020 season crates.
1059      * @dev reverts if `crateTier` is not supported.
1060      * @dev reverts if `quantity` is zero or more than 5.
1061      * @dev reverts if `signerKey` has not been set.
1062      * @dev reverts if `sig` is not verified to be a signature as described below.
1063      * @dev Reverts if the transfer of the crate key to this contract fails (missing approval or insufficient balance).
1064      * @dev Reverts if this contract is not owner of the `crateTier`-related contract.
1065      * @dev Reverts if this contract is not minter of the DeltaTimeInventory contract.
1066      * @param crateTier The tier identifier for the crates to open.
1067      * @param quantity The number of keys to burn / crates to open.
1068      * @param sig The signature for keccak256(abi.encode(sender, crateTier, nonce))
1069      *  signed by the private key paired to the public key `signerKey`, where:
1070      *  - `sender` is the msg.sender,
1071      *  - `crateTier` is the tier of crate to open,
1072      *  - `nonce` is the currently tracked nonce, accessed via `nonces(sender, crateTier)`.
1073      */
1074     function insertKeys(uint256 crateTier, uint256 quantity, bytes calldata sig) external {
1075         require(crateTier <= Crates2020RNGLib.CRATE_TIER_COMMON, "Locksmith: wrong crate tier");
1076         require(quantity <= 5, "Locksmith: above max quantity");
1077 
1078         address signerKey_ = signerKey;
1079         require(signerKey_ != address(0), "Locksmith: signer key not set");
1080 
1081         address sender = _msgSender();
1082         uint256 nonce = nonces[sender][crateTier];
1083         bytes32 hash_ = keccak256(abi.encode(sender, crateTier, nonce));
1084         require(hash_.toEthSignedMessageHash().recover(sig) == signerKey_, "Locksmith: invalid signature");
1085 
1086         uint256 seed = uint256(keccak256(sig));
1087         _openCrates(crateTier, quantity, seed);
1088 
1089         nonces[sender][crateTier] = nonce + 1;
1090     }
1091 }