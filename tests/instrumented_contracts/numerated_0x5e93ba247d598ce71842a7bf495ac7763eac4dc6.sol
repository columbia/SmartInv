1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-12
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 
8 library Pairing {
9     struct G1Point {
10         uint X;
11         uint Y;
12     }
13 
14     // Encoding of field elements is: X[0] * z + X[1]
15     struct G2Point {
16         uint[2] X;
17         uint[2] Y;
18     }
19 
20     /// @return the generator of G1
21     function P1()
22         internal pure returns (G1Point memory)
23     {
24         return G1Point(1, 2);
25     }
26 
27     /// @return the generator of G2
28     function P2() internal pure returns (G2Point memory) {
29         return G2Point(
30             [11559732032986387107991004021392285783925812861821192530917403151452391805634,
31              10857046999023057135944570762232829481370756359578518086990519993285655852781],
32             [4082367875863433681332203403145435568316851327593401208105741076214120093531,
33              8495653923123431417604973247489272438418190587263600148770280649306958101930]
34         );
35     }
36 
37     /// @return the negation of p, i.e. p.add(p.negate()) should be zero.
38     function negate(G1Point memory p) internal pure returns (G1Point memory) {
39         // The prime q in the base field F_q for G1
40         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
41         if (p.X == 0 && p.Y == 0)
42             return G1Point(0, 0);
43         return G1Point(p.X, q - (p.Y % q));
44     }
45 
46     /// @return the sum of two points of G1
47     function pointAdd(G1Point memory p1, G1Point memory p2)
48         internal view returns (G1Point memory r)
49     {
50         uint[4] memory input;
51         input[0] = p1.X;
52         input[1] = p1.Y;
53         input[2] = p2.X;
54         input[3] = p2.Y;
55         bool success;
56         assembly {
57             success := staticcall(sub(gas, 2000), 6, input, 0xc0, r, 0x60)
58         }
59         require(success);
60     }
61 
62     /// @return the product of a point on G1 and a scalar, i.e.
63     /// p == p.mul(1) and p.add(p) == p.mul(2) for all points p.
64     function pointMul(G1Point memory p, uint s)
65         internal view returns (G1Point memory r)
66     {
67         uint[3] memory input;
68         input[0] = p.X;
69         input[1] = p.Y;
70         input[2] = s;
71         bool success;
72         assembly {
73             success := staticcall(sub(gas, 2000), 7, input, 0x80, r, 0x60)
74         }
75         require (success);
76     }
77 
78     /// @return the result of computing the pairing check
79     /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
80     /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
81     /// return true.
82     function pairing(G1Point[] memory p1, G2Point[] memory p2)
83         internal view returns (bool)
84     {
85         require(p1.length == p2.length);
86         uint elements = p1.length;
87         uint inputSize = elements * 6;
88         uint[] memory input = new uint[](inputSize);
89         for (uint i = 0; i < elements; i++)
90         {
91             input[i * 6 + 0] = p1[i].X;
92             input[i * 6 + 1] = p1[i].Y;
93             input[i * 6 + 2] = p2[i].X[0];
94             input[i * 6 + 3] = p2[i].X[1];
95             input[i * 6 + 4] = p2[i].Y[0];
96             input[i * 6 + 5] = p2[i].Y[1];
97         }
98         uint[1] memory out;
99         bool success;
100         assembly {
101             success := staticcall(sub(gas, 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
102         }
103         require(success);
104         return out[0] != 0;
105     }
106 
107     /// Convenience method for a pairing check for two pairs.
108     function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2)
109         internal view returns (bool)
110     {
111         G1Point[] memory p1 = new G1Point[](2);
112         G2Point[] memory p2 = new G2Point[](2);
113         p1[0] = a1;
114         p1[1] = b1;
115         p2[0] = a2;
116         p2[1] = b2;
117         return pairing(p1, p2);
118     }
119     /// Convenience method for a pairing check for three pairs.
120     function pairingProd3(
121             G1Point memory a1, G2Point memory a2,
122             G1Point memory b1, G2Point memory b2,
123             G1Point memory c1, G2Point memory c2
124     )
125         internal view returns (bool)
126     {
127         G1Point[] memory p1 = new G1Point[](3);
128         G2Point[] memory p2 = new G2Point[](3);
129         p1[0] = a1;
130         p1[1] = b1;
131         p1[2] = c1;
132         p2[0] = a2;
133         p2[1] = b2;
134         p2[2] = c2;
135         return pairing(p1, p2);
136     }
137 
138     /// Convenience method for a pairing check for four pairs.
139     function pairingProd4(
140             G1Point memory a1, G2Point memory a2,
141             G1Point memory b1, G2Point memory b2,
142             G1Point memory c1, G2Point memory c2,
143             G1Point memory d1, G2Point memory d2
144     )
145         internal view returns (bool)
146     {
147         G1Point[] memory p1 = new G1Point[](4);
148         G2Point[] memory p2 = new G2Point[](4);
149         p1[0] = a1;
150         p1[1] = b1;
151         p1[2] = c1;
152         p1[3] = d1;
153         p2[0] = a2;
154         p2[1] = b2;
155         p2[2] = c2;
156         p2[3] = d2;
157         return pairing(p1, p2);
158     }
159 }
160 
161 
162 library Verifier
163 {
164     using Pairing for Pairing.G1Point;
165     using Pairing for Pairing.G2Point;
166 
167     function scalarField ()
168         internal pure returns (uint256)
169     {
170         return 21888242871839275222246405745257275088548364400416034343698204186575808495617;
171     }
172 
173     struct VerifyingKey
174     {
175         Pairing.G1Point alpha;
176         Pairing.G2Point beta;
177         Pairing.G2Point gamma;
178         Pairing.G2Point delta;
179         Pairing.G1Point[] gammaABC;
180     }
181 
182     struct Proof
183     {
184         Pairing.G1Point A;
185         Pairing.G2Point B;
186         Pairing.G1Point C;
187     }
188 
189     struct ProofWithInput
190     {
191         Proof proof;
192         uint256[] input;
193     }
194 
195 
196     function negateY( uint256 Y )
197         internal 
198         pure 
199         returns (uint256)
200     {
201         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
202         return q - (Y % q);
203     }
204 
205 
206     /*
207     * This implements the Solidity equivalent of the following Python code:
208 
209         from py_ecc.bn128 import *
210 
211         data = # ... arguments to function [in_vk, vk_gammaABC, in_proof, proof_inputs]
212 
213         vk = [int(_, 16) for _ in data[0]]
214         ic = [FQ(int(_, 16)) for _ in data[1]]
215         proof = [int(_, 16) for _ in data[2]]
216         inputs = [int(_, 16) for _ in data[3]]
217 
218         it = iter(ic)
219         ic = [(_, next(it)) for _ in it]
220         vk_alpha = [FQ(_) for _ in vk[:2]]
221         vk_beta = (FQ2(vk[2:4][::-1]), FQ2(vk[4:6][::-1]))
222         vk_gamma = (FQ2(vk[6:8][::-1]), FQ2(vk[8:10][::-1]))
223         vk_delta = (FQ2(vk[10:12][::-1]), FQ2(vk[12:14][::-1]))
224 
225         assert is_on_curve(vk_alpha, b)
226         assert is_on_curve(vk_beta, b2)
227         assert is_on_curve(vk_gamma, b2)
228         assert is_on_curve(vk_delta, b2)
229 
230         proof_A = [FQ(_) for _ in proof[:2]]
231         proof_B = (FQ2(proof[2:4][::-1]), FQ2(proof[4:-2][::-1]))
232         proof_C = [FQ(_) for _ in proof[-2:]]
233 
234         assert is_on_curve(proof_A, b)
235         assert is_on_curve(proof_B, b2)
236         assert is_on_curve(proof_C, b)
237 
238         vk_x = ic[0]
239         for i, s in enumerate(inputs):
240             vk_x = add(vk_x, multiply(ic[i + 1], s))
241 
242         check_1 = pairing(proof_B, proof_A)
243         check_2 = pairing(vk_beta, neg(vk_alpha))
244         check_3 = pairing(vk_gamma, neg(vk_x))
245         check_4 = pairing(vk_delta, neg(proof_C))
246 
247         ok = check_1 * check_2 * check_3 * check_4
248         assert ok == FQ12.one()
249     */
250     function verify (uint256[14] memory in_vk, uint256[] memory vk_gammaABC, uint256[8] memory in_proof, uint256[] memory proof_inputs)
251         internal 
252         view 
253         returns (bool)
254     {
255         require( ((vk_gammaABC.length / 2) - 1) == proof_inputs.length );
256         
257         // Compute the linear combination vk_x
258         uint256[3] memory mul_input;
259         uint256[4] memory add_input;
260         bool success;
261         uint m = 2;
262 
263         // First two fields are used as the sum
264         add_input[0] = vk_gammaABC[0];
265         add_input[1] = vk_gammaABC[1];
266 
267         // Performs a sum of gammaABC[0] + sum[ gammaABC[i+1]^proof_inputs[i] ]
268         for (uint i = 0; i < proof_inputs.length; i++) {
269             mul_input[0] = vk_gammaABC[m++];
270             mul_input[1] = vk_gammaABC[m++];
271             mul_input[2] = proof_inputs[i];
272 
273             assembly {
274                 // ECMUL, output to last 2 elements of `add_input`
275                 success := staticcall(sub(gas, 2000), 7, mul_input, 0x80, add(add_input, 0x40), 0x60)
276             }
277             require(success);
278             
279             assembly {
280                 // ECADD
281                 success := staticcall(sub(gas, 2000), 6, add_input, 0xc0, add_input, 0x60)
282             }
283             require(success);
284         }
285         
286         uint[24] memory input = [
287             // (proof.A, proof.B)
288             in_proof[0], in_proof[1],                           // proof.A   (G1)
289             in_proof[2], in_proof[3], in_proof[4], in_proof[5], // proof.B   (G2)
290 
291             // (-vk.alpha, vk.beta)
292             in_vk[0], negateY(in_vk[1]),                        // -vk.alpha (G1)
293             in_vk[2], in_vk[3], in_vk[4], in_vk[5],             // vk.beta   (G2)
294 
295             // (-vk_x, vk.gamma)
296             add_input[0], negateY(add_input[1]),                // -vk_x     (G1)
297             in_vk[6], in_vk[7], in_vk[8], in_vk[9],             // vk.gamma  (G2)
298 
299             // (-proof.C, vk.delta)
300             in_proof[6], negateY(in_proof[7]),                  // -proof.C  (G1)
301             in_vk[10], in_vk[11], in_vk[12], in_vk[13]          // vk.delta  (G2)
302         ];
303 
304         uint[1] memory out;
305         assembly {
306             success := staticcall(sub(gas, 2000), 8, input, 768, out, 0x20)
307         }
308         require(success);
309         return out[0] != 0;
310     }
311 
312 
313     function verify(VerifyingKey memory vk, ProofWithInput memory pwi)
314         internal 
315         view 
316         returns (bool)
317     {
318         return verify(vk, pwi.proof, pwi.input);
319     }
320 
321 
322     function verify(VerifyingKey memory vk, Proof memory proof, uint256[] memory input)
323         internal 
324         view 
325         returns (bool)
326     {
327         require(input.length + 1 == vk.gammaABC.length);
328 
329         // Compute the linear combination vk_x
330         Pairing.G1Point memory vk_x = vk.gammaABC[0];
331         for (uint i = 0; i < input.length; i++)
332             vk_x = Pairing.pointAdd(vk_x, Pairing.pointMul(vk.gammaABC[i + 1], input[i]));
333 
334         // Verify proof
335         return Pairing.pairingProd4(
336             proof.A, proof.B,
337             vk_x.negate(), vk.gamma,
338             proof.C.negate(), vk.delta,
339             vk.alpha.negate(), vk.beta);
340     }
341 }
342 
343 library MiMC
344 {
345     function getScalarField ()
346         internal pure returns (uint256)
347     {
348         return 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
349     }
350 
351     /**
352     * MiMC-p/p with exponent of 7
353     * 
354     * Recommended at least 46 rounds, for a polynomial degree of 2^126
355     */
356     function MiMCpe7( uint256 in_x, uint256 in_k, uint256 in_seed, uint256 round_count )
357         internal pure returns(uint256 out_x)
358     {
359         assembly {
360             if lt(round_count, 1) { revert(0, 0) }
361 
362             // Initialise round constants, k will be hashed
363             let c := mload(0x40)
364             mstore(0x40, add(c, 32))
365             mstore(c, in_seed)
366 
367             let localQ := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
368             let t
369             let a
370 
371             // Further n-2 subsequent rounds include a round constant
372             for { let i := round_count } gt(i, 0) { i := sub(i, 1) } {
373                 // c = H(c)
374                 mstore(c, keccak256(c, 32))
375 
376                 // x = pow(x + c_i, 7, p) + k
377                 t := addmod(addmod(in_x, mload(c), localQ), in_k, localQ)              // t = x + c_i + k
378                 a := mulmod(t, t, localQ)                                              // t^2
379                 in_x := mulmod(mulmod(a, mulmod(a, a, localQ), localQ), t, localQ)     // t^7
380             }
381 
382             // Result adds key again as blinding factor
383             out_x := addmod(in_x, in_k, localQ)
384         }
385     }
386        
387     function MiMCpe7_mp( uint256[] memory in_x, uint256 in_k, uint256 in_seed, uint256 round_count )
388         internal pure returns (uint256)
389     {
390         uint256 r = in_k;
391         uint256 localQ = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
392 
393         for( uint256 i = 0; i < in_x.length; i++ )
394         {
395             r = (r + in_x[i] + MiMCpe7(in_x[i], r, in_seed, round_count)) % localQ;
396         }
397 
398         // uint256 x0 = in_x[0];
399         // uint256 x1 = in_x[1];
400         // uint256 m0 = MiMCpe7(x0, r, in_seed, round_count);
401         // assembly {
402         //     r := addmod(addmod(r, x0, localQ), m0, localQ)
403         // }
404         // uint256 m1 = MiMCpe7(x1, r, in_seed, round_count);
405         // assembly {
406         //     r := addmod(addmod(r, x1, localQ), m1, localQ)
407         // }
408         
409         return r;
410     }
411 
412     function Hash( uint256[] memory in_msgs, uint256 in_key )
413         internal pure returns (uint256)
414     {
415         return MiMCpe7_mp(in_msgs, in_key, uint256(keccak256("mimc")), 91);
416     }
417 
418     function Hash( uint256[] memory in_msgs )
419         internal pure returns (uint256)
420     {
421         return Hash(in_msgs, 0);
422     }
423 }
424 
425 library MerkleTree
426 {
427     // ceil(log2(1<<15))
428     uint constant internal TREE_DEPTH = 15;
429 
430 
431     // 1<<15 leaves
432     uint constant internal MAX_LEAF_COUNT = 32768;
433 
434 
435     struct Data
436     {
437         uint cur;
438         uint256[32768][16] nodes; // first column = leaves, second column = leaves' parents, etc
439     }
440 
441     function treeDepth() internal pure returns (uint256) {
442         return TREE_DEPTH;
443     }
444 
445 
446     function fillLevelIVs (uint256[15] memory IVs)
447         internal
448         pure
449     {
450         IVs[0] = 149674538925118052205057075966660054952481571156186698930522557832224430770;
451         IVs[1] = 9670701465464311903249220692483401938888498641874948577387207195814981706974;
452         IVs[2] = 18318710344500308168304415114839554107298291987930233567781901093928276468271;
453         IVs[3] = 6597209388525824933845812104623007130464197923269180086306970975123437805179;
454         IVs[4] = 21720956803147356712695575768577036859892220417043839172295094119877855004262;
455         IVs[5] = 10330261616520855230513677034606076056972336573153777401182178891807369896722;
456         IVs[6] = 17466547730316258748333298168566143799241073466140136663575045164199607937939;
457         IVs[7] = 18881017304615283094648494495339883533502299318365959655029893746755475886610;
458         IVs[8] = 21580915712563378725413940003372103925756594604076607277692074507345076595494;
459         IVs[9] = 12316305934357579015754723412431647910012873427291630993042374701002287130550;
460         IVs[10] = 18905410889238873726515380969411495891004493295170115920825550288019118582494;
461         IVs[11] = 12819107342879320352602391015489840916114959026915005817918724958237245903353;
462         IVs[12] = 8245796392944118634696709403074300923517437202166861682117022548371601758802;
463         IVs[13] = 16953062784314687781686527153155644849196472783922227794465158787843281909585;
464         IVs[14] = 19346880451250915556764413197424554385509847473349107460608536657852472800734;
465     }
466 
467 
468     function hashImpl (uint256 left, uint256 right, uint256 IV)
469         internal
470         pure
471         returns (uint256)
472     {
473         uint256[] memory x = new uint256[](2);
474         x[0] = left;
475         x[1] = right;
476 
477         return MiMC.Hash(x, IV);
478     }
479 
480 
481     function insert(Data storage self, uint256 leaf)
482         internal
483         returns (uint256 new_root, uint256 offset)
484     {
485         require(leaf != 0);
486 
487 
488         uint256[15] memory IVs;
489         fillLevelIVs(IVs);
490 
491         offset = self.cur;
492 
493         require(offset != MAX_LEAF_COUNT - 1);
494 
495         self.nodes[0][offset] = leaf;
496 
497         new_root = updateTree(self, IVs);
498 
499         self.cur = offset + 1;
500     }
501 
502 
503     /**
504     * Returns calculated merkle root
505     */
506     function verifyPath(uint256 leaf, uint256[15] memory in_path, bool[15] memory address_bits)
507         internal 
508         pure 
509         returns (uint256 merkleRoot)
510     {
511         uint256[15] memory IVs;
512         fillLevelIVs(IVs);
513 
514         merkleRoot = leaf;
515 
516         for (uint depth = 0; depth < TREE_DEPTH; depth++) {
517             if (address_bits[depth]) {
518                 merkleRoot = hashImpl(in_path[depth], merkleRoot, IVs[depth]);
519             } else {
520                 merkleRoot = hashImpl(merkleRoot, in_path[depth], IVs[depth]);
521             }
522         }
523     }
524 
525 
526     function verifyPath(Data storage self, uint256 leaf, uint256[15] memory in_path, bool[15] memory address_bits)
527         internal 
528         view 
529         returns (bool)
530     {
531         return verifyPath(leaf, in_path, address_bits) == getRoot(self);
532     }
533 
534 
535     function getLeaf(Data storage self, uint depth, uint offset)
536         internal
537         view
538         returns (uint256)
539     {
540         return getUniqueLeaf(depth, offset, self.nodes[depth][offset]);
541     }
542 
543 
544     function getMerkleProof(Data storage self, uint index)
545         internal
546         view
547         returns (uint256[15] memory proof_path)
548     {
549         for (uint depth = 0; depth < TREE_DEPTH; depth++)
550         {
551             if (index % 2 == 0) {
552                 proof_path[depth] = getLeaf(self, depth, index + 1);
553             } else {
554                 proof_path[depth] = getLeaf(self, depth, index - 1);
555             }
556             index = uint(index / 2);
557         }
558     }
559 
560 
561     function getUniqueLeaf(uint256 depth, uint256 offset, uint256 leaf)
562         internal pure returns (uint256)
563     {
564         if (leaf == 0x0)
565         {
566             leaf = uint256(
567                 sha256(
568                     abi.encodePacked(
569                         uint16(depth),
570                         uint240(offset)))) % MiMC.getScalarField();
571         }
572 
573         return leaf;
574     }
575 
576 
577     function updateTree(Data storage self, uint256[15] memory IVs)
578         internal returns(uint256 root)
579     {
580         uint currentIndex = self.cur;
581         uint256 leaf1;
582         uint256 leaf2;
583 
584         for (uint depth = 0; depth < TREE_DEPTH; depth++)
585         {
586 
587             if (currentIndex%2 == 0)
588             {
589                 leaf1 = self.nodes[depth][currentIndex];
590 
591                 leaf2 = getUniqueLeaf(depth, currentIndex + 1, self.nodes[depth][currentIndex + 1]);
592             } else
593             {
594                 leaf1 = getUniqueLeaf(depth, currentIndex - 1, self.nodes[depth][currentIndex - 1]);
595 
596                 leaf2 = self.nodes[depth][currentIndex];
597             }
598 
599             uint nextIndex = uint(currentIndex/2);
600 
601             self.nodes[depth+1][nextIndex] = hashImpl(leaf1, leaf2, IVs[depth]);
602 
603             currentIndex = nextIndex;
604         }
605 
606         return self.nodes[TREE_DEPTH][0];
607     }
608 
609 
610     function getRoot (Data storage self)
611         internal
612         view
613         returns (uint256)
614     {
615         return self.nodes[TREE_DEPTH][0];
616     }
617 
618     function getNextLeafIndex (Data storage self)
619         internal
620         view
621         returns (uint256)
622     {
623         return self.cur;
624     }
625 }
626 
627 
628 contract Mixer
629 {
630     using MerkleTree for MerkleTree.Data;
631 
632     uint constant public AMOUNT = 0.01 ether;
633 
634     uint256[14] vk;
635     uint256[] gammaABC;
636 
637     mapping (uint256 => bool) public nullifiers;
638     mapping (address => uint256[]) public pendingDeposits;
639 
640     MerkleTree.Data internal tree;
641 
642     event CommitmentAdded(address indexed _fundingWallet, uint256 _leaf);
643     event LeafAdded(uint256 _leaf, uint256 _leafIndex);
644     event DepositWithdrawn(uint256 _nullifier);
645 
646     constructor(uint256[14] memory in_vk, uint256[] memory in_gammaABC)
647         public
648     {
649         vk = in_vk;
650         gammaABC = in_gammaABC;
651     }
652 
653     function getRoot()
654         public
655         view
656         returns (uint256)
657     {
658         return tree.getRoot();
659     }
660 
661     /**
662     * Save a commitment (leaf) that needs to be funded later on
663     */
664     function commit(uint256 leaf, address fundingWallet)
665         public
666         payable
667     {
668         require(leaf > 0, "null leaf");
669         pendingDeposits[fundingWallet].push(leaf);
670         emit CommitmentAdded(fundingWallet, leaf);
671         if (msg.value > 0) fundCommitment();
672     }
673 
674     function fundCommitment() private {
675         require(msg.value == AMOUNT, "wrong value");
676         uint256[] storage leaves = pendingDeposits[msg.sender];
677         require(leaves.length > 0, "commitment must be sent first");
678         uint256 leaf = leaves[leaves.length - 1];
679         leaves.length--;
680         (, uint256 leafIndex) = tree.insert(leaf);
681         emit LeafAdded(leaf, leafIndex);
682     }
683 
684     /*
685     * Used by the funding wallet to fund a previously saved commitment
686     */
687     function () external payable {
688         fundCommitment();
689     }
690 
691     // should not be used in production otherwise nullifier_secret would be shared with node!
692     function makeLeafHash(uint256 nullifier_secret, address wallet_address)
693         external
694         pure
695         returns (uint256)
696     {
697         // return MiMC.Hash([nullifier_secret, uint256(wallet_address)], 0);
698         bytes32 digest = sha256(abi.encodePacked(nullifier_secret, uint256(wallet_address)));
699         uint256 mask = uint256(-1) >> 4; // clear the first 4 bits to make sure we stay within the prime field
700         return uint256(digest) & mask;
701     }
702 
703     // should not be used in production otherwise nullifier_secret would be shared with node!
704     function makeNullifierHash(uint256 nullifier_secret)
705         external
706         pure
707         returns (uint256)
708     {
709         uint256[] memory vals = new uint256[](2);
710         vals[0] = nullifier_secret;
711         vals[1] = nullifier_secret;
712         return MiMC.Hash(vals, 0);
713     }
714 
715     function getMerklePath(uint256 leafIndex)
716         external
717         view
718         returns (uint256[15] memory out_path)
719     {
720         out_path = tree.getMerkleProof(leafIndex);
721     }
722 
723     function isSpent(uint256 nullifier)
724         public
725         view
726         returns (bool)
727     {
728         return nullifiers[nullifier];
729     }
730 
731     function verifyProof(uint256 in_root, address in_wallet_address, uint256 in_nullifier, uint256[8] memory proof)
732         public
733         view
734         returns (bool)
735     {
736         uint256[] memory snark_input = new uint256[](3);
737         snark_input[0] = in_root;
738         snark_input[1] = uint256(in_wallet_address);
739         snark_input[2] = in_nullifier;
740 
741         return Verifier.verify(vk, gammaABC, proof, snark_input);
742     }
743 
744     function withdraw(
745         address payable in_withdraw_address,
746         uint256 in_nullifier,
747         uint256[8] memory proof
748     )
749         public
750     {
751         uint startGas = gasleft();
752         require(!nullifiers[in_nullifier], "Nullifier used");
753         require(verifyProof(getRoot(), in_withdraw_address, in_nullifier, proof), "Proof verification failed");
754 
755         nullifiers[in_nullifier] = true;
756         emit DepositWithdrawn(in_nullifier);
757 
758         uint gasUsed = startGas - gasleft() + 57700;
759         uint relayerRefund = gasUsed * tx.gasprice;
760         if(relayerRefund > AMOUNT/20) relayerRefund = AMOUNT/20;
761         in_withdraw_address.transfer(AMOUNT - relayerRefund); // leaf withdrawal
762         msg.sender.transfer(relayerRefund); // relayer refund
763     }
764 
765     function treeDepth() external pure returns (uint256) {
766         return MerkleTree.treeDepth();
767     }
768 
769     function getNextLeafIndex() external view returns (uint256) {
770         return tree.getNextLeafIndex();
771     }
772 }