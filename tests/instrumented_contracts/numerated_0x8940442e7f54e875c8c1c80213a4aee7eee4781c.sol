1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Eliptic curve signature operations
6  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
7  * TODO Remove this library once solidity supports passing a signature to ecrecover.
8  * See https://github.com/ethereum/solidity/issues/864
9  */
10 
11 library ECRecovery {
12 
13   /**
14    * @dev Recover signer address from a message by using their signature
15    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
16    * @param sig bytes signature, the signature is generated using web3.eth.sign()
17    */
18   function recover(bytes32 hash, bytes sig)
19     internal
20     pure
21     returns (address)
22   {
23     bytes32 r;
24     bytes32 s;
25     uint8 v;
26 
27     // Check the signature length
28     if (sig.length != 65) {
29       return (address(0));
30     }
31 
32     // Divide the signature in r, s and v variables
33     // ecrecover takes the signature parameters, and the only way to get them
34     // currently is to use assembly.
35     // solium-disable-next-line security/no-inline-assembly
36     assembly {
37       r := mload(add(sig, 32))
38       s := mload(add(sig, 64))
39       v := byte(0, mload(add(sig, 96)))
40     }
41 
42     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
43     if (v < 27) {
44       v += 27;
45     }
46 
47     // If the version is correct return the signer address
48     if (v != 27 && v != 28) {
49       return (address(0));
50     } else {
51       // solium-disable-next-line arg-overflow
52       return ecrecover(hash, v, r, s);
53     }
54   }
55 
56   /**
57    * toEthSignedMessageHash
58    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
59    * and hash the result
60    */
61   function toEthSignedMessageHash(bytes32 hash)
62     internal
63     pure
64     returns (bytes32)
65   {
66     // 32 is the length in bytes of hash,
67     // enforced by the type signature above
68     return keccak256(
69       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
70     );
71   }
72 }
73 
74 
75 library OrderStatisticTree {
76 
77     struct Node {
78         mapping (bool => uint) children; // a mapping of left(false) child and right(true) child nodes
79         uint parent; // parent node
80         bool side;   // side of the node on the tree (left or right)
81         uint height; //Height of this node
82         uint count; //Number of tree nodes below this node (including this one)
83         uint dupes; //Number of duplicates values for this node
84     }
85 
86     struct Tree {
87         // a mapping between node value(uint) to Node
88         // the tree's root is always at node 0 ,which points to the "real" tree
89         // as its right child.this is done to eliminate the need to update the tree
90         // root in the case of rotation.(saving gas).
91         mapping(uint => Node) nodes;
92     }
93     /**
94      * @dev rank - find the rank of a value in the tree,
95      *      i.e. its index in the sorted list of elements of the tree
96      * @param _tree the tree
97      * @param _value the input value to find its rank.
98      * @return smaller - the number of elements in the tree which their value is
99      * less than the input value.
100      */
101     function rank(Tree storage _tree,uint _value) internal view returns (uint smaller) {
102         if (_value != 0) {
103             smaller = _tree.nodes[0].dupes;
104 
105             uint cur = _tree.nodes[0].children[true];
106             Node storage currentNode = _tree.nodes[cur];
107 
108             while (true) {
109                 if (cur <= _value) {
110                     if (cur<_value) {
111                         smaller = smaller + 1+currentNode.dupes;
112                     }
113                     uint leftChild = currentNode.children[false];
114                     if (leftChild!=0) {
115                         smaller = smaller + _tree.nodes[leftChild].count;
116                     }
117                 }
118                 if (cur == _value) {
119                     break;
120                 }
121                 cur = currentNode.children[cur<_value];
122                 if (cur == 0) {
123                     break;
124                 }
125                 currentNode = _tree.nodes[cur];
126             }
127         }
128     }
129 
130     function count(Tree storage _tree) internal view returns (uint) {
131         Node storage root = _tree.nodes[0];
132         Node memory child = _tree.nodes[root.children[true]];
133         return root.dupes+child.count;
134     }
135 
136     function updateCount(Tree storage _tree,uint _value) private {
137         Node storage n = _tree.nodes[_value];
138         n.count = 1+_tree.nodes[n.children[false]].count+_tree.nodes[n.children[true]].count+n.dupes;
139     }
140 
141     function updateCounts(Tree storage _tree,uint _value) private {
142         uint parent = _tree.nodes[_value].parent;
143         while (parent!=0) {
144             updateCount(_tree,parent);
145             parent = _tree.nodes[parent].parent;
146         }
147     }
148 
149     function updateHeight(Tree storage _tree,uint _value) private {
150         Node storage n = _tree.nodes[_value];
151         uint heightLeft = _tree.nodes[n.children[false]].height;
152         uint heightRight = _tree.nodes[n.children[true]].height;
153         if (heightLeft > heightRight)
154             n.height = heightLeft+1;
155         else
156             n.height = heightRight+1;
157     }
158 
159     function balanceFactor(Tree storage _tree,uint _value) private view returns (int bf) {
160         Node storage n = _tree.nodes[_value];
161         return int(_tree.nodes[n.children[false]].height)-int(_tree.nodes[n.children[true]].height);
162     }
163 
164     function rotate(Tree storage _tree,uint _value,bool dir) private {
165         bool otherDir = !dir;
166         Node storage n = _tree.nodes[_value];
167         bool side = n.side;
168         uint parent = n.parent;
169         uint valueNew = n.children[otherDir];
170         Node storage nNew = _tree.nodes[valueNew];
171         uint orphan = nNew.children[dir];
172         Node storage p = _tree.nodes[parent];
173         Node storage o = _tree.nodes[orphan];
174         p.children[side] = valueNew;
175         nNew.side = side;
176         nNew.parent = parent;
177         nNew.children[dir] = _value;
178         n.parent = valueNew;
179         n.side = dir;
180         n.children[otherDir] = orphan;
181         o.parent = _value;
182         o.side = otherDir;
183         updateHeight(_tree,_value);
184         updateHeight(_tree,valueNew);
185         updateCount(_tree,_value);
186         updateCount(_tree,valueNew);
187     }
188 
189     function rebalanceInsert(Tree storage _tree,uint _nValue) private {
190         updateHeight(_tree,_nValue);
191         Node storage n = _tree.nodes[_nValue];
192         uint pValue = n.parent;
193         if (pValue!=0) {
194             int pBf = balanceFactor(_tree,pValue);
195             bool side = n.side;
196             int sign;
197             if (side)
198                 sign = -1;
199             else
200                 sign = 1;
201             if (pBf == sign*2) {
202                 if (balanceFactor(_tree,_nValue) == (-1 * sign)) {
203                     rotate(_tree,_nValue,side);
204                 }
205                 rotate(_tree,pValue,!side);
206             } else if (pBf != 0) {
207                 rebalanceInsert(_tree,pValue);
208             }
209         }
210     }
211 
212     function rebalanceDelete(Tree storage _tree,uint _pValue,bool side) private {
213         if (_pValue!=0) {
214             updateHeight(_tree,_pValue);
215             int pBf = balanceFactor(_tree,_pValue);
216             int sign;
217             if (side)
218                 sign = 1;
219             else
220                 sign = -1;
221             int bf = balanceFactor(_tree,_pValue);
222             if (bf==(2*sign)) {
223                 Node storage p = _tree.nodes[_pValue];
224                 uint sValue = p.children[!side];
225                 int sBf = balanceFactor(_tree,sValue);
226                 if (sBf == (-1 * sign)) {
227                     rotate(_tree,sValue,!side);
228                 }
229                 rotate(_tree,_pValue,side);
230                 if (sBf!=0) {
231                     p = _tree.nodes[_pValue];
232                     rebalanceDelete(_tree,p.parent,p.side);
233                 }
234             } else if (pBf != sign) {
235                 p = _tree.nodes[_pValue];
236                 rebalanceDelete(_tree,p.parent,p.side);
237             }
238         }
239     }
240 
241     function fixParents(Tree storage _tree,uint parent,bool side) private {
242         if (parent!=0) {
243             updateCount(_tree,parent);
244             updateCounts(_tree,parent);
245             rebalanceDelete(_tree,parent,side);
246         }
247     }
248 
249     function insertHelper(Tree storage _tree,uint _pValue,bool _side,uint _value) private {
250         Node storage root = _tree.nodes[_pValue];
251         uint cValue = root.children[_side];
252         if (cValue==0) {
253             root.children[_side] = _value;
254             Node storage child = _tree.nodes[_value];
255             child.parent = _pValue;
256             child.side = _side;
257             child.height = 1;
258             child.count = 1;
259             updateCounts(_tree,_value);
260             rebalanceInsert(_tree,_value);
261         } else if (cValue==_value) {
262             _tree.nodes[cValue].dupes++;
263             updateCount(_tree,_value);
264             updateCounts(_tree,_value);
265         } else {
266             insertHelper(_tree,cValue,(_value >= cValue),_value);
267         }
268     }
269 
270     function insert(Tree storage _tree,uint _value) internal {
271         if (_value==0) {
272             _tree.nodes[_value].dupes++;
273         } else {
274             insertHelper(_tree,0,true,_value);
275         }
276     }
277 
278     function rightmostLeaf(Tree storage _tree,uint _value) private view returns (uint leaf) {
279         uint child = _tree.nodes[_value].children[true];
280         if (child!=0) {
281             return rightmostLeaf(_tree,child);
282         } else {
283             return _value;
284         }
285     }
286 
287     function zeroOut(Tree storage _tree,uint _value) private {
288         Node storage n = _tree.nodes[_value];
289         n.parent = 0;
290         n.side = false;
291         n.children[false] = 0;
292         n.children[true] = 0;
293         n.count = 0;
294         n.height = 0;
295         n.dupes = 0;
296     }
297 
298     function removeBranch(Tree storage _tree,uint _value,uint _left) private {
299         uint ipn = rightmostLeaf(_tree,_left);
300         Node storage i = _tree.nodes[ipn];
301         uint dupes = i.dupes;
302         removeHelper(_tree,ipn);
303         Node storage n = _tree.nodes[_value];
304         uint parent = n.parent;
305         Node storage p = _tree.nodes[parent];
306         uint height = n.height;
307         bool side = n.side;
308         uint ncount = n.count;
309         uint right = n.children[true];
310         uint left = n.children[false];
311         p.children[side] = ipn;
312         i.parent = parent;
313         i.side = side;
314         i.count = ncount+dupes-n.dupes;
315         i.height = height;
316         i.dupes = dupes;
317         if (left!=0) {
318             i.children[false] = left;
319             _tree.nodes[left].parent = ipn;
320         }
321         if (right!=0) {
322             i.children[true] = right;
323             _tree.nodes[right].parent = ipn;
324         }
325         zeroOut(_tree,_value);
326         updateCounts(_tree,ipn);
327     }
328 
329     function removeHelper(Tree storage _tree,uint _value) private {
330         Node storage n = _tree.nodes[_value];
331         uint parent = n.parent;
332         bool side = n.side;
333         Node storage p = _tree.nodes[parent];
334         uint left = n.children[false];
335         uint right = n.children[true];
336         if ((left == 0) && (right == 0)) {
337             p.children[side] = 0;
338             zeroOut(_tree,_value);
339             fixParents(_tree,parent,side);
340         } else if ((left != 0) && (right != 0)) {
341             removeBranch(_tree,_value,left);
342         } else {
343             uint child = left+right;
344             Node storage c = _tree.nodes[child];
345             p.children[side] = child;
346             c.parent = parent;
347             c.side = side;
348             zeroOut(_tree,_value);
349             fixParents(_tree,parent,side);
350         }
351     }
352 
353     function remove(Tree storage _tree,uint _value) internal {
354         Node storage n = _tree.nodes[_value];
355         if (_value==0) {
356             if (n.dupes==0) {
357                 return;
358             }
359         } else {
360             if (n.count==0) {
361                 return;
362             }
363         }
364         if (n.dupes>0) {
365             n.dupes--;
366             if (_value!=0) {
367                 n.count--;
368             }
369             fixParents(_tree,n.parent,n.side);
370         } else {
371             removeHelper(_tree,_value);
372         }
373     }
374 
375 }
376 
377 /**
378  * RealMath: fixed-point math library, based on fractional and integer parts.
379  * Using int256 as real216x40, which isn't in Solidity yet.
380  * 40 fractional bits gets us down to 1E-12 precision, while still letting us
381  * go up to galaxy scale counting in meters.
382  * Internally uses the wider int256 for some math.
383  *
384  * Note that for addition, subtraction, and mod (%), you should just use the
385  * built-in Solidity operators. Functions for these operations are not provided.
386  *
387  * Note that the fancy functions like sqrt, atan2, etc. aren't as accurate as
388  * they should be. They are (hopefully) Good Enough for doing orbital mechanics
389  * on block timescales in a game context, but they may not be good enough for
390  * other applications.
391  */
392 
393 
394 library RealMath {
395 
396     /**
397      * How many total bits are there?
398      */
399     int256 constant REAL_BITS = 256;
400 
401     /**
402      * How many fractional bits are there?
403      */
404     int256 constant REAL_FBITS = 40;
405 
406     /**
407      * How many integer bits are there?
408      */
409     int256 constant REAL_IBITS = REAL_BITS - REAL_FBITS;
410 
411     /**
412      * What's the first non-fractional bit
413      */
414     int256 constant REAL_ONE = int256(1) << REAL_FBITS;
415 
416     /**
417      * What's the last fractional bit?
418      */
419     int256 constant REAL_HALF = REAL_ONE >> 1;
420 
421     /**
422      * What's two? Two is pretty useful.
423      */
424     int256 constant REAL_TWO = REAL_ONE << 1;
425 
426     /**
427      * And our logarithms are based on ln(2).
428      */
429     int256 constant REAL_LN_TWO = 762123384786;
430 
431     /**
432      * It is also useful to have Pi around.
433      */
434     int256 constant REAL_PI = 3454217652358;
435 
436     /**
437      * And half Pi, to save on divides.
438      * TODO: That might not be how the compiler handles constants.
439      */
440     int256 constant REAL_HALF_PI = 1727108826179;
441 
442     /**
443      * And two pi, which happens to be odd in its most accurate representation.
444      */
445     int256 constant REAL_TWO_PI = 6908435304715;
446 
447     /**
448      * What's the sign bit?
449      */
450     int256 constant SIGN_MASK = int256(1) << 255;
451 
452 
453     /**
454      * Convert an integer to a real. Preserves sign.
455      */
456     function toReal(int216 ipart) internal pure returns (int256) {
457         return int256(ipart) * REAL_ONE;
458     }
459 
460     /**
461      * Convert a real to an integer. Preserves sign.
462      */
463     function fromReal(int256 realValue) internal pure returns (int216) {
464         return int216(realValue / REAL_ONE);
465     }
466 
467     /**
468      * Round a real to the nearest integral real value.
469      */
470     function round(int256 realValue) internal pure returns (int256) {
471         // First, truncate.
472         int216 ipart = fromReal(realValue);
473         if ((fractionalBits(realValue) & (uint40(1) << (REAL_FBITS - 1))) > 0) {
474             // High fractional bit is set. Round up.
475             if (realValue < int256(0)) {
476                 // Rounding up for a negative number is rounding down.
477                 ipart -= 1;
478             } else {
479                 ipart += 1;
480             }
481         }
482         return toReal(ipart);
483     }
484 
485     /**
486      * Get the absolute value of a real. Just the same as abs on a normal int256.
487      */
488     function abs(int256 realValue) internal pure returns (int256) {
489         if (realValue > 0) {
490             return realValue;
491         } else {
492             return -realValue;
493         }
494     }
495 
496     /**
497      * Returns the fractional bits of a real. Ignores the sign of the real.
498      */
499     function fractionalBits(int256 realValue) internal pure returns (uint40) {
500         return uint40(abs(realValue) % REAL_ONE);
501     }
502 
503     /**
504      * Get the fractional part of a real, as a real. Ignores sign (so fpart(-0.5) is 0.5).
505      */
506     function fpart(int256 realValue) internal pure returns (int256) {
507         // This gets the fractional part but strips the sign
508         return abs(realValue) % REAL_ONE;
509     }
510 
511     /**
512      * Get the fractional part of a real, as a real. Respects sign (so fpartSigned(-0.5) is -0.5).
513      */
514     function fpartSigned(int256 realValue) internal pure returns (int256) {
515         // This gets the fractional part but strips the sign
516         int256 fractional = fpart(realValue);
517         if (realValue < 0) {
518             // Add the negative sign back in.
519             return -fractional;
520         } else {
521             return fractional;
522         }
523     }
524 
525     /**
526      * Get the integer part of a fixed point value.
527      */
528     function ipart(int256 realValue) internal pure returns (int256) {
529         // Subtract out the fractional part to get the real part.
530         return realValue - fpartSigned(realValue);
531     }
532 
533     /**
534      * Multiply one real by another. Truncates overflows.
535      */
536     function mul(int256 realA, int256 realB) internal pure returns (int256) {
537         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
538         // So we just have to clip off the extra REAL_FBITS fractional bits.
539         return int256((int256(realA) * int256(realB)) >> REAL_FBITS);
540     }
541 
542     /**
543      * Divide one real by another real. Truncates overflows.
544      */
545     function div(int256 realNumerator, int256 realDenominator) internal pure returns (int256) {
546         // We use the reverse of the multiplication trick: convert numerator from
547         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
548         return int256((int256(realNumerator) * REAL_ONE) / int256(realDenominator));
549     }
550 
551     /**
552      * Create a real from a rational fraction.
553      */
554     function fraction(int216 numerator, int216 denominator) internal pure returns (int256) {
555         return div(toReal(numerator), toReal(denominator));
556     }
557 
558     // Now we have some fancy math things (like pow and trig stuff). This isn't
559     // in the RealMath that was deployed with the original Macroverse
560     // deployment, so it needs to be linked into your contract statically.
561 
562     /**
563      * Raise a number to a positive integer power in O(log power) time.
564      * See <https://stackoverflow.com/a/101613>
565      */
566     function ipow(int256 realBase, int216 exponent) internal pure returns (int256) {
567         if (exponent < 0) {
568             // Negative powers are not allowed here.
569             revert();
570         }
571 
572         int256 tempRealBase = realBase;
573         int256 tempExponent = exponent;
574 
575         // Start with the 0th power
576         int256 realResult = REAL_ONE;
577         while (tempExponent != 0) {
578             // While there are still bits set
579             if ((tempExponent & 0x1) == 0x1) {
580                 // If the low bit is set, multiply in the (many-times-squared) base
581                 realResult = mul(realResult, tempRealBase);
582             }
583             // Shift off the low bit
584             tempExponent = tempExponent >> 1;
585             // Do the squaring
586             tempRealBase = mul(tempRealBase, tempRealBase);
587         }
588 
589         // Return the final result.
590         return realResult;
591     }
592 
593     /**
594      * Zero all but the highest set bit of a number.
595      * See <https://stackoverflow.com/a/53184>
596      */
597     function hibit(uint256 _val) internal pure returns (uint256) {
598         // Set all the bits below the highest set bit
599         uint256 val = _val;
600         val |= (val >> 1);
601         val |= (val >> 2);
602         val |= (val >> 4);
603         val |= (val >> 8);
604         val |= (val >> 16);
605         val |= (val >> 32);
606         val |= (val >> 64);
607         val |= (val >> 128);
608         return val ^ (val >> 1);
609     }
610 
611     /**
612      * Given a number with one bit set, finds the index of that bit.
613      */
614     function findbit(uint256 val) internal pure returns (uint8 index) {
615         index = 0;
616         // We and the value with alternating bit patters of various pitches to find it.
617         if (val & 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA != 0) {
618             // Picth 1
619             index |= 1;
620         }
621         if (val & 0xCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC != 0) {
622             // Pitch 2
623             index |= 2;
624         }
625         if (val & 0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0 != 0) {
626             // Pitch 4
627             index |= 4;
628         }
629         if (val & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00 != 0) {
630             // Pitch 8
631             index |= 8;
632         }
633         if (val & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000 != 0) {
634             // Pitch 16
635             index |= 16;
636         }
637         if (val & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000 != 0) {
638             // Pitch 32
639             index |= 32;
640         }
641         if (val & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000 != 0) {
642             // Pitch 64
643             index |= 64;
644         }
645         if (val & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000 != 0) {
646             // Pitch 128
647             index |= 128;
648         }
649     }
650 
651     /**
652      * Shift realArg left or right until it is between 1 and 2. Return the
653      * rescaled value, and the number of bits of right shift applied. Shift may be negative.
654      *
655      * Expresses realArg as realScaled * 2^shift, setting shift to put realArg between [1 and 2).
656      *
657      * Rejects 0 or negative arguments.
658      */
659     function rescale(int256 realArg) internal pure returns (int256 realScaled, int216 shift) {
660         if (realArg <= 0) {
661             // Not in domain!
662             revert();
663         }
664 
665         // Find the high bit
666         int216 highBit = findbit(hibit(uint256(realArg)));
667 
668         // We'll shift so the high bit is the lowest non-fractional bit.
669         shift = highBit - int216(REAL_FBITS);
670 
671         if (shift < 0) {
672             // Shift left
673             realScaled = realArg << -shift;
674         } else if (shift >= 0) {
675             // Shift right
676             realScaled = realArg >> shift;
677         }
678     }
679 
680     /**
681      * Calculate the natural log of a number. Rescales the input value and uses
682      * the algorithm outlined at <https://math.stackexchange.com/a/977836> and
683      * the ipow implementation.
684      *
685      * Lets you artificially limit the number of iterations.
686      *
687      * Note that it is potentially possible to get an un-converged value; lack
688      * of convergence does not throw.
689      */
690     function lnLimited(int256 realArg, int maxIterations) internal pure returns (int256) {
691         if (realArg <= 0) {
692             // Outside of acceptable domain
693             revert();
694         }
695 
696         if (realArg == REAL_ONE) {
697             // Handle this case specially because people will want exactly 0 and
698             // not ~2^-39 ish.
699             return 0;
700         }
701 
702         // We know it's positive, so rescale it to be between [1 and 2)
703         int256 realRescaled;
704         int216 shift;
705         (realRescaled, shift) = rescale(realArg);
706 
707         // Compute the argument to iterate on
708         int256 realSeriesArg = div(realRescaled - REAL_ONE, realRescaled + REAL_ONE);
709 
710         // We will accumulate the result here
711         int256 realSeriesResult = 0;
712 
713         for (int216 n = 0; n < maxIterations; n++) {
714             // Compute term n of the series
715             int256 realTerm = div(ipow(realSeriesArg, 2 * n + 1), toReal(2 * n + 1));
716             // And add it in
717             realSeriesResult += realTerm;
718             if (realTerm == 0) {
719                 // We must have converged. Next term is too small to represent.
720                 break;
721             }
722             // If we somehow never converge I guess we will run out of gas
723         }
724 
725         // Double it to account for the factor of 2 outside the sum
726         realSeriesResult = mul(realSeriesResult, REAL_TWO);
727 
728         // Now compute and return the overall result
729         return mul(toReal(shift), REAL_LN_TWO) + realSeriesResult;
730 
731     }
732 
733     /**
734      * Calculate a natural logarithm with a sensible maximum iteration count to
735      * wait until convergence. Note that it is potentially possible to get an
736      * un-converged value; lack of convergence does not throw.
737      */
738     function ln(int256 realArg) internal pure returns (int256) {
739         return lnLimited(realArg, 100);
740     }
741 
742     /**
743      * Calculate e^x. Uses the series given at
744      * <http://pages.mtu.edu/~shene/COURSES/cs201/NOTES/chap04/exp.html>.
745      *
746      * Lets you artificially limit the number of iterations.
747      *
748      * Note that it is potentially possible to get an un-converged value; lack
749      * of convergence does not throw.
750      */
751     function expLimited(int256 realArg, int maxIterations) internal pure returns (int256) {
752         // We will accumulate the result here
753         int256 realResult = 0;
754 
755         // We use this to save work computing terms
756         int256 realTerm = REAL_ONE;
757 
758         for (int216 n = 0; n < maxIterations; n++) {
759             // Add in the term
760             realResult += realTerm;
761 
762             // Compute the next term
763             realTerm = mul(realTerm, div(realArg, toReal(n + 1)));
764 
765             if (realTerm == 0) {
766                 // We must have converged. Next term is too small to represent.
767                 break;
768             }
769             // If we somehow never converge I guess we will run out of gas
770         }
771 
772         // Return the result
773         return realResult;
774 
775     }
776 
777     /**
778      * Calculate e^x with a sensible maximum iteration count to wait until
779      * convergence. Note that it is potentially possible to get an un-converged
780      * value; lack of convergence does not throw.
781      */
782     function exp(int256 realArg) internal pure returns (int256) {
783         return expLimited(realArg, 100);
784     }
785 
786     /**
787      * Raise any number to any power, except for negative bases to fractional powers.
788      */
789     function pow(int256 realBase, int256 realExponent) internal pure returns (int256) {
790         if (realExponent == 0) {
791             // Anything to the 0 is 1
792             return REAL_ONE;
793         }
794 
795         if (realBase == 0) {
796             if (realExponent < 0) {
797                 // Outside of domain!
798                 revert();
799             }
800             // Otherwise it's 0
801             return 0;
802         }
803 
804         if (fpart(realExponent) == 0) {
805             // Anything (even a negative base) is super easy to do to an integer power.
806 
807             if (realExponent > 0) {
808                 // Positive integer power is easy
809                 return ipow(realBase, fromReal(realExponent));
810             } else {
811                 // Negative integer power is harder
812                 return div(REAL_ONE, ipow(realBase, fromReal(-realExponent)));
813             }
814         }
815 
816         if (realBase < 0) {
817             // It's a negative base to a non-integer power.
818             // In general pow(-x^y) is undefined, unless y is an int or some
819             // weird rational-number-based relationship holds.
820             revert();
821         }
822 
823         // If it's not a special case, actually do it.
824         return exp(mul(realExponent, ln(realBase)));
825     }
826 
827     /**
828      * Compute the square root of a number.
829      */
830     function sqrt(int256 realArg) internal pure returns (int256) {
831         return pow(realArg, REAL_HALF);
832     }
833 
834     /**
835      * Compute the sin of a number to a certain number of Taylor series terms.
836      */
837     function sinLimited(int256 _realArg, int216 maxIterations) internal pure returns (int256) {
838         // First bring the number into 0 to 2 pi
839         // TODO: This will introduce an error for very large numbers, because the error in our Pi will compound.
840         // But for actual reasonable angle values we should be fine.
841         int256 realArg = _realArg;
842         realArg = realArg % REAL_TWO_PI;
843 
844         int256 accumulator = REAL_ONE;
845 
846         // We sum from large to small iteration so that we can have higher powers in later terms
847         for (int216 iteration = maxIterations - 1; iteration >= 0; iteration--) {
848             accumulator = REAL_ONE - mul(div(mul(realArg, realArg), toReal((2 * iteration + 2) * (2 * iteration + 3))), accumulator);
849             // We can't stop early; we need to make it to the first term.
850         }
851 
852         return mul(realArg, accumulator);
853     }
854 
855     /**
856      * Calculate sin(x) with a sensible maximum iteration count to wait until
857      * convergence.
858      */
859     function sin(int256 realArg) internal pure returns (int256) {
860         return sinLimited(realArg, 15);
861     }
862 
863     /**
864      * Calculate cos(x).
865      */
866     function cos(int256 realArg) internal pure returns (int256) {
867         return sin(realArg + REAL_HALF_PI);
868     }
869 
870     /**
871      * Calculate tan(x). May overflow for large results. May throw if tan(x)
872      * would be infinite, or return an approximation, or overflow.
873      */
874     function tan(int256 realArg) internal pure returns (int256) {
875         return div(sin(realArg), cos(realArg));
876     }
877 }
878 /**
879  * @title Ownable
880  * @dev The Ownable contract has an owner address, and provides basic authorization control
881  * functions, this simplifies the implementation of "user permissions".
882  */
883 contract Ownable {
884   address public owner;
885 
886 
887   event OwnershipRenounced(address indexed previousOwner);
888   event OwnershipTransferred(
889     address indexed previousOwner,
890     address indexed newOwner
891   );
892 
893 
894   /**
895    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
896    * account.
897    */
898   constructor() public {
899     owner = msg.sender;
900   }
901 
902   /**
903    * @dev Throws if called by any account other than the owner.
904    */
905   modifier onlyOwner() {
906     require(msg.sender == owner);
907     _;
908   }
909 
910   /**
911    * @dev Allows the current owner to relinquish control of the contract.
912    * @notice Renouncing to ownership will leave the contract without an owner.
913    * It will not be possible to call the functions with the `onlyOwner`
914    * modifier anymore.
915    */
916   function renounceOwnership() public onlyOwner {
917     emit OwnershipRenounced(owner);
918     owner = address(0);
919   }
920 
921   /**
922    * @dev Allows the current owner to transfer control of the contract to a newOwner.
923    * @param _newOwner The address to transfer ownership to.
924    */
925   function transferOwnership(address _newOwner) public onlyOwner {
926     _transferOwnership(_newOwner);
927   }
928 
929   /**
930    * @dev Transfers control of the contract to a newOwner.
931    * @param _newOwner The address to transfer ownership to.
932    */
933   function _transferOwnership(address _newOwner) internal {
934     require(_newOwner != address(0));
935     emit OwnershipTransferred(owner, _newOwner);
936     owner = _newOwner;
937   }
938 }
939 
940 pragma solidity ^0.4.24;
941 
942 
943 
944 /**
945  * @title ERC20Basic
946  * @dev Simpler version of ERC20 interface
947  * See https://github.com/ethereum/EIPs/issues/179
948  */
949 contract ERC20Basic {
950   function totalSupply() public view returns (uint256);
951   function balanceOf(address who) public view returns (uint256);
952   function transfer(address to, uint256 value) public returns (bool);
953   event Transfer(address indexed from, address indexed to, uint256 value);
954 }
955 
956 
957 /**
958  * @title ERC20 interface
959  * @dev see https://github.com/ethereum/EIPs/issues/20
960  */
961 contract ERC20 is ERC20Basic {
962   function allowance(address owner, address spender)
963     public view returns (uint256);
964 
965   function transferFrom(address from, address to, uint256 value)
966     public returns (bool);
967 
968   function approve(address spender, uint256 value) public returns (bool);
969   event Approval(
970     address indexed owner,
971     address indexed spender,
972     uint256 value
973   );
974 }
975 
976 /**
977  * @title Basic token
978  * @dev Basic version of StandardToken, with no allowances.
979  */
980 contract BasicToken is ERC20Basic {
981   using SafeMath for uint256;
982 
983   mapping(address => uint256) balances;
984 
985   uint256 totalSupply_;
986 
987   /**
988   * @dev Total number of tokens in existence
989   */
990   function totalSupply() public view returns (uint256) {
991     return totalSupply_;
992   }
993 
994   /**
995   * @dev Transfer token for a specified address
996   * @param _to The address to transfer to.
997   * @param _value The amount to be transferred.
998   */
999   function transfer(address _to, uint256 _value) public returns (bool) {
1000     require(_to != address(0));
1001     require(_value <= balances[msg.sender]);
1002 
1003     balances[msg.sender] = balances[msg.sender].sub(_value);
1004     balances[_to] = balances[_to].add(_value);
1005     emit Transfer(msg.sender, _to, _value);
1006     return true;
1007   }
1008 
1009   /**
1010   * @dev Gets the balance of the specified address.
1011   * @param _owner The address to query the the balance of.
1012   * @return An uint256 representing the amount owned by the passed address.
1013   */
1014   function balanceOf(address _owner) public view returns (uint256) {
1015     return balances[_owner];
1016   }
1017 
1018 }
1019 
1020 /**
1021  * @title Standard ERC20 token
1022  *
1023  * @dev Implementation of the basic standard token.
1024  * https://github.com/ethereum/EIPs/issues/20
1025  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1026  */
1027 contract StandardToken is ERC20, BasicToken {
1028 
1029   mapping (address => mapping (address => uint256)) internal allowed;
1030 
1031 
1032   /**
1033    * @dev Transfer tokens from one address to another
1034    * @param _from address The address which you want to send tokens from
1035    * @param _to address The address which you want to transfer to
1036    * @param _value uint256 the amount of tokens to be transferred
1037    */
1038   function transferFrom(
1039     address _from,
1040     address _to,
1041     uint256 _value
1042   )
1043     public
1044     returns (bool)
1045   {
1046     require(_to != address(0));
1047     require(_value <= balances[_from]);
1048     require(_value <= allowed[_from][msg.sender]);
1049 
1050     balances[_from] = balances[_from].sub(_value);
1051     balances[_to] = balances[_to].add(_value);
1052     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1053     emit Transfer(_from, _to, _value);
1054     return true;
1055   }
1056 
1057   /**
1058    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1059    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1060    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1061    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1062    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1063    * @param _spender The address which will spend the funds.
1064    * @param _value The amount of tokens to be spent.
1065    */
1066   function approve(address _spender, uint256 _value) public returns (bool) {
1067     allowed[msg.sender][_spender] = _value;
1068     emit Approval(msg.sender, _spender, _value);
1069     return true;
1070   }
1071 
1072   /**
1073    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1074    * @param _owner address The address which owns the funds.
1075    * @param _spender address The address which will spend the funds.
1076    * @return A uint256 specifying the amount of tokens still available for the spender.
1077    */
1078   function allowance(
1079     address _owner,
1080     address _spender
1081    )
1082     public
1083     view
1084     returns (uint256)
1085   {
1086     return allowed[_owner][_spender];
1087   }
1088 
1089   /**
1090    * @dev Increase the amount of tokens that an owner allowed to a spender.
1091    * approve should be called when allowed[_spender] == 0. To increment
1092    * allowed value is better to use this function to avoid 2 calls (and wait until
1093    * the first transaction is mined)
1094    * From MonolithDAO Token.sol
1095    * @param _spender The address which will spend the funds.
1096    * @param _addedValue The amount of tokens to increase the allowance by.
1097    */
1098   function increaseApproval(
1099     address _spender,
1100     uint256 _addedValue
1101   )
1102     public
1103     returns (bool)
1104   {
1105     allowed[msg.sender][_spender] = (
1106       allowed[msg.sender][_spender].add(_addedValue));
1107     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1108     return true;
1109   }
1110 
1111   /**
1112    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1113    * approve should be called when allowed[_spender] == 0. To decrement
1114    * allowed value is better to use this function to avoid 2 calls (and wait until
1115    * the first transaction is mined)
1116    * From MonolithDAO Token.sol
1117    * @param _spender The address which will spend the funds.
1118    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1119    */
1120   function decreaseApproval(
1121     address _spender,
1122     uint256 _subtractedValue
1123   )
1124     public
1125     returns (bool)
1126   {
1127     uint256 oldValue = allowed[msg.sender][_spender];
1128     if (_subtractedValue > oldValue) {
1129       allowed[msg.sender][_spender] = 0;
1130     } else {
1131       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1132     }
1133     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1134     return true;
1135   }
1136 
1137 }
1138 
1139 
1140 
1141 
1142 
1143 /**
1144  * @title Mintable token
1145  * @dev Simple ERC20 Token example, with mintable token creation
1146  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1147  */
1148 contract MintableToken is StandardToken, Ownable {
1149   event Mint(address indexed to, uint256 amount);
1150   event MintFinished();
1151 
1152   bool public mintingFinished = false;
1153 
1154 
1155   modifier canMint() {
1156     require(!mintingFinished);
1157     _;
1158   }
1159 
1160   modifier hasMintPermission() {
1161     require(msg.sender == owner);
1162     _;
1163   }
1164 
1165   /**
1166    * @dev Function to mint tokens
1167    * @param _to The address that will receive the minted tokens.
1168    * @param _amount The amount of tokens to mint.
1169    * @return A boolean that indicates if the operation was successful.
1170    */
1171   function mint(
1172     address _to,
1173     uint256 _amount
1174   )
1175     hasMintPermission
1176     canMint
1177     public
1178     returns (bool)
1179   {
1180     totalSupply_ = totalSupply_.add(_amount);
1181     balances[_to] = balances[_to].add(_amount);
1182     emit Mint(_to, _amount);
1183     emit Transfer(address(0), _to, _amount);
1184     return true;
1185   }
1186 
1187   /**
1188    * @dev Function to stop minting new tokens.
1189    * @return True if the operation was successful.
1190    */
1191   function finishMinting() onlyOwner canMint public returns (bool) {
1192     mintingFinished = true;
1193     emit MintFinished();
1194     return true;
1195   }
1196 }
1197 
1198 /**
1199  * @title Burnable Token
1200  * @dev Token that can be irreversibly burned (destroyed).
1201  */
1202 contract BurnableToken is BasicToken {
1203 
1204   event Burn(address indexed burner, uint256 value);
1205 
1206   /**
1207    * @dev Burns a specific amount of tokens.
1208    * @param _value The amount of token to be burned.
1209    */
1210   function burn(uint256 _value) public {
1211     _burn(msg.sender, _value);
1212   }
1213 
1214   function _burn(address _who, uint256 _value) internal {
1215     require(_value <= balances[_who]);
1216     // no need to require value <= totalSupply, since that would imply the
1217     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1218 
1219     balances[_who] = balances[_who].sub(_value);
1220     totalSupply_ = totalSupply_.sub(_value);
1221     emit Burn(_who, _value);
1222     emit Transfer(_who, address(0), _value);
1223   }
1224 }
1225 
1226 
1227 
1228 /**
1229  * @title SafeMath
1230  * @dev Math operations with safety checks that throw on error
1231  */
1232 library SafeMath {
1233 
1234   /**
1235   * @dev Multiplies two numbers, throws on overflow.
1236   */
1237   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1238     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1239     // benefit is lost if 'b' is also tested.
1240     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1241     if (a == 0) {
1242       return 0;
1243     }
1244 
1245     c = a * b;
1246     assert(c / a == b);
1247     return c;
1248   }
1249 
1250   /**
1251   * @dev Integer division of two numbers, truncating the quotient.
1252   */
1253   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1254     // assert(b > 0); // Solidity automatically throws when dividing by 0
1255     // uint256 c = a / b;
1256     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1257     return a / b;
1258   }
1259 
1260   /**
1261   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1262   */
1263   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1264     assert(b <= a);
1265     return a - b;
1266   }
1267 
1268   /**
1269   * @dev Adds two numbers, throws on overflow.
1270   */
1271   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1272     c = a + b;
1273     assert(c >= a);
1274     return c;
1275   }
1276 }
1277 
1278 /**
1279  * @title ERC827 interface, an extension of ERC20 token standard
1280  *
1281  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
1282  * methods to transfer value and data and execute calls in transfers and
1283  * approvals.
1284  */
1285 contract ERC827 is ERC20 {
1286 
1287     function approveAndCall(address _spender,uint256 _value,bytes _data) public payable returns(bool);
1288 
1289     function transferAndCall(address _to,uint256 _value,bytes _data) public payable returns(bool);
1290 
1291     function transferFromAndCall(address _from,address _to,uint256 _value,bytes _data) public payable returns(bool);
1292 
1293 }
1294 
1295 /**
1296  * @title ERC827, an extension of ERC20 token standard
1297  *
1298  * @dev Implementation the ERC827, following the ERC20 standard with extra
1299  * methods to transfer value and data and execute calls in transfers and
1300  * approvals. Uses OpenZeppelin StandardToken.
1301  */
1302 contract ERC827Token is ERC827, StandardToken {
1303 
1304   /**
1305    * @dev Addition to ERC20 token methods. It allows to
1306    * approve the transfer of value and execute a call with the sent data.
1307    * Beware that changing an allowance with this method brings the risk that
1308    * someone may use both the old and the new allowance by unfortunate
1309    * transaction ordering. One possible solution to mitigate this race condition
1310    * is to first reduce the spender's allowance to 0 and set the desired value
1311    * afterwards:
1312    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1313    * @param _spender The address that will spend the funds.
1314    * @param _value The amount of tokens to be spent.
1315    * @param _data ABI-encoded contract call to call `_spender` address.
1316    * @return true if the call function was executed successfully
1317    */
1318     function approveAndCall(
1319         address _spender,
1320         uint256 _value,
1321         bytes _data
1322     )
1323     public
1324     payable
1325     returns (bool)
1326     {
1327         require(_spender != address(this));
1328 
1329         super.approve(_spender, _value);
1330 
1331         // solium-disable-next-line security/no-call-value
1332         require(_spender.call.value(msg.value)(_data));
1333 
1334         return true;
1335     }
1336 
1337   /**
1338    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
1339    * address and execute a call with the sent data on the same transaction
1340    * @param _to address The address which you want to transfer to
1341    * @param _value uint256 the amout of tokens to be transfered
1342    * @param _data ABI-encoded contract call to call `_to` address.
1343    * @return true if the call function was executed successfully
1344    */
1345     function transferAndCall(
1346         address _to,
1347         uint256 _value,
1348         bytes _data
1349     )
1350     public
1351     payable
1352     returns (bool)
1353     {
1354         require(_to != address(this));
1355 
1356         super.transfer(_to, _value);
1357 
1358         // solium-disable-next-line security/no-call-value
1359         require(_to.call.value(msg.value)(_data));
1360         return true;
1361     }
1362 
1363   /**
1364    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
1365    * another and make a contract call on the same transaction
1366    * @param _from The address which you want to send tokens from
1367    * @param _to The address which you want to transfer to
1368    * @param _value The amout of tokens to be transferred
1369    * @param _data ABI-encoded contract call to call `_to` address.
1370    * @return true if the call function was executed successfully
1371    */
1372     function transferFromAndCall(
1373         address _from,
1374         address _to,
1375         uint256 _value,
1376         bytes _data
1377     )
1378     public payable returns (bool)
1379     {
1380         require(_to != address(this));
1381 
1382         super.transferFrom(_from, _to, _value);
1383 
1384         // solium-disable-next-line security/no-call-value
1385         require(_to.call.value(msg.value)(_data));
1386         return true;
1387     }
1388 
1389   /**
1390    * @dev Addition to StandardToken methods. Increase the amount of tokens that
1391    * an owner allowed to a spender and execute a call with the sent data.
1392    * approve should be called when allowed[_spender] == 0. To increment
1393    * allowed value is better to use this function to avoid 2 calls (and wait until
1394    * the first transaction is mined)
1395    * From MonolithDAO Token.sol
1396    * @param _spender The address which will spend the funds.
1397    * @param _addedValue The amount of tokens to increase the allowance by.
1398    * @param _data ABI-encoded contract call to call `_spender` address.
1399    */
1400     function increaseApprovalAndCall(
1401         address _spender,
1402         uint _addedValue,
1403         bytes _data
1404     )
1405     public
1406     payable
1407     returns (bool)
1408     {
1409         require(_spender != address(this));
1410 
1411         super.increaseApproval(_spender, _addedValue);
1412 
1413         // solium-disable-next-line security/no-call-value
1414         require(_spender.call.value(msg.value)(_data));
1415 
1416         return true;
1417     }
1418 
1419   /**
1420    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
1421    * an owner allowed to a spender and execute a call with the sent data.
1422    * approve should be called when allowed[_spender] == 0. To decrement
1423    * allowed value is better to use this function to avoid 2 calls (and wait until
1424    * the first transaction is mined)
1425    * From MonolithDAO Token.sol
1426    * @param _spender The address which will spend the funds.
1427    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1428    * @param _data ABI-encoded contract call to call `_spender` address.
1429    */
1430     function decreaseApprovalAndCall(
1431         address _spender,
1432         uint _subtractedValue,
1433         bytes _data
1434     )
1435     public
1436     payable
1437     returns (bool)
1438     {
1439         require(_spender != address(this));
1440 
1441         super.decreaseApproval(_spender, _subtractedValue);
1442 
1443         // solium-disable-next-line security/no-call-value
1444         require(_spender.call.value(msg.value)(_data));
1445 
1446         return true;
1447     }
1448 
1449 }
1450 
1451 /**
1452  * @title DAOToken, base on zeppelin contract.
1453  * @dev ERC20 compatible token. It is a mintable, destructible, burnable token.
1454  */
1455 
1456 contract DAOToken is ERC827Token,MintableToken,BurnableToken {
1457 
1458     string public name;
1459     string public symbol;
1460     // solium-disable-next-line uppercase
1461     uint8 public constant decimals = 18;
1462     uint public cap;
1463 
1464     /**
1465     * @dev Constructor
1466     * @param _name - token name
1467     * @param _symbol - token symbol
1468     * @param _cap - token cap - 0 value means no cap
1469     */
1470     constructor(string _name, string _symbol,uint _cap) public {
1471         name = _name;
1472         symbol = _symbol;
1473         cap = _cap;
1474     }
1475 
1476     /**
1477      * @dev Function to mint tokens
1478      * @param _to The address that will receive the minted tokens.
1479      * @param _amount The amount of tokens to mint.
1480      * @return A boolean that indicates if the operation was successful.
1481      */
1482     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
1483         if (cap > 0)
1484             require(totalSupply_.add(_amount) <= cap);
1485         return super.mint(_to, _amount);
1486     }
1487 }
1488 
1489 /**
1490  * @title Reputation system
1491  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
1492  * A reputation is use to assign influence measure to a DAO'S peers.
1493  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
1494  * The Reputation contract maintain a map of address to reputation value.
1495  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
1496  */
1497 
1498 contract Reputation is Ownable {
1499     using SafeMath for uint;
1500 
1501     mapping (address => uint256) public balances;
1502     uint256 public totalSupply;
1503     uint public decimals = 18;
1504 
1505     // Event indicating minting of reputation to an address.
1506     event Mint(address indexed _to, uint256 _amount);
1507     // Event indicating burning of reputation for an address.
1508     event Burn(address indexed _from, uint256 _amount);
1509 
1510     /**
1511     * @dev return the reputation amount of a given owner
1512     * @param _owner an address of the owner which we want to get his reputation
1513     */
1514     function reputationOf(address _owner) public view returns (uint256 balance) {
1515         return balances[_owner];
1516     }
1517 
1518     /**
1519     * @dev Generates `_amount` of reputation that are assigned to `_to`
1520     * @param _to The address that will be assigned the new reputation
1521     * @param _amount The quantity of reputation to be generated
1522     * @return True if the reputation are generated correctly
1523     */
1524     function mint(address _to, uint _amount)
1525     public
1526     onlyOwner
1527     returns (bool)
1528     {
1529         totalSupply = totalSupply.add(_amount);
1530         balances[_to] = balances[_to].add(_amount);
1531         emit Mint(_to, _amount);
1532         return true;
1533     }
1534 
1535     /**
1536     * @dev Burns `_amount` of reputation from `_from`
1537     * if _amount tokens to burn > balances[_from] the balance of _from will turn to zero.
1538     * @param _from The address that will lose the reputation
1539     * @param _amount The quantity of reputation to burn
1540     * @return True if the reputation are burned correctly
1541     */
1542     function burn(address _from, uint _amount)
1543     public
1544     onlyOwner
1545     returns (bool)
1546     {
1547         uint amountMinted = _amount;
1548         if (balances[_from] < _amount) {
1549             amountMinted = balances[_from];
1550         }
1551         totalSupply = totalSupply.sub(amountMinted);
1552         balances[_from] = balances[_from].sub(amountMinted);
1553         emit Burn(_from, amountMinted);
1554         return true;
1555     }
1556 }
1557 
1558 /**
1559  * @title An Avatar holds tokens, reputation and ether for a controller
1560  */
1561 contract Avatar is Ownable {
1562     bytes32 public orgName;
1563     DAOToken public nativeToken;
1564     Reputation public nativeReputation;
1565 
1566     event GenericAction(address indexed _action, bytes32[] _params);
1567     event SendEther(uint _amountInWei, address indexed _to);
1568     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint _value);
1569     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint _value);
1570     event ExternalTokenIncreaseApproval(StandardToken indexed _externalToken, address _spender, uint _addedValue);
1571     event ExternalTokenDecreaseApproval(StandardToken indexed _externalToken, address _spender, uint _subtractedValue);
1572     event ReceiveEther(address indexed _sender, uint _value);
1573 
1574     /**
1575     * @dev the constructor takes organization name, native token and reputation system
1576     and creates an avatar for a controller
1577     */
1578     constructor(bytes32 _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
1579         orgName = _orgName;
1580         nativeToken = _nativeToken;
1581         nativeReputation = _nativeReputation;
1582     }
1583 
1584     /**
1585     * @dev enables an avatar to receive ethers
1586     */
1587     function() public payable {
1588         emit ReceiveEther(msg.sender, msg.value);
1589     }
1590 
1591     /**
1592     * @dev perform a generic call to an arbitrary contract
1593     * @param _contract  the contract's address to call
1594     * @param _data ABI-encoded contract call to call `_contract` address.
1595     * @return the return bytes of the called contract's function.
1596     */
1597     function genericCall(address _contract,bytes _data) public onlyOwner {
1598         // solium-disable-next-line security/no-low-level-calls
1599         bool result = _contract.call(_data);
1600         // solium-disable-next-line security/no-inline-assembly
1601         assembly {
1602         // Copy the returned data.
1603         returndatacopy(0, 0, returndatasize)
1604 
1605         switch result
1606         // call returns 0 on error.
1607         case 0 { revert(0, returndatasize) }
1608         default { return(0, returndatasize) }
1609         }
1610     }
1611 
1612     /**
1613     * @dev send ethers from the avatar's wallet
1614     * @param _amountInWei amount to send in Wei units
1615     * @param _to send the ethers to this address
1616     * @return bool which represents success
1617     */
1618     function sendEther(uint _amountInWei, address _to) public onlyOwner returns(bool) {
1619         _to.transfer(_amountInWei);
1620         emit SendEther(_amountInWei, _to);
1621         return true;
1622     }
1623 
1624     /**
1625     * @dev external token transfer
1626     * @param _externalToken the token contract
1627     * @param _to the destination address
1628     * @param _value the amount of tokens to transfer
1629     * @return bool which represents success
1630     */
1631     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value)
1632     public onlyOwner returns(bool)
1633     {
1634         _externalToken.transfer(_to, _value);
1635         emit ExternalTokenTransfer(_externalToken, _to, _value);
1636         return true;
1637     }
1638 
1639     /**
1640     * @dev external token transfer from a specific account
1641     * @param _externalToken the token contract
1642     * @param _from the account to spend token from
1643     * @param _to the destination address
1644     * @param _value the amount of tokens to transfer
1645     * @return bool which represents success
1646     */
1647     function externalTokenTransferFrom(
1648         StandardToken _externalToken,
1649         address _from,
1650         address _to,
1651         uint _value
1652     )
1653     public onlyOwner returns(bool)
1654     {
1655         _externalToken.transferFrom(_from, _to, _value);
1656         emit ExternalTokenTransferFrom(_externalToken, _from, _to, _value);
1657         return true;
1658     }
1659 
1660     /**
1661     * @dev increase approval for the spender address to spend a specified amount of tokens
1662     *      on behalf of msg.sender.
1663     * @param _externalToken the address of the Token Contract
1664     * @param _spender address
1665     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1666     * @return bool which represents a success
1667     */
1668     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue)
1669     public onlyOwner returns(bool)
1670     {
1671         _externalToken.increaseApproval(_spender, _addedValue);
1672         emit ExternalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
1673         return true;
1674     }
1675 
1676     /**
1677     * @dev decrease approval for the spender address to spend a specified amount of tokens
1678     *      on behalf of msg.sender.
1679     * @param _externalToken the address of the Token Contract
1680     * @param _spender address
1681     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1682     * @return bool which represents a success
1683     */
1684     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue )
1685     public onlyOwner returns(bool)
1686     {
1687         _externalToken.decreaseApproval(_spender, _subtractedValue);
1688         emit ExternalTokenDecreaseApproval(_externalToken,_spender, _subtractedValue);
1689         return true;
1690     }
1691 
1692 }
1693 
1694 contract UniversalSchemeInterface {
1695 
1696     function updateParameters(bytes32 _hashedParameters) public;
1697 
1698     function getParametersFromController(Avatar _avatar) internal view returns(bytes32);
1699 }
1700 
1701 
1702 /**
1703  * @title Controller contract
1704  * @dev A controller controls the organizations tokens ,reputation and avatar.
1705  * It is subject to a set of schemes and constraints that determine its behavior.
1706  * Each scheme has it own parameters and operation permissions.
1707  */
1708 interface ControllerInterface {
1709 
1710     /**
1711      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1712      * @param  _amount amount of reputation to mint
1713      * @param _to beneficiary address
1714      * @return bool which represents a success
1715     */
1716     function mintReputation(uint256 _amount, address _to,address _avatar)
1717     external
1718     returns(bool);
1719 
1720     /**
1721      * @dev Burns `_amount` of reputation from `_from`
1722      * @param _amount amount of reputation to burn
1723      * @param _from The address that will lose the reputation
1724      * @return bool which represents a success
1725      */
1726     function burnReputation(uint256 _amount, address _from,address _avatar)
1727     external
1728     returns(bool);
1729 
1730     /**
1731      * @dev mint tokens .
1732      * @param  _amount amount of token to mint
1733      * @param _beneficiary beneficiary address
1734      * @param _avatar address
1735      * @return bool which represents a success
1736      */
1737     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
1738     external
1739     returns(bool);
1740 
1741   /**
1742    * @dev register or update a scheme
1743    * @param _scheme the address of the scheme
1744    * @param _paramsHash a hashed configuration of the usage of the scheme
1745    * @param _permissions the permissions the new scheme will have
1746    * @param _avatar address
1747    * @return bool which represents a success
1748    */
1749     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
1750     external
1751     returns(bool);
1752 
1753     /**
1754      * @dev unregister a scheme
1755      * @param _avatar address
1756      * @param _scheme the address of the scheme
1757      * @return bool which represents a success
1758      */
1759     function unregisterScheme(address _scheme,address _avatar)
1760     external
1761     returns(bool);
1762     /**
1763      * @dev unregister the caller's scheme
1764      * @param _avatar address
1765      * @return bool which represents a success
1766      */
1767     function unregisterSelf(address _avatar) external returns(bool);
1768 
1769     function isSchemeRegistered( address _scheme,address _avatar) external view returns(bool);
1770 
1771     function getSchemeParameters(address _scheme,address _avatar) external view returns(bytes32);
1772 
1773     function getGlobalConstraintParameters(address _globalConstraint,address _avatar) external view returns(bytes32);
1774 
1775     function getSchemePermissions(address _scheme,address _avatar) external view returns(bytes4);
1776 
1777     /**
1778      * @dev globalConstraintsCount return the global constraint pre and post count
1779      * @return uint globalConstraintsPre count.
1780      * @return uint globalConstraintsPost count.
1781      */
1782     function globalConstraintsCount(address _avatar) external view returns(uint,uint);
1783 
1784     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar) external view returns(bool);
1785 
1786     /**
1787      * @dev add or update Global Constraint
1788      * @param _globalConstraint the address of the global constraint to be added.
1789      * @param _params the constraint parameters hash.
1790      * @param _avatar the avatar of the organization
1791      * @return bool which represents a success
1792      */
1793     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
1794     external returns(bool);
1795 
1796     /**
1797      * @dev remove Global Constraint
1798      * @param _globalConstraint the address of the global constraint to be remove.
1799      * @param _avatar the organization avatar.
1800      * @return bool which represents a success
1801      */
1802     function removeGlobalConstraint (address _globalConstraint,address _avatar)
1803     external  returns(bool);
1804 
1805   /**
1806     * @dev upgrade the Controller
1807     *      The function will trigger an event 'UpgradeController'.
1808     * @param  _newController the address of the new controller.
1809     * @param _avatar address
1810     * @return bool which represents a success
1811     */
1812     function upgradeController(address _newController,address _avatar)
1813     external returns(bool);
1814 
1815     /**
1816     * @dev perform a generic call to an arbitrary contract
1817     * @param _contract  the contract's address to call
1818     * @param _data ABI-encoded contract call to call `_contract` address.
1819     * @param _avatar the controller's avatar address
1820     * @return bytes32  - the return value of the called _contract's function.
1821     */
1822     function genericCall(address _contract,bytes _data,address _avatar)
1823     external
1824     returns(bytes32);
1825 
1826   /**
1827    * @dev send some ether
1828    * @param _amountInWei the amount of ether (in Wei) to send
1829    * @param _to address of the beneficiary
1830    * @param _avatar address
1831    * @return bool which represents a success
1832    */
1833     function sendEther(uint _amountInWei, address _to,address _avatar)
1834     external returns(bool);
1835 
1836     /**
1837     * @dev send some amount of arbitrary ERC20 Tokens
1838     * @param _externalToken the address of the Token Contract
1839     * @param _to address of the beneficiary
1840     * @param _value the amount of ether (in Wei) to send
1841     * @param _avatar address
1842     * @return bool which represents a success
1843     */
1844     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1845     external
1846     returns(bool);
1847 
1848     /**
1849     * @dev transfer token "from" address "to" address
1850     *      One must to approve the amount of tokens which can be spend from the
1851     *      "from" account.This can be done using externalTokenApprove.
1852     * @param _externalToken the address of the Token Contract
1853     * @param _from address of the account to send from
1854     * @param _to address of the beneficiary
1855     * @param _value the amount of ether (in Wei) to send
1856     * @param _avatar address
1857     * @return bool which represents a success
1858     */
1859     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1860     external
1861     returns(bool);
1862 
1863     /**
1864     * @dev increase approval for the spender address to spend a specified amount of tokens
1865     *      on behalf of msg.sender.
1866     * @param _externalToken the address of the Token Contract
1867     * @param _spender address
1868     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1869     * @param _avatar address
1870     * @return bool which represents a success
1871     */
1872     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1873     external
1874     returns(bool);
1875 
1876     /**
1877     * @dev decrease approval for the spender address to spend a specified amount of tokens
1878     *      on behalf of msg.sender.
1879     * @param _externalToken the address of the Token Contract
1880     * @param _spender address
1881     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1882     * @param _avatar address
1883     * @return bool which represents a success
1884     */
1885     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1886     external
1887     returns(bool);
1888 
1889     /**
1890      * @dev getNativeReputation
1891      * @param _avatar the organization avatar.
1892      * @return organization native reputation
1893      */
1894     function getNativeReputation(address _avatar)
1895     external
1896     view
1897     returns(address);
1898 }
1899 
1900 contract UniversalScheme is Ownable, UniversalSchemeInterface {
1901     bytes32 public hashedParameters; // For other parameters.
1902 
1903     function updateParameters(
1904         bytes32 _hashedParameters
1905     )
1906         public
1907         onlyOwner
1908     {
1909         hashedParameters = _hashedParameters;
1910     }
1911 
1912     /**
1913     *  @dev get the parameters for the current scheme from the controller
1914     */
1915     function getParametersFromController(Avatar _avatar) internal view returns(bytes32) {
1916         return ControllerInterface(_avatar.owner()).getSchemeParameters(this,address(_avatar));
1917     }
1918 }
1919 contract ExecutableInterface {
1920     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool);
1921 }
1922 
1923 interface IntVoteInterface {
1924     //When implementing this interface please do not only override function and modifier,
1925     //but also to keep the modifiers on the overridden functions.
1926     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
1927     modifier votable(bytes32 _proposalId) {revert(); _;}
1928 
1929     event NewProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _numOfChoices, address _proposer, bytes32 _paramsHash);
1930     event ExecuteProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _decision, uint _totalReputation);
1931     event VoteProposal(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter, uint _vote, uint _reputation);
1932     event CancelProposal(bytes32 indexed _proposalId, address indexed _avatar );
1933     event CancelVoting(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter);
1934 
1935     /**
1936      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
1937      * generated by calculating keccak256 of a incremented counter.
1938      * @param _numOfChoices number of voting choices
1939      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
1940      * @param _avatar an address to be sent as the payload to the _executable contract.
1941      * @param _executable This contract will be executed when vote is over.
1942      * @param _proposer address
1943      * @return proposal's id.
1944      */
1945     function propose(
1946         uint _numOfChoices,
1947         bytes32 _proposalParameters,
1948         address _avatar,
1949         ExecutableInterface _executable,
1950         address _proposer
1951         ) external returns(bytes32);
1952 
1953     // Only owned proposals and only the owner:
1954     function cancelProposal(bytes32 _proposalId) external returns(bool);
1955 
1956     // Only owned proposals and only the owner:
1957     function ownerVote(bytes32 _proposalId, uint _vote, address _voter) external returns(bool);
1958 
1959     function vote(bytes32 _proposalId, uint _vote) external returns(bool);
1960 
1961     function voteWithSpecifiedAmounts(
1962         bytes32 _proposalId,
1963         uint _vote,
1964         uint _rep,
1965         uint _token) external returns(bool);
1966 
1967     function cancelVote(bytes32 _proposalId) external;
1968 
1969     //@dev execute check if the proposal has been decided, and if so, execute the proposal
1970     //@param _proposalId the id of the proposal
1971     //@return bool true - the proposal has been executed
1972     //             false - otherwise.
1973     function execute(bytes32 _proposalId) external returns(bool);
1974 
1975     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint);
1976 
1977     function isVotable(bytes32 _proposalId) external view returns(bool);
1978 
1979     /**
1980      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1981      * @param _proposalId the ID of the proposal
1982      * @param _choice the index in the
1983      * @return voted reputation for the given choice
1984      */
1985     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint);
1986 
1987     /**
1988      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1989      * @return bool true or false
1990      */
1991     function isAbstainAllow() external pure returns(bool);
1992 
1993     /**
1994      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1995      * @return min - minimum number of choices
1996                max - maximum number of choices
1997      */
1998     function getAllowedRangeOfChoices() external pure returns(uint min,uint max);
1999 }
2000 
2001 
2002 
2003 
2004 
2005 /**
2006  * @title GenesisProtocol implementation -an organization's voting machine scheme.
2007  */
2008 
2009 
2010 contract GenesisProtocol is IntVoteInterface,UniversalScheme {
2011     using SafeMath for uint;
2012     using RealMath for int216;
2013     using RealMath for int256;
2014     using ECRecovery for bytes32;
2015     using OrderStatisticTree for OrderStatisticTree.Tree;
2016 
2017     enum ProposalState { None ,Closed, Executed, PreBoosted,Boosted,QuietEndingPeriod }
2018     enum ExecutionState { None, PreBoostedTimeOut, PreBoostedBarCrossed, BoostedTimeOut,BoostedBarCrossed }
2019 
2020     //Organization's parameters
2021     struct Parameters {
2022         uint preBoostedVoteRequiredPercentage; // the absolute vote percentages bar.
2023         uint preBoostedVotePeriodLimit; //the time limit for a proposal to be in an absolute voting mode.
2024         uint boostedVotePeriodLimit; //the time limit for a proposal to be in an relative voting mode.
2025         uint thresholdConstA;//constant A for threshold calculation . threshold =A * (e ** (numberOfBoostedProposals/B))
2026         uint thresholdConstB;//constant B for threshold calculation . threshold =A * (e ** (numberOfBoostedProposals/B))
2027         uint minimumStakingFee; //minimum staking fee allowed.
2028         uint quietEndingPeriod; //quite ending period
2029         uint proposingRepRewardConstA;//constant A for calculate proposer reward. proposerReward =(A*(RTotal) +B*(R+ - R-))/1000
2030         uint proposingRepRewardConstB;//constant B for calculate proposing reward.proposerReward =(A*(RTotal) +B*(R+ - R-))/1000
2031         uint stakerFeeRatioForVoters; // The “ratio of stake” to be paid to voters.
2032                                       // All stakers pay a portion of their stake to all voters, stakerFeeRatioForVoters * (s+ + s-).
2033                                       //All voters (pre and during boosting period) divide this portion in proportion to their reputation.
2034         uint votersReputationLossRatio;//Unsuccessful pre booster voters lose votersReputationLossRatio% of their reputation.
2035         uint votersGainRepRatioFromLostRep; //the percentages of the lost reputation which is divided by the successful pre boosted voters,
2036                                             //in proportion to their reputation.
2037                                             //The rest (100-votersGainRepRatioFromLostRep)% of lost reputation is divided between the successful wagers,
2038                                             //in proportion to their stake.
2039         uint daoBountyConst;//The DAO adds up a bounty for successful staker.
2040                             //The bounty formula is: s * daoBountyConst, where s+ is the wager staked for the proposal,
2041                             //and  daoBountyConst is a constant factor that is configurable and changeable by the DAO given.
2042                             //  daoBountyConst should be greater than stakerFeeRatioForVoters and less than 2 * stakerFeeRatioForVoters.
2043         uint daoBountyLimit;//The daoBounty cannot be greater than daoBountyLimit.
2044 
2045 
2046 
2047     }
2048     struct Voter {
2049         uint vote; // YES(1) ,NO(2)
2050         uint reputation; // amount of voter's reputation
2051         bool preBoosted;
2052     }
2053 
2054     struct Staker {
2055         uint vote; // YES(1) ,NO(2)
2056         uint amount; // amount of staker's stake
2057         uint amountForBounty; // amount of staker's stake which will be use for bounty calculation
2058     }
2059 
2060     struct Proposal {
2061         address avatar; // the organization's avatar the proposal is target to.
2062         uint numOfChoices;
2063         ExecutableInterface executable; // will be executed if the proposal will pass
2064         uint votersStakes;
2065         uint submittedTime;
2066         uint boostedPhaseTime; //the time the proposal shift to relative mode.
2067         ProposalState state;
2068         uint winningVote; //the winning vote.
2069         address proposer;
2070         uint currentBoostedVotePeriodLimit;
2071         bytes32 paramsHash;
2072         uint daoBountyRemain;
2073         uint[2] totalStakes;// totalStakes[0] - (amount staked minus fee) - Total number of tokens staked which can be redeemable by stakers.
2074                             // totalStakes[1] - (amount staked) - Total number of redeemable tokens.
2075         //      vote      reputation
2076         mapping(uint    =>  uint     ) votes;
2077         //      vote      reputation
2078         mapping(uint    =>  uint     ) preBoostedVotes;
2079         //      address     voter
2080         mapping(address =>  Voter    ) voters;
2081         //      vote        stakes
2082         mapping(uint    =>  uint     ) stakes;
2083         //      address  staker
2084         mapping(address  => Staker   ) stakers;
2085     }
2086 
2087     event GPExecuteProposal(bytes32 indexed _proposalId, ExecutionState _executionState);
2088     event Stake(bytes32 indexed _proposalId, address indexed _avatar, address indexed _staker,uint _vote,uint _amount);
2089     event Redeem(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
2090     event RedeemDaoBounty(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
2091     event RedeemReputation(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
2092 
2093     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
2094     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
2095 
2096     mapping(bytes=>bool) stakeSignatures; //stake signatures
2097 
2098     uint constant public NUM_OF_CHOICES = 2;
2099     uint constant public NO = 2;
2100     uint constant public YES = 1;
2101     uint public proposalsCnt; // Total number of proposals
2102     mapping(address=>uint) orgBoostedProposalsCnt;
2103     StandardToken public stakingToken;
2104     mapping(address=>OrderStatisticTree.Tree) proposalsExpiredTimes; //proposals expired times
2105 
2106     /**
2107      * @dev Constructor
2108      */
2109     constructor(StandardToken _stakingToken) public
2110     {
2111         stakingToken = _stakingToken;
2112     }
2113 
2114   /**
2115    * @dev Check that the proposal is votable (open and not executed yet)
2116    */
2117     modifier votable(bytes32 _proposalId) {
2118         require(_isVotable(_proposalId));
2119         _;
2120     }
2121 
2122     /**
2123      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
2124      * generated by calculating keccak256 of a incremented counter.
2125      * @param _numOfChoices number of voting choices
2126      * @param _avatar an address to be sent as the payload to the _executable contract.
2127      * @param _executable This contract will be executed when vote is over.
2128      * @param _proposer address
2129      * @return proposal's id.
2130      */
2131     function propose(uint _numOfChoices, bytes32 , address _avatar, ExecutableInterface _executable,address _proposer)
2132         external
2133         returns(bytes32)
2134     {
2135           // Check valid params and number of choices:
2136         require(_numOfChoices == NUM_OF_CHOICES);
2137         require(ExecutableInterface(_executable) != address(0));
2138         //Check parameters existence.
2139         bytes32 paramsHash = getParametersFromController(Avatar(_avatar));
2140 
2141         require(parameters[paramsHash].preBoostedVoteRequiredPercentage > 0);
2142         // Generate a unique ID:
2143         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
2144         proposalsCnt++;
2145         // Open proposal:
2146         Proposal memory proposal;
2147         proposal.numOfChoices = _numOfChoices;
2148         proposal.avatar = _avatar;
2149         proposal.executable = _executable;
2150         proposal.state = ProposalState.PreBoosted;
2151         // solium-disable-next-line security/no-block-members
2152         proposal.submittedTime = now;
2153         proposal.currentBoostedVotePeriodLimit = parameters[paramsHash].boostedVotePeriodLimit;
2154         proposal.proposer = _proposer;
2155         proposal.winningVote = NO;
2156         proposal.paramsHash = paramsHash;
2157         proposals[proposalId] = proposal;
2158         emit NewProposal(proposalId, _avatar, _numOfChoices, _proposer, paramsHash);
2159         return proposalId;
2160     }
2161 
2162   /**
2163    * @dev Cancel a proposal, only the owner can call this function and only if allowOwner flag is true.
2164    */
2165     function cancelProposal(bytes32 ) external returns(bool) {
2166         //This is not allowed.
2167         return false;
2168     }
2169 
2170     /**
2171      * @dev staking function
2172      * @param _proposalId id of the proposal
2173      * @param _vote  NO(2) or YES(1).
2174      * @param _amount the betting amount
2175      * @return bool true - the proposal has been executed
2176      *              false - otherwise.
2177      */
2178     function stake(bytes32 _proposalId, uint _vote, uint _amount) external returns(bool) {
2179         return _stake(_proposalId,_vote,_amount,msg.sender);
2180     }
2181 
2182     // Digest describing the data the user signs according EIP 712.
2183     // Needs to match what is passed to Metamask.
2184     bytes32 public constant DELEGATION_HASH_EIP712 =
2185     keccak256(abi.encodePacked("address GenesisProtocolAddress","bytes32 ProposalId", "uint Vote","uint AmountToStake","uint Nonce"));
2186     // web3.eth.sign prefix
2187     string public constant ETH_SIGN_PREFIX= "\x19Ethereum Signed Message:\n32";
2188 
2189     /**
2190      * @dev stakeWithSignature function
2191      * @param _proposalId id of the proposal
2192      * @param _vote  NO(2) or YES(1).
2193      * @param _amount the betting amount
2194      * @param _nonce nonce value ,it is part of the signature to ensure that
2195               a signature can be received only once.
2196      * @param _signatureType signature type
2197               1 - for web3.eth.sign
2198               2 - for eth_signTypedData according to EIP #712.
2199      * @param _signature  - signed data by the staker
2200      * @return bool true - the proposal has been executed
2201      *              false - otherwise.
2202      */
2203     function stakeWithSignature(
2204         bytes32 _proposalId,
2205         uint _vote,
2206         uint _amount,
2207         uint _nonce,
2208         uint _signatureType,
2209         bytes _signature
2210         )
2211         external
2212         returns(bool)
2213         {
2214         require(stakeSignatures[_signature] == false);
2215         // Recreate the digest the user signed
2216         bytes32 delegationDigest;
2217         if (_signatureType == 2) {
2218             delegationDigest = keccak256(
2219                 abi.encodePacked(
2220                     DELEGATION_HASH_EIP712, keccak256(
2221                         abi.encodePacked(
2222                            address(this),
2223                           _proposalId,
2224                           _vote,
2225                           _amount,
2226                           _nonce)))
2227             );
2228         } else {
2229             delegationDigest = keccak256(
2230                 abi.encodePacked(
2231                     ETH_SIGN_PREFIX, keccak256(
2232                         abi.encodePacked(
2233                             address(this),
2234                            _proposalId,
2235                            _vote,
2236                            _amount,
2237                            _nonce)))
2238             );
2239         }
2240         address staker = delegationDigest.recover(_signature);
2241         //a garbage staker address due to wrong signature will revert due to lack of approval and funds.
2242         require(staker!=address(0));
2243         stakeSignatures[_signature] = true;
2244         return _stake(_proposalId,_vote,_amount,staker);
2245     }
2246 
2247   /**
2248    * @dev voting function
2249    * @param _proposalId id of the proposal
2250    * @param _vote NO(2) or YES(1).
2251    * @return bool true - the proposal has been executed
2252    *              false - otherwise.
2253    */
2254     function vote(bytes32 _proposalId, uint _vote) external votable(_proposalId) returns(bool) {
2255         return internalVote(_proposalId, msg.sender, _vote, 0);
2256     }
2257 
2258   /**
2259    * @dev voting function with owner functionality (can vote on behalf of someone else)
2260    * @return bool true - the proposal has been executed
2261    *              false - otherwise.
2262    */
2263     function ownerVote(bytes32 , uint , address ) external returns(bool) {
2264       //This is not allowed.
2265         return false;
2266     }
2267 
2268     function voteWithSpecifiedAmounts(bytes32 _proposalId,uint _vote,uint _rep,uint) external votable(_proposalId) returns(bool) {
2269         return internalVote(_proposalId,msg.sender,_vote,_rep);
2270     }
2271 
2272   /**
2273    * @dev Cancel the vote of the msg.sender.
2274    * cancel vote is not allow in genesisProtocol so this function doing nothing.
2275    * This function is here in order to comply to the IntVoteInterface .
2276    */
2277     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
2278        //this is not allowed
2279         return;
2280     }
2281 
2282   /**
2283     * @dev getNumberOfChoices returns the number of choices possible in this proposal
2284     * @param _proposalId the ID of the proposals
2285     * @return uint that contains number of choices
2286     */
2287     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint) {
2288         return proposals[_proposalId].numOfChoices;
2289     }
2290 
2291     /**
2292      * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
2293      * @param _proposalId the ID of the proposal
2294      * @param _voter the address of the voter
2295      * @return uint vote - the voters vote
2296      *        uint reputation - amount of reputation committed by _voter to _proposalId
2297      */
2298     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
2299         Voter memory voter = proposals[_proposalId].voters[_voter];
2300         return (voter.vote, voter.reputation);
2301     }
2302 
2303     /**
2304     * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
2305     * @param _proposalId the ID of the proposal
2306     * @param _choice the index in the
2307     * @return voted reputation for the given choice
2308     */
2309     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint) {
2310         return proposals[_proposalId].votes[_choice];
2311     }
2312 
2313     /**
2314     * @dev isVotable check if the proposal is votable
2315     * @param _proposalId the ID of the proposal
2316     * @return bool true or false
2317     */
2318     function isVotable(bytes32 _proposalId) external view returns(bool) {
2319         return _isVotable(_proposalId);
2320     }
2321 
2322     /**
2323     * @dev proposalStatus return the total votes and stakes for a given proposal
2324     * @param _proposalId the ID of the proposal
2325     * @return uint preBoostedVotes YES
2326     * @return uint preBoostedVotes NO
2327     * @return uint stakersStakes
2328     * @return uint totalRedeemableStakes
2329     * @return uint total stakes YES
2330     * @return uint total stakes NO
2331     */
2332     function proposalStatus(bytes32 _proposalId) external view returns(uint, uint, uint ,uint, uint ,uint) {
2333         return (
2334                 proposals[_proposalId].preBoostedVotes[YES],
2335                 proposals[_proposalId].preBoostedVotes[NO],
2336                 proposals[_proposalId].totalStakes[0],
2337                 proposals[_proposalId].totalStakes[1],
2338                 proposals[_proposalId].stakes[YES],
2339                 proposals[_proposalId].stakes[NO]
2340         );
2341     }
2342 
2343   /**
2344     * @dev proposalAvatar return the avatar for a given proposal
2345     * @param _proposalId the ID of the proposal
2346     * @return uint total reputation supply
2347     */
2348     function proposalAvatar(bytes32 _proposalId) external view returns(address) {
2349         return (proposals[_proposalId].avatar);
2350     }
2351 
2352   /**
2353     * @dev scoreThresholdParams return the score threshold params for a given
2354     * organization.
2355     * @param _avatar the organization's avatar
2356     * @return uint thresholdConstA
2357     * @return uint thresholdConstB
2358     */
2359     function scoreThresholdParams(address _avatar) external view returns(uint,uint) {
2360         bytes32 paramsHash = getParametersFromController(Avatar(_avatar));
2361         Parameters memory params = parameters[paramsHash];
2362         return (params.thresholdConstA,params.thresholdConstB);
2363     }
2364 
2365     /**
2366       * @dev getStaker return the vote and stake amount for a given proposal and staker
2367       * @param _proposalId the ID of the proposal
2368       * @param _staker staker address
2369       * @return uint vote
2370       * @return uint amount
2371     */
2372     function getStaker(bytes32 _proposalId,address _staker) external view returns(uint,uint) {
2373         return (proposals[_proposalId].stakers[_staker].vote,proposals[_proposalId].stakers[_staker].amount);
2374     }
2375 
2376     /**
2377       * @dev state return the state for a given proposal
2378       * @param _proposalId the ID of the proposal
2379       * @return ProposalState proposal state
2380     */
2381     function state(bytes32 _proposalId) external view returns(ProposalState) {
2382         return proposals[_proposalId].state;
2383     }
2384 
2385     /**
2386     * @dev winningVote return the winningVote for a given proposal
2387     * @param _proposalId the ID of the proposal
2388     * @return uint winningVote
2389     */
2390     function winningVote(bytes32 _proposalId) external view returns(uint) {
2391         return proposals[_proposalId].winningVote;
2392     }
2393 
2394    /**
2395     * @dev isAbstainAllow returns if the voting machine allow abstain (0)
2396     * @return bool true or false
2397     */
2398     function isAbstainAllow() external pure returns(bool) {
2399         return false;
2400     }
2401 
2402     /**
2403      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
2404      * @return min - minimum number of choices
2405                max - maximum number of choices
2406      */
2407     function getAllowedRangeOfChoices() external pure returns(uint min,uint max) {
2408         return (NUM_OF_CHOICES,NUM_OF_CHOICES);
2409     }
2410 
2411     /**
2412     * @dev execute check if the proposal has been decided, and if so, execute the proposal
2413     * @param _proposalId the id of the proposal
2414     * @return bool true - the proposal has been executed
2415     *              false - otherwise.
2416    */
2417     function execute(bytes32 _proposalId) external votable(_proposalId) returns(bool) {
2418         return _execute(_proposalId);
2419     }
2420 
2421     /**
2422      * @dev redeem a reward for a successful stake, vote or proposing.
2423      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
2424      * users to redeem on behalf of someone else.
2425      * @param _proposalId the ID of the proposal
2426      * @param _beneficiary - the beneficiary address
2427      * @return rewards -
2428      *         rewards[0] - stakerTokenAmount
2429      *         rewards[1] - stakerReputationAmount
2430      *         rewards[2] - voterTokenAmount
2431      *         rewards[3] - voterReputationAmount
2432      *         rewards[4] - proposerReputationAmount
2433      * @return reputation - redeem reputation
2434      */
2435     function redeem(bytes32 _proposalId,address _beneficiary) public returns (uint[5] rewards) {
2436         Proposal storage proposal = proposals[_proposalId];
2437         require((proposal.state == ProposalState.Executed) || (proposal.state == ProposalState.Closed),"wrong proposal state");
2438         Parameters memory params = parameters[proposal.paramsHash];
2439         uint amount;
2440         uint reputation;
2441         uint lostReputation;
2442         if (proposal.winningVote == YES) {
2443             lostReputation = proposal.preBoostedVotes[NO];
2444         } else {
2445             lostReputation = proposal.preBoostedVotes[YES];
2446         }
2447         lostReputation = (lostReputation * params.votersReputationLossRatio)/100;
2448         //as staker
2449         Staker storage staker = proposal.stakers[_beneficiary];
2450         if ((staker.amount>0) &&
2451              (staker.vote == proposal.winningVote)) {
2452             uint totalWinningStakes = proposal.stakes[proposal.winningVote];
2453             if (totalWinningStakes != 0) {
2454                 rewards[0] = (staker.amount * proposal.totalStakes[0]) / totalWinningStakes;
2455             }
2456             if (proposal.state != ProposalState.Closed) {
2457                 rewards[1] = (staker.amount * ( lostReputation - ((lostReputation * params.votersGainRepRatioFromLostRep)/100)))/proposal.stakes[proposal.winningVote];
2458             }
2459             staker.amount = 0;
2460         }
2461         //as voter
2462         Voter storage voter = proposal.voters[_beneficiary];
2463         if ((voter.reputation != 0 ) && (voter.preBoosted)) {
2464             uint preBoostedVotes = proposal.preBoostedVotes[YES] + proposal.preBoostedVotes[NO];
2465             if (preBoostedVotes>0) {
2466                 rewards[2] = ((proposal.votersStakes * voter.reputation) / preBoostedVotes);
2467             }
2468             if (proposal.state == ProposalState.Closed) {
2469               //give back reputation for the voter
2470                 rewards[3] = ((voter.reputation * params.votersReputationLossRatio)/100);
2471             } else if (proposal.winningVote == voter.vote ) {
2472                 rewards[3] = (((voter.reputation * params.votersReputationLossRatio)/100) +
2473                 (((voter.reputation * lostReputation * params.votersGainRepRatioFromLostRep)/100)/preBoostedVotes));
2474             }
2475             voter.reputation = 0;
2476         }
2477         //as proposer
2478         if ((proposal.proposer == _beneficiary)&&(proposal.winningVote == YES)&&(proposal.proposer != address(0))) {
2479             rewards[4] = (params.proposingRepRewardConstA.mul(proposal.votes[YES]+proposal.votes[NO]) + params.proposingRepRewardConstB.mul(proposal.votes[YES]-proposal.votes[NO]))/1000;
2480             proposal.proposer = 0;
2481         }
2482         amount = rewards[0] + rewards[2];
2483         reputation = rewards[1] + rewards[3] + rewards[4];
2484         if (amount != 0) {
2485             proposal.totalStakes[1] = proposal.totalStakes[1].sub(amount);
2486             require(stakingToken.transfer(_beneficiary, amount));
2487             emit Redeem(_proposalId,proposal.avatar,_beneficiary,amount);
2488         }
2489         if (reputation != 0 ) {
2490             ControllerInterface(Avatar(proposal.avatar).owner()).mintReputation(reputation,_beneficiary,proposal.avatar);
2491             emit RedeemReputation(_proposalId,proposal.avatar,_beneficiary,reputation);
2492         }
2493     }
2494 
2495     /**
2496      * @dev redeemDaoBounty a reward for a successful stake, vote or proposing.
2497      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
2498      * users to redeem on behalf of someone else.
2499      * @param _proposalId the ID of the proposal
2500      * @param _beneficiary - the beneficiary address
2501      * @return redeemedAmount - redeem token amount
2502      * @return potentialAmount - potential redeem token amount(if there is enough tokens bounty at the avatar )
2503      */
2504     function redeemDaoBounty(bytes32 _proposalId,address _beneficiary) public returns(uint redeemedAmount,uint potentialAmount) {
2505         Proposal storage proposal = proposals[_proposalId];
2506         require((proposal.state == ProposalState.Executed) || (proposal.state == ProposalState.Closed));
2507         uint totalWinningStakes = proposal.stakes[proposal.winningVote];
2508         if (
2509           // solium-disable-next-line operator-whitespace
2510             (proposal.stakers[_beneficiary].amountForBounty>0)&&
2511             (proposal.stakers[_beneficiary].vote == proposal.winningVote)&&
2512             (proposal.winningVote == YES)&&
2513             (totalWinningStakes != 0))
2514         {
2515             //as staker
2516             Parameters memory params = parameters[proposal.paramsHash];
2517             uint beneficiaryLimit = (proposal.stakers[_beneficiary].amountForBounty.mul(params.daoBountyLimit)) / totalWinningStakes;
2518             potentialAmount = (params.daoBountyConst.mul(proposal.stakers[_beneficiary].amountForBounty))/100;
2519             if (potentialAmount > beneficiaryLimit) {
2520                 potentialAmount = beneficiaryLimit;
2521             }
2522         }
2523         if ((potentialAmount != 0)&&(stakingToken.balanceOf(proposal.avatar) >= potentialAmount)) {
2524             proposal.daoBountyRemain = proposal.daoBountyRemain.sub(potentialAmount);
2525             require(ControllerInterface(Avatar(proposal.avatar).owner()).externalTokenTransfer(stakingToken,_beneficiary,potentialAmount,proposal.avatar));
2526             proposal.stakers[_beneficiary].amountForBounty = 0;
2527             redeemedAmount = potentialAmount;
2528             emit RedeemDaoBounty(_proposalId,proposal.avatar,_beneficiary,redeemedAmount);
2529         }
2530     }
2531 
2532     /**
2533      * @dev shouldBoost check if a proposal should be shifted to boosted phase.
2534      * @param _proposalId the ID of the proposal
2535      * @return bool true or false.
2536      */
2537     function shouldBoost(bytes32 _proposalId) public view returns(bool) {
2538         Proposal memory proposal = proposals[_proposalId];
2539         return (_score(_proposalId) >= threshold(proposal.paramsHash,proposal.avatar));
2540     }
2541 
2542     /**
2543      * @dev score return the proposal score
2544      * @param _proposalId the ID of the proposal
2545      * @return uint proposal score.
2546      */
2547     function score(bytes32 _proposalId) public view returns(int) {
2548         return _score(_proposalId);
2549     }
2550 
2551     /**
2552      * @dev getBoostedProposalsCount return the number of boosted proposal for an organization
2553      * @param _avatar the organization avatar
2554      * @return uint number of boosted proposals
2555      */
2556     function getBoostedProposalsCount(address _avatar) public view returns(uint) {
2557         uint expiredProposals;
2558         if (proposalsExpiredTimes[_avatar].count() != 0) {
2559           // solium-disable-next-line security/no-block-members
2560             expiredProposals = proposalsExpiredTimes[_avatar].rank(now);
2561         }
2562         return orgBoostedProposalsCnt[_avatar].sub(expiredProposals);
2563     }
2564 
2565     /**
2566      * @dev threshold return the organization's score threshold which required by
2567      * a proposal to shift to boosted state.
2568      * This threshold is dynamically set and it depend on the number of boosted proposal.
2569      * @param _avatar the organization avatar
2570      * @param _paramsHash the organization parameters hash
2571      * @return int organization's score threshold.
2572      */
2573     function threshold(bytes32 _paramsHash,address _avatar) public view returns(int) {
2574         uint boostedProposals = getBoostedProposalsCount(_avatar);
2575         int216 e = 2;
2576 
2577         Parameters memory params = parameters[_paramsHash];
2578         require(params.thresholdConstB > 0,"should be a valid parameter hash");
2579         int256 power = int216(boostedProposals).toReal().div(int216(params.thresholdConstB).toReal());
2580 
2581         if (power.fromReal() > 100 ) {
2582             power = int216(100).toReal();
2583         }
2584         int256 res = int216(params.thresholdConstA).toReal().mul(e.toReal().pow(power));
2585         return res.fromReal();
2586     }
2587 
2588     /**
2589      * @dev hash the parameters, save them if necessary, and return the hash value
2590      * @param _params a parameters array
2591      *    _params[0] - _preBoostedVoteRequiredPercentage,
2592      *    _params[1] - _preBoostedVotePeriodLimit, //the time limit for a proposal to be in an absolute voting mode.
2593      *    _params[2] -_boostedVotePeriodLimit, //the time limit for a proposal to be in an relative voting mode.
2594      *    _params[3] -_thresholdConstA
2595      *    _params[4] -_thresholdConstB
2596      *    _params[5] -_minimumStakingFee
2597      *    _params[6] -_quietEndingPeriod
2598      *    _params[7] -_proposingRepRewardConstA
2599      *    _params[8] -_proposingRepRewardConstB
2600      *    _params[9] -_stakerFeeRatioForVoters
2601      *    _params[10] -_votersReputationLossRatio
2602      *    _params[11] -_votersGainRepRatioFromLostRep
2603      *    _params[12] - _daoBountyConst
2604      *    _params[13] - _daoBountyLimit
2605     */
2606     function setParameters(
2607         uint[14] _params //use array here due to stack too deep issue.
2608     )
2609     public
2610     returns(bytes32)
2611     {
2612         require(_params[0] <= 100 && _params[0] > 0,"0 < preBoostedVoteRequiredPercentage <= 100");
2613         require(_params[4] > 0 && _params[4] <= 100000000,"0 < thresholdConstB < 100000000 ");
2614         require(_params[3] <= 100000000 ether,"thresholdConstA <= 100000000 wei");
2615         require(_params[9] <= 100,"stakerFeeRatioForVoters <= 100");
2616         require(_params[10] <= 100,"votersReputationLossRatio <= 100");
2617         require(_params[11] <= 100,"votersGainRepRatioFromLostRep <= 100");
2618         require(_params[2] >= _params[6],"boostedVotePeriodLimit >= quietEndingPeriod");
2619         require(_params[7] <= 100000000,"proposingRepRewardConstA <= 100000000");
2620         require(_params[8] <= 100000000,"proposingRepRewardConstB <= 100000000");
2621         require(_params[12] <= (2 * _params[9]),"daoBountyConst <= 2 * stakerFeeRatioForVoters");
2622         require(_params[12] >= _params[9],"daoBountyConst >= stakerFeeRatioForVoters");
2623 
2624 
2625         bytes32 paramsHash = getParametersHash(_params);
2626         parameters[paramsHash] = Parameters({
2627             preBoostedVoteRequiredPercentage: _params[0],
2628             preBoostedVotePeriodLimit: _params[1],
2629             boostedVotePeriodLimit: _params[2],
2630             thresholdConstA:_params[3],
2631             thresholdConstB:_params[4],
2632             minimumStakingFee: _params[5],
2633             quietEndingPeriod: _params[6],
2634             proposingRepRewardConstA: _params[7],
2635             proposingRepRewardConstB:_params[8],
2636             stakerFeeRatioForVoters:_params[9],
2637             votersReputationLossRatio:_params[10],
2638             votersGainRepRatioFromLostRep:_params[11],
2639             daoBountyConst:_params[12],
2640             daoBountyLimit:_params[13]
2641         });
2642         return paramsHash;
2643     }
2644 
2645   /**
2646    * @dev hashParameters returns a hash of the given parameters
2647    */
2648     function getParametersHash(
2649         uint[14] _params) //use array here due to stack too deep issue.
2650         public
2651         pure
2652         returns(bytes32)
2653         {
2654         return keccak256(
2655             abi.encodePacked(
2656             _params[0],
2657             _params[1],
2658             _params[2],
2659             _params[3],
2660             _params[4],
2661             _params[5],
2662             _params[6],
2663             _params[7],
2664             _params[8],
2665             _params[9],
2666             _params[10],
2667             _params[11],
2668             _params[12],
2669             _params[13]));
2670     }
2671 
2672     /**
2673     * @dev execute check if the proposal has been decided, and if so, execute the proposal
2674     * @param _proposalId the id of the proposal
2675     * @return bool true - the proposal has been executed
2676     *              false - otherwise.
2677    */
2678     function _execute(bytes32 _proposalId) internal votable(_proposalId) returns(bool) {
2679         Proposal storage proposal = proposals[_proposalId];
2680         Parameters memory params = parameters[proposal.paramsHash];
2681         Proposal memory tmpProposal = proposal;
2682         uint totalReputation = Avatar(proposal.avatar).nativeReputation().totalSupply();
2683         uint executionBar = totalReputation * params.preBoostedVoteRequiredPercentage/100;
2684         ExecutionState executionState = ExecutionState.None;
2685 
2686         if (proposal.state == ProposalState.PreBoosted) {
2687             // solium-disable-next-line security/no-block-members
2688             if ((now - proposal.submittedTime) >= params.preBoostedVotePeriodLimit) {
2689                 proposal.state = ProposalState.Closed;
2690                 proposal.winningVote = NO;
2691                 executionState = ExecutionState.PreBoostedTimeOut;
2692              } else if (proposal.votes[proposal.winningVote] > executionBar) {
2693               // someone crossed the absolute vote execution bar.
2694                 proposal.state = ProposalState.Executed;
2695                 executionState = ExecutionState.PreBoostedBarCrossed;
2696                } else if ( shouldBoost(_proposalId)) {
2697                 //change proposal mode to boosted mode.
2698                 proposal.state = ProposalState.Boosted;
2699                 // solium-disable-next-line security/no-block-members
2700                 proposal.boostedPhaseTime = now;
2701                 proposalsExpiredTimes[proposal.avatar].insert(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
2702                 orgBoostedProposalsCnt[proposal.avatar]++;
2703               }
2704            }
2705 
2706         if ((proposal.state == ProposalState.Boosted) ||
2707             (proposal.state == ProposalState.QuietEndingPeriod)) {
2708             // solium-disable-next-line security/no-block-members
2709             if ((now - proposal.boostedPhaseTime) >= proposal.currentBoostedVotePeriodLimit) {
2710                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
2711                 orgBoostedProposalsCnt[tmpProposal.avatar] = orgBoostedProposalsCnt[tmpProposal.avatar].sub(1);
2712                 proposal.state = ProposalState.Executed;
2713                 executionState = ExecutionState.BoostedTimeOut;
2714              } else if (proposal.votes[proposal.winningVote] > executionBar) {
2715                // someone crossed the absolute vote execution bar.
2716                 orgBoostedProposalsCnt[tmpProposal.avatar] = orgBoostedProposalsCnt[tmpProposal.avatar].sub(1);
2717                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
2718                 proposal.state = ProposalState.Executed;
2719                 executionState = ExecutionState.BoostedBarCrossed;
2720             }
2721        }
2722         if (executionState != ExecutionState.None) {
2723             if (proposal.winningVote == YES) {
2724                 uint daoBountyRemain = (params.daoBountyConst.mul(proposal.stakes[proposal.winningVote]))/100;
2725                 if (daoBountyRemain > params.daoBountyLimit) {
2726                     daoBountyRemain = params.daoBountyLimit;
2727                 }
2728                 proposal.daoBountyRemain = daoBountyRemain;
2729             }
2730             emit ExecuteProposal(_proposalId, proposal.avatar, proposal.winningVote, totalReputation);
2731             emit GPExecuteProposal(_proposalId, executionState);
2732             (tmpProposal.executable).execute(_proposalId, tmpProposal.avatar, int(proposal.winningVote));
2733         }
2734         return (executionState != ExecutionState.None);
2735     }
2736 
2737     /**
2738      * @dev staking function
2739      * @param _proposalId id of the proposal
2740      * @param _vote  NO(2) or YES(1).
2741      * @param _amount the betting amount
2742      * @param _staker the staker address
2743      * @return bool true - the proposal has been executed
2744      *              false - otherwise.
2745      */
2746     function _stake(bytes32 _proposalId, uint _vote, uint _amount,address _staker) internal returns(bool) {
2747         // 0 is not a valid vote.
2748 
2749         require(_vote <= NUM_OF_CHOICES && _vote > 0);
2750         require(_amount > 0);
2751         if (_execute(_proposalId)) {
2752             return true;
2753         }
2754 
2755         Proposal storage proposal = proposals[_proposalId];
2756 
2757         if (proposal.state != ProposalState.PreBoosted) {
2758             return false;
2759         }
2760 
2761         // enable to increase stake only on the previous stake vote
2762         Staker storage staker = proposal.stakers[_staker];
2763         if ((staker.amount > 0) && (staker.vote != _vote)) {
2764             return false;
2765         }
2766 
2767         uint amount = _amount;
2768         Parameters memory params = parameters[proposal.paramsHash];
2769         require(amount >= params.minimumStakingFee);
2770         require(stakingToken.transferFrom(_staker, address(this), amount));
2771         proposal.totalStakes[1] = proposal.totalStakes[1].add(amount); //update totalRedeemableStakes
2772         staker.amount += amount;
2773         staker.amountForBounty = staker.amount;
2774         staker.vote = _vote;
2775 
2776         proposal.votersStakes += (params.stakerFeeRatioForVoters * amount)/100;
2777         proposal.stakes[_vote] = amount.add(proposal.stakes[_vote]);
2778         amount = amount - ((params.stakerFeeRatioForVoters*amount)/100);
2779 
2780         proposal.totalStakes[0] = amount.add(proposal.totalStakes[0]);
2781       // Event:
2782         emit Stake(_proposalId, proposal.avatar, _staker, _vote, _amount);
2783       // execute the proposal if this vote was decisive:
2784         return _execute(_proposalId);
2785     }
2786 
2787     /**
2788      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
2789      * @param _proposalId id of the proposal
2790      * @param _voter used in case the vote is cast for someone else
2791      * @param _vote a value between 0 to and the proposal's number of choices.
2792      * @param _rep how many reputation the voter would like to stake for this vote.
2793      *         if  _rep==0 so the voter full reputation will be use.
2794      * @return true in case of proposal execution otherwise false
2795      * throws if proposal is not open or if it has been executed
2796      * NB: executes the proposal if a decision has been reached
2797      */
2798     function internalVote(bytes32 _proposalId, address _voter, uint _vote, uint _rep) internal returns(bool) {
2799         // 0 is not a valid vote.
2800         require(_vote <= NUM_OF_CHOICES && _vote > 0,"0 < _vote <= 2");
2801         if (_execute(_proposalId)) {
2802             return true;
2803         }
2804 
2805         Parameters memory params = parameters[proposals[_proposalId].paramsHash];
2806         Proposal storage proposal = proposals[_proposalId];
2807 
2808         // Check voter has enough reputation:
2809         uint reputation = Avatar(proposal.avatar).nativeReputation().reputationOf(_voter);
2810         require(reputation >= _rep);
2811         uint rep = _rep;
2812         if (rep == 0) {
2813             rep = reputation;
2814         }
2815         // If this voter has already voted, return false.
2816         if (proposal.voters[_voter].reputation != 0) {
2817             return false;
2818         }
2819         // The voting itself:
2820         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
2821         //check if the current winningVote changed or there is a tie.
2822         //for the case there is a tie the current winningVote set to NO.
2823         if ((proposal.votes[_vote] > proposal.votes[proposal.winningVote]) ||
2824            ((proposal.votes[NO] == proposal.votes[proposal.winningVote]) &&
2825              proposal.winningVote == YES))
2826         {
2827            // solium-disable-next-line security/no-block-members
2828             uint _now = now;
2829             if ((proposal.state == ProposalState.QuietEndingPeriod) ||
2830                ((proposal.state == ProposalState.Boosted) && ((_now - proposal.boostedPhaseTime) >= (params.boostedVotePeriodLimit - params.quietEndingPeriod)))) {
2831                 //quietEndingPeriod
2832                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
2833                 if (proposal.state != ProposalState.QuietEndingPeriod) {
2834                     proposal.currentBoostedVotePeriodLimit = params.quietEndingPeriod;
2835                     proposal.state = ProposalState.QuietEndingPeriod;
2836                 }
2837                 proposal.boostedPhaseTime = _now;
2838                 proposalsExpiredTimes[proposal.avatar].insert(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
2839             }
2840             proposal.winningVote = _vote;
2841         }
2842         proposal.voters[_voter] = Voter({
2843             reputation: rep,
2844             vote: _vote,
2845             preBoosted:(proposal.state == ProposalState.PreBoosted)
2846         });
2847         if (proposal.state != ProposalState.Boosted) {
2848             proposal.preBoostedVotes[_vote] = rep.add(proposal.preBoostedVotes[_vote]);
2849             uint reputationDeposit = (params.votersReputationLossRatio * rep)/100;
2850             ControllerInterface(Avatar(proposal.avatar).owner()).burnReputation(reputationDeposit,_voter,proposal.avatar);
2851         }
2852         // Event:
2853         emit VoteProposal(_proposalId, proposal.avatar, _voter, _vote, rep);
2854         // execute the proposal if this vote was decisive:
2855         return _execute(_proposalId);
2856     }
2857 
2858     /**
2859      * @dev _score return the proposal score
2860      * For dual choice proposal S = (S+) - (S-)
2861      * @param _proposalId the ID of the proposal
2862      * @return int proposal score.
2863      */
2864     function _score(bytes32 _proposalId) private view returns(int) {
2865         Proposal storage proposal = proposals[_proposalId];
2866         return int(proposal.stakes[YES]) - int(proposal.stakes[NO]);
2867     }
2868 
2869     /**
2870       * @dev _isVotable check if the proposal is votable
2871       * @param _proposalId the ID of the proposal
2872       * @return bool true or false
2873     */
2874     function _isVotable(bytes32 _proposalId) private view returns(bool) {
2875         ProposalState pState = proposals[_proposalId].state;
2876         return ((pState == ProposalState.PreBoosted)||(pState == ProposalState.Boosted)||(pState == ProposalState.QuietEndingPeriod));
2877     }
2878 }