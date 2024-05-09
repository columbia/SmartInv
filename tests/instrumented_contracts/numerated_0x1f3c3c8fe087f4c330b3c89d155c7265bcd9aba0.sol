1 pragma solidity 0.4.18;
2 
3 /**
4  * For convenience, you can delete all of the code between the <ORACLIZE_API>
5  * and </ORACLIZE_API> tags as etherscan cannot use the import callback, you
6  * can then just uncomment the line below and compile it via Remix.
7  */
8 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
9 
10 
11 // <ORACLIZE_API>
12 /*
13 Copyright (c) 2015-2016 Oraclize SRL
14 Copyright (c) 2016 Oraclize LTD
15 
16 
17 
18 Permission is hereby granted, free of charge, to any person obtaining a copy
19 of this software and associated documentation files (the "Software"), to deal
20 in the Software without restriction, including without limitation the rights
21 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 copies of the Software, and to permit persons to whom the Software is
23 furnished to do so, subject to the following conditions:
24 
25 
26 
27 The above copyright notice and this permission notice shall be included in
28 all copies or substantial portions of the Software.
29 
30 
31 
32 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
35 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
38 THE SOFTWARE.
39 */
40 
41 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
42 
43 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
44 
45 contract OraclizeI {
46     address public cbAddress;
47     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
48     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
49     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
50     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
51     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
52     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
53     function getPrice(string _datasource) public returns (uint _dsprice);
54     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
55     function setProofType(byte _proofType) external;
56     function setCustomGasPrice(uint _gasPrice) external;
57     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
58 }
59 
60 contract OraclizeAddrResolverI {
61     function getAddress() public returns (address _addr);
62 }
63 
64 /*
65 Begin solidity-cborutils
66 
67 https://github.com/smartcontractkit/solidity-cborutils
68 
69 MIT License
70 
71 Copyright (c) 2018 SmartContract ChainLink, Ltd.
72 
73 Permission is hereby granted, free of charge, to any person obtaining a copy
74 of this software and associated documentation files (the "Software"), to deal
75 in the Software without restriction, including without limitation the rights
76 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
77 copies of the Software, and to permit persons to whom the Software is
78 furnished to do so, subject to the following conditions:
79 
80 The above copyright notice and this permission notice shall be included in all
81 copies or substantial portions of the Software.
82 
83 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
84 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
85 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
86 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
87 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
88 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
89 SOFTWARE.
90  */
91 
92 library Buffer {
93     struct buffer {
94         bytes buf;
95         uint capacity;
96     }
97 
98     function init(buffer memory buf, uint _capacity) internal pure {
99         uint capacity = _capacity;
100         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
101         // Allocate space for the buffer data
102         buf.capacity = capacity;
103         assembly {
104             let ptr := mload(0x40)
105             mstore(buf, ptr)
106             mstore(ptr, 0)
107             mstore(0x40, add(ptr, capacity))
108         }
109     }
110 
111     function resize(buffer memory buf, uint capacity) private pure {
112         bytes memory oldbuf = buf.buf;
113         init(buf, capacity);
114         append(buf, oldbuf);
115     }
116 
117     function max(uint a, uint b) private pure returns(uint) {
118         if(a > b) {
119             return a;
120         }
121         return b;
122     }
123 
124     /**
125      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
126      *      would exceed the capacity of the buffer.
127      * @param buf The buffer to append to.
128      * @param data The data to append.
129      * @return The original buffer.
130      */
131     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
132         if(data.length + buf.buf.length > buf.capacity) {
133             resize(buf, max(buf.capacity, data.length) * 2);
134         }
135 
136         uint dest;
137         uint src;
138         uint len = data.length;
139         assembly {
140             // Memory address of the buffer data
141             let bufptr := mload(buf)
142             // Length of existing buffer data
143             let buflen := mload(bufptr)
144             // Start address = buffer address + buffer length + sizeof(buffer length)
145             dest := add(add(bufptr, buflen), 32)
146             // Update buffer length
147             mstore(bufptr, add(buflen, mload(data)))
148             src := add(data, 32)
149         }
150 
151         // Copy word-length chunks while possible
152         for(; len >= 32; len -= 32) {
153             assembly {
154                 mstore(dest, mload(src))
155             }
156             dest += 32;
157             src += 32;
158         }
159 
160         // Copy remaining bytes
161         uint mask = 256 ** (32 - len) - 1;
162         assembly {
163             let srcpart := and(mload(src), not(mask))
164             let destpart := and(mload(dest), mask)
165             mstore(dest, or(destpart, srcpart))
166         }
167 
168         return buf;
169     }
170 
171     /**
172      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
173      * exceed the capacity of the buffer.
174      * @param buf The buffer to append to.
175      * @param data The data to append.
176      * @return The original buffer.
177      */
178     function append(buffer memory buf, uint8 data) internal pure {
179         if(buf.buf.length + 1 > buf.capacity) {
180             resize(buf, buf.capacity * 2);
181         }
182 
183         assembly {
184             // Memory address of the buffer data
185             let bufptr := mload(buf)
186             // Length of existing buffer data
187             let buflen := mload(bufptr)
188             // Address = buffer address + buffer length + sizeof(buffer length)
189             let dest := add(add(bufptr, buflen), 32)
190             mstore8(dest, data)
191             // Update buffer length
192             mstore(bufptr, add(buflen, 1))
193         }
194     }
195 
196     /**
197      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
198      * exceed the capacity of the buffer.
199      * @param buf The buffer to append to.
200      * @param data The data to append.
201      * @return The original buffer.
202      */
203     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
204         if(len + buf.buf.length > buf.capacity) {
205             resize(buf, max(buf.capacity, len) * 2);
206         }
207 
208         uint mask = 256 ** len - 1;
209         assembly {
210             // Memory address of the buffer data
211             let bufptr := mload(buf)
212             // Length of existing buffer data
213             let buflen := mload(bufptr)
214             // Address = buffer address + buffer length + sizeof(buffer length) + len
215             let dest := add(add(bufptr, buflen), len)
216             mstore(dest, or(and(mload(dest), not(mask)), data))
217             // Update buffer length
218             mstore(bufptr, add(buflen, len))
219         }
220         return buf;
221     }
222 }
223 
224 library CBOR {
225     using Buffer for Buffer.buffer;
226 
227     uint8 private constant MAJOR_TYPE_INT = 0;
228     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
229     uint8 private constant MAJOR_TYPE_BYTES = 2;
230     uint8 private constant MAJOR_TYPE_STRING = 3;
231     uint8 private constant MAJOR_TYPE_ARRAY = 4;
232     uint8 private constant MAJOR_TYPE_MAP = 5;
233     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
234 
235     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
236         if(value <= 23) {
237             buf.append(uint8((major << 5) | value));
238         } else if(value <= 0xFF) {
239             buf.append(uint8((major << 5) | 24));
240             buf.appendInt(value, 1);
241         } else if(value <= 0xFFFF) {
242             buf.append(uint8((major << 5) | 25));
243             buf.appendInt(value, 2);
244         } else if(value <= 0xFFFFFFFF) {
245             buf.append(uint8((major << 5) | 26));
246             buf.appendInt(value, 4);
247         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
248             buf.append(uint8((major << 5) | 27));
249             buf.appendInt(value, 8);
250         }
251     }
252 
253     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
254         buf.append(uint8((major << 5) | 31));
255     }
256 
257     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
258         encodeType(buf, MAJOR_TYPE_INT, value);
259     }
260 
261     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
262         if(value >= 0) {
263             encodeType(buf, MAJOR_TYPE_INT, uint(value));
264         } else {
265             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
266         }
267     }
268 
269     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
270         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
271         buf.append(value);
272     }
273 
274     function encodeString(Buffer.buffer memory buf, string value) internal pure {
275         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
276         buf.append(bytes(value));
277     }
278 
279     function startArray(Buffer.buffer memory buf) internal pure {
280         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
281     }
282 
283     function startMap(Buffer.buffer memory buf) internal pure {
284         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
285     }
286 
287     function endSequence(Buffer.buffer memory buf) internal pure {
288         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
289     }
290 }
291 
292 /*
293 End solidity-cborutils
294  */
295 
296 contract usingOraclize {
297     uint constant day = 60*60*24;
298     uint constant week = 60*60*24*7;
299     uint constant month = 60*60*24*30;
300     byte constant proofType_NONE = 0x00;
301     byte constant proofType_TLSNotary = 0x10;
302     byte constant proofType_Ledger = 0x30;
303     byte constant proofType_Android = 0x40;
304     byte constant proofType_Native = 0xF0;
305     byte constant proofStorage_IPFS = 0x01;
306     uint8 constant networkID_auto = 0;
307     uint8 constant networkID_mainnet = 1;
308     uint8 constant networkID_testnet = 2;
309     uint8 constant networkID_morden = 2;
310     uint8 constant networkID_consensys = 161;
311 
312     OraclizeAddrResolverI OAR;
313 
314     OraclizeI oraclize;
315     modifier oraclizeAPI {
316         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
317             oraclize_setNetwork(networkID_auto);
318 
319         if(address(oraclize) != OAR.getAddress())
320             oraclize = OraclizeI(OAR.getAddress());
321 
322         _;
323     }
324     modifier coupon(string code){
325         oraclize = OraclizeI(OAR.getAddress());
326         _;
327     }
328 
329     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
330       return oraclize_setNetwork();
331       networkID; // silence the warning and remain backwards compatible
332     }
333     function oraclize_setNetwork() internal returns(bool){
334         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
335             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
336             oraclize_setNetworkName("eth_mainnet");
337             return true;
338         }
339         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
340             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
341             oraclize_setNetworkName("eth_ropsten3");
342             return true;
343         }
344         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
345             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
346             oraclize_setNetworkName("eth_kovan");
347             return true;
348         }
349         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
350             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
351             oraclize_setNetworkName("eth_rinkeby");
352             return true;
353         }
354         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
355             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
356             return true;
357         }
358         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
359             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
360             return true;
361         }
362         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
363             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
364             return true;
365         }
366         return false;
367     }
368 
369     function __callback(bytes32 myid, string result) public {
370         __callback(myid, result, new bytes(0));
371     }
372     function __callback(bytes32 myid, string result, bytes proof) public {
373       return;
374       myid; result; proof; // Silence compiler warnings
375     }
376 
377     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
378         return oraclize.getPrice(datasource);
379     }
380 
381     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
382         return oraclize.getPrice(datasource, gaslimit);
383     }
384 
385     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
386         uint price = oraclize.getPrice(datasource);
387         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
388         return oraclize.query.value(price)(0, datasource, arg);
389     }
390     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource);
392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
393         return oraclize.query.value(price)(timestamp, datasource, arg);
394     }
395     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
399     }
400     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
401         uint price = oraclize.getPrice(datasource, gaslimit);
402         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
403         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
404     }
405     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource);
407         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
408         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
409     }
410     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource);
412         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
413         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
414     }
415     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
416         uint price = oraclize.getPrice(datasource, gaslimit);
417         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
418         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
419     }
420     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource, gaslimit);
422         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
423         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
424     }
425     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource);
427         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
428         bytes memory args = stra2cbor(argN);
429         return oraclize.queryN.value(price)(0, datasource, args);
430     }
431     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource);
433         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
434         bytes memory args = stra2cbor(argN);
435         return oraclize.queryN.value(price)(timestamp, datasource, args);
436     }
437     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
438         uint price = oraclize.getPrice(datasource, gaslimit);
439         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
440         bytes memory args = stra2cbor(argN);
441         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
442     }
443     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
444         uint price = oraclize.getPrice(datasource, gaslimit);
445         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
446         bytes memory args = stra2cbor(argN);
447         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
448     }
449     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
450         string[] memory dynargs = new string[](1);
451         dynargs[0] = args[0];
452         return oraclize_query(datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
455         string[] memory dynargs = new string[](1);
456         dynargs[0] = args[0];
457         return oraclize_query(timestamp, datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](1);
461         dynargs[0] = args[0];
462         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
463     }
464     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](1);
466         dynargs[0] = args[0];
467         return oraclize_query(datasource, dynargs, gaslimit);
468     }
469 
470     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](2);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         return oraclize_query(datasource, dynargs);
475     }
476     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](2);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         return oraclize_query(timestamp, datasource, dynargs);
481     }
482     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
483         string[] memory dynargs = new string[](2);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
487     }
488     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](2);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         return oraclize_query(datasource, dynargs, gaslimit);
493     }
494     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](3);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         return oraclize_query(datasource, dynargs);
500     }
501     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
502         string[] memory dynargs = new string[](3);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         return oraclize_query(timestamp, datasource, dynargs);
507     }
508     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](3);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
514     }
515     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](3);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         return oraclize_query(datasource, dynargs, gaslimit);
521     }
522 
523     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
524         string[] memory dynargs = new string[](4);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         dynargs[2] = args[2];
528         dynargs[3] = args[3];
529         return oraclize_query(datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
532         string[] memory dynargs = new string[](4);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         return oraclize_query(timestamp, datasource, dynargs);
538     }
539     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](4);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         dynargs[2] = args[2];
544         dynargs[3] = args[3];
545         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
546     }
547     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](4);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         dynargs[3] = args[3];
553         return oraclize_query(datasource, dynargs, gaslimit);
554     }
555     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
556         string[] memory dynargs = new string[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(datasource, dynargs);
563     }
564     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
565         string[] memory dynargs = new string[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(timestamp, datasource, dynargs);
572     }
573     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
581     }
582     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
583         string[] memory dynargs = new string[](5);
584         dynargs[0] = args[0];
585         dynargs[1] = args[1];
586         dynargs[2] = args[2];
587         dynargs[3] = args[3];
588         dynargs[4] = args[4];
589         return oraclize_query(datasource, dynargs, gaslimit);
590     }
591     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
592         uint price = oraclize.getPrice(datasource);
593         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
594         bytes memory args = ba2cbor(argN);
595         return oraclize.queryN.value(price)(0, datasource, args);
596     }
597     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
598         uint price = oraclize.getPrice(datasource);
599         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
600         bytes memory args = ba2cbor(argN);
601         return oraclize.queryN.value(price)(timestamp, datasource, args);
602     }
603     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
604         uint price = oraclize.getPrice(datasource, gaslimit);
605         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
606         bytes memory args = ba2cbor(argN);
607         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
608     }
609     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
610         uint price = oraclize.getPrice(datasource, gaslimit);
611         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
612         bytes memory args = ba2cbor(argN);
613         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
614     }
615     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
616         bytes[] memory dynargs = new bytes[](1);
617         dynargs[0] = args[0];
618         return oraclize_query(datasource, dynargs);
619     }
620     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
621         bytes[] memory dynargs = new bytes[](1);
622         dynargs[0] = args[0];
623         return oraclize_query(timestamp, datasource, dynargs);
624     }
625     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](1);
627         dynargs[0] = args[0];
628         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
629     }
630     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](1);
632         dynargs[0] = args[0];
633         return oraclize_query(datasource, dynargs, gaslimit);
634     }
635 
636     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](2);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         return oraclize_query(datasource, dynargs);
641     }
642     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](2);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         return oraclize_query(timestamp, datasource, dynargs);
647     }
648     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
649         bytes[] memory dynargs = new bytes[](2);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
653     }
654     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](2);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         return oraclize_query(datasource, dynargs, gaslimit);
659     }
660     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](3);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         return oraclize_query(datasource, dynargs);
666     }
667     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
668         bytes[] memory dynargs = new bytes[](3);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         dynargs[2] = args[2];
672         return oraclize_query(timestamp, datasource, dynargs);
673     }
674     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](3);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
680     }
681     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](3);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         return oraclize_query(datasource, dynargs, gaslimit);
687     }
688 
689     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
690         bytes[] memory dynargs = new bytes[](4);
691         dynargs[0] = args[0];
692         dynargs[1] = args[1];
693         dynargs[2] = args[2];
694         dynargs[3] = args[3];
695         return oraclize_query(datasource, dynargs);
696     }
697     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
698         bytes[] memory dynargs = new bytes[](4);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         dynargs[2] = args[2];
702         dynargs[3] = args[3];
703         return oraclize_query(timestamp, datasource, dynargs);
704     }
705     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](4);
707         dynargs[0] = args[0];
708         dynargs[1] = args[1];
709         dynargs[2] = args[2];
710         dynargs[3] = args[3];
711         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
712     }
713     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](4);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         dynargs[2] = args[2];
718         dynargs[3] = args[3];
719         return oraclize_query(datasource, dynargs, gaslimit);
720     }
721     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
722         bytes[] memory dynargs = new bytes[](5);
723         dynargs[0] = args[0];
724         dynargs[1] = args[1];
725         dynargs[2] = args[2];
726         dynargs[3] = args[3];
727         dynargs[4] = args[4];
728         return oraclize_query(datasource, dynargs);
729     }
730     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
731         bytes[] memory dynargs = new bytes[](5);
732         dynargs[0] = args[0];
733         dynargs[1] = args[1];
734         dynargs[2] = args[2];
735         dynargs[3] = args[3];
736         dynargs[4] = args[4];
737         return oraclize_query(timestamp, datasource, dynargs);
738     }
739     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](5);
741         dynargs[0] = args[0];
742         dynargs[1] = args[1];
743         dynargs[2] = args[2];
744         dynargs[3] = args[3];
745         dynargs[4] = args[4];
746         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
747     }
748     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](5);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         dynargs[4] = args[4];
755         return oraclize_query(datasource, dynargs, gaslimit);
756     }
757 
758     function oraclize_cbAddress() oraclizeAPI internal returns (address){
759         return oraclize.cbAddress();
760     }
761     function oraclize_setProof(byte proofP) oraclizeAPI internal {
762         return oraclize.setProofType(proofP);
763     }
764     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
765         return oraclize.setCustomGasPrice(gasPrice);
766     }
767 
768     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
769         return oraclize.randomDS_getSessionPubKeyHash();
770     }
771 
772     function getCodeSize(address _addr) constant internal returns(uint _size) {
773         assembly {
774             _size := extcodesize(_addr)
775         }
776     }
777 
778     function parseAddr(string _a) internal pure returns (address){
779         bytes memory tmp = bytes(_a);
780         uint160 iaddr = 0;
781         uint160 b1;
782         uint160 b2;
783         for (uint i=2; i<2+2*20; i+=2){
784             iaddr *= 256;
785             b1 = uint160(tmp[i]);
786             b2 = uint160(tmp[i+1]);
787             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
788             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
789             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
790             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
791             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
792             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
793             iaddr += (b1*16+b2);
794         }
795         return address(iaddr);
796     }
797 
798     function strCompare(string _a, string _b) internal pure returns (int) {
799         bytes memory a = bytes(_a);
800         bytes memory b = bytes(_b);
801         uint minLength = a.length;
802         if (b.length < minLength) minLength = b.length;
803         for (uint i = 0; i < minLength; i ++)
804             if (a[i] < b[i])
805                 return -1;
806             else if (a[i] > b[i])
807                 return 1;
808         if (a.length < b.length)
809             return -1;
810         else if (a.length > b.length)
811             return 1;
812         else
813             return 0;
814     }
815 
816     function indexOf(string _haystack, string _needle) internal pure returns (int) {
817         bytes memory h = bytes(_haystack);
818         bytes memory n = bytes(_needle);
819         if(h.length < 1 || n.length < 1 || (n.length > h.length))
820             return -1;
821         else if(h.length > (2**128 -1))
822             return -1;
823         else
824         {
825             uint subindex = 0;
826             for (uint i = 0; i < h.length; i ++)
827             {
828                 if (h[i] == n[0])
829                 {
830                     subindex = 1;
831                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
832                     {
833                         subindex++;
834                     }
835                     if(subindex == n.length)
836                         return int(i);
837                 }
838             }
839             return -1;
840         }
841     }
842 
843     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
844         bytes memory _ba = bytes(_a);
845         bytes memory _bb = bytes(_b);
846         bytes memory _bc = bytes(_c);
847         bytes memory _bd = bytes(_d);
848         bytes memory _be = bytes(_e);
849         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
850         bytes memory babcde = bytes(abcde);
851         uint k = 0;
852         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
853         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
854         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
855         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
856         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
857         return string(babcde);
858     }
859 
860     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
861         return strConcat(_a, _b, _c, _d, "");
862     }
863 
864     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
865         return strConcat(_a, _b, _c, "", "");
866     }
867 
868     function strConcat(string _a, string _b) internal pure returns (string) {
869         return strConcat(_a, _b, "", "", "");
870     }
871 
872     // parseInt
873     function parseInt(string _a) internal pure returns (uint) {
874         return parseInt(_a, 0);
875     }
876 
877     // parseInt(parseFloat*10^_b)
878     function parseInt(string _a, uint _b) internal pure returns (uint) {
879         bytes memory bresult = bytes(_a);
880         uint mint = 0;
881         bool decimals = false;
882         for (uint i=0; i<bresult.length; i++){
883             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
884                 if (decimals){
885                    if (_b == 0) break;
886                     else _b--;
887                 }
888                 mint *= 10;
889                 mint += uint(bresult[i]) - 48;
890             } else if (bresult[i] == 46) decimals = true;
891         }
892         if (_b > 0) mint *= 10**_b;
893         return mint;
894     }
895 
896     function uint2str(uint i) internal pure returns (string){
897         if (i == 0) return "0";
898         uint j = i;
899         uint len;
900         while (j != 0){
901             len++;
902             j /= 10;
903         }
904         bytes memory bstr = new bytes(len);
905         uint k = len - 1;
906         while (i != 0){
907             bstr[k--] = byte(48 + i % 10);
908             i /= 10;
909         }
910         return string(bstr);
911     }
912 
913     using CBOR for Buffer.buffer;
914     function stra2cbor(string[] arr) internal pure returns (bytes) {
915         safeMemoryCleaner();
916         Buffer.buffer memory buf;
917         Buffer.init(buf, 1024);
918         buf.startArray();
919         for (uint i = 0; i < arr.length; i++) {
920             buf.encodeString(arr[i]);
921         }
922         buf.endSequence();
923         return buf.buf;
924     }
925 
926     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
927         safeMemoryCleaner();
928         Buffer.buffer memory buf;
929         Buffer.init(buf, 1024);
930         buf.startArray();
931         for (uint i = 0; i < arr.length; i++) {
932             buf.encodeBytes(arr[i]);
933         }
934         buf.endSequence();
935         return buf.buf;
936     }
937 
938     string oraclize_network_name;
939     function oraclize_setNetworkName(string _network_name) internal {
940         oraclize_network_name = _network_name;
941     }
942 
943     function oraclize_getNetworkName() internal view returns (string) {
944         return oraclize_network_name;
945     }
946 
947     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
948         require((_nbytes > 0) && (_nbytes <= 32));
949         // Convert from seconds to ledger timer ticks
950         _delay *= 10;
951         bytes memory nbytes = new bytes(1);
952         nbytes[0] = byte(_nbytes);
953         bytes memory unonce = new bytes(32);
954         bytes memory sessionKeyHash = new bytes(32);
955         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
956         assembly {
957             mstore(unonce, 0x20)
958             // the following variables can be relaxed
959             // check relaxed random contract under ethereum-examples repo
960             // for an idea on how to override and replace comit hash vars
961             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
962             mstore(sessionKeyHash, 0x20)
963             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
964         }
965         bytes memory delay = new bytes(32);
966         assembly {
967             mstore(add(delay, 0x20), _delay)
968         }
969 
970         bytes memory delay_bytes8 = new bytes(8);
971         copyBytes(delay, 24, 8, delay_bytes8, 0);
972 
973         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
974         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
975 
976         bytes memory delay_bytes8_left = new bytes(8);
977 
978         assembly {
979             let x := mload(add(delay_bytes8, 0x20))
980             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
981             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
982             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
983             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
984             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
985             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
986             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
987             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
988 
989         }
990 
991         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
992         return queryId;
993     }
994 
995     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
996         oraclize_randomDS_args[queryId] = commitment;
997     }
998 
999     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1000     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1001 
1002     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1003         bool sigok;
1004         address signer;
1005 
1006         bytes32 sigr;
1007         bytes32 sigs;
1008 
1009         bytes memory sigr_ = new bytes(32);
1010         uint offset = 4+(uint(dersig[3]) - 0x20);
1011         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1012         bytes memory sigs_ = new bytes(32);
1013         offset += 32 + 2;
1014         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1015 
1016         assembly {
1017             sigr := mload(add(sigr_, 32))
1018             sigs := mload(add(sigs_, 32))
1019         }
1020 
1021 
1022         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1023         if (address(keccak256(pubkey)) == signer) return true;
1024         else {
1025             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1026             return (address(keccak256(pubkey)) == signer);
1027         }
1028     }
1029 
1030     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1031         bool sigok;
1032 
1033         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1034         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1035         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1036 
1037         bytes memory appkey1_pubkey = new bytes(64);
1038         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1039 
1040         bytes memory tosign2 = new bytes(1+65+32);
1041         tosign2[0] = byte(1); //role
1042         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1043         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1044         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1045         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1046 
1047         if (sigok == false) return false;
1048 
1049 
1050         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1051         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1052 
1053         bytes memory tosign3 = new bytes(1+65);
1054         tosign3[0] = 0xFE;
1055         copyBytes(proof, 3, 65, tosign3, 1);
1056 
1057         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1058         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1059 
1060         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1061 
1062         return sigok;
1063     }
1064 
1065     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1066         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1067         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1068 
1069         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1070         require(proofVerified);
1071 
1072         _;
1073     }
1074 
1075     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1076         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1077         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1078 
1079         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1080         if (proofVerified == false) return 2;
1081 
1082         return 0;
1083     }
1084 
1085     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1086         bool match_ = true;
1087 
1088         require(prefix.length == n_random_bytes);
1089 
1090         for (uint256 i=0; i< n_random_bytes; i++) {
1091             if (content[i] != prefix[i]) match_ = false;
1092         }
1093 
1094         return match_;
1095     }
1096 
1097     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1098 
1099         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1100         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1101         bytes memory keyhash = new bytes(32);
1102         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1103         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1104 
1105         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1106         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1107 
1108         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1109         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1110 
1111         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1112         // This is to verify that the computed args match with the ones specified in the query.
1113         bytes memory commitmentSlice1 = new bytes(8+1+32);
1114         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1115 
1116         bytes memory sessionPubkey = new bytes(64);
1117         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1118         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1119 
1120         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1121         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1122             delete oraclize_randomDS_args[queryId];
1123         } else return false;
1124 
1125 
1126         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1127         bytes memory tosign1 = new bytes(32+8+1+32);
1128         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1129         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1130 
1131         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1132         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1133             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1134         }
1135 
1136         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1137     }
1138 
1139     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1140     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1141         uint minLength = length + toOffset;
1142 
1143         // Buffer too small
1144         require(to.length >= minLength); // Should be a better way?
1145 
1146         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1147         uint i = 32 + fromOffset;
1148         uint j = 32 + toOffset;
1149 
1150         while (i < (32 + fromOffset + length)) {
1151             assembly {
1152                 let tmp := mload(add(from, i))
1153                 mstore(add(to, j), tmp)
1154             }
1155             i += 32;
1156             j += 32;
1157         }
1158 
1159         return to;
1160     }
1161 
1162     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1163     // Duplicate Solidity's ecrecover, but catching the CALL return value
1164     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1165         // We do our own memory management here. Solidity uses memory offset
1166         // 0x40 to store the current end of memory. We write past it (as
1167         // writes are memory extensions), but don't update the offset so
1168         // Solidity will reuse it. The memory used here is only needed for
1169         // this context.
1170 
1171         // FIXME: inline assembly can't access return values
1172         bool ret;
1173         address addr;
1174 
1175         assembly {
1176             let size := mload(0x40)
1177             mstore(size, hash)
1178             mstore(add(size, 32), v)
1179             mstore(add(size, 64), r)
1180             mstore(add(size, 96), s)
1181 
1182             // NOTE: we can reuse the request memory because we deal with
1183             //       the return code
1184             ret := call(3000, 1, 0, size, 128, size, 32)
1185             addr := mload(size)
1186         }
1187 
1188         return (ret, addr);
1189     }
1190 
1191     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1192     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1193         bytes32 r;
1194         bytes32 s;
1195         uint8 v;
1196 
1197         if (sig.length != 65)
1198           return (false, 0);
1199 
1200         // The signature format is a compact form of:
1201         //   {bytes32 r}{bytes32 s}{uint8 v}
1202         // Compact means, uint8 is not padded to 32 bytes.
1203         assembly {
1204             r := mload(add(sig, 32))
1205             s := mload(add(sig, 64))
1206 
1207             // Here we are loading the last 32 bytes. We exploit the fact that
1208             // 'mload' will pad with zeroes if we overread.
1209             // There is no 'mload8' to do this, but that would be nicer.
1210             v := byte(0, mload(add(sig, 96)))
1211 
1212             // Alternative solution:
1213             // 'byte' is not working due to the Solidity parser, so lets
1214             // use the second best option, 'and'
1215             // v := and(mload(add(sig, 65)), 255)
1216         }
1217 
1218         // albeit non-transactional signatures are not specified by the YP, one would expect it
1219         // to match the YP range of [27, 28]
1220         //
1221         // geth uses [0, 1] and some clients have followed. This might change, see:
1222         //  https://github.com/ethereum/go-ethereum/issues/2053
1223         if (v < 27)
1224           v += 27;
1225 
1226         if (v != 27 && v != 28)
1227             return (false, 0);
1228 
1229         return safer_ecrecover(hash, v, r, s);
1230     }
1231 
1232     function safeMemoryCleaner() internal pure {
1233         assembly {
1234             let fmem := mload(0x40)
1235             codecopy(fmem, codesize, sub(msize, fmem))
1236         }
1237     }
1238 
1239 }
1240 // </ORACLIZE_API>
1241 
1242 
1243 /*===========================================================================================*
1244 *************************************** https://p4d.io ***************************************
1245 *============================================================================================*
1246 *                                                             
1247 *     ,-.----.           ,--,              
1248 *     \    /  \        ,--.'|    ,---,     
1249 *     |   :    \    ,--,  | :  .'  .' `\          ____                            __      
1250 *     |   |  .\ :,---.'|  : ',---.'     \        / __ \________  ________  ____  / /______
1251 *     .   :  |: |;   : |  | ;|   |  .`\  |      / /_/ / ___/ _ \/ ___/ _ \/ __ \/ __/ ___/
1252 *     |   |   \ :|   | : _' |:   : |  '  |     / ____/ /  /  __(__  )  __/ / / / /_(__  ) 
1253 *     |   : .   /:   : |.'  ||   ' '  ;  :    /_/   /_/___\\\_/____/\_\\/_\_/_/\__/____/  
1254 *     ;   | |`-' |   ' '  ; :'   | ;  .  |            /_  __/___      \ \/ /___  __  __   
1255 *     |   | ;    \   \  .'. ||   | :  |  '             / / / __ \      \  / __ \/ / / /   
1256 *     :   ' |     `---`:  | ''   : | /  ;             / / / /_/ /      / / /_/ / /_/ /    
1257 *     :   : :          '  ; ||   | '` ,/             /_/  \____/      /_/\____/\__,_/     
1258 *     |   | :          |  : ;;   :  .'     
1259 *     `---'.|          '  ,/ |   ,.'       
1260 *       `---`          '--'  '---'         
1261 * 
1262 *                        _______ _             _____        _           
1263 *                       (_______) |           (____ \      | |_         
1264 *                        _____  | |_   _ _   _ _   \ \ ____| | |_  ____ 
1265 *                       |  ___) | | | | ( \ / ) |   | / _  ) |  _)/ _  |
1266 *                       | |     | | |_| |) X (| |__/ ( (/ /| | |_( ( | |
1267 *                       |_|     |_|\____(_/ \_)_____/ \____)_|\___)_||_|
1268 * 
1269 *                                           ____
1270 *                                          /\   \
1271 *                                         /  \   \
1272 *                                        /    \   \
1273 *                                       /      \   \
1274 *                                      /   /\   \   \
1275 *                                     /   /  \   \   \
1276 *                                    /   /    \   \   \
1277 *                                   /   /    / \   \   \
1278 *                                  /   /    /   \   \   \
1279 *                                 /   /    /---------'   \
1280 *                                /   /    /_______________\
1281 *                                \  /                     /
1282 *                                 \/_____________________/
1283 *                   _       ___            _                  _       ___       
1284 *                  /_\     / __\___  _ __ | |_ _ __ __ _  ___| |_    / __\_   _ 
1285 *                 //_\\   / /  / _ \| '_ \| __| '__/ _` |/ __| __|  /__\// | | |
1286 *                /  _  \ / /__| (_) | | | | |_| | | (_| | (__| |_  / \/  \ |_| |
1287 *                \_/ \_/ \____/\___/|_| |_|\__|_|  \__,_|\___|\__| \_____/\__, |
1288 *                                   ╔═╗╔═╗╦      ╔╦╗╔═╗╦  ╦               |___/ 
1289 *                                   ╚═╗║ ║║       ║║║╣ ╚╗╔╝
1290 *                                   ╚═╝╚═╝╩═╝────═╩╝╚═╝ ╚╝ 
1291 *                                      0x736f6c5f646576
1292 *                                      ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
1293 *                                                
1294 */
1295 
1296 
1297 // P3D interface
1298 interface P3D {
1299     function sell(uint256) external;
1300     function myTokens() external view returns(uint256);
1301     function myDividends(bool) external view returns(uint256);
1302     function withdraw() external;
1303 }
1304 
1305 // P4D interface
1306 interface P4D {
1307     function buy(address) external payable returns(uint256);
1308     function sell(uint256) external;
1309     function transfer(address, uint256) external returns(bool);
1310     function myTokens() external view returns(uint256);
1311     function myStoredDividends() external view returns(uint256);
1312     function mySubdividends() external view returns(uint256);
1313     function withdraw(bool) external;
1314     function withdrawSubdivs(bool) external;
1315     function P3D_address() external view returns(address);
1316     function setCanAcceptTokens(address) external;
1317 }
1318 
1319 /**
1320  * An inheritable contract structure that connects to the P4D exchange
1321  * This will then point to the P3D exchange as well as providing the tokenCallback() function
1322  */
1323 contract usingP4D {
1324 
1325     P4D internal tokenContract;
1326     P3D internal _P3D;
1327 
1328     function usingP4D(address _P4D_address) public {
1329         tokenContract = P4D(_P4D_address);
1330         _P3D = P3D(tokenContract.P3D_address());
1331     }
1332 
1333     modifier onlyTokenContract {
1334         require(msg.sender == address(tokenContract));
1335         _;
1336     }
1337 
1338     function tokenCallback(address _from, uint256 _value, bytes _data) external returns (bool);
1339 }
1340 
1341 
1342 /**
1343  * This is the coin-pair contract, the main FluxDelta contract will create a new coin-pair
1344  * contract every time a pairing is added to the network. The FluxDelta contract is be able
1345  * to manage the coin-pair in respect to setting its UI visibility as well as the coin-pairs
1346  * callback gas price in case the network gets congested.
1347  * Each coin-pair contract is self-managing and has its own P4D, P3D and ETH balances. In
1348  * order to keep affording to pay for Oraclize calls, it will always maintain a certain 
1349  * amount of ETH and should it drop beneath a certain threshold, it will sell some of the
1350  * P3D that it holds. If it has a surplus of ETH, it will use the excess to purchase more
1351  * P4D that will go towards the global withdrawable pot.
1352  * A user can invest into a coin-pair via the P4D exchange contract using the transferAndCall()
1353  * function and they can withdraw their P4D shares via the main FluxDelta contract using the
1354  * withdrawFromCoinPair() function.
1355  */
1356 contract CoinPair is usingP4D, usingOraclize {
1357 
1358     using SafeMath for uint256;
1359 
1360     struct OraclizeMap {
1361         address _sender;
1362         bool _isNextShort;
1363         uint256 _sentValue;
1364     }
1365     mapping(bytes32 => OraclizeMap) private _oraclizeCallbackMap;
1366 
1367     event RequestSubmitted(bytes32 id);
1368 
1369     uint256 constant private _devOwnerCut = 1; // 1% of deposits are used as dev fees
1370     uint256 constant private _minDeposit = 100e18; // we need to cover Oraclize at a bare minimum
1371     uint256 constant private _sellThreshold = 0.1 ether; // if the balance drops below this, sell P4D
1372     uint256 constant private _buyThreshold = 0.2 ether; // if the balance goes above this, buy P4D
1373     int256 constant private _baseSharesPerRequest = 1e18; // 1% * 100e18
1374 
1375     address private _dev; // main developer; will receive 0.5% of P4D deposits
1376     address private _owner; // a nominated owner; they will also receive 0.5% of the depost
1377     address private _creator; // the parent FluxDelta contract
1378 
1379     uint256 private _devBalance = 0;
1380     uint256 private _ownerBalance = 0;
1381     uint256 private _processingP4D = 0;
1382 
1383     bytes32 public fSym;
1384     bytes32 public tSym;
1385     uint256 constant public baseCost = 100e18; // 100 P4D tokens
1386     uint256 public shares;
1387     mapping(address => uint256) public sharesOf;
1388     mapping(address => uint256) public scalarOf;
1389     mapping(address => bool) public isShorting;
1390     mapping(address => uint256) public lastPriceOf;
1391     mapping(address => uint256) public lastPriceTimeOf;
1392     bool public isVisible;
1393 
1394     /**
1395      * Modifier for restricting a call to just the FluxDelta contract
1396      */
1397     modifier onlyCreator {
1398         require(msg.sender == _creator);
1399         _;
1400     }
1401 
1402     /**
1403      * Coin-pair constructor;
1404      * _fSym: From symbol (eg ETH)
1405      * _tSym: To symbol (eg USD)
1406      * _ownerAddress: Nominated owner, will receive 0.5% of all deposits
1407      * _devAddress: FluxDelta dev, will also receive 0.5% of all deposits
1408      * _P4D_address: P4D exchange address reference
1409      */
1410     function CoinPair(string _fSym, string _tSym, address _ownerAddress, address _devAddress, address _P4D_address) public payable usingP4D(_P4D_address) {
1411         require (msg.value >= _sellThreshold);
1412 
1413         require(_ownerAddress != _devAddress && _ownerAddress != msg.sender && _devAddress != msg.sender);
1414 
1415         _creator = msg.sender;
1416         fSym = _stringToBytes32(_fSym);
1417         tSym = _stringToBytes32(_tSym);
1418         shares = 0;
1419         _owner = _ownerAddress;
1420         _dev = _devAddress;
1421         isVisible = true;
1422 
1423         changeOraclizeGasPrice(16e9); // 16 Gwei for all callbacks
1424     }
1425 
1426     /**
1427      * Main point of interaction within a coin-pair, the P4D contract will call this function
1428      * after a customer has sent P4D using the transferAndCall() function to this address.
1429      * This function sets up all of the required information in order to make a call to the
1430      * internet via Oraclize, this will fetch the current price of the coin-pair without needing
1431      * to worry about a user tampering with the data.
1432      * Oraclize is a paid service and requires ETH to use, this contract must pay a fee for the
1433      * internet call itself as well as the gas cost to cover the __callback() function below.
1434      */
1435     function tokenCallback(address _from, uint256 _value, bytes _data) external onlyTokenContract returns (bool) {
1436         require(_value >= _minDeposit);
1437 
1438         require(!_isContract(_from));
1439         require(_from != _dev && _from != _owner && _from != _creator);
1440 
1441         uint256 fees = _value.mul(_devOwnerCut).div(100); // 1%
1442         _devBalance = _devBalance.add(fees.div(2)); // 0.5%
1443         _ownerBalance = _ownerBalance.add(fees.div(2)); // 0.5%
1444 
1445         _processingP4D = _processingP4D.add(_value);
1446 
1447         /////////////////////////////////////////////////////////////////////////////////
1448         //  
1449         // The block of code below is responsible for using all of the P4D and P3D
1450         // dividends in order to both maintain and afford to pay for Oraclize calls
1451         // as well as purchasing more P4D to put towards the global pot should there
1452         // be an excess of ETH
1453         //
1454         // first withdraw all ETH subdividends from the P4D contract
1455         if (tokenContract.mySubdividends() > 0) {
1456             tokenContract.withdrawSubdivs(true);
1457         }
1458 
1459         // if this contracts ETH balance is less than the threshold, sell a minimum
1460         // P4D deposit (100 P4D) then sell 1/4 of all the held P3D in this contract
1461         //
1462         // if this contracts ETH balance is more than the buying threshold, use this
1463         // excess ETH to purchase more P4D to put in the global withdrawable pot
1464         if (address(this).balance < _sellThreshold) {
1465             tokenContract.sell(_minDeposit);
1466             tokenContract.withdraw(true);
1467             _P3D.sell(_P3D.myTokens().div(4)); // sell 1/4 of all P3D held by the contract
1468         } else if (address(this).balance > _buyThreshold) {
1469             uint256 diff = address(this).balance.sub(_buyThreshold);
1470             tokenContract.buy.value(diff)(_owner); // use the owner as a ref
1471         }
1472         
1473         // if there's any stored P3D dividends, withdraw and hold them
1474         if (tokenContract.myStoredDividends() > 0) {
1475             tokenContract.withdraw(true);
1476         }
1477 
1478         // finally, check if there's any ETH divs to withdraw from the P3D contract
1479         if (_P3D.myDividends(true) > 0) {
1480             _P3D.withdraw();
1481         }
1482 
1483         /////////////////////////////////////////////////////////////////////////////////
1484 
1485         uint256 gasLimit = 220000;
1486         if (lastPriceOf[_from] != 0) {
1487             gasLimit = 160000;
1488             require(_value.mul(1e18).div(baseCost) == scalarOf[_from]); // check if they sent the right amount
1489         }
1490 
1491         // parse the URL data for Oraclize
1492         string memory tSymString = strConcat("&tsyms=", _bytes32ToString(tSym), ").", _bytes32ToString(tSym));
1493         bytes32 queryId = oraclize_query("URL", strConcat("json(https://min-api.cryptocompare.com/data/price?fsym=", _bytes32ToString(fSym), tSymString), gasLimit);
1494 
1495         uint256 intData = _bytesToUint(_data);
1496         OraclizeMap memory map = OraclizeMap({
1497             _sender: _from,
1498             _isNextShort: intData != 0,
1499             _sentValue: _value
1500         });
1501         _oraclizeCallbackMap[queryId] = map;
1502 
1503         RequestSubmitted(queryId);
1504 
1505         return true;
1506     }
1507 
1508     /**
1509      * Oraclize callback function for returning data
1510      */
1511     function __callback(bytes32 myid, string result) public {
1512         require(msg.sender == oraclize_cbAddress());
1513         _handleCallback(myid, result);
1514     }
1515 
1516     /**
1517      * Internally handled callback, this function is responsible for updating the shares gained/lost
1518      * of a user once they've invested in a coin-pair. If you have already invested in the coin-pair
1519      * before, this will compare your last locked in price to the current price and provide you shares
1520      * based on the gain/loss of the coin-pair (as well as being multiplied by your staked P4D amount).
1521      */
1522     function _handleCallback(bytes32 _id, string _result) internal {
1523         OraclizeMap memory mappedInfo = _oraclizeCallbackMap[_id];
1524         address receiver = mappedInfo._sender;
1525         require(receiver != address(0x0));
1526 
1527         int256 latestPrice = int256(parseInt(_result, 18)); // 18 decimal places
1528         if (latestPrice > 0) {
1529 
1530             int256 lastPrice = int256(lastPriceOf[receiver]);
1531             if (lastPrice == 0) { // we are starting from the beginning
1532 
1533                 lastPriceTimeOf[receiver] = now;
1534                 lastPriceOf[receiver] = uint256(latestPrice);
1535                 scalarOf[receiver] = mappedInfo._sentValue.mul(1e18).div(baseCost);
1536                 sharesOf[receiver] = uint256(_baseSharesPerRequest) * scalarOf[receiver] / 1e18;
1537                 isShorting[receiver] = mappedInfo._isNextShort;
1538                 shares = shares.add(uint256(_baseSharesPerRequest) * scalarOf[receiver] / 1e18);
1539 
1540             } else { // they already have a price recorded so find the gain/loss
1541 
1542                 if (mappedInfo._sentValue.mul(1e18).div(baseCost) == scalarOf[receiver]) {
1543                     int256 delta = _baseSharesPerRequest + ((isShorting[receiver] ? int256(-1) : int256(1)) * ((100e18 * (latestPrice - lastPrice)) / lastPrice)); // in terms of % (18 decimals) + base gain (+1%)
1544                     delta = delta * int256(scalarOf[receiver]) / int256(1e18);
1545                     int256 currentShares = int256(sharesOf[receiver]);
1546                     if (currentShares + delta > _baseSharesPerRequest * int256(scalarOf[receiver]) / int256(1e18)) {
1547                         sharesOf[receiver] = uint256(currentShares + delta);
1548                     } else {
1549                         sharesOf[receiver] = uint256(_baseSharesPerRequest) * scalarOf[receiver] / 1e18;
1550                     }
1551 
1552                     lastPriceTimeOf[receiver] = now;
1553                     lastPriceOf[receiver] = uint256(latestPrice);
1554                     isShorting[receiver] = mappedInfo._isNextShort;
1555                     shares = uint256(int256(shares) + int256(sharesOf[receiver]) - currentShares);
1556                 } else { // something strange has happened so refund the P4D
1557                     require(tokenContract.transfer(receiver, mappedInfo._sentValue));
1558                 }
1559             }
1560         } else { // price returned an error so refund the P4D
1561             require(tokenContract.transfer(receiver, mappedInfo._sentValue));
1562         }
1563 
1564         _processingP4D = _processingP4D.sub(mappedInfo._sentValue);
1565         delete _oraclizeCallbackMap[_id];
1566     }
1567 
1568     /**
1569      * Should there be any problems with Oraclize such as a callback running out of gas or
1570      * reverting, you are able to refund the P4D you sent to the contract. This will only
1571      * work if the __callback() function has not been successful.
1572      */
1573     function requestRefund(bytes32 _id) external {
1574         OraclizeMap memory mappedInfo = _oraclizeCallbackMap[_id];
1575         address receiver = mappedInfo._sender;
1576         require(msg.sender == receiver);
1577 
1578         uint256 refundable = mappedInfo._sentValue;
1579         _processingP4D = _processingP4D.sub(refundable);
1580         delete _oraclizeCallbackMap[_id];
1581 
1582         require(tokenContract.transfer(receiver, refundable));
1583     }
1584 
1585     /**
1586      * Liquidate your shares to P4D
1587      */
1588     function withdraw(address _user) external onlyCreator {
1589         uint256 withdrawableP4D = getWithdrawableOf(_user);
1590         if (withdrawableP4D > 0) {
1591             if (_user == _dev) {
1592                 _devBalance = 0;
1593             } else if (_user == _owner) {
1594                 _ownerBalance = 0;
1595             } else {
1596                 shares = shares.sub(sharesOf[_user]);
1597                 sharesOf[_user] = 0;
1598                 scalarOf[_user] = 0;
1599                 lastPriceOf[_user] = 0;
1600                 lastPriceTimeOf[_user] = 0;
1601             }
1602 
1603             require(tokenContract.transfer(_user, withdrawableP4D));
1604 
1605         } else if (sharesOf[_user] == 0) { // they are restarting
1606             scalarOf[_user] = 0;
1607             lastPriceOf[_user] = 0;
1608             lastPriceTimeOf[_user] = 0;
1609         }
1610     }
1611 
1612     /**
1613      * Change the UI visibility of the coin-pair
1614      * Although a coin-pair may be hidden, a customer can still interact with it without restrictions
1615      */
1616     function setVisibility(bool _isVisible) external onlyCreator {
1617         isVisible = _isVisible;
1618     }
1619 
1620     /**
1621      * Ability to change the gas price for callbacks in case the network becomes congested
1622      */
1623     function changeOraclizeGasPrice(uint256 _gasPrice) public onlyCreator {
1624         oraclize_setCustomGasPrice(_gasPrice);
1625     }
1626 
1627     /**
1628      * Retrieve the total withdrawable P4D pot
1629      */
1630     function getTotalPot() public view returns (uint256) {
1631         return tokenContract.myTokens().sub(_devBalance).sub(_ownerBalance).sub(_processingP4D.mul(uint256(100).sub(_devOwnerCut)).div(100));
1632     }
1633 
1634     /**
1635      * Retrieve the total withdrawable P4D of an individual customer
1636      */
1637     function getWithdrawableOf(address _user) public view returns (uint256) {
1638         if (_user == _dev) {
1639             return _devBalance;
1640         } else if (_user == _owner) {
1641             return _ownerBalance;
1642         } else {
1643             return (shares == 0 ? 0 : getTotalPot().mul(sharesOf[_user]).div(shares));
1644         }
1645     }
1646 
1647     /**
1648      * Utility function to convert strings into fixed length byte arrays
1649      */
1650     function _stringToBytes32(string memory _s) internal pure returns (bytes32 result) {
1651         bytes memory tmpEmptyStringTest = bytes(_s);
1652         if (tmpEmptyStringTest.length == 0) {
1653             return 0x0;
1654         }
1655         assembly { result := mload(add(_s, 32)) }
1656     }
1657 
1658     /**
1659      * Utility function to make bytes32 data readable
1660      */
1661     function _bytes32ToString(bytes32 _b) internal pure returns (string) {
1662         bytes memory bytesString = new bytes(32);
1663         uint charCount = 0;
1664         for (uint256 i = 0; i < 32; i++) {
1665             byte char = byte(bytes32(uint(_b) * 2 ** (8 * i)));
1666             if (char != 0) {
1667                 bytesString[charCount++] = char;
1668             }
1669         }
1670         bytes memory bytesStringTrimmed = new bytes(charCount);
1671         for (i = 0; i < charCount; i++) {
1672             bytesStringTrimmed[i] = bytesString[i];
1673         }
1674         return string(bytesStringTrimmed);
1675     }
1676 
1677     /**
1678      * Utility function to convert bytes into an integer
1679      */
1680     function _bytesToUint(bytes _b) internal pure returns (uint256 result) {
1681         result = 0;
1682         for (uint i = 0; i < _b.length; i++) {
1683             result += uint(_b[i]) * (2 ** (8 * (_b.length - (i + 1))));
1684         }
1685     }
1686 
1687     /**
1688      * Utility function to check if an address is a contract
1689      */
1690     function _isContract(address _a) internal view returns (bool) {
1691         uint size;
1692         assembly { size := extcodesize(_a) }
1693         return size > 0;
1694     }
1695 
1696     /**
1697      * Payable function for receiving dividends from the P4D and P3D contracts
1698      */   
1699     function () public payable {
1700         require(msg.sender == address(tokenContract) || msg.sender == address(_P3D) || msg.sender == _dev || msg.sender == _owner);
1701         // only accept ETH payments from P4D and P3D (subdividends and dividends) as well
1702         // as allowing the owner or dev to top up this contracts balance
1703         //
1704         // all ETH sent through this function will be used in the tokenCallback() function
1705         // in order to buy more P4D (if there's excess) and pay for Oraclize calls
1706     }
1707 }
1708 
1709 
1710 /**
1711  * This is the core FluxDelta contract, it is primarily a contract factory that
1712  * is able to create any number of coin-pair sub-contracts. On top of this, it is
1713  * also used as an efficient way to return all of the data needed for the front-end.
1714  */
1715 contract FluxDelta is usingP4D {
1716 
1717     using SafeMath for uint256;
1718 
1719     CoinPair[] private _coinPairs;
1720 
1721     address private _owner;
1722 
1723     modifier onlyOwner {
1724         require(msg.sender == _owner);
1725         _;
1726     }
1727 
1728     /**
1729      * Application entry point
1730      */
1731     function FluxDelta(address _P4D_address) public usingP4D(_P4D_address) {
1732         _owner = msg.sender;
1733     }
1734 
1735     /**
1736      * Coin-pair creation function, this function will also allow this newly created pair to receive P4D
1737      * tokens via the setCanAcceptTokens() function. This means that the FluxDetla contract will be
1738      * granted administrator permissions in the P4D contract although this is the only method it uses.
1739      */   
1740     function createCoinPair(string _fromSym, string _toSym, address _ownerAddress) external payable onlyOwner {
1741         CoinPair newCoinPair = (new CoinPair).value(msg.value)(_fromSym, _toSym, _ownerAddress, _owner, address(tokenContract));
1742         _coinPairs.push(newCoinPair);
1743 
1744         tokenContract.setCanAcceptTokens(address(newCoinPair));
1745     }
1746 
1747     /**
1748      * Liquidates your shares to P4D from a certain coin-pair
1749      */
1750     function withdrawFromCoinPair(uint256 _index) external {
1751         require(_index < getTotalCoinPairs());
1752         CoinPair coinPair = _coinPairs[_index];
1753         coinPair.withdraw(msg.sender);
1754     }
1755 
1756     /**
1757      * Ability to toggle the UI visibility of a coin-pair
1758      * This will not prevent a coin-pair from being able to invest or withdraw
1759      */
1760     function setCoinPairVisibility(uint256 _index, bool _isVisible) external onlyOwner {
1761         require(_index < getTotalCoinPairs());
1762         CoinPair coinPair = _coinPairs[_index];
1763         coinPair.setVisibility(_isVisible);
1764     }
1765 
1766     /**
1767      * Ability to change the callback gas price in case the network gets congested
1768      */
1769     function setCoinPairOraclizeGasPrice(uint256 _index, uint256 _gasPrice) public onlyOwner {
1770         require(_index < getTotalCoinPairs());
1771         CoinPair coinPair = _coinPairs[_index];
1772         coinPair.changeOraclizeGasPrice(_gasPrice);
1773     }
1774 
1775     /**
1776      * Utility function to bulk set the callback gas price
1777      */
1778     function setAllOraclizeGasPrices(uint256 _gasPrice) external onlyOwner {
1779         for (uint256 i = 0; i < getTotalCoinPairs(); i++) {
1780             setCoinPairOraclizeGasPrice(i, _gasPrice);
1781         }
1782     }
1783 
1784     /**
1785      * Retreive the total coin-pairs created by FluxDelta
1786      */
1787     function getTotalCoinPairs() public view returns (uint256) {
1788         return _coinPairs.length;
1789     }
1790 
1791     /**
1792      * Retreive the total visible coin-pairs
1793      */
1794     function getTotalVisibleCoinPairs() internal view returns (uint256 count) {
1795         count = 0;
1796         for (uint256 i = 0; i < _coinPairs.length; i++) {
1797             if (_coinPairs[i].isVisible()) {
1798                 count++;
1799             }
1800         }
1801     }
1802 
1803     /**
1804      * Utility function for returning all of the core information of the coin-pairs
1805      */
1806     function getAllCoinPairs(bool _onlyVisible) public view returns (uint256[] indexes, address[] addresses, bytes32[] fromSyms, bytes32[] toSyms, uint256[] totalShares, uint256[] totalPots) {
1807         uint256 length = (_onlyVisible ? getTotalVisibleCoinPairs() : getTotalCoinPairs());
1808 
1809         indexes = new uint256[](length);
1810         addresses = new address[](length);
1811         fromSyms = new bytes32[](length);
1812         toSyms = new bytes32[](length);
1813         totalShares = new uint256[](length);
1814         totalPots = new uint256[](length);
1815 
1816         uint256 index = 0;
1817         for (uint256 i = 0; i < getTotalCoinPairs(); i++) {
1818             CoinPair coinPair = _coinPairs[i];
1819             if (coinPair.isVisible() || !_onlyVisible) {
1820                 indexes[index] = i;
1821                 addresses[index] = address(coinPair);
1822                 fromSyms[index] = coinPair.fSym();
1823                 toSyms[index] = coinPair.tSym();
1824                 totalShares[index] = coinPair.shares();
1825                 totalPots[index] = coinPair.getTotalPot();
1826 
1827                 index++;
1828             }
1829         }
1830     }
1831 
1832     /**
1833      * Utility function for returning all of the shares information of the coin-pairs of a certain user
1834      */
1835     function getAllSharesInfoOf(address _user, bool _onlyVisible) public view returns (uint256[] indexes, uint256[] userShares, uint256[] lastPrices, uint256[] lastPriceTimes, uint256[] withdrawables) {
1836         uint256 length = (_onlyVisible ? getTotalVisibleCoinPairs() : getTotalCoinPairs());
1837 
1838         indexes = new uint256[](length);
1839         userShares = new uint256[](length);
1840         lastPrices = new uint256[](length);
1841         lastPriceTimes = new uint256[](length);
1842         withdrawables = new uint256[](length);
1843 
1844         uint256 index = 0;
1845         for (uint256 i = 0; i < getTotalCoinPairs(); i++) {
1846             CoinPair coinPair = _coinPairs[i];
1847             if (coinPair.isVisible() || !_onlyVisible) {
1848                 indexes[index] = i;
1849                 userShares[index] = coinPair.sharesOf(_user);
1850                 lastPrices[index] = coinPair.lastPriceOf(_user);
1851                 lastPriceTimes[index] = coinPair.lastPriceTimeOf(_user);
1852                 withdrawables[index] = coinPair.getWithdrawableOf(_user);
1853 
1854                 index++;
1855             }
1856         }
1857     }
1858 
1859     /**
1860      * Utility function for returning all of the cost information of the coin-pairs of a certain user
1861      */
1862     function getAllCostsInfoOf(address _user, bool _onlyVisible) public view returns (uint256[] indexes, uint256[] baseCosts, uint256[] myScalars, uint256[] myCosts, bool[] isShorting) {
1863         uint256 length = (_onlyVisible ? getTotalVisibleCoinPairs() : getTotalCoinPairs());
1864 
1865         indexes = new uint256[](length);
1866         baseCosts = new uint256[](length);
1867         myScalars = new uint256[](length);
1868         myCosts = new uint256[](length);
1869         isShorting = new bool[](length);
1870 
1871         uint256 index = 0;
1872         for (uint256 i = 0; i < getTotalCoinPairs(); i++) {
1873             CoinPair coinPair = _coinPairs[i];
1874             if (coinPair.isVisible() || !_onlyVisible) {
1875                 indexes[index] = i;
1876                 baseCosts[index] = coinPair.baseCost();
1877                 myScalars[index] = coinPair.scalarOf(_user);
1878                 myCosts[index] = coinPair.baseCost().mul(coinPair.scalarOf(_user)).div(1e18);
1879                 isShorting[index] = coinPair.isShorting(_user);
1880 
1881                 index++;
1882             }
1883         }
1884     }
1885 
1886     /**
1887      * Because this contract inherits usingP4D it must implement this method
1888      * Returning false will not allow this contract to receive P4D (only child
1889      * coin-pair contracts are allowed to receive P4D)
1890      */
1891     function tokenCallback(address, uint256, bytes) external returns (bool) { return false; }
1892 }
1893 
1894 
1895 /**
1896  * @title SafeMath
1897  * @dev Math operations with safety checks that revert on error
1898  */
1899 library SafeMath {
1900 
1901   /**
1902   * @dev Multiplies two numbers, reverts on overflow.
1903   */
1904   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
1905     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1906     // benefit is lost if 'b' is also tested.
1907     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1908     if (_a == 0) {
1909       return 0;
1910     }
1911 
1912     uint256 c = _a * _b;
1913     require(c / _a == _b);
1914 
1915     return c;
1916   }
1917 
1918   /**
1919   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1920   */
1921   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1922     require(_b > 0); // Solidity only automatically asserts when dividing by 0
1923     uint256 c = _a / _b;
1924     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1925 
1926     return c;
1927   }
1928 
1929   /**
1930   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1931   */
1932   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1933     require(_b <= _a);
1934     uint256 c = _a - _b;
1935 
1936     return c;
1937   }
1938 
1939   /**
1940   * @dev Adds two numbers, reverts on overflow.
1941   */
1942   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
1943     uint256 c = _a + _b;
1944     require(c >= _a);
1945 
1946     return c;
1947   }
1948 
1949   /**
1950   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1951   * reverts when dividing by zero.
1952   */
1953   function mod(uint256 _a, uint256 _b) internal pure returns (uint256) {
1954     require(_b != 0);
1955     return _a % _b;
1956   }
1957 }
1958 
1959 /*===========================================================================================*
1960 *************************************** https://p4d.io ***************************************
1961 *===========================================================================================*/