1 pragma solidity ^0.4.20;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
11     function getPrice(string _datasource) returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
13     function useCoupon(string _coupon);
14     function setProofType(byte _proofType);
15     function setConfig(bytes32 _config);
16     function setCustomGasPrice(uint _gasPrice);
17     function randomDS_getSessionPubKeyHash() returns(bytes32);
18 }
19 
20 contract OraclizeAddrResolverI {
21     function getAddress() returns (address _addr);
22 }
23 
24 library Buffer {
25     struct buffer {
26         bytes buf;
27         uint capacity;
28     }
29 
30     function init(buffer memory buf, uint capacity) internal constant {
31         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
32         // Allocate space for the buffer data
33         buf.capacity = capacity;
34         assembly {
35             let ptr := mload(0x40)
36             mstore(buf, ptr)
37             mstore(0x40, add(ptr, capacity))
38         }
39     }
40 
41     function resize(buffer memory buf, uint capacity) private constant {
42         bytes memory oldbuf = buf.buf;
43         init(buf, capacity);
44         append(buf, oldbuf);
45     }
46 
47     function max(uint a, uint b) private constant returns(uint) {
48         if(a > b) {
49             return a;
50         }
51         return b;
52     }
53 
54     /**
55      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
56      *      would exceed the capacity of the buffer.
57      * @param buf The buffer to append to.
58      * @param data The data to append.
59      * @return The original buffer.
60      */
61     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
62         if(data.length + buf.buf.length > buf.capacity) {
63             resize(buf, max(buf.capacity, data.length) * 2);
64         }
65 
66         uint dest;
67         uint src;
68         uint len = data.length;
69         assembly {
70             // Memory address of the buffer data
71             let bufptr := mload(buf)
72             // Length of existing buffer data
73             let buflen := mload(bufptr)
74             // Start address = buffer address + buffer length + sizeof(buffer length)
75             dest := add(add(bufptr, buflen), 32)
76             // Update buffer length
77             mstore(bufptr, add(buflen, mload(data)))
78             src := add(data, 32)
79         }
80 
81         // Copy word-length chunks while possible
82         for(; len >= 32; len -= 32) {
83             assembly {
84                 mstore(dest, mload(src))
85             }
86             dest += 32;
87             src += 32;
88         }
89 
90         // Copy remaining bytes
91         uint mask = 256 ** (32 - len) - 1;
92         assembly {
93             let srcpart := and(mload(src), not(mask))
94             let destpart := and(mload(dest), mask)
95             mstore(dest, or(destpart, srcpart))
96         }
97 
98         return buf;
99     }
100 
101     /**
102      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
103      * exceed the capacity of the buffer.
104      * @param buf The buffer to append to.
105      * @param data The data to append.
106      * @return The original buffer.
107      */
108     function append(buffer memory buf, uint8 data) internal constant {
109         if(buf.buf.length + 1 > buf.capacity) {
110             resize(buf, buf.capacity * 2);
111         }
112 
113         assembly {
114             // Memory address of the buffer data
115             let bufptr := mload(buf)
116             // Length of existing buffer data
117             let buflen := mload(bufptr)
118             // Address = buffer address + buffer length + sizeof(buffer length)
119             let dest := add(add(bufptr, buflen), 32)
120             mstore8(dest, data)
121             // Update buffer length
122             mstore(bufptr, add(buflen, 1))
123         }
124     }
125 
126     /**
127      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
128      * exceed the capacity of the buffer.
129      * @param buf The buffer to append to.
130      * @param data The data to append.
131      * @return The original buffer.
132      */
133     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
134         if(len + buf.buf.length > buf.capacity) {
135             resize(buf, max(buf.capacity, len) * 2);
136         }
137 
138         uint mask = 256 ** len - 1;
139         assembly {
140             // Memory address of the buffer data
141             let bufptr := mload(buf)
142             // Length of existing buffer data
143             let buflen := mload(bufptr)
144             // Address = buffer address + buffer length + sizeof(buffer length) + len
145             let dest := add(add(bufptr, buflen), len)
146             mstore(dest, or(and(mload(dest), not(mask)), data))
147             // Update buffer length
148             mstore(bufptr, add(buflen, len))
149         }
150         return buf;
151     }
152 }
153 
154 library CBOR {
155     using Buffer for Buffer.buffer;
156 
157     uint8 private constant MAJOR_TYPE_INT = 0;
158     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
159     uint8 private constant MAJOR_TYPE_BYTES = 2;
160     uint8 private constant MAJOR_TYPE_STRING = 3;
161     uint8 private constant MAJOR_TYPE_ARRAY = 4;
162     uint8 private constant MAJOR_TYPE_MAP = 5;
163     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
164 
165     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
166         return x * (2 ** y);
167     }
168 
169     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
170         if(value <= 23) {
171             buf.append(uint8(shl8(major, 5) | value));
172         } else if(value <= 0xFF) {
173             buf.append(uint8(shl8(major, 5) | 24));
174             buf.appendInt(value, 1);
175         } else if(value <= 0xFFFF) {
176             buf.append(uint8(shl8(major, 5) | 25));
177             buf.appendInt(value, 2);
178         } else if(value <= 0xFFFFFFFF) {
179             buf.append(uint8(shl8(major, 5) | 26));
180             buf.appendInt(value, 4);
181         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
182             buf.append(uint8(shl8(major, 5) | 27));
183             buf.appendInt(value, 8);
184         }
185     }
186 
187     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
188         buf.append(uint8(shl8(major, 5) | 31));
189     }
190 
191     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
192         encodeType(buf, MAJOR_TYPE_INT, value);
193     }
194 
195     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
196         if(value >= 0) {
197             encodeType(buf, MAJOR_TYPE_INT, uint(value));
198         } else {
199             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
200         }
201     }
202 
203     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
204         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
205         buf.append(value);
206     }
207 
208     function encodeString(Buffer.buffer memory buf, string value) internal constant {
209         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
210         buf.append(bytes(value));
211     }
212 
213     function startArray(Buffer.buffer memory buf) internal constant {
214         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
215     }
216 
217     function startMap(Buffer.buffer memory buf) internal constant {
218         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
219     }
220 
221     function endSequence(Buffer.buffer memory buf) internal constant {
222         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
223     }
224 }
225 
226 /*
227 End solidity-cborutils
228  */
229 
230 contract usingOraclize {
231     uint constant day = 60*60*24;
232     uint constant week = 60*60*24*7;
233     uint constant month = 60*60*24*30;
234     byte constant proofType_NONE = 0x00;
235     byte constant proofType_TLSNotary = 0x10;
236     byte constant proofType_Android = 0x20;
237     byte constant proofType_Ledger = 0x30;
238     byte constant proofType_Native = 0xF0;
239     byte constant proofStorage_IPFS = 0x01;
240     uint8 constant networkID_auto = 0;
241     uint8 constant networkID_mainnet = 1;
242     uint8 constant networkID_testnet = 2;
243     uint8 constant networkID_morden = 2;
244     uint8 constant networkID_consensys = 161;
245 
246     OraclizeAddrResolverI OAR;
247 
248     OraclizeI oraclize;
249     modifier oraclizeAPI {
250         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
251             oraclize_setNetwork(networkID_auto);
252 
253         if(address(oraclize) != OAR.getAddress())
254             oraclize = OraclizeI(OAR.getAddress());
255 
256         _;
257     }
258     modifier coupon(string code){
259         oraclize = OraclizeI(OAR.getAddress());
260         oraclize.useCoupon(code);
261         _;
262     }
263 
264     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
265         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
266             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
267             oraclize_setNetworkName("eth_mainnet");
268             return true;
269         }
270         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
271             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
272             oraclize_setNetworkName("eth_ropsten3");
273             return true;
274         }
275         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
276             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
277             oraclize_setNetworkName("eth_kovan");
278             return true;
279         }
280         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
281             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
282             oraclize_setNetworkName("eth_rinkeby");
283             return true;
284         }
285         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
286             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
287             return true;
288         }
289         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
290             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
291             return true;
292         }
293         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
294             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
295             return true;
296         }
297         return false;
298     }
299 
300     function __callback(bytes32 myid, string result) {
301         __callback(myid, result, new bytes(0));
302     }
303     function __callback(bytes32 myid, string result, bytes proof) {
304     }
305 
306     function oraclize_useCoupon(string code) oraclizeAPI internal {
307         oraclize.useCoupon(code);
308     }
309 
310     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
311         return oraclize.getPrice(datasource);
312     }
313 
314     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
315         return oraclize.getPrice(datasource, gaslimit);
316     }
317 
318     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
319         uint price = oraclize.getPrice(datasource);
320         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
321         return oraclize.query.value(price)(0, datasource, arg);
322     }
323     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
324         uint price = oraclize.getPrice(datasource);
325         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
326         return oraclize.query.value(price)(timestamp, datasource, arg);
327     }
328     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
329         uint price = oraclize.getPrice(datasource, gaslimit);
330         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
331         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
332     }
333     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
334         uint price = oraclize.getPrice(datasource, gaslimit);
335         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
336         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
337     }
338     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
339         uint price = oraclize.getPrice(datasource);
340         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
341         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
342     }
343     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
344         uint price = oraclize.getPrice(datasource);
345         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
346         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
347     }
348     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource, gaslimit);
350         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
351         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
352     }
353     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource, gaslimit);
355         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
356         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
357     }
358     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
359         uint price = oraclize.getPrice(datasource);
360         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
361         bytes memory args = stra2cbor(argN);
362         return oraclize.queryN.value(price)(0, datasource, args);
363     }
364     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource);
366         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
367         bytes memory args = stra2cbor(argN);
368         return oraclize.queryN.value(price)(timestamp, datasource, args);
369     }
370     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource, gaslimit);
372         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
373         bytes memory args = stra2cbor(argN);
374         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
375     }
376     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         bytes memory args = stra2cbor(argN);
380         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
381     }
382     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
383         string[] memory dynargs = new string[](1);
384         dynargs[0] = args[0];
385         return oraclize_query(datasource, dynargs);
386     }
387     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
388         string[] memory dynargs = new string[](1);
389         dynargs[0] = args[0];
390         return oraclize_query(timestamp, datasource, dynargs);
391     }
392     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
393         string[] memory dynargs = new string[](1);
394         dynargs[0] = args[0];
395         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
396     }
397     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
398         string[] memory dynargs = new string[](1);
399         dynargs[0] = args[0];
400         return oraclize_query(datasource, dynargs, gaslimit);
401     }
402 
403     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
404         string[] memory dynargs = new string[](2);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         return oraclize_query(datasource, dynargs);
408     }
409     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
410         string[] memory dynargs = new string[](2);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         return oraclize_query(timestamp, datasource, dynargs);
414     }
415     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
416         string[] memory dynargs = new string[](2);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
420     }
421     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
422         string[] memory dynargs = new string[](2);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         return oraclize_query(datasource, dynargs, gaslimit);
426     }
427     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
428         string[] memory dynargs = new string[](3);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         return oraclize_query(datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](3);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         return oraclize_query(timestamp, datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](3);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         dynargs[2] = args[2];
446         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
447     }
448     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
449         string[] memory dynargs = new string[](3);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         dynargs[2] = args[2];
453         return oraclize_query(datasource, dynargs, gaslimit);
454     }
455 
456     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](4);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         return oraclize_query(datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](4);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         dynargs[2] = args[2];
469         dynargs[3] = args[3];
470         return oraclize_query(timestamp, datasource, dynargs);
471     }
472     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](4);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         dynargs[3] = args[3];
478         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
479     }
480     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](4);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         dynargs[3] = args[3];
486         return oraclize_query(datasource, dynargs, gaslimit);
487     }
488     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](5);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         dynargs[3] = args[3];
494         dynargs[4] = args[4];
495         return oraclize_query(datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](5);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         dynargs[4] = args[4];
504         return oraclize_query(timestamp, datasource, dynargs);
505     }
506     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](5);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         dynargs[4] = args[4];
513         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
514     }
515     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](5);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         dynargs[3] = args[3];
521         dynargs[4] = args[4];
522         return oraclize_query(datasource, dynargs, gaslimit);
523     }
524     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
525         uint price = oraclize.getPrice(datasource);
526         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
527         bytes memory args = ba2cbor(argN);
528         return oraclize.queryN.value(price)(0, datasource, args);
529     }
530     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
531         uint price = oraclize.getPrice(datasource);
532         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
533         bytes memory args = ba2cbor(argN);
534         return oraclize.queryN.value(price)(timestamp, datasource, args);
535     }
536     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
537         uint price = oraclize.getPrice(datasource, gaslimit);
538         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
539         bytes memory args = ba2cbor(argN);
540         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
541     }
542     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
543         uint price = oraclize.getPrice(datasource, gaslimit);
544         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
545         bytes memory args = ba2cbor(argN);
546         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
547     }
548     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
549         bytes[] memory dynargs = new bytes[](1);
550         dynargs[0] = args[0];
551         return oraclize_query(datasource, dynargs);
552     }
553     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
554         bytes[] memory dynargs = new bytes[](1);
555         dynargs[0] = args[0];
556         return oraclize_query(timestamp, datasource, dynargs);
557     }
558     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
559         bytes[] memory dynargs = new bytes[](1);
560         dynargs[0] = args[0];
561         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
562     }
563     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
564         bytes[] memory dynargs = new bytes[](1);
565         dynargs[0] = args[0];
566         return oraclize_query(datasource, dynargs, gaslimit);
567     }
568 
569     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
570         bytes[] memory dynargs = new bytes[](2);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         return oraclize_query(datasource, dynargs);
574     }
575     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
576         bytes[] memory dynargs = new bytes[](2);
577         dynargs[0] = args[0];
578         dynargs[1] = args[1];
579         return oraclize_query(timestamp, datasource, dynargs);
580     }
581     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
582         bytes[] memory dynargs = new bytes[](2);
583         dynargs[0] = args[0];
584         dynargs[1] = args[1];
585         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
586     }
587     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
588         bytes[] memory dynargs = new bytes[](2);
589         dynargs[0] = args[0];
590         dynargs[1] = args[1];
591         return oraclize_query(datasource, dynargs, gaslimit);
592     }
593     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
594         bytes[] memory dynargs = new bytes[](3);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         return oraclize_query(datasource, dynargs);
599     }
600     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](3);
602         dynargs[0] = args[0];
603         dynargs[1] = args[1];
604         dynargs[2] = args[2];
605         return oraclize_query(timestamp, datasource, dynargs);
606     }
607     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](3);
609         dynargs[0] = args[0];
610         dynargs[1] = args[1];
611         dynargs[2] = args[2];
612         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
613     }
614     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
615         bytes[] memory dynargs = new bytes[](3);
616         dynargs[0] = args[0];
617         dynargs[1] = args[1];
618         dynargs[2] = args[2];
619         return oraclize_query(datasource, dynargs, gaslimit);
620     }
621 
622     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](4);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         dynargs[2] = args[2];
627         dynargs[3] = args[3];
628         return oraclize_query(datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](4);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         dynargs[2] = args[2];
635         dynargs[3] = args[3];
636         return oraclize_query(timestamp, datasource, dynargs);
637     }
638     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
639         bytes[] memory dynargs = new bytes[](4);
640         dynargs[0] = args[0];
641         dynargs[1] = args[1];
642         dynargs[2] = args[2];
643         dynargs[3] = args[3];
644         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
645     }
646     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](4);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         dynargs[2] = args[2];
651         dynargs[3] = args[3];
652         return oraclize_query(datasource, dynargs, gaslimit);
653     }
654     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](5);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         dynargs[3] = args[3];
660         dynargs[4] = args[4];
661         return oraclize_query(datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](5);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         dynargs[4] = args[4];
670         return oraclize_query(timestamp, datasource, dynargs);
671     }
672     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](5);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         dynargs[3] = args[3];
678         dynargs[4] = args[4];
679         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
680     }
681     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](5);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         dynargs[3] = args[3];
687         dynargs[4] = args[4];
688         return oraclize_query(datasource, dynargs, gaslimit);
689     }
690 
691     function oraclize_cbAddress() oraclizeAPI internal returns (address){
692         return oraclize.cbAddress();
693     }
694     function oraclize_setProof(byte proofP) oraclizeAPI internal {
695         return oraclize.setProofType(proofP);
696     }
697     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
698         return oraclize.setCustomGasPrice(gasPrice);
699     }
700     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
701         return oraclize.setConfig(config);
702     }
703 
704     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
705         return oraclize.randomDS_getSessionPubKeyHash();
706     }
707 
708     function getCodeSize(address _addr) constant internal returns(uint _size) {
709         assembly {
710             _size := extcodesize(_addr)
711         }
712     }
713 
714     function parseAddr(string _a) internal returns (address){
715         bytes memory tmp = bytes(_a);
716         uint160 iaddr = 0;
717         uint160 b1;
718         uint160 b2;
719         for (uint i=2; i<2+2*20; i+=2){
720             iaddr *= 256;
721             b1 = uint160(tmp[i]);
722             b2 = uint160(tmp[i+1]);
723             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
724             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
725             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
726             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
727             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
728             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
729             iaddr += (b1*16+b2);
730         }
731         return address(iaddr);
732     }
733 
734     function strCompare(string _a, string _b) internal returns (int) {
735         bytes memory a = bytes(_a);
736         bytes memory b = bytes(_b);
737         uint minLength = a.length;
738         if (b.length < minLength) minLength = b.length;
739         for (uint i = 0; i < minLength; i ++)
740             if (a[i] < b[i])
741                 return -1;
742             else if (a[i] > b[i])
743                 return 1;
744         if (a.length < b.length)
745             return -1;
746         else if (a.length > b.length)
747             return 1;
748         else
749             return 0;
750     }
751 
752     function indexOf(string _haystack, string _needle) internal returns (int) {
753         bytes memory h = bytes(_haystack);
754         bytes memory n = bytes(_needle);
755         if(h.length < 1 || n.length < 1 || (n.length > h.length))
756             return -1;
757         else if(h.length > (2**128 -1))
758             return -1;
759         else
760         {
761             uint subindex = 0;
762             for (uint i = 0; i < h.length; i ++)
763             {
764                 if (h[i] == n[0])
765                 {
766                     subindex = 1;
767                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
768                     {
769                         subindex++;
770                     }
771                     if(subindex == n.length)
772                         return int(i);
773                 }
774             }
775             return -1;
776         }
777     }
778 
779     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
780         bytes memory _ba = bytes(_a);
781         bytes memory _bb = bytes(_b);
782         bytes memory _bc = bytes(_c);
783         bytes memory _bd = bytes(_d);
784         bytes memory _be = bytes(_e);
785         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
786         bytes memory babcde = bytes(abcde);
787         uint k = 0;
788         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
789         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
790         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
791         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
792         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
793         return string(babcde);
794     }
795 
796     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
797         return strConcat(_a, _b, _c, _d, "");
798     }
799 
800     function strConcat(string _a, string _b, string _c) internal returns (string) {
801         return strConcat(_a, _b, _c, "", "");
802     }
803 
804     function strConcat(string _a, string _b) internal returns (string) {
805         return strConcat(_a, _b, "", "", "");
806     }
807 
808     // parseInt
809     function parseInt(string _a) internal returns (uint) {
810         return parseInt(_a, 0);
811     }
812 
813     // parseInt(parseFloat*10^_b)
814     function parseInt(string _a, uint _b) internal returns (uint) {
815         bytes memory bresult = bytes(_a);
816         uint mint = 0;
817         bool decimals = false;
818         for (uint i=0; i<bresult.length; i++){
819             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
820                 if (decimals){
821                    if (_b == 0) break;
822                     else _b--;
823                 }
824                 mint *= 10;
825                 mint += uint(bresult[i]) - 48;
826             } else if (bresult[i] == 46) decimals = true;
827         }
828         if (_b > 0) mint *= 10**_b;
829         return mint;
830     }
831 
832     function uint2str(uint i) internal returns (string){
833         if (i == 0) return "0";
834         uint j = i;
835         uint len;
836         while (j != 0){
837             len++;
838             j /= 10;
839         }
840         bytes memory bstr = new bytes(len);
841         uint k = len - 1;
842         while (i != 0){
843             bstr[k--] = byte(48 + i % 10);
844             i /= 10;
845         }
846         return string(bstr);
847     }
848 
849     using CBOR for Buffer.buffer;
850     function stra2cbor(string[] arr) internal constant returns (bytes) {
851         Buffer.buffer memory buf;
852         Buffer.init(buf, 1024);
853         buf.startArray();
854         for (uint i = 0; i < arr.length; i++) {
855             buf.encodeString(arr[i]);
856         }
857         buf.endSequence();
858         return buf.buf;
859     }
860 
861     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
862         Buffer.buffer memory buf;
863         Buffer.init(buf, 1024);
864         buf.startArray();
865         for (uint i = 0; i < arr.length; i++) {
866             buf.encodeBytes(arr[i]);
867         }
868         buf.endSequence();
869         return buf.buf;
870     }
871 
872     string oraclize_network_name;
873     function oraclize_setNetworkName(string _network_name) internal {
874         oraclize_network_name = _network_name;
875     }
876 
877     function oraclize_getNetworkName() internal returns (string) {
878         return oraclize_network_name;
879     }
880 
881     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
882         if ((_nbytes == 0)||(_nbytes > 32)) throw;
883 	// Convert from seconds to ledger timer ticks
884         _delay *= 10;
885         bytes memory nbytes = new bytes(1);
886         nbytes[0] = byte(_nbytes);
887         bytes memory unonce = new bytes(32);
888         bytes memory sessionKeyHash = new bytes(32);
889         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
890         assembly {
891             mstore(unonce, 0x20)
892             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
893             mstore(sessionKeyHash, 0x20)
894             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
895         }
896         bytes memory delay = new bytes(32);
897         assembly {
898             mstore(add(delay, 0x20), _delay)
899         }
900 
901         bytes memory delay_bytes8 = new bytes(8);
902         copyBytes(delay, 24, 8, delay_bytes8, 0);
903 
904         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
905         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
906 
907         bytes memory delay_bytes8_left = new bytes(8);
908 
909         assembly {
910             let x := mload(add(delay_bytes8, 0x20))
911             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
912             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
913             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
914             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
915             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
916             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
917             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
918             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
919 
920         }
921 
922         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
923         return queryId;
924     }
925 
926     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
927         oraclize_randomDS_args[queryId] = commitment;
928     }
929 
930     mapping(bytes32=>bytes32) oraclize_randomDS_args;
931     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
932 
933     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
934         bool sigok;
935         address signer;
936 
937         bytes32 sigr;
938         bytes32 sigs;
939 
940         bytes memory sigr_ = new bytes(32);
941         uint offset = 4+(uint(dersig[3]) - 0x20);
942         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
943         bytes memory sigs_ = new bytes(32);
944         offset += 32 + 2;
945         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
946 
947         assembly {
948             sigr := mload(add(sigr_, 32))
949             sigs := mload(add(sigs_, 32))
950         }
951 
952 
953         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
954         if (address(sha3(pubkey)) == signer) return true;
955         else {
956             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
957             return (address(sha3(pubkey)) == signer);
958         }
959     }
960 
961     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
962         bool sigok;
963 
964         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
965         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
966         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
967 
968         bytes memory appkey1_pubkey = new bytes(64);
969         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
970 
971         bytes memory tosign2 = new bytes(1+65+32);
972         tosign2[0] = 1; //role
973         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
974         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
975         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
976         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
977 
978         if (sigok == false) return false;
979 
980 
981         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
982         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
983 
984         bytes memory tosign3 = new bytes(1+65);
985         tosign3[0] = 0xFE;
986         copyBytes(proof, 3, 65, tosign3, 1);
987 
988         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
989         copyBytes(proof, 3+65, sig3.length, sig3, 0);
990 
991         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
992 
993         return sigok;
994     }
995 
996     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
997         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
998         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
999 
1000         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1001         if (proofVerified == false) throw;
1002 
1003         _;
1004     }
1005 
1006     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1007         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1008         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1009 
1010         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1011         if (proofVerified == false) return 2;
1012 
1013         return 0;
1014     }
1015 
1016     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1017         bool match_ = true;
1018 
1019 	if (prefix.length != n_random_bytes) throw;
1020 
1021         for (uint256 i=0; i< n_random_bytes; i++) {
1022             if (content[i] != prefix[i]) match_ = false;
1023         }
1024 
1025         return match_;
1026     }
1027 
1028     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1029 
1030         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1031         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1032         bytes memory keyhash = new bytes(32);
1033         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1034         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1035 
1036         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1037         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1038 
1039         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1040         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1041 
1042         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1043         // This is to verify that the computed args match with the ones specified in the query.
1044         bytes memory commitmentSlice1 = new bytes(8+1+32);
1045         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1046 
1047         bytes memory sessionPubkey = new bytes(64);
1048         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1049         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1050 
1051         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1052         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1053             delete oraclize_randomDS_args[queryId];
1054         } else return false;
1055 
1056 
1057         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1058         bytes memory tosign1 = new bytes(32+8+1+32);
1059         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1060         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1061 
1062         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1063         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1064             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1065         }
1066 
1067         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1068     }
1069 
1070 
1071     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1072     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1073         uint minLength = length + toOffset;
1074 
1075         if (to.length < minLength) {
1076             // Buffer too small
1077             throw; // Should be a better way?
1078         }
1079 
1080         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1081         uint i = 32 + fromOffset;
1082         uint j = 32 + toOffset;
1083 
1084         while (i < (32 + fromOffset + length)) {
1085             assembly {
1086                 let tmp := mload(add(from, i))
1087                 mstore(add(to, j), tmp)
1088             }
1089             i += 32;
1090             j += 32;
1091         }
1092 
1093         return to;
1094     }
1095 
1096     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1097     // Duplicate Solidity's ecrecover, but catching the CALL return value
1098     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1099         // We do our own memory management here. Solidity uses memory offset
1100         // 0x40 to store the current end of memory. We write past it (as
1101         // writes are memory extensions), but don't update the offset so
1102         // Solidity will reuse it. The memory used here is only needed for
1103         // this context.
1104 
1105         // FIXME: inline assembly can't access return values
1106         bool ret;
1107         address addr;
1108 
1109         assembly {
1110             let size := mload(0x40)
1111             mstore(size, hash)
1112             mstore(add(size, 32), v)
1113             mstore(add(size, 64), r)
1114             mstore(add(size, 96), s)
1115 
1116             // NOTE: we can reuse the request memory because we deal with
1117             //       the return code
1118             ret := call(3000, 1, 0, size, 128, size, 32)
1119             addr := mload(size)
1120         }
1121 
1122         return (ret, addr);
1123     }
1124 
1125     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1126     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1127         bytes32 r;
1128         bytes32 s;
1129         uint8 v;
1130 
1131         if (sig.length != 65)
1132           return (false, 0);
1133 
1134         // The signature format is a compact form of:
1135         //   {bytes32 r}{bytes32 s}{uint8 v}
1136         // Compact means, uint8 is not padded to 32 bytes.
1137         assembly {
1138             r := mload(add(sig, 32))
1139             s := mload(add(sig, 64))
1140 
1141             // Here we are loading the last 32 bytes. We exploit the fact that
1142             // 'mload' will pad with zeroes if we overread.
1143             // There is no 'mload8' to do this, but that would be nicer.
1144             v := byte(0, mload(add(sig, 96)))
1145 
1146             // Alternative solution:
1147             // 'byte' is not working due to the Solidity parser, so lets
1148             // use the second best option, 'and'
1149             // v := and(mload(add(sig, 65)), 255)
1150         }
1151 
1152         // albeit non-transactional signatures are not specified by the YP, one would expect it
1153         // to match the YP range of [27, 28]
1154         //
1155         // geth uses [0, 1] and some clients have followed. This might change, see:
1156         //  https://github.com/ethereum/go-ethereum/issues/2053
1157         if (v < 27)
1158           v += 27;
1159 
1160         if (v != 27 && v != 28)
1161             return (false, 0);
1162 
1163         return safer_ecrecover(hash, v, r, s);
1164     }
1165 
1166 }
1167 
1168 
1169 contract Cryptodraw is usingOraclize {
1170     address private contractOwner;
1171     address[] private playerList;
1172 
1173     // Oracle to query WolframAlpha
1174     string private wolframRandom;
1175     event newWolframRandom(string wolframRandom);
1176     
1177     // Public seed of the previous round
1178     string private previousSeed;
1179     bytes32 private previousHash;
1180     uint private previousHashUint;
1181     uint private previousWinner;
1182     
1183     // Winner variable
1184     uint private winner;
1185     // Ticketprice per entry
1186     uint constant ticketPrice = 0.01 ether;
1187     // Maximum of players to join
1188     uint constant maxPlayers = 25;
1189     // Maximum of players to join
1190     uint constant Fee = 4;
1191     // Track the poolround
1192     uint round = 1;
1193     //Declare owners address
1194     address poolOwner = msg.sender;
1195     // Declare timestamp 
1196     uint timestamp = now + 2 weeks;
1197 
1198     // Contructor to initiate the conatract
1199     function Cryptodraw() public {
1200         contractOwner = msg.sender;
1201         oraclize_setCustomGasPrice(5000000000 wei);
1202     }
1203     
1204     modifier restricted() {
1205         require(msg.sender == contractOwner);
1206         _;
1207     }
1208 
1209     function __callback(bytes32 myid, string result) {
1210         if (msg.sender != oraclize_cbAddress()) throw;
1211         wolframRandom = result;
1212         newWolframRandom(wolframRandom);
1213         uint ownerFee = address(this).balance / 100 * Fee;
1214         uint totalPayout = address(this).balance - ownerFee;
1215         // Pick the winner of the lottery
1216         winner = calculateHash() % playerList.length;
1217         // Send reward to the winner
1218         playerList[winner].transfer(totalPayout);
1219         // Send reward to the contractOwner
1220         poolOwner.transfer(ownerFee);
1221         
1222         // List the previous seed to verify results 
1223         previousSeed = wolframRandom;
1224         previousHash = keccak256(wolframRandom);
1225         previousHashUint = uint(keccak256(wolframRandom));
1226         previousWinner = winner;
1227         
1228         // Clear the current addresses so pool can restart
1229         playerList = new address[](0);
1230 
1231         // Set some round specific stuff
1232         round += 1;      
1233         timestamp = now + 2 weeks;
1234     }
1235     
1236     function joinLottery() public payable {
1237         if (playerList.length < maxPlayers) {
1238             require(msg.value == ticketPrice);
1239             playerList.push(msg.sender);
1240         }
1241         else {
1242             revert();
1243         }
1244     }
1245 
1246     // Calculating hash with a oracilize seed (Wolfram)
1247     function calculateHash() internal returns (uint) {
1248         return uint(keccak256(wolframRandom));
1249     }
1250     
1251     function update() payable {
1252         if (playerList.length == maxPlayers || now > timestamp) {
1253             if (oraclize_getPrice("URL") > this.balance) {
1254             // "Oraclize query was NOT sent, please add some ETH to cover for the query fee
1255             } 
1256             else {
1257             // Oraclize can be queried
1258             oraclize_query("WolframAlpha", "Give me 20 random words", 700000);
1259             }
1260         }
1261         else {
1262             revert();
1263         }
1264     }
1265     
1266     function notSameSeed (string a, string b) private view returns (bool) {
1267        return keccak256(a) != keccak256(b);
1268    }
1269     
1270     function getPreviousSeed() public view returns (string) {
1271         return previousSeed;
1272     }
1273     
1274     function getHash() public view returns (bytes32) {
1275         return previousHash;
1276     }
1277     
1278     function getPreviousHashUint() public view returns (uint) {
1279         return previousHashUint;
1280     }
1281     
1282     function getPlayerLength() public view returns (uint) {
1283         return playerList.length;
1284     }
1285     
1286     function getPreviousWinner() public view returns (uint) {
1287         return previousWinner;
1288     }
1289     
1290     
1291      // Return list of players
1292     function getPlayers() public view returns (address[]) {
1293         return playerList;
1294     }
1295     
1296     // Return list of players
1297     function getTime() public view returns (uint) {
1298         return timestamp;
1299     }
1300     
1301 
1302     //Return max entries
1303     function getMaxTickets() public view returns (uint) {
1304         return maxPlayers;
1305     }
1306     
1307         //Return max entries
1308     function getRound() public view returns (uint) {
1309         return round;
1310     }
1311     
1312         //Return tickets left in the contract
1313     function getTicketsLeft() public view returns (uint) {
1314         return maxPlayers - playerList.length;
1315     }
1316     
1317         //Get total lottery amount
1318     function getLotteryBalance() public view returns (uint) {
1319         return address(this).balance;
1320     }
1321     
1322             //Get total lottery amount
1323     function getTicketPrice() public view returns (uint) {
1324         return ticketPrice;
1325     }
1326     
1327 }