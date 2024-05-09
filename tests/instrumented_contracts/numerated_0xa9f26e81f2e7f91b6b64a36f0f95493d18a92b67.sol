1 pragma solidity ^0.4.24;
2 
3 // File: contracts/AZTEC/AZTEC.sol
4 
5 library AZTECInterface {
6     function validateJoinSplit(bytes32[6][], uint, uint, bytes32[4]) external pure returns (bool) {}
7 }
8 
9 /**
10  * @title Library to validate AZTEC zero-knowledge proofs
11  * @author Zachary Williamson, AZTEC
12  * @dev Don't include this as an internal library. This contract uses a static memory table to cache elliptic curve primitives and hashes.
13  * Calling this internally from another function will lead to memory mutation and undefined behaviour.
14  * The intended use case is to call this externally via `staticcall`. External calls to OptimizedAZTEC can be treated as pure functions as this contract contains no storage and makes no external calls (other than to precompiles)
15  * Copyright Spilbury Holdings Ltd 2018. All rights reserved.
16  * We will be releasing AZTEC as an open-source protocol that provides efficient transaction privacy for Ethereum.
17  * Our full vision of the protocol includes confidential cross-asset interactions via our family of AZTEC zero-knowledge proofs
18  * and the AZTEC token standard, stay tuned for updates!
19  **/
20 contract AZTEC {
21     /**
22      * @dev AZTEC will take any transaction sent to it and attempt to validate a zero knowledge proof.
23      * If the proof is not valid, the transaction will throw.
24      * @notice See AZTECInterface for how method calls should be constructed.
25      * 'Cost' of raw elliptic curve primitives for a transaction: 260,700 gas + (124,500 * number of input notes) + (167,600 * number of output notes).
26      * For a basic 'joinSplit' with 2 inputs and 2 outputs = 844,900 gas.
27      * AZTEC is written in YUL to enable manual memory management and for other efficiency savings.
28      **/
29     function() external payable {
30         assembly {
31 
32             // We don't check for function signatures, there's only one function that ever gets called: validateJoinSplit()
33             // We still assume calldata is offset by 4 bytes so that we can represent this contract through a compatible ABI
34             validateJoinSplit()
35 
36             // should not get here
37             mstore(0x00, 404)
38             revert(0x00, 0x20)
39 
40             /**
41              * @dev Validate an AZTEC protocol JoinSplit zero-knowledge proof
42              * Calldata Map is
43              * 0x04:0x24       = calldata location of start of ```note``` dynamic array
44              * 0x24:0x44       = m, which defines the index separator between input notes ando utput notes
45              * 0x44:0x64       = Fiat-Shamir heuristicified random challenge
46              * 0x64:0xe4       = G2 element t2, the trusted setup public key
47              * 0xe4:0x104      = start of ```note``` dynamic array, contains the size of the array (```n```)
48              * Subsequent calldata arranged in 0xc0 sized blocks of data, each representing an AZTEC commitment and zero-knowledge proof variables
49              *
50              * Note data map (uint[6]) is
51              * 0x00:0x20       = Z_p element \bar{k}_i
52              * 0x20:0x40       = Z_p element \bar{a}_i
53              * 0x40:0x80       = G1 element \gamma_i
54              * 0x80:0xc0       = G1 element \sigma_i
55              *
56              * The last element in the note array is special and contains the following:
57              * 0x00:0x20       = Z_p element k_{public}
58              * 0x20:0x40       = Z_p element \bar{a}_i
59              * 0x40:0x60       = G1 element \gamma_i
60              * 0x60-0x80       = G1 element \sigma_i
61              * We can recover \bar{k}_{n-1} from the homomorphic sum condition \sum_{i=0}^{m-1}\bar{k}_i = \sum_{i=m}^{n-1}\bar{k}_i + k_{public}
62              * So we use the empty slot to store k_{public}, which represents any public 'value' being blinded into zero-knowledge notes
63              *
64              * We use a hard-coded memory map to reduce gas costs - if this is not called as an external contract then terrible things will happen!
65              * 0x00:0x20       = scratch data to store result of keccak256 calls
66              * 0x20:0x80       = scratch data to store \gamma_i and a multiplication scalar
67              * 0x80:0xc0       = x-coordinate of generator h
68              * 0xc0:0xe0       = y-coordinate of generator h
69              * 0xe0:0x100      = scratch data to store a scalar we plan to multiply h by
70              * 0x100:0x160     = scratch data to store \sigma_i and a multiplication scalar
71              * 0x160:0x1a0     = stratch data to store result of G1 point additions
72              * 0x1a0:0x1c0     = scratch data to store result of \sigma_i^{-cx_{i-m-1}}
73              * 0x1c0:0x200     = location of pairing accumulator \sigma_{acc}, where \sigma_{acc} = \prod_{i=m}^{n-1}\sigma_i^{cx_{i-m-1}}
74              * 0x220:0x260     = scratch data to store \gamma_i^{cx_{i-m-1}}
75              * 0x260:0x2a0     = location of pairing accumulator \gamma_{acc}, where \gamma_{acc} = \prod_{i=m}^{n-1}\gamma_i^{cx_{i-m-1}}
76              * 0x2a0:0x2c0     = msg.sender (contract should be called via delegatecall/staticcall)
77              * 0x2c0:0x2e0     = kn (memory used to reconstruct hash starts here)
78              * 0x2e0:0x300     = m
79              * 0x300:???       = block of memory that contains (\gamma_i, \sigma_i)_{i=0}^{n-1} concatenated with (B_i)_{i=0}^{n-1}
80              **/
81             function validateJoinSplit() {
82                 mstore(0x80, 7673901602397024137095011250362199966051872585513276903826533215767972925880) // h_x
83                 mstore(0xa0, 8489654445897228341090914135473290831551238522473825886865492707826370766375) // h_y
84                 let notes := add(0x04, calldataload(0x04))
85                 let m := calldataload(0x24)
86                 let n := calldataload(notes)
87                 let gen_order := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
88                 let challenge := mod(calldataload(0x44), gen_order)
89 
90                 // validate m <= n
91                 if gt(m, n) { mstore(0x00, 404) revert(0x00, 0x20) }
92 
93                 // recover k_{public} and calculate k_{public}
94                 let kn := calldataload(sub(calldatasize, 0xc0))
95 
96                 // add kn and m to final hash table
97                 mstore(0x2a0, caller)
98                 mstore(0x2c0, kn)
99                 mstore(0x2e0, m)
100                 kn := mulmod(sub(gen_order, kn), challenge, gen_order) // we actually want c*k_{public}
101                 hashCommitments(notes, n)
102                 let b := add(0x300, mul(n, 0x80))
103 
104                 // Iterate over every note and calculate the blinding factor B_i = \gamma_i^{kBar}h^{aBar}\sigma_i^{-c}.
105                 // We use the AZTEC protocol pairing optimization to reduce the number of pairing comparisons to 1, which adds some minor alterations
106                 for { let i := 0 } lt(i, n) { i := add(i, 0x01) } {
107 
108                     // Get the calldata index of this note
109                     let noteIndex := add(add(notes, 0x20), mul(i, 0xc0))
110 
111                     // Define variables k, a and c.
112                     // If i <= m then
113                     //   k = kBar_i
114                     //   a = aBar_i
115                     //   c = challenge
116                     // If i > m then we add a modification for the pairing optimization
117                     //   k = kBar_i * x_i
118                     //   a = aBar_i * x_i
119                     //   c = challenge * x_i
120                     // Set j = i - (m + 1).
121                     // x_0 = 1
122                     // x_1 = keccak256(input string)
123                     // all other x_{j} = keccak256(x_{j-1})
124                     // The reason for doing this is that the point  \sigma_i^{-cx_j} can be re-used in the pairing check
125                     // Instead of validating e(\gamma_i, t_2) == e(\sigma_i, g_2) for all i = [m+1,\ldots,n]
126                     // We instead validate e(\Pi_{i=m+1}^{n}\gamma_i^{-cx_j}, t_2) == e(\Pi_{i=m+1}^{n}\sigma_i^{cx_j}, g_2).
127                     // x_j is a pseudorandom variable whose entropy source is the input string, allowing for
128                     // a sum of commitment points to be evaluated in one pairing comparison
129                     let k
130                     let a := calldataload(add(noteIndex, 0x20))
131                     let c := challenge
132 
133                     // We don't transmit kBar_{n-1} in the proof to save space, instead we derive it
134                     // As per the homomorphic sum condition: \sum_{i=0}^{m-1}\bar{k}_i = \sum_{i=m}^{n-1}\bar{k}_i + k_{public}c, 
135                     // We can recover \bar{k}_{n-1}.
136                     // If m=n then \bar{k}_{n-1} = \sum_{i=0}^{n-1}\bar{k}_i + k_{public}
137                     // else \bar{k}_{n-1} = \sum_{i=0}^{m-1}\bar{k}_i - \sum_{i=m}^{n-1}\bar{k}_i - k_{public}
138                     switch eq(add(i, 0x01), n)
139                     case 1 {
140                         k := kn
141 
142                         // if all notes are input notes, invert k
143                         if eq(m, n) {
144                             k := sub(gen_order, k)
145                         }
146                     }
147                     case 0 { k := calldataload(noteIndex) }
148 
149                     // Check this commitment is well formed...
150                     validateCommitment(noteIndex, k, a)
151 
152                     // If i > m then this is an output note.
153                     // Set k = kx_j, a = ax_j, c = cx_j, where j = i - (m+1)
154                     switch gt(add(i, 0x01), m)
155                     case 1 {
156 
157                         // before we update k, update kn = \sum_{i=0}^{m-1}k_i - \sum_{i=m}^{n-1}k_i
158                         kn := addmod(kn, sub(gen_order, k), gen_order)
159                         let x := mod(mload(0x00), gen_order)
160                         k := mulmod(k, x, gen_order)
161                         a := mulmod(a, x, gen_order)
162                         c := mulmod(challenge, x, gen_order)
163 
164                         // calculate x_{j+1}
165                         mstore(0x00, keccak256(0x00, 0x20))
166                     }
167                     case 0 {
168 
169                         // nothing to do here except update kn = \sum_{i=0}^{m-1}k_i - \sum_{i=m}^{n-1}k_i
170                         kn := addmod(kn, k, gen_order)
171                     }
172                     
173                     // Calculate the G1 element \gamma_i^{k}h^{a}\sigma_i^{-c} = B_i
174                     // Memory map:
175                     // 0x20: \gamma_iX
176                     // 0x40: \gamma_iY
177                     // 0x60: k_i
178                     // 0x80: hX
179                     // 0xa0: hY
180                     // 0xc0: a_i
181                     // 0xe0: \sigma_iX
182                     // 0x100: \sigma_iY
183                     // 0x120: -c
184                     calldatacopy(0xe0, add(noteIndex, 0x80), 0x40)
185                     calldatacopy(0x20, add(noteIndex, 0x40), 0x40)
186                     mstore(0x120, sub(gen_order, c)) 
187                     mstore(0x60, k)
188                     mstore(0xc0, a)
189 
190                     // Call bn128 scalar multiplication precompiles
191                     // Represent point + multiplication scalar in 3 consecutive blocks of memory
192                     // Store \sigma_i^{-c} at 0x1a0:0x200
193                     // Store \gamma_i^{k} at 0x120:0x160
194                     // Store h^{a} at 0x160:0x1a0
195                     let result := staticcall(gas, 7, 0xe0, 0x60, 0x1a0, 0x40)
196                     result := and(result, staticcall(gas, 7, 0x20, 0x60, 0x120, 0x40))
197                     result := and(result, staticcall(gas, 7, 0x80, 0x60, 0x160, 0x40))
198 
199                     // Call bn128 group addition precompiles
200                     // \gamma_i^{k} and h^{a} in memory block 0x120:0x1a0
201                     // Store result of addition at 0x160:0x1a0
202                     result := and(result, staticcall(gas, 6, 0x120, 0x80, 0x160, 0x40))
203 
204                     // \gamma_i^{k}h^{a} and \sigma^{-c} in memory block 0x160:0x1e0
205                     // Store resulting point B at memory index b
206                     result := and(result, staticcall(gas, 6, 0x160, 0x80, b, 0x40))
207 
208                     // We have \sigma^{-c} at 0x1a0:0x200
209                     // And \sigma_{acc} at 0x1e0:0x200
210                     // If i = m + 1 (i.e. first output note)
211                     // then we set \gamma_{acc} and \sigma_{acc} to \gamma_i, -\sigma_i
212                     if eq(i, m) {
213                         mstore(0x260, mload(0x20))
214                         mstore(0x280, mload(0x40))
215                         mstore(0x1e0, mload(0xe0))
216                         mstore(0x200, sub(0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47, mload(0x100)))
217                     }
218 
219                     // If i > m + 1 (i.e. subsequent output notes)
220                     // then we add \sigma^{-c} and \sigma_{acc} and store result at \sigma_{acc} (0x1e0:0x200)
221                     // we then calculate \gamma^{cx} and add into \gamma_{acc}
222                     if gt(i, m) {
223                        mstore(0x60, c)
224                        result := and(result, staticcall(gas, 7, 0x20, 0x60, 0x220, 0x40))
225 
226                        // \gamma_i^{cx} now at 0x220:0x260, \gamma_{acc} is at 0x260:0x2a0
227                        result := and(result, staticcall(gas, 6, 0x220, 0x80, 0x260, 0x40))
228 
229                        // add \sigma_i^{-cx} and \sigma_{acc} into \sigma_{acc} at 0x1e0
230                        result := and(result, staticcall(gas, 6, 0x1a0, 0x80, 0x1e0, 0x40))
231                     }
232 
233                     // throw transaction if any calls to precompiled contracts failed
234                     if iszero(result) { mstore(0x00, 400) revert(0x00, 0x20) }
235                     b := add(b, 0x40) // increase B pointer by 2 words
236                 }
237 
238                 // If the AZTEC protocol is implemented correctly then any input notes were previously outputs of
239                 // a JoinSplit transaction. We can inductively assume that all input notes are well-formed AZTEC commitments and do not need to validate the implicit range proof
240                 // This is not the case for any output commitments, so if (m < n) call validatePairing()
241                 if lt(m, n) {
242                    validatePairing(0x64)
243                 }
244 
245                 // We now have the note commitments and the calculated blinding factors in a block of memory
246                 // starting at 0x2a0, of size (b - 0x2a0).
247                 // Hash this block to reconstruct the initial challenge and validate that they match
248                 let expected := mod(keccak256(0x2a0, sub(b, 0x2a0)), gen_order)
249                 if iszero(eq(expected, challenge)) {
250 
251                     // No! Bad! No soup for you!
252                     mstore(0x00, 404)
253                     revert(0x00, 0x20)
254                 }
255 
256                 // Great! All done. This is a valid proof so return ```true```
257                 mstore(0x00, 0x01)
258                 return(0x00, 0x20)
259             }
260 
261             /**        
262              * @dev evaluate if e(P1, t2) . e(P2, g2) == 0.
263              * @notice we don't hard-code t2 so that contracts that call this library can use different trusted setups.
264              **/
265             function validatePairing(t2) {
266                 let field_order := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
267                 let t2_x_1 := calldataload(t2)
268                 let t2_x_2 := calldataload(add(t2, 0x20))
269                 let t2_y_1 := calldataload(add(t2, 0x40))
270                 let t2_y_2 := calldataload(add(t2, 0x60))
271 
272                 // check provided setup pubkey is not zero or g2
273                 if or(or(or(or(or(or(or(
274                     iszero(t2_x_1),
275                     iszero(t2_x_2)),
276                     iszero(t2_y_1)),
277                     iszero(t2_y_2)),
278                     eq(t2_x_1, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)),
279                     eq(t2_x_2, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2)),
280                     eq(t2_y_1, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)),
281                     eq(t2_y_2, 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b))
282                 {
283                     mstore(0x00, 400)
284                     revert(0x00, 0x20)
285                 }
286 
287                 // store coords in memory
288                 // indices are a bit off, scipr lab's libff limb ordering (c0, c1) is opposite to what precompile expects
289                 // We can overwrite the memory we used previously as this function is called at the end of the validation routine.
290                 mstore(0x20, mload(0x1e0)) // sigma accumulator x
291                 mstore(0x40, mload(0x200)) // sigma accumulator y
292                 mstore(0x80, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)
293                 mstore(0x60, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2)
294                 mstore(0xc0, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)
295                 mstore(0xa0, 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b)
296                 mstore(0xe0, mload(0x260)) // gamma accumulator x
297                 mstore(0x100, mload(0x280)) // gamma accumulator y
298                 mstore(0x140, t2_x_1)
299                 mstore(0x120, t2_x_2)
300                 mstore(0x180, t2_y_1)
301                 mstore(0x160, t2_y_2)
302 
303                 let success := staticcall(gas, 8, 0x20, 0x180, 0x20, 0x20)
304 
305                 if or(iszero(success), iszero(mload(0x20))) {
306                     mstore(0x00, 400)
307                     revert(0x00, 0x20)
308                 }
309             }
310 
311             /**
312              * @dev check that this note's points are on the altbn128 curve(y^2 = x^3 + 3)
313              * and that signatures 'k' and 'a' are modulo the order of the curve. Transaction will throw if this is not the case.
314              * @param note the calldata loation of the note
315              **/
316             function validateCommitment(note, k, a) {
317                 let gen_order := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
318                 let field_order := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
319                 let gammaX := calldataload(add(note, 0x40))
320                 let gammaY := calldataload(add(note, 0x60))
321                 let sigmaX := calldataload(add(note, 0x80))
322                 let sigmaY := calldataload(add(note, 0xa0))
323                 if iszero(
324                     and(
325                         and(
326                             and(
327                                 eq(mod(a, gen_order), a), // a is modulo generator order?
328                                 gt(a, 1)                  // can't be 0 or 1 either!
329                             ),
330                             and(
331                                 eq(mod(k, gen_order), k), // k is modulo generator order?
332                                 gt(k, 1)                  // and not 0 or 1
333                             )
334                         ),
335                         and(
336                             eq( // y^2 ?= x^3 + 3
337                                 addmod(mulmod(mulmod(sigmaX, sigmaX, field_order), sigmaX, field_order), 3, field_order),
338                                 mulmod(sigmaY, sigmaY, field_order)
339                             ),
340                             eq( // y^2 ?= x^3 + 3
341                                 addmod(mulmod(mulmod(gammaX, gammaX, field_order), gammaX, field_order), 3, field_order),
342                                 mulmod(gammaY, gammaY, field_order)
343                             )
344                         )
345                     )
346                 ) {
347                     mstore(0x00, 400)
348                     revert(0x00, 0x20)
349                 }
350             }
351 
352             /**
353              * @dev Calculate the keccak256 hash of the commitments for both input notes and output notes.
354              * This is used both as an input to validate the challenge `c` and also to generate pseudorandom relationships
355              * between commitments for different outputNotes, so that we can combine them into a single multi-exponentiation for the purposes of validating the bilinear pairing relationships.
356              * @param notes calldata location notes
357              * @param n number of notes
358              **/
359             function hashCommitments(notes, n) {
360                 for { let i := 0 } lt(i, n) { i := add(i, 0x01) } {
361                     let index := add(add(notes, mul(i, 0xc0)), 0x60)
362                     calldatacopy(add(0x300, mul(i, 0x80)), index, 0x80)
363                 }
364                 mstore(0x00, keccak256(0x300, mul(n, 0x80)))
365             }
366         }
367     }
368 }
369 
370 // File: contracts/AZTEC/AZTECERC20Bridge.sol
371 
372 /**
373  * @title ERC20 interface
374  * @dev https://github.com/ethereum/EIPs/issues/20
375  **/
376 contract ERC20Interface {
377   function transfer(address to, uint256 value) external returns (bool);
378 
379   function transferFrom(address from, address to, uint256 value)
380     external returns (bool);
381 }
382 
383 /**
384  * @title  AZTEC token, providing a confidential representation of an ERC20 token 
385  * @author Zachary Williamson, AZTEC
386  * Copyright Spilsbury Holdings Ltd 2018. All rights reserved.
387  * We will be releasing AZTEC as an open-source protocol that provides efficient transaction privacy for Ethereum.
388  * Our full vision of the protocol includes confidential cross-asset interactions via our family of AZTEC zero-knowledge proofs
389  * and the AZTEC token standard, stay tuned for updates!
390  **/
391 contract AZTECERC20Bridge {
392     bytes32[4] setupPubKey;
393     bytes32 domainHash;
394     uint private constant groupModulusBoundary = 10944121435919637611123202872628637544274182200208017171849102093287904247808;
395     uint private constant groupModulus = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
396     uint public scalingFactor;
397     mapping(bytes32 => address) public noteRegistry;
398     ERC20Interface token;
399 
400     event Created(bytes32 domainHash, address contractAddress);
401     event ConfidentialTransfer();
402 
403     /**
404     * @dev contract constructor.
405     * @param _setupPubKey the trusted setup public key (group element of group G2)
406     * @param _token the address of the ERC20 token being attached to
407     * @param _scalingFactor the mapping from note value -> ERC20 token value.
408     * AZTEC notes have a range between 0 and 2^{25}-1 and ERC20 tokens range between 0 and 2^{255} - 1
409     * so we don't want to directly map note value : token value
410     **/
411     constructor(bytes32[4] _setupPubKey, address _token, uint256 _scalingFactor, uint256 _chainId) public {
412         setupPubKey = _setupPubKey;
413         token = ERC20Interface(_token);
414         scalingFactor = _scalingFactor;
415         bytes32 _domainHash;
416         assembly {
417             let m := mload(0x40)
418             mstore(m, 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f) // "EIP712Domain(string name, string version, uint256 chainId, address verifyingContract)"
419             mstore(add(m, 0x20), 0x60d177492a60de7c666b3e3d468f14d59def1d4b022d08b6adf554d88da60d63) // name = "AZTECERC20BRIDGE_DOMAIN"
420             mstore(add(m, 0x40), 0x28a43689b8932fb9695c28766648ed3d943ff8a6406f8f593738feed70039290) // version = "0.1.1"
421             mstore(add(m, 0x60), _chainId) // chain id
422             mstore(add(m, 0x80), address) // verifying contract
423             _domainHash := keccak256(m, 0xa0)
424         }
425         domainHash = _domainHash;
426         emit Created(_domainHash, this);
427     }
428 
429     /**
430     * @dev Determine validity of an input note and remove from note registry
431     * 1. validate that the note is signed by the note owner
432     * 2. validate that the note exists in the note registry
433     *
434     * Note signature is EIP712 signature (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md) over the following struct
435     * struct AZTEC_NOTE_SIGNATURE {
436     *     bytes32[4] note;
437     *     uint256 challenge;
438     *     address sender;    
439     * };
440     * @param note AZTEC confidential note being destroyed
441     * @param signature ECDSA signature from note owner
442     * @param challenge AZTEC zero-knowledge proof challenge
443     * @param domainHashT Temporary holding ```domainHash``` (to minimize # of sload ops)
444     **/
445     function validateInputNote(bytes32[6] note, bytes32[3] signature, uint challenge, bytes32 domainHashT) internal {
446         bytes32 noteHash;
447         bytes32 signatureMessage;
448         assembly {
449             let m := mload(0x40)
450             mstore(m, mload(add(note, 0x40)))
451             mstore(add(m, 0x20), mload(add(note, 0x60)))
452             mstore(add(m, 0x40), mload(add(note, 0x80)))
453             mstore(add(m, 0x60), mload(add(note, 0xa0)))
454             noteHash := keccak256(m, 0x80)
455             mstore(m, 0x0f1ea84c0ceb3ad2f38123d94a164612e1a0c14a694dc5bfa16bc86ea1f3eabd) // keccak256 hash of "AZTEC_NOTE_SIGNATURE(bytes32[4] note,uint256 challenge,address sender)"
456             mstore(add(m, 0x20), noteHash)
457             mstore(add(m, 0x40), challenge)
458             mstore(add(m, 0x60), caller)
459             mstore(add(m, 0x40), keccak256(m, 0x80))
460             mstore(add(m, 0x20), domainHashT)
461             mstore(m, 0x1901)
462             signatureMessage := keccak256(add(m, 0x1e), 0x42)
463         }
464         address owner = ecrecover(signatureMessage, uint8(signature[0]), signature[1], signature[2]);
465         require(owner != address(0), "signature invalid");
466         require(noteRegistry[noteHash] == owner, "expected input note to exist in registry");
467         noteRegistry[noteHash] = 0;
468     }
469 
470     /**
471     * @dev Validate an output note from an AZTEC confidential transaction
472     * If the note does not already exist in ```noteRegistry```, create it
473     * @param note AZTEC confidential note to be created
474     * @param owner The address of the note owner
475     **/
476     function validateOutputNote(bytes32[6] note, address owner) internal {
477         bytes32 noteHash; // Construct a keccak256 hash of the note coordinates.
478         assembly {
479             let m := mload(0x40)
480             mstore(m, mload(add(note, 0x40)))
481             mstore(add(m, 0x20), mload(add(note, 0x60)))
482             mstore(add(m, 0x40), mload(add(note, 0x80)))
483             mstore(add(m, 0x60), mload(add(note, 0xa0)))
484             noteHash := keccak256(m, 0x80)
485         }
486         require(owner != address(0), "owner must be valid Ethereum address");
487         require(noteRegistry[noteHash] == 0, "expected output note to not exist in registry");
488         noteRegistry[noteHash] = owner;
489     }
490 
491     /**
492     * @dev Perform a confidential transaction. Takes ```m``` input notes and ```notes.length - m``` output notes.
493     * ```notes, m, challenge``` constitute an AZTEC zero-knowledge proof that states the following:
494     * The sum of the values of the input notes is equal to a the sum of the values of the output notes + a public commitment value ```kPublic```
495     * \sum_{i=0}^{m-1}k_i = \sum_{i=m}^{n-1}k_i + k_{public} (mod p)
496     * notes[6][] contains value ```kPublic```  at notes[notes.length - 1][0].
497     * If ```kPublic``` is negative, this represents ```(GROUP_MODULUS - kPublic) * SCALING_FACTOR``` ERC20 tokens being converted into confidential note form.
498     * If ```kPublic``` is positive, this represents ```kPublic * SCALING_FACTOR``` worth of AZTEC notes being converted into ERC20 form
499     * @param notes defines AZTEC input notes and output notes. notes[0,...,m-1] = input notes. notes[m,...,notes.length-1] = output notes
500     * @param m where notes[0,..., m - 1] = input notes. notes[m,...,notes.length - 1] = output notes
501     * @param challenge AZTEC zero-knowledge proof challenge variable
502     * @param inputSignatures array of ECDSA signatures, one for each input note
503     * @param outputOwners addresses of owners, one for each output note
504     * Unnamed param is metadata: if AZTEC notes are assigned to stealth addresses, metadata should contain the ephemeral keys required for note owner to identify their note
505     */
506     function confidentialTransfer(bytes32[6][] notes, uint256 m, uint256 challenge, bytes32[3][] inputSignatures, address[] outputOwners, bytes) external {
507         require(inputSignatures.length == m, "input signature length invalid");
508         require(inputSignatures.length + outputOwners.length == notes.length, "array length mismatch");
509 
510         // validate AZTEC zero-knowledge proof
511         require(AZTECInterface.validateJoinSplit(notes, m, challenge, setupPubKey), "proof not valid!");
512 
513         // extract variable kPublic from proof
514         uint256 kPublic = uint(notes[notes.length - 1][0]);
515         require(kPublic < groupModulus, "invalid value of kPublic");
516 
517         // iterate over the notes array and validate each input/output note
518         for (uint256 i = 0; i < notes.length; i++) {
519 
520             // if i < m this is an input note
521             if (i < m) {
522 
523                 // call validateInputNote to check that the note exists and that we have a matching signature over the note.
524                 // pass domainHash in as a function parameter to prevent multiple sloads
525                 // this will remove the input notes from noteRegistry
526                 validateInputNote(notes[i], inputSignatures[i], challenge, domainHash);
527             } else {
528 
529                 // if i >= m this is an output note
530                 // validate that output notes, attached to the specified owners do not exist in noteRegistry.
531                 // if all checks pass, add notes into note registry
532                 validateOutputNote(notes[i], outputOwners[i - m]);
533             }
534         }
535 
536         if (kPublic > 0) {
537             if (kPublic < groupModulusBoundary) {
538 
539                 // if value < the group modulus boundary then this public value represents a conversion from confidential note form to public form
540                 // call token.transfer to send relevent tokens
541                 require(token.transfer(msg.sender, kPublic * scalingFactor), "token transfer to user failed!");
542             } else {
543 
544                 // if value > group modulus boundary, this represents a commitment of a public value into confidential note form.
545                 // only proceed if the required transferFrom call from msg.sender to this contract succeeds
546                 require(token.transferFrom(msg.sender, this, (groupModulus - kPublic) * scalingFactor), "token transfer from user failed!");
547             }
548         }
549 
550         // emit an event to mark this transaction. Can recover notes + metadata from input data
551         emit ConfidentialTransfer();
552     }
553 }