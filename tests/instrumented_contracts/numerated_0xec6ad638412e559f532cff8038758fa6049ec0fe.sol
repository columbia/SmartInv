1 pragma solidity ^0.4.24;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
41     function getPrice(string _datasource) public returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
43     function setProofType(byte _proofType) external;
44     function setCustomGasPrice(uint _gasPrice) external;
45     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
46 }
47 
48 contract OraclizeAddrResolverI {
49     function getAddress() public returns (address _addr);
50 }
51 
52 
53 library Buffer {
54     struct buffer {
55         bytes buf;
56         uint capacity;
57     }
58 
59     function init(buffer memory buf, uint _capacity) internal pure {
60         uint capacity = _capacity;
61         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
62         // Allocate space for the buffer data
63         buf.capacity = capacity;
64         assembly {
65             let ptr := mload(0x40)
66             mstore(buf, ptr)
67             mstore(ptr, 0)
68             mstore(0x40, add(ptr, capacity))
69         }
70     }
71 
72     function resize(buffer memory buf, uint capacity) private pure {
73         bytes memory oldbuf = buf.buf;
74         init(buf, capacity);
75         append(buf, oldbuf);
76     }
77 
78     function max(uint a, uint b) private pure returns(uint) {
79         if(a > b) {
80             return a;
81         }
82         return b;
83     }
84 
85     /**
86      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
87      *      would exceed the capacity of the buffer.
88      * @param buf The buffer to append to.
89      * @param data The data to append.
90      * @return The original buffer.
91      */
92     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
93         if(data.length + buf.buf.length > buf.capacity) {
94             resize(buf, max(buf.capacity, data.length) * 2);
95         }
96 
97         uint dest;
98         uint src;
99         uint len = data.length;
100         assembly {
101             // Memory address of the buffer data
102             let bufptr := mload(buf)
103             // Length of existing buffer data
104             let buflen := mload(bufptr)
105             // Start address = buffer address + buffer length + sizeof(buffer length)
106             dest := add(add(bufptr, buflen), 32)
107             // Update buffer length
108             mstore(bufptr, add(buflen, mload(data)))
109             src := add(data, 32)
110         }
111 
112         // Copy word-length chunks while possible
113         for(; len >= 32; len -= 32) {
114             assembly {
115                 mstore(dest, mload(src))
116             }
117             dest += 32;
118             src += 32;
119         }
120 
121         // Copy remaining bytes
122         uint mask = 256 ** (32 - len) - 1;
123         assembly {
124             let srcpart := and(mload(src), not(mask))
125             let destpart := and(mload(dest), mask)
126             mstore(dest, or(destpart, srcpart))
127         }
128 
129         return buf;
130     }
131 
132     /**
133      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
134      * exceed the capacity of the buffer.
135      * @param buf The buffer to append to.
136      * @param data The data to append.
137      * @return The original buffer.
138      */
139     function append(buffer memory buf, uint8 data) internal pure {
140         if(buf.buf.length + 1 > buf.capacity) {
141             resize(buf, buf.capacity * 2);
142         }
143 
144         assembly {
145             // Memory address of the buffer data
146             let bufptr := mload(buf)
147             // Length of existing buffer data
148             let buflen := mload(bufptr)
149             // Address = buffer address + buffer length + sizeof(buffer length)
150             let dest := add(add(bufptr, buflen), 32)
151             mstore8(dest, data)
152             // Update buffer length
153             mstore(bufptr, add(buflen, 1))
154         }
155     }
156 
157     /**
158      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
159      * exceed the capacity of the buffer.
160      * @param buf The buffer to append to.
161      * @param data The data to append.
162      * @return The original buffer.
163      */
164     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
165         if(len + buf.buf.length > buf.capacity) {
166             resize(buf, max(buf.capacity, len) * 2);
167         }
168 
169         uint mask = 256 ** len - 1;
170         assembly {
171             // Memory address of the buffer data
172             let bufptr := mload(buf)
173             // Length of existing buffer data
174             let buflen := mload(bufptr)
175             // Address = buffer address + buffer length + sizeof(buffer length) + len
176             let dest := add(add(bufptr, buflen), len)
177             mstore(dest, or(and(mload(dest), not(mask)), data))
178             // Update buffer length
179             mstore(bufptr, add(buflen, len))
180         }
181         return buf;
182     }
183 }
184 
185 library CBOR {
186     using Buffer for Buffer.buffer;
187 
188     uint8 private constant MAJOR_TYPE_INT = 0;
189     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
190     uint8 private constant MAJOR_TYPE_BYTES = 2;
191     uint8 private constant MAJOR_TYPE_STRING = 3;
192     uint8 private constant MAJOR_TYPE_ARRAY = 4;
193     uint8 private constant MAJOR_TYPE_MAP = 5;
194     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
195 
196     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
197         if(value <= 23) {
198             buf.append(uint8((major << 5) | value));
199         } else if(value <= 0xFF) {
200             buf.append(uint8((major << 5) | 24));
201             buf.appendInt(value, 1);
202         } else if(value <= 0xFFFF) {
203             buf.append(uint8((major << 5) | 25));
204             buf.appendInt(value, 2);
205         } else if(value <= 0xFFFFFFFF) {
206             buf.append(uint8((major << 5) | 26));
207             buf.appendInt(value, 4);
208         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
209             buf.append(uint8((major << 5) | 27));
210             buf.appendInt(value, 8);
211         }
212     }
213 
214     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
215         buf.append(uint8((major << 5) | 31));
216     }
217 
218     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
219         encodeType(buf, MAJOR_TYPE_INT, value);
220     }
221 
222     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
223         if(value >= 0) {
224             encodeType(buf, MAJOR_TYPE_INT, uint(value));
225         } else {
226             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
227         }
228     }
229 
230     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
231         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
232         buf.append(value);
233     }
234 
235     function encodeString(Buffer.buffer memory buf, string value) internal pure {
236         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
237         buf.append(bytes(value));
238     }
239 
240     function startArray(Buffer.buffer memory buf) internal pure {
241         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
242     }
243 
244     function startMap(Buffer.buffer memory buf) internal pure {
245         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
246     }
247 
248     function endSequence(Buffer.buffer memory buf) internal pure {
249         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
250     }
251 }
252 
253 contract usingOraclize {
254     uint constant day = 60*60*24;
255     uint constant week = 60*60*24*7;
256     uint constant month = 60*60*24*30;
257     byte constant proofType_NONE = 0x00;
258     byte constant proofType_TLSNotary = 0x10;
259     byte constant proofType_Ledger = 0x30;
260     byte constant proofType_Android = 0x40;
261     byte constant proofType_Native = 0xF0;
262     byte constant proofStorage_IPFS = 0x01;
263     uint8 constant networkID_auto = 0;
264     uint8 constant networkID_mainnet = 1;
265     uint8 constant networkID_testnet = 2;
266     uint8 constant networkID_morden = 2;
267     uint8 constant networkID_consensys = 161;
268 
269     OraclizeAddrResolverI OAR;
270 
271     OraclizeI oraclize;
272     modifier oraclizeAPI {
273         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
274             oraclize_setNetwork(networkID_auto);
275 
276         if(address(oraclize) != OAR.getAddress())
277             oraclize = OraclizeI(OAR.getAddress());
278 
279         _;
280     }
281     modifier coupon(string code){
282         oraclize = OraclizeI(OAR.getAddress());
283         _;
284     }
285 
286     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
287       return oraclize_setNetwork();
288       networkID; // silence the warning and remain backwards compatible
289     }
290     function oraclize_setNetwork() internal returns(bool){
291         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
292             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
293             oraclize_setNetworkName("eth_mainnet");
294             return true;
295         }
296         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
297             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
298             oraclize_setNetworkName("eth_ropsten3");
299             return true;
300         }
301         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
302             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
303             oraclize_setNetworkName("eth_kovan");
304             return true;
305         }
306         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
307             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
308             oraclize_setNetworkName("eth_rinkeby");
309             return true;
310         }
311         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
312             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
313             return true;
314         }
315         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
316             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
317             return true;
318         }
319         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
320             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
321             return true;
322         }
323         return false;
324     }
325 
326     function __callback(bytes32 myid, string result) public {
327         __callback(myid, result, new bytes(0));
328     }
329     
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
949         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
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
1061         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
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
1079         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
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
1200 /**
1201  * @title SafeMath
1202  * @dev Math operations with safety checks that revert on error
1203  */
1204 library SafeMath {
1205 
1206   /**
1207   * @dev Multiplies two numbers, reverts on overflow.
1208   */
1209   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1210     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1211     // benefit is lost if 'b' is also tested.
1212     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1213     if (a == 0) {
1214       return 0;
1215     }
1216 
1217     uint256 c = a * b;
1218     require(c / a == b);
1219 
1220     return c;
1221   }
1222 
1223   /**
1224   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1225   */
1226   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1227     require(b > 0); // Solidity only automatically asserts when dividing by 0
1228     uint256 c = a / b;
1229     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1230 
1231     return c;
1232   }
1233 
1234   /**
1235   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1236   */
1237   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1238     require(b <= a);
1239     uint256 c = a - b;
1240 
1241     return c;
1242   }
1243 
1244   /**
1245   * @dev Adds two numbers, reverts on overflow.
1246   */
1247   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1248     uint256 c = a + b;
1249     require(c >= a);
1250 
1251     return c;
1252   }
1253 
1254   /**
1255   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1256   * reverts when dividing by zero.
1257   */
1258   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1259     require(b != 0);
1260     return a % b;
1261   }
1262 }
1263 
1264 contract BMRoll is usingOraclize {
1265     using SafeMath for uint256;
1266     /*
1267      * checks player profit, bet size and player number is within range
1268     */
1269     modifier betIsValid(uint _betSize, uint _playerNumber) {      
1270         require(_betSize >= minBet && _playerNumber >= minNumber && _playerNumber <= maxNumber && (((((_betSize * (100-(_playerNumber.sub(1)))) / (_playerNumber.sub(1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize <= maxProfit));
1271 		_;
1272     }
1273 
1274     /*
1275      * checks game is currently active
1276     */
1277     modifier gameIsActive {
1278         require(gamePaused == false);
1279 		_;
1280     }    
1281 
1282     /*
1283      * checks payouts are currently active
1284     */
1285     modifier payoutsAreActive {
1286         require(payoutsPaused == false);
1287 		_;
1288     }    
1289 
1290     /*
1291      * checks only Oraclize address is calling
1292     */
1293     modifier onlyOraclize {
1294         require(msg.sender == oraclize_cbAddress());
1295         _;
1296     }
1297 
1298     /*
1299      * checks only owner address is calling
1300     */
1301     modifier onlyOwner {
1302          require(msg.sender == owner);
1303          _;
1304     }
1305 
1306     /*
1307      * checks only treasury address is calling
1308     */
1309     modifier onlyTreasury {
1310          require (msg.sender == treasury);
1311          _;
1312     }    
1313 
1314     /*
1315      * game vars
1316     */ 
1317     uint constant public maxProfitDivisor = 1000000;
1318     uint constant public houseEdgeDivisor = 1000;    
1319     uint constant public maxNumber = 99; 
1320     uint constant public minNumber = 2;
1321 	bool public gamePaused;
1322     uint32 public gasForOraclize;
1323     address public owner;
1324     bool public payoutsPaused; 
1325     address public treasury;
1326     uint public contractBalance;
1327     uint public houseEdge;     
1328     uint public maxProfit;   
1329     uint public maxProfitAsPercentOfHouse;                    
1330     uint public minBet; 
1331 
1332     uint public totalBets = 0;
1333     uint public totalWeiWon = 0;
1334     uint public totalWeiWagered = 0; 
1335 
1336     uint public maxPendingPayouts;
1337     
1338     /*
1339      * player vars
1340     */
1341     mapping (bytes32 => address) playerAddress;
1342     mapping (bytes32 => address) playerTempAddress;
1343     mapping (bytes32 => bytes32) playerBetId;
1344     mapping (bytes32 => uint) playerBetValue;
1345     mapping (bytes32 => uint) playerTempBetValue;               
1346     mapping (bytes32 => uint) playerDieResult;
1347     mapping (bytes32 => uint) playerNumber;
1348     mapping (address => uint) playerPendingWithdrawals;      
1349     mapping (bytes32 => uint) playerProfit;
1350     mapping (bytes32 => uint) playerTempReward;           
1351 
1352     /*
1353      * events
1354     */
1355     /* log bets + output to web3 for precise 'payout on win' field in UI */
1356     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);      
1357     /* output to web3 UI on bet result*/
1358     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1359 	event LogResult(bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint ProfitValue, uint BetValue, int Status, bytes Proof);   
1360     /* log manual refunds */
1361     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1362     /* log owner transfers */
1363     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
1364 
1365 
1366     /*
1367      * init
1368     */
1369     constructor() public {
1370 
1371         owner = msg.sender;
1372         treasury = msg.sender;
1373         oraclize_setNetwork(networkID_auto);        
1374         /* sets the Ledger authenticity proof in the constructor */
1375         oraclize_setProof(proofType_Ledger);
1376         /* init 980 = 98% (2% houseEdge)*/
1377         ownerSetHouseEdge(980);
1378         /* init 50,000 = 5%  */
1379         ownerSetMaxProfitAsPercentOfHouse(50000);
1380         /* init min bet (0.1 ether) */
1381         ownerSetMinBet(100000000000000000);        
1382         /* init gas for oraclize */        
1383         gasForOraclize = 235000;  
1384         /* init gas price for callback (default 20 gwei)*/
1385         oraclize_setCustomGasPrice(20000000000 wei);              
1386 
1387     }
1388 
1389     /*
1390      * public function
1391      * player submit bet
1392      * only if game is active & bet is valid can query oraclize and set player vars     
1393     */
1394     function playerRollDice(uint rollUnder) public 
1395         payable
1396         gameIsActive
1397         betIsValid(msg.value, rollUnder)
1398 	{       
1399 
1400         bytes32 rngId = oraclize_newRandomDSQuery(0, 1, gasForOraclize); // this function internally generates the correct oraclize_query and returns its queryId
1401 
1402         /* map bet id to this oraclize query */
1403 		playerBetId[rngId] = rngId;
1404         /* map player lucky number to this oraclize query */
1405 		playerNumber[rngId] = rollUnder;
1406         /* map value of wager to this oraclize query */
1407         playerBetValue[rngId] = msg.value;
1408         /* map player address to this oraclize query */
1409         playerAddress[rngId] = msg.sender;
1410         /* safely map player profit to this oraclize query */                     
1411         playerProfit[rngId] = ((((msg.value * (100-(rollUnder.sub(1)))) / (rollUnder.sub(1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
1412         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
1413         maxPendingPayouts = maxPendingPayouts.add(playerProfit[rngId]);
1414         /* check contract can payout on win */
1415         if(maxPendingPayouts >= contractBalance) revert();
1416         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
1417         emit LogBet(playerBetId[rngId], playerAddress[rngId], playerBetValue[rngId].add(playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);          
1418 
1419     }   
1420              
1421 
1422     /*
1423     * semi-public function - only oraclize can call
1424     */
1425 	function __callback(bytes32 myid, string result, bytes proof) public   
1426 		onlyOraclize
1427 		payoutsAreActive
1428 	{  
1429 
1430         /* player address mapped to query id does not exist */
1431         require(playerAddress[myid]!=0x0);
1432 
1433             
1434         /* map random result to player */
1435         playerDieResult[myid] = uint(keccak256(abi.encodePacked(result))) % 100; // this is an efficient way to get the uint out in the [0, maxRange] range;
1436         /* get the playerAddress for this query id */
1437         playerTempAddress[myid] = playerAddress[myid];
1438         /* delete playerAddress for this query id */
1439         delete playerAddress[myid];
1440 
1441         /* map the playerProfit for this query id */
1442         playerTempReward[myid] = playerProfit[myid];
1443         /* set  playerProfit for this query id to 0 */
1444         playerProfit[myid] = 0; 
1445 
1446         /* safely reduce maxPendingPayouts liability */
1447         maxPendingPayouts = maxPendingPayouts.sub(playerTempReward[myid]);         
1448 
1449         /* map the playerBetValue for this query id */
1450         playerTempBetValue[myid] = playerBetValue[myid];
1451         /* set  playerBetValue for this query id to 0 */
1452         playerBetValue[myid] = 0; 
1453 
1454         /* total number of bets */
1455         totalBets += 1;
1456 
1457         /* total wagered */
1458         totalWeiWagered += playerTempBetValue[myid];    
1459 
1460         /*
1461         * refund
1462         * if result is 0 result is empty or no proof refund original bet value
1463         * if refund fails save refund value to playerPendingWithdrawals
1464         */
1465         if (playerDieResult[myid] == 0 || bytes(result).length == 0 || bytes(proof).length == 0 || oraclize_randomDS_proofVerify__returnCode(myid, result, proof) != 0) {
1466             emit LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], 0, playerTempBetValue[myid], 3, proof);            
1467 
1468             /*
1469             * send refund - external call to an untrusted contract
1470             * if send fails map refund value to playerPendingWithdrawals[address]
1471             * for withdrawal later via playerWithdrawPendingTransactions
1472             */
1473             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
1474                 emit LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], 0, playerTempBetValue[myid], 4, proof);              
1475                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1476                 playerPendingWithdrawals[playerTempAddress[myid]] = playerPendingWithdrawals[playerTempAddress[myid]].add(playerTempBetValue[myid]);
1477             }
1478 
1479             return;
1480         }
1481 
1482         /*
1483         * pay winner
1484         * update contract balance to calculate new max bet
1485         * send reward
1486         * if send of reward fails save value to playerPendingWithdrawals        
1487         */
1488         if(playerDieResult[myid] < playerNumber[myid]){ 
1489 
1490             /* safely reduce contract balance by player profit */
1491             contractBalance = contractBalance.sub(playerTempReward[myid]); 
1492 
1493             /* update total wei won */
1494             totalWeiWon = totalWeiWon.add(playerTempReward[myid]);              
1495 
1496             /* safely calculate payout via profit plus original wager */
1497             playerTempReward[myid] = playerTempReward[myid].add(playerTempBetValue[myid]); 
1498 
1499             emit LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], playerTempBetValue[myid],1, proof);                            
1500 
1501             /* update maximum profit */
1502             setMaxProfit();
1503             
1504             /*
1505             * send win - external call to an untrusted contract
1506             * if send fails map reward value to playerPendingWithdrawals[address]
1507             * for withdrawal later via playerWithdrawPendingTransactions
1508             */
1509             if(!playerTempAddress[myid].send(playerTempReward[myid])){
1510                 emit LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], playerTempBetValue[myid], 2, proof);                   
1511                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
1512                 playerPendingWithdrawals[playerTempAddress[myid]] = playerPendingWithdrawals[playerTempAddress[myid]].add(playerTempReward[myid]);                               
1513             }
1514 
1515             return;
1516 
1517         }
1518 
1519         /*
1520         * no win
1521         * send 1 wei to a losing bet
1522         * update contract balance to calculate new max bet
1523         */
1524         if(playerDieResult[myid] >= playerNumber[myid]){
1525 
1526             emit LogResult(playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], 0, playerTempBetValue[myid], 0, proof);                                
1527 
1528             /*  
1529             *  safe adjust contractBalance
1530             *  setMaxProfit
1531             *  send 1 wei to losing bet
1532             */
1533             contractBalance = contractBalance.add((playerTempBetValue[myid]-1));                                                                         
1534 
1535             /* update maximum profit */
1536             setMaxProfit(); 
1537 
1538             /*
1539             * send 1 wei - external call to an untrusted contract                  
1540             */
1541             if(!playerTempAddress[myid].send(1)){
1542                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
1543                playerPendingWithdrawals[playerTempAddress[myid]] = playerPendingWithdrawals[playerTempAddress[myid]].add(1);                                
1544             }                                   
1545 
1546             return;
1547 
1548         }
1549 
1550     }
1551     
1552     /*
1553     * public function
1554     * in case of a failed refund or win send
1555     */
1556     function playerWithdrawPendingTransactions() public 
1557         payoutsAreActive
1558         returns (bool)
1559      {
1560         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
1561         playerPendingWithdrawals[msg.sender] = 0;
1562         /* external call to untrusted contract */
1563         if (msg.sender.call.value(withdrawAmount)()) {
1564             return true;
1565         } else {
1566             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
1567             /* player can try to withdraw again later */
1568             playerPendingWithdrawals[msg.sender] = withdrawAmount;
1569             return false;
1570         }
1571     }
1572 
1573     /* check for pending withdrawals  */
1574     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
1575         return playerPendingWithdrawals[addressToCheck];
1576     }
1577 
1578     /*
1579     * internal function
1580     * sets max profit
1581     */
1582     function setMaxProfit() internal {
1583         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
1584     }      
1585 
1586     /*
1587     * owner/treasury address only functions
1588     */
1589     function ()
1590         payable public
1591         onlyTreasury
1592     {
1593         /* safely update contract balance */
1594         contractBalance = contractBalance.add(msg.value);        
1595         /* update the maximum profit */
1596         setMaxProfit();
1597     } 
1598 
1599     /* set gas price for oraclize callback */
1600     function ownerSetCallbackGasPrice(uint newCallbackGasPrice) public 
1601 		onlyOwner
1602 	{
1603         oraclize_setCustomGasPrice(newCallbackGasPrice);
1604     }     
1605 
1606     /* set gas limit for oraclize query */
1607     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
1608 		onlyOwner
1609 	{
1610     	gasForOraclize = newSafeGasToOraclize;
1611     }
1612 
1613     /* only owner adjust contract balance variable (only used for max profit calc) */
1614     function ownerUpdateContractBalance(uint newContractBalanceInWei) public 
1615 		onlyOwner
1616     {        
1617        contractBalance = newContractBalanceInWei;
1618     }    
1619 
1620     /* only owner address can set houseEdge */
1621     function ownerSetHouseEdge(uint newHouseEdge) public 
1622 		onlyOwner
1623     {
1624         houseEdge = newHouseEdge;
1625     }
1626 
1627     /* only owner address can set maxProfitAsPercentOfHouse */
1628     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
1629 		onlyOwner
1630     {
1631         /* restrict each bet to a maximum profit of 5% contractBalance */
1632         require(newMaxProfitAsPercent <= 50000);
1633         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
1634         setMaxProfit();
1635     }
1636 
1637     /* only owner address can set minBet */
1638     function ownerSetMinBet(uint newMinimumBet) public 
1639 		onlyOwner
1640     {
1641         minBet = newMinimumBet;
1642     }       
1643 
1644     /* only owner address can transfer ether */
1645     function ownerTransferEther(address sendTo, uint amount) public 
1646 		onlyOwner
1647     {        
1648         /* safely update contract balance when sending out funds*/
1649         contractBalance = contractBalance.sub(amount);		
1650         /* update max profit */
1651         setMaxProfit();
1652         if(!sendTo.send(amount)) revert();
1653         emit LogOwnerTransfer(sendTo, amount); 
1654     }
1655 
1656     /* only owner address can do manual refund
1657     * used only if bet placed + oraclize failed to __callback
1658     * filter LogBet by address and/or playerBetId:
1659     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
1660     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
1661     * LogResult or LogRefund
1662     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
1663     */
1664     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
1665 		onlyOwner
1666     {        
1667         /* safely reduce pendingPayouts by playerProfit[rngId] */
1668         maxPendingPayouts = maxPendingPayouts.sub(originalPlayerProfit);
1669         /* send refund */
1670         if(!sendTo.send(originalPlayerBetValue)) revert();
1671         /* log refunds */
1672         emit LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
1673     }    
1674 
1675     /* only owner address can set emergency pause #1 */
1676     function ownerPauseGame(bool newStatus) public 
1677 		onlyOwner
1678     {
1679 		gamePaused = newStatus;
1680     }
1681 
1682     /* only owner address can set emergency pause #2 */
1683     function ownerPausePayouts(bool newPayoutStatus) public 
1684 		onlyOwner
1685     {
1686 		payoutsPaused = newPayoutStatus;
1687     } 
1688 
1689     /* only owner address can set treasury address */
1690     function ownerSetTreasury(address newTreasury) public 
1691 		onlyOwner
1692 	{
1693         treasury = newTreasury;
1694     }         
1695 
1696     /* only owner address can set owner address */
1697     function ownerChangeOwner(address newOwner) public 
1698 		onlyOwner
1699 	{
1700         require(newOwner != 0);
1701         owner = newOwner;
1702     }
1703 
1704     /* only owner address can suicide - emergency */
1705     function ownerkill() public 
1706 		onlyOwner
1707 	{
1708 		selfdestruct(owner);
1709 	}    
1710 
1711 
1712 }