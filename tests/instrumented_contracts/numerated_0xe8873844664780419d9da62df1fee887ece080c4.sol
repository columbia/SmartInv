1 pragma solidity ^0.5.0;
2 
3 
4 library Pairing {
5     struct G1Point {
6         uint X;
7         uint Y;
8     }
9 
10     // Encoding of field elements is: X[0] * z + X[1]
11     struct G2Point {
12         uint[2] X;
13         uint[2] Y;
14     }
15 
16     /// @return the generator of G1
17     function P1()
18         internal pure returns (G1Point memory)
19     {
20         return G1Point(1, 2);
21     }
22 
23     /// @return the generator of G2
24     function P2() internal pure returns (G2Point memory) {
25         return G2Point(
26             [11559732032986387107991004021392285783925812861821192530917403151452391805634,
27              10857046999023057135944570762232829481370756359578518086990519993285655852781],
28             [4082367875863433681332203403145435568316851327593401208105741076214120093531,
29              8495653923123431417604973247489272438418190587263600148770280649306958101930]
30         );
31     }
32 
33     /// @return the negation of p, i.e. p.add(p.negate()) should be zero.
34     function negate(G1Point memory p) internal pure returns (G1Point memory) {
35         // The prime q in the base field F_q for G1
36         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
37         if (p.X == 0 && p.Y == 0)
38             return G1Point(0, 0);
39         return G1Point(p.X, q - (p.Y % q));
40     }
41 
42     /// @return the sum of two points of G1
43     function pointAdd(G1Point memory p1, G1Point memory p2)
44         internal view returns (G1Point memory r)
45     {
46         uint[4] memory input;
47         input[0] = p1.X;
48         input[1] = p1.Y;
49         input[2] = p2.X;
50         input[3] = p2.Y;
51         bool success;
52         assembly {
53             success := staticcall(sub(gas, 2000), 6, input, 0xc0, r, 0x60)
54         }
55         require(success);
56     }
57 
58     /// @return the product of a point on G1 and a scalar, i.e.
59     /// p == p.mul(1) and p.add(p) == p.mul(2) for all points p.
60     function pointMul(G1Point memory p, uint s)
61         internal view returns (G1Point memory r)
62     {
63         uint[3] memory input;
64         input[0] = p.X;
65         input[1] = p.Y;
66         input[2] = s;
67         bool success;
68         assembly {
69             success := staticcall(sub(gas, 2000), 7, input, 0x80, r, 0x60)
70         }
71         require (success);
72     }
73 
74     /// @return the result of computing the pairing check
75     /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
76     /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
77     /// return true.
78     function pairing(G1Point[] memory p1, G2Point[] memory p2)
79         internal view returns (bool)
80     {
81         require(p1.length == p2.length);
82         uint elements = p1.length;
83         uint inputSize = elements * 6;
84         uint[] memory input = new uint[](inputSize);
85         for (uint i = 0; i < elements; i++)
86         {
87             input[i * 6 + 0] = p1[i].X;
88             input[i * 6 + 1] = p1[i].Y;
89             input[i * 6 + 2] = p2[i].X[0];
90             input[i * 6 + 3] = p2[i].X[1];
91             input[i * 6 + 4] = p2[i].Y[0];
92             input[i * 6 + 5] = p2[i].Y[1];
93         }
94         uint[1] memory out;
95         bool success;
96         assembly {
97             success := staticcall(sub(gas, 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
98         }
99         require(success);
100         return out[0] != 0;
101     }
102 
103     /// Convenience method for a pairing check for two pairs.
104     function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2)
105         internal view returns (bool)
106     {
107         G1Point[] memory p1 = new G1Point[](2);
108         G2Point[] memory p2 = new G2Point[](2);
109         p1[0] = a1;
110         p1[1] = b1;
111         p2[0] = a2;
112         p2[1] = b2;
113         return pairing(p1, p2);
114     }
115     /// Convenience method for a pairing check for three pairs.
116     function pairingProd3(
117             G1Point memory a1, G2Point memory a2,
118             G1Point memory b1, G2Point memory b2,
119             G1Point memory c1, G2Point memory c2
120     )
121         internal view returns (bool)
122     {
123         G1Point[] memory p1 = new G1Point[](3);
124         G2Point[] memory p2 = new G2Point[](3);
125         p1[0] = a1;
126         p1[1] = b1;
127         p1[2] = c1;
128         p2[0] = a2;
129         p2[1] = b2;
130         p2[2] = c2;
131         return pairing(p1, p2);
132     }
133 
134     /// Convenience method for a pairing check for four pairs.
135     function pairingProd4(
136             G1Point memory a1, G2Point memory a2,
137             G1Point memory b1, G2Point memory b2,
138             G1Point memory c1, G2Point memory c2,
139             G1Point memory d1, G2Point memory d2
140     )
141         internal view returns (bool)
142     {
143         G1Point[] memory p1 = new G1Point[](4);
144         G2Point[] memory p2 = new G2Point[](4);
145         p1[0] = a1;
146         p1[1] = b1;
147         p1[2] = c1;
148         p1[3] = d1;
149         p2[0] = a2;
150         p2[1] = b2;
151         p2[2] = c2;
152         p2[3] = d2;
153         return pairing(p1, p2);
154     }
155 }
156 
157 
158 library Verifier
159 {
160     using Pairing for Pairing.G1Point;
161     using Pairing for Pairing.G2Point;
162 
163     function scalarField ()
164         internal pure returns (uint256)
165     {
166         return 21888242871839275222246405745257275088548364400416034343698204186575808495617;
167     }
168 
169     struct VerifyingKey
170     {
171         Pairing.G1Point alpha;
172         Pairing.G2Point beta;
173         Pairing.G2Point gamma;
174         Pairing.G2Point delta;
175         Pairing.G1Point[] gammaABC;
176     }
177 
178     struct Proof
179     {
180         Pairing.G1Point A;
181         Pairing.G2Point B;
182         Pairing.G1Point C;
183     }
184 
185     struct ProofWithInput
186     {
187         Proof proof;
188         uint256[] input;
189     }
190 
191 
192     function negateY( uint256 Y )
193         internal 
194         pure 
195         returns (uint256)
196     {
197         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
198         return q - (Y % q);
199     }
200 
201 
202     /*
203     * This implements the Solidity equivalent of the following Python code:
204 
205         from py_ecc.bn128 import *
206 
207         data = # ... arguments to function [in_vk, vk_gammaABC, in_proof, proof_inputs]
208 
209         vk = [int(_, 16) for _ in data[0]]
210         ic = [FQ(int(_, 16)) for _ in data[1]]
211         proof = [int(_, 16) for _ in data[2]]
212         inputs = [int(_, 16) for _ in data[3]]
213 
214         it = iter(ic)
215         ic = [(_, next(it)) for _ in it]
216         vk_alpha = [FQ(_) for _ in vk[:2]]
217         vk_beta = (FQ2(vk[2:4][::-1]), FQ2(vk[4:6][::-1]))
218         vk_gamma = (FQ2(vk[6:8][::-1]), FQ2(vk[8:10][::-1]))
219         vk_delta = (FQ2(vk[10:12][::-1]), FQ2(vk[12:14][::-1]))
220 
221         assert is_on_curve(vk_alpha, b)
222         assert is_on_curve(vk_beta, b2)
223         assert is_on_curve(vk_gamma, b2)
224         assert is_on_curve(vk_delta, b2)
225 
226         proof_A = [FQ(_) for _ in proof[:2]]
227         proof_B = (FQ2(proof[2:4][::-1]), FQ2(proof[4:-2][::-1]))
228         proof_C = [FQ(_) for _ in proof[-2:]]
229 
230         assert is_on_curve(proof_A, b)
231         assert is_on_curve(proof_B, b2)
232         assert is_on_curve(proof_C, b)
233 
234         vk_x = ic[0]
235         for i, s in enumerate(inputs):
236             vk_x = add(vk_x, multiply(ic[i + 1], s))
237 
238         check_1 = pairing(proof_B, proof_A)
239         check_2 = pairing(vk_beta, neg(vk_alpha))
240         check_3 = pairing(vk_gamma, neg(vk_x))
241         check_4 = pairing(vk_delta, neg(proof_C))
242 
243         ok = check_1 * check_2 * check_3 * check_4
244         assert ok == FQ12.one()
245     */
246     function verify (uint256[14] memory in_vk, uint256[] memory vk_gammaABC, uint256[8] memory in_proof, uint256[] memory proof_inputs)
247         internal 
248         view 
249         returns (bool)
250     {
251         require( ((vk_gammaABC.length / 2) - 1) == proof_inputs.length );
252         
253         // Compute the linear combination vk_x
254         uint256[3] memory mul_input;
255         uint256[4] memory add_input;
256         bool success;
257         uint m = 2;
258 
259         // First two fields are used as the sum
260         add_input[0] = vk_gammaABC[0];
261         add_input[1] = vk_gammaABC[1];
262 
263         // Performs a sum of gammaABC[0] + sum[ gammaABC[i+1]^proof_inputs[i] ]
264         for (uint i = 0; i < proof_inputs.length; i++) {
265             mul_input[0] = vk_gammaABC[m++];
266             mul_input[1] = vk_gammaABC[m++];
267             mul_input[2] = proof_inputs[i];
268 
269             assembly {
270                 // ECMUL, output to last 2 elements of `add_input`
271                 success := staticcall(sub(gas, 2000), 7, mul_input, 0x80, add(add_input, 0x40), 0x60)
272             }
273             require(success);
274             
275             assembly {
276                 // ECADD
277                 success := staticcall(sub(gas, 2000), 6, add_input, 0xc0, add_input, 0x60)
278             }
279             require(success);
280         }
281         
282         uint[24] memory input = [
283             // (proof.A, proof.B)
284             in_proof[0], in_proof[1],                           // proof.A   (G1)
285             in_proof[2], in_proof[3], in_proof[4], in_proof[5], // proof.B   (G2)
286 
287             // (-vk.alpha, vk.beta)
288             in_vk[0], negateY(in_vk[1]),                        // -vk.alpha (G1)
289             in_vk[2], in_vk[3], in_vk[4], in_vk[5],             // vk.beta   (G2)
290 
291             // (-vk_x, vk.gamma)
292             add_input[0], negateY(add_input[1]),                // -vk_x     (G1)
293             in_vk[6], in_vk[7], in_vk[8], in_vk[9],             // vk.gamma  (G2)
294 
295             // (-proof.C, vk.delta)
296             in_proof[6], negateY(in_proof[7]),                  // -proof.C  (G1)
297             in_vk[10], in_vk[11], in_vk[12], in_vk[13]          // vk.delta  (G2)
298         ];
299 
300         uint[1] memory out;
301         assembly {
302             success := staticcall(sub(gas, 2000), 8, input, 768, out, 0x20)
303         }
304         require(success);
305         return out[0] != 0;
306     }
307 
308 
309     function verify(VerifyingKey memory vk, ProofWithInput memory pwi)
310         internal 
311         view 
312         returns (bool)
313     {
314         return verify(vk, pwi.proof, pwi.input);
315     }
316 
317 
318     function verify(VerifyingKey memory vk, Proof memory proof, uint256[] memory input)
319         internal 
320         view 
321         returns (bool)
322     {
323         require(input.length + 1 == vk.gammaABC.length);
324 
325         // Compute the linear combination vk_x
326         Pairing.G1Point memory vk_x = vk.gammaABC[0];
327         for (uint i = 0; i < input.length; i++)
328             vk_x = Pairing.pointAdd(vk_x, Pairing.pointMul(vk.gammaABC[i + 1], input[i]));
329 
330         // Verify proof
331         return Pairing.pairingProd4(
332             proof.A, proof.B,
333             vk_x.negate(), vk.gamma,
334             proof.C.negate(), vk.delta,
335             vk.alpha.negate(), vk.beta);
336     }
337 }
338 
339 library MiMC
340 {
341     function getScalarField ()
342         internal pure returns (uint256)
343     {
344         return 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
345     }
346 
347     /**
348     * MiMC-p/p with exponent of 7
349     * 
350     * Recommended at least 46 rounds, for a polynomial degree of 2^126
351     */
352     function MiMCpe7( uint256 in_x, uint256 in_k, uint256 in_seed, uint256 round_count )
353         internal pure returns(uint256 out_x)
354     {
355         assembly {
356             if lt(round_count, 1) { revert(0, 0) }
357 
358             // Initialise round constants, k will be hashed
359             let c := mload(0x40)
360             mstore(0x40, add(c, 32))
361             mstore(c, in_seed)
362 
363             let localQ := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
364             let t
365             let a
366 
367             // Further n-2 subsequent rounds include a round constant
368             for { let i := round_count } gt(i, 0) { i := sub(i, 1) } {
369                 // c = H(c)
370                 mstore(c, keccak256(c, 32))
371 
372                 // x = pow(x + c_i, 7, p) + k
373                 t := addmod(addmod(in_x, mload(c), localQ), in_k, localQ)              // t = x + c_i + k
374                 a := mulmod(t, t, localQ)                                              // t^2
375                 in_x := mulmod(mulmod(a, mulmod(a, a, localQ), localQ), t, localQ)     // t^7
376             }
377 
378             // Result adds key again as blinding factor
379             out_x := addmod(in_x, in_k, localQ)
380         }
381     }
382        
383     function MiMCpe7_mp( uint256[] memory in_x, uint256 in_k, uint256 in_seed, uint256 round_count )
384         internal pure returns (uint256)
385     {
386         uint256 r = in_k;
387         uint256 localQ = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
388 
389         for( uint256 i = 0; i < in_x.length; i++ )
390         {
391             r = (r + in_x[i] + MiMCpe7(in_x[i], r, in_seed, round_count)) % localQ;
392         }
393 
394         return r;
395     }
396 
397     function Hash( uint256[] memory in_msgs, uint256 in_key )
398         internal pure returns (uint256)
399     {
400         return MiMCpe7_mp(in_msgs, in_key, uint256(keccak256("mimc")), 91);
401     }
402 
403     function Hash( uint256[] memory in_msgs )
404         internal pure returns (uint256)
405     {
406         return Hash(in_msgs, 0);
407     }
408 }
409 
410 library MerkleTree
411 {
412     // ceil(log2(1<<15))
413     uint constant internal TREE_DEPTH = 15;
414 
415 
416     // 1<<15 leaves
417     uint constant internal MAX_LEAF_COUNT = 32768;
418 
419 
420     struct Data
421     {
422         uint cur;
423         uint256[32768][16] nodes; // first column = leaves, second column = leaves' parents, etc
424     }
425 
426     function treeDepth() internal pure returns (uint256) {
427         return TREE_DEPTH;
428     }
429 
430 
431     function fillLevelIVs (uint256[15] memory IVs)
432         internal
433         pure
434     {
435         IVs[0] = 149674538925118052205057075966660054952481571156186698930522557832224430770;
436         IVs[1] = 9670701465464311903249220692483401938888498641874948577387207195814981706974;
437         IVs[2] = 18318710344500308168304415114839554107298291987930233567781901093928276468271;
438         IVs[3] = 6597209388525824933845812104623007130464197923269180086306970975123437805179;
439         IVs[4] = 21720956803147356712695575768577036859892220417043839172295094119877855004262;
440         IVs[5] = 10330261616520855230513677034606076056972336573153777401182178891807369896722;
441         IVs[6] = 17466547730316258748333298168566143799241073466140136663575045164199607937939;
442         IVs[7] = 18881017304615283094648494495339883533502299318365959655029893746755475886610;
443         IVs[8] = 21580915712563378725413940003372103925756594604076607277692074507345076595494;
444         IVs[9] = 12316305934357579015754723412431647910012873427291630993042374701002287130550;
445         IVs[10] = 18905410889238873726515380969411495891004493295170115920825550288019118582494;
446         IVs[11] = 12819107342879320352602391015489840916114959026915005817918724958237245903353;
447         IVs[12] = 8245796392944118634696709403074300923517437202166861682117022548371601758802;
448         IVs[13] = 16953062784314687781686527153155644849196472783922227794465158787843281909585;
449         IVs[14] = 19346880451250915556764413197424554385509847473349107460608536657852472800734;
450     }
451 
452 
453     function hashImpl (uint256 left, uint256 right, uint256 IV)
454         internal
455         pure
456         returns (uint256)
457     {
458         uint256[] memory x = new uint256[](2);
459         x[0] = left;
460         x[1] = right;
461 
462         return MiMC.Hash(x, IV);
463     }
464 
465 
466     function insert(Data storage self, uint256 leaf)
467         internal
468         returns (uint256 new_root, uint256 offset)
469     {
470         require(leaf != 0);
471 
472 
473         uint256[15] memory IVs;
474         fillLevelIVs(IVs);
475 
476         offset = self.cur;
477 
478         require(offset != MAX_LEAF_COUNT - 1);
479 
480         self.nodes[0][offset] = leaf;
481 
482         new_root = updateTree(self, IVs);
483 
484         self.cur = offset + 1;
485     }
486 
487 
488     /**
489     * Returns calculated merkle root
490     */
491     function verifyPath(uint256 leaf, uint256[15] memory in_path, bool[15] memory address_bits)
492         internal 
493         pure 
494         returns (uint256 merkleRoot)
495     {
496         uint256[15] memory IVs;
497         fillLevelIVs(IVs);
498 
499         merkleRoot = leaf;
500 
501         for (uint depth = 0; depth < TREE_DEPTH; depth++) {
502             if (address_bits[depth]) {
503                 merkleRoot = hashImpl(in_path[depth], merkleRoot, IVs[depth]);
504             } else {
505                 merkleRoot = hashImpl(merkleRoot, in_path[depth], IVs[depth]);
506             }
507         }
508     }
509 
510 
511     function verifyPath(Data storage self, uint256 leaf, uint256[15] memory in_path, bool[15] memory address_bits)
512         internal 
513         view 
514         returns (bool)
515     {
516         return verifyPath(leaf, in_path, address_bits) == getRoot(self);
517     }
518 
519 
520     function getLeaf(Data storage self, uint depth, uint offset)
521         internal
522         view
523         returns (uint256)
524     {
525         return getUniqueLeaf(depth, offset, self.nodes[depth][offset]);
526     }
527 
528 
529     function getMerkleProof(Data storage self, uint index)
530         internal
531         view
532         returns (uint256[15] memory proof_path)
533     {
534         for (uint depth = 0; depth < TREE_DEPTH; depth++)
535         {
536             if (index % 2 == 0) {
537                 proof_path[depth] = getLeaf(self, depth, index + 1);
538             } else {
539                 proof_path[depth] = getLeaf(self, depth, index - 1);
540             }
541             index = uint(index / 2);
542         }
543     }
544 
545 
546     function getUniqueLeaf(uint256 depth, uint256 offset, uint256 leaf)
547         internal pure returns (uint256)
548     {
549         if (leaf == 0x0)
550         {
551             leaf = uint256(
552                 sha256(
553                     abi.encodePacked(
554                         uint16(depth),
555                         uint240(offset)))) % MiMC.getScalarField();
556         }
557 
558         return leaf;
559     }
560 
561 
562     function updateTree(Data storage self, uint256[15] memory IVs)
563         internal returns(uint256 root)
564     {
565         uint currentIndex = self.cur;
566         uint256 leaf1;
567         uint256 leaf2;
568 
569         for (uint depth = 0; depth < TREE_DEPTH; depth++)
570         {
571 
572             if (currentIndex%2 == 0)
573             {
574                 leaf1 = self.nodes[depth][currentIndex];
575 
576                 leaf2 = getUniqueLeaf(depth, currentIndex + 1, self.nodes[depth][currentIndex + 1]);
577             } else
578             {
579                 leaf1 = getUniqueLeaf(depth, currentIndex - 1, self.nodes[depth][currentIndex - 1]);
580 
581                 leaf2 = self.nodes[depth][currentIndex];
582             }
583 
584             uint nextIndex = uint(currentIndex/2);
585 
586             self.nodes[depth+1][nextIndex] = hashImpl(leaf1, leaf2, IVs[depth]);
587 
588             currentIndex = nextIndex;
589         }
590 
591         return self.nodes[TREE_DEPTH][0];
592     }
593 
594 
595     function getRoot (Data storage self)
596         internal
597         view
598         returns (uint256)
599     {
600         return self.nodes[TREE_DEPTH][0];
601     }
602 
603     function getNextLeafIndex (Data storage self)
604         internal
605         view
606         returns (uint256)
607     {
608         return self.cur;
609     }
610 }
611 
612 contract Mixer
613 {
614     using MerkleTree for MerkleTree.Data;
615 
616     uint constant public AMOUNT = 1 ether;
617 
618     uint256[14] vk;
619     uint256[] gammaABC;
620 
621     mapping (uint256 => bool) public nullifiers;
622     mapping (address => uint256[]) public pendingDeposits;
623 
624     MerkleTree.Data internal tree;
625 
626     event CommitmentAdded(address indexed _fundingWallet, uint256 _leaf);
627     event LeafAdded(uint256 _leaf, uint256 _leafIndex);
628 
629     constructor(uint256[14] memory in_vk, uint256[] memory in_gammaABC)
630         public
631     {
632         vk = in_vk;
633         gammaABC = in_gammaABC;
634     }
635 
636     function getRoot()
637         public
638         view
639         returns (uint256)
640     {
641         return tree.getRoot();
642     }
643 
644     /**
645     * Save a commitment (leaf) that needs to be funded later on
646     */
647     function commit(uint256 leaf, address fundingWallet)
648         public
649         payable
650     {
651         require(leaf > 0, "null leaf");
652         pendingDeposits[fundingWallet].push(leaf);
653         emit CommitmentAdded(fundingWallet, leaf);
654         if (msg.value > 0) fundCommitment();
655     }
656 
657     function fundCommitment() private {
658         require(msg.value == AMOUNT, "wrong value");
659         uint256[] storage leaves = pendingDeposits[msg.sender];
660         require(leaves.length > 0, "commitment must be sent first");
661         uint256 leaf = leaves[leaves.length - 1];
662         leaves.length--;
663         (, uint256 leafIndex) = tree.insert(leaf);
664         emit LeafAdded(leaf, leafIndex);
665     }
666 
667     /*
668     * Used by the funding wallet to fund a previously saved commitment
669     */
670     function () external payable {
671         fundCommitment();
672     }
673 
674     // should not be used in production otherwise nullifier_secret would be shared with the node!
675     function makeLeafHash(uint256 nullifier_secret, address wallet_address)
676         external
677         pure
678         returns (uint256)
679     {
680         bytes32 digest = sha256(abi.encodePacked(nullifier_secret, uint256(wallet_address)));
681         uint256 mask = uint256(-1) >> 4; // clear the first 4 bits to make sure we stay within the prime field
682         return uint256(digest) & mask;
683     }
684 
685     // should not be used in production otherwise nullifier_secret would be shared with the node!
686     function makeNullifierHash(uint256 nullifier_secret)
687         external
688         pure
689         returns (uint256)
690     {
691         uint256[] memory vals = new uint256[](2);
692         vals[0] = nullifier_secret;
693         vals[1] = nullifier_secret;
694         return MiMC.Hash(vals, 0);
695     }
696 
697     function getMerklePath(uint256 leafIndex)
698         external
699         view
700         returns (uint256[15] memory out_path)
701     {
702         out_path = tree.getMerkleProof(leafIndex);
703     }
704 
705     function isSpent(uint256 nullifier)
706         public
707         view
708         returns (bool)
709     {
710         return nullifiers[nullifier];
711     }
712 
713     function verifyProof(uint256 in_root, address in_wallet_address, uint256 in_nullifier, uint256[8] memory proof)
714         public
715         view
716         returns (bool)
717     {
718         uint256[] memory snark_input = new uint256[](3);
719         snark_input[0] = in_root;
720         snark_input[1] = uint256(in_wallet_address);
721         snark_input[2] = in_nullifier;
722 
723         return Verifier.verify(vk, gammaABC, proof, snark_input);
724     }
725 
726     function withdraw(
727         address payable in_withdraw_address,
728         uint256 in_nullifier,
729         uint256[8] memory proof
730     )
731         public
732     {
733         uint startGas = gasleft();
734         require(!nullifiers[in_nullifier], "Nullifier used");
735         require(verifyProof(getRoot(), in_withdraw_address, in_nullifier, proof), "Proof verification failed");
736 
737         nullifiers[in_nullifier] = true;
738 
739         uint gasUsed = startGas - gasleft() + 82775;
740         in_withdraw_address.transfer(AMOUNT - gasUsed * tx.gasprice); // leaf withdrawal
741         msg.sender.transfer(gasUsed * tx.gasprice); // relayer refund
742     }
743 
744     function treeDepth() external pure returns (uint256) {
745         return MerkleTree.treeDepth();
746     }
747 
748     function getNextLeafIndex() external view returns (uint256) {
749         return tree.getNextLeafIndex();
750     }
751 }