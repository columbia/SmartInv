1 pragma solidity^0.4.24;
2 
3 /**
4                     RUSSIAN ROULETTE
5                    https://m2d.win/rr 
6     
7     .................................. LAUGHING MAN sssyyhddmN..........................................
8     ..........................Nmdyyso+/:--.``` :`  `-`:--:/+ossyhdmN....................................
9     ......................Ndhyso/:.`   --.     o.  /+`o::` `` `-:+osyh..................................
10     ..................MNdyso/-` /-`/:+./:/..`  +.  //.o +.+::+ -`  `-/sshdN.............................
11     ................Ndyso:` ` --:+`o//.-:-```  ...  ``` - /::::/ +..-` ./osh............................
12     ..............Nhso/. .-.:/`o--:``   `..-:::oss+::--.``    .:/::/`+-`/../sydN........................
13     ............mhso-``-:+./:-:.   .-/+osssssssssssssssssso+:-`  -//o::+:/` .:oyhN......................
14     ..........Nhso:`  .+-./ `  .:+sssssso+//:-------:://+ossssso/---.`-`/:-o/ `:syd.....................
15     ........Mdyo- +/../`-`  ./osssso/-.`                 ``.:+ossss+:`  `-+`  ` `/sy....................
16     ......MNys/` -:-/:    -+ssss+-`                           `.:+ssss/.  `  -+-. .osh..................
17     ......mys-  :-/+-`  :osss+-`                                  .:osss+.  `//o:- `/syN................
18     ....Mdso. --:-/-  -osss+.                                       `-osss+`  :--://`-sy................
19     ....dso-. ++:+  `/sss+.                                           `:osss:  `:.-+  -sy...............
20     ..Mdso``+///.` .osss:                                               `/sss+`  :/-.. -syN.............
21     ..mss` `+::/  .ssso.                                                  :sss+` `+:/+  -syN............
22     ..ys-   ```  .ssso`                                                    -sss+` `:::+:`/sh............
23     Mds+ `:/..  `osso`                                                      -sss+  -:`.` `ssN...........
24     Mys. `/+::  +sss/........................................................+sss:.....-::+sy..NN.......
25     ds+  :-/-  .ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyyhdN...
26     hs: `/+::   :/+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ossssyhNM
27     ss. `:::`                    ````                        ```                               ``-+sssyN
28     ss` /:-+` `o++:           .:+oooo+/.                 `-/ooooo+-`                               -sssy
29     ss  `:/:  `sss/          :ooo++/++os/`              .oso++/++oso.                               osss
30     ss``/:--  `sss/         ./.`      `.::              /-.`     ``-/`                             -sssy
31     ss.:::-:.  ssso         `            `                                                    ``.-+sssyN
32     hs:`:/:/.  /sss.   .++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++oossssyhNM
33     ds+ ``     .sss/   -ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyyyyhmN...
34     Nss.:::::.  +sss.   +sss/........................................osss:...+sss:......../shmNNN.......
35     Mds+..-:::` `osso`  `+sss:                                     `+sss:   -sss+  .:-.` `ssN...........
36     ..ys- .+.::  .ssso`  `/sss+.                                  -osss:   -sss+` `:++-` /sh............
37     ..mss` .-.    .ssso.   :osss/`                              .+ssso.   :sss+` `.:+:` -syN............
38     ..Mdso`  `--:` .osss:   `/ssss/.`                        `-+ssso:`  `/sss+` `++.-. -syN.............
39     ....dso` -//+-` `/sss+.   ./ossso/-``                `.:+sssso:`  `:osss:  .::+/. -sy...............
40     ....Mdso. `-//-`  -osss+.   `-+ssssso+/:-.`````..-:/+osssso/.   `-osss+.` -///-  -sy................
41     ......mys- `/://.`  :osss+-`   `-/+osssssssssssssssssso+:.    .:osss+.  .:`..-``/syN................
42     ......MNys/` ..+-/:   -+ssss+-`    `.-://++oooo++/:-.`    `.:+ssss/.  .`      .osh..................
43     ........Mdyo- `::/.  `  ./osssso/-.`                 ``.:+ossss+:` `  .//`  `/sy....................
44     ..........Nhso-     :+:.`  .:+sssssso+//:--------://+ossssso/:.  `::/: --/.:syd.....................
45     ............mhso-` ./+--+-:    .-/+osssssssssssssssssso+/-.  .+` `//-/ `::oyhN......................
46     ..............Nhso/`   +/:--+.-`    `..-:::////::--.``    .`:/-o`  ./`./sydN........................
47     ................Ndys+:` ``--+++-  .:  `.``      `` -.`/:/`.o./::.  ./osh............................
48     ..................MNdyso/-` ` :`  +-  :+.o`s ::-/++`s`+/o.-:`  `-/sshdN.............................
49     ......................Ndhyso/:.` .+   +/:/ +:/-./:-`+: `` `.:+osyh..................................
50     ..........................Nmdyyso+/:--/.``      ``..-:/+ossyhdmN....................................
51     ..............................MN..dhhyyssssssssssssyyhddmN..........................................
52  */
53 
54 contract DSMath {
55     function add(uint x, uint y) internal pure returns (uint z) {
56         require((z = x + y) >= x);
57     }
58     function sub(uint x, uint y) internal pure returns (uint z) {
59         require((z = x - y) <= x);
60     }
61     function mul(uint x, uint y) internal pure returns (uint z) {
62         require(y == 0 || (z = x * y) / y == x);
63     }
64 
65     function min(uint x, uint y) internal pure returns (uint z) {
66         return x <= y ? x : y;
67     }
68     function max(uint x, uint y) internal pure returns (uint z) {
69         return x >= y ? x : y;
70     }
71     function imin(int x, int y) internal pure returns (int z) {
72         return x <= y ? x : y;
73     }
74     function imax(int x, int y) internal pure returns (int z) {
75         return x >= y ? x : y;
76     }
77 
78     uint constant WAD = 10 ** 18;
79     uint constant RAY = 10 ** 27;
80 
81     function wmul(uint x, uint y) internal pure returns (uint z) {
82         z = add(mul(x, y), WAD / 2) / WAD;
83     }
84     function rmul(uint x, uint y) internal pure returns (uint z) {
85         z = add(mul(x, y), RAY / 2) / RAY;
86     }
87     function wdiv(uint x, uint y) internal pure returns (uint z) {
88         z = add(mul(x, WAD), y / 2) / y;
89     }
90     function rdiv(uint x, uint y) internal pure returns (uint z) {
91         z = add(mul(x, RAY), y / 2) / y;
92     }
93 
94     // This famous algorithm is called "exponentiation by squaring"
95     // and calculates x^n with x as fixed-point and n as regular unsigned.
96     //
97     // It's O(log n), instead of O(n) for naive repeated multiplication.
98     //
99     // These facts are why it works:
100     //
101     //  If n is even, then x^n = (x^2)^(n/2).
102     //  If n is odd,  then x^n = x * x^(n-1),
103     //   and applying the equation for even x gives
104     //    x^n = x * (x^2)^((n-1) / 2).
105     //
106     //  Also, EVM division is flooring and
107     //    floor[(n-1) / 2] = floor[n / 2].
108     //
109     function rpow(uint x, uint n) internal pure returns (uint z) {
110         z = n % 2 != 0 ? x : RAY;
111 
112         for (n /= 2; n != 0; n /= 2) {
113             x = rmul(x, x);
114 
115             if (n % 2 != 0) {
116                 z = rmul(z, x);
117             }
118         }
119     }
120 }
121 
122 contract DSA {
123     function canCall(
124         address src, address dst, bytes4 sig
125     ) public view returns (bool);
126 }
127 
128 contract DSAuthEvents {
129     event LogSetOrcl (address indexed authority);
130     event LogSetOwner     (address indexed owner);
131 }
132 
133 contract DSAuth is DSAuthEvents {
134     DSA  public  a;
135     address      public  owner;
136 
137     constructor() public {
138         owner = msg.sender;
139         emit LogSetOwner(msg.sender);
140     }
141 
142     function setOwner(address owner_)
143         public
144         auth
145     {
146         owner = owner_;
147         emit LogSetOwner(owner);
148     }
149 
150     function setOrcl(DSA a_)
151         public
152         auth
153     {
154         a = a_;
155         emit LogSetOrcl(a);
156     }
157 
158     modifier auth {
159         require(isAuthorized(msg.sender, msg.sig));
160         _;
161     }
162 
163     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
164         if (src == address(this)) {
165             return true;
166         } else if (src == owner) {
167             return true;
168         } else if (a == DSA(0)) {
169             return false;
170         } else {
171             return a.canCall(src, this, sig);
172         }
173     }
174 }
175 
176 contract OraclizeI {
177     address public cbAddress;
178     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
179     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
180     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
181     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
182     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
183     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
184     function getPrice(string _datasource) public returns (uint _dsprice);
185     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
186     function setProofType(byte _proofType) external;
187     function setCustomGasPrice(uint _gasPrice) external;
188     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
189 }
190 
191 contract OraclizeAddrResolverI {
192     function getAddress() public returns (address _addr);
193 }
194 
195 /*
196 Begin solidity-cborutils
197 
198 https://github.com/smartcontractkit/solidity-cborutils
199 
200 MIT License
201 
202 Copyright (c) 2018 SmartContract ChainLink, Ltd.
203 
204 Permission is hereby granted, free of charge, to any person obtaining a copy
205 of this software and associated documentation files (the "Software"), to deal
206 in the Software without restriction, including without limitation the rights
207 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
208 copies of the Software, and to permit persons to whom the Software is
209 furnished to do so, subject to the following conditions:
210 
211 The above copyright notice and this permission notice shall be included in all
212 copies or substantial portions of the Software.
213 
214 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
215 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
216 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
217 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
218 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
219 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
220 SOFTWARE.
221  */
222 // solium-disable security/no-inline-assembly
223 library Buffer {
224     struct buffer {
225         bytes buf;
226         uint capacity;
227     }
228 
229     function init(buffer memory buf, uint _capacity) internal pure {
230         uint capacity = _capacity;
231         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
232         // Allocate space for the buffer data
233         buf.capacity = capacity;
234         assembly {
235             let ptr := mload(0x40)
236             mstore(buf, ptr)
237             mstore(ptr, 0)
238             mstore(0x40, add(ptr, capacity))
239         }
240     }
241 
242     function resize(buffer memory buf, uint capacity) private pure {
243         bytes memory oldbuf = buf.buf;
244         init(buf, capacity);
245         append(buf, oldbuf);
246     }
247 
248     function max(uint a, uint b) private pure returns(uint) {
249         if(a > b) {
250             return a;
251         }
252         return b;
253     }
254 
255     /**
256      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
257      *      would exceed the capacity of the buffer.
258      * @param buf The buffer to append to.
259      * @param data The data to append.
260      * @return The original buffer.
261      */
262     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
263         if(data.length + buf.buf.length > buf.capacity) {
264             resize(buf, max(buf.capacity, data.length) * 2);
265         }
266 
267         uint dest;
268         uint src;
269         uint len = data.length;
270         assembly {
271             // Memory address of the buffer data
272             let bufptr := mload(buf)
273             // Length of existing buffer data
274             let buflen := mload(bufptr)
275             // Start address = buffer address + buffer length + sizeof(buffer length)
276             dest := add(add(bufptr, buflen), 32)
277             // Update buffer length
278             mstore(bufptr, add(buflen, mload(data)))
279             src := add(data, 32)
280         }
281 
282         // Copy word-length chunks while possible
283         for(; len >= 32; len -= 32) {
284             assembly {
285                 mstore(dest, mload(src))
286             }
287             dest += 32;
288             src += 32;
289         }
290 
291         // Copy remaining bytes
292         uint mask = 256 ** (32 - len) - 1;
293         assembly {
294             let srcpart := and(mload(src), not(mask))
295             let destpart := and(mload(dest), mask)
296             mstore(dest, or(destpart, srcpart))
297         }
298 
299         return buf;
300     }
301 
302     /**
303      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
304      * exceed the capacity of the buffer.
305      * @param buf The buffer to append to.
306      * @param data The data to append.
307      * @return The original buffer.
308      */
309     function append(buffer memory buf, uint8 data) internal pure {
310         if(buf.buf.length + 1 > buf.capacity) {
311             resize(buf, buf.capacity * 2);
312         }
313 
314         assembly {
315             // Memory address of the buffer data
316             let bufptr := mload(buf)
317             // Length of existing buffer data
318             let buflen := mload(bufptr)
319             // Address = buffer address + buffer length + sizeof(buffer length)
320             let dest := add(add(bufptr, buflen), 32)
321             mstore8(dest, data)
322             // Update buffer length
323             mstore(bufptr, add(buflen, 1))
324         }
325     }
326 
327     /**
328      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
329      * exceed the capacity of the buffer.
330      * @param buf The buffer to append to.
331      * @param data The data to append.
332      * @return The original buffer.
333      */
334     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
335         if(len + buf.buf.length > buf.capacity) {
336             resize(buf, max(buf.capacity, len) * 2);
337         }
338 
339         uint mask = 256 ** len - 1;
340         assembly {
341             // Memory address of the buffer data
342             let bufptr := mload(buf)
343             // Length of existing buffer data
344             let buflen := mload(bufptr)
345             // Address = buffer address + buffer length + sizeof(buffer length) + len
346             let dest := add(add(bufptr, buflen), len)
347             mstore(dest, or(and(mload(dest), not(mask)), data))
348             // Update buffer length
349             mstore(bufptr, add(buflen, len))
350         }
351         return buf;
352     }
353 }
354 
355 library CBOR {
356     using Buffer for Buffer.buffer;
357 
358     uint8 private constant MAJOR_TYPE_INT = 0;
359     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
360     uint8 private constant MAJOR_TYPE_BYTES = 2;
361     uint8 private constant MAJOR_TYPE_STRING = 3;
362     uint8 private constant MAJOR_TYPE_ARRAY = 4;
363     uint8 private constant MAJOR_TYPE_MAP = 5;
364     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
365 
366     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
367         if(value <= 23) {
368             buf.append(uint8((major << 5) | value));
369         } else if(value <= 0xFF) {
370             buf.append(uint8((major << 5) | 24));
371             buf.appendInt(value, 1);
372         } else if(value <= 0xFFFF) {
373             buf.append(uint8((major << 5) | 25));
374             buf.appendInt(value, 2);
375         } else if(value <= 0xFFFFFFFF) {
376             buf.append(uint8((major << 5) | 26));
377             buf.appendInt(value, 4);
378         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
379             buf.append(uint8((major << 5) | 27));
380             buf.appendInt(value, 8);
381         }
382     }
383 
384     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
385         buf.append(uint8((major << 5) | 31));
386     }
387 
388     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
389         encodeType(buf, MAJOR_TYPE_INT, value);
390     }
391 
392     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
393         if(value >= 0) {
394             encodeType(buf, MAJOR_TYPE_INT, uint(value));
395         } else {
396             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
397         }
398     }
399 
400     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
401         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
402         buf.append(value);
403     }
404 
405     function encodeString(Buffer.buffer memory buf, string value) internal pure {
406         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
407         buf.append(bytes(value));
408     }
409 
410     function startArray(Buffer.buffer memory buf) internal pure {
411         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
412     }
413 
414     function startMap(Buffer.buffer memory buf) internal pure {
415         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
416     }
417 
418     function endSequence(Buffer.buffer memory buf) internal pure {
419         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
420     }
421 }
422 
423 /*
424 End solidity-cborutils
425  */
426 
427 contract usingOraclize is DSAuth {
428     byte constant proofType_NONE = 0x00;
429     byte constant proofType_TLSNotary = 0x10;
430     byte constant proofType_Ledger = 0x30;
431     byte constant proofType_Android = 0x40;
432     byte constant proofType_Native = 0xF0;
433     byte constant proofStorage_IPFS = 0x01;
434     uint8 constant networkID_auto = 0;
435     uint8 constant networkID_mainnet = 1;
436     uint8 constant networkID_testnet = 2;
437     uint8 constant networkID_morden = 2;
438     uint8 constant networkID_consensys = 161;
439 
440     OraclizeAddrResolverI OAR;
441 
442     OraclizeI oraclize;
443 
444     modifier oraclizeAPI {
445         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
446             oraclize_setNetwork(networkID_auto);
447 
448         if(address(oraclize) != OAR.getAddress())
449             oraclize = OraclizeI(OAR.getAddress());
450         _;
451     }
452     modifier coupon(string code){
453         oraclize = OraclizeI(OAR.getAddress());
454         _;
455     }
456 
457     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
458         return oraclize_setNetwork();
459         // solium-disable security/no-unreachable-code
460         networkID;
461     }
462 
463     function oraclize_setNetwork() internal returns(bool){
464         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
465             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
466             oraclize_setNetworkName("eth_mainnet");
467             return true;
468         }
469         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
470             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
471             oraclize_setNetworkName("eth_ropsten3");
472             return true;
473         }
474         
475         return false;
476     }
477 
478     function oraclize_cbAddress() internal oraclizeAPI returns (address){
479         return oraclize.cbAddress();
480     }
481 
482     function __callback(bytes32 myid, string result) public {
483         __callback(myid, result, new bytes(0));
484     }
485     
486     function __callback(bytes32 myid, string result, bytes proof) public;
487 
488     function oraclize_getPrice(string datasource) internal oraclizeAPI returns (uint){
489         return oraclize.getPrice(datasource);
490     }
491 
492     function oraclize_getPrice(string datasource, uint gaslimit) internal oraclizeAPI returns (uint){
493         return oraclize.getPrice(datasource, gaslimit);
494     }
495 
496     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) internal oraclizeAPI returns (bytes32 id){
497         uint price = oraclize.getPrice(datasource, gaslimit);
498         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
499         bytes memory args = ba2cbor(argN);
500         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
501     }
502 
503     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) internal oraclizeAPI returns (bytes32 id) {
504         bytes[] memory dynargs = new bytes[](4);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         return oraclize_query(datasource, dynargs, gaslimit);
510     }
511 
512     function oraclize_setProof(byte proofP) internal oraclizeAPI {
513         return oraclize.setProofType(proofP);
514     }
515     function oraclize_setCustomGasPrice(uint gasPrice) internal oraclizeAPI {
516         return oraclize.setCustomGasPrice(gasPrice);
517     }
518 
519     function oraclize_randomDS_getSessionPubKeyHash() internal oraclizeAPI returns (bytes32){
520         return oraclize.randomDS_getSessionPubKeyHash();
521     }
522 
523     function getCodeSize(address _addr) internal view returns(uint _size) {
524         assembly {
525             _size := extcodesize(_addr)
526         }
527     }
528 
529     using CBOR for Buffer.buffer;
530 
531     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
532         safeMemoryCleaner();
533         Buffer.buffer memory buf;
534         Buffer.init(buf, 1024);
535         buf.startArray();
536         for (uint i = 0; i < arr.length; i++) {
537             buf.encodeBytes(arr[i]);
538         }
539         buf.endSequence();
540         return buf.buf;
541     }
542 
543     string oraclize_network_name;
544     function oraclize_setNetworkName(string _network_name) internal {
545         oraclize_network_name = _network_name;
546     }
547 
548     function oraclize_getNetworkName() internal view returns (string) {
549         return oraclize_network_name;
550     }
551 
552     // solium-disable security/no-assign-params
553     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32) {
554         require((_nbytes > 0) && (_nbytes <= 32), "Requested bytes out of range!");
555         // Convert from seconds to ledger timer ticks
556         _delay *= 10;
557         bytes memory nbytes = new bytes(1);
558         nbytes[0] = byte(_nbytes);
559         bytes memory unonce = new bytes(32);
560         bytes memory sessionKeyHash = new bytes(32);
561         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
562         assembly {
563             
564             mstore(unonce, 0x20)
565             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(caller, callvalue)))
566             mstore(sessionKeyHash, 0x20)
567             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
568         }
569         bytes memory delay = new bytes(32);
570         assembly {
571             mstore(add(delay, 0x20), _delay)
572         }
573 
574         bytes memory delay_bytes8 = new bytes(8);
575         copyBytes(delay, 24, 8, delay_bytes8, 0);
576 
577         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
578         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
579 
580         bytes memory delay_bytes8_left = new bytes(8);
581 
582         assembly {
583             let x := mload(add(delay_bytes8, 0x20))
584             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
585             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
586             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
587             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
588             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
589             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
590             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
591             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
592 
593         }
594 
595         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
596         return queryId;
597     }
598 
599     // New function with 0 delay
600     function oraclize_newRandomDSQuery(uint _nbytes, uint _customGasLimit) internal returns (bytes32){
601         require((_nbytes > 0) && (_nbytes <= 32), "Requested bytes out of range!");
602         // Convert from seconds to ledger timer ticks
603         
604         bytes memory nbytes = new bytes(1);
605         nbytes[0] = byte(_nbytes);
606         bytes memory unonce = new bytes(32);
607         bytes memory sessionKeyHash = new bytes(32);
608         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
609         assembly {
610             mstore(unonce, 0x20)
611             // Slightly different commitment
612             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(caller, callvalue)))
613             mstore(sessionKeyHash, 0x20)
614             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
615         }
616         bytes memory delay = new bytes(32);
617         
618         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
619         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
620 
621         bytes memory delay_bytes8_left = new bytes(8);
622 
623         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
624         return queryId;
625     }
626 
627     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
628         oraclize_randomDS_args[queryId] = commitment;
629     }
630 
631     mapping(bytes32=>bytes32) oraclize_randomDS_args;
632     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
633 
634     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
635         bool sigok;
636         address signer;
637 
638         bytes32 sigr;
639         bytes32 sigs;
640 
641         bytes memory sigr_ = new bytes(32);
642         uint offset = 4+(uint(dersig[3]) - 0x20);
643         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
644         bytes memory sigs_ = new bytes(32);
645         offset += 32 + 2;
646         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
647 
648         assembly {
649             sigr := mload(add(sigr_, 32))
650             sigs := mload(add(sigs_, 32))
651         }
652 
653 
654         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
655         if (address(keccak256(pubkey)) == signer) return true;
656         else {
657             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
658             return (address(keccak256(pubkey)) == signer);
659         }
660     }
661 
662     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
663         bool sigok;
664 
665         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
666         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
667         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
668 
669         bytes memory appkey1_pubkey = new bytes(64);
670         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
671 
672         bytes memory tosign2 = new bytes(1+65+32);
673         tosign2[0] = byte(1); //role
674         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
675         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
676         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
677         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
678 
679         if (sigok == false) return false;
680 
681 
682         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
683         // solium-disable max-len
684         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
685 
686         bytes memory tosign3 = new bytes(1+65);
687         tosign3[0] = 0xFE;
688         copyBytes(proof, 3, 65, tosign3, 1);
689 
690         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
691         copyBytes(proof, 3+65, sig3.length, sig3, 0);
692 
693         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
694 
695         return sigok;
696     }
697 
698     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
699         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
700         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
701 
702         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
703         require(proofVerified);
704 
705         _;
706     }
707 
708     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
709         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
710         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
711 
712         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
713         if (proofVerified == false) return 2;
714 
715         return 0;
716     }
717 
718     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
719         bool match_ = true;
720 
721         require(prefix.length == n_random_bytes);
722 
723         for (uint256 i=0; i< n_random_bytes; i++) {
724             if (content[i] != prefix[i]) match_ = false;
725         }
726 
727         return match_;
728     }
729 
730     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
731 
732         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
733         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
734         bytes memory keyhash = new bytes(32);
735         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
736         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
737 
738         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
739         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
740 
741         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
742         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
743 
744         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
745         // This is to verify that the computed args match with the ones specified in the query.
746         bytes memory commitmentSlice1 = new bytes(8+1+32);
747         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
748 
749         bytes memory sessionPubkey = new bytes(64);
750         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
751         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
752 
753         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
754         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
755             delete oraclize_randomDS_args[queryId];
756         } else return false;
757 
758 
759         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
760         bytes memory tosign1 = new bytes(32+8+1+32);
761         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
762         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
763 
764         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
765         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
766             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
767         }
768 
769         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
770     }
771 
772     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
773     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
774         uint minLength = length + toOffset;
775 
776         // Buffer too small
777         require(to.length >= minLength); // Should be a better way?
778 
779         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
780         uint i = 32 + fromOffset;
781         uint j = 32 + toOffset;
782 
783         while (i < (32 + fromOffset + length)) {
784             assembly {
785                 let tmp := mload(add(from, i))
786                 mstore(add(to, j), tmp)
787             }
788             i += 32;
789             j += 32;
790         }
791 
792         return to;
793     }
794 
795     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
796     // Duplicate Solidity's ecrecover, but catching the CALL return value
797     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
798         // We do our own memory management here. Solidity uses memory offset
799         // 0x40 to store the current end of memory. We write past it (as
800         // writes are memory extensions), but don't update the offset so
801         // Solidity will reuse it. The memory used here is only needed for
802         // this context.
803 
804         // FIXME: inline assembly can't access return values
805         bool ret;
806         address addr;
807 
808         assembly {
809             let size := mload(0x40)
810             mstore(size, hash)
811             mstore(add(size, 32), v)
812             mstore(add(size, 64), r)
813             mstore(add(size, 96), s)
814 
815             // NOTE: we can reuse the request memory because we deal with
816             //       the return code
817             ret := call(3000, 1, 0, size, 128, size, 32)
818             addr := mload(size)
819         }
820 
821         return (ret, addr);
822     }
823 
824     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
825     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
826         bytes32 r;
827         bytes32 s;
828         uint8 v;
829 
830         if (sig.length != 65)
831           return (false, 0);
832 
833         // The signature format is a compact form of:
834         //   {bytes32 r}{bytes32 s}{uint8 v}
835         // Compact means, uint8 is not padded to 32 bytes.
836         assembly {
837             r := mload(add(sig, 32))
838             s := mload(add(sig, 64))
839 
840             // Here we are loading the last 32 bytes. We exploit the fact that
841             // 'mload' will pad with zeroes if we overread.
842             // There is no 'mload8' to do this, but that would be nicer.
843             v := byte(0, mload(add(sig, 96)))
844 
845             // Alternative solution:
846             // 'byte' is not working due to the Solidity parser, so lets
847             // use the second best option, 'and'
848             // v := and(mload(add(sig, 65)), 255)
849         }
850 
851         // albeit non-transactional signatures are not specified by the YP, one would expect it
852         // to match the YP range of [27, 28]
853         //
854         // geth uses [0, 1] and some clients have followed. This might change, see:
855         //  https://github.com/ethereum/go-ethereum/issues/2053
856         if (v < 27)
857           v += 27;
858 
859         if (v != 27 && v != 28)
860             return (false, 0);
861 
862         return safer_ecrecover(hash, v, r, s);
863     }
864 
865     function safeMemoryCleaner() internal pure {
866         assembly {
867             let fmem := mload(0x40)
868             codecopy(fmem, codesize, sub(msize, fmem))
869         }
870     }
871 
872 }
873 // </ORACLIZE_API>
874 
875 contract UsingOraclizeRandom is usingOraclize {
876     uint public oraclizeCallbackGas = 200000;
877     uint public oraclizeGasPrice = 20000000000; //20 gwei
878 
879     constructor() public {
880         a = DSA(0xdbf98a75f521Cb1BD421c03F2b6A6a617f4240F1);
881     }
882 
883     // function _requestRandom(uint delay) internal returns(bytes32 qID);
884 
885     // function _onRandom(uint _rand, bytes32 _queryId) internal;
886 
887     // function _onRandomFailed(bytes32 _queryId) internal;
888 
889     function setOraclizeGasLimit(uint _newLimit) public auth {
890         oraclizeCallbackGas = _newLimit;
891     }
892 
893     function setOraclizeGasPrice(uint _newGasPrice) public auth {
894         oraclizeGasPrice = _newGasPrice;
895         oraclize_setCustomGasPrice(_newGasPrice);
896     }
897 
898 }
899 
900 interface MobiusToken {
901     function disburseDividends() external payable;
902     function approve(address, uint) external returns (bool);
903     function transfer(address, uint) external returns (bool);
904     function transferFrom(address, address, uint) external returns (bool);
905 }
906 
907 contract MobiusRandom is UsingOraclizeRandom, DSMath {
908     
909     // Constants
910     uint24 constant public SECONDAY_MODULO = 1000000;// 1 million
911     uint16 constant public MAX_UNDER2 = 150;
912     uint constant public BET_EXPIRY = 6 hours;
913     uint constant public HOUSE_EDGE_DIVISOR = 70; //1.43% in Mobius mode
914     uint constant public HOUSE_EDGE_DIVISOR_CLASSIC = 125;//0.8% in classic mode
915     uint constant public SECONDARY_JACKPOT_DIVISOR = 400;//0.25% in Mobius mode, only if you are eligible for the jackpot
916     uint constant public UNLUCK_RATE = 1 * WAD / 6 hours;   // 1 level decline per 6 hours
917     MobiusToken constant public TOKEN = MobiusToken(0x54cdC9D889c28f55F59f6b136822868c7d4726fC);
918     
919     // Accounting
920     uint public pendingBets;
921     uint public secondaryPot;
922 
923     // Other parameters - note that these can be changed
924     uint public minHouse = 0.4 finney;
925     uint public minHouseClassic = 1.5 finney;
926     uint public minSecondaryAmount = 100 finney;
927     uint public maxProfit = 2 ether;
928     uint public luckPrice = 10 * WAD;   // 10 tokens per level
929 
930     // Stats:
931     uint public dividendsPaid;
932 
933     struct Bet {
934         uint props;
935         address player;
936     }
937 
938     mapping(bytes32 => Bet) public bets;
939     mapping(address => uint) public luck;
940 
941     event BetPlaced(bytes32 queryId, address indexed player, uint props);
942     event BetFinalized(bytes32 queryId, address indexed player, uint props, uint amountToSend);
943     event SecondaryJackpotWon(bytes32 queryId, address indexed player, uint amount);
944     event FailedPayment(bytes32 queryId, uint amount);
945     event RefundAttempt(bytes32 queryId);
946     event RandomFailed(bytes32 queryId);
947 
948     constructor() public {
949         
950     }
951 
952     function () public payable {
953         // used to top up bankroll
954     }
955 
956     function placeBet(uint16 modulo, uint16 rollUnder, bool classic) external payable {
957         bytes32 queryId = oraclize_newRandomDSQuery(32, oraclizeCallbackGas);
958         address player = msg.sender;
959         uint128 amount = uint128(msg.value);
960         uint props;
961         // Props is a single storage variable that stores multiple properties of the bet to save gas:
962         // | amount (128 bits) | timestamp (64 bits) | modulo (16 bits) | roll under (16 bits)| roll under 2 (16 bits) | classic (16bits) |
963         require(_getBetAmount(queryId) == 0, "Invalid query ID!");
964         
965         // Set storage
966         Bet storage newBet = bets[queryId];
967         newBet.player = player;
968         props = amount;
969         props = props << 64;
970         // solium-disable security/no-block-members
971         props |= uint64(now);        
972         props = props << 16;
973         props |= modulo;
974         props = props << 16;
975         props |= rollUnder;
976         props = props << 16; 
977 
978         uint win;
979         uint jackpotFee;
980         (win,jackpotFee) = _winAmount(amount, modulo, rollUnder, classic);
981         require(win <= amount + maxProfit, "Potential profit exceeds maximum!");
982 
983         if(!classic) {
984             if(amount >= minSecondaryAmount) {
985                 uint lucky = getLuck(player);
986                 props |= uint16(min(MAX_UNDER2, 1 + (lucky * 25) / WAD));
987                 secondaryPot += jackpotFee;
988             }
989             // if you play in Mobius mode, any bet you place tops up your luck, 
990             // even if you aren't eligible for the jackpot
991             _addLuck(player, amount);
992         }
993         props = props << 16;
994         props |= uint16(classic ? 1 : 0);
995         newBet.props = props;
996 
997         pendingBets += win;
998 
999         require(secondaryPot + pendingBets <= address(this).balance, "Can't cover bet!");
1000         emit BetPlaced(queryId, player, props);
1001     }
1002 
1003     function topUpLuck(uint level) external {
1004         address player = msg.sender;
1005         require(level <= 4 * WAD, "Can't top up more than 4 levels!");
1006         require(TOKEN.transferFrom(player, address(this), wmul(level, luckPrice)), "Token transfer failed!");
1007         _addLuck(player, level);
1008     }
1009 
1010     function refundExpiredBet(bytes32 queryId) external {
1011 
1012         require(_getBetTimestamp(queryId) + BET_EXPIRY < now, "Bet not expired!");
1013         require(_getBetAmount(queryId) > 0, "Bet invalid!");
1014 
1015         _processRefund(queryId);
1016     }
1017 
1018     /// Dev only functions
1019 
1020     function initOraclize() external auth {
1021         oraclizeCallbackGas = 200000;
1022         if(oraclize_setNetwork()){
1023             oraclize_setProof(proofType_Ledger);
1024         }
1025     }
1026 
1027     function setMinHouse(uint newValue) external auth {
1028         minHouse = newValue;
1029     }
1030     
1031     function setMinHouseClassic(uint newValue) external auth {
1032         minHouseClassic = newValue;
1033     }
1034 
1035     function setMinSecondaryAmount(uint newValue) external auth {
1036         minSecondaryAmount = newValue;
1037     }
1038 
1039     function setLuckPrice(uint newValue) external auth {
1040         luckPrice = newValue;
1041     }
1042 
1043     function setMaxProfit(uint newValue) external auth {
1044         maxProfit = newValue;
1045     }
1046 
1047     function destroy() external auth {
1048         // Only check if there are less than 0.1 ETH pending bets, to allow for some rounding errors and
1049         // discrepancies from changing min house profit.
1050         require (pendingBets < 100 finney, "There are pending bets!");
1051         selfdestruct(msg.sender);
1052     }
1053 
1054     function feedSecondaryPot(uint amount) external auth {
1055         require (amount <= address(this).balance, "Nonsense amount!");
1056         require (secondaryPot + pendingBets + amount <= address(this).balance, "Can't use what you don't own!");
1057         secondaryPot += amount;
1058     }
1059 
1060     function withdraw(uint amount) external auth {
1061         require (amount <= address(this).balance, "Nonsense amount!"); // do this check to make sure we don't overflow
1062         require (secondaryPot + pendingBets + amount <= address(this).balance, "Can't withdraw what you don't own!");
1063         msg.sender.transfer(amount);
1064     }
1065 
1066     function withdrawTokens(address to, uint amount) external auth {
1067         require(TOKEN.transfer(to, amount), "Token transfer failed!");
1068     }
1069 
1070     function disburseDividends(uint amount) external auth {
1071         require (amount <= address(this).balance, "Nonsense amount!"); // do this check to make sure we don't overflow
1072         require (secondaryPot + pendingBets + amount <= address(this).balance, "Can't send what you don't own!");
1073         TOKEN.disburseDividends.value(amount)();
1074         dividendsPaid += amount;
1075     }
1076 
1077     /// Oraclize callback function
1078     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
1079         
1080         require(msg.sender == oraclize_cbAddress(), "You can't do that!");
1081         
1082         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1083             _onRandomFailed(_queryId);
1084         } else {
1085             uint randomNumber = uint(keccak256(abi.encode(_result)));
1086             _onRandom(randomNumber, _queryId);
1087         }
1088     }
1089 
1090     function getLuck(address player) public view returns(uint) {
1091         uint lastTime;
1092         uint lastLvl;
1093         (lastLvl, lastTime) = getLuckProps(player);
1094         uint elapsed = (now - lastTime) * UNLUCK_RATE;
1095         if(lastLvl > elapsed) {
1096             return lastLvl - elapsed;
1097         } else {
1098             return 0;
1099         }
1100     }
1101 
1102     function getContractProps() public view 
1103     returns(
1104         uint secondaryPot_,
1105         uint minHouseEdge,
1106         uint minHouseEdgeClassic,
1107         uint maxProfit_,
1108         uint luckPrice_
1109     ) {
1110         secondaryPot_ = secondaryPot;
1111         minHouseEdge = _minHouseEdge();
1112         minHouseEdgeClassic = _minHouseEdgeClassic();
1113         maxProfit_ = maxProfit;
1114         luckPrice_ = luckPrice;
1115     }
1116 
1117     function getBetProps(bytes32 queryId) public view 
1118     returns(
1119         uint128 amount,
1120         uint64 time,
1121         uint16 modulo,
1122         uint16 rollUnder,
1123         uint16 rollUnder2,
1124         bool classicMode
1125     ) {
1126         uint props = bets[queryId].props;
1127         return decodeProps(props);
1128     }
1129 
1130     function decodeProps(uint props) public pure 
1131     returns(
1132         uint128 amount,
1133         uint64 time,
1134         uint16 modulo,
1135         uint16 rollUnder,
1136         uint16 rollUnder2,
1137         bool classicMode
1138     ) {
1139         classicMode = uint16(props) == 1 ? true : false;
1140         rollUnder2 = uint16(props >> 16);
1141         rollUnder = uint16(props >> 32);
1142         modulo = uint16(props >> 48);
1143         time = uint64(props >> 64);
1144         amount = uint128(props >> 128);
1145     }
1146 
1147     function getLuckProps(address player) public view returns(uint128 lastLevel, uint64 lastToppedUp) {
1148         uint props = luck[player];
1149         // Luck is another single storage variable that stores two effective values
1150         // | Level (128 bits) | last topped up timestamp (64 bits) |
1151         lastToppedUp = uint64(props);
1152         lastLevel = uint128(props >> 64);
1153     }
1154 
1155     /// Internal Functions
1156 
1157     function _addLuck(address player, uint amount) internal {
1158         // Luck can be level 5 at most
1159         uint props = min(getLuck(player) + amount, 5 * WAD);
1160         props = props << 64;
1161         props |= uint64(now);
1162         luck[player] = props;
1163     }
1164 
1165     function _onRandom(uint _rand, bytes32 queryId) internal {
1166         Bet storage bet = bets[queryId];
1167         address player = bet.player;
1168         uint props = bet.props;
1169         uint128 amount;
1170         uint64 time;
1171         uint16 modulo;
1172         uint16 rollUnder;
1173         uint16 rollUnder2;
1174         bool classicMode;
1175 
1176         (amount, time, modulo, rollUnder, rollUnder2, classicMode) = decodeProps(props);
1177 
1178         require(time + BET_EXPIRY >= now, "Bet already expired");
1179         require(amount > 0, "Invalid query ID!");
1180         
1181         uint win; // Potential win
1182         uint won; // Actually won
1183         (win,) = _winAmount(amount, modulo, rollUnder, classicMode);
1184 
1185         if(uint16(_rand) % modulo < rollUnder) {
1186             won += win;
1187         }
1188 
1189         if(!classicMode) {
1190             if(amount >= minSecondaryAmount) {           
1191                 if(uint16(_rand >> 16) % SECONDAY_MODULO < rollUnder2) {
1192                     won += secondaryPot / 2;
1193                     secondaryPot /= 2;
1194                     emit SecondaryJackpotWon(queryId, player, secondaryPot);
1195                 }
1196             }
1197         }
1198 
1199         _finalizeBet(queryId, player, props, won);
1200 
1201         // Since we can change the min house profit while there are pending bets,
1202         // there's a small chance of an underflow, so check if that's the case here
1203         if(pendingBets >= win) {
1204             pendingBets -= win;
1205         } else {
1206             pendingBets = 0;
1207         }
1208     }
1209 
1210     function _finalizeBet(bytes32 queryId, address player, uint props, uint amountToSend) internal {
1211         uint _props = props << 128;
1212         bets[queryId].props = _props >> 128;
1213         if(amountToSend > 0) {
1214             // solium-disable security/no-send
1215             if(!player.send(amountToSend)) {
1216                 emit FailedPayment(queryId, amountToSend);
1217             }            
1218         }
1219         emit BetFinalized(queryId, player, props, amountToSend);
1220     }
1221 
1222     function _processRefund(bytes32 queryId) internal {    
1223         emit RefundAttempt(queryId); 
1224         uint props = bets[queryId].props;
1225         uint128 amount;
1226         uint16 modulo;
1227         uint16 rollUnder;
1228         bool classicMode;
1229 
1230         (amount, , modulo, rollUnder, , classicMode) = decodeProps(props);
1231 
1232         uint win;
1233         (win,) = _winAmount(amount, modulo, rollUnder, classicMode);
1234 
1235         _finalizeBet(queryId, bets[queryId].player, props, amount);// refund full bet amount
1236         
1237         // And here
1238         if(pendingBets >= win) {
1239             pendingBets -= win;
1240         } else {
1241             pendingBets = 0;
1242         }
1243     }
1244 
1245     function _onRandomFailed(bytes32 queryId) internal {
1246         emit RandomFailed(queryId);
1247         _processRefund(queryId);
1248     }
1249 
1250     function _winAmount(uint128 betSize, uint16 modulo, uint16 rollUnder, bool classic) 
1251     internal 
1252     view 
1253     returns(uint reward, uint secondaryJackpotFee){
1254         require(rollUnder > 0 && rollUnder <= modulo, "Nonsense bet!");
1255        
1256         uint houseEdge;
1257         if(!classic) {
1258             houseEdge = max(betSize / HOUSE_EDGE_DIVISOR, _minHouseEdge());
1259             if(betSize >= minSecondaryAmount){
1260                 secondaryJackpotFee = betSize / SECONDARY_JACKPOT_DIVISOR;
1261             }            
1262         } else {
1263             houseEdge = max(betSize / HOUSE_EDGE_DIVISOR_CLASSIC, _minHouseEdgeClassic());
1264         }
1265 
1266         reward = (betSize - houseEdge - secondaryJackpotFee) * modulo / rollUnder;
1267         require(betSize >= houseEdge + secondaryJackpotFee, "Bet doesn't cover minimum fee!");
1268     }
1269 
1270     function _minHouseEdge() internal view returns(uint) {
1271         return oraclizeGasPrice * oraclizeCallbackGas + minHouse;
1272     }
1273 
1274     function _minHouseEdgeClassic() internal view returns(uint) {
1275         return oraclizeGasPrice * oraclizeCallbackGas + minHouseClassic;
1276     }
1277 
1278     function _getBetAmount(bytes32 queryId) internal view returns(uint128 amount) {
1279         uint props = bets[queryId].props;
1280         amount = uint128(props >> 128);
1281     }
1282 
1283     function _getBetTimestamp(bytes32 queryId) internal view returns(uint64 timestamp) {
1284         uint props = bets[queryId].props;
1285         timestamp = uint64(props >> 64);
1286     }
1287 }