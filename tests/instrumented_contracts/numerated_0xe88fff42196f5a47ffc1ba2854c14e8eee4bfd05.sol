1 pragma solidity ^0.4.24;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
11     function getPrice(string _datasource) public returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
13     function setProofType(byte _proofType) external;
14     function setCustomGasPrice(uint _gasPrice) external;
15     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
16 }
17 
18 contract OraclizeAddrResolverI {
19     function getAddress() public returns (address _addr);
20 }
21 
22 /*
23 Begin solidity-cborutils
24 
25 https://github.com/smartcontractkit/solidity-cborutils
26 
27 MIT License
28 
29 Copyright (c) 2018 SmartContract ChainLink, Ltd.
30 
31 Permission is hereby granted, free of charge, to any person obtaining a copy
32 of this software and associated documentation files (the "Software"), to deal
33 in the Software without restriction, including without limitation the rights
34 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
35 copies of the Software, and to permit persons to whom the Software is
36 furnished to do so, subject to the following conditions:
37 
38 The above copyright notice and this permission notice shall be included in all
39 copies or substantial portions of the Software.
40 
41 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
42 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
43 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
44 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
45 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
46 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
47 SOFTWARE.
48  */
49 
50 library Buffer {
51     struct buffer {
52         bytes buf;
53         uint capacity;
54     }
55 
56     function init(buffer memory buf, uint _capacity) internal pure {
57         uint capacity = _capacity;
58         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
59         // Allocate space for the buffer data
60         buf.capacity = capacity;
61         assembly {
62             let ptr := mload(0x40)
63             mstore(buf, ptr)
64             mstore(ptr, 0)
65             mstore(0x40, add(ptr, capacity))
66         }
67     }
68 
69     function resize(buffer memory buf, uint capacity) private pure {
70         bytes memory oldbuf = buf.buf;
71         init(buf, capacity);
72         append(buf, oldbuf);
73     }
74 
75     function max(uint a, uint b) private pure returns(uint) {
76         if(a > b) {
77             return a;
78         }
79         return b;
80     }
81 
82     /**
83      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
84      *      would exceed the capacity of the buffer.
85      * @param buf The buffer to append to.
86      * @param data The data to append.
87      * @return The original buffer.
88      */
89     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
90         if(data.length + buf.buf.length > buf.capacity) {
91             resize(buf, max(buf.capacity, data.length) * 2);
92         }
93 
94         uint dest;
95         uint src;
96         uint len = data.length;
97         assembly {
98             // Memory address of the buffer data
99             let bufptr := mload(buf)
100             // Length of existing buffer data
101             let buflen := mload(bufptr)
102             // Start address = buffer address + buffer length + sizeof(buffer length)
103             dest := add(add(bufptr, buflen), 32)
104             // Update buffer length
105             mstore(bufptr, add(buflen, mload(data)))
106             src := add(data, 32)
107         }
108 
109         // Copy word-length chunks while possible
110         for(; len >= 32; len -= 32) {
111             assembly {
112                 mstore(dest, mload(src))
113             }
114             dest += 32;
115             src += 32;
116         }
117 
118         // Copy remaining bytes
119         uint mask = 256 ** (32 - len) - 1;
120         assembly {
121             let srcpart := and(mload(src), not(mask))
122             let destpart := and(mload(dest), mask)
123             mstore(dest, or(destpart, srcpart))
124         }
125 
126         return buf;
127     }
128 
129     /**
130      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
131      * exceed the capacity of the buffer.
132      * @param buf The buffer to append to.
133      * @param data The data to append.
134      * @return The original buffer.
135      */
136     function append(buffer memory buf, uint8 data) internal pure {
137         if(buf.buf.length + 1 > buf.capacity) {
138             resize(buf, buf.capacity * 2);
139         }
140 
141         assembly {
142             // Memory address of the buffer data
143             let bufptr := mload(buf)
144             // Length of existing buffer data
145             let buflen := mload(bufptr)
146             // Address = buffer address + buffer length + sizeof(buffer length)
147             let dest := add(add(bufptr, buflen), 32)
148             mstore8(dest, data)
149             // Update buffer length
150             mstore(bufptr, add(buflen, 1))
151         }
152     }
153 
154     /**
155      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
156      * exceed the capacity of the buffer.
157      * @param buf The buffer to append to.
158      * @param data The data to append.
159      * @return The original buffer.
160      */
161     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
162         if(len + buf.buf.length > buf.capacity) {
163             resize(buf, max(buf.capacity, len) * 2);
164         }
165 
166         uint mask = 256 ** len - 1;
167         assembly {
168             // Memory address of the buffer data
169             let bufptr := mload(buf)
170             // Length of existing buffer data
171             let buflen := mload(bufptr)
172             // Address = buffer address + buffer length + sizeof(buffer length) + len
173             let dest := add(add(bufptr, buflen), len)
174             mstore(dest, or(and(mload(dest), not(mask)), data))
175             // Update buffer length
176             mstore(bufptr, add(buflen, len))
177         }
178         return buf;
179     }
180 }
181 
182 library CBOR {
183     using Buffer for Buffer.buffer;
184 
185     uint8 private constant MAJOR_TYPE_INT = 0;
186     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
187     uint8 private constant MAJOR_TYPE_BYTES = 2;
188     uint8 private constant MAJOR_TYPE_STRING = 3;
189     uint8 private constant MAJOR_TYPE_ARRAY = 4;
190     uint8 private constant MAJOR_TYPE_MAP = 5;
191     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
192 
193     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
194         if(value <= 23) {
195             buf.append(uint8((major << 5) | value));
196         } else if(value <= 0xFF) {
197             buf.append(uint8((major << 5) | 24));
198             buf.appendInt(value, 1);
199         } else if(value <= 0xFFFF) {
200             buf.append(uint8((major << 5) | 25));
201             buf.appendInt(value, 2);
202         } else if(value <= 0xFFFFFFFF) {
203             buf.append(uint8((major << 5) | 26));
204             buf.appendInt(value, 4);
205         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
206             buf.append(uint8((major << 5) | 27));
207             buf.appendInt(value, 8);
208         }
209     }
210 
211     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
212         buf.append(uint8((major << 5) | 31));
213     }
214 
215     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
216         encodeType(buf, MAJOR_TYPE_INT, value);
217     }
218 
219     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
220         if(value >= 0) {
221             encodeType(buf, MAJOR_TYPE_INT, uint(value));
222         } else {
223             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
224         }
225     }
226 
227     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
228         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
229         buf.append(value);
230     }
231 
232     function encodeString(Buffer.buffer memory buf, string value) internal pure {
233         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
234         buf.append(bytes(value));
235     }
236 
237     function startArray(Buffer.buffer memory buf) internal pure {
238         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
239     }
240 
241     function startMap(Buffer.buffer memory buf) internal pure {
242         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
243     }
244 
245     function endSequence(Buffer.buffer memory buf) internal pure {
246         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
247     }
248 }
249 
250 /*
251 End solidity-cborutils
252  */
253 
254 contract usingOraclize {
255     uint constant day = 60*60*24;
256     uint constant week = 60*60*24*7;
257     uint constant month = 60*60*24*30;
258     byte constant proofType_NONE = 0x00;
259     byte constant proofType_TLSNotary = 0x10;
260     byte constant proofType_Ledger = 0x30;
261     byte constant proofType_Android = 0x40;
262     byte constant proofType_Native = 0xF0;
263     byte constant proofStorage_IPFS = 0x01;
264     uint8 constant networkID_auto = 0;
265     uint8 constant networkID_mainnet = 1;
266     uint8 constant networkID_testnet = 2;
267     uint8 constant networkID_morden = 2;
268     uint8 constant networkID_consensys = 161;
269 
270     OraclizeAddrResolverI OAR;
271 
272     OraclizeI oraclize;
273     modifier oraclizeAPI {
274         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
275             oraclize_setNetwork(networkID_auto);
276 
277         if(address(oraclize) != OAR.getAddress())
278             oraclize = OraclizeI(OAR.getAddress());
279 
280         _;
281     }
282     modifier coupon(string code){
283         oraclize = OraclizeI(OAR.getAddress());
284         _;
285     }
286 
287     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
288       return oraclize_setNetwork();
289       networkID; // silence the warning and remain backwards compatible
290     }
291     function oraclize_setNetwork() internal returns(bool){
292         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
293             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
294             oraclize_setNetworkName("eth_mainnet");
295             return true;
296         }
297         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
298             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
299             oraclize_setNetworkName("eth_ropsten3");
300             return true;
301         }
302         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
303             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
304             oraclize_setNetworkName("eth_kovan");
305             return true;
306         }
307         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
308             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
309             oraclize_setNetworkName("eth_rinkeby");
310             return true;
311         }
312         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
313             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
314             return true;
315         }
316         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
317             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
318             return true;
319         }
320         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
321             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
322             return true;
323         }
324         return false;
325     }
326 
327     function __callback(bytes32 myid, string result) public {
328         __callback(myid, result, new bytes(0));
329     }
330     function __callback(bytes32 myid, string result, bytes proof) public {
331       return;
332       myid; result; proof; // Silence compiler warnings
333     }
334 
335     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
336         return oraclize.getPrice(datasource);
337     }
338 
339     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
340         return oraclize.getPrice(datasource, gaslimit);
341     }
342 
343     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
344         uint price = oraclize.getPrice(datasource);
345         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
346         return oraclize.query.value(price)(0, datasource, arg);
347     }
348     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource);
350         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
351         return oraclize.query.value(price)(timestamp, datasource, arg);
352     }
353     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource, gaslimit);
355         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
356         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
357     }
358     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
359         uint price = oraclize.getPrice(datasource, gaslimit);
360         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
361         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
362     }
363     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
364         uint price = oraclize.getPrice(datasource);
365         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
366         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
367     }
368     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
369         uint price = oraclize.getPrice(datasource);
370         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
371         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
372     }
373     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
374         uint price = oraclize.getPrice(datasource, gaslimit);
375         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
376         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
377     }
378     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource, gaslimit);
380         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
381         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
382     }
383     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         bytes memory args = stra2cbor(argN);
387         return oraclize.queryN.value(price)(0, datasource, args);
388     }
389     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         bytes memory args = stra2cbor(argN);
393         return oraclize.queryN.value(price)(timestamp, datasource, args);
394     }
395     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         bytes memory args = stra2cbor(argN);
399         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
400     }
401     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         bytes memory args = stra2cbor(argN);
405         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
406     }
407     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
408         string[] memory dynargs = new string[](1);
409         dynargs[0] = args[0];
410         return oraclize_query(datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
413         string[] memory dynargs = new string[](1);
414         dynargs[0] = args[0];
415         return oraclize_query(timestamp, datasource, dynargs);
416     }
417     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
418         string[] memory dynargs = new string[](1);
419         dynargs[0] = args[0];
420         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
421     }
422     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         string[] memory dynargs = new string[](1);
424         dynargs[0] = args[0];
425         return oraclize_query(datasource, dynargs, gaslimit);
426     }
427 
428     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
429         string[] memory dynargs = new string[](2);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         return oraclize_query(datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](2);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         return oraclize_query(timestamp, datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](2);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](3);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         dynargs[2] = args[2];
457         return oraclize_query(datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](3);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         return oraclize_query(timestamp, datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         string[] memory dynargs = new string[](3);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480 
481     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](4);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](4);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](4);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
514         string[] memory dynargs = new string[](5);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         dynargs[4] = args[4];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(timestamp, datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         string[] memory dynargs = new string[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(datasource, dynargs, gaslimit);
548     }
549     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
550         uint price = oraclize.getPrice(datasource);
551         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
552         bytes memory args = ba2cbor(argN);
553         return oraclize.queryN.value(price)(0, datasource, args);
554     }
555     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
556         uint price = oraclize.getPrice(datasource);
557         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
558         bytes memory args = ba2cbor(argN);
559         return oraclize.queryN.value(price)(timestamp, datasource, args);
560     }
561     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
562         uint price = oraclize.getPrice(datasource, gaslimit);
563         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
564         bytes memory args = ba2cbor(argN);
565         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
566     }
567     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
568         uint price = oraclize.getPrice(datasource, gaslimit);
569         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
570         bytes memory args = ba2cbor(argN);
571         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
572     }
573     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](1);
575         dynargs[0] = args[0];
576         return oraclize_query(datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
579         bytes[] memory dynargs = new bytes[](1);
580         dynargs[0] = args[0];
581         return oraclize_query(timestamp, datasource, dynargs);
582     }
583     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
584         bytes[] memory dynargs = new bytes[](1);
585         dynargs[0] = args[0];
586         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
587     }
588     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
589         bytes[] memory dynargs = new bytes[](1);
590         dynargs[0] = args[0];
591         return oraclize_query(datasource, dynargs, gaslimit);
592     }
593 
594     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
595         bytes[] memory dynargs = new bytes[](2);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         return oraclize_query(datasource, dynargs);
599     }
600     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](2);
602         dynargs[0] = args[0];
603         dynargs[1] = args[1];
604         return oraclize_query(timestamp, datasource, dynargs);
605     }
606     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](2);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](2);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         return oraclize_query(datasource, dynargs, gaslimit);
617     }
618     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](3);
620         dynargs[0] = args[0];
621         dynargs[1] = args[1];
622         dynargs[2] = args[2];
623         return oraclize_query(datasource, dynargs);
624     }
625     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](3);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         dynargs[2] = args[2];
630         return oraclize_query(timestamp, datasource, dynargs);
631     }
632     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
633         bytes[] memory dynargs = new bytes[](3);
634         dynargs[0] = args[0];
635         dynargs[1] = args[1];
636         dynargs[2] = args[2];
637         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
638     }
639     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](3);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         dynargs[2] = args[2];
644         return oraclize_query(datasource, dynargs, gaslimit);
645     }
646 
647     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](4);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         dynargs[3] = args[3];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](4);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         dynargs[3] = args[3];
661         return oraclize_query(timestamp, datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](4);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
670     }
671     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](4);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         return oraclize_query(datasource, dynargs, gaslimit);
678     }
679     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
680         bytes[] memory dynargs = new bytes[](5);
681         dynargs[0] = args[0];
682         dynargs[1] = args[1];
683         dynargs[2] = args[2];
684         dynargs[3] = args[3];
685         dynargs[4] = args[4];
686         return oraclize_query(datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](5);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         dynargs[3] = args[3];
694         dynargs[4] = args[4];
695         return oraclize_query(timestamp, datasource, dynargs);
696     }
697     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
698         bytes[] memory dynargs = new bytes[](5);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         dynargs[2] = args[2];
702         dynargs[3] = args[3];
703         dynargs[4] = args[4];
704         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
705     }
706     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](5);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         dynargs[4] = args[4];
713         return oraclize_query(datasource, dynargs, gaslimit);
714     }
715 
716     function oraclize_cbAddress() oraclizeAPI internal returns (address){
717         return oraclize.cbAddress();
718     }
719     function oraclize_setProof(byte proofP) oraclizeAPI internal {
720         return oraclize.setProofType(proofP);
721     }
722     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
723         return oraclize.setCustomGasPrice(gasPrice);
724     }
725 
726     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
727         return oraclize.randomDS_getSessionPubKeyHash();
728     }
729 
730     function getCodeSize(address _addr) constant internal returns(uint _size) {
731         assembly {
732             _size := extcodesize(_addr)
733         }
734     }
735 
736     function parseAddr(string _a) internal pure returns (address){
737         bytes memory tmp = bytes(_a);
738         uint160 iaddr = 0;
739         uint160 b1;
740         uint160 b2;
741         for (uint i=2; i<2+2*20; i+=2){
742             iaddr *= 256;
743             b1 = uint160(tmp[i]);
744             b2 = uint160(tmp[i+1]);
745             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
746             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
747             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
748             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
749             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
750             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
751             iaddr += (b1*16+b2);
752         }
753         return address(iaddr);
754     }
755 
756     function strCompare(string _a, string _b) internal pure returns (int) {
757         bytes memory a = bytes(_a);
758         bytes memory b = bytes(_b);
759         uint minLength = a.length;
760         if (b.length < minLength) minLength = b.length;
761         for (uint i = 0; i < minLength; i ++)
762             if (a[i] < b[i])
763                 return -1;
764             else if (a[i] > b[i])
765                 return 1;
766         if (a.length < b.length)
767             return -1;
768         else if (a.length > b.length)
769             return 1;
770         else
771             return 0;
772     }
773 
774     function indexOf(string _haystack, string _needle) internal pure returns (int) {
775         bytes memory h = bytes(_haystack);
776         bytes memory n = bytes(_needle);
777         if(h.length < 1 || n.length < 1 || (n.length > h.length))
778             return -1;
779         else if(h.length > (2**128 -1))
780             return -1;
781         else
782         {
783             uint subindex = 0;
784             for (uint i = 0; i < h.length; i ++)
785             {
786                 if (h[i] == n[0])
787                 {
788                     subindex = 1;
789                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
790                     {
791                         subindex++;
792                     }
793                     if(subindex == n.length)
794                         return int(i);
795                 }
796             }
797             return -1;
798         }
799     }
800 
801     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
802         bytes memory _ba = bytes(_a);
803         bytes memory _bb = bytes(_b);
804         bytes memory _bc = bytes(_c);
805         bytes memory _bd = bytes(_d);
806         bytes memory _be = bytes(_e);
807         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
808         bytes memory babcde = bytes(abcde);
809         uint k = 0;
810         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
811         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
812         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
813         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
814         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
815         return string(babcde);
816     }
817 
818     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
819         return strConcat(_a, _b, _c, _d, "");
820     }
821 
822     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
823         return strConcat(_a, _b, _c, "", "");
824     }
825 
826     function strConcat(string _a, string _b) internal pure returns (string) {
827         return strConcat(_a, _b, "", "", "");
828     }
829 
830     // parseInt
831     function parseInt(string _a) internal pure returns (uint) {
832         return parseInt(_a, 0);
833     }
834 
835     // parseInt(parseFloat*10^_b)
836     function parseInt(string _a, uint _b) internal pure returns (uint) {
837         bytes memory bresult = bytes(_a);
838         uint mint = 0;
839         bool decimals = false;
840         for (uint i=0; i<bresult.length; i++){
841             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
842                 if (decimals){
843                    if (_b == 0) break;
844                     else _b--;
845                 }
846                 mint *= 10;
847                 mint += uint(bresult[i]) - 48;
848             } else if (bresult[i] == 46) decimals = true;
849         }
850         if (_b > 0) mint *= 10**_b;
851         return mint;
852     }
853 
854     function uint2str(uint i) internal pure returns (string){
855         if (i == 0) return "0";
856         uint j = i;
857         uint len;
858         while (j != 0){
859             len++;
860             j /= 10;
861         }
862         bytes memory bstr = new bytes(len);
863         uint k = len - 1;
864         while (i != 0){
865             bstr[k--] = byte(48 + i % 10);
866             i /= 10;
867         }
868         return string(bstr);
869     }
870 
871     using CBOR for Buffer.buffer;
872     function stra2cbor(string[] arr) internal pure returns (bytes) {
873         safeMemoryCleaner();
874         Buffer.buffer memory buf;
875         Buffer.init(buf, 1024);
876         buf.startArray();
877         for (uint i = 0; i < arr.length; i++) {
878             buf.encodeString(arr[i]);
879         }
880         buf.endSequence();
881         return buf.buf;
882     }
883 
884     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
885         safeMemoryCleaner();
886         Buffer.buffer memory buf;
887         Buffer.init(buf, 1024);
888         buf.startArray();
889         for (uint i = 0; i < arr.length; i++) {
890             buf.encodeBytes(arr[i]);
891         }
892         buf.endSequence();
893         return buf.buf;
894     }
895 
896     string oraclize_network_name;
897     function oraclize_setNetworkName(string _network_name) internal {
898         oraclize_network_name = _network_name;
899     }
900 
901     function oraclize_getNetworkName() internal view returns (string) {
902         return oraclize_network_name;
903     }
904 
905     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
906         require((_nbytes > 0) && (_nbytes <= 32));
907         // Convert from seconds to ledger timer ticks
908         _delay *= 10;
909         bytes memory nbytes = new bytes(1);
910         nbytes[0] = byte(_nbytes);
911         bytes memory unonce = new bytes(32);
912         bytes memory sessionKeyHash = new bytes(32);
913         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
914         assembly {
915             mstore(unonce, 0x20)
916             // the following variables can be relaxed
917             // check relaxed random contract under ethereum-examples repo
918             // for an idea on how to override and replace comit hash vars
919             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
920             mstore(sessionKeyHash, 0x20)
921             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
922         }
923         bytes memory delay = new bytes(32);
924         assembly {
925             mstore(add(delay, 0x20), _delay)
926         }
927 
928         bytes memory delay_bytes8 = new bytes(8);
929         copyBytes(delay, 24, 8, delay_bytes8, 0);
930 
931         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
932         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
933 
934         bytes memory delay_bytes8_left = new bytes(8);
935 
936         assembly {
937             let x := mload(add(delay_bytes8, 0x20))
938             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
939             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
940             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
941             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
942             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
943             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
944             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
945             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
946 
947         }
948 
949         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
950         return queryId;
951     }
952 
953     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
954         oraclize_randomDS_args[queryId] = commitment;
955     }
956 
957     mapping(bytes32=>bytes32) oraclize_randomDS_args;
958     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
959 
960     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
961         bool sigok;
962         address signer;
963 
964         bytes32 sigr;
965         bytes32 sigs;
966 
967         bytes memory sigr_ = new bytes(32);
968         uint offset = 4+(uint(dersig[3]) - 0x20);
969         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
970         bytes memory sigs_ = new bytes(32);
971         offset += 32 + 2;
972         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
973 
974         assembly {
975             sigr := mload(add(sigr_, 32))
976             sigs := mload(add(sigs_, 32))
977         }
978 
979 
980         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
981         if (address(keccak256(pubkey)) == signer) return true;
982         else {
983             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
984             return (address(keccak256(pubkey)) == signer);
985         }
986     }
987 
988     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
989         bool sigok;
990 
991         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
992         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
993         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
994 
995         bytes memory appkey1_pubkey = new bytes(64);
996         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
997 
998         bytes memory tosign2 = new bytes(1+65+32);
999         tosign2[0] = byte(1); //role
1000         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1001         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1002         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1003         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1004 
1005         if (sigok == false) return false;
1006 
1007 
1008         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1009         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1010 
1011         bytes memory tosign3 = new bytes(1+65);
1012         tosign3[0] = 0xFE;
1013         copyBytes(proof, 3, 65, tosign3, 1);
1014 
1015         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1016         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1017 
1018         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1019 
1020         return sigok;
1021     }
1022 
1023     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1024         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1025         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1026 
1027         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1028         require(proofVerified);
1029 
1030         _;
1031     }
1032 
1033     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1034         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1035         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1036 
1037         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1038         if (proofVerified == false) return 2;
1039 
1040         return 0;
1041     }
1042 
1043     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1044         bool match_ = true;
1045 
1046         require(prefix.length == n_random_bytes);
1047 
1048         for (uint256 i=0; i< n_random_bytes; i++) {
1049             if (content[i] != prefix[i]) match_ = false;
1050         }
1051 
1052         return match_;
1053     }
1054 
1055     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1056 
1057         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1058         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1059         bytes memory keyhash = new bytes(32);
1060         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1061         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1062 
1063         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1064         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1065 
1066         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1067         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1068 
1069         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1070         // This is to verify that the computed args match with the ones specified in the query.
1071         bytes memory commitmentSlice1 = new bytes(8+1+32);
1072         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1073 
1074         bytes memory sessionPubkey = new bytes(64);
1075         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1076         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1077 
1078         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1079         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1080             delete oraclize_randomDS_args[queryId];
1081         } else return false;
1082 
1083 
1084         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1085         bytes memory tosign1 = new bytes(32+8+1+32);
1086         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1087         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1088 
1089         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1090         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1091             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1092         }
1093 
1094         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1095     }
1096 
1097     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1098     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1099         uint minLength = length + toOffset;
1100 
1101         // Buffer too small
1102         require(to.length >= minLength); // Should be a better way?
1103 
1104         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1105         uint i = 32 + fromOffset;
1106         uint j = 32 + toOffset;
1107 
1108         while (i < (32 + fromOffset + length)) {
1109             assembly {
1110                 let tmp := mload(add(from, i))
1111                 mstore(add(to, j), tmp)
1112             }
1113             i += 32;
1114             j += 32;
1115         }
1116 
1117         return to;
1118     }
1119 
1120     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1121     // Duplicate Solidity's ecrecover, but catching the CALL return value
1122     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1123         // We do our own memory management here. Solidity uses memory offset
1124         // 0x40 to store the current end of memory. We write past it (as
1125         // writes are memory extensions), but don't update the offset so
1126         // Solidity will reuse it. The memory used here is only needed for
1127         // this context.
1128 
1129         // FIXME: inline assembly can't access return values
1130         bool ret;
1131         address addr;
1132 
1133         assembly {
1134             let size := mload(0x40)
1135             mstore(size, hash)
1136             mstore(add(size, 32), v)
1137             mstore(add(size, 64), r)
1138             mstore(add(size, 96), s)
1139 
1140             // NOTE: we can reuse the request memory because we deal with
1141             //       the return code
1142             ret := call(3000, 1, 0, size, 128, size, 32)
1143             addr := mload(size)
1144         }
1145 
1146         return (ret, addr);
1147     }
1148 
1149     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1150     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1151         bytes32 r;
1152         bytes32 s;
1153         uint8 v;
1154 
1155         if (sig.length != 65)
1156           return (false, 0);
1157 
1158         // The signature format is a compact form of:
1159         //   {bytes32 r}{bytes32 s}{uint8 v}
1160         // Compact means, uint8 is not padded to 32 bytes.
1161         assembly {
1162             r := mload(add(sig, 32))
1163             s := mload(add(sig, 64))
1164 
1165             // Here we are loading the last 32 bytes. We exploit the fact that
1166             // 'mload' will pad with zeroes if we overread.
1167             // There is no 'mload8' to do this, but that would be nicer.
1168             v := byte(0, mload(add(sig, 96)))
1169 
1170             // Alternative solution:
1171             // 'byte' is not working due to the Solidity parser, so lets
1172             // use the second best option, 'and'
1173             // v := and(mload(add(sig, 65)), 255)
1174         }
1175 
1176         // albeit non-transactional signatures are not specified by the YP, one would expect it
1177         // to match the YP range of [27, 28]
1178         //
1179         // geth uses [0, 1] and some clients have followed. This might change, see:
1180         //  https://github.com/ethereum/go-ethereum/issues/2053
1181         if (v < 27)
1182           v += 27;
1183 
1184         if (v != 27 && v != 28)
1185             return (false, 0);
1186 
1187         return safer_ecrecover(hash, v, r, s);
1188     }
1189 
1190     function safeMemoryCleaner() internal pure {
1191         assembly {
1192             let fmem := mload(0x40)
1193             codecopy(fmem, codesize, sub(msize, fmem))
1194         }
1195     }
1196 
1197 }
1198 // </ORACLIZE_API>
1199 
1200 // ----------------------------------------------------------------------------
1201 // Safe maths
1202 // ----------------------------------------------------------------------------
1203 /**
1204  * @title SafeMath
1205  * @dev Math operations with safety checks that throw on error
1206  */
1207 library SafeMath {
1208 
1209   /**
1210   * @dev Multiplies two numbers, throws on overflow.
1211   */
1212   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1213     if (a == 0) {
1214       return 0;
1215     }
1216     uint256 c = a * b;
1217     assert(c / a == b);
1218     return c;
1219   }
1220 
1221   /**
1222   * @dev Integer division of two numbers, truncating the quotient.
1223   */
1224   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1225     
1226     return a / b;
1227   }
1228 
1229   /**
1230   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1231   */
1232   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1233     assert(b <= a);
1234     return a - b;
1235   }
1236 
1237   /**
1238   * @dev Adds two numbers, throws on overflow.
1239   */
1240   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1241     uint256 c = a + b;
1242     assert(c >= a);
1243     return c;
1244   }
1245 }
1246 
1247 // ----------------------------------------------------------------------------
1248 // Ownership functionality for authorization controls and user permissions
1249 // ----------------------------------------------------------------------------
1250 /**
1251  * @title Ownable
1252  * @dev The Ownable contract has an owner address, and provides basic authorization control
1253  * functions, this simplifies the implementation of "user permissions".
1254  */
1255 contract Ownable {
1256   address public owner;
1257 
1258 
1259   event OwnershipRenounced(address indexed previousOwner);
1260   event OwnershipTransferred(
1261     address indexed previousOwner,
1262     address indexed newOwner
1263   );
1264 
1265 
1266   /**
1267    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1268    * account.
1269    */
1270   constructor() public {
1271     owner = msg.sender;
1272   }
1273 
1274   /**
1275    * @dev Throws if called by any account other than the owner.
1276    */
1277   modifier onlyOwner() {
1278     require(msg.sender == owner);
1279     _;
1280   }
1281 
1282   /**
1283    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1284    * @param newOwner The address to transfer ownership to.
1285    */
1286   function transferOwnership(address newOwner) public onlyOwner {
1287     require(newOwner != address(0));
1288     emit OwnershipTransferred(owner, newOwner);
1289     owner = newOwner;
1290   }
1291 
1292   /**
1293    * @dev Allows the current owner to relinquish control of the contract.
1294    */
1295   function renounceOwnership() public onlyOwner {
1296     emit OwnershipRenounced(owner);
1297     owner = address(0);
1298   }
1299 }
1300 
1301 // ERC20 Standard Interface
1302 // ----------------------------------------------------------------------------
1303 /**
1304  * @title ERC20Basic
1305  * @dev Simpler version of ERC20 interface
1306  * @dev see https://github.com/ethereum/EIPs/issues/179
1307  */
1308 contract ERC20Basic {
1309   function totalSupply() public view returns (uint256);
1310   function balanceOf(address who) public view returns (uint256);
1311   function transfer(address to, uint256 value) public returns (bool);
1312   event Transfer(address indexed from, address indexed to, uint256 value);
1313 }
1314 
1315 
1316 /**
1317  * @title ERC20 interface
1318  * @dev see https://github.com/ethereum/EIPs/issues/20
1319  */
1320 contract ERC20 is ERC20Basic {
1321   function allowance(address owner, address spender)
1322     public view returns (uint256);
1323 
1324   function transferFrom(address from, address to, uint256 value)
1325     public returns (bool);
1326 
1327   function approve(address spender, uint256 value) public returns (bool);
1328   event Approval(
1329     address indexed owner,
1330     address indexed spender,
1331     uint256 value
1332   );
1333 }
1334 
1335 // ----------------------------------------------------------------------------
1336 // Basic version of StandardToken, with no allowances.
1337 // ----------------------------------------------------------------------------
1338 
1339 /**
1340  * @title Basic token
1341  * @dev Basic version of StandardToken, with no allowances.
1342  */
1343 contract BasicToken is ERC20Basic {
1344   using SafeMath for uint256;
1345 
1346   mapping(address => uint256) balances;
1347 
1348   uint256 totalSupply_;
1349 
1350   /**
1351   * @dev total number of tokens in existence
1352   */
1353   function totalSupply() public view returns (uint256) {
1354     return totalSupply_;
1355   }
1356 
1357   /**
1358   * @dev transfer token for a specified address
1359   * @param _to The address to transfer to.
1360   * @param _value The amount to be transferred.
1361   */
1362   function transfer(address _to, uint256 _value) public returns (bool) {
1363     require(_to != address(0));
1364     require(_value <= balances[msg.sender]);
1365 
1366     balances[msg.sender] = balances[msg.sender].sub(_value);
1367     balances[_to] = balances[_to].add(_value);
1368     emit Transfer(msg.sender, _to, _value);
1369     return true;
1370   }
1371 
1372   /**
1373   * @dev Gets the balance of the specified address.
1374   * @param _owner The address to query the the balance of.
1375   * @return An uint256 representing the amount owned by the passed address.
1376   */
1377   function balanceOf(address _owner) public view returns (uint256) {
1378     return balances[_owner];
1379   }
1380 }
1381 
1382 /**
1383  * @title Standard ERC20 token
1384  *
1385  * @dev Implementation of the basic standard token.
1386  * @dev https://github.com/ethereum/EIPs/issues/20
1387  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1388  */
1389 contract StandardToken is ERC20, BasicToken {
1390 
1391   mapping (address => mapping (address => uint256)) internal allowed;
1392 
1393 
1394   /**
1395    * @dev Transfer tokens from one address to another
1396    * @param _from address The address which you want to send tokens from
1397    * @param _to address The address which you want to transfer to
1398    * @param _value uint256 the amount of tokens to be transferred
1399    */
1400   function transferFrom(
1401     address _from,
1402     address _to,
1403     uint256 _value
1404   )
1405     public
1406     returns (bool)
1407   {
1408     require(_to != address(0));
1409     require(_value <= balances[_from]);
1410     require(_value <= allowed[_from][msg.sender]);
1411 
1412     balances[_from] = balances[_from].sub(_value);
1413     balances[_to] = balances[_to].add(_value);
1414     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1415     emit Transfer(_from, _to, _value);
1416     return true;
1417   }
1418 
1419   /**
1420    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1421    *
1422    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1423    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1424    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1425    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1426    * @param _spender The address which will spend the funds.
1427    * @param _value The amount of tokens to be spent.
1428    */
1429   function approve(address _spender, uint256 _value) public returns (bool) {
1430     allowed[msg.sender][_spender] = _value;
1431     emit Approval(msg.sender, _spender, _value);
1432     return true;
1433   }
1434 
1435   /**
1436    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1437    * @param _owner address The address which owns the funds.
1438    * @param _spender address The address which will spend the funds.
1439    * @return A uint256 specifying the amount of tokens still available for the spender.
1440    */
1441   function allowance(
1442     address _owner,
1443     address _spender
1444    )
1445     public
1446     view
1447     returns (uint256)
1448   {
1449     return allowed[_owner][_spender];
1450   }
1451 
1452   /**
1453    * @dev Increase the amount of tokens that an owner allowed to a spender.
1454    *
1455    * approve should be called when allowed[_spender] == 0. To increment
1456    * allowed value is better to use this function to avoid 2 calls (and wait until
1457    * the first transaction is mined)
1458    * From MonolithDAO Token.sol
1459    * @param _spender The address which will spend the funds.
1460    * @param _addedValue The amount of tokens to increase the allowance by.
1461    */
1462   function increaseApproval(
1463     address _spender,
1464     uint _addedValue
1465   )
1466     public
1467     returns (bool)
1468   {
1469     allowed[msg.sender][_spender] = (
1470       allowed[msg.sender][_spender].add(_addedValue));
1471     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1472     return true;
1473   }
1474 
1475   /**
1476    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1477    *
1478    * approve should be called when allowed[_spender] == 0. To decrement
1479    * allowed value is better to use this function to avoid 2 calls (and wait until
1480    * the first transaction is mined)
1481    * From MonolithDAO Token.sol
1482    * @param _spender The address which will spend the funds.
1483    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1484    */
1485   function decreaseApproval(
1486     address _spender,
1487     uint _subtractedValue
1488   )
1489     public
1490     returns (bool)
1491   {
1492     uint oldValue = allowed[msg.sender][_spender];
1493     if (_subtractedValue > oldValue) {
1494       allowed[msg.sender][_spender] = 0;
1495     } else {
1496       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1497     }
1498     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1499     return true;
1500   }
1501 }
1502 
1503 
1504 
1505 /**
1506  * @title Burnable Token
1507  * @dev Token that can be irreversibly burned (destroyed).
1508  */
1509 contract BurnableToken is BasicToken {
1510 
1511   event Burn(address indexed burner, uint256 value);
1512 
1513   /**
1514    * @dev Burns a specific amount of tokens.
1515    * @param _value The amount of token to be burned.
1516    */
1517   function burn(uint256 _value) public {
1518     _burn(msg.sender, _value);
1519   }
1520 
1521   function _burn(address _who, uint256 _value) internal {
1522     require(_value <= balances[_who]);
1523     // no need to require value <= totalSupply, since that would imply the
1524     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1525 
1526     balances[_who] = balances[_who].sub(_value);
1527     totalSupply_ = totalSupply_.sub(_value);
1528     emit Burn(_who, _value);
1529     emit Transfer(_who, address(0), _value);
1530   }
1531 }
1532 
1533 /**
1534  * @title Standard Burnable Token
1535  * @dev Adds burnFrom method to ERC20 implementations
1536  */
1537 contract StandardBurnableToken is BurnableToken, StandardToken {
1538 
1539   /**
1540    * @dev Burns a specific amount of tokens from the target address and decrements allowance
1541    * @param _from address The address which you want to send tokens from
1542    * @param _value uint256 The amount of token to be burned
1543    */
1544   function burnFrom(address _from, uint256 _value) public {
1545     require(_value <= allowed[_from][msg.sender]);
1546     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1547     // this function needs to emit an event with the updated approval.
1548     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1549     _burn(_from, _value);
1550   }
1551 }
1552 
1553 
1554 contract VictorieumToken is StandardBurnableToken, Ownable, usingOraclize {
1555 
1556   using SafeMath for uint256;
1557 
1558   string public symbol = "VTM";
1559   string public name = "Victorieum";
1560   uint256 public decimals = 18;
1561   uint public ETHUSD;
1562   uint presaleEndsAt;
1563   uint startDate;
1564   uint firstStageEndsAt;
1565   uint secondStageEndsAt;
1566   uint thirdStageEndsAt;
1567   uint forthStageEndsAt;
1568   uint endDate;
1569   uint currentpriceincent;
1570   uint bonus;
1571   uint256 public icoSupply = 0;
1572   uint256 public icoLimit = 765000000000000000000000000;
1573   event LogConstructorInitiated(string nextStep);
1574   event LogPriceUpdated(string price);
1575   event LogNewOraclizeQuery(string description);
1576 
1577 
1578   
1579   
1580 
1581   function transfer(address _to, uint256 _value) 
1582   public  
1583   returns (bool) {
1584     super.transfer(_to,_value);
1585   }
1586 
1587   function transferFrom(address _from, address _to, uint256 _value) 
1588   public  
1589   returns (bool) {
1590     super.transferFrom(_from, _to, _value);
1591   }
1592 
1593   function approve(address _spender, uint256 _value) 
1594   public  
1595   returns (bool) {
1596     super.approve(_spender, _value);
1597   }
1598 
1599   function increaseApproval(address _spender, uint _addedValue) 
1600   public  
1601   returns (bool) {
1602     super.increaseApproval(_spender, _addedValue);
1603   }
1604 
1605   function decreaseApproval(address _spender, uint _subtractedValue) 
1606   public  
1607   returns (bool) {
1608     super.decreaseApproval(_spender, _subtractedValue);
1609   }
1610 
1611   /**
1612    * @dev Transfer ownership now transfers all owners tokens to new owner 
1613    */
1614   function transferOwnership(address newOwner) public onlyOwner {
1615     balances[newOwner] = balances[newOwner].add(balances[owner]);
1616     emit Transfer(owner, newOwner, balances[owner]);
1617     balances[owner] = 0;
1618 
1619     super.transferOwnership(newOwner);
1620   }
1621 
1622   /* ICO status */
1623   enum State {
1624     Active,
1625     Closed
1626   }
1627 
1628   event Closed();
1629 
1630   State public state;
1631 
1632   // ------------------------------------------------------------------------
1633   // Constructor
1634   // ------------------------------------------------------------------------
1635   constructor() public payable {
1636   
1637     owner = msg.sender;
1638     totalSupply_ = 1000000000000000000000000000;
1639     balances[owner] = totalSupply_;
1640     emit Transfer(address(0), owner, totalSupply_);
1641     
1642     state = State.Active;
1643     startDate = 1539993600 ; // Oct 20 2018, 00:01 AM
1644     presaleEndsAt = 1541376000; // ;   // Nov 04 2018, 11:59 PM
1645     firstStageEndsAt = 1542758400;   // Nov 20 2018, 11:59 PM
1646     secondStageEndsAt = 1544140800;   // Dec 06 2018, 11:59 PM
1647     thirdStageEndsAt = 1545523200;   // Dec 22 2018, 11:59 PM
1648     forthStageEndsAt = 1546905600;   // Jan 07 2019, 11:59 PM
1649     endDate = 1548028799;   // Jan 20 2019, 11:59 PM
1650 
1651     // to update ETH Price 
1652     //oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1653     updatePrice(60);
1654     
1655   }
1656 
1657   /**
1658    * @dev all ether transfer to another wallet automatic
1659    */
1660   function () public payable {
1661     require(state == State.Active); // Reject the transactions after ICO ended
1662     // production code to start accepting payment and stop  
1663     require(now >= startDate && now <= endDate);
1664     currentpriceincent = 24;
1665     bonus = 0;
1666     if (now < presaleEndsAt)
1667     {
1668         currentpriceincent = 1;
1669         bonus = 40;
1670     }
1671     else if (now < firstStageEndsAt)
1672     {
1673         currentpriceincent = 6;
1674         bonus = 35;
1675     }
1676     else if (now < secondStageEndsAt)
1677     {
1678         currentpriceincent = 9;
1679         bonus = 30;
1680     }
1681     else if (now < thirdStageEndsAt)
1682     {
1683         currentpriceincent = 12;
1684         bonus = 25;
1685     }
1686     else if (now < forthStageEndsAt)
1687     {
1688         currentpriceincent = 16;
1689         bonus = 20;
1690     }
1691     else if (now < endDate)
1692     {
1693         currentpriceincent = 21;
1694         bonus = 15;
1695         
1696     }
1697     else
1698     {
1699         currentpriceincent = 24;
1700         bonus = 0;
1701     }
1702    
1703     uint256 tokens = msg.value * ETHUSD / currentpriceincent;
1704     tokens = tokens + (tokens * bonus/100);
1705     balances[msg.sender] = balances[msg.sender].add(tokens);
1706     balances[owner] = balances[owner].sub(tokens);
1707     require(icoSupply.add(tokens) <= icoLimit);
1708     icoSupply = icoSupply.add(tokens);
1709     emit Transfer(owner, msg.sender, tokens);
1710     owner.transfer(msg.value);
1711   }
1712 
1713 
1714     function __callback(bytes32 myid, string result) {
1715         if (msg.sender != oraclize_cbAddress()) revert();
1716         ETHUSD = parseInt(result,2);
1717         emit LogPriceUpdated(result);
1718 	    updatePrice(10800); // updates ETHUSD each 3 hours 
1719     }
1720 
1721     function updatePrice(uint time_interval) payable {
1722         require(now <= endDate); // end all updates transaction for eth to usd conversion after ICO
1723         if (oraclize_getPrice("URL") > this.balance) {
1724             emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1725         } else {
1726             emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1727             oraclize_query(time_interval, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1728         }
1729         
1730         
1731         
1732     }
1733 
1734 
1735 
1736   /**
1737   * After ICO close it helps to lock tokens for pools
1738   **/
1739   function close() onlyOwner public {
1740     require(state == State.Active);
1741     state = State.Closed;
1742     emit Closed();
1743   }
1744 }