1 pragma solidity ^0.4.9;
2 
3 
4 library strings {
5     struct slice {
6         uint _len;
7         uint _ptr;
8     }
9 
10     function memcpy(uint dest, uint src, uint len) private {
11         // Copy word-length chunks while possible
12         for(; len >= 32; len -= 32) {
13             assembly {
14                 mstore(dest, mload(src))
15             }
16             dest += 32;
17             src += 32;
18         }
19 
20         // Copy remaining bytes
21         uint mask = 256 ** (32 - len) - 1;
22         assembly {
23             let srcpart := and(mload(src), not(mask))
24             let destpart := and(mload(dest), mask)
25             mstore(dest, or(destpart, srcpart))
26         }
27     }
28 
29     /*
30      * @dev Returns a slice containing the entire string.
31      * @param self The string to make a slice from.
32      * @return A newly allocated slice containing the entire string.
33      */
34     function toSlice(string self) internal returns (slice) {
35         uint ptr;
36         assembly {
37             ptr := add(self, 0x20)
38         }
39         return slice(bytes(self).length, ptr);
40     }
41 
42     /*
43      * @dev Returns the length of a null-terminated bytes32 string.
44      * @param self The value to find the length of.
45      * @return The length of the string, from 0 to 32.
46      */
47     function len(bytes32 self) internal returns (uint) {
48         uint ret;
49         if (self == 0)
50             return 0;
51         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
52             ret += 16;
53             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
54         }
55         if (self & 0xffffffffffffffff == 0) {
56             ret += 8;
57             self = bytes32(uint(self) / 0x10000000000000000);
58         }
59         if (self & 0xffffffff == 0) {
60             ret += 4;
61             self = bytes32(uint(self) / 0x100000000);
62         }
63         if (self & 0xffff == 0) {
64             ret += 2;
65             self = bytes32(uint(self) / 0x10000);
66         }
67         if (self & 0xff == 0) {
68             ret += 1;
69         }
70         return 32 - ret;
71     }
72 
73     /*
74      * @dev Returns a slice containing the entire bytes32, interpreted as a
75      *      null-termintaed utf-8 string.
76      * @param self The bytes32 value to convert to a slice.
77      * @return A new slice containing the value of the input argument up to the
78      *         first null.
79      */
80     function toSliceB32(bytes32 self) internal returns (slice ret) {
81         // Allocate space for `self` in memory, copy it there, and point ret at it
82         assembly {
83             let ptr := mload(0x40)
84             mstore(0x40, add(ptr, 0x20))
85             mstore(ptr, self)
86             mstore(add(ret, 0x20), ptr)
87         }
88         ret._len = len(self);
89     }
90 
91     /*
92      * @dev Returns a new slice containing the same data as the current slice.
93      * @param self The slice to copy.
94      * @return A new slice containing the same data as `self`.
95      */
96     function copy(slice self) internal returns (slice) {
97         return slice(self._len, self._ptr);
98     }
99 
100     /*
101      * @dev Copies a slice to a new string.
102      * @param self The slice to copy.
103      * @return A newly allocated string containing the slice's text.
104      */
105     function toString(slice self) internal returns (string) {
106         var ret = new string(self._len);
107         uint retptr;
108         assembly { retptr := add(ret, 32) }
109 
110         memcpy(retptr, self._ptr, self._len);
111         return ret;
112     }
113 
114     /*
115      * @dev Returns the length in runes of the slice. Note that this operation
116      *      takes time proportional to the length of the slice; avoid using it
117      *      in loops, and call `slice.empty()` if you only need to know whether
118      *      the slice is empty or not.
119      * @param self The slice to operate on.
120      * @return The length of the slice in runes.
121      */
122     function len(slice self) internal returns (uint) {
123         // Starting at ptr-31 means the LSB will be the byte we care about
124         var ptr = self._ptr - 31;
125         var end = ptr + self._len;
126         for (uint len = 0; ptr < end; len++) {
127             uint8 b;
128             assembly { b := and(mload(ptr), 0xFF) }
129             if (b < 0x80) {
130                 ptr += 1;
131             } else if(b < 0xE0) {
132                 ptr += 2;
133             } else if(b < 0xF0) {
134                 ptr += 3;
135             } else if(b < 0xF8) {
136                 ptr += 4;
137             } else if(b < 0xFC) {
138                 ptr += 5;
139             } else {
140                 ptr += 6;
141             }
142         }
143         return len;
144     }
145 
146     /*
147      * @dev Returns true if the slice is empty (has a length of 0).
148      * @param self The slice to operate on.
149      * @return True if the slice is empty, False otherwise.
150      */
151     function empty(slice self) internal returns (bool) {
152         return self._len == 0;
153     }
154 
155     /*
156      * @dev Returns a positive number if `other` comes lexicographically after
157      *      `self`, a negative number if it comes before, or zero if the
158      *      contents of the two slices are equal. Comparison is done per-rune,
159      *      on unicode codepoints.
160      * @param self The first slice to compare.
161      * @param other The second slice to compare.
162      * @return The result of the comparison.
163      */
164     function compare(slice self, slice other) internal returns (int) {
165         uint shortest = self._len;
166         if (other._len < self._len)
167             shortest = other._len;
168 
169         var selfptr = self._ptr;
170         var otherptr = other._ptr;
171         for (uint idx = 0; idx < shortest; idx += 32) {
172             uint a;
173             uint b;
174             assembly {
175                 a := mload(selfptr)
176                 b := mload(otherptr)
177             }
178             if (a != b) {
179                 // Mask out irrelevant bytes and check again
180                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
181                 var diff = (a & mask) - (b & mask);
182                 if (diff != 0)
183                     return int(diff);
184             }
185             selfptr += 32;
186             otherptr += 32;
187         }
188         return int(self._len) - int(other._len);
189     }
190 
191     /*
192      * @dev Returns true if the two slices contain the same text.
193      * @param self The first slice to compare.
194      * @param self The second slice to compare.
195      * @return True if the slices are equal, false otherwise.
196      */
197     function equals(slice self, slice other) internal returns (bool) {
198         return compare(self, other) == 0;
199     }
200 
201     /*
202      * @dev Extracts the first rune in the slice into `rune`, advancing the
203      *      slice to point to the next rune and returning `self`.
204      * @param self The slice to operate on.
205      * @param rune The slice that will contain the first rune.
206      * @return `rune`.
207      */
208     function nextRune(slice self, slice rune) internal returns (slice) {
209         rune._ptr = self._ptr;
210 
211         if (self._len == 0) {
212             rune._len = 0;
213             return rune;
214         }
215 
216         uint len;
217         uint b;
218         // Load the first byte of the rune into the LSBs of b
219         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
220         if (b < 0x80) {
221             len = 1;
222         } else if(b < 0xE0) {
223             len = 2;
224         } else if(b < 0xF0) {
225             len = 3;
226         } else {
227             len = 4;
228         }
229 
230         // Check for truncated codepoints
231         if (len > self._len) {
232             rune._len = self._len;
233             self._ptr += self._len;
234             self._len = 0;
235             return rune;
236         }
237 
238         self._ptr += len;
239         self._len -= len;
240         rune._len = len;
241         return rune;
242     }
243 
244     /*
245      * @dev Returns the first rune in the slice, advancing the slice to point
246      *      to the next rune.
247      * @param self The slice to operate on.
248      * @return A slice containing only the first rune from `self`.
249      */
250     function nextRune(slice self) internal returns (slice ret) {
251         nextRune(self, ret);
252     }
253 
254     /*
255      * @dev Returns the number of the first codepoint in the slice.
256      * @param self The slice to operate on.
257      * @return The number of the first codepoint in the slice.
258      */
259     function ord(slice self) internal returns (uint ret) {
260         if (self._len == 0) {
261             return 0;
262         }
263 
264         uint word;
265         uint len;
266         uint div = 2 ** 248;
267 
268         // Load the rune into the MSBs of b
269         assembly { word:= mload(mload(add(self, 32))) }
270         var b = word / div;
271         if (b < 0x80) {
272             ret = b;
273             len = 1;
274         } else if(b < 0xE0) {
275             ret = b & 0x1F;
276             len = 2;
277         } else if(b < 0xF0) {
278             ret = b & 0x0F;
279             len = 3;
280         } else {
281             ret = b & 0x07;
282             len = 4;
283         }
284 
285         // Check for truncated codepoints
286         if (len > self._len) {
287             return 0;
288         }
289 
290         for (uint i = 1; i < len; i++) {
291             div = div / 256;
292             b = (word / div) & 0xFF;
293             if (b & 0xC0 != 0x80) {
294                 // Invalid UTF-8 sequence
295                 return 0;
296             }
297             ret = (ret * 64) | (b & 0x3F);
298         }
299 
300         return ret;
301     }
302 
303     /*
304      * @dev Returns the keccak-256 hash of the slice.
305      * @param self The slice to hash.
306      * @return The hash of the slice.
307      */
308     function keccak(slice self) internal returns (bytes32 ret) {
309         assembly {
310             ret := sha3(mload(add(self, 32)), mload(self))
311         }
312     }
313 
314     /*
315      * @dev Returns true if `self` starts with `needle`.
316      * @param self The slice to operate on.
317      * @param needle The slice to search for.
318      * @return True if the slice starts with the provided text, false otherwise.
319      */
320     function startsWith(slice self, slice needle) internal returns (bool) {
321         if (self._len < needle._len) {
322             return false;
323         }
324 
325         if (self._ptr == needle._ptr) {
326             return true;
327         }
328 
329         bool equal;
330         assembly {
331             let len := mload(needle)
332             let selfptr := mload(add(self, 0x20))
333             let needleptr := mload(add(needle, 0x20))
334             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
335         }
336         return equal;
337     }
338 
339     /*
340      * @dev If `self` starts with `needle`, `needle` is removed from the
341      *      beginning of `self`. Otherwise, `self` is unmodified.
342      * @param self The slice to operate on.
343      * @param needle The slice to search for.
344      * @return `self`
345      */
346     function beyond(slice self, slice needle) internal returns (slice) {
347         if (self._len < needle._len) {
348             return self;
349         }
350 
351         bool equal = true;
352         if (self._ptr != needle._ptr) {
353             assembly {
354                 let len := mload(needle)
355                 let selfptr := mload(add(self, 0x20))
356                 let needleptr := mload(add(needle, 0x20))
357                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
358             }
359         }
360 
361         if (equal) {
362             self._len -= needle._len;
363             self._ptr += needle._len;
364         }
365 
366         return self;
367     }
368 
369     /*
370      * @dev Returns true if the slice ends with `needle`.
371      * @param self The slice to operate on.
372      * @param needle The slice to search for.
373      * @return True if the slice starts with the provided text, false otherwise.
374      */
375     function endsWith(slice self, slice needle) internal returns (bool) {
376         if (self._len < needle._len) {
377             return false;
378         }
379 
380         var selfptr = self._ptr + self._len - needle._len;
381 
382         if (selfptr == needle._ptr) {
383             return true;
384         }
385 
386         bool equal;
387         assembly {
388             let len := mload(needle)
389             let needleptr := mload(add(needle, 0x20))
390             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
391         }
392 
393         return equal;
394     }
395 
396     /*
397      * @dev If `self` ends with `needle`, `needle` is removed from the
398      *      end of `self`. Otherwise, `self` is unmodified.
399      * @param self The slice to operate on.
400      * @param needle The slice to search for.
401      * @return `self`
402      */
403     function until(slice self, slice needle) internal returns (slice) {
404         if (self._len < needle._len) {
405             return self;
406         }
407 
408         var selfptr = self._ptr + self._len - needle._len;
409         bool equal = true;
410         if (selfptr != needle._ptr) {
411             assembly {
412                 let len := mload(needle)
413                 let needleptr := mload(add(needle, 0x20))
414                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
415             }
416         }
417 
418         if (equal) {
419             self._len -= needle._len;
420         }
421 
422         return self;
423     }
424 
425     // Returns the memory address of the first byte of the first occurrence of
426     // `needle` in `self`, or the first byte after `self` if not found.
427     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
428         uint ptr;
429         uint idx;
430 
431         if (needlelen <= selflen) {
432             if (needlelen <= 32) {
433                 // Optimized assembly for 68 gas per byte on short strings
434                 assembly {
435                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
436                     let needledata := and(mload(needleptr), mask)
437                     let end := add(selfptr, sub(selflen, needlelen))
438                     ptr := selfptr
439                     loop:
440                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
441                     ptr := add(ptr, 1)
442                     jumpi(loop, lt(sub(ptr, 1), end))
443                     ptr := add(selfptr, selflen)
444                     exit:
445                 }
446                 return ptr;
447             } else {
448                 // For long needles, use hashing
449                 bytes32 hash;
450                 assembly { hash := sha3(needleptr, needlelen) }
451                 ptr = selfptr;
452                 for (idx = 0; idx <= selflen - needlelen; idx++) {
453                     bytes32 testHash;
454                     assembly { testHash := sha3(ptr, needlelen) }
455                     if (hash == testHash)
456                         return ptr;
457                     ptr += 1;
458                 }
459             }
460         }
461         return selfptr + selflen;
462     }
463 
464     // Returns the memory address of the first byte after the last occurrence of
465     // `needle` in `self`, or the address of `self` if not found.
466     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
467         uint ptr;
468 
469         if (needlelen <= selflen) {
470             if (needlelen <= 32) {
471                 // Optimized assembly for 69 gas per byte on short strings
472                 assembly {
473                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
474                     let needledata := and(mload(needleptr), mask)
475                     ptr := add(selfptr, sub(selflen, needlelen))
476                     loop:
477                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
478                     ptr := sub(ptr, 1)
479                     jumpi(loop, gt(add(ptr, 1), selfptr))
480                     ptr := selfptr
481                     jump(exit)
482                     ret:
483                     ptr := add(ptr, needlelen)
484                     exit:
485                 }
486                 return ptr;
487             } else {
488                 // For long needles, use hashing
489                 bytes32 hash;
490                 assembly { hash := sha3(needleptr, needlelen) }
491                 ptr = selfptr + (selflen - needlelen);
492                 while (ptr >= selfptr) {
493                     bytes32 testHash;
494                     assembly { testHash := sha3(ptr, needlelen) }
495                     if (hash == testHash)
496                         return ptr + needlelen;
497                     ptr -= 1;
498                 }
499             }
500         }
501         return selfptr;
502     }
503 
504     /*
505      * @dev Modifies `self` to contain everything from the first occurrence of
506      *      `needle` to the end of the slice. `self` is set to the empty slice
507      *      if `needle` is not found.
508      * @param self The slice to search and modify.
509      * @param needle The text to search for.
510      * @return `self`.
511      */
512     function find(slice self, slice needle) internal returns (slice) {
513         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
514         self._len -= ptr - self._ptr;
515         self._ptr = ptr;
516         return self;
517     }
518 
519     /*
520      * @dev Modifies `self` to contain the part of the string from the start of
521      *      `self` to the end of the first occurrence of `needle`. If `needle`
522      *      is not found, `self` is set to the empty slice.
523      * @param self The slice to search and modify.
524      * @param needle The text to search for.
525      * @return `self`.
526      */
527     function rfind(slice self, slice needle) internal returns (slice) {
528         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
529         self._len = ptr - self._ptr;
530         return self;
531     }
532 
533     /*
534      * @dev Splits the slice, setting `self` to everything after the first
535      *      occurrence of `needle`, and `token` to everything before it. If
536      *      `needle` does not occur in `self`, `self` is set to the empty slice,
537      *      and `token` is set to the entirety of `self`.
538      * @param self The slice to split.
539      * @param needle The text to search for in `self`.
540      * @param token An output parameter to which the first token is written.
541      * @return `token`.
542      */
543     function split(slice self, slice needle, slice token) internal returns (slice) {
544         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
545         token._ptr = self._ptr;
546         token._len = ptr - self._ptr;
547         if (ptr == self._ptr + self._len) {
548             // Not found
549             self._len = 0;
550         } else {
551             self._len -= token._len + needle._len;
552             self._ptr = ptr + needle._len;
553         }
554         return token;
555     }
556 
557     /*
558      * @dev Splits the slice, setting `self` to everything after the first
559      *      occurrence of `needle`, and returning everything before it. If
560      *      `needle` does not occur in `self`, `self` is set to the empty slice,
561      *      and the entirety of `self` is returned.
562      * @param self The slice to split.
563      * @param needle The text to search for in `self`.
564      * @return The part of `self` up to the first occurrence of `delim`.
565      */
566     function split(slice self, slice needle) internal returns (slice token) {
567         split(self, needle, token);
568     }
569 
570     /*
571      * @dev Splits the slice, setting `self` to everything before the last
572      *      occurrence of `needle`, and `token` to everything after it. If
573      *      `needle` does not occur in `self`, `self` is set to the empty slice,
574      *      and `token` is set to the entirety of `self`.
575      * @param self The slice to split.
576      * @param needle The text to search for in `self`.
577      * @param token An output parameter to which the first token is written.
578      * @return `token`.
579      */
580     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
581         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
582         token._ptr = ptr;
583         token._len = self._len - (ptr - self._ptr);
584         if (ptr == self._ptr) {
585             // Not found
586             self._len = 0;
587         } else {
588             self._len -= token._len + needle._len;
589         }
590         return token;
591     }
592 
593     /*
594      * @dev Splits the slice, setting `self` to everything before the last
595      *      occurrence of `needle`, and returning everything after it. If
596      *      `needle` does not occur in `self`, `self` is set to the empty slice,
597      *      and the entirety of `self` is returned.
598      * @param self The slice to split.
599      * @param needle The text to search for in `self`.
600      * @return The part of `self` after the last occurrence of `delim`.
601      */
602     function rsplit(slice self, slice needle) internal returns (slice token) {
603         rsplit(self, needle, token);
604     }
605 
606     /*
607      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
608      * @param self The slice to search.
609      * @param needle The text to search for in `self`.
610      * @return The number of occurrences of `needle` found in `self`.
611      */
612     function count(slice self, slice needle) internal returns (uint count) {
613         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
614         while (ptr <= self._ptr + self._len) {
615             count++;
616             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
617         }
618     }
619 
620     /*
621      * @dev Returns True if `self` contains `needle`.
622      * @param self The slice to search.
623      * @param needle The text to search for in `self`.
624      * @return True if `needle` is found in `self`, false otherwise.
625      */
626     function contains(slice self, slice needle) internal returns (bool) {
627         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
628     }
629 
630     /*
631      * @dev Returns a newly allocated string containing the concatenation of
632      *      `self` and `other`.
633      * @param self The first slice to concatenate.
634      * @param other The second slice to concatenate.
635      * @return The concatenation of the two strings.
636      */
637     function concat(slice self, slice other) internal returns (string) {
638         var ret = new string(self._len + other._len);
639         uint retptr;
640         assembly { retptr := add(ret, 32) }
641         memcpy(retptr, self._ptr, self._len);
642         memcpy(retptr + self._len, other._ptr, other._len);
643         return ret;
644     }
645 
646     /*
647      * @dev Joins an array of slices, using `self` as a delimiter, returning a
648      *      newly allocated string.
649      * @param self The delimiter to use.
650      * @param parts A list of slices to join.
651      * @return A newly allocated string containing all the slices in `parts`,
652      *         joined with `self`.
653      */
654     function join(slice self, slice[] parts) internal returns (string) {
655         if (parts.length == 0)
656             return "";
657 
658         uint len = self._len * (parts.length - 1);
659         for(uint i = 0; i < parts.length; i++)
660             len += parts[i]._len;
661 
662         var ret = new string(len);
663         uint retptr;
664         assembly { retptr := add(ret, 32) }
665 
666         for(i = 0; i < parts.length; i++) {
667             memcpy(retptr, parts[i]._ptr, parts[i]._len);
668             retptr += parts[i]._len;
669             if (i < parts.length - 1) {
670                 memcpy(retptr, self._ptr, self._len);
671                 retptr += self._len;
672             }
673         }
674 
675         return ret;
676     }
677 }
678 
679 contract OraclizeI {
680     address public cbAddress;
681     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
682     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
683     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
684     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
685     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
686     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
687     function getPrice(string _datasource) returns (uint _dsprice);
688     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
689     function useCoupon(string _coupon);
690     function setProofType(byte _proofType);
691     function setConfig(bytes32 _config);
692     function setCustomGasPrice(uint _gasPrice);
693     function randomDS_getSessionPubKeyHash() returns(bytes32);
694 }
695 contract OraclizeAddrResolverI {
696     function getAddress() returns (address _addr);
697 }
698 contract usingOraclize {
699     uint constant day = 60*60*24;
700     uint constant week = 60*60*24*7;
701     uint constant month = 60*60*24*30;
702     byte constant proofType_NONE = 0x00;
703     byte constant proofType_TLSNotary = 0x10;
704     byte constant proofType_Android = 0x20;
705     byte constant proofType_Ledger = 0x30;
706     byte constant proofType_Native = 0xF0;
707     byte constant proofStorage_IPFS = 0x01;
708     uint8 constant networkID_auto = 0;
709     uint8 constant networkID_mainnet = 1;
710     uint8 constant networkID_testnet = 2;
711     uint8 constant networkID_morden = 2;
712     uint8 constant networkID_consensys = 161;
713 
714     OraclizeAddrResolverI OAR;
715 
716     OraclizeI oraclize;
717     modifier oraclizeAPI {
718         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
719         oraclize = OraclizeI(OAR.getAddress());
720         _;
721     }
722     modifier coupon(string code){
723         oraclize = OraclizeI(OAR.getAddress());
724         oraclize.useCoupon(code);
725         _;
726     }
727 
728     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
729         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
730             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
731             oraclize_setNetworkName("eth_mainnet");
732             return true;
733         }
734         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
735             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
736             oraclize_setNetworkName("eth_ropsten3");
737             return true;
738         }
739         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
740             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
741             oraclize_setNetworkName("eth_kovan");
742             return true;
743         }
744         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
745             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
746             oraclize_setNetworkName("eth_rinkeby");
747             return true;
748         }
749         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
750             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
751             return true;
752         }
753         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
754             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
755             return true;
756         }
757         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
758             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
759             return true;
760         }
761         return false;
762     }
763 
764     function __callback(bytes32 myid, string result) {
765         __callback(myid, result, new bytes(0));
766     }
767     function __callback(bytes32 myid, string result, bytes proof) {
768     }
769     
770     function oraclize_useCoupon(string code) oraclizeAPI internal {
771         oraclize.useCoupon(code);
772     }
773 
774     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
775         return oraclize.getPrice(datasource);
776     }
777 
778     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
779         return oraclize.getPrice(datasource, gaslimit);
780     }
781     
782     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
783         uint price = oraclize.getPrice(datasource);
784         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
785         return oraclize.query.value(price)(0, datasource, arg);
786     }
787     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
788         uint price = oraclize.getPrice(datasource);
789         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
790         return oraclize.query.value(price)(timestamp, datasource, arg);
791     }
792     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
793         uint price = oraclize.getPrice(datasource, gaslimit);
794         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
795         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
796     }
797     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
798         uint price = oraclize.getPrice(datasource, gaslimit);
799         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
800         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
801     }
802     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
803         uint price = oraclize.getPrice(datasource);
804         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
805         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
806     }
807     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
808         uint price = oraclize.getPrice(datasource);
809         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
810         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
811     }
812     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
813         uint price = oraclize.getPrice(datasource, gaslimit);
814         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
815         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
816     }
817     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
818         uint price = oraclize.getPrice(datasource, gaslimit);
819         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
820         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
821     }
822     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
823         uint price = oraclize.getPrice(datasource);
824         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
825         bytes memory args = stra2cbor(argN);
826         return oraclize.queryN.value(price)(0, datasource, args);
827     }
828     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
829         uint price = oraclize.getPrice(datasource);
830         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
831         bytes memory args = stra2cbor(argN);
832         return oraclize.queryN.value(price)(timestamp, datasource, args);
833     }
834     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
835         uint price = oraclize.getPrice(datasource, gaslimit);
836         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
837         bytes memory args = stra2cbor(argN);
838         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
839     }
840     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
841         uint price = oraclize.getPrice(datasource, gaslimit);
842         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
843         bytes memory args = stra2cbor(argN);
844         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
845     }
846     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
847         string[] memory dynargs = new string[](1);
848         dynargs[0] = args[0];
849         return oraclize_query(datasource, dynargs);
850     }
851     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
852         string[] memory dynargs = new string[](1);
853         dynargs[0] = args[0];
854         return oraclize_query(timestamp, datasource, dynargs);
855     }
856     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
857         string[] memory dynargs = new string[](1);
858         dynargs[0] = args[0];
859         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
860     }
861     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
862         string[] memory dynargs = new string[](1);
863         dynargs[0] = args[0];       
864         return oraclize_query(datasource, dynargs, gaslimit);
865     }
866     
867     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
868         string[] memory dynargs = new string[](2);
869         dynargs[0] = args[0];
870         dynargs[1] = args[1];
871         return oraclize_query(datasource, dynargs);
872     }
873     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
874         string[] memory dynargs = new string[](2);
875         dynargs[0] = args[0];
876         dynargs[1] = args[1];
877         return oraclize_query(timestamp, datasource, dynargs);
878     }
879     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
880         string[] memory dynargs = new string[](2);
881         dynargs[0] = args[0];
882         dynargs[1] = args[1];
883         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
884     }
885     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
886         string[] memory dynargs = new string[](2);
887         dynargs[0] = args[0];
888         dynargs[1] = args[1];
889         return oraclize_query(datasource, dynargs, gaslimit);
890     }
891     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
892         string[] memory dynargs = new string[](3);
893         dynargs[0] = args[0];
894         dynargs[1] = args[1];
895         dynargs[2] = args[2];
896         return oraclize_query(datasource, dynargs);
897     }
898     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
899         string[] memory dynargs = new string[](3);
900         dynargs[0] = args[0];
901         dynargs[1] = args[1];
902         dynargs[2] = args[2];
903         return oraclize_query(timestamp, datasource, dynargs);
904     }
905     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
906         string[] memory dynargs = new string[](3);
907         dynargs[0] = args[0];
908         dynargs[1] = args[1];
909         dynargs[2] = args[2];
910         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
911     }
912     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
913         string[] memory dynargs = new string[](3);
914         dynargs[0] = args[0];
915         dynargs[1] = args[1];
916         dynargs[2] = args[2];
917         return oraclize_query(datasource, dynargs, gaslimit);
918     }
919     
920     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
921         string[] memory dynargs = new string[](4);
922         dynargs[0] = args[0];
923         dynargs[1] = args[1];
924         dynargs[2] = args[2];
925         dynargs[3] = args[3];
926         return oraclize_query(datasource, dynargs);
927     }
928     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
929         string[] memory dynargs = new string[](4);
930         dynargs[0] = args[0];
931         dynargs[1] = args[1];
932         dynargs[2] = args[2];
933         dynargs[3] = args[3];
934         return oraclize_query(timestamp, datasource, dynargs);
935     }
936     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
937         string[] memory dynargs = new string[](4);
938         dynargs[0] = args[0];
939         dynargs[1] = args[1];
940         dynargs[2] = args[2];
941         dynargs[3] = args[3];
942         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
943     }
944     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
945         string[] memory dynargs = new string[](4);
946         dynargs[0] = args[0];
947         dynargs[1] = args[1];
948         dynargs[2] = args[2];
949         dynargs[3] = args[3];
950         return oraclize_query(datasource, dynargs, gaslimit);
951     }
952     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
953         string[] memory dynargs = new string[](5);
954         dynargs[0] = args[0];
955         dynargs[1] = args[1];
956         dynargs[2] = args[2];
957         dynargs[3] = args[3];
958         dynargs[4] = args[4];
959         return oraclize_query(datasource, dynargs);
960     }
961     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
962         string[] memory dynargs = new string[](5);
963         dynargs[0] = args[0];
964         dynargs[1] = args[1];
965         dynargs[2] = args[2];
966         dynargs[3] = args[3];
967         dynargs[4] = args[4];
968         return oraclize_query(timestamp, datasource, dynargs);
969     }
970     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
971         string[] memory dynargs = new string[](5);
972         dynargs[0] = args[0];
973         dynargs[1] = args[1];
974         dynargs[2] = args[2];
975         dynargs[3] = args[3];
976         dynargs[4] = args[4];
977         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
978     }
979     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
980         string[] memory dynargs = new string[](5);
981         dynargs[0] = args[0];
982         dynargs[1] = args[1];
983         dynargs[2] = args[2];
984         dynargs[3] = args[3];
985         dynargs[4] = args[4];
986         return oraclize_query(datasource, dynargs, gaslimit);
987     }
988     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
989         uint price = oraclize.getPrice(datasource);
990         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
991         bytes memory args = ba2cbor(argN);
992         return oraclize.queryN.value(price)(0, datasource, args);
993     }
994     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
995         uint price = oraclize.getPrice(datasource);
996         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
997         bytes memory args = ba2cbor(argN);
998         return oraclize.queryN.value(price)(timestamp, datasource, args);
999     }
1000     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1001         uint price = oraclize.getPrice(datasource, gaslimit);
1002         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1003         bytes memory args = ba2cbor(argN);
1004         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1005     }
1006     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1007         uint price = oraclize.getPrice(datasource, gaslimit);
1008         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1009         bytes memory args = ba2cbor(argN);
1010         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1011     }
1012     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1013         bytes[] memory dynargs = new bytes[](1);
1014         dynargs[0] = args[0];
1015         return oraclize_query(datasource, dynargs);
1016     }
1017     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1018         bytes[] memory dynargs = new bytes[](1);
1019         dynargs[0] = args[0];
1020         return oraclize_query(timestamp, datasource, dynargs);
1021     }
1022     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1023         bytes[] memory dynargs = new bytes[](1);
1024         dynargs[0] = args[0];
1025         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1026     }
1027     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1028         bytes[] memory dynargs = new bytes[](1);
1029         dynargs[0] = args[0];       
1030         return oraclize_query(datasource, dynargs, gaslimit);
1031     }
1032     
1033     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1034         bytes[] memory dynargs = new bytes[](2);
1035         dynargs[0] = args[0];
1036         dynargs[1] = args[1];
1037         return oraclize_query(datasource, dynargs);
1038     }
1039     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1040         bytes[] memory dynargs = new bytes[](2);
1041         dynargs[0] = args[0];
1042         dynargs[1] = args[1];
1043         return oraclize_query(timestamp, datasource, dynargs);
1044     }
1045     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1046         bytes[] memory dynargs = new bytes[](2);
1047         dynargs[0] = args[0];
1048         dynargs[1] = args[1];
1049         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1050     }
1051     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1052         bytes[] memory dynargs = new bytes[](2);
1053         dynargs[0] = args[0];
1054         dynargs[1] = args[1];
1055         return oraclize_query(datasource, dynargs, gaslimit);
1056     }
1057     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1058         bytes[] memory dynargs = new bytes[](3);
1059         dynargs[0] = args[0];
1060         dynargs[1] = args[1];
1061         dynargs[2] = args[2];
1062         return oraclize_query(datasource, dynargs);
1063     }
1064     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1065         bytes[] memory dynargs = new bytes[](3);
1066         dynargs[0] = args[0];
1067         dynargs[1] = args[1];
1068         dynargs[2] = args[2];
1069         return oraclize_query(timestamp, datasource, dynargs);
1070     }
1071     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1072         bytes[] memory dynargs = new bytes[](3);
1073         dynargs[0] = args[0];
1074         dynargs[1] = args[1];
1075         dynargs[2] = args[2];
1076         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1077     }
1078     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1079         bytes[] memory dynargs = new bytes[](3);
1080         dynargs[0] = args[0];
1081         dynargs[1] = args[1];
1082         dynargs[2] = args[2];
1083         return oraclize_query(datasource, dynargs, gaslimit);
1084     }
1085     
1086     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1087         bytes[] memory dynargs = new bytes[](4);
1088         dynargs[0] = args[0];
1089         dynargs[1] = args[1];
1090         dynargs[2] = args[2];
1091         dynargs[3] = args[3];
1092         return oraclize_query(datasource, dynargs);
1093     }
1094     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1095         bytes[] memory dynargs = new bytes[](4);
1096         dynargs[0] = args[0];
1097         dynargs[1] = args[1];
1098         dynargs[2] = args[2];
1099         dynargs[3] = args[3];
1100         return oraclize_query(timestamp, datasource, dynargs);
1101     }
1102     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1103         bytes[] memory dynargs = new bytes[](4);
1104         dynargs[0] = args[0];
1105         dynargs[1] = args[1];
1106         dynargs[2] = args[2];
1107         dynargs[3] = args[3];
1108         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1109     }
1110     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1111         bytes[] memory dynargs = new bytes[](4);
1112         dynargs[0] = args[0];
1113         dynargs[1] = args[1];
1114         dynargs[2] = args[2];
1115         dynargs[3] = args[3];
1116         return oraclize_query(datasource, dynargs, gaslimit);
1117     }
1118     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1119         bytes[] memory dynargs = new bytes[](5);
1120         dynargs[0] = args[0];
1121         dynargs[1] = args[1];
1122         dynargs[2] = args[2];
1123         dynargs[3] = args[3];
1124         dynargs[4] = args[4];
1125         return oraclize_query(datasource, dynargs);
1126     }
1127     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1128         bytes[] memory dynargs = new bytes[](5);
1129         dynargs[0] = args[0];
1130         dynargs[1] = args[1];
1131         dynargs[2] = args[2];
1132         dynargs[3] = args[3];
1133         dynargs[4] = args[4];
1134         return oraclize_query(timestamp, datasource, dynargs);
1135     }
1136     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1137         bytes[] memory dynargs = new bytes[](5);
1138         dynargs[0] = args[0];
1139         dynargs[1] = args[1];
1140         dynargs[2] = args[2];
1141         dynargs[3] = args[3];
1142         dynargs[4] = args[4];
1143         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1144     }
1145     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1146         bytes[] memory dynargs = new bytes[](5);
1147         dynargs[0] = args[0];
1148         dynargs[1] = args[1];
1149         dynargs[2] = args[2];
1150         dynargs[3] = args[3];
1151         dynargs[4] = args[4];
1152         return oraclize_query(datasource, dynargs, gaslimit);
1153     }
1154 
1155     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1156         return oraclize.cbAddress();
1157     }
1158     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1159         return oraclize.setProofType(proofP);
1160     }
1161     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1162         return oraclize.setCustomGasPrice(gasPrice);
1163     }
1164     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1165         return oraclize.setConfig(config);
1166     }
1167     
1168     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1169         return oraclize.randomDS_getSessionPubKeyHash();
1170     }
1171 
1172     function getCodeSize(address _addr) constant internal returns(uint _size) {
1173         assembly {
1174             _size := extcodesize(_addr)
1175         }
1176     }
1177 
1178     function parseAddr(string _a) internal returns (address){
1179         bytes memory tmp = bytes(_a);
1180         uint160 iaddr = 0;
1181         uint160 b1;
1182         uint160 b2;
1183         for (uint i=2; i<2+2*20; i+=2){
1184             iaddr *= 256;
1185             b1 = uint160(tmp[i]);
1186             b2 = uint160(tmp[i+1]);
1187             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1188             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1189             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1190             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1191             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1192             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1193             iaddr += (b1*16+b2);
1194         }
1195         return address(iaddr);
1196     }
1197 
1198     function strCompare(string _a, string _b) internal returns (int) {
1199         bytes memory a = bytes(_a);
1200         bytes memory b = bytes(_b);
1201         uint minLength = a.length;
1202         if (b.length < minLength) minLength = b.length;
1203         for (uint i = 0; i < minLength; i ++)
1204             if (a[i] < b[i])
1205                 return -1;
1206             else if (a[i] > b[i])
1207                 return 1;
1208         if (a.length < b.length)
1209             return -1;
1210         else if (a.length > b.length)
1211             return 1;
1212         else
1213             return 0;
1214     }
1215 
1216     function indexOf(string _haystack, string _needle) internal returns (int) {
1217         bytes memory h = bytes(_haystack);
1218         bytes memory n = bytes(_needle);
1219         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1220             return -1;
1221         else if(h.length > (2**128 -1))
1222             return -1;
1223         else
1224         {
1225             uint subindex = 0;
1226             for (uint i = 0; i < h.length; i ++)
1227             {
1228                 if (h[i] == n[0])
1229                 {
1230                     subindex = 1;
1231                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1232                     {
1233                         subindex++;
1234                     }
1235                     if(subindex == n.length)
1236                         return int(i);
1237                 }
1238             }
1239             return -1;
1240         }
1241     }
1242 
1243     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1244         bytes memory _ba = bytes(_a);
1245         bytes memory _bb = bytes(_b);
1246         bytes memory _bc = bytes(_c);
1247         bytes memory _bd = bytes(_d);
1248         bytes memory _be = bytes(_e);
1249         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1250         bytes memory babcde = bytes(abcde);
1251         uint k = 0;
1252         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1253         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1254         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1255         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1256         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1257         return string(babcde);
1258     }
1259 
1260     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1261         return strConcat(_a, _b, _c, _d, "");
1262     }
1263 
1264     function strConcat(string _a, string _b, string _c) internal returns (string) {
1265         return strConcat(_a, _b, _c, "", "");
1266     }
1267 
1268     function strConcat(string _a, string _b) internal returns (string) {
1269         return strConcat(_a, _b, "", "", "");
1270     }
1271 
1272     // parseInt
1273     function parseInt(string _a) internal returns (uint) {
1274         return parseInt(_a, 0);
1275     }
1276 
1277     // parseInt(parseFloat*10^_b)
1278     function parseInt(string _a, uint _b) internal returns (uint) {
1279         bytes memory bresult = bytes(_a);
1280         uint mint = 0;
1281         bool decimals = false;
1282         for (uint i=0; i<bresult.length; i++){
1283             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1284                 if (decimals){
1285                    if (_b == 0) break;
1286                     else _b--;
1287                 }
1288                 mint *= 10;
1289                 mint += uint(bresult[i]) - 48;
1290             } else if (bresult[i] == 46) decimals = true;
1291         }
1292         if (_b > 0) mint *= 10**_b;
1293         return mint;
1294     }
1295 
1296     function uint2str(uint i) internal returns (string){
1297         if (i == 0) return "0";
1298         uint j = i;
1299         uint len;
1300         while (j != 0){
1301             len++;
1302             j /= 10;
1303         }
1304         bytes memory bstr = new bytes(len);
1305         uint k = len - 1;
1306         while (i != 0){
1307             bstr[k--] = byte(48 + i % 10);
1308             i /= 10;
1309         }
1310         return string(bstr);
1311     }
1312     
1313     function stra2cbor(string[] arr) internal returns (bytes) {
1314             uint arrlen = arr.length;
1315 
1316             // get correct cbor output length
1317             uint outputlen = 0;
1318             bytes[] memory elemArray = new bytes[](arrlen);
1319             for (uint i = 0; i < arrlen; i++) {
1320                 elemArray[i] = (bytes(arr[i]));
1321                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1322             }
1323             uint ctr = 0;
1324             uint cborlen = arrlen + 0x80;
1325             outputlen += byte(cborlen).length;
1326             bytes memory res = new bytes(outputlen);
1327 
1328             while (byte(cborlen).length > ctr) {
1329                 res[ctr] = byte(cborlen)[ctr];
1330                 ctr++;
1331             }
1332             for (i = 0; i < arrlen; i++) {
1333                 res[ctr] = 0x5F;
1334                 ctr++;
1335                 for (uint x = 0; x < elemArray[i].length; x++) {
1336                     // if there's a bug with larger strings, this may be the culprit
1337                     if (x % 23 == 0) {
1338                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1339                         elemcborlen += 0x40;
1340                         uint lctr = ctr;
1341                         while (byte(elemcborlen).length > ctr - lctr) {
1342                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1343                             ctr++;
1344                         }
1345                     }
1346                     res[ctr] = elemArray[i][x];
1347                     ctr++;
1348                 }
1349                 res[ctr] = 0xFF;
1350                 ctr++;
1351             }
1352             return res;
1353         }
1354 
1355     function ba2cbor(bytes[] arr) internal returns (bytes) {
1356             uint arrlen = arr.length;
1357 
1358             // get correct cbor output length
1359             uint outputlen = 0;
1360             bytes[] memory elemArray = new bytes[](arrlen);
1361             for (uint i = 0; i < arrlen; i++) {
1362                 elemArray[i] = (bytes(arr[i]));
1363                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1364             }
1365             uint ctr = 0;
1366             uint cborlen = arrlen + 0x80;
1367             outputlen += byte(cborlen).length;
1368             bytes memory res = new bytes(outputlen);
1369 
1370             while (byte(cborlen).length > ctr) {
1371                 res[ctr] = byte(cborlen)[ctr];
1372                 ctr++;
1373             }
1374             for (i = 0; i < arrlen; i++) {
1375                 res[ctr] = 0x5F;
1376                 ctr++;
1377                 for (uint x = 0; x < elemArray[i].length; x++) {
1378                     // if there's a bug with larger strings, this may be the culprit
1379                     if (x % 23 == 0) {
1380                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1381                         elemcborlen += 0x40;
1382                         uint lctr = ctr;
1383                         while (byte(elemcborlen).length > ctr - lctr) {
1384                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1385                             ctr++;
1386                         }
1387                     }
1388                     res[ctr] = elemArray[i][x];
1389                     ctr++;
1390                 }
1391                 res[ctr] = 0xFF;
1392                 ctr++;
1393             }
1394             return res;
1395         }
1396         
1397         
1398     string oraclize_network_name;
1399     function oraclize_setNetworkName(string _network_name) internal {
1400         oraclize_network_name = _network_name;
1401     }
1402     
1403     function oraclize_getNetworkName() internal returns (string) {
1404         return oraclize_network_name;
1405     }
1406     
1407     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1408         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1409         bytes memory nbytes = new bytes(1);
1410         nbytes[0] = byte(_nbytes);
1411         bytes memory unonce = new bytes(32);
1412         bytes memory sessionKeyHash = new bytes(32);
1413         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1414         assembly {
1415             mstore(unonce, 0x20)
1416             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1417             mstore(sessionKeyHash, 0x20)
1418             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1419         }
1420         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
1421         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1422         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1423         return queryId;
1424     }
1425     
1426     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1427         oraclize_randomDS_args[queryId] = commitment;
1428     }
1429     
1430     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1431     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1432 
1433     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1434         bool sigok;
1435         address signer;
1436         
1437         bytes32 sigr;
1438         bytes32 sigs;
1439         
1440         bytes memory sigr_ = new bytes(32);
1441         uint offset = 4+(uint(dersig[3]) - 0x20);
1442         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1443         bytes memory sigs_ = new bytes(32);
1444         offset += 32 + 2;
1445         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1446 
1447         assembly {
1448             sigr := mload(add(sigr_, 32))
1449             sigs := mload(add(sigs_, 32))
1450         }
1451         
1452         
1453         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1454         if (address(sha3(pubkey)) == signer) return true;
1455         else {
1456             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1457             return (address(sha3(pubkey)) == signer);
1458         }
1459     }
1460 
1461     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1462         bool sigok;
1463         
1464         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1465         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1466         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1467         
1468         bytes memory appkey1_pubkey = new bytes(64);
1469         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1470         
1471         bytes memory tosign2 = new bytes(1+65+32);
1472         tosign2[0] = 1; //role
1473         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1474         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1475         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1476         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1477         
1478         if (sigok == false) return false;
1479         
1480         
1481         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1482         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1483         
1484         bytes memory tosign3 = new bytes(1+65);
1485         tosign3[0] = 0xFE;
1486         copyBytes(proof, 3, 65, tosign3, 1);
1487         
1488         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1489         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1490         
1491         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1492         
1493         return sigok;
1494     }
1495     
1496     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1497         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1498         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1499         
1500         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1501         if (proofVerified == false) throw;
1502         
1503         _;
1504     }
1505     
1506     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1507         bool match_ = true;
1508         
1509         for (var i=0; i<prefix.length; i++){
1510             if (content[i] != prefix[i]) match_ = false;
1511         }
1512         
1513         return match_;
1514     }
1515 
1516     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1517         bool checkok;
1518         
1519         
1520         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1521         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1522         bytes memory keyhash = new bytes(32);
1523         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1524         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1525         if (checkok == false) return false;
1526         
1527         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1528         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1529         
1530         
1531         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1532         checkok = matchBytes32Prefix(sha256(sig1), result);
1533         if (checkok == false) return false;
1534         
1535         
1536         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1537         // This is to verify that the computed args match with the ones specified in the query.
1538         bytes memory commitmentSlice1 = new bytes(8+1+32);
1539         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1540         
1541         bytes memory sessionPubkey = new bytes(64);
1542         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1543         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1544         
1545         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1546         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1547             delete oraclize_randomDS_args[queryId];
1548         } else return false;
1549         
1550         
1551         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1552         bytes memory tosign1 = new bytes(32+8+1+32);
1553         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1554         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1555         if (checkok == false) return false;
1556         
1557         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1558         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1559             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1560         }
1561         
1562         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1563     }
1564 
1565     
1566     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1567     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1568         uint minLength = length + toOffset;
1569 
1570         if (to.length < minLength) {
1571             // Buffer too small
1572             throw; // Should be a better way?
1573         }
1574 
1575         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1576         uint i = 32 + fromOffset;
1577         uint j = 32 + toOffset;
1578 
1579         while (i < (32 + fromOffset + length)) {
1580             assembly {
1581                 let tmp := mload(add(from, i))
1582                 mstore(add(to, j), tmp)
1583             }
1584             i += 32;
1585             j += 32;
1586         }
1587 
1588         return to;
1589     }
1590     
1591     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1592     // Duplicate Solidity's ecrecover, but catching the CALL return value
1593     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1594         // We do our own memory management here. Solidity uses memory offset
1595         // 0x40 to store the current end of memory. We write past it (as
1596         // writes are memory extensions), but don't update the offset so
1597         // Solidity will reuse it. The memory used here is only needed for
1598         // this context.
1599 
1600         // FIXME: inline assembly can't access return values
1601         bool ret;
1602         address addr;
1603 
1604         assembly {
1605             let size := mload(0x40)
1606             mstore(size, hash)
1607             mstore(add(size, 32), v)
1608             mstore(add(size, 64), r)
1609             mstore(add(size, 96), s)
1610 
1611             // NOTE: we can reuse the request memory because we deal with
1612             //       the return code
1613             ret := call(3000, 1, 0, size, 128, size, 32)
1614             addr := mload(size)
1615         }
1616   
1617         return (ret, addr);
1618     }
1619 
1620     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1621     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1622         bytes32 r;
1623         bytes32 s;
1624         uint8 v;
1625 
1626         if (sig.length != 65)
1627           return (false, 0);
1628 
1629         // The signature format is a compact form of:
1630         //   {bytes32 r}{bytes32 s}{uint8 v}
1631         // Compact means, uint8 is not padded to 32 bytes.
1632         assembly {
1633             r := mload(add(sig, 32))
1634             s := mload(add(sig, 64))
1635 
1636             // Here we are loading the last 32 bytes. We exploit the fact that
1637             // 'mload' will pad with zeroes if we overread.
1638             // There is no 'mload8' to do this, but that would be nicer.
1639             v := byte(0, mload(add(sig, 96)))
1640 
1641             // Alternative solution:
1642             // 'byte' is not working due to the Solidity parser, so lets
1643             // use the second best option, 'and'
1644             // v := and(mload(add(sig, 65)), 255)
1645         }
1646 
1647         // albeit non-transactional signatures are not specified by the YP, one would expect it
1648         // to match the YP range of [27, 28]
1649         //
1650         // geth uses [0, 1] and some clients have followed. This might change, see:
1651         //  https://github.com/ethereum/go-ethereum/issues/2053
1652         if (v < 27)
1653           v += 27;
1654 
1655         if (v != 27 && v != 28)
1656             return (false, 0);
1657 
1658         return safer_ecrecover(hash, v, r, s);
1659     }
1660         
1661 }
1662 // </ORACLIZE_API>
1663 
1664 contract ERC20 {
1665   uint public totalSupply;
1666   function balanceOf(address who) constant returns (uint);
1667   function allowance(address owner, address spender) constant returns (uint);
1668   function transferFrom(address from, address to, uint value) returns (bool ok);
1669   function approve(address spender, uint value) returns (bool ok);
1670   function transfer(address to, uint value) returns (bool ok);
1671   function convert(uint _value) returns (bool ok);
1672   event Transfer(address indexed from, address indexed to, uint value);
1673   event Approval(address indexed owner, address indexed spender, uint value);
1674 }
1675 
1676 
1677 contract SigmaToken is ERC20,usingOraclize
1678 {
1679     
1680     using strings for *;
1681     
1682     bytes32 myid_;
1683     
1684     mapping(bytes32=>bytes32) myidList;
1685     
1686       uint public totalSupply = 500000000 *100000;  // total supply 500 million
1687       
1688        uint public counter = 0;
1689       
1690       mapping(address => uint) balances;
1691 
1692       mapping (address => mapping (address => uint)) allowed;
1693       
1694       address owner;
1695       
1696      // string usd_price_with_decimal=".02 usd per token";
1697       
1698       uint one_ether_usd_price;
1699       
1700        modifier respectTimeFrame() {
1701 		if ((now < startBlock) || (now > endBlock )) throw;
1702 		_;
1703 	}
1704       
1705         enum State {created , gotapidata,wait}
1706           State state;
1707           
1708             // To indicate ICO status; crowdsaleStatus=0=> ICO not started; crowdsaleStatus=1=> ICO started; crowdsaleStatus=2=> ICO closed
1709     uint public crowdsaleStatus=0; 
1710     
1711         // ICO start block
1712     uint public startBlock;   
1713    // ICO end block  
1714     uint public endBlock; 
1715              
1716                	// Name of the token
1717     string public constant name = "SIGMA";
1718     
1719       //Emit event on transferring 3TC to user when payment is received 
1720   event MintAndTransfer(address addr, uint value, bytes32 comment);
1721 
1722   
1723   	// Symbol of token
1724     string public constant symbol = "SIGMA"; 
1725     uint8 public constant decimals = 5;  
1726     
1727       address beneficiary_;
1728      uint256 benef_ether;
1729            
1730         // Functions with this modifier can only be executed by the owner
1731     modifier onlyOwner() {
1732        if (msg.sender != owner) {
1733          throw;
1734         }
1735        _;
1736      }
1737 
1738       mapping (bytes32 => address)userAddress;
1739     mapping (address => uint)uservalue;
1740     mapping (bytes32 => bytes32)userqueryID;
1741       
1742      
1743        event TRANS(address accountAddress, uint amount);
1744        event Message(string message,address to_,uint token_amount);
1745        
1746          event Price(string ethh);
1747          event valuee(uint price);
1748          
1749          function SigmaToken()
1750          {
1751              owner = msg.sender;
1752              balances[owner]=totalSupply;
1753              
1754          }
1755          
1756           //To start PREICO
1757   function PREICOstart() onlyOwner() {
1758    
1759     startBlock = now ;            
1760   
1761     endBlock =  now + 10 days;
1762    
1763     crowdsaleStatus=3;  
1764      
1765   }
1766   
1767    //fallback function i.e. payable; initiates when any address transfers Eth to Contract address
1768  		 function () payable {
1769  		     
1770  		     beneficiary_=msg.sender;
1771  		     
1772  		     benef_ether=msg.value;
1773  		     
1774  		       TRANS(beneficiary_,benef_ether); // doing something with the result..
1775        
1776  		     
1777  		     getetherpriceinUSD(msg.sender,msg.value);
1778    	
1779   		}
1780   		
1781   		function getetherpriceinUSD(address benef_add,uint256 benef_value)
1782   {
1783       
1784       bytes32 ID = oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1785  
1786          userAddress[ID]=benef_add;
1787               uservalue[benef_add]=benef_value;
1788               userqueryID[ID]=ID;
1789             
1790 
1791  
1792   }
1793 
1794   //  callback function called when we get USD price from oraclize query
1795   
1796     function __callback(bytes32 myid, string result) {
1797     if (msg.sender != oraclize_cbAddress()) {
1798       // just to be sure the calling address is the Oraclize authorized one
1799       throw;
1800     }
1801     
1802     
1803                 var s = result.toSlice();
1804         strings.slice memory part;
1805         var usd_price_b=s.split(".".toSlice()); // part and return value is "www"
1806       var usd_price_a = s; 
1807      var fina=usd_price_b.concat(usd_price_a);
1808         
1809         
1810       
1811       Price(fina); // doing something with the result..
1812       
1813       
1814        one_ether_usd_price = stringToUint(fina);
1815        
1816        bytes memory b = bytes(fina);
1817        
1818        if(b.length == 3)
1819        {
1820            one_ether_usd_price = stringToUint(fina)*100;
1821            
1822            valuee(one_ether_usd_price);
1823        }
1824        
1825        if(b.length ==4)
1826        {
1827             one_ether_usd_price = stringToUint(fina)*10;
1828               valuee(one_ether_usd_price);
1829        }
1830        uint no_of_token;
1831        if(counter >100000000 || now>endBlock)
1832        {
1833            crowdsaleStatus=1;
1834        }
1835        
1836        valuee(counter);
1837        
1838          valuee(now); 
1839          valuee(endBlock);
1840          if(crowdsaleStatus ==3)
1841          {
1842             if((now <= endBlock ) &&  counter <=100000000) 
1843            {
1844                 Price("moreless");
1845                 
1846                if(counter >=0 && counter <= 55000000)
1847                {
1848                    Price("less than 55000000");
1849                     no_of_token = ((one_ether_usd_price*uservalue[userAddress[myid]]))/(200*1000000000000000); 
1850                     counter = counter+no_of_token;
1851                }
1852                 else if(counter >55000000 && counter <= 100000000)
1853                {
1854                     Price("more than 55000000");
1855                      no_of_token = ((one_ether_usd_price*uservalue[userAddress[myid]]))/(500*1000000000000000); 
1856                     counter = counter+no_of_token;
1857                }
1858 
1859            }
1860          }
1861            else
1862            {
1863                 Price("nextt");
1864                  no_of_token = ((one_ether_usd_price*uservalue[userAddress[myid]]))/(20*10000000000000000); 
1865             
1866            }
1867             
1868                  
1869              balances[owner] -= (no_of_token*100000);
1870              balances[userAddress[myid]] += (no_of_token*100000);
1871            // transfer(userAddress[myid],no_of_token);
1872              Transfer(owner, userAddress[myid] , no_of_token);
1873         
1874         Message("Transferred to",userAddress[myid],no_of_token);
1875         
1876         
1877     
1878         
1879        
1880      
1881     // new query for Oraclize!
1882  }
1883 
1884      
1885        // for balance of a account
1886       function balanceOf(address _owner) constant returns (uint256 balance) {
1887           return balances[_owner];
1888       }
1889       
1890           // Transfer the balance from owner's account to another account
1891       function transfer(address _to, uint256 _amount) returns (bool success) {
1892          
1893            
1894           if (balances[msg.sender] >= _amount 
1895               && _amount > 0
1896               && balances[_to] + _amount > balances[_to]) {
1897               balances[msg.sender] -= _amount;
1898               balances[_to] += _amount;
1899               Transfer(msg.sender, _to, _amount);
1900               return true;
1901           } else {
1902               return false;
1903           }
1904       }
1905       
1906    
1907       
1908          // Send _value amount of tokens from address _from to address _to
1909       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
1910       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
1911       // fees in sub-currencies; the command should fail unless the _from account has
1912       // deliberately authorized the sender of the message via some mechanism; we propose
1913       // these standardized APIs for approval:
1914       function transferFrom(
1915           address _from,
1916           address _to,
1917           uint256 _amount
1918      ) returns (bool success) {
1919          if (balances[_from] >= _amount
1920              && allowed[_from][msg.sender] >= _amount
1921              && _amount > 0
1922              && balances[_to] + _amount > balances[_to]) {
1923              balances[_from] -= _amount;
1924              allowed[_from][msg.sender] -= _amount;
1925              balances[_to] += _amount;
1926              Transfer(_from, _to, _amount);
1927              return true;
1928          } else {
1929              return false;
1930          }
1931      }
1932      
1933     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1934      // If this function is called again it overwrites the current allowance with _value.
1935      function approve(address _spender, uint256 _amount) returns (bool success) {
1936          allowed[msg.sender][_spender] = _amount;
1937          Approval(msg.sender, _spender, _amount);
1938          return true;
1939      }
1940   
1941      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1942          return allowed[_owner][_spender];
1943      }
1944      
1945      function convert(uint _value) returns (bool ok)
1946      {
1947          return true;
1948      }
1949      
1950       /*	
1951 	* Finalize the crowdsale
1952 	*/
1953 	function finalize() onlyOwner {
1954     //Make sure IDO is running
1955     if(crowdsaleStatus==0 || crowdsaleStatus==2) throw;   
1956    
1957     //crowdsale is ended
1958 		crowdsaleStatus = 2;
1959 	}
1960 	
1961 	  function transfer_ownership(address to) onlyOwner {
1962         //if it's not the admin or the owner
1963         if (msg.sender != owner) throw;
1964         owner = to;
1965          balances[owner]=balances[msg.sender];
1966          balances[msg.sender]=0;
1967     }
1968 	
1969 	 /*	
1970    * Failsafe drain
1971    */
1972 	function drain() onlyOwner {
1973 		if (!owner.send(this.balance)) throw;
1974 	}
1975 	
1976 	  function stringToUint(string s) constant returns (uint result) {
1977         bytes memory b = bytes(s);
1978         uint i;
1979         result = 0;
1980         for (i = 0; i < b.length; i++) {
1981             uint c = uint(b[i]);
1982             if (c >= 48 && c <= 57) {
1983                 result = result * 10 + (c - 48);
1984                // usd_price=result;
1985                 
1986             }
1987         }
1988     }
1989        
1990  }