1 pragma solidity ^0.4.24;
2 
3 library AZTECInterface {
4     function validateJoinSplit(bytes32[6][], uint, uint, bytes32[4]) external pure returns (bool) {}
5 }
6 
7 /**
8  * @title Library to validate AZTEC zero-knowledge proofs
9  * @author Zachary Williamson, AZTEC
10  * @dev Don't include this as an internal library. This contract uses a static memory table to cache elliptic curve primitives and hashes.
11  * Calling this internally from another function will lead to memory mutation and undefined behaviour.
12  * The intended use case is to call this externally via `staticcall`. External calls to OptimizedAZTEC can be treated as pure functions as this contract contains no storage and makes no external calls (other than to precompiles)
13  * Copyright Spilbury Holdings Ltd 2018. All rights reserved.
14  * We will be releasing AZTEC as an open-source protocol that provides efficient transaction privacy for Ethereum.
15  * Our full vision of the protocol includes confidential cross-asset interactions via our family of AZTEC zero-knowledge proofs
16  * and the AZTEC token standard, stay tuned for updates!
17  **/
18 contract AZTEC {
19     /**
20      * @dev AZTEC will take any transaction sent to it and attempt to validate a zero knowledge proof.
21      * If the proof is not valid, the transaction will throw.
22      * @notice See AZTECInterface for how method calls should be constructed.
23      * 'Cost' of raw elliptic curve primitives for a transaction: 260,700 gas + (124,500 * number of input notes) + (167,600 * number of output notes).
24      * For a basic 'joinSplit' with 2 inputs and 2 outputs = 844,900 gas.
25      * AZTEC is written in YUL to enable manual memory management and for other efficiency savings.
26      **/
27     function() external payable {
28         assembly {
29 
30             // We don't check for function signatures, there's only one function that ever gets called: validateJoinSplit()
31             // We still assume calldata is offset by 4 bytes so that we can represent this contract through a compatible ABI
32             validateJoinSplit()
33 
34             // should not get here
35             mstore(0x00, 404)
36             revert(0x00, 0x20)
37 
38             /**
39              * @dev Validate an AZTEC protocol JoinSplit zero-knowledge proof
40              * Calldata Map is
41              * 0x04:0x24       = calldata location of start of ```note``` dynamic array
42              * 0x24:0x44       = m, which defines the index separator between input notes ando utput notes
43              * 0x44:0x64       = Fiat-Shamir heuristicified random challenge
44              * 0x64:0xe4       = G2 element t2, the trusted setup public key
45              * 0xe4:0x104      = start of ```note``` dynamic array, contains the size of the array (```n```)
46              * Subsequent calldata arranged in 0xc0 sized blocks of data, each representing an AZTEC commitment and zero-knowledge proof variables
47              *
48              * Note data map (uint[6]) is
49              * 0x00:0x20       = Z_p element \bar{k}_i
50              * 0x20:0x40       = Z_p element \bar{a}_i
51              * 0x40:0x80       = G1 element \gamma_i
52              * 0x80:0xc0       = G1 element \sigma_i
53              *
54              * The last element in the note array is special and contains the following:
55              * 0x00:0x20       = Z_p element k_{public}
56              * 0x20:0x40       = Z_p element \bar{a}_i
57              * 0x40:0x60       = G1 element \gamma_i
58              * 0x60-0x80       = G1 element \sigma_i
59              * We can recover \bar{k}_{n-1} from the homomorphic sum condition \sum_{i=0}^{m-1}\bar{k}_i = \sum_{i=m}^{n-1}\bar{k}_i + k_{public}
60              * So we use the empty slot to store k_{public}, which represents any public 'value' being blinded into zero-knowledge notes
61              *
62              * We use a hard-coded memory map to reduce gas costs - if this is not called as an external contract then terrible things will happen!
63              * 0x00:0x20       = scratch data to store result of keccak256 calls
64              * 0x20:0x80       = scratch data to store \gamma_i and a multiplication scalar
65              * 0x80:0xc0       = x-coordinate of generator h
66              * 0xc0:0xe0       = y-coordinate of generator h
67              * 0xe0:0x100      = scratch data to store a scalar we plan to multiply h by
68              * 0x100:0x160     = scratch data to store \sigma_i and a multiplication scalar
69              * 0x160:0x1a0     = stratch data to store result of G1 point additions
70              * 0x1a0:0x1c0     = scratch data to store result of \sigma_i^{-cx_{i-m-1}}
71              * 0x1c0:0x200     = location of pairing accumulator \sigma_{acc}, where \sigma_{acc} = \prod_{i=m}^{n-1}\sigma_i^{cx_{i-m-1}}
72              * 0x220:0x260     = scratch data to store \gamma_i^{cx_{i-m-1}}
73              * 0x260:0x2a0     = location of pairing accumulator \gamma_{acc}, where \gamma_{acc} = \prod_{i=m}^{n-1}\gamma_i^{cx_{i-m-1}}
74              * 0x2a0:0x2c0     = msg.sender (contract should be called via delegatecall/staticcall)
75              * 0x2c0:0x2e0     = kn (memory used to reconstruct hash starts here)
76              * 0x2e0:0x300     = m
77              * 0x300:???       = block of memory that contains (\gamma_i, \sigma_i)_{i=0}^{n-1} concatenated with (B_i)_{i=0}^{n-1}
78              **/
79             function validateJoinSplit() {
80                 mstore(0x80, 7673901602397024137095011250362199966051872585513276903826533215767972925880) // h_x
81                 mstore(0xa0, 8489654445897228341090914135473290831551238522473825886865492707826370766375) // h_y
82                 let notes := add(0x04, calldataload(0x04))
83                 let m := calldataload(0x24)
84                 let n := calldataload(notes)
85                 let gen_order := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
86                 let challenge := mod(calldataload(0x44), gen_order)
87 
88                 // validate m <= n
89                 if gt(m, n) { mstore(0x00, 404) revert(0x00, 0x20) }
90 
91                 // recover k_{public} and calculate k_{public}
92                 let kn := calldataload(sub(calldatasize, 0xc0))
93 
94                 // add kn and m to final hash table
95                 mstore(0x2a0, caller)
96                 mstore(0x2c0, kn)
97                 mstore(0x2e0, m)
98                 kn := mulmod(sub(gen_order, kn), challenge, gen_order) // we actually want c*k_{public}
99                 hashCommitments(notes, n)
100                 let b := add(0x300, mul(n, 0x80))
101 
102                 // Iterate over every note and calculate the blinding factor B_i = \gamma_i^{kBar}h^{aBar}\sigma_i^{-c}.
103                 // We use the AZTEC protocol pairing optimization to reduce the number of pairing comparisons to 1, which adds some minor alterations
104                 for { let i := 0 } lt(i, n) { i := add(i, 0x01) } {
105 
106                     // Get the calldata index of this note
107                     let noteIndex := add(add(notes, 0x20), mul(i, 0xc0))
108 
109                     // Define variables k, a and c.
110                     // If i <= m then
111                     //   k = kBar_i
112                     //   a = aBar_i
113                     //   c = challenge
114                     // If i > m then we add a modification for the pairing optimization
115                     //   k = kBar_i * x_i
116                     //   a = aBar_i * x_i
117                     //   c = challenge * x_i
118                     // Set j = i - (m + 1).
119                     // x_0 = 1
120                     // x_1 = keccak256(input string)
121                     // all other x_{j} = keccak256(x_{j-1})
122                     // The reason for doing this is that the point  \sigma_i^{-cx_j} can be re-used in the pairing check
123                     // Instead of validating e(\gamma_i, t_2) == e(\sigma_i, g_2) for all i = [m+1,\ldots,n]
124                     // We instead validate e(\Pi_{i=m+1}^{n}\gamma_i^{-cx_j}, t_2) == e(\Pi_{i=m+1}^{n}\sigma_i^{cx_j}, g_2).
125                     // x_j is a pseudorandom variable whose entropy source is the input string, allowing for
126                     // a sum of commitment points to be evaluated in one pairing comparison
127                     let k
128                     let a := calldataload(add(noteIndex, 0x20))
129                     let c := challenge
130 
131                     // We don't transmit kBar_{n-1} in the proof to save space, instead we derive it
132                     // As per the homomorphic sum condition: \sum_{i=0}^{m-1}\bar{k}_i = \sum_{i=m}^{n-1}\bar{k}_i + k_{public}c, 
133                     // We can recover \bar{k}_{n-1}.
134                     // If m=n then \bar{k}_{n-1} = \sum_{i=0}^{n-1}\bar{k}_i + k_{public}
135                     // else \bar{k}_{n-1} = \sum_{i=0}^{m-1}\bar{k}_i - \sum_{i=m}^{n-1}\bar{k}_i - k_{public}
136                     switch eq(add(i, 0x01), n)
137                     case 1 {
138                         k := kn
139 
140                         // if all notes are input notes, invert k
141                         if eq(m, n) {
142                             k := sub(gen_order, k)
143                         }
144                     }
145                     case 0 { k := calldataload(noteIndex) }
146 
147                     // Check this commitment is well formed...
148                     validateCommitment(noteIndex, k, a)
149 
150                     // If i > m then this is an output note.
151                     // Set k = kx_j, a = ax_j, c = cx_j, where j = i - (m+1)
152                     switch gt(add(i, 0x01), m)
153                     case 1 {
154 
155                         // before we update k, update kn = \sum_{i=0}^{m-1}k_i - \sum_{i=m}^{n-1}k_i
156                         kn := addmod(kn, sub(gen_order, k), gen_order)
157                         let x := mod(mload(0x00), gen_order)
158                         k := mulmod(k, x, gen_order)
159                         a := mulmod(a, x, gen_order)
160                         c := mulmod(challenge, x, gen_order)
161 
162                         // calculate x_{j+1}
163                         mstore(0x00, keccak256(0x00, 0x20))
164                     }
165                     case 0 {
166 
167                         // nothing to do here except update kn = \sum_{i=0}^{m-1}k_i - \sum_{i=m}^{n-1}k_i
168                         kn := addmod(kn, k, gen_order)
169                     }
170                     
171                     // Calculate the G1 element \gamma_i^{k}h^{a}\sigma_i^{-c} = B_i
172                     // Memory map:
173                     // 0x20: \gamma_iX
174                     // 0x40: \gamma_iY
175                     // 0x60: k_i
176                     // 0x80: hX
177                     // 0xa0: hY
178                     // 0xc0: a_i
179                     // 0xe0: \sigma_iX
180                     // 0x100: \sigma_iY
181                     // 0x120: -c
182                     calldatacopy(0xe0, add(noteIndex, 0x80), 0x40)
183                     calldatacopy(0x20, add(noteIndex, 0x40), 0x40)
184                     mstore(0x120, sub(gen_order, c)) 
185                     mstore(0x60, k)
186                     mstore(0xc0, a)
187 
188                     // Call bn128 scalar multiplication precompiles
189                     // Represent point + multiplication scalar in 3 consecutive blocks of memory
190                     // Store \sigma_i^{-c} at 0x1a0:0x200
191                     // Store \gamma_i^{k} at 0x120:0x160
192                     // Store h^{a} at 0x160:0x1a0
193                     let result := staticcall(gas, 7, 0xe0, 0x60, 0x1a0, 0x40)
194                     result := and(result, staticcall(gas, 7, 0x20, 0x60, 0x120, 0x40))
195                     result := and(result, staticcall(gas, 7, 0x80, 0x60, 0x160, 0x40))
196 
197                     // Call bn128 group addition precompiles
198                     // \gamma_i^{k} and h^{a} in memory block 0x120:0x1a0
199                     // Store result of addition at 0x160:0x1a0
200                     result := and(result, staticcall(gas, 6, 0x120, 0x80, 0x160, 0x40))
201 
202                     // \gamma_i^{k}h^{a} and \sigma^{-c} in memory block 0x160:0x1e0
203                     // Store resulting point B at memory index b
204                     result := and(result, staticcall(gas, 6, 0x160, 0x80, b, 0x40))
205 
206                     // We have \sigma^{-c} at 0x1a0:0x200
207                     // And \sigma_{acc} at 0x1e0:0x200
208                     // If i = m + 1 (i.e. first output note)
209                     // then we set \gamma_{acc} and \sigma_{acc} to \gamma_i, -\sigma_i
210                     if eq(i, m) {
211                         mstore(0x260, mload(0x20))
212                         mstore(0x280, mload(0x40))
213                         mstore(0x1e0, mload(0xe0))
214                         mstore(0x200, sub(0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47, mload(0x100)))
215                     }
216 
217                     // If i > m + 1 (i.e. subsequent output notes)
218                     // then we add \sigma^{-c} and \sigma_{acc} and store result at \sigma_{acc} (0x1e0:0x200)
219                     // we then calculate \gamma^{cx} and add into \gamma_{acc}
220                     if gt(i, m) {
221                        mstore(0x60, c)
222                        result := and(result, staticcall(gas, 7, 0x20, 0x60, 0x220, 0x40))
223 
224                        // \gamma_i^{cx} now at 0x220:0x260, \gamma_{acc} is at 0x260:0x2a0
225                        result := and(result, staticcall(gas, 6, 0x220, 0x80, 0x260, 0x40))
226 
227                        // add \sigma_i^{-cx} and \sigma_{acc} into \sigma_{acc} at 0x1e0
228                        result := and(result, staticcall(gas, 6, 0x1a0, 0x80, 0x1e0, 0x40))
229                     }
230 
231                     // throw transaction if any calls to precompiled contracts failed
232                     if iszero(result) { mstore(0x00, 400) revert(0x00, 0x20) }
233                     b := add(b, 0x40) // increase B pointer by 2 words
234                 }
235 
236                 // If the AZTEC protocol is implemented correctly then any input notes were previously outputs of
237                 // a JoinSplit transaction. We can inductively assume that all input notes are well-formed AZTEC commitments and do not need to validate the implicit range proof
238                 // This is not the case for any output commitments, so if (m < n) call validatePairing()
239                 if lt(m, n) {
240                    validatePairing(0x64)
241                 }
242 
243                 // We now have the note commitments and the calculated blinding factors in a block of memory
244                 // starting at 0x2a0, of size (b - 0x2a0).
245                 // Hash this block to reconstruct the initial challenge and validate that they match
246                 let expected := mod(keccak256(0x2a0, sub(b, 0x2a0)), gen_order)
247                 if iszero(eq(expected, challenge)) {
248 
249                     // No! Bad! No soup for you!
250                     mstore(0x00, 404)
251                     revert(0x00, 0x20)
252                 }
253 
254                 // Great! All done. This is a valid proof so return ```true```
255                 mstore(0x00, 0x01)
256                 return(0x00, 0x20)
257             }
258 
259             /**        
260              * @dev evaluate if e(P1, t2) . e(P2, g2) == 0.
261              * @notice we don't hard-code t2 so that contracts that call this library can use different trusted setups.
262              **/
263             function validatePairing(t2) {
264                 let field_order := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
265                 let t2_x_1 := calldataload(t2)
266                 let t2_x_2 := calldataload(add(t2, 0x20))
267                 let t2_y_1 := calldataload(add(t2, 0x40))
268                 let t2_y_2 := calldataload(add(t2, 0x60))
269 
270                 // check provided setup pubkey is not zero or g2
271                 if or(or(or(or(or(or(or(
272                     iszero(t2_x_1),
273                     iszero(t2_x_2)),
274                     iszero(t2_y_1)),
275                     iszero(t2_y_2)),
276                     eq(t2_x_1, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)),
277                     eq(t2_x_2, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2)),
278                     eq(t2_y_1, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)),
279                     eq(t2_y_2, 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b))
280                 {
281                     mstore(0x00, 400)
282                     revert(0x00, 0x20)
283                 }
284 
285                 // store coords in memory
286                 // indices are a bit off, scipr lab's libff limb ordering (c0, c1) is opposite to what precompile expects
287                 // We can overwrite the memory we used previously as this function is called at the end of the validation routine.
288                 mstore(0x20, mload(0x1e0)) // sigma accumulator x
289                 mstore(0x40, mload(0x200)) // sigma accumulator y
290                 mstore(0x80, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)
291                 mstore(0x60, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2)
292                 mstore(0xc0, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)
293                 mstore(0xa0, 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b)
294                 mstore(0xe0, mload(0x260)) // gamma accumulator x
295                 mstore(0x100, mload(0x280)) // gamma accumulator y
296                 mstore(0x140, t2_x_1)
297                 mstore(0x120, t2_x_2)
298                 mstore(0x180, t2_y_1)
299                 mstore(0x160, t2_y_2)
300 
301                 let success := staticcall(gas, 8, 0x20, 0x180, 0x20, 0x20)
302 
303                 if or(iszero(success), iszero(mload(0x20))) {
304                     mstore(0x00, 400)
305                     revert(0x00, 0x20)
306                 }
307             }
308 
309             /**
310              * @dev check that this note's points are on the altbn128 curve(y^2 = x^3 + 3)
311              * and that signatures 'k' and 'a' are modulo the order of the curve. Transaction will throw if this is not the case.
312              * @param note the calldata loation of the note
313              **/
314             function validateCommitment(note, k, a) {
315                 let gen_order := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
316                 let field_order := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
317                 let gammaX := calldataload(add(note, 0x40))
318                 let gammaY := calldataload(add(note, 0x60))
319                 let sigmaX := calldataload(add(note, 0x80))
320                 let sigmaY := calldataload(add(note, 0xa0))
321                 if iszero(
322                     and(
323                         and(
324                             and(
325                                 eq(mod(a, gen_order), a), // a is modulo generator order?
326                                 gt(a, 1)                  // can't be 0 or 1 either!
327                             ),
328                             and(
329                                 eq(mod(k, gen_order), k), // k is modulo generator order?
330                                 gt(k, 1)                  // and not 0 or 1
331                             )
332                         ),
333                         and(
334                             eq( // y^2 ?= x^3 + 3
335                                 addmod(mulmod(mulmod(sigmaX, sigmaX, field_order), sigmaX, field_order), 3, field_order),
336                                 mulmod(sigmaY, sigmaY, field_order)
337                             ),
338                             eq( // y^2 ?= x^3 + 3
339                                 addmod(mulmod(mulmod(gammaX, gammaX, field_order), gammaX, field_order), 3, field_order),
340                                 mulmod(gammaY, gammaY, field_order)
341                             )
342                         )
343                     )
344                 ) {
345                     mstore(0x00, 400)
346                     revert(0x00, 0x20)
347                 }
348             }
349 
350             /**
351              * @dev Calculate the keccak256 hash of the commitments for both input notes and output notes.
352              * This is used both as an input to validate the challenge `c` and also to generate pseudorandom relationships
353              * between commitments for different outputNotes, so that we can combine them into a single multi-exponentiation for the purposes of validating the bilinear pairing relationships.
354              * @param notes calldata location notes
355              * @param n number of notes
356              **/
357             function hashCommitments(notes, n) {
358                 for { let i := 0 } lt(i, n) { i := add(i, 0x01) } {
359                     let index := add(add(notes, mul(i, 0xc0)), 0x60)
360                     calldatacopy(add(0x300, mul(i, 0x80)), index, 0x80)
361                 }
362                 mstore(0x00, keccak256(0x300, mul(n, 0x80)))
363             }
364         }
365     }
366 }
367 
368 /**
369  * @title ERC20 interface
370  * @dev https://github.com/ethereum/EIPs/issues/20
371  **/
372 contract ERC20Interface {
373   function transfer(address to, uint256 value) external returns (bool);
374 
375   function transferFrom(address from, address to, uint256 value)
376     external returns (bool);
377 }
378 
379 /**
380  * @title  AZTEC token, providing a confidential representation of an ERC20 token 
381  * @author Zachary Williamson, AZTEC
382  * Copyright Spilsbury Holdings Ltd 2018. All rights reserved.
383  * We will be releasing AZTEC as an open-source protocol that provides efficient transaction privacy for Ethereum.
384  * Our full vision of the protocol includes confidential cross-asset interactions via our family of AZTEC zero-knowledge proofs
385  * and the AZTEC token standard, stay tuned for updates!
386  **/
387 contract AZTECERC20Bridge {
388     bytes32[4] setupPubKey;
389     bytes32 domainHash;
390     uint private constant groupModulusBoundary = 10944121435919637611123202872628637544274182200208017171849102093287904247808;
391     uint private constant groupModulus = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
392     uint public scalingFactor;
393     mapping(bytes32 => address) public noteRegistry;
394     ERC20Interface token;
395 
396     event Created(bytes32 domainHash, address contractAddress);
397     event ConfidentialTransfer();
398 
399     /**
400     * @dev contract constructor.
401     * @param _setupPubKey the trusted setup public key (group element of group G2)
402     * @param _token the address of the ERC20 token being attached to
403     * @param _scalingFactor the mapping from note value -> ERC20 token value.
404     * AZTEC notes have a range between 0 and 2^{25}-1 and ERC20 tokens range between 0 and 2^{255} - 1
405     * so we don't want to directly map note value : token value
406     **/
407     constructor(bytes32[4] _setupPubKey, address _token, uint256 _scalingFactor, uint256 _chainId) public {
408         setupPubKey = _setupPubKey;
409         token = ERC20Interface(_token);
410         scalingFactor = _scalingFactor;
411         bytes32 _domainHash;
412         assembly {
413             let m := mload(0x40)
414             mstore(m, 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f) // "EIP712Domain(string name, string version, uint256 chainId, address verifyingContract)"
415             mstore(add(m, 0x20), 0x60d177492a60de7c666b3e3d468f14d59def1d4b022d08b6adf554d88da60d63) // name = "AZTECERC20BRIDGE_DOMAIN"
416             mstore(add(m, 0x40), 0x28a43689b8932fb9695c28766648ed3d943ff8a6406f8f593738feed70039290) // version = "0.1.1"
417             mstore(add(m, 0x60), _chainId) // chain id
418             mstore(add(m, 0x80), address) // verifying contract
419             _domainHash := keccak256(m, 0xa0)
420         }
421         domainHash = _domainHash;
422         emit Created(_domainHash, this);
423     }
424 
425     /**
426     * @dev Determine validity of an input note and remove from note registry
427     * 1. validate that the note is signed by the note owner
428     * 2. validate that the note exists in the note registry
429     *
430     * Note signature is EIP712 signature (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md) over the following struct
431     * struct AZTEC_NOTE_SIGNATURE {
432     *     bytes32[4] note;
433     *     uint256 challenge;
434     *     address sender;    
435     * };
436     * @param note AZTEC confidential note being destroyed
437     * @param signature ECDSA signature from note owner
438     * @param challenge AZTEC zero-knowledge proof challenge
439     * @param domainHashT Temporary holding ```domainHash``` (to minimize # of sload ops)
440     **/
441     function validateInputNote(bytes32[6] note, bytes32[3] signature, uint challenge, bytes32 domainHashT) internal {
442         bytes32 noteHash;
443         bytes32 signatureMessage;
444         assembly {
445             let m := mload(0x40)
446             mstore(m, mload(add(note, 0x40)))
447             mstore(add(m, 0x20), mload(add(note, 0x60)))
448             mstore(add(m, 0x40), mload(add(note, 0x80)))
449             mstore(add(m, 0x60), mload(add(note, 0xa0)))
450             noteHash := keccak256(m, 0x80)
451             mstore(m, 0x0f1ea84c0ceb3ad2f38123d94a164612e1a0c14a694dc5bfa16bc86ea1f3eabd) // keccak256 hash of "AZTEC_NOTE_SIGNATURE(bytes32[4] note,uint256 challenge,address sender)"
452             mstore(add(m, 0x20), noteHash)
453             mstore(add(m, 0x40), challenge)
454             mstore(add(m, 0x60), caller)
455             mstore(add(m, 0x40), keccak256(m, 0x80))
456             mstore(add(m, 0x20), domainHashT)
457             mstore(m, 0x1901)
458             signatureMessage := keccak256(add(m, 0x1e), 0x42)
459         }
460         address owner = ecrecover(signatureMessage, uint8(signature[0]), signature[1], signature[2]);
461         require(owner != address(0), "signature invalid");
462         require(noteRegistry[noteHash] == owner, "expected input note to exist in registry");
463         noteRegistry[noteHash] = 0;
464     }
465 
466     /**
467     * @dev Validate an output note from an AZTEC confidential transaction
468     * If the note does not already exist in ```noteRegistry```, create it
469     * @param note AZTEC confidential note to be created
470     * @param owner The address of the note owner
471     **/
472     function validateOutputNote(bytes32[6] note, address owner) internal {
473         bytes32 noteHash; // Construct a keccak256 hash of the note coordinates.
474         assembly {
475             let m := mload(0x40)
476             mstore(m, mload(add(note, 0x40)))
477             mstore(add(m, 0x20), mload(add(note, 0x60)))
478             mstore(add(m, 0x40), mload(add(note, 0x80)))
479             mstore(add(m, 0x60), mload(add(note, 0xa0)))
480             noteHash := keccak256(m, 0x80)
481         }
482         require(owner != address(0), "owner must be valid Ethereum address");
483         require(noteRegistry[noteHash] == 0, "expected output note to not exist in registry");
484         noteRegistry[noteHash] = owner;
485     }
486 
487     /**
488     * @dev Perform a confidential transaction. Takes ```m``` input notes and ```notes.length - m``` output notes.
489     * ```notes, m, challenge``` constitute an AZTEC zero-knowledge proof that states the following:
490     * The sum of the values of the input notes is equal to a the sum of the values of the output notes + a public commitment value ```kPublic```
491     * \sum_{i=0}^{m-1}k_i = \sum_{i=m}^{n-1}k_i + k_{public} (mod p)
492     * notes[6][] contains value ```kPublic```  at notes[notes.length - 1][0].
493     * If ```kPublic``` is negative, this represents ```(GROUP_MODULUS - kPublic) * SCALING_FACTOR``` ERC20 tokens being converted into confidential note form.
494     * If ```kPublic``` is positive, this represents ```kPublic * SCALING_FACTOR``` worth of AZTEC notes being converted into ERC20 form
495     * @param notes defines AZTEC input notes and output notes. notes[0,...,m-1] = input notes. notes[m,...,notes.length-1] = output notes
496     * @param m where notes[0,..., m - 1] = input notes. notes[m,...,notes.length - 1] = output notes
497     * @param challenge AZTEC zero-knowledge proof challenge variable
498     * @param inputSignatures array of ECDSA signatures, one for each input note
499     * @param outputOwners addresses of owners, one for each output note
500     * Unnamed param is metadata: if AZTEC notes are assigned to stealth addresses, metadata should contain the ephemeral keys required for note owner to identify their note
501     */
502     function confidentialTransfer(bytes32[6][] notes, uint256 m, uint256 challenge, bytes32[3][] inputSignatures, address[] outputOwners, bytes) external {
503         require(inputSignatures.length == m, "input signature length invalid");
504         require(inputSignatures.length + outputOwners.length == notes.length, "array length mismatch");
505 
506         // validate AZTEC zero-knowledge proof
507         require(AZTECInterface.validateJoinSplit(notes, m, challenge, setupPubKey), "proof not valid!");
508 
509         // extract variable kPublic from proof
510         uint256 kPublic = uint(notes[notes.length - 1][0]);
511         require(kPublic < groupModulus, "invalid value of kPublic");
512 
513         // iterate over the notes array and validate each input/output note
514         for (uint256 i = 0; i < notes.length; i++) {
515 
516             // if i < m this is an input note
517             if (i < m) {
518 
519                 // call validateInputNote to check that the note exists and that we have a matching signature over the note.
520                 // pass domainHash in as a function parameter to prevent multiple sloads
521                 // this will remove the input notes from noteRegistry
522                 validateInputNote(notes[i], inputSignatures[i], challenge, domainHash);
523             } else {
524 
525                 // if i >= m this is an output note
526                 // validate that output notes, attached to the specified owners do not exist in noteRegistry.
527                 // if all checks pass, add notes into note registry
528                 validateOutputNote(notes[i], outputOwners[i - m]);
529             }
530         }
531 
532         if (kPublic > 0) {
533             if (kPublic < groupModulusBoundary) {
534 
535                 // if value < the group modulus boundary then this public value represents a conversion from confidential note form to public form
536                 // call token.transfer to send relevent tokens
537                 require(token.transfer(msg.sender, kPublic * scalingFactor), "token transfer to user failed!");
538             } else {
539 
540                 // if value > group modulus boundary, this represents a commitment of a public value into confidential note form.
541                 // only proceed if the required transferFrom call from msg.sender to this contract succeeds
542                 require(token.transferFrom(msg.sender, this, (groupModulus - kPublic) * scalingFactor), "token transfer from user failed!");
543             }
544         }
545 
546         // emit an event to mark this transaction. Can recover notes + metadata from input data
547         emit ConfidentialTransfer();
548     }
549 }