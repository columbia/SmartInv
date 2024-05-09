1 pragma solidity^0.4.24;
2 
3 /**
4                         MOBIUS 2D
5                         V2.0
6                      https://m2d.win 
7                                        
8     This game was inspired by FOMO3D. Our code is much cleaner and more efficient (built from scratch).
9     Some useless "features" like the teams were not implemented.
10  */
11 
12 interface MobiusToken {
13     function disburseDividends() external payable;
14 }
15 
16 interface LastVersion {
17     function withdrawReturns() external;
18     function roundInfo(uint roundID) external view 
19     returns(
20         address leader, 
21         uint price,
22         uint jackpot, 
23         uint airdrop, 
24         uint shares, 
25         uint totalInvested,
26         uint distributedReturns,
27         uint _hardDeadline,
28         uint _softDeadline,
29         bool finalized
30         );
31     function totalsInfo() external view 
32     returns(
33         uint totalReturns,
34         uint totalShares,
35         uint totalDividends,
36         uint totalJackpots
37     );
38     function latestRoundID() external returns(uint);
39 }
40 
41 /**
42     The Mobius2D game consists of rounds with guaranteed winners!
43     You buy "shares" (instad of keys) for a given round, and you get returns from investors after you.
44     The sare price is constant until the hard deadline, after which it increases exponentially. 
45     If a round is inactive for a day it can end earlier than the hard deadline.
46     If a round runs longer, it is guaranteed to finish not much after the hard deadline (and the last investor gets the big jackpot).
47     Additionally, if you invest more than 0.1 ETH you get a chance to win an airdrop and you get bonus shares
48     Part of all funds also go to a big final jackpot - the last investor (before a round runs out) wins.
49     Payouts work in REAL TIME - you can withdraw your returns at any time!
50     Additionally, the first round is an ICO, so you'll also get our tokens by participating!
51     !!!!!!!!!!!!!!
52     Token holders will receive part of current and future revenue of this and any other game we develop!
53     !!!!!!!!!!!!!!
54     
55     .................................. LAUGHING MAN sssyyhddmN..........................................
56     ..........................Nmdyyso+/:--.``` :`  `-`:--:/+ossyhdmN....................................
57     ......................Ndhyso/:.`   --.     o.  /+`o::` `` `-:+osyh..................................
58     ..................MNdyso/-` /-`/:+./:/..`  +.  //.o +.+::+ -`  `-/sshdN.............................
59     ................Ndyso:` ` --:+`o//.-:-```  ...  ``` - /::::/ +..-` ./osh............................
60     ..............Nhso/. .-.:/`o--:``   `..-:::oss+::--.``    .:/::/`+-`/../sydN........................
61     ............mhso-``-:+./:-:.   .-/+osssssssssssssssssso+:-`  -//o::+:/` .:oyhN......................
62     ..........Nhso:`  .+-./ `  .:+sssssso+//:-------:://+ossssso/---.`-`/:-o/ `:syd.....................
63     ........Mdyo- +/../`-`  ./osssso/-.`                 ``.:+ossss+:`  `-+`  ` `/sy....................
64     ......MNys/` -:-/:    -+ssss+-`                           `.:+ssss/.  `  -+-. .osh..................
65     ......mys-  :-/+-`  :osss+-`                                  .:osss+.  `//o:- `/syN................
66     ....Mdso. --:-/-  -osss+.                                       `-osss+`  :--://`-sy................
67     ....dso-. ++:+  `/sss+.                                           `:osss:  `:.-+  -sy...............
68     ..Mdso``+///.` .osss:                                               `/sss+`  :/-.. -syN.............
69     ..mss` `+::/  .ssso.                                                  :sss+` `+:/+  -syN............
70     ..ys-   ```  .ssso`                                                    -sss+` `:::+:`/sh............
71     Mds+ `:/..  `osso`                                                      -sss+  -:`.` `ssN...........
72     Mys. `/+::  +sss/........................................................+sss:.....-::+sy..NN.......
73     ds+  :-/-  .ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyyhdN...
74     hs: `/+::   :/+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ossssyhNM
75     ss. `:::`                    ````                        ```                               ``-+sssyN
76     ss` /:-+` `o++:           .:+oooo+/.                 `-/ooooo+-`                               -sssy
77     ss  `:/:  `sss/          :ooo++/++os/`              .oso++/++oso.                               osss
78     ss``/:--  `sss/         ./.`      `.::              /-.`     ``-/`                             -sssy
79     ss.:::-:.  ssso         `            `                                                    ``.-+sssyN
80     hs:`:/:/.  /sss.   .++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++oossssyhNM
81     ds+ ``     .sss/   -ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyyyyhmN...
82     Nss.:::::.  +sss.   +sss/........................................osss:...+sss:......../shmNNN.......
83     Mds+..-:::` `osso`  `+sss:                                     `+sss:   -sss+  .:-.` `ssN...........
84     ..ys- .+.::  .ssso`  `/sss+.                                  -osss:   -sss+` `:++-` /sh............
85     ..mss` .-.    .ssso.   :osss/`                              .+ssso.   :sss+` `.:+:` -syN............
86     ..Mdso`  `--:` .osss:   `/ssss/.`                        `-+ssso:`  `/sss+` `++.-. -syN.............
87     ....dso` -//+-` `/sss+.   ./ossso/-``                `.:+sssso:`  `:osss:  .::+/. -sy...............
88     ....Mdso. `-//-`  -osss+.   `-+ssssso+/:-.`````..-:/+osssso/.   `-osss+.` -///-  -sy................
89     ......mys- `/://.`  :osss+-`   `-/+osssssssssssssssssso+:.    .:osss+.  .:`..-``/syN................
90     ......MNys/` ..+-/:   -+ssss+-`    `.-://++oooo++/:-.`    `.:+ssss/.  .`      .osh..................
91     ........Mdyo- `::/.  `  ./osssso/-.`                 ``.:+ossss+:` `  .//`  `/sy....................
92     ..........Nhso-     :+:.`  .:+sssssso+//:--------://+ossssso/:.  `::/: --/.:syd.....................
93     ............mhso-` ./+--+-:    .-/+osssssssssssssssssso+/-.  .+` `//-/ `::oyhN......................
94     ..............Nhso/`   +/:--+.-`    `..-:::////::--.``    .`:/-o`  ./`./sydN........................
95     ................Ndys+:` ``--+++-  .:  `.``      `` -.`/:/`.o./::.  ./osh............................
96     ..................MNdyso/-` ` :`  +-  :+.o`s ::-/++`s`+/o.-:`  `-/sshdN.............................
97     ......................Ndhyso/:.` .+   +/:/ +:/-./:-`+: `` `.:+osyh..................................
98     ..........................Nmdyyso+/:--/.``      ``..-:/+ossyhdmN....................................
99     ..............................MN..dhhyyssssssssssssyyhddmN..........................................
100  */
101  
102  contract DSMath {
103     function add(uint x, uint y) internal pure returns (uint z) {
104         require((z = x + y) >= x);
105     }
106     function sub(uint x, uint y) internal pure returns (uint z) {
107         require((z = x - y) <= x);
108     }
109     function mul(uint x, uint y) internal pure returns (uint z) {
110         require(y == 0 || (z = x * y) / y == x);
111     }
112 
113     function min(uint x, uint y) internal pure returns (uint z) {
114         return x <= y ? x : y;
115     }
116     function max(uint x, uint y) internal pure returns (uint z) {
117         return x >= y ? x : y;
118     }
119     function imin(int x, int y) internal pure returns (int z) {
120         return x <= y ? x : y;
121     }
122     function imax(int x, int y) internal pure returns (int z) {
123         return x >= y ? x : y;
124     }
125 
126     uint constant WAD = 10 ** 18;
127     uint constant RAY = 10 ** 27;
128 
129     function wmul(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, y), WAD / 2) / WAD;
131     }
132     function rmul(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, y), RAY / 2) / RAY;
134     }
135     function wdiv(uint x, uint y) internal pure returns (uint z) {
136         z = add(mul(x, WAD), y / 2) / y;
137     }
138     function rdiv(uint x, uint y) internal pure returns (uint z) {
139         z = add(mul(x, RAY), y / 2) / y;
140     }
141 
142     // This famous algorithm is called "exponentiation by squaring"
143     // and calculates x^n with x as fixed-point and n as regular unsigned.
144     //
145     // It's O(log n), instead of O(n) for naive repeated multiplication.
146     //
147     // These facts are why it works:
148     //
149     //  If n is even, then x^n = (x^2)^(n/2).
150     //  If n is odd,  then x^n = x * x^(n-1),
151     //   and applying the equation for even x gives
152     //    x^n = x * (x^2)^((n-1) / 2).
153     //
154     //  Also, EVM division is flooring and
155     //    floor[(n-1) / 2] = floor[n / 2].
156     //
157     function rpow(uint x, uint n) internal pure returns (uint z) {
158         z = n % 2 != 0 ? x : RAY;
159 
160         for (n /= 2; n != 0; n /= 2) {
161             x = rmul(x, x);
162 
163             if (n % 2 != 0) {
164                 z = rmul(z, x);
165             }
166         }
167     }
168 }
169 
170 contract DSA {
171     function canCall(
172         address src, address dst, bytes4 sig
173     ) public view returns (bool);
174 }
175 
176 contract DSAuthEvents {
177     event LogSetOrcl (address indexed authority);
178     event LogSetOwner     (address indexed owner);
179 }
180 
181 contract DSAuth is DSAuthEvents {
182     DSA  public  a;
183     address      public  owner;
184 
185     constructor() public {
186         owner = msg.sender;
187         emit LogSetOwner(msg.sender);
188     }
189 
190     function setOwner(address owner_)
191         public
192         auth
193     {
194         owner = owner_;
195         emit LogSetOwner(owner);
196     }
197 
198     function setOrcl(DSA a_)
199         public
200         auth
201     {
202         a = a_;
203         emit LogSetOrcl(a);
204     }
205 
206     modifier auth {
207         require(isAuthorized(msg.sender, msg.sig));
208         _;
209     }
210 
211     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
212         if (src == address(this)) {
213             return true;
214         } else if (src == owner) {
215             return true;
216         } else if (a == DSA(0)) {
217             return false;
218         } else {
219             return a.canCall(src, this, sig);
220         }
221     }
222 }
223 
224 
225 contract OraclizeI {
226     address public cbAddress;
227     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
228     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
229     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
230     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
231     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
232     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
233     function getPrice(string _datasource) public returns (uint _dsprice);
234     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
235     function setProofType(byte _proofType) external;
236     function setCustomGasPrice(uint _gasPrice) external;
237     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
238 }
239 
240 contract OraclizeAddrResolverI {
241     function getAddress() public returns (address _addr);
242 }
243 
244 /*
245 Begin solidity-cborutils
246 
247 https://github.com/smartcontractkit/solidity-cborutils
248 
249 MIT License
250 
251 Copyright (c) 2018 SmartContract ChainLink, Ltd.
252 
253 Permission is hereby granted, free of charge, to any person obtaining a copy
254 of this software and associated documentation files (the "Software"), to deal
255 in the Software without restriction, including without limitation the rights
256 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
257 copies of the Software, and to permit persons to whom the Software is
258 furnished to do so, subject to the following conditions:
259 
260 The above copyright notice and this permission notice shall be included in all
261 copies or substantial portions of the Software.
262 
263 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
264 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
265 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
266 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
267 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
268 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
269 SOFTWARE.
270  */
271 
272 library Buffer {
273     struct buffer {
274         bytes buf;
275         uint capacity;
276     }
277 
278     function init(buffer memory buf, uint _capacity) internal pure {
279         uint capacity = _capacity;
280         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
281         // Allocate space for the buffer data
282         buf.capacity = capacity;
283         assembly {
284             let ptr := mload(0x40)
285             mstore(buf, ptr)
286             mstore(ptr, 0)
287             mstore(0x40, add(ptr, capacity))
288         }
289     }
290 
291     function resize(buffer memory buf, uint capacity) private pure {
292         bytes memory oldbuf = buf.buf;
293         init(buf, capacity);
294         append(buf, oldbuf);
295     }
296 
297     function max(uint a, uint b) private pure returns(uint) {
298         if(a > b) {
299             return a;
300         }
301         return b;
302     }
303 
304     /**
305      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
306      *      would exceed the capacity of the buffer.
307      * @param buf The buffer to append to.
308      * @param data The data to append.
309      * @return The original buffer.
310      */
311     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
312         if(data.length + buf.buf.length > buf.capacity) {
313             resize(buf, max(buf.capacity, data.length) * 2);
314         }
315 
316         uint dest;
317         uint src;
318         uint len = data.length;
319         assembly {
320             // Memory address of the buffer data
321             let bufptr := mload(buf)
322             // Length of existing buffer data
323             let buflen := mload(bufptr)
324             // Start address = buffer address + buffer length + sizeof(buffer length)
325             dest := add(add(bufptr, buflen), 32)
326             // Update buffer length
327             mstore(bufptr, add(buflen, mload(data)))
328             src := add(data, 32)
329         }
330 
331         // Copy word-length chunks while possible
332         for(; len >= 32; len -= 32) {
333             assembly {
334                 mstore(dest, mload(src))
335             }
336             dest += 32;
337             src += 32;
338         }
339 
340         // Copy remaining bytes
341         uint mask = 256 ** (32 - len) - 1;
342         assembly {
343             let srcpart := and(mload(src), not(mask))
344             let destpart := and(mload(dest), mask)
345             mstore(dest, or(destpart, srcpart))
346         }
347 
348         return buf;
349     }
350 
351     /**
352      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
353      * exceed the capacity of the buffer.
354      * @param buf The buffer to append to.
355      * @param data The data to append.
356      * @return The original buffer.
357      */
358     function append(buffer memory buf, uint8 data) internal pure {
359         if(buf.buf.length + 1 > buf.capacity) {
360             resize(buf, buf.capacity * 2);
361         }
362 
363         assembly {
364             // Memory address of the buffer data
365             let bufptr := mload(buf)
366             // Length of existing buffer data
367             let buflen := mload(bufptr)
368             // Address = buffer address + buffer length + sizeof(buffer length)
369             let dest := add(add(bufptr, buflen), 32)
370             mstore8(dest, data)
371             // Update buffer length
372             mstore(bufptr, add(buflen, 1))
373         }
374     }
375 
376     /**
377      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
378      * exceed the capacity of the buffer.
379      * @param buf The buffer to append to.
380      * @param data The data to append.
381      * @return The original buffer.
382      */
383     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
384         if(len + buf.buf.length > buf.capacity) {
385             resize(buf, max(buf.capacity, len) * 2);
386         }
387 
388         uint mask = 256 ** len - 1;
389         assembly {
390             // Memory address of the buffer data
391             let bufptr := mload(buf)
392             // Length of existing buffer data
393             let buflen := mload(bufptr)
394             // Address = buffer address + buffer length + sizeof(buffer length) + len
395             let dest := add(add(bufptr, buflen), len)
396             mstore(dest, or(and(mload(dest), not(mask)), data))
397             // Update buffer length
398             mstore(bufptr, add(buflen, len))
399         }
400         return buf;
401     }
402 }
403 
404 library CBOR {
405     using Buffer for Buffer.buffer;
406 
407     uint8 private constant MAJOR_TYPE_INT = 0;
408     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
409     uint8 private constant MAJOR_TYPE_BYTES = 2;
410     uint8 private constant MAJOR_TYPE_STRING = 3;
411     uint8 private constant MAJOR_TYPE_ARRAY = 4;
412     uint8 private constant MAJOR_TYPE_MAP = 5;
413     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
414 
415     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
416         if(value <= 23) {
417             buf.append(uint8((major << 5) | value));
418         } else if(value <= 0xFF) {
419             buf.append(uint8((major << 5) | 24));
420             buf.appendInt(value, 1);
421         } else if(value <= 0xFFFF) {
422             buf.append(uint8((major << 5) | 25));
423             buf.appendInt(value, 2);
424         } else if(value <= 0xFFFFFFFF) {
425             buf.append(uint8((major << 5) | 26));
426             buf.appendInt(value, 4);
427         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
428             buf.append(uint8((major << 5) | 27));
429             buf.appendInt(value, 8);
430         }
431     }
432 
433     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
434         buf.append(uint8((major << 5) | 31));
435     }
436 
437     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
438         encodeType(buf, MAJOR_TYPE_INT, value);
439     }
440 
441     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
442         if(value >= 0) {
443             encodeType(buf, MAJOR_TYPE_INT, uint(value));
444         } else {
445             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
446         }
447     }
448 
449     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
450         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
451         buf.append(value);
452     }
453 
454     function encodeString(Buffer.buffer memory buf, string value) internal pure {
455         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
456         buf.append(bytes(value));
457     }
458 
459     function startArray(Buffer.buffer memory buf) internal pure {
460         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
461     }
462 
463     function startMap(Buffer.buffer memory buf) internal pure {
464         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
465     }
466 
467     function endSequence(Buffer.buffer memory buf) internal pure {
468         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
469     }
470 }
471 
472 /*
473 End solidity-cborutils
474  */
475 
476 contract usingOraclize is DSAuth {
477     byte constant proofType_NONE = 0x00;
478     byte constant proofType_TLSNotary = 0x10;
479     byte constant proofType_Ledger = 0x30;
480     byte constant proofType_Android = 0x40;
481     byte constant proofType_Native = 0xF0;
482     byte constant proofStorage_IPFS = 0x01;
483     uint8 constant networkID_auto = 0;
484     uint8 constant networkID_mainnet = 1;
485     uint8 constant networkID_testnet = 2;
486     uint8 constant networkID_morden = 2;
487     uint8 constant networkID_consensys = 161;
488 
489     OraclizeAddrResolverI OAR;
490 
491     OraclizeI oraclize;
492     modifier oraclizeAPI {
493         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
494             oraclize_setNetwork(networkID_auto);
495 
496         if(address(oraclize) != OAR.getAddress())
497             oraclize = OraclizeI(OAR.getAddress());
498 
499         _;
500     }
501     modifier coupon(string code){
502         oraclize = OraclizeI(OAR.getAddress());
503         _;
504     }
505 
506     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
507       return oraclize_setNetwork();
508       networkID; // silence the warning and remain backwards compatible
509     }
510     function oraclize_setNetwork() internal returns(bool){
511         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
512             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
513             oraclize_setNetworkName("eth_mainnet");
514             return true;
515         }
516         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
517             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
518             oraclize_setNetworkName("eth_ropsten3");
519             return true;
520         }
521         
522         return false;
523     }
524 
525     function oraclize_cbAddress() oraclizeAPI internal returns (address){
526         return oraclize.cbAddress();
527     }
528 
529     function __callback(bytes32 myid, string result) public {
530         __callback(myid, result, new bytes(0));
531     }
532     
533     function __callback(bytes32 myid, string result, bytes proof) public {
534       return;
535       // Following should never be reached with a preceding return, however
536       // this is just a placeholder function, ideally meant to be defined in
537       // child contract when proofs are used
538       myid; result; proof; // Silence compiler warnings
539       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
540     }
541 
542     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
543         return oraclize.getPrice(datasource);
544     }
545 
546     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
547         return oraclize.getPrice(datasource, gaslimit);
548     }
549 
550     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
551         uint price = oraclize.getPrice(datasource, gaslimit);
552         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
553         bytes memory args = ba2cbor(argN);
554         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
555     }
556 
557     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
558         bytes[] memory dynargs = new bytes[](4);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         dynargs[3] = args[3];
563         return oraclize_query(datasource, dynargs, gaslimit);
564     }
565 
566     function oraclize_setProof(byte proofP) oraclizeAPI internal {
567         return oraclize.setProofType(proofP);
568     }
569     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
570         return oraclize.setCustomGasPrice(gasPrice);
571     }
572 
573     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
574         return oraclize.randomDS_getSessionPubKeyHash();
575     }
576 
577     function getCodeSize(address _addr) view internal returns(uint _size) {
578         assembly {
579             _size := extcodesize(_addr)
580         }
581     }
582 
583     using CBOR for Buffer.buffer;
584 
585     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
586         safeMemoryCleaner();
587         Buffer.buffer memory buf;
588         Buffer.init(buf, 1024);
589         buf.startArray();
590         for (uint i = 0; i < arr.length; i++) {
591             buf.encodeBytes(arr[i]);
592         }
593         buf.endSequence();
594         return buf.buf;
595     }
596 
597     string oraclize_network_name;
598     function oraclize_setNetworkName(string _network_name) internal {
599         oraclize_network_name = _network_name;
600     }
601 
602     function oraclize_getNetworkName() internal view returns (string) {
603         return oraclize_network_name;
604     }
605 
606     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
607         require((_nbytes > 0) && (_nbytes <= 32));
608         // Convert from seconds to ledger timer ticks
609         _delay *= 10;
610         bytes memory nbytes = new bytes(1);
611         nbytes[0] = byte(_nbytes);
612         bytes memory unonce = new bytes(32);
613         bytes memory sessionKeyHash = new bytes(32);
614         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
615         assembly {
616             mstore(unonce, 0x20)
617             // the following variables can be relaxed
618             // check relaxed random contract under ethereum-examples repo
619             // for an idea on how to override and replace comit hash vars
620             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
621             mstore(sessionKeyHash, 0x20)
622             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
623         }
624         bytes memory delay = new bytes(32);
625         assembly {
626             mstore(add(delay, 0x20), _delay)
627         }
628 
629         bytes memory delay_bytes8 = new bytes(8);
630         copyBytes(delay, 24, 8, delay_bytes8, 0);
631 
632         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
633         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
634 
635         bytes memory delay_bytes8_left = new bytes(8);
636 
637         assembly {
638             let x := mload(add(delay_bytes8, 0x20))
639             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
640             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
641             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
642             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
643             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
644             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
645             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
646             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
647 
648         }
649 
650         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
651         return queryId;
652     }
653 
654     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
655         oraclize_randomDS_args[queryId] = commitment;
656     }
657 
658     mapping(bytes32=>bytes32) oraclize_randomDS_args;
659     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
660 
661     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
662         bool sigok;
663         address signer;
664 
665         bytes32 sigr;
666         bytes32 sigs;
667 
668         bytes memory sigr_ = new bytes(32);
669         uint offset = 4+(uint(dersig[3]) - 0x20);
670         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
671         bytes memory sigs_ = new bytes(32);
672         offset += 32 + 2;
673         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
674 
675         assembly {
676             sigr := mload(add(sigr_, 32))
677             sigs := mload(add(sigs_, 32))
678         }
679 
680 
681         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
682         if (address(keccak256(pubkey)) == signer) return true;
683         else {
684             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
685             return (address(keccak256(pubkey)) == signer);
686         }
687     }
688 
689     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
690         bool sigok;
691 
692         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
693         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
694         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
695 
696         bytes memory appkey1_pubkey = new bytes(64);
697         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
698 
699         bytes memory tosign2 = new bytes(1+65+32);
700         tosign2[0] = byte(1); //role
701         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
702         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
703         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
704         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
705 
706         if (sigok == false) return false;
707 
708 
709         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
710         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
711 
712         bytes memory tosign3 = new bytes(1+65);
713         tosign3[0] = 0xFE;
714         copyBytes(proof, 3, 65, tosign3, 1);
715 
716         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
717         copyBytes(proof, 3+65, sig3.length, sig3, 0);
718 
719         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
720 
721         return sigok;
722     }
723 
724     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
725         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
726         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
727 
728         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
729         require(proofVerified);
730 
731         _;
732     }
733 
734     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
735         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
736         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
737 
738         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
739         if (proofVerified == false) return 2;
740 
741         return 0;
742     }
743 
744     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
745         bool match_ = true;
746 
747         require(prefix.length == n_random_bytes);
748 
749         for (uint256 i=0; i< n_random_bytes; i++) {
750             if (content[i] != prefix[i]) match_ = false;
751         }
752 
753         return match_;
754     }
755 
756     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
757 
758         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
759         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
760         bytes memory keyhash = new bytes(32);
761         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
762         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
763 
764         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
765         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
766 
767         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
768         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
769 
770         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
771         // This is to verify that the computed args match with the ones specified in the query.
772         bytes memory commitmentSlice1 = new bytes(8+1+32);
773         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
774 
775         bytes memory sessionPubkey = new bytes(64);
776         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
777         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
778 
779         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
780         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
781             delete oraclize_randomDS_args[queryId];
782         } else return false;
783 
784 
785         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
786         bytes memory tosign1 = new bytes(32+8+1+32);
787         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
788         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
789 
790         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
791         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
792             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
793         }
794 
795         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
796     }
797 
798     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
799     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
800         uint minLength = length + toOffset;
801 
802         // Buffer too small
803         require(to.length >= minLength); // Should be a better way?
804 
805         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
806         uint i = 32 + fromOffset;
807         uint j = 32 + toOffset;
808 
809         while (i < (32 + fromOffset + length)) {
810             assembly {
811                 let tmp := mload(add(from, i))
812                 mstore(add(to, j), tmp)
813             }
814             i += 32;
815             j += 32;
816         }
817 
818         return to;
819     }
820 
821     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
822     // Duplicate Solidity's ecrecover, but catching the CALL return value
823     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
824         // We do our own memory management here. Solidity uses memory offset
825         // 0x40 to store the current end of memory. We write past it (as
826         // writes are memory extensions), but don't update the offset so
827         // Solidity will reuse it. The memory used here is only needed for
828         // this context.
829 
830         // FIXME: inline assembly can't access return values
831         bool ret;
832         address addr;
833 
834         assembly {
835             let size := mload(0x40)
836             mstore(size, hash)
837             mstore(add(size, 32), v)
838             mstore(add(size, 64), r)
839             mstore(add(size, 96), s)
840 
841             // NOTE: we can reuse the request memory because we deal with
842             //       the return code
843             ret := call(3000, 1, 0, size, 128, size, 32)
844             addr := mload(size)
845         }
846 
847         return (ret, addr);
848     }
849 
850     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
851     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
852         bytes32 r;
853         bytes32 s;
854         uint8 v;
855 
856         if (sig.length != 65)
857           return (false, 0);
858 
859         // The signature format is a compact form of:
860         //   {bytes32 r}{bytes32 s}{uint8 v}
861         // Compact means, uint8 is not padded to 32 bytes.
862         assembly {
863             r := mload(add(sig, 32))
864             s := mload(add(sig, 64))
865 
866             // Here we are loading the last 32 bytes. We exploit the fact that
867             // 'mload' will pad with zeroes if we overread.
868             // There is no 'mload8' to do this, but that would be nicer.
869             v := byte(0, mload(add(sig, 96)))
870 
871             // Alternative solution:
872             // 'byte' is not working due to the Solidity parser, so lets
873             // use the second best option, 'and'
874             // v := and(mload(add(sig, 65)), 255)
875         }
876 
877         // albeit non-transactional signatures are not specified by the YP, one would expect it
878         // to match the YP range of [27, 28]
879         //
880         // geth uses [0, 1] and some clients have followed. This might change, see:
881         //  https://github.com/ethereum/go-ethereum/issues/2053
882         if (v < 27)
883           v += 27;
884 
885         if (v != 27 && v != 28)
886             return (false, 0);
887 
888         return safer_ecrecover(hash, v, r, s);
889     }
890 
891     function safeMemoryCleaner() internal pure {
892         assembly {
893             let fmem := mload(0x40)
894             codecopy(fmem, codesize, sub(msize, fmem))
895         }
896     }
897 
898 }
899 
900 contract UsingOraclizeRandom is usingOraclize {
901     uint public oraclizeCallbackGas = 200000;
902     uint public oraclizeGasPrice = 20000000000; //20 gwei
903     uint public totalPaidOraclize;
904     uint internal oraclizeLastRequestTime;
905     bool internal oraclizePending;
906 
907     mapping(bytes32=>bool) internal validQueryIDs;
908 
909     constructor() public {
910         a = DSA(0xdbf98a75f521Cb1BD421c03F2b6A6a617f4240F1);
911     }
912 
913     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
914         oraclizePending = false;
915         require(validQueryIDs[_queryId], "Invalid request ID!");
916         require(msg.sender == oraclize_cbAddress(), "You can't do that!");
917         
918         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
919             _onRandomFailed(_queryId);
920         } else {
921             uint randomNumber = uint(keccak256(abi.encode(_result)));
922             _onRandom(randomNumber, _queryId);
923         }
924         delete validQueryIDs[_queryId];
925     }
926 
927     function _requestRandom(uint delay) internal returns(bytes32 qID) {
928         qID = oraclize_newRandomDSQuery(delay, 32, oraclizeCallbackGas);
929         validQueryIDs[qID] = true;
930     }
931 
932     function _onRandom(uint _rand, bytes32 _queryId) internal;
933 
934     function _onRandomFailed(bytes32 _queryId) internal;
935 
936     function setOraclizeGasLimit(uint _newLimit) public auth {
937         oraclizeCallbackGas = _newLimit;
938     }
939 
940     function setOraclizeGasPrice(uint _newGasPrice) public auth {
941         oraclizeGasPrice = _newGasPrice;
942         oraclize_setCustomGasPrice(_newGasPrice);
943     }
944 
945     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
946         oraclizePending = true; // overriding the dafault function to add this line
947         oraclizeLastRequestTime = now; // overriding the dafault function to add this line
948         uint price = oraclize.getPrice(datasource, gaslimit);
949         totalPaidOraclize += price; // overriding the dafault function to add this line
950         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
951         bytes memory args = ba2cbor(argN);
952         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
953     }
954 
955 }
956 // </ORACLIZE_API>
957 
958  
959 contract Mobius2Dv2 is UsingOraclizeRandom, DSMath {
960     // IPFS hash of the website - can be accessed even if our domain goes down.
961     // Just go to any public IPFS gateway and use this hash - e.g. ipfs.infura.io/ipfs/<ipfsHash>
962     string public ipfsHash;
963     string public ipfsHashType = "ipfs"; // can either be ipfs, or ipns
964 
965     MobiusToken public constant token = MobiusToken(0x54cdC9D889c28f55F59f6b136822868c7d4726fC);
966 
967     // In case of an upgrade, these variables will be set. An upgrade does not affect a currently running round,
968     // nor does it do anything with investors' vaults.
969     bool public upgraded;
970     bool public initialized;
971     address public nextVersion;
972     LastVersion public constant lastVersion = LastVersion(0xA74642Aeae3e2Fd79150c910eB5368B64f864B1e);
973     uint public previousRounds;// how many rounds the last version had
974 
975     // Total stats
976     uint public totalRevenue;
977     uint public totalSharesSold;
978     uint public totalEarningsGenerated;
979     uint public totalDividendsPaid;
980     uint public totalJackpotsWon;
981 
982     // Fractions for where revenue goes
983     uint public constant DEV_DIVISOR = 20;                      // 5% 
984 
985     uint public constant RETURNS_FRACTION = 60 * 10**16;        // 60% goes to share holders
986     // this value will be taken from the above fraction (e.g. if 3% is for refferals, then 57% goes to returns) 
987     uint public constant REFERRAL_FRACTION = 3 * 10**16;        //3% for referrals
988 
989     uint public constant JACKPOT_SEED_FRACTION = WAD / 20;      // 5% goes to the next round's jackpot
990     uint public constant JACKPOT_FRACTION = 15 * 10**16;        // 15% goes to the final jackpot
991     uint public constant DAILY_JACKPOT_FRACTION = 6 * 10**16;    // 6% goes to daily jackpots
992     uint public constant DIVIDENDS_FRACTION = 9 * 10**16;       // 9% goes to token holders!
993 
994     // NOTE: These parameters can be changed. If they are changed, the new values only affect the next round (not a currently running one)
995     uint public startingSharePrice = 1 finney;   // a 1000th of an ETH
996     uint public _priceIncreasePeriod = 1 hours;  // how often the price increases
997     uint public _priceMultiplier = 101 * 10**16; // 101% - increase by 1% each increase period
998 
999     uint public _secondaryPrice = 100 finney;    // The minimum value to enter the daily jackpot draw
1000     uint public maxDailyJackpot = 5 ether; // Limit the max daily jackpot, so that it doesn't deplete quickly after a period of rapid growth
1001 
1002     uint public constant SOFT_DEADLINE_DURATION = 1 days; // max soft deadline
1003     uint public constant DAILY_JACKPOT_PERIOD = 1 days;
1004     uint public constant TIME_PER_SHARE = 5 minutes; // how much time is added to the soft deadline per share purchased
1005 
1006     uint public nextRoundTime; // this can be set as a delay before the next round can be started
1007     uint public jackpotSeed;// Jackpot from previous rounds
1008     uint public devBalance; // outstanding balance for devs
1009 
1010     // Helpers to calculate returns - no funds are ever held on lockdown
1011     uint public unclaimedReturns;
1012     uint public constant MULTIPLIER = RAY;
1013 
1014     // To keep track of players latest daily jackpot entry
1015     mapping (address => uint) public lastDailyEntry;
1016 
1017     // This represents an investor. No need to player IDs - they are useless (everyone already has a unique address).
1018     // Just use native mappings (duh!)
1019     struct Investor {
1020         uint lastCumulativeReturnsPoints;
1021         uint shares;
1022     }
1023 
1024     // This represents a round
1025     struct MobiusRound {
1026         uint totalInvested;        
1027         uint jackpot;
1028         uint dailyJackpot;
1029         uint totalShares;
1030         uint cumulativeReturnsPoints; // this is to help calculate returns when the total number of shares changes
1031         uint softDeadline;
1032         uint price;
1033         uint secondaryPrice;
1034         uint priceMultiplier;
1035         uint priceIncreasePeriod;
1036         uint lastPriceIncreaseTime;
1037         uint lastDailyJackpot;
1038         address lastInvestor;
1039         bool finalized;
1040         mapping (address => Investor) investors;
1041     }
1042 
1043     struct DailyJackpotRound {
1044         address[] entrants;
1045         address winner;
1046         bool finalized;
1047     }
1048 
1049     struct Vault {
1050         uint totalReturns; // Total balance = returns + referral returns + jackpots/airdrops 
1051         uint refReturns; // how much of the total is from referrals
1052     }
1053 
1054     mapping (address => Vault) vaults;
1055 
1056     uint public latestRoundID;// the first round has an ID of 0
1057     uint public latestDailyID;// daily round ID
1058     MobiusRound[] rounds;
1059     DailyJackpotRound[] dailyRounds;
1060 
1061     event SharesIssued(address indexed to, uint shares);
1062     event ReturnsWithdrawn(address indexed by, uint amount);
1063     event JackpotWon(address by, uint amount);
1064     event DailyJackpotWon(address indexed by, uint amount);
1065     event RoundStarted(uint ID, uint startingPrice, uint priceMultiplier, uint priceIncreasePeriod);
1066     event IPFSHashSet(string _type, string _hash);
1067 
1068     constructor() public {
1069     }
1070 
1071     function initOraclize() public auth {
1072         oraclizeCallbackGas = 250000;
1073         if(oraclize_setNetwork()){
1074             oraclize_setProof(proofType_Ledger);
1075         }
1076     }
1077 
1078     // The return values will include all vault balance, but you must specify a roundID because
1079     // Returns are not actually calculated in storage until you invest in the round or withdraw them
1080     function estimateReturns(address investor, uint roundID) public view 
1081     returns (uint totalReturns, uint refReturns) 
1082     {
1083         MobiusRound storage rnd = rounds[roundID];
1084         uint outstanding;
1085         if(rounds.length > 1) {
1086             if(hasReturns(investor, roundID - 1)) {
1087                 MobiusRound storage prevRnd = rounds[roundID - 1];
1088                 outstanding = _outstandingReturns(investor, prevRnd);
1089             }
1090         }
1091 
1092         outstanding += _outstandingReturns(investor, rnd);
1093         
1094         totalReturns = vaults[investor].totalReturns + outstanding;
1095         refReturns = vaults[investor].refReturns;
1096     }
1097 
1098     function hasReturns(address investor, uint roundID) public view returns (bool) {
1099         MobiusRound storage rnd = rounds[roundID];
1100         return rnd.cumulativeReturnsPoints > rnd.investors[investor].lastCumulativeReturnsPoints;
1101     }
1102 
1103     function investorInfo(address investor, uint roundID) external view
1104     returns(uint shares, uint totalReturns, uint referralReturns, bool inNextDailyDraw) 
1105     {
1106         MobiusRound storage rnd = rounds[roundID];
1107         shares = rnd.investors[investor].shares;
1108         (totalReturns, referralReturns) = estimateReturns(investor, roundID);
1109         inNextDailyDraw = lastDailyEntry[investor] > rnd.lastDailyJackpot;
1110     }
1111 
1112     function roundInfo(uint roundID) external view 
1113     returns(
1114         address leader, 
1115         uint price,
1116         uint secondaryPrice,
1117         uint priceMultiplier,
1118         uint priceIncreasePeriod,
1119         uint jackpot, 
1120         uint dailyJackpot, 
1121         uint lastDailyJackpot,
1122         uint shares, 
1123         uint totalInvested,
1124         uint distributedReturns,
1125         uint _softDeadline,
1126         bool finalized
1127         )
1128     {
1129         MobiusRound storage rnd = rounds[roundID];
1130         leader = rnd.lastInvestor;
1131         price = rnd.price;
1132         secondaryPrice = _secondaryPrice;
1133         priceMultiplier = rnd.priceMultiplier;
1134         priceIncreasePeriod = rnd.priceIncreasePeriod;
1135         jackpot = rnd.jackpot;
1136         dailyJackpot = min(maxDailyJackpot, rnd.dailyJackpot/2);
1137         lastDailyJackpot = rnd.lastDailyJackpot;
1138         shares = rnd.totalShares;
1139         totalInvested = rnd.totalInvested;
1140         distributedReturns = wmul(rnd.totalInvested, RETURNS_FRACTION);
1141         _softDeadline = rnd.softDeadline;
1142         finalized = rnd.finalized;
1143     }
1144 
1145     function totalsInfo() external view 
1146     returns(
1147         uint totalReturns,
1148         uint totalShares,
1149         uint totalDividends,
1150         uint totalJackpots,
1151         uint totalInvested,
1152         uint totalRounds
1153     ) {
1154         MobiusRound storage rnd = rounds[latestRoundID];
1155         if(rnd.softDeadline > now) {
1156             totalShares = totalSharesSold + rnd.totalShares;
1157             totalReturns = totalEarningsGenerated + wmul(rnd.totalInvested, RETURNS_FRACTION);
1158             totalDividends = totalDividendsPaid + wmul(rnd.totalInvested, DIVIDENDS_FRACTION);
1159             totalInvested = totalRevenue + rnd.totalInvested;
1160         } else {
1161             totalShares = totalSharesSold;
1162             totalReturns = totalEarningsGenerated;
1163             totalDividends = totalDividendsPaid;
1164             totalInvested = totalRevenue;
1165         }
1166         totalJackpots = totalJackpotsWon;
1167         totalRounds = previousRounds + rounds.length;
1168     }
1169 
1170     function () public payable {
1171         if(!initialized){
1172             jackpotSeed += msg.value;
1173         } else {
1174             buyShares(address(0x0));
1175         }
1176     }
1177 
1178     /// Function to buy shares in the latest round. Purchase logic is abstracted
1179     function buyShares(address ref) public payable {        
1180         if(rounds.length > 0) {
1181             MobiusRound storage rnd = rounds[latestRoundID];                  
1182             _purchase(rnd, msg.value, ref);            
1183         } else {
1184             revert("Not yet started");
1185         }
1186     }
1187 
1188     /// Function to purchase with what you have in your vault as returns
1189     function reinvestReturns(uint value) public {        
1190         reinvestReturns(value, address(0x0));
1191     }
1192 
1193     function reinvestReturns(uint value, address ref) public {        
1194         MobiusRound storage rnd = rounds[latestRoundID];
1195         _updateReturns(msg.sender, rnd);        
1196         require(vaults[msg.sender].totalReturns >= value, "Can't spend what you don't have");        
1197         vaults[msg.sender].totalReturns = sub(vaults[msg.sender].totalReturns, value);
1198         vaults[msg.sender].refReturns = min(vaults[msg.sender].refReturns, vaults[msg.sender].totalReturns);
1199         unclaimedReturns = sub(unclaimedReturns, value);
1200         _purchase(rnd, value, ref);
1201     }
1202 
1203     function withdrawReturns() public {
1204         MobiusRound storage rnd = rounds[latestRoundID];
1205 
1206         if(rounds.length > 1) {// check if they also have returns from before
1207             if(hasReturns(msg.sender, latestRoundID - 1)) {
1208                 MobiusRound storage prevRnd = rounds[latestRoundID - 1];
1209                 _updateReturns(msg.sender, prevRnd);
1210             }
1211         }
1212         _updateReturns(msg.sender, rnd);
1213         uint amount = vaults[msg.sender].totalReturns;
1214         require(amount > 0, "Nothing to withdraw!");
1215         unclaimedReturns = sub(unclaimedReturns, amount);
1216         vaults[msg.sender].totalReturns = 0;
1217         vaults[msg.sender].refReturns = 0;
1218         
1219         rnd.investors[msg.sender].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
1220         msg.sender.transfer(amount);
1221 
1222         emit ReturnsWithdrawn(msg.sender, amount);
1223     }
1224 
1225     // Manually update your returns for a given round in case you were inactive since before it ended
1226     function updateMyReturns(uint roundID) public {
1227         MobiusRound storage rnd = rounds[roundID];
1228         _updateReturns(msg.sender, rnd);
1229     }
1230 
1231     function finalizeAndRestart() public payable {
1232         finalizeLastRound();
1233         startNewRound();
1234     }
1235 
1236     /// Anyone can start a new round
1237     function startNewRound() public payable {
1238         require(!upgraded && initialized, "This contract has been upgraded, or is not yet initialized!");
1239         require(now >= nextRoundTime, "Too early!");
1240         if(rounds.length > 0) {
1241             require(rounds[latestRoundID].finalized, "Previous round not finalized");
1242             require(rounds[latestRoundID].softDeadline < now, "Previous round still running");
1243         }
1244         uint _rID = rounds.length++;
1245         MobiusRound storage rnd = rounds[_rID];
1246         latestRoundID = _rID;
1247 
1248         rnd.lastInvestor = msg.sender;
1249         rnd.price = startingSharePrice;
1250         rnd.secondaryPrice = _secondaryPrice;
1251         rnd.priceMultiplier = _priceMultiplier;
1252         rnd.priceIncreasePeriod = _priceIncreasePeriod;
1253         rnd.lastPriceIncreaseTime = now;
1254         rnd.lastDailyJackpot = now;
1255         rnd.softDeadline = now + SOFT_DEADLINE_DURATION;
1256         rnd.jackpot = jackpotSeed;
1257         jackpotSeed = 0; 
1258         _startNewDailyRound();
1259         _purchase(rnd, msg.value, address(0x0));
1260         emit RoundStarted(_rID, startingSharePrice, _priceMultiplier, _priceIncreasePeriod);
1261     }
1262 
1263     /// Anyone can finalize a finished round
1264     function finalizeLastRound() public {
1265         MobiusRound storage rnd = rounds[latestRoundID];
1266         _finalizeRound(rnd);
1267     }
1268 
1269     function setRoundParams(uint startingPrice, uint priceMultiplier, uint priceIncreasePeriod) public auth {
1270         startingSharePrice = startingPrice;
1271         _priceMultiplier = priceMultiplier;
1272         _priceIncreasePeriod = priceIncreasePeriod;
1273     }
1274 
1275     function setSecondaryPrice(uint newPrice) public auth {
1276         _secondaryPrice = newPrice;
1277     }
1278 
1279     function setMaxDailyJackpot(uint newLimit) public auth {
1280         maxDailyJackpot = newLimit;
1281     }
1282 
1283     // This is if we want to delay the start of the next round
1284     function setNextRoundTimestamp(uint timestamp) public auth {
1285         require(now > nextRoundTime);
1286         require(timestamp <= now + 2 days);// Can't set longer than 2 days delay
1287         nextRoundTime = timestamp;
1288     }
1289 
1290     function setNextRoundDelay(uint delayInSeconds) public auth {
1291         require(now > nextRoundTime);
1292         require(now + delayInSeconds <= now + 2 days);// Can't set longer than 2 days delay
1293         nextRoundTime = now + delayInSeconds;
1294     }
1295     
1296     /// This is how devs pay the bills
1297     function withdrawDevShare() public auth {
1298         uint value = sub(devBalance, totalPaidOraclize); // Pay for oraclize from dev share
1299         devBalance = 0;
1300         totalPaidOraclize = 0;
1301         msg.sender.transfer(value);
1302     }
1303 
1304     function setIPFSHash(string _type, string _hash) public auth {
1305         ipfsHashType = _type;
1306         ipfsHash = _hash;
1307         emit IPFSHashSet(_type, _hash);
1308     }
1309 
1310     function upgrade(address _nextVersion) public auth {
1311         require(_nextVersion != address(0x0), "Invalid Address!");
1312         require(!upgraded, "Already upgraded!");
1313         upgraded = true;
1314         nextVersion = _nextVersion;
1315     }
1316 
1317     //this is a fix for the previous bug that didn't let us transfer directly to the next version
1318     function getSeed() public {
1319         require(upgraded, "Not upgraded!");
1320         require(msg.sender == nextVersion, "You can't do that!");
1321         MobiusRound storage rnd = rounds[latestRoundID];
1322         require(rnd.finalized, "Still running!");
1323         
1324         require(nextVersion.call.value(jackpotSeed)(), "Transfer failed!");
1325     }
1326 
1327     // Function to initialise an updated version of the contract
1328     // Grab totals info and transfer the jackpot seed
1329     function init() public auth {
1330         
1331         require(!initialized, "Already initialized!");
1332         uint _rID = lastVersion.latestRoundID();
1333         previousRounds = 1 + _rID;
1334         uint _shares;
1335         uint _invested;// last version doesn't have a total invested counter, so this is assuming only a single round has run
1336         uint _returns;
1337         uint _dividends;
1338         uint _jackpots;
1339         bool finalized;
1340         ( , , , , , _invested, , , , finalized) = lastVersion.roundInfo(_rID);
1341         require(finalized, "Last round is still not finalized!");
1342         (_returns, _shares, _dividends, _jackpots) = lastVersion.totalsInfo();
1343 
1344         totalSharesSold = _shares;
1345         totalRevenue = _invested;
1346         totalEarningsGenerated = _returns;
1347         totalDividendsPaid = _dividends;
1348         totalJackpotsWon = _jackpots;
1349         // To be used in the next version - this one will be manually seeded
1350         // lastVersion.getSeed();
1351         
1352         initialized = true;
1353     }
1354 
1355     function _startNewDailyRound() internal {
1356         if(dailyRounds.length > 0) {
1357             require(dailyRounds[latestDailyID].finalized, "Previous round not finalized");
1358         }
1359         uint _rID = dailyRounds.length++;
1360         latestDailyID = _rID;
1361     }
1362 
1363     /// Purchase logic
1364     function _purchase(MobiusRound storage rnd, uint value, address ref) internal {
1365         require(rnd.softDeadline >= now, "After deadline!");
1366         require(value >= 100 szabo, "Not enough Ether!");
1367         rnd.totalInvested = add(rnd.totalInvested, value);
1368 
1369         // Set the last investor (to win the jackpot after the deadline)
1370         if(value >= rnd.price) {
1371             rnd.lastInvestor = msg.sender;
1372         }
1373         // Process daily jackpot 
1374         _dailyJackpot(rnd, value);
1375         // Process revenue in different "buckets"
1376         _splitRevenue(rnd, value, ref);
1377         // Update returns before issuing shares
1378         _updateReturns(msg.sender, rnd);
1379         //issue shares for the current round. 1 share = 1 time increase for the deadline
1380         uint newShares = _issueShares(rnd, msg.sender, value);
1381 
1382         uint timeIncreases = newShares/WAD;// since 1 share is represented by 1 * 10^18, divide by 10^18
1383         // adjust soft deadline to new soft deadline
1384         uint newDeadline = add(rnd.softDeadline, mul(timeIncreases, TIME_PER_SHARE));
1385         rnd.softDeadline = min(newDeadline, now + SOFT_DEADLINE_DURATION);
1386         
1387         // If it's time to increase the price - do it
1388         if(now > rnd.lastPriceIncreaseTime + rnd.priceIncreasePeriod) {
1389             rnd.price = wmul(rnd.price, rnd.priceMultiplier);
1390             rnd.lastPriceIncreaseTime = now;
1391         }
1392         
1393     }
1394 
1395     function _finalizeRound(MobiusRound storage rnd) internal {
1396         require(!rnd.finalized, "Already finalized!");
1397         require(rnd.softDeadline < now, "Round still running!");
1398 
1399         // Transfer jackpot to winner's vault
1400         vaults[rnd.lastInvestor].totalReturns = add(vaults[rnd.lastInvestor].totalReturns, rnd.jackpot);
1401         unclaimedReturns = add(unclaimedReturns, rnd.jackpot);
1402         
1403         emit JackpotWon(rnd.lastInvestor, rnd.jackpot);
1404         totalJackpotsWon += rnd.jackpot;
1405         // transfer the leftover to the next round's jackpot
1406         jackpotSeed = add(jackpotSeed, wmul(rnd.totalInvested, JACKPOT_SEED_FRACTION));
1407         //Empty the AD pot if it has a balance.
1408         jackpotSeed = add(jackpotSeed, rnd.dailyJackpot);
1409                
1410         //Send out dividends to token holders
1411         uint _div = wmul(rnd.totalInvested, DIVIDENDS_FRACTION);            
1412         
1413         token.disburseDividends.value(_div)();
1414         totalDividendsPaid += _div;
1415         totalSharesSold += rnd.totalShares;
1416         totalEarningsGenerated += wmul(rnd.totalInvested, RETURNS_FRACTION);
1417         totalRevenue += rnd.totalInvested;
1418         dailyRounds[latestDailyID].finalized = true;
1419         rnd.finalized = true;
1420     }
1421 
1422     /** 
1423         This is where the magic happens: every investor gets an exact share of all returns proportional to their shares
1424         If you're early, you'll have a larger share for longer, so obviously you earn more.
1425     */
1426     function _updateReturns(address _investor, MobiusRound storage rnd) internal {
1427         if(rnd.investors[_investor].shares == 0) {
1428             return;
1429         }
1430         
1431         uint outstanding = _outstandingReturns(_investor, rnd);
1432 
1433         // if there are any returns, transfer them to the investor's vaults
1434         if (outstanding > 0) {
1435             vaults[_investor].totalReturns = add(vaults[_investor].totalReturns, outstanding);
1436         }
1437 
1438         rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
1439     }
1440 
1441     function _outstandingReturns(address _investor, MobiusRound storage rnd) internal view returns(uint) {
1442         if(rnd.investors[_investor].shares == 0) {
1443             return 0;
1444         }
1445         // check if there've been new returns
1446         uint newReturns = sub(
1447             rnd.cumulativeReturnsPoints, 
1448             rnd.investors[_investor].lastCumulativeReturnsPoints
1449             );
1450 
1451         uint outstanding = 0;
1452         if(newReturns != 0) { 
1453             // outstanding returns = (total new returns points * ivestor shares) / MULTIPLIER
1454             // The MULTIPLIER is used also at the point of returns disbursment
1455             outstanding = mul(newReturns, rnd.investors[_investor].shares) / MULTIPLIER;
1456         }
1457 
1458         return outstanding;
1459     }
1460 
1461     /// Process revenue according to fractions
1462     function _splitRevenue(MobiusRound storage rnd, uint value, address ref) internal {
1463         uint roundReturns;
1464         
1465         if(ref != address(0x0) && ref != msg.sender) {
1466             // if there was a referral
1467             roundReturns = wmul(value, RETURNS_FRACTION - REFERRAL_FRACTION);
1468             uint _ref = wmul(value, REFERRAL_FRACTION);
1469             vaults[ref].totalReturns = add(vaults[ref].totalReturns, _ref);            
1470             vaults[ref].refReturns = add(vaults[ref].refReturns, _ref);
1471             unclaimedReturns = add(unclaimedReturns, _ref);
1472         } else {
1473             roundReturns = wmul(value, RETURNS_FRACTION);
1474         }
1475         
1476         uint dailyJackpot = wmul(value, DAILY_JACKPOT_FRACTION);
1477         uint jackpot = wmul(value, JACKPOT_FRACTION);
1478         
1479         uint dev;
1480         
1481         dev = value / DEV_DIVISOR;
1482         
1483         // if this is the first purchase, send to jackpot (no one can claim these returns otherwise)
1484         if(rnd.totalShares == 0) {
1485             rnd.jackpot = add(rnd.jackpot, roundReturns);
1486         } else {
1487             _disburseReturns(rnd, roundReturns);
1488         }
1489         
1490         rnd.dailyJackpot = add(rnd.dailyJackpot, dailyJackpot);
1491         rnd.jackpot = add(rnd.jackpot, jackpot);
1492         devBalance = add(devBalance, dev);
1493     }
1494 
1495     function _disburseReturns(MobiusRound storage rnd, uint value) internal {
1496         unclaimedReturns = add(unclaimedReturns, value);// keep track of unclaimed returns
1497         // The returns points represent returns*MULTIPLIER/totalShares (at the point of purchase)
1498         // This allows us to keep outstanding balances of shareholders when the total supply changes in real time
1499         if(rnd.totalShares == 0) {
1500             rnd.cumulativeReturnsPoints = mul(value, MULTIPLIER) / wdiv(value, rnd.price);
1501         } else {
1502             rnd.cumulativeReturnsPoints = add(
1503                 rnd.cumulativeReturnsPoints, 
1504                 mul(value, MULTIPLIER) / rnd.totalShares
1505             );
1506         }
1507     }
1508 
1509     function _issueShares(MobiusRound storage rnd, address _investor, uint value) internal returns(uint) {    
1510         if(rnd.investors[_investor].lastCumulativeReturnsPoints == 0) {
1511             rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
1512         }    
1513         
1514         uint newShares = wdiv(value, rnd.price);
1515         
1516         //bonuses:
1517         if(value >= 100 ether) {
1518             newShares = mul(newShares, 2);//get double shares if you paid more than 100 ether
1519         } else if(value >= 10 ether) {
1520             newShares = add(newShares, newShares/2);//50% bonus
1521         } else if(value >= 1 ether) {
1522             newShares = add(newShares, newShares/3);//33% bonus
1523         } else if(value >= 100 finney) {
1524             newShares = add(newShares, newShares/10);//10% bonus
1525         }
1526 
1527         rnd.investors[_investor].shares = add(rnd.investors[_investor].shares, newShares);
1528         rnd.totalShares = add(rnd.totalShares, newShares);
1529         emit SharesIssued(_investor, newShares);
1530         return newShares;
1531     }    
1532 
1533     function _dailyJackpot(MobiusRound storage rnd, uint value) internal {
1534         
1535         if(value >= rnd.secondaryPrice) {
1536             dailyRounds[latestDailyID].entrants.push(msg.sender);
1537             lastDailyEntry[msg.sender] = now; // in order to tell who's eligible for the next draw
1538         }
1539         // If it's time to draw
1540         if(now > rnd.lastDailyJackpot + DAILY_JACKPOT_PERIOD) {
1541             //if the jackpot is smaller than 2*secondaryPrice, then skip
1542             if(rnd.dailyJackpot < rnd.secondaryPrice * 4) {// multiply by 4 bexause only half is won
1543                 return;
1544             }
1545             if(!oraclizePending) {                
1546                 _requestRandom(0);
1547             } else {
1548                 if(now > oraclizeLastRequestTime + 10 minutes){
1549                     // Increase gas price if callback times out
1550                     // Increase to double last price, max 150 gwei.
1551                     oraclizeGasPrice = min(150000000000, oraclizeGasPrice * 2); 
1552                     oraclize_setCustomGasPrice(oraclizeGasPrice);
1553                 }
1554             }
1555         }
1556     }
1557 
1558     // What happens when we get the random number from Oraclize
1559     function _onRandom(uint _rand, bytes32 _queryId) internal {
1560         MobiusRound storage rnd = rounds[latestRoundID];
1561         // only if the latest round is still running and it's time to draw the daily jackpot
1562         if(rnd.softDeadline >= now && now > rnd.lastDailyJackpot + DAILY_JACKPOT_PERIOD) {
1563             _drawDailyJackpot(dailyRounds[latestDailyID], rnd, _rand);
1564         }
1565     }
1566 
1567     event FailedRNGVerification(bytes32 qID);
1568 
1569     function _onRandomFailed(bytes32 _queryId) internal {
1570         emit FailedRNGVerification(_queryId);
1571     }
1572 
1573     // We can manually send an Oraclize request - it doesn't affect the time of drawing the daily jackpot
1574     function _triggerOraclize() public auth {
1575         _requestRandom(0);
1576     }
1577 
1578     function _drawDailyJackpot(DailyJackpotRound storage dRnd, MobiusRound storage rnd, uint _rand) internal {
1579         if(dRnd.entrants.length != 0){
1580             uint winner = _rand % dRnd.entrants.length;
1581             uint prize = min(maxDailyJackpot, rnd.dailyJackpot / 2);// win half of the pot, with a max limit
1582             rnd.dailyJackpot = sub(rnd.dailyJackpot, prize);
1583             vaults[dRnd.entrants[winner]].totalReturns = add(vaults[dRnd.entrants[winner]].totalReturns, prize);
1584             emit DailyJackpotWon(dRnd.entrants[winner], prize);
1585             dRnd.finalized = true;       
1586             unclaimedReturns = add(unclaimedReturns, prize);
1587             totalJackpotsWon += prize;
1588 
1589             _startNewDailyRound();
1590         }        
1591         rnd.lastDailyJackpot = now; 
1592     }
1593 
1594 }