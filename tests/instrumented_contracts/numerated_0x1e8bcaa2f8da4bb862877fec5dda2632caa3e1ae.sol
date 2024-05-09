1 pragma solidity 0.4.24;
2 
3 // File: installed_contracts/oraclize/contracts/usingOraclize.sol
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
1236 // File: installed_contracts/stringutils/strings.sol
1237 
1238 /*
1239  * @title String & slice utility library for Solidity contracts.
1240  * @author Nick Johnson <arachnid@notdot.net>
1241  *
1242  * @dev Functionality in this library is largely implemented using an
1243  *      abstraction called a 'slice'. A slice represents a part of a string -
1244  *      anything from the entire string to a single character, or even no
1245  *      characters at all (a 0-length slice). Since a slice only has to specify
1246  *      an offset and a length, copying and manipulating slices is a lot less
1247  *      expensive than copying and manipulating the strings they reference.
1248  *
1249  *      To further reduce gas costs, most functions on slice that need to return
1250  *      a slice modify the original one instead of allocating a new one; for
1251  *      instance, `s.split(".")` will return the text up to the first '.',
1252  *      modifying s to only contain the remainder of the string after the '.'.
1253  *      In situations where you do not want to modify the original slice, you
1254  *      can make a copy first with `.copy()`, for example:
1255  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1256  *      Solidity has no memory management, it will result in allocating many
1257  *      short-lived slices that are later discarded.
1258  *
1259  *      Functions that return two slices come in two versions: a non-allocating
1260  *      version that takes the second slice as an argument, modifying it in
1261  *      place, and an allocating version that allocates and returns the second
1262  *      slice; see `nextRune` for example.
1263  *
1264  *      Functions that have to copy string data will return strings rather than
1265  *      slices; these can be cast back to slices for further processing if
1266  *      required.
1267  *
1268  *      For convenience, some functions are provided with non-modifying
1269  *      variants that create a new slice and return both; for instance,
1270  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1271  *      corresponding to the left and right parts of the string.
1272  */
1273 
1274 pragma solidity ^0.4.14;
1275 
1276 library strings {
1277     struct slice {
1278         uint _len;
1279         uint _ptr;
1280     }
1281 
1282     function memcpy(uint dest, uint src, uint len) private pure {
1283         // Copy word-length chunks while possible
1284         for(; len >= 32; len -= 32) {
1285             assembly {
1286                 mstore(dest, mload(src))
1287             }
1288             dest += 32;
1289             src += 32;
1290         }
1291 
1292         // Copy remaining bytes
1293         uint mask = 256 ** (32 - len) - 1;
1294         assembly {
1295             let srcpart := and(mload(src), not(mask))
1296             let destpart := and(mload(dest), mask)
1297             mstore(dest, or(destpart, srcpart))
1298         }
1299     }
1300 
1301     /*
1302      * @dev Returns a slice containing the entire string.
1303      * @param self The string to make a slice from.
1304      * @return A newly allocated slice containing the entire string.
1305      */
1306     function toSlice(string memory self) internal pure returns (slice memory) {
1307         uint ptr;
1308         assembly {
1309             ptr := add(self, 0x20)
1310         }
1311         return slice(bytes(self).length, ptr);
1312     }
1313 
1314     /*
1315      * @dev Returns the length of a null-terminated bytes32 string.
1316      * @param self The value to find the length of.
1317      * @return The length of the string, from 0 to 32.
1318      */
1319     function len(bytes32 self) internal pure returns (uint) {
1320         uint ret;
1321         if (self == 0)
1322             return 0;
1323         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1324             ret += 16;
1325             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1326         }
1327         if (self & 0xffffffffffffffff == 0) {
1328             ret += 8;
1329             self = bytes32(uint(self) / 0x10000000000000000);
1330         }
1331         if (self & 0xffffffff == 0) {
1332             ret += 4;
1333             self = bytes32(uint(self) / 0x100000000);
1334         }
1335         if (self & 0xffff == 0) {
1336             ret += 2;
1337             self = bytes32(uint(self) / 0x10000);
1338         }
1339         if (self & 0xff == 0) {
1340             ret += 1;
1341         }
1342         return 32 - ret;
1343     }
1344 
1345     /*
1346      * @dev Returns a slice containing the entire bytes32, interpreted as a
1347      *      null-terminated utf-8 string.
1348      * @param self The bytes32 value to convert to a slice.
1349      * @return A new slice containing the value of the input argument up to the
1350      *         first null.
1351      */
1352     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1353         // Allocate space for `self` in memory, copy it there, and point ret at it
1354         assembly {
1355             let ptr := mload(0x40)
1356             mstore(0x40, add(ptr, 0x20))
1357             mstore(ptr, self)
1358             mstore(add(ret, 0x20), ptr)
1359         }
1360         ret._len = len(self);
1361     }
1362 
1363     /*
1364      * @dev Returns a new slice containing the same data as the current slice.
1365      * @param self The slice to copy.
1366      * @return A new slice containing the same data as `self`.
1367      */
1368     function copy(slice memory self) internal pure returns (slice memory) {
1369         return slice(self._len, self._ptr);
1370     }
1371 
1372     /*
1373      * @dev Copies a slice to a new string.
1374      * @param self The slice to copy.
1375      * @return A newly allocated string containing the slice's text.
1376      */
1377     function toString(slice memory self) internal pure returns (string memory) {
1378         string memory ret = new string(self._len);
1379         uint retptr;
1380         assembly { retptr := add(ret, 32) }
1381 
1382         memcpy(retptr, self._ptr, self._len);
1383         return ret;
1384     }
1385 
1386     /*
1387      * @dev Returns the length in runes of the slice. Note that this operation
1388      *      takes time proportional to the length of the slice; avoid using it
1389      *      in loops, and call `slice.empty()` if you only need to know whether
1390      *      the slice is empty or not.
1391      * @param self The slice to operate on.
1392      * @return The length of the slice in runes.
1393      */
1394     function len(slice memory self) internal pure returns (uint l) {
1395         // Starting at ptr-31 means the LSB will be the byte we care about
1396         uint ptr = self._ptr - 31;
1397         uint end = ptr + self._len;
1398         for (l = 0; ptr < end; l++) {
1399             uint8 b;
1400             assembly { b := and(mload(ptr), 0xFF) }
1401             if (b < 0x80) {
1402                 ptr += 1;
1403             } else if(b < 0xE0) {
1404                 ptr += 2;
1405             } else if(b < 0xF0) {
1406                 ptr += 3;
1407             } else if(b < 0xF8) {
1408                 ptr += 4;
1409             } else if(b < 0xFC) {
1410                 ptr += 5;
1411             } else {
1412                 ptr += 6;
1413             }
1414         }
1415     }
1416 
1417     /*
1418      * @dev Returns true if the slice is empty (has a length of 0).
1419      * @param self The slice to operate on.
1420      * @return True if the slice is empty, False otherwise.
1421      */
1422     function empty(slice memory self) internal pure returns (bool) {
1423         return self._len == 0;
1424     }
1425 
1426     /*
1427      * @dev Returns a positive number if `other` comes lexicographically after
1428      *      `self`, a negative number if it comes before, or zero if the
1429      *      contents of the two slices are equal. Comparison is done per-rune,
1430      *      on unicode codepoints.
1431      * @param self The first slice to compare.
1432      * @param other The second slice to compare.
1433      * @return The result of the comparison.
1434      */
1435     function compare(slice memory self, slice memory other) internal pure returns (int) {
1436         uint shortest = self._len;
1437         if (other._len < self._len)
1438             shortest = other._len;
1439 
1440         uint selfptr = self._ptr;
1441         uint otherptr = other._ptr;
1442         for (uint idx = 0; idx < shortest; idx += 32) {
1443             uint a;
1444             uint b;
1445             assembly {
1446                 a := mload(selfptr)
1447                 b := mload(otherptr)
1448             }
1449             if (a != b) {
1450                 // Mask out irrelevant bytes and check again
1451                 uint256 mask = uint256(-1); // 0xffff...
1452                 if(shortest < 32) {
1453                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1454                 }
1455                 uint256 diff = (a & mask) - (b & mask);
1456                 if (diff != 0)
1457                     return int(diff);
1458             }
1459             selfptr += 32;
1460             otherptr += 32;
1461         }
1462         return int(self._len) - int(other._len);
1463     }
1464 
1465     /*
1466      * @dev Returns true if the two slices contain the same text.
1467      * @param self The first slice to compare.
1468      * @param self The second slice to compare.
1469      * @return True if the slices are equal, false otherwise.
1470      */
1471     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1472         return compare(self, other) == 0;
1473     }
1474 
1475     /*
1476      * @dev Extracts the first rune in the slice into `rune`, advancing the
1477      *      slice to point to the next rune and returning `self`.
1478      * @param self The slice to operate on.
1479      * @param rune The slice that will contain the first rune.
1480      * @return `rune`.
1481      */
1482     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1483         rune._ptr = self._ptr;
1484 
1485         if (self._len == 0) {
1486             rune._len = 0;
1487             return rune;
1488         }
1489 
1490         uint l;
1491         uint b;
1492         // Load the first byte of the rune into the LSBs of b
1493         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1494         if (b < 0x80) {
1495             l = 1;
1496         } else if(b < 0xE0) {
1497             l = 2;
1498         } else if(b < 0xF0) {
1499             l = 3;
1500         } else {
1501             l = 4;
1502         }
1503 
1504         // Check for truncated codepoints
1505         if (l > self._len) {
1506             rune._len = self._len;
1507             self._ptr += self._len;
1508             self._len = 0;
1509             return rune;
1510         }
1511 
1512         self._ptr += l;
1513         self._len -= l;
1514         rune._len = l;
1515         return rune;
1516     }
1517 
1518     /*
1519      * @dev Returns the first rune in the slice, advancing the slice to point
1520      *      to the next rune.
1521      * @param self The slice to operate on.
1522      * @return A slice containing only the first rune from `self`.
1523      */
1524     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1525         nextRune(self, ret);
1526     }
1527 
1528     /*
1529      * @dev Returns the number of the first codepoint in the slice.
1530      * @param self The slice to operate on.
1531      * @return The number of the first codepoint in the slice.
1532      */
1533     function ord(slice memory self) internal pure returns (uint ret) {
1534         if (self._len == 0) {
1535             return 0;
1536         }
1537 
1538         uint word;
1539         uint length;
1540         uint divisor = 2 ** 248;
1541 
1542         // Load the rune into the MSBs of b
1543         assembly { word:= mload(mload(add(self, 32))) }
1544         uint b = word / divisor;
1545         if (b < 0x80) {
1546             ret = b;
1547             length = 1;
1548         } else if(b < 0xE0) {
1549             ret = b & 0x1F;
1550             length = 2;
1551         } else if(b < 0xF0) {
1552             ret = b & 0x0F;
1553             length = 3;
1554         } else {
1555             ret = b & 0x07;
1556             length = 4;
1557         }
1558 
1559         // Check for truncated codepoints
1560         if (length > self._len) {
1561             return 0;
1562         }
1563 
1564         for (uint i = 1; i < length; i++) {
1565             divisor = divisor / 256;
1566             b = (word / divisor) & 0xFF;
1567             if (b & 0xC0 != 0x80) {
1568                 // Invalid UTF-8 sequence
1569                 return 0;
1570             }
1571             ret = (ret * 64) | (b & 0x3F);
1572         }
1573 
1574         return ret;
1575     }
1576 
1577     /*
1578      * @dev Returns the keccak-256 hash of the slice.
1579      * @param self The slice to hash.
1580      * @return The hash of the slice.
1581      */
1582     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1583         assembly {
1584             ret := keccak256(mload(add(self, 32)), mload(self))
1585         }
1586     }
1587 
1588     /*
1589      * @dev Returns true if `self` starts with `needle`.
1590      * @param self The slice to operate on.
1591      * @param needle The slice to search for.
1592      * @return True if the slice starts with the provided text, false otherwise.
1593      */
1594     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1595         if (self._len < needle._len) {
1596             return false;
1597         }
1598 
1599         if (self._ptr == needle._ptr) {
1600             return true;
1601         }
1602 
1603         bool equal;
1604         assembly {
1605             let length := mload(needle)
1606             let selfptr := mload(add(self, 0x20))
1607             let needleptr := mload(add(needle, 0x20))
1608             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1609         }
1610         return equal;
1611     }
1612 
1613     /*
1614      * @dev If `self` starts with `needle`, `needle` is removed from the
1615      *      beginning of `self`. Otherwise, `self` is unmodified.
1616      * @param self The slice to operate on.
1617      * @param needle The slice to search for.
1618      * @return `self`
1619      */
1620     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1621         if (self._len < needle._len) {
1622             return self;
1623         }
1624 
1625         bool equal = true;
1626         if (self._ptr != needle._ptr) {
1627             assembly {
1628                 let length := mload(needle)
1629                 let selfptr := mload(add(self, 0x20))
1630                 let needleptr := mload(add(needle, 0x20))
1631                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1632             }
1633         }
1634 
1635         if (equal) {
1636             self._len -= needle._len;
1637             self._ptr += needle._len;
1638         }
1639 
1640         return self;
1641     }
1642 
1643     /*
1644      * @dev Returns true if the slice ends with `needle`.
1645      * @param self The slice to operate on.
1646      * @param needle The slice to search for.
1647      * @return True if the slice starts with the provided text, false otherwise.
1648      */
1649     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1650         if (self._len < needle._len) {
1651             return false;
1652         }
1653 
1654         uint selfptr = self._ptr + self._len - needle._len;
1655 
1656         if (selfptr == needle._ptr) {
1657             return true;
1658         }
1659 
1660         bool equal;
1661         assembly {
1662             let length := mload(needle)
1663             let needleptr := mload(add(needle, 0x20))
1664             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1665         }
1666 
1667         return equal;
1668     }
1669 
1670     /*
1671      * @dev If `self` ends with `needle`, `needle` is removed from the
1672      *      end of `self`. Otherwise, `self` is unmodified.
1673      * @param self The slice to operate on.
1674      * @param needle The slice to search for.
1675      * @return `self`
1676      */
1677     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1678         if (self._len < needle._len) {
1679             return self;
1680         }
1681 
1682         uint selfptr = self._ptr + self._len - needle._len;
1683         bool equal = true;
1684         if (selfptr != needle._ptr) {
1685             assembly {
1686                 let length := mload(needle)
1687                 let needleptr := mload(add(needle, 0x20))
1688                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1689             }
1690         }
1691 
1692         if (equal) {
1693             self._len -= needle._len;
1694         }
1695 
1696         return self;
1697     }
1698 
1699     // Returns the memory address of the first byte of the first occurrence of
1700     // `needle` in `self`, or the first byte after `self` if not found.
1701     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1702         uint ptr = selfptr;
1703         uint idx;
1704 
1705         if (needlelen <= selflen) {
1706             if (needlelen <= 32) {
1707                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1708 
1709                 bytes32 needledata;
1710                 assembly { needledata := and(mload(needleptr), mask) }
1711 
1712                 uint end = selfptr + selflen - needlelen;
1713                 bytes32 ptrdata;
1714                 assembly { ptrdata := and(mload(ptr), mask) }
1715 
1716                 while (ptrdata != needledata) {
1717                     if (ptr >= end)
1718                         return selfptr + selflen;
1719                     ptr++;
1720                     assembly { ptrdata := and(mload(ptr), mask) }
1721                 }
1722                 return ptr;
1723             } else {
1724                 // For long needles, use hashing
1725                 bytes32 hash;
1726                 assembly { hash := keccak256(needleptr, needlelen) }
1727 
1728                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1729                     bytes32 testHash;
1730                     assembly { testHash := keccak256(ptr, needlelen) }
1731                     if (hash == testHash)
1732                         return ptr;
1733                     ptr += 1;
1734                 }
1735             }
1736         }
1737         return selfptr + selflen;
1738     }
1739 
1740     // Returns the memory address of the first byte after the last occurrence of
1741     // `needle` in `self`, or the address of `self` if not found.
1742     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1743         uint ptr;
1744 
1745         if (needlelen <= selflen) {
1746             if (needlelen <= 32) {
1747                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1748 
1749                 bytes32 needledata;
1750                 assembly { needledata := and(mload(needleptr), mask) }
1751 
1752                 ptr = selfptr + selflen - needlelen;
1753                 bytes32 ptrdata;
1754                 assembly { ptrdata := and(mload(ptr), mask) }
1755 
1756                 while (ptrdata != needledata) {
1757                     if (ptr <= selfptr)
1758                         return selfptr;
1759                     ptr--;
1760                     assembly { ptrdata := and(mload(ptr), mask) }
1761                 }
1762                 return ptr + needlelen;
1763             } else {
1764                 // For long needles, use hashing
1765                 bytes32 hash;
1766                 assembly { hash := keccak256(needleptr, needlelen) }
1767                 ptr = selfptr + (selflen - needlelen);
1768                 while (ptr >= selfptr) {
1769                     bytes32 testHash;
1770                     assembly { testHash := keccak256(ptr, needlelen) }
1771                     if (hash == testHash)
1772                         return ptr + needlelen;
1773                     ptr -= 1;
1774                 }
1775             }
1776         }
1777         return selfptr;
1778     }
1779 
1780     /*
1781      * @dev Modifies `self` to contain everything from the first occurrence of
1782      *      `needle` to the end of the slice. `self` is set to the empty slice
1783      *      if `needle` is not found.
1784      * @param self The slice to search and modify.
1785      * @param needle The text to search for.
1786      * @return `self`.
1787      */
1788     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1789         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1790         self._len -= ptr - self._ptr;
1791         self._ptr = ptr;
1792         return self;
1793     }
1794 
1795     /*
1796      * @dev Modifies `self` to contain the part of the string from the start of
1797      *      `self` to the end of the first occurrence of `needle`. If `needle`
1798      *      is not found, `self` is set to the empty slice.
1799      * @param self The slice to search and modify.
1800      * @param needle The text to search for.
1801      * @return `self`.
1802      */
1803     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1804         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1805         self._len = ptr - self._ptr;
1806         return self;
1807     }
1808 
1809     /*
1810      * @dev Splits the slice, setting `self` to everything after the first
1811      *      occurrence of `needle`, and `token` to everything before it. If
1812      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1813      *      and `token` is set to the entirety of `self`.
1814      * @param self The slice to split.
1815      * @param needle The text to search for in `self`.
1816      * @param token An output parameter to which the first token is written.
1817      * @return `token`.
1818      */
1819     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1820         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1821         token._ptr = self._ptr;
1822         token._len = ptr - self._ptr;
1823         if (ptr == self._ptr + self._len) {
1824             // Not found
1825             self._len = 0;
1826         } else {
1827             self._len -= token._len + needle._len;
1828             self._ptr = ptr + needle._len;
1829         }
1830         return token;
1831     }
1832 
1833     /*
1834      * @dev Splits the slice, setting `self` to everything after the first
1835      *      occurrence of `needle`, and returning everything before it. If
1836      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1837      *      and the entirety of `self` is returned.
1838      * @param self The slice to split.
1839      * @param needle The text to search for in `self`.
1840      * @return The part of `self` up to the first occurrence of `delim`.
1841      */
1842     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1843         split(self, needle, token);
1844     }
1845 
1846     /*
1847      * @dev Splits the slice, setting `self` to everything before the last
1848      *      occurrence of `needle`, and `token` to everything after it. If
1849      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1850      *      and `token` is set to the entirety of `self`.
1851      * @param self The slice to split.
1852      * @param needle The text to search for in `self`.
1853      * @param token An output parameter to which the first token is written.
1854      * @return `token`.
1855      */
1856     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1857         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1858         token._ptr = ptr;
1859         token._len = self._len - (ptr - self._ptr);
1860         if (ptr == self._ptr) {
1861             // Not found
1862             self._len = 0;
1863         } else {
1864             self._len -= token._len + needle._len;
1865         }
1866         return token;
1867     }
1868 
1869     /*
1870      * @dev Splits the slice, setting `self` to everything before the last
1871      *      occurrence of `needle`, and returning everything after it. If
1872      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1873      *      and the entirety of `self` is returned.
1874      * @param self The slice to split.
1875      * @param needle The text to search for in `self`.
1876      * @return The part of `self` after the last occurrence of `delim`.
1877      */
1878     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1879         rsplit(self, needle, token);
1880     }
1881 
1882     /*
1883      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1884      * @param self The slice to search.
1885      * @param needle The text to search for in `self`.
1886      * @return The number of occurrences of `needle` found in `self`.
1887      */
1888     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1889         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1890         while (ptr <= self._ptr + self._len) {
1891             cnt++;
1892             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1893         }
1894     }
1895 
1896     /*
1897      * @dev Returns True if `self` contains `needle`.
1898      * @param self The slice to search.
1899      * @param needle The text to search for in `self`.
1900      * @return True if `needle` is found in `self`, false otherwise.
1901      */
1902     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1903         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1904     }
1905 
1906     /*
1907      * @dev Returns a newly allocated string containing the concatenation of
1908      *      `self` and `other`.
1909      * @param self The first slice to concatenate.
1910      * @param other The second slice to concatenate.
1911      * @return The concatenation of the two strings.
1912      */
1913     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1914         string memory ret = new string(self._len + other._len);
1915         uint retptr;
1916         assembly { retptr := add(ret, 32) }
1917         memcpy(retptr, self._ptr, self._len);
1918         memcpy(retptr + self._len, other._ptr, other._len);
1919         return ret;
1920     }
1921 
1922     /*
1923      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1924      *      newly allocated string.
1925      * @param self The delimiter to use.
1926      * @param parts A list of slices to join.
1927      * @return A newly allocated string containing all the slices in `parts`,
1928      *         joined with `self`.
1929      */
1930     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1931         if (parts.length == 0)
1932             return "";
1933 
1934         uint length = self._len * (parts.length - 1);
1935         for(uint i = 0; i < parts.length; i++)
1936             length += parts[i]._len;
1937 
1938         string memory ret = new string(length);
1939         uint retptr;
1940         assembly { retptr := add(ret, 32) }
1941 
1942         for(i = 0; i < parts.length; i++) {
1943             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1944             retptr += parts[i]._len;
1945             if (i < parts.length - 1) {
1946                 memcpy(retptr, self._ptr, self._len);
1947                 retptr += self._len;
1948             }
1949         }
1950 
1951         return ret;
1952     }
1953 }
1954 
1955 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
1956 
1957 /**
1958  * @title Ownable
1959  * @dev The Ownable contract has an owner address, and provides basic authorization control
1960  * functions, this simplifies the implementation of "user permissions".
1961  */
1962 contract Ownable {
1963   address public owner;
1964 
1965 
1966   event OwnershipRenounced(address indexed previousOwner);
1967   event OwnershipTransferred(
1968     address indexed previousOwner,
1969     address indexed newOwner
1970   );
1971 
1972 
1973   /**
1974    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1975    * account.
1976    */
1977   constructor() public {
1978     owner = msg.sender;
1979   }
1980 
1981   /**
1982    * @dev Throws if called by any account other than the owner.
1983    */
1984   modifier onlyOwner() {
1985     require(msg.sender == owner);
1986     _;
1987   }
1988 
1989   /**
1990    * @dev Allows the current owner to relinquish control of the contract.
1991    * @notice Renouncing to ownership will leave the contract without an owner.
1992    * It will not be possible to call the functions with the `onlyOwner`
1993    * modifier anymore.
1994    */
1995   function renounceOwnership() public onlyOwner {
1996     emit OwnershipRenounced(owner);
1997     owner = address(0);
1998   }
1999 
2000   /**
2001    * @dev Allows the current owner to transfer control of the contract to a newOwner.
2002    * @param _newOwner The address to transfer ownership to.
2003    */
2004   function transferOwnership(address _newOwner) public onlyOwner {
2005     _transferOwnership(_newOwner);
2006   }
2007 
2008   /**
2009    * @dev Transfers control of the contract to a newOwner.
2010    * @param _newOwner The address to transfer ownership to.
2011    */
2012   function _transferOwnership(address _newOwner) internal {
2013     require(_newOwner != address(0));
2014     emit OwnershipTransferred(owner, _newOwner);
2015     owner = _newOwner;
2016   }
2017 }
2018 
2019 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
2020 
2021 /**
2022  * @title Pausable
2023  * @dev Base contract which allows children to implement an emergency stop mechanism.
2024  */
2025 contract Pausable is Ownable {
2026   event Pause();
2027   event Unpause();
2028 
2029   bool public paused = false;
2030 
2031 
2032   /**
2033    * @dev Modifier to make a function callable only when the contract is not paused.
2034    */
2035   modifier whenNotPaused() {
2036     require(!paused);
2037     _;
2038   }
2039 
2040   /**
2041    * @dev Modifier to make a function callable only when the contract is paused.
2042    */
2043   modifier whenPaused() {
2044     require(paused);
2045     _;
2046   }
2047 
2048   /**
2049    * @dev called by the owner to pause, triggers stopped state
2050    */
2051   function pause() public onlyOwner whenNotPaused {
2052     paused = true;
2053     emit Pause();
2054   }
2055 
2056   /**
2057    * @dev called by the owner to unpause, returns to normal state
2058    */
2059   function unpause() public onlyOwner whenPaused {
2060     paused = false;
2061     emit Unpause();
2062   }
2063 }
2064 
2065 // File: zeppelin-solidity/contracts/math/SafeMath.sol
2066 
2067 /**
2068  * @title SafeMath
2069  * @dev Math operations with safety checks that throw on error
2070  */
2071 library SafeMath {
2072 
2073   /**
2074   * @dev Multiplies two numbers, throws on overflow.
2075   */
2076   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
2077     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
2078     // benefit is lost if 'b' is also tested.
2079     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2080     if (_a == 0) {
2081       return 0;
2082     }
2083 
2084     c = _a * _b;
2085     assert(c / _a == _b);
2086     return c;
2087   }
2088 
2089   /**
2090   * @dev Integer division of two numbers, truncating the quotient.
2091   */
2092   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
2093     // assert(_b > 0); // Solidity automatically throws when dividing by 0
2094     // uint256 c = _a / _b;
2095     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
2096     return _a / _b;
2097   }
2098 
2099   /**
2100   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2101   */
2102   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
2103     assert(_b <= _a);
2104     return _a - _b;
2105   }
2106 
2107   /**
2108   * @dev Adds two numbers, throws on overflow.
2109   */
2110   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
2111     c = _a + _b;
2112     assert(c >= _a);
2113     return c;
2114   }
2115 }
2116 
2117 // File: contracts/PlayToken.sol
2118 
2119 interface ERC20Token {
2120     function totalSupply() external view returns (uint);
2121     function balanceOf(address who) external constant returns (uint256);
2122     function transfer(address to, uint256 value) external returns (bool);
2123 }
2124 
2125 contract PlayToken is Pausable{
2126 
2127     ERC20Token Token;
2128 
2129     bool public registeredToken = false;
2130     uint public tokenDecimalPlaces = 2;
2131     address public tokenAddress;
2132 
2133     uint public tokenWinRatio = 555555555555555 wei; //1800
2134     uint public tokenLossRatio = 5000000000000000 wei; //200
2135 
2136     modifier TokenCheck() {
2137        if (registeredToken != true) { //check balance
2138             revert();
2139         }
2140         _;
2141     }
2142 
2143     function registerToken(address _tokenAddress, uint decimalPlaces) public onlyOwner{
2144         Token = ERC20Token(_tokenAddress);
2145         tokenAddress = _tokenAddress;
2146         registeredToken = true;
2147         tokenDecimalPlaces = decimalPlaces;
2148     }
2149 
2150     function remainingTokens(address who) public constant returns (uint){
2151         return Token.balanceOf(who)/(10 ** tokenDecimalPlaces);
2152     }
2153 
2154     function getTokenWinValue(uint betInWei) public view returns(uint){
2155         return betInWei/tokenWinRatio;
2156     }
2157 
2158     function getTokenLossValue(uint betInWei) public view returns(uint){
2159         return betInWei/tokenLossRatio;
2160     }
2161 
2162     function setWinLossAmount(uint winAmount, uint lossAmount)public onlyOwner{
2163         tokenWinRatio = 1 ether/winAmount;
2164         tokenLossRatio = 1 ether/lossAmount;
2165     }
2166     function getWinTokenAmount()public constant returns(uint){
2167         return 1 ether/tokenWinRatio;
2168     }
2169     function getLossTokenAmount()public constant returns(uint){
2170         return 1 ether/tokenLossRatio;
2171     }
2172 
2173 }
2174 
2175 // File: contracts/CustomEvents.sol
2176 
2177 contract CustomEvents{
2178     event betPayout(address indexed playerAddr, uint amount);
2179     event betPayoutToken(address indexed playerAddr, uint amount);
2180     event dealtCards(address indexed player, bytes32 orcID, uint dealerHand, uint playerHand, uint dealerSuit, uint playerSuit);
2181     event currentOrcID(bytes32 orcID);
2182 
2183     event DEBUG_betSplit(uint mainBet, uint sideBet, uint percent);
2184     event DEBUG_str(string msg);
2185     event DEBUG_invalidOp(string error);
2186     event DEBUG_addr(address addr);
2187     event DEBUG_byte(bytes32 thing);
2188     event DEBUG_uint(uint thing);
2189 }
2190 
2191 // File: contracts/TestMode.sol
2192 
2193 contract TestMode is Pausable {
2194     bool public TEST_MODE = false;
2195     uint public TEST_HOUSE = 111;
2196     uint public TEST_PLAYER = 111;
2197 
2198     function ToggleTestMode(bool state) public onlyOwner{
2199       TEST_MODE = state;
2200     }
2201 
2202     function SetTestModeHands(uint house, uint player) public onlyOwner{
2203       require(house <= 416 && house >= 1);
2204       require(player <= 416 && player >= 1);
2205 
2206       TEST_HOUSE = house;
2207       TEST_PLAYER = player;
2208     }
2209 }
2210 
2211 // File: contracts/War.sol
2212 
2213 contract War is usingOraclize, Pausable, PlayToken, CustomEvents, TestMode {
2214     using strings for *;
2215     using SafeMath for uint;
2216 
2217     // default game settings
2218     uint public sideBetPercent_MAX = 80;
2219     uint public bet_MAX = 10 ether;
2220     uint public bet_MIN = 0.05 ether;
2221     uint public gasForShuffle = 185000;
2222 
2223     // player info store
2224     struct Info{
2225         address playerAddress;
2226         uint fees;
2227         uint mainBetAmount;
2228         uint sideBetAmount;
2229         uint sideBetPercentage;
2230         uint playerHand;
2231         uint houseHand;
2232     }
2233 
2234     struct FirstHand{
2235       bool isTied;
2236       uint fees;
2237       uint mainBetAmount;
2238     }
2239 
2240     mapping (bytes32 => Info) public hand_info;
2241     mapping (address => FirstHand) public firstHandInfo;
2242     mapping (address => bool) public hasHandInProgress;
2243     mapping (address => uint) public refundPool;
2244 
2245     constructor() public {
2246       oraclize_setCustomGasPrice(20000000000);
2247     }
2248     function() public payable {}
2249 
2250 //=====================
2251 // Game Settings
2252 //=====================
2253     function setGasPrice(uint gasPrice) public onlyOwner{
2254       oraclize_setCustomGasPrice(gasPrice);
2255     }
2256     function setOraclizeGas(uint32 gasAmount) public onlyOwner{
2257       gasForShuffle = gasAmount;
2258     }
2259 
2260     function setBetMinMax(uint min_bet, uint max_bet) public onlyOwner{
2261       require(min_bet > max_bet);
2262       bet_MIN = min_bet;
2263       bet_MAX = max_bet;
2264     }
2265 
2266     function setSideBetPercentage(uint percentage) public onlyOwner{
2267       require(percentage >= 0 && percentage <= 100);
2268       sideBetPercent_MAX = percentage;
2269     }
2270 //=====================
2271 // Main gameplay
2272 //=====================
2273     function playWar(uint sideBetPercent) public whenNotPaused TokenCheck payable {
2274 
2275       require(sideBetPercent >= 0 && sideBetPercent <= sideBetPercent_MAX);
2276 
2277       require(hasHandInProgress[msg.sender]==false);
2278 
2279       require(msg.value <= bet_MAX && msg.value >= bet_MIN);
2280 
2281       uint betAmount = msg.value;
2282       uint sideBetAmount = betAmount.mul(sideBetPercent).div(100);
2283       uint mainBetAmount = betAmount.sub(sideBetAmount);
2284 
2285       emit DEBUG_betSplit(mainBetAmount, sideBetAmount, sideBetPercent);
2286 
2287       //Initiate oraclize call
2288       bytes32 orcID = oraclize_query("WolframAlpha", "RandomSample[Range[416],2]",gasForShuffle);
2289       emit currentOrcID(orcID);
2290 
2291       uint orcFees = oraclize_getPrice("WolframAlpha", gasForShuffle);
2292 
2293       //check if previous hand was a tie and player chose to go to WAR
2294       if(firstHandInfo[msg.sender].isTied){
2295         assert(msg.value == firstHandInfo[msg.sender].mainBetAmount);
2296         assert(sideBetAmount == 0);
2297       }
2298       else{
2299         FirstHand memory thisHand = FirstHand({
2300           isTied : false,
2301           fees: orcFees,
2302           mainBetAmount : mainBetAmount
2303         });
2304         firstHandInfo[msg.sender] = thisHand;
2305       }
2306 
2307       Info memory info = Info({
2308           playerAddress : msg.sender,
2309           mainBetAmount : mainBetAmount,
2310           sideBetAmount : sideBetAmount,
2311           fees: orcFees,
2312           sideBetPercentage : sideBetPercent,
2313           playerHand : 0,
2314           houseHand : 0
2315       });
2316 
2317       hand_info[orcID] = info;
2318       refundPool[msg.sender] = msg.value.sub(orcFees);
2319       hasHandInProgress[msg.sender] = true;
2320     }
2321 
2322     function parseResult(bytes32 orcID, string result, address playerAddr) private returns(uint, uint){
2323         strings.slice memory partition = result.toSlice();
2324         partition.beyond("{".toSlice()).until("}".toSlice());
2325         strings.slice memory delim = ",".toSlice();
2326 
2327         uint houseRaw = parseInt(partition.split(delim).toString());
2328         uint playerRaw = parseInt(partition.split(delim).toString());
2329 
2330         if(TEST_MODE){
2331           houseRaw = TEST_HOUSE;
2332           playerRaw = TEST_PLAYER;
2333         }
2334 
2335         hand_info[orcID].houseHand = getCardValue(houseRaw);
2336         hand_info[orcID].playerHand = getCardValue(playerRaw);
2337 
2338         uint houseHand = hand_info[orcID].houseHand;
2339         uint playerHand = hand_info[orcID].playerHand;
2340 
2341         emit dealtCards(playerAddr, orcID, houseHand, playerHand, houseRaw, playerRaw);
2342 
2343         return(playerHand, houseHand);
2344     }
2345 
2346     function __callback(bytes32 orcID, string result) public{
2347         //security checks
2348         require(msg.sender == oraclize_cbAddress());
2349         require(hand_info[orcID].playerAddress!=0x0);
2350 
2351         address playerAddr = hand_info[orcID].playerAddress;
2352         require(hasHandInProgress[playerAddr]==true);
2353 
2354         hasHandInProgress[playerAddr] = false;
2355         delete refundPool[playerAddr];
2356 
2357         uint playerHand;
2358         uint houseHand;
2359 
2360         (playerHand, houseHand) =  parseResult(orcID, result, playerAddr);
2361 
2362         uint fees;
2363 
2364         if(playerHand == houseHand){
2365             uint betAmount = firstHandInfo[playerAddr].mainBetAmount;
2366             fees = firstHandInfo[playerAddr].fees;
2367 
2368             if(firstHandInfo[playerAddr].isTied){
2369                 pay(playerAddr, betAmount,fees);
2370                 payToken(playerAddr, getTokenWinValue(betAmount).mul(3));
2371                 delete firstHandInfo[playerAddr];
2372             }
2373             else{
2374                 firstHandInfo[playerAddr].isTied = true;
2375 
2376                 Info memory hand = hand_info[orcID];
2377 
2378                 if(hand.sideBetAmount > 0){
2379                     sideBetPay(orcID);
2380                     sideBetPayToken(orcID);
2381                 }
2382                 else{
2383                     payToken(playerAddr, getTokenLossValue(betAmount));
2384                 }
2385             }
2386         }
2387 
2388         uint winAmount = hand_info[orcID].mainBetAmount;
2389         fees = hand_info[orcID].fees;
2390 
2391         //Pay winner
2392         if(playerHand > houseHand){
2393           uint winTokenAmount = getTokenWinValue(winAmount);
2394 
2395           pay(playerAddr,winAmount,fees);
2396           payToken(playerAddr,winTokenAmount);
2397           delete firstHandInfo[playerAddr];
2398           delete hand_info[orcID];
2399         }
2400         else if(playerHand < houseHand){
2401             uint lossTokenAmount = getTokenLossValue(winAmount);
2402 
2403             payToken(playerAddr,lossTokenAmount);
2404             delete firstHandInfo[playerAddr];
2405             delete hand_info[orcID];
2406         }
2407     }
2408 
2409     function playerSurrender() public whenNotPaused payable {
2410 
2411       if(firstHandInfo[msg.sender].isTied){
2412           emit DEBUG_str("player surrendering");
2413 
2414         //   uint returnAmount = div(firstHandInfo[msg.sender].mainBetAmount,2);
2415           uint returnAmount = (firstHandInfo[msg.sender].mainBetAmount).div(2);
2416           uint fees = firstHandInfo[msg.sender].fees;
2417 
2418           pay(msg.sender,returnAmount,fees);
2419           delete firstHandInfo[msg.sender];
2420       }
2421       else{
2422         emit DEBUG_str("nothing to surrender"); //change this function to return false
2423       }
2424 
2425     }
2426 //=====================
2427 // Payment methods
2428 //=====================
2429     function pay(address _addr, uint amount, uint fees) private {
2430         amount = amount.sub(fees);
2431         _addr.transfer(amount);
2432         emit betPayout(_addr, amount);
2433     }
2434 
2435     function payToken(address _addr, uint amount) private {
2436         Token.transfer(_addr,amount * 10 ** tokenDecimalPlaces);
2437         emit betPayoutToken(_addr, amount);
2438     }
2439 
2440     function sideBetPay(bytes32 orcID) private{
2441         Info memory hand = hand_info[orcID];
2442 
2443         if(hand.sideBetAmount > 0) {
2444           pay(hand.playerAddress,hand.sideBetAmount,hand.fees);
2445         }
2446     }
2447 
2448     function sideBetPayToken(bytes32 orcID) private{
2449         Info memory hand = hand_info[orcID];
2450 
2451         if(hand.sideBetAmount > 0){
2452           uint sideBetWin = getTokenWinValue(hand.sideBetAmount).mul(10);
2453           payToken(hand.playerAddress,sideBetWin);
2454         }
2455     }
2456 
2457     function refund() whenNotPaused public returns(uint){
2458       address _addr = msg.sender;
2459       uint amount = refundPool[_addr];
2460       require(hasHandInProgress[_addr]==true);
2461       require(amount>0);
2462       require(amount<=bet_MAX);
2463 
2464       _addr.transfer(amount);
2465       emit betPayout(_addr, amount);
2466       hasHandInProgress[_addr]=false;
2467       delete refundPool[_addr];
2468       return amount;
2469     }
2470 
2471     function houseBankRoll() view public returns(uint){
2472         return address(this).balance;
2473     }
2474 //=====================
2475 // Owner
2476 //=====================
2477     function withdrawFunds() public onlyOwner{
2478       msg.sender.transfer(address(this).balance);
2479     }
2480 
2481     function withdrawTokens() public onlyOwner{
2482       uint amount = Token.balanceOf(address(this));
2483       Token.transfer(msg.sender, amount);
2484     }
2485 //=====================
2486 // Special
2487 //=====================
2488     function getCardValue(uint card) private pure returns(uint){
2489       if (card > 416 || card < 1) {
2490         return 0;
2491       }
2492 
2493       card = card % 52;
2494 
2495       if (card == 0) {
2496         return 13;
2497       } else if (card <= 4) {
2498         return 14;
2499       } else if (card % 4 > 0) {
2500         card = card.div(4).add(1);
2501       } else {
2502         card = card.div(4);
2503       }
2504 
2505       return card == 1 ? 14 : card;
2506     }
2507 }