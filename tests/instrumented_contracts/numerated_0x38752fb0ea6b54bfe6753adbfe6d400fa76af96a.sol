1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
32 
33 pragma solidity >=0.4.18 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
43     function getPrice(string _datasource) public returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
45     function setProofType(byte _proofType) external;
46     function setCustomGasPrice(uint _gasPrice) external;
47     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
48 }
49 
50 contract OraclizeAddrResolverI {
51     function getAddress() public returns (address _addr);
52 }
53 
54 /*
55 Begin solidity-cborutils
56 
57 https://github.com/smartcontractkit/solidity-cborutils
58 
59 MIT License
60 
61 Copyright (c) 2018 SmartContract ChainLink, Ltd.
62 
63 Permission is hereby granted, free of charge, to any person obtaining a copy
64 of this software and associated documentation files (the "Software"), to deal
65 in the Software without restriction, including without limitation the rights
66 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
67 copies of the Software, and to permit persons to whom the Software is
68 furnished to do so, subject to the following conditions:
69 
70 The above copyright notice and this permission notice shall be included in all
71 copies or substantial portions of the Software.
72 
73 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
74 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
75 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
76 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
77 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
78 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
79 SOFTWARE.
80  */
81 
82 library Buffer {
83     struct buffer {
84         bytes buf;
85         uint capacity;
86     }
87 
88     function init(buffer memory buf, uint capacity) internal pure {
89         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
90         // Allocate space for the buffer data
91         buf.capacity = capacity;
92         assembly {
93             let ptr := mload(0x40)
94             mstore(buf, ptr)
95             mstore(0x40, add(ptr, capacity))
96         }
97     }
98 
99     function resize(buffer memory buf, uint capacity) private pure {
100         bytes memory oldbuf = buf.buf;
101         init(buf, capacity);
102         append(buf, oldbuf);
103     }
104 
105     function max(uint a, uint b) private pure returns(uint) {
106         if(a > b) {
107             return a;
108         }
109         return b;
110     }
111 
112     /**
113      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
114      *      would exceed the capacity of the buffer.
115      * @param buf The buffer to append to.
116      * @param data The data to append.
117      * @return The original buffer.
118      */
119     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
120         if(data.length + buf.buf.length > buf.capacity) {
121             resize(buf, max(buf.capacity, data.length) * 2);
122         }
123 
124         uint dest;
125         uint src;
126         uint len = data.length;
127         assembly {
128             // Memory address of the buffer data
129             let bufptr := mload(buf)
130             // Length of existing buffer data
131             let buflen := mload(bufptr)
132             // Start address = buffer address + buffer length + sizeof(buffer length)
133             dest := add(add(bufptr, buflen), 32)
134             // Update buffer length
135             mstore(bufptr, add(buflen, mload(data)))
136             src := add(data, 32)
137         }
138 
139         // Copy word-length chunks while possible
140         for(; len >= 32; len -= 32) {
141             assembly {
142                 mstore(dest, mload(src))
143             }
144             dest += 32;
145             src += 32;
146         }
147 
148         // Copy remaining bytes
149         uint mask = 256 ** (32 - len) - 1;
150         assembly {
151             let srcpart := and(mload(src), not(mask))
152             let destpart := and(mload(dest), mask)
153             mstore(dest, or(destpart, srcpart))
154         }
155 
156         return buf;
157     }
158 
159     /**
160      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
161      * exceed the capacity of the buffer.
162      * @param buf The buffer to append to.
163      * @param data The data to append.
164      * @return The original buffer.
165      */
166     function append(buffer memory buf, uint8 data) internal pure {
167         if(buf.buf.length + 1 > buf.capacity) {
168             resize(buf, buf.capacity * 2);
169         }
170 
171         assembly {
172             // Memory address of the buffer data
173             let bufptr := mload(buf)
174             // Length of existing buffer data
175             let buflen := mload(bufptr)
176             // Address = buffer address + buffer length + sizeof(buffer length)
177             let dest := add(add(bufptr, buflen), 32)
178             mstore8(dest, data)
179             // Update buffer length
180             mstore(bufptr, add(buflen, 1))
181         }
182     }
183 
184     /**
185      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
186      * exceed the capacity of the buffer.
187      * @param buf The buffer to append to.
188      * @param data The data to append.
189      * @return The original buffer.
190      */
191     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
192         if(len + buf.buf.length > buf.capacity) {
193             resize(buf, max(buf.capacity, len) * 2);
194         }
195 
196         uint mask = 256 ** len - 1;
197         assembly {
198             // Memory address of the buffer data
199             let bufptr := mload(buf)
200             // Length of existing buffer data
201             let buflen := mload(bufptr)
202             // Address = buffer address + buffer length + sizeof(buffer length) + len
203             let dest := add(add(bufptr, buflen), len)
204             mstore(dest, or(and(mload(dest), not(mask)), data))
205             // Update buffer length
206             mstore(bufptr, add(buflen, len))
207         }
208         return buf;
209     }
210 }
211 
212 library CBOR {
213     using Buffer for Buffer.buffer;
214 
215     uint8 private constant MAJOR_TYPE_INT = 0;
216     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
217     uint8 private constant MAJOR_TYPE_BYTES = 2;
218     uint8 private constant MAJOR_TYPE_STRING = 3;
219     uint8 private constant MAJOR_TYPE_ARRAY = 4;
220     uint8 private constant MAJOR_TYPE_MAP = 5;
221     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
222 
223     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
224         if(value <= 23) {
225             buf.append(uint8((major << 5) | value));
226         } else if(value <= 0xFF) {
227             buf.append(uint8((major << 5) | 24));
228             buf.appendInt(value, 1);
229         } else if(value <= 0xFFFF) {
230             buf.append(uint8((major << 5) | 25));
231             buf.appendInt(value, 2);
232         } else if(value <= 0xFFFFFFFF) {
233             buf.append(uint8((major << 5) | 26));
234             buf.appendInt(value, 4);
235         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
236             buf.append(uint8((major << 5) | 27));
237             buf.appendInt(value, 8);
238         }
239     }
240 
241     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
242         buf.append(uint8((major << 5) | 31));
243     }
244 
245     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
246         encodeType(buf, MAJOR_TYPE_INT, value);
247     }
248 
249     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
250         if(value >= 0) {
251             encodeType(buf, MAJOR_TYPE_INT, uint(value));
252         } else {
253             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
254         }
255     }
256 
257     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
258         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
259         buf.append(value);
260     }
261 
262     function encodeString(Buffer.buffer memory buf, string value) internal pure {
263         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
264         buf.append(bytes(value));
265     }
266 
267     function startArray(Buffer.buffer memory buf) internal pure {
268         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
269     }
270 
271     function startMap(Buffer.buffer memory buf) internal pure {
272         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
273     }
274 
275     function endSequence(Buffer.buffer memory buf) internal pure {
276         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
277     }
278 }
279 
280 /*
281 End solidity-cborutils
282  */
283 
284 contract usingOraclize {
285     uint constant day = 60*60*24;
286     uint constant week = 60*60*24*7;
287     uint constant month = 60*60*24*30;
288     byte constant proofType_NONE = 0x00;
289     byte constant proofType_TLSNotary = 0x10;
290     byte constant proofType_Android = 0x20;
291     byte constant proofType_Ledger = 0x30;
292     byte constant proofType_Native = 0xF0;
293     byte constant proofStorage_IPFS = 0x01;
294     uint8 constant networkID_auto = 0;
295     uint8 constant networkID_mainnet = 1;
296     uint8 constant networkID_testnet = 2;
297     uint8 constant networkID_morden = 2;
298     uint8 constant networkID_consensys = 161;
299 
300     OraclizeAddrResolverI OAR;
301 
302     OraclizeI oraclize;
303     modifier oraclizeAPI {
304         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
305             oraclize_setNetwork(networkID_auto);
306 
307         if(address(oraclize) != OAR.getAddress())
308             oraclize = OraclizeI(OAR.getAddress());
309 
310         _;
311     }
312     modifier coupon(string code){
313         oraclize = OraclizeI(OAR.getAddress());
314         _;
315     }
316 
317     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
318       return oraclize_setNetwork();
319       networkID; // silence the warning and remain backwards compatible
320     }
321     function oraclize_setNetwork() internal returns(bool){
322         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
323             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
324             oraclize_setNetworkName("eth_mainnet");
325             return true;
326         }
327         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
328             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
329             oraclize_setNetworkName("eth_ropsten3");
330             return true;
331         }
332         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
333             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
334             oraclize_setNetworkName("eth_kovan");
335             return true;
336         }
337         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
338             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
339             oraclize_setNetworkName("eth_rinkeby");
340             return true;
341         }
342         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
343             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
344             return true;
345         }
346         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
347             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
348             return true;
349         }
350         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
351             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
352             return true;
353         }
354         return false;
355     }
356 
357     function __callback(bytes32 myid, string result) public {
358         __callback(myid, result, new bytes(0));
359     }
360     function __callback(bytes32 myid, string result, bytes proof) public {
361       return;
362       myid; result; proof; // Silence compiler warnings
363     }
364 
365     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
366         return oraclize.getPrice(datasource);
367     }
368 
369     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
370         return oraclize.getPrice(datasource, gaslimit);
371     }
372 
373     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
374         uint price = oraclize.getPrice(datasource);
375         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
376         return oraclize.query.value(price)(0, datasource, arg);
377     }
378     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource);
380         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
381         return oraclize.query.value(price)(timestamp, datasource, arg);
382     }
383     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource, gaslimit);
385         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
386         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
387     }
388     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource, gaslimit);
390         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
391         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
392     }
393     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource);
395         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
396         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
397     }
398     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource);
400         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
401         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
402     }
403     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
404         uint price = oraclize.getPrice(datasource, gaslimit);
405         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
406         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
407     }
408     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource, gaslimit);
410         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
411         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
412     }
413     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource);
415         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
416         bytes memory args = stra2cbor(argN);
417         return oraclize.queryN.value(price)(0, datasource, args);
418     }
419     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource);
421         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
422         bytes memory args = stra2cbor(argN);
423         return oraclize.queryN.value(price)(timestamp, datasource, args);
424     }
425     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource, gaslimit);
427         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
428         bytes memory args = stra2cbor(argN);
429         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
430     }
431     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource, gaslimit);
433         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
434         bytes memory args = stra2cbor(argN);
435         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
436     }
437     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
438         string[] memory dynargs = new string[](1);
439         dynargs[0] = args[0];
440         return oraclize_query(datasource, dynargs);
441     }
442     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
443         string[] memory dynargs = new string[](1);
444         dynargs[0] = args[0];
445         return oraclize_query(timestamp, datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](1);
449         dynargs[0] = args[0];
450         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](1);
454         dynargs[0] = args[0];
455         return oraclize_query(datasource, dynargs, gaslimit);
456     }
457 
458     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](2);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         return oraclize_query(datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(timestamp, datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](2);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](2);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         return oraclize_query(datasource, dynargs, gaslimit);
481     }
482     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
483         string[] memory dynargs = new string[](3);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](3);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         return oraclize_query(timestamp, datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](3);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](3);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         return oraclize_query(datasource, dynargs, gaslimit);
509     }
510 
511     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](4);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         dynargs[2] = args[2];
516         dynargs[3] = args[3];
517         return oraclize_query(datasource, dynargs);
518     }
519     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
520         string[] memory dynargs = new string[](4);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         dynargs[3] = args[3];
525         return oraclize_query(timestamp, datasource, dynargs);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](4);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         dynargs[3] = args[3];
533         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
534     }
535     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
536         string[] memory dynargs = new string[](4);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         return oraclize_query(datasource, dynargs, gaslimit);
542     }
543     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](5);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         dynargs[4] = args[4];
550         return oraclize_query(datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](5);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         dynargs[4] = args[4];
559         return oraclize_query(timestamp, datasource, dynargs);
560     }
561     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         string[] memory dynargs = new string[](5);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         dynargs[4] = args[4];
568         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
569     }
570     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
571         string[] memory dynargs = new string[](5);
572         dynargs[0] = args[0];
573         dynargs[1] = args[1];
574         dynargs[2] = args[2];
575         dynargs[3] = args[3];
576         dynargs[4] = args[4];
577         return oraclize_query(datasource, dynargs, gaslimit);
578     }
579     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
580         uint price = oraclize.getPrice(datasource);
581         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
582         bytes memory args = ba2cbor(argN);
583         return oraclize.queryN.value(price)(0, datasource, args);
584     }
585     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
586         uint price = oraclize.getPrice(datasource);
587         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
588         bytes memory args = ba2cbor(argN);
589         return oraclize.queryN.value(price)(timestamp, datasource, args);
590     }
591     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
592         uint price = oraclize.getPrice(datasource, gaslimit);
593         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
594         bytes memory args = ba2cbor(argN);
595         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
596     }
597     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
598         uint price = oraclize.getPrice(datasource, gaslimit);
599         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
600         bytes memory args = ba2cbor(argN);
601         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
602     }
603     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](1);
605         dynargs[0] = args[0];
606         return oraclize_query(datasource, dynargs);
607     }
608     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
609         bytes[] memory dynargs = new bytes[](1);
610         dynargs[0] = args[0];
611         return oraclize_query(timestamp, datasource, dynargs);
612     }
613     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](1);
615         dynargs[0] = args[0];
616         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
617     }
618     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](1);
620         dynargs[0] = args[0];
621         return oraclize_query(datasource, dynargs, gaslimit);
622     }
623 
624     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](2);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         return oraclize_query(datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](2);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         return oraclize_query(timestamp, datasource, dynargs);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](2);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
641     }
642     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](2);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         return oraclize_query(datasource, dynargs, gaslimit);
647     }
648     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
649         bytes[] memory dynargs = new bytes[](3);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         dynargs[2] = args[2];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](3);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         return oraclize_query(timestamp, datasource, dynargs);
661     }
662     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](3);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](3);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         return oraclize_query(datasource, dynargs, gaslimit);
675     }
676 
677     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](4);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         dynargs[2] = args[2];
682         dynargs[3] = args[3];
683         return oraclize_query(datasource, dynargs);
684     }
685     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
686         bytes[] memory dynargs = new bytes[](4);
687         dynargs[0] = args[0];
688         dynargs[1] = args[1];
689         dynargs[2] = args[2];
690         dynargs[3] = args[3];
691         return oraclize_query(timestamp, datasource, dynargs);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](4);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         dynargs[3] = args[3];
699         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
700     }
701     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
702         bytes[] memory dynargs = new bytes[](4);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         dynargs[3] = args[3];
707         return oraclize_query(datasource, dynargs, gaslimit);
708     }
709     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](5);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         dynargs[3] = args[3];
715         dynargs[4] = args[4];
716         return oraclize_query(datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
719         bytes[] memory dynargs = new bytes[](5);
720         dynargs[0] = args[0];
721         dynargs[1] = args[1];
722         dynargs[2] = args[2];
723         dynargs[3] = args[3];
724         dynargs[4] = args[4];
725         return oraclize_query(timestamp, datasource, dynargs);
726     }
727     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
728         bytes[] memory dynargs = new bytes[](5);
729         dynargs[0] = args[0];
730         dynargs[1] = args[1];
731         dynargs[2] = args[2];
732         dynargs[3] = args[3];
733         dynargs[4] = args[4];
734         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
735     }
736     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
737         bytes[] memory dynargs = new bytes[](5);
738         dynargs[0] = args[0];
739         dynargs[1] = args[1];
740         dynargs[2] = args[2];
741         dynargs[3] = args[3];
742         dynargs[4] = args[4];
743         return oraclize_query(datasource, dynargs, gaslimit);
744     }
745 
746     function oraclize_cbAddress() oraclizeAPI internal returns (address){
747         return oraclize.cbAddress();
748     }
749     function oraclize_setProof(byte proofP) oraclizeAPI internal {
750         return oraclize.setProofType(proofP);
751     }
752     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
753         return oraclize.setCustomGasPrice(gasPrice);
754     }
755 
756     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
757         return oraclize.randomDS_getSessionPubKeyHash();
758     }
759 
760     function getCodeSize(address _addr) constant internal returns(uint _size) {
761         assembly {
762             _size := extcodesize(_addr)
763         }
764     }
765 
766     function parseAddr(string _a) internal pure returns (address){
767         bytes memory tmp = bytes(_a);
768         uint160 iaddr = 0;
769         uint160 b1;
770         uint160 b2;
771         for (uint i=2; i<2+2*20; i+=2){
772             iaddr *= 256;
773             b1 = uint160(tmp[i]);
774             b2 = uint160(tmp[i+1]);
775             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
776             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
777             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
778             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
779             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
780             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
781             iaddr += (b1*16+b2);
782         }
783         return address(iaddr);
784     }
785 
786     function strCompare(string _a, string _b) internal pure returns (int) {
787         bytes memory a = bytes(_a);
788         bytes memory b = bytes(_b);
789         uint minLength = a.length;
790         if (b.length < minLength) minLength = b.length;
791         for (uint i = 0; i < minLength; i ++)
792             if (a[i] < b[i])
793                 return -1;
794             else if (a[i] > b[i])
795                 return 1;
796         if (a.length < b.length)
797             return -1;
798         else if (a.length > b.length)
799             return 1;
800         else
801             return 0;
802     }
803 
804     function indexOf(string _haystack, string _needle) internal pure returns (int) {
805         bytes memory h = bytes(_haystack);
806         bytes memory n = bytes(_needle);
807         if(h.length < 1 || n.length < 1 || (n.length > h.length))
808             return -1;
809         else if(h.length > (2**128 -1))
810             return -1;
811         else
812         {
813             uint subindex = 0;
814             for (uint i = 0; i < h.length; i ++)
815             {
816                 if (h[i] == n[0])
817                 {
818                     subindex = 1;
819                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
820                     {
821                         subindex++;
822                     }
823                     if(subindex == n.length)
824                         return int(i);
825                 }
826             }
827             return -1;
828         }
829     }
830 
831     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
832         bytes memory _ba = bytes(_a);
833         bytes memory _bb = bytes(_b);
834         bytes memory _bc = bytes(_c);
835         bytes memory _bd = bytes(_d);
836         bytes memory _be = bytes(_e);
837         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
838         bytes memory babcde = bytes(abcde);
839         uint k = 0;
840         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
841         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
842         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
843         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
844         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
845         return string(babcde);
846     }
847 
848     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
849         return strConcat(_a, _b, _c, _d, "");
850     }
851 
852     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
853         return strConcat(_a, _b, _c, "", "");
854     }
855 
856     function strConcat(string _a, string _b) internal pure returns (string) {
857         return strConcat(_a, _b, "", "", "");
858     }
859 
860     // parseInt
861     function parseInt(string _a) internal pure returns (uint) {
862         return parseInt(_a, 0);
863     }
864 
865     // parseInt(parseFloat*10^_b)
866     function parseInt(string _a, uint _b) internal pure returns (uint) {
867         bytes memory bresult = bytes(_a);
868         uint mint = 0;
869         bool decimals = false;
870         for (uint i=0; i<bresult.length; i++){
871             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
872                 if (decimals){
873                    if (_b == 0) break;
874                     else _b--;
875                 }
876                 mint *= 10;
877                 mint += uint(bresult[i]) - 48;
878             } else if (bresult[i] == 46) decimals = true;
879         }
880         if (_b > 0) mint *= 10**_b;
881         return mint;
882     }
883 
884     function uint2str(uint i) internal pure returns (string){
885         if (i == 0) return "0";
886         uint j = i;
887         uint len;
888         while (j != 0){
889             len++;
890             j /= 10;
891         }
892         bytes memory bstr = new bytes(len);
893         uint k = len - 1;
894         while (i != 0){
895             bstr[k--] = byte(48 + i % 10);
896             i /= 10;
897         }
898         return string(bstr);
899     }
900 
901     using CBOR for Buffer.buffer;
902     function stra2cbor(string[] arr) internal pure returns (bytes) {
903         Buffer.buffer memory buf;
904         Buffer.init(buf, 1024);
905         buf.startArray();
906         for (uint i = 0; i < arr.length; i++) {
907             buf.encodeString(arr[i]);
908         }
909         buf.endSequence();
910         return buf.buf;
911     }
912 
913     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
914         Buffer.buffer memory buf;
915         Buffer.init(buf, 1024);
916         buf.startArray();
917         for (uint i = 0; i < arr.length; i++) {
918             buf.encodeBytes(arr[i]);
919         }
920         buf.endSequence();
921         return buf.buf;
922     }
923 
924     string oraclize_network_name;
925     function oraclize_setNetworkName(string _network_name) internal {
926         oraclize_network_name = _network_name;
927     }
928 
929     function oraclize_getNetworkName() internal view returns (string) {
930         return oraclize_network_name;
931     }
932 
933     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
934         require((_nbytes > 0) && (_nbytes <= 32));
935         // Convert from seconds to ledger timer ticks
936         _delay *= 10;
937         bytes memory nbytes = new bytes(1);
938         nbytes[0] = byte(_nbytes);
939         bytes memory unonce = new bytes(32);
940         bytes memory sessionKeyHash = new bytes(32);
941         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
942         assembly {
943             mstore(unonce, 0x20)
944             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
945             mstore(sessionKeyHash, 0x20)
946             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
947         }
948         bytes memory delay = new bytes(32);
949         assembly {
950             mstore(add(delay, 0x20), _delay)
951         }
952 
953         bytes memory delay_bytes8 = new bytes(8);
954         copyBytes(delay, 24, 8, delay_bytes8, 0);
955 
956         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
957         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
958 
959         bytes memory delay_bytes8_left = new bytes(8);
960 
961         assembly {
962             let x := mload(add(delay_bytes8, 0x20))
963             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
971 
972         }
973 
974         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
975         return queryId;
976     }
977 
978     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
979         oraclize_randomDS_args[queryId] = commitment;
980     }
981 
982     mapping(bytes32=>bytes32) oraclize_randomDS_args;
983     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
984 
985     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
986         bool sigok;
987         address signer;
988 
989         bytes32 sigr;
990         bytes32 sigs;
991 
992         bytes memory sigr_ = new bytes(32);
993         uint offset = 4+(uint(dersig[3]) - 0x20);
994         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
995         bytes memory sigs_ = new bytes(32);
996         offset += 32 + 2;
997         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
998 
999         assembly {
1000             sigr := mload(add(sigr_, 32))
1001             sigs := mload(add(sigs_, 32))
1002         }
1003 
1004 
1005         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1006         if (address(keccak256(pubkey)) == signer) return true;
1007         else {
1008             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1009             return (address(keccak256(pubkey)) == signer);
1010         }
1011     }
1012 
1013     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1014         bool sigok;
1015 
1016         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1017         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1018         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1019 
1020         bytes memory appkey1_pubkey = new bytes(64);
1021         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1022 
1023         bytes memory tosign2 = new bytes(1+65+32);
1024         tosign2[0] = byte(1); //role
1025         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1026         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1027         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1028         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1029 
1030         if (sigok == false) return false;
1031 
1032 
1033         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1034         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1035 
1036         bytes memory tosign3 = new bytes(1+65);
1037         tosign3[0] = 0xFE;
1038         copyBytes(proof, 3, 65, tosign3, 1);
1039 
1040         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1041         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1042 
1043         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1044 
1045         return sigok;
1046     }
1047 
1048     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1049         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1050         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1051 
1052         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1053         require(proofVerified);
1054 
1055         _;
1056     }
1057 
1058     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1059         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1060         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1061 
1062         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1063         if (proofVerified == false) return 2;
1064 
1065         return 0;
1066     }
1067 
1068     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1069         bool match_ = true;
1070 
1071         require(prefix.length == n_random_bytes);
1072 
1073         for (uint256 i=0; i< n_random_bytes; i++) {
1074             if (content[i] != prefix[i]) match_ = false;
1075         }
1076 
1077         return match_;
1078     }
1079 
1080     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1081 
1082         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1083         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1084         bytes memory keyhash = new bytes(32);
1085         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1086         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1087 
1088         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1089         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1090 
1091         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1092         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1093 
1094         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1095         // This is to verify that the computed args match with the ones specified in the query.
1096         bytes memory commitmentSlice1 = new bytes(8+1+32);
1097         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1098 
1099         bytes memory sessionPubkey = new bytes(64);
1100         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1101         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1102 
1103         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1104         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1105             delete oraclize_randomDS_args[queryId];
1106         } else return false;
1107 
1108 
1109         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1110         bytes memory tosign1 = new bytes(32+8+1+32);
1111         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1112         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1113 
1114         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1115         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1116             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1117         }
1118 
1119         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1120     }
1121 
1122     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1123     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1124         uint minLength = length + toOffset;
1125 
1126         // Buffer too small
1127         require(to.length >= minLength); // Should be a better way?
1128 
1129         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1130         uint i = 32 + fromOffset;
1131         uint j = 32 + toOffset;
1132 
1133         while (i < (32 + fromOffset + length)) {
1134             assembly {
1135                 let tmp := mload(add(from, i))
1136                 mstore(add(to, j), tmp)
1137             }
1138             i += 32;
1139             j += 32;
1140         }
1141 
1142         return to;
1143     }
1144 
1145     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1146     // Duplicate Solidity's ecrecover, but catching the CALL return value
1147     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1148         // We do our own memory management here. Solidity uses memory offset
1149         // 0x40 to store the current end of memory. We write past it (as
1150         // writes are memory extensions), but don't update the offset so
1151         // Solidity will reuse it. The memory used here is only needed for
1152         // this context.
1153 
1154         // FIXME: inline assembly can't access return values
1155         bool ret;
1156         address addr;
1157 
1158         assembly {
1159             let size := mload(0x40)
1160             mstore(size, hash)
1161             mstore(add(size, 32), v)
1162             mstore(add(size, 64), r)
1163             mstore(add(size, 96), s)
1164 
1165             // NOTE: we can reuse the request memory because we deal with
1166             //       the return code
1167             ret := call(3000, 1, 0, size, 128, size, 32)
1168             addr := mload(size)
1169         }
1170 
1171         return (ret, addr);
1172     }
1173 
1174     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1175     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1176         bytes32 r;
1177         bytes32 s;
1178         uint8 v;
1179 
1180         if (sig.length != 65)
1181           return (false, 0);
1182 
1183         // The signature format is a compact form of:
1184         //   {bytes32 r}{bytes32 s}{uint8 v}
1185         // Compact means, uint8 is not padded to 32 bytes.
1186         assembly {
1187             r := mload(add(sig, 32))
1188             s := mload(add(sig, 64))
1189 
1190             // Here we are loading the last 32 bytes. We exploit the fact that
1191             // 'mload' will pad with zeroes if we overread.
1192             // There is no 'mload8' to do this, but that would be nicer.
1193             v := byte(0, mload(add(sig, 96)))
1194 
1195             // Alternative solution:
1196             // 'byte' is not working due to the Solidity parser, so lets
1197             // use the second best option, 'and'
1198             // v := and(mload(add(sig, 65)), 255)
1199         }
1200 
1201         // albeit non-transactional signatures are not specified by the YP, one would expect it
1202         // to match the YP range of [27, 28]
1203         //
1204         // geth uses [0, 1] and some clients have followed. This might change, see:
1205         //  https://github.com/ethereum/go-ethereum/issues/2053
1206         if (v < 27)
1207           v += 27;
1208 
1209         if (v != 27 && v != 28)
1210             return (false, 0);
1211 
1212         return safer_ecrecover(hash, v, r, s);
1213     }
1214 
1215 }
1216 // </ORACLIZE_API>
1217 
1218 contract Test is usingOraclize {
1219     uint public randomNumber;
1220     mapping(bytes32 => bool) validIds;
1221     uint constant gasLimitForOraclize = 175000;
1222 
1223     event LogOraclizeQuery(string description);
1224     event LogResultReceived(uint number);
1225 
1226     function Template() public {
1227         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1228         oraclize_setCustomGasPrice(10000000000 wei); // 10 Gwei
1229     }
1230 
1231     function getRandomNumber() public payable {
1232         require(msg.value >= 0.00175 ether);
1233 
1234         bytes32 queryId = oraclize_query(
1235             "nested",
1236             "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BBn8phrFl4FKmQp9hPf54Gqt511WrDSr+M2rmxv9KOY6Tk9rW7vQiusULtNJuTsUaF2msUYUgx4+GemziX5HpMDS8nCWL2bFt4KkhhnGuaoEi/2bsbJCJI26H0DWf3Xf8UMPldXKOWjkWsA519U84w+lm9K5}\",\"n\":1,\"min\":1,\"max\":10000${[identity] \"}\"},\"id\":1${[identity] \"}\"}']",
1237             gasLimitForOraclize
1238         );
1239 
1240         LogOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1241 
1242         validIds[queryId] = true;
1243     }
1244 
1245     function __callback(bytes32 queryId, string result, bytes proof) public {
1246         require(msg.sender == oraclize_cbAddress());
1247         require(validIds[queryId]);
1248 
1249         randomNumber = parseInt(result);
1250 
1251         LogResultReceived(randomNumber);
1252 
1253         validIds[queryId] = false;
1254     }
1255 }