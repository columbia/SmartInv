1 pragma solidity ^0.4.24;
2 
3 // File: /home/petr/Projects/2018-03-02-million-ether-2/Truffle/future/oraclizeAPI_0.5.sol
4 
5 // <ORACLIZE_API>
6 /*
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 
20 
21 The above copyright notice and this permission notice shall be included in
22 all copies or substantial portions of the Software.
23 
24 
25 
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32 THE SOFTWARE.
33 */
34 
35 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
36 
37 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
38 
39 contract OraclizeI {
40     address public cbAddress;
41     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
42     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
43     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
44     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
45     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
46     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
47     function getPrice(string _datasource) public returns (uint _dsprice);
48     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
49     function setProofType(byte _proofType) external;
50     function setCustomGasPrice(uint _gasPrice) external;
51     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
52 }
53 
54 contract OraclizeAddrResolverI {
55     function getAddress() public returns (address _addr);
56 }
57 
58 /*
59 Begin solidity-cborutils
60 
61 https://github.com/smartcontractkit/solidity-cborutils
62 
63 MIT License
64 
65 Copyright (c) 2018 SmartContract ChainLink, Ltd.
66 
67 Permission is hereby granted, free of charge, to any person obtaining a copy
68 of this software and associated documentation files (the "Software"), to deal
69 in the Software without restriction, including without limitation the rights
70 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
71 copies of the Software, and to permit persons to whom the Software is
72 furnished to do so, subject to the following conditions:
73 
74 The above copyright notice and this permission notice shall be included in all
75 copies or substantial portions of the Software.
76 
77 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
78 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
79 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
80 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
81 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
82 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
83 SOFTWARE.
84  */
85 
86 library Buffer {
87     struct buffer {
88         bytes buf;
89         uint capacity;
90     }
91 
92     function init(buffer memory buf, uint _capacity) internal pure {
93         uint capacity = _capacity;
94         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
95         // Allocate space for the buffer data
96         buf.capacity = capacity;
97         assembly {
98             let ptr := mload(0x40)
99             mstore(buf, ptr)
100             mstore(ptr, 0)
101             mstore(0x40, add(ptr, capacity))
102         }
103     }
104 
105     function resize(buffer memory buf, uint capacity) private pure {
106         bytes memory oldbuf = buf.buf;
107         init(buf, capacity);
108         append(buf, oldbuf);
109     }
110 
111     function max(uint a, uint b) private pure returns(uint) {
112         if(a > b) {
113             return a;
114         }
115         return b;
116     }
117 
118     /**
119      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
120      *      would exceed the capacity of the buffer.
121      * @param buf The buffer to append to.
122      * @param data The data to append.
123      * @return The original buffer.
124      */
125     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
126         if(data.length + buf.buf.length > buf.capacity) {
127             resize(buf, max(buf.capacity, data.length) * 2);
128         }
129 
130         uint dest;
131         uint src;
132         uint len = data.length;
133         assembly {
134             // Memory address of the buffer data
135             let bufptr := mload(buf)
136             // Length of existing buffer data
137             let buflen := mload(bufptr)
138             // Start address = buffer address + buffer length + sizeof(buffer length)
139             dest := add(add(bufptr, buflen), 32)
140             // Update buffer length
141             mstore(bufptr, add(buflen, mload(data)))
142             src := add(data, 32)
143         }
144 
145         // Copy word-length chunks while possible
146         for(; len >= 32; len -= 32) {
147             assembly {
148                 mstore(dest, mload(src))
149             }
150             dest += 32;
151             src += 32;
152         }
153 
154         // Copy remaining bytes
155         uint mask = 256 ** (32 - len) - 1;
156         assembly {
157             let srcpart := and(mload(src), not(mask))
158             let destpart := and(mload(dest), mask)
159             mstore(dest, or(destpart, srcpart))
160         }
161 
162         return buf;
163     }
164 
165     /**
166      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
167      * exceed the capacity of the buffer.
168      * @param buf The buffer to append to.
169      * @param data The data to append.
170      * @return The original buffer.
171      */
172     function append(buffer memory buf, uint8 data) internal pure {
173         if(buf.buf.length + 1 > buf.capacity) {
174             resize(buf, buf.capacity * 2);
175         }
176 
177         assembly {
178             // Memory address of the buffer data
179             let bufptr := mload(buf)
180             // Length of existing buffer data
181             let buflen := mload(bufptr)
182             // Address = buffer address + buffer length + sizeof(buffer length)
183             let dest := add(add(bufptr, buflen), 32)
184             mstore8(dest, data)
185             // Update buffer length
186             mstore(bufptr, add(buflen, 1))
187         }
188     }
189 
190     /**
191      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
192      * exceed the capacity of the buffer.
193      * @param buf The buffer to append to.
194      * @param data The data to append.
195      * @return The original buffer.
196      */
197     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
198         if(len + buf.buf.length > buf.capacity) {
199             resize(buf, max(buf.capacity, len) * 2);
200         }
201 
202         uint mask = 256 ** len - 1;
203         assembly {
204             // Memory address of the buffer data
205             let bufptr := mload(buf)
206             // Length of existing buffer data
207             let buflen := mload(bufptr)
208             // Address = buffer address + buffer length + sizeof(buffer length) + len
209             let dest := add(add(bufptr, buflen), len)
210             mstore(dest, or(and(mload(dest), not(mask)), data))
211             // Update buffer length
212             mstore(bufptr, add(buflen, len))
213         }
214         return buf;
215     }
216 }
217 
218 library CBOR {
219     using Buffer for Buffer.buffer;
220 
221     uint8 private constant MAJOR_TYPE_INT = 0;
222     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
223     uint8 private constant MAJOR_TYPE_BYTES = 2;
224     uint8 private constant MAJOR_TYPE_STRING = 3;
225     uint8 private constant MAJOR_TYPE_ARRAY = 4;
226     uint8 private constant MAJOR_TYPE_MAP = 5;
227     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
228 
229     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
230         if(value <= 23) {
231             buf.append(uint8((major << 5) | value));
232         } else if(value <= 0xFF) {
233             buf.append(uint8((major << 5) | 24));
234             buf.appendInt(value, 1);
235         } else if(value <= 0xFFFF) {
236             buf.append(uint8((major << 5) | 25));
237             buf.appendInt(value, 2);
238         } else if(value <= 0xFFFFFFFF) {
239             buf.append(uint8((major << 5) | 26));
240             buf.appendInt(value, 4);
241         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
242             buf.append(uint8((major << 5) | 27));
243             buf.appendInt(value, 8);
244         }
245     }
246 
247     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
248         buf.append(uint8((major << 5) | 31));
249     }
250 
251     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
252         encodeType(buf, MAJOR_TYPE_INT, value);
253     }
254 
255     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
256         if(value >= 0) {
257             encodeType(buf, MAJOR_TYPE_INT, uint(value));
258         } else {
259             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
260         }
261     }
262 
263     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
264         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
265         buf.append(value);
266     }
267 
268     function encodeString(Buffer.buffer memory buf, string value) internal pure {
269         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
270         buf.append(bytes(value));
271     }
272 
273     function startArray(Buffer.buffer memory buf) internal pure {
274         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
275     }
276 
277     function startMap(Buffer.buffer memory buf) internal pure {
278         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
279     }
280 
281     function endSequence(Buffer.buffer memory buf) internal pure {
282         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
283     }
284 }
285 
286 /*
287 End solidity-cborutils
288  */
289 
290 contract usingOraclize {
291     uint constant day = 60*60*24;
292     uint constant week = 60*60*24*7;
293     uint constant month = 60*60*24*30;
294     byte constant proofType_NONE = 0x00;
295     byte constant proofType_TLSNotary = 0x10;
296     byte constant proofType_Ledger = 0x30;
297     byte constant proofType_Android = 0x40;
298     byte constant proofType_Native = 0xF0;
299     byte constant proofStorage_IPFS = 0x01;
300     uint8 constant networkID_auto = 0;
301     uint8 constant networkID_mainnet = 1;
302     uint8 constant networkID_testnet = 2;
303     uint8 constant networkID_morden = 2;
304     uint8 constant networkID_consensys = 161;
305 
306     OraclizeAddrResolverI OAR;
307 
308     OraclizeI oraclize;
309     modifier oraclizeAPI {
310         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
311             oraclize_setNetwork(networkID_auto);
312 
313         if(address(oraclize) != OAR.getAddress())
314             oraclize = OraclizeI(OAR.getAddress());
315 
316         _;
317     }
318     modifier coupon(string code){
319         oraclize = OraclizeI(OAR.getAddress());
320         _;
321     }
322 
323     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
324       return oraclize_setNetwork();
325       networkID; // silence the warning and remain backwards compatible
326     }
327     function oraclize_setNetwork() internal returns(bool){
328         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
329             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
330             oraclize_setNetworkName("eth_mainnet");
331             return true;
332         }
333         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
334             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
335             oraclize_setNetworkName("eth_ropsten3");
336             return true;
337         }
338         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
339             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
340             oraclize_setNetworkName("eth_kovan");
341             return true;
342         }
343         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
344             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
345             oraclize_setNetworkName("eth_rinkeby");
346             return true;
347         }
348         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
349             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
350             return true;
351         }
352         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
353             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
354             return true;
355         }
356         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
357             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
358             return true;
359         }
360         return false;
361     }
362 
363     function __callback(bytes32 myid, string result) public {
364         __callback(myid, result, new bytes(0));
365     }
366     function __callback(bytes32 myid, string result, bytes proof) public {
367       return;
368       myid; result; proof; // Silence compiler warnings
369     }
370 
371     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
372         return oraclize.getPrice(datasource);
373     }
374 
375     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
376         return oraclize.getPrice(datasource, gaslimit);
377     }
378 
379     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
380         uint price = oraclize.getPrice(datasource);
381         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
382         return oraclize.query.value(price)(0, datasource, arg);
383     }
384     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource);
386         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
387         return oraclize.query.value(price)(timestamp, datasource, arg);
388     }
389     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource, gaslimit);
391         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
392         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
393     }
394     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource, gaslimit);
396         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
397         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
398     }
399     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource);
401         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
402         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
403     }
404     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource);
406         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
407         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
408     }
409     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource, gaslimit);
411         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
412         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
413     }
414     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource, gaslimit);
416         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
417         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
418     }
419     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource);
421         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
422         bytes memory args = stra2cbor(argN);
423         return oraclize.queryN.value(price)(0, datasource, args);
424     }
425     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource);
427         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
428         bytes memory args = stra2cbor(argN);
429         return oraclize.queryN.value(price)(timestamp, datasource, args);
430     }
431     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource, gaslimit);
433         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
434         bytes memory args = stra2cbor(argN);
435         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
436     }
437     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
438         uint price = oraclize.getPrice(datasource, gaslimit);
439         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
440         bytes memory args = stra2cbor(argN);
441         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
442     }
443     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
444         string[] memory dynargs = new string[](1);
445         dynargs[0] = args[0];
446         return oraclize_query(datasource, dynargs);
447     }
448     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
449         string[] memory dynargs = new string[](1);
450         dynargs[0] = args[0];
451         return oraclize_query(timestamp, datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
454         string[] memory dynargs = new string[](1);
455         dynargs[0] = args[0];
456         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
457     }
458     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](1);
460         dynargs[0] = args[0];
461         return oraclize_query(datasource, dynargs, gaslimit);
462     }
463 
464     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](2);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         return oraclize_query(timestamp, datasource, dynargs);
475     }
476     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](2);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
481     }
482     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
483         string[] memory dynargs = new string[](2);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         return oraclize_query(datasource, dynargs, gaslimit);
487     }
488     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](3);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         return oraclize_query(datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](3);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         return oraclize_query(timestamp, datasource, dynargs);
501     }
502     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](3);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
508     }
509     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](3);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         return oraclize_query(datasource, dynargs, gaslimit);
515     }
516 
517     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](4);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         dynargs[3] = args[3];
523         return oraclize_query(datasource, dynargs);
524     }
525     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
526         string[] memory dynargs = new string[](4);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         dynargs[2] = args[2];
530         dynargs[3] = args[3];
531         return oraclize_query(timestamp, datasource, dynargs);
532     }
533     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](4);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         dynargs[2] = args[2];
538         dynargs[3] = args[3];
539         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
540     }
541     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
542         string[] memory dynargs = new string[](4);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         dynargs[3] = args[3];
547         return oraclize_query(datasource, dynargs, gaslimit);
548     }
549     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
550         string[] memory dynargs = new string[](5);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         dynargs[4] = args[4];
556         return oraclize_query(datasource, dynargs);
557     }
558     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](5);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         dynargs[4] = args[4];
565         return oraclize_query(timestamp, datasource, dynargs);
566     }
567     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
568         string[] memory dynargs = new string[](5);
569         dynargs[0] = args[0];
570         dynargs[1] = args[1];
571         dynargs[2] = args[2];
572         dynargs[3] = args[3];
573         dynargs[4] = args[4];
574         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
575     }
576     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
577         string[] memory dynargs = new string[](5);
578         dynargs[0] = args[0];
579         dynargs[1] = args[1];
580         dynargs[2] = args[2];
581         dynargs[3] = args[3];
582         dynargs[4] = args[4];
583         return oraclize_query(datasource, dynargs, gaslimit);
584     }
585     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
586         uint price = oraclize.getPrice(datasource);
587         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
588         bytes memory args = ba2cbor(argN);
589         return oraclize.queryN.value(price)(0, datasource, args);
590     }
591     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
592         uint price = oraclize.getPrice(datasource);
593         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
594         bytes memory args = ba2cbor(argN);
595         return oraclize.queryN.value(price)(timestamp, datasource, args);
596     }
597     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
598         uint price = oraclize.getPrice(datasource, gaslimit);
599         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
600         bytes memory args = ba2cbor(argN);
601         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
602     }
603     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
604         uint price = oraclize.getPrice(datasource, gaslimit);
605         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
606         bytes memory args = ba2cbor(argN);
607         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
608     }
609     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
610         bytes[] memory dynargs = new bytes[](1);
611         dynargs[0] = args[0];
612         return oraclize_query(datasource, dynargs);
613     }
614     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
615         bytes[] memory dynargs = new bytes[](1);
616         dynargs[0] = args[0];
617         return oraclize_query(timestamp, datasource, dynargs);
618     }
619     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
620         bytes[] memory dynargs = new bytes[](1);
621         dynargs[0] = args[0];
622         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
623     }
624     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](1);
626         dynargs[0] = args[0];
627         return oraclize_query(datasource, dynargs, gaslimit);
628     }
629 
630     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](2);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         return oraclize_query(datasource, dynargs);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](2);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         return oraclize_query(timestamp, datasource, dynargs);
641     }
642     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](2);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
647     }
648     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
649         bytes[] memory dynargs = new bytes[](2);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         return oraclize_query(datasource, dynargs, gaslimit);
653     }
654     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](3);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         return oraclize_query(datasource, dynargs);
660     }
661     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](3);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         return oraclize_query(timestamp, datasource, dynargs);
667     }
668     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](3);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         dynargs[2] = args[2];
673         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
674     }
675     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](3);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         dynargs[2] = args[2];
680         return oraclize_query(datasource, dynargs, gaslimit);
681     }
682 
683     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](4);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         dynargs[3] = args[3];
689         return oraclize_query(datasource, dynargs);
690     }
691     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
692         bytes[] memory dynargs = new bytes[](4);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         return oraclize_query(timestamp, datasource, dynargs);
698     }
699     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](4);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         dynargs[3] = args[3];
705         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
706     }
707     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
708         bytes[] memory dynargs = new bytes[](4);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         dynargs[2] = args[2];
712         dynargs[3] = args[3];
713         return oraclize_query(datasource, dynargs, gaslimit);
714     }
715     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
716         bytes[] memory dynargs = new bytes[](5);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         dynargs[4] = args[4];
722         return oraclize_query(datasource, dynargs);
723     }
724     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](5);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         dynargs[3] = args[3];
730         dynargs[4] = args[4];
731         return oraclize_query(timestamp, datasource, dynargs);
732     }
733     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
734         bytes[] memory dynargs = new bytes[](5);
735         dynargs[0] = args[0];
736         dynargs[1] = args[1];
737         dynargs[2] = args[2];
738         dynargs[3] = args[3];
739         dynargs[4] = args[4];
740         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
741     }
742     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
743         bytes[] memory dynargs = new bytes[](5);
744         dynargs[0] = args[0];
745         dynargs[1] = args[1];
746         dynargs[2] = args[2];
747         dynargs[3] = args[3];
748         dynargs[4] = args[4];
749         return oraclize_query(datasource, dynargs, gaslimit);
750     }
751 
752     function oraclize_cbAddress() oraclizeAPI internal returns (address){
753         return oraclize.cbAddress();
754     }
755     function oraclize_setProof(byte proofP) oraclizeAPI internal {
756         return oraclize.setProofType(proofP);
757     }
758     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
759         return oraclize.setCustomGasPrice(gasPrice);
760     }
761 
762     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
763         return oraclize.randomDS_getSessionPubKeyHash();
764     }
765 
766     function getCodeSize(address _addr) constant internal returns(uint _size) {
767         assembly {
768             _size := extcodesize(_addr)
769         }
770     }
771 
772     function parseAddr(string _a) internal pure returns (address){
773         bytes memory tmp = bytes(_a);
774         uint160 iaddr = 0;
775         uint160 b1;
776         uint160 b2;
777         for (uint i=2; i<2+2*20; i+=2){
778             iaddr *= 256;
779             b1 = uint160(tmp[i]);
780             b2 = uint160(tmp[i+1]);
781             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
782             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
783             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
784             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
785             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
786             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
787             iaddr += (b1*16+b2);
788         }
789         return address(iaddr);
790     }
791 
792     function strCompare(string _a, string _b) internal pure returns (int) {
793         bytes memory a = bytes(_a);
794         bytes memory b = bytes(_b);
795         uint minLength = a.length;
796         if (b.length < minLength) minLength = b.length;
797         for (uint i = 0; i < minLength; i ++)
798             if (a[i] < b[i])
799                 return -1;
800             else if (a[i] > b[i])
801                 return 1;
802         if (a.length < b.length)
803             return -1;
804         else if (a.length > b.length)
805             return 1;
806         else
807             return 0;
808     }
809 
810     function indexOf(string _haystack, string _needle) internal pure returns (int) {
811         bytes memory h = bytes(_haystack);
812         bytes memory n = bytes(_needle);
813         if(h.length < 1 || n.length < 1 || (n.length > h.length))
814             return -1;
815         else if(h.length > (2**128 -1))
816             return -1;
817         else
818         {
819             uint subindex = 0;
820             for (uint i = 0; i < h.length; i ++)
821             {
822                 if (h[i] == n[0])
823                 {
824                     subindex = 1;
825                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
826                     {
827                         subindex++;
828                     }
829                     if(subindex == n.length)
830                         return int(i);
831                 }
832             }
833             return -1;
834         }
835     }
836 
837     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
838         bytes memory _ba = bytes(_a);
839         bytes memory _bb = bytes(_b);
840         bytes memory _bc = bytes(_c);
841         bytes memory _bd = bytes(_d);
842         bytes memory _be = bytes(_e);
843         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
844         bytes memory babcde = bytes(abcde);
845         uint k = 0;
846         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
847         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
848         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
849         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
850         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
851         return string(babcde);
852     }
853 
854     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
855         return strConcat(_a, _b, _c, _d, "");
856     }
857 
858     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
859         return strConcat(_a, _b, _c, "", "");
860     }
861 
862     function strConcat(string _a, string _b) internal pure returns (string) {
863         return strConcat(_a, _b, "", "", "");
864     }
865 
866     // parseInt
867     function parseInt(string _a) internal pure returns (uint) {
868         return parseInt(_a, 0);
869     }
870 
871     // parseInt(parseFloat*10^_b)
872     function parseInt(string _a, uint _b) internal pure returns (uint) {
873         bytes memory bresult = bytes(_a);
874         uint mint = 0;
875         bool decimals = false;
876         for (uint i=0; i<bresult.length; i++){
877             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
878                 if (decimals){
879                    if (_b == 0) break;
880                     else _b--;
881                 }
882                 mint *= 10;
883                 mint += uint(bresult[i]) - 48;
884             } else if (bresult[i] == 46) decimals = true;
885         }
886         if (_b > 0) mint *= 10**_b;
887         return mint;
888     }
889 
890     function uint2str(uint i) internal pure returns (string){
891         if (i == 0) return "0";
892         uint j = i;
893         uint len;
894         while (j != 0){
895             len++;
896             j /= 10;
897         }
898         bytes memory bstr = new bytes(len);
899         uint k = len - 1;
900         while (i != 0){
901             bstr[k--] = byte(48 + i % 10);
902             i /= 10;
903         }
904         return string(bstr);
905     }
906 
907     using CBOR for Buffer.buffer;
908     function stra2cbor(string[] arr) internal pure returns (bytes) {
909         safeMemoryCleaner();
910         Buffer.buffer memory buf;
911         Buffer.init(buf, 1024);
912         buf.startArray();
913         for (uint i = 0; i < arr.length; i++) {
914             buf.encodeString(arr[i]);
915         }
916         buf.endSequence();
917         return buf.buf;
918     }
919 
920     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
921         safeMemoryCleaner();
922         Buffer.buffer memory buf;
923         Buffer.init(buf, 1024);
924         buf.startArray();
925         for (uint i = 0; i < arr.length; i++) {
926             buf.encodeBytes(arr[i]);
927         }
928         buf.endSequence();
929         return buf.buf;
930     }
931 
932     string oraclize_network_name;
933     function oraclize_setNetworkName(string _network_name) internal {
934         oraclize_network_name = _network_name;
935     }
936 
937     function oraclize_getNetworkName() internal view returns (string) {
938         return oraclize_network_name;
939     }
940 
941     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
942         require((_nbytes > 0) && (_nbytes <= 32));
943         // Convert from seconds to ledger timer ticks
944         _delay *= 10;
945         bytes memory nbytes = new bytes(1);
946         nbytes[0] = byte(_nbytes);
947         bytes memory unonce = new bytes(32);
948         bytes memory sessionKeyHash = new bytes(32);
949         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
950         assembly {
951             mstore(unonce, 0x20)
952             // the following variables can be relaxed
953             // check relaxed random contract under ethereum-examples repo
954             // for an idea on how to override and replace comit hash vars
955             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
956             mstore(sessionKeyHash, 0x20)
957             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
958         }
959         bytes memory delay = new bytes(32);
960         assembly {
961             mstore(add(delay, 0x20), _delay)
962         }
963 
964         bytes memory delay_bytes8 = new bytes(8);
965         copyBytes(delay, 24, 8, delay_bytes8, 0);
966 
967         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
968         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
969 
970         bytes memory delay_bytes8_left = new bytes(8);
971 
972         assembly {
973             let x := mload(add(delay_bytes8, 0x20))
974             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
978             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
979             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
980             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
981             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
982 
983         }
984 
985         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
986         return queryId;
987     }
988 
989     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
990         oraclize_randomDS_args[queryId] = commitment;
991     }
992 
993     mapping(bytes32=>bytes32) oraclize_randomDS_args;
994     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
995 
996     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
997         bool sigok;
998         address signer;
999 
1000         bytes32 sigr;
1001         bytes32 sigs;
1002 
1003         bytes memory sigr_ = new bytes(32);
1004         uint offset = 4+(uint(dersig[3]) - 0x20);
1005         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1006         bytes memory sigs_ = new bytes(32);
1007         offset += 32 + 2;
1008         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1009 
1010         assembly {
1011             sigr := mload(add(sigr_, 32))
1012             sigs := mload(add(sigs_, 32))
1013         }
1014 
1015 
1016         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1017         if (address(keccak256(pubkey)) == signer) return true;
1018         else {
1019             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1020             return (address(keccak256(pubkey)) == signer);
1021         }
1022     }
1023 
1024     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1025         bool sigok;
1026 
1027         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1028         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1029         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1030 
1031         bytes memory appkey1_pubkey = new bytes(64);
1032         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1033 
1034         bytes memory tosign2 = new bytes(1+65+32);
1035         tosign2[0] = byte(1); //role
1036         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1037         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1038         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1039         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1040 
1041         if (sigok == false) return false;
1042 
1043 
1044         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1045         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1046 
1047         bytes memory tosign3 = new bytes(1+65);
1048         tosign3[0] = 0xFE;
1049         copyBytes(proof, 3, 65, tosign3, 1);
1050 
1051         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1052         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1053 
1054         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1055 
1056         return sigok;
1057     }
1058 
1059     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1060         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1061         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1062 
1063         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1064         require(proofVerified);
1065 
1066         _;
1067     }
1068 
1069     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1070         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1071         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1072 
1073         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1074         if (proofVerified == false) return 2;
1075 
1076         return 0;
1077     }
1078 
1079     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1080         bool match_ = true;
1081 
1082         require(prefix.length == n_random_bytes);
1083 
1084         for (uint256 i=0; i< n_random_bytes; i++) {
1085             if (content[i] != prefix[i]) match_ = false;
1086         }
1087 
1088         return match_;
1089     }
1090 
1091     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1092 
1093         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1094         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1095         bytes memory keyhash = new bytes(32);
1096         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1097         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1098 
1099         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1100         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1101 
1102         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1103         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1104 
1105         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1106         // This is to verify that the computed args match with the ones specified in the query.
1107         bytes memory commitmentSlice1 = new bytes(8+1+32);
1108         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1109 
1110         bytes memory sessionPubkey = new bytes(64);
1111         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1112         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1113 
1114         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1115         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1116             delete oraclize_randomDS_args[queryId];
1117         } else return false;
1118 
1119 
1120         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1121         bytes memory tosign1 = new bytes(32+8+1+32);
1122         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1123         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1124 
1125         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1126         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1127             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1128         }
1129 
1130         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1131     }
1132 
1133     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1134     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1135         uint minLength = length + toOffset;
1136 
1137         // Buffer too small
1138         require(to.length >= minLength); // Should be a better way?
1139 
1140         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1141         uint i = 32 + fromOffset;
1142         uint j = 32 + toOffset;
1143 
1144         while (i < (32 + fromOffset + length)) {
1145             assembly {
1146                 let tmp := mload(add(from, i))
1147                 mstore(add(to, j), tmp)
1148             }
1149             i += 32;
1150             j += 32;
1151         }
1152 
1153         return to;
1154     }
1155 
1156     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1157     // Duplicate Solidity's ecrecover, but catching the CALL return value
1158     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1159         // We do our own memory management here. Solidity uses memory offset
1160         // 0x40 to store the current end of memory. We write past it (as
1161         // writes are memory extensions), but don't update the offset so
1162         // Solidity will reuse it. The memory used here is only needed for
1163         // this context.
1164 
1165         // FIXME: inline assembly can't access return values
1166         bool ret;
1167         address addr;
1168 
1169         assembly {
1170             let size := mload(0x40)
1171             mstore(size, hash)
1172             mstore(add(size, 32), v)
1173             mstore(add(size, 64), r)
1174             mstore(add(size, 96), s)
1175 
1176             // NOTE: we can reuse the request memory because we deal with
1177             //       the return code
1178             ret := call(3000, 1, 0, size, 128, size, 32)
1179             addr := mload(size)
1180         }
1181 
1182         return (ret, addr);
1183     }
1184 
1185     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1186     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1187         bytes32 r;
1188         bytes32 s;
1189         uint8 v;
1190 
1191         if (sig.length != 65)
1192           return (false, 0);
1193 
1194         // The signature format is a compact form of:
1195         //   {bytes32 r}{bytes32 s}{uint8 v}
1196         // Compact means, uint8 is not padded to 32 bytes.
1197         assembly {
1198             r := mload(add(sig, 32))
1199             s := mload(add(sig, 64))
1200 
1201             // Here we are loading the last 32 bytes. We exploit the fact that
1202             // 'mload' will pad with zeroes if we overread.
1203             // There is no 'mload8' to do this, but that would be nicer.
1204             v := byte(0, mload(add(sig, 96)))
1205 
1206             // Alternative solution:
1207             // 'byte' is not working due to the Solidity parser, so lets
1208             // use the second best option, 'and'
1209             // v := and(mload(add(sig, 65)), 255)
1210         }
1211 
1212         // albeit non-transactional signatures are not specified by the YP, one would expect it
1213         // to match the YP range of [27, 28]
1214         //
1215         // geth uses [0, 1] and some clients have followed. This might change, see:
1216         //  https://github.com/ethereum/go-ethereum/issues/2053
1217         if (v < 27)
1218           v += 27;
1219 
1220         if (v != 27 && v != 28)
1221             return (false, 0);
1222 
1223         return safer_ecrecover(hash, v, r, s);
1224     }
1225 
1226     function safeMemoryCleaner() internal pure {
1227         assembly {
1228             let fmem := mload(0x40)
1229             codecopy(fmem, codesize, sub(msize, fmem))
1230         }
1231     }
1232 
1233 }
1234 // </ORACLIZE_API>
1235 
1236 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
1237 
1238 /**
1239  * @title SafeMath
1240  * @dev Math operations with safety checks that throw on error
1241  */
1242 library SafeMath {
1243 
1244   /**
1245   * @dev Multiplies two numbers, throws on overflow.
1246   */
1247   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1248     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1249     // benefit is lost if 'b' is also tested.
1250     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1251     if (_a == 0) {
1252       return 0;
1253     }
1254 
1255     c = _a * _b;
1256     assert(c / _a == _b);
1257     return c;
1258   }
1259 
1260   /**
1261   * @dev Integer division of two numbers, truncating the quotient.
1262   */
1263   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1264     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1265     // uint256 c = _a / _b;
1266     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1267     return _a / _b;
1268   }
1269 
1270   /**
1271   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1272   */
1273   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1274     assert(_b <= _a);
1275     return _a - _b;
1276   }
1277 
1278   /**
1279   * @dev Adds two numbers, throws on overflow.
1280   */
1281   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1282     c = _a + _b;
1283     assert(c >= _a);
1284     return c;
1285   }
1286 }
1287 
1288 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
1289 
1290 /**
1291  * @title Ownable
1292  * @dev The Ownable contract has an owner address, and provides basic authorization control
1293  * functions, this simplifies the implementation of "user permissions".
1294  */
1295 contract Ownable {
1296   address public owner;
1297 
1298 
1299   event OwnershipRenounced(address indexed previousOwner);
1300   event OwnershipTransferred(
1301     address indexed previousOwner,
1302     address indexed newOwner
1303   );
1304 
1305 
1306   /**
1307    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1308    * account.
1309    */
1310   constructor() public {
1311     owner = msg.sender;
1312   }
1313 
1314   /**
1315    * @dev Throws if called by any account other than the owner.
1316    */
1317   modifier onlyOwner() {
1318     require(msg.sender == owner);
1319     _;
1320   }
1321 
1322   /**
1323    * @dev Allows the current owner to relinquish control of the contract.
1324    * @notice Renouncing to ownership will leave the contract without an owner.
1325    * It will not be possible to call the functions with the `onlyOwner`
1326    * modifier anymore.
1327    */
1328   function renounceOwnership() public onlyOwner {
1329     emit OwnershipRenounced(owner);
1330     owner = address(0);
1331   }
1332 
1333   /**
1334    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1335    * @param _newOwner The address to transfer ownership to.
1336    */
1337   function transferOwnership(address _newOwner) public onlyOwner {
1338     _transferOwnership(_newOwner);
1339   }
1340 
1341   /**
1342    * @dev Transfers control of the contract to a newOwner.
1343    * @param _newOwner The address to transfer ownership to.
1344    */
1345   function _transferOwnership(address _newOwner) internal {
1346     require(_newOwner != address(0));
1347     emit OwnershipTransferred(owner, _newOwner);
1348     owner = _newOwner;
1349   }
1350 }
1351 
1352 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Destructible.sol
1353 
1354 /**
1355  * @title Destructible
1356  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
1357  */
1358 contract Destructible is Ownable {
1359   /**
1360    * @dev Transfers the current balance to the owner and terminates the contract.
1361    */
1362   function destroy() public onlyOwner {
1363     selfdestruct(owner);
1364   }
1365 
1366   function destroyAndSend(address _recipient) public onlyOwner {
1367     selfdestruct(_recipient);
1368   }
1369 }
1370 
1371 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1372 
1373 /**
1374  * @title Pausable
1375  * @dev Base contract which allows children to implement an emergency stop mechanism.
1376  */
1377 contract Pausable is Ownable {
1378   event Pause();
1379   event Unpause();
1380 
1381   bool public paused = false;
1382 
1383 
1384   /**
1385    * @dev Modifier to make a function callable only when the contract is not paused.
1386    */
1387   modifier whenNotPaused() {
1388     require(!paused);
1389     _;
1390   }
1391 
1392   /**
1393    * @dev Modifier to make a function callable only when the contract is paused.
1394    */
1395   modifier whenPaused() {
1396     require(paused);
1397     _;
1398   }
1399 
1400   /**
1401    * @dev called by the owner to pause, triggers stopped state
1402    */
1403   function pause() public onlyOwner whenNotPaused {
1404     paused = true;
1405     emit Pause();
1406   }
1407 
1408   /**
1409    * @dev called by the owner to unpause, returns to normal state
1410    */
1411   function unpause() public onlyOwner whenPaused {
1412     paused = false;
1413     emit Unpause();
1414   }
1415 }
1416 
1417 // File: node_modules/openzeppelin-solidity/contracts/OracleProxy.sol
1418 
1419 // import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
1420 // import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/lifecycle/Destructible.sol";
1421 // import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
1422 // import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
1423 // import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol ";
1424 
1425 
1426 
1427 
1428 
1429 
1430 contract OracleProxy is Ownable, Destructible, Pausable, usingOraclize {
1431     using SafeMath for uint256;
1432     // cofirm it's the right Oracle proxy
1433     bool public isOracleProxy = true;
1434 
1435     // stores ETHUSD price (one cent in wei)
1436     uint public oneCentInWei;
1437 
1438     // Oracalize default callback gas limit is 200000. More accurate estimate saves money.
1439     uint public callbackGasLimit;
1440 
1441     // Default REQUEST URL string (according to Oracalize API)
1442     string public REQUEST_URL;
1443     
1444     // Mapping to keep track of valid requests to Oracalize
1445     mapping(bytes32=>bool) validIds;
1446     
1447     // Oracalize querry-response events
1448     event LogResponseReceived(bytes32 id, string price);
1449     event LogOraclizeQuery(bytes32 queryId, uint gasPriceInWei, string description);
1450     
1451     // events to fire when admin changes settings
1452     event LogNewRequestURL(string newURL);
1453     event LogNewCallbackGasLimit(uint callbackGasLimit);
1454 
1455     constructor() public {
1456         REQUEST_URL = "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.p.1";
1457         callbackGasLimit = 99159; // 99159;  // 99159 - my estimation, 36364, 36062 - actual Oracalize response at Rinkeby
1458         oneCentInWei = 10 wei; // 24331000000000; // 1 cent in wei (1 eth = $410)
1459     }
1460     
1461     function __callback(bytes32 myid, string result) public whenNotPaused {
1462         require(validIds[myid]);
1463         require(msg.sender == oraclize_cbAddress());
1464 
1465         emit LogResponseReceived(myid, result);
1466         
1467         // parseInt handles zero length result string and returns 0
1468         uint oneEthInCents = parseInt(result, 2);
1469         require(oneEthInCents > 0);
1470         
1471         oneCentInWei = 1 ether / oneEthInCents;
1472         assert(oneCentInWei > 0);
1473         
1474         delete validIds[myid];
1475     }
1476 
1477     /// @notice calculates the ammount of ether to send with updatePrice
1478     function getQueryPrice(uint EthInCents, uint gasPriceInWei) public view returns (uint) {
1479         uint256 oneEth = 1 ether;  // dedicated var to apply SafeMath's div function
1480         uint256 oracalizeFee = oneEth.div(EthInCents).div(98); // 1 cent + 2% (safety margin)
1481         uint256 gasCost = callbackGasLimit.mul(gasPriceInWei);
1482         return oracalizeFee + gasCost;
1483     }
1484 
1485     /// @dev function is public in order to allow hot wallet
1486     /// @notice Will not check the right ammount of money. Will consume all ether sent!
1487     function updatePrice(uint gasPriceInWei) public payable whenNotPaused {
1488 
1489         if (gasPriceInWei > 0) {
1490             oraclize_setCustomGasPrice(gasPriceInWei);
1491         }
1492         
1493         if (oraclize_getPrice("URL") > address(this).balance) {
1494 
1495             emit LogOraclizeQuery(
1496                 "", 
1497                 gasPriceInWei, 
1498                 "Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1499 
1500         } else {
1501 
1502             bytes32 queryId = oraclize_query(0, "URL", REQUEST_URL, callbackGasLimit);
1503             validIds[queryId] = true;
1504             emit LogOraclizeQuery(
1505                 queryId,
1506                 gasPriceInWei, 
1507                 "Oraclize query was sent, standing by for the answer...");
1508         }
1509     }
1510 
1511     // fine-tune callback gas limit
1512     function setCallbackGasLimit(uint newCallbackGasLimit) external onlyOwner {
1513         require(newCallbackGasLimit >0);
1514         callbackGasLimit = newCallbackGasLimit;
1515         emit LogNewCallbackGasLimit(newCallbackGasLimit);
1516     }
1517     
1518     // set new request URL according to Oracalize API
1519     function setRequestURL(string newRequestURL) external onlyOwner {
1520         REQUEST_URL = newRequestURL;
1521         emit LogNewRequestURL(newRequestURL);
1522     }
1523 
1524     /// sends excess contract balance to contract owner
1525     function withdrawExcess() external {
1526         uint payment = address(this).balance;
1527         require(payment > 0);
1528         owner.transfer(payment);
1529     }
1530 }