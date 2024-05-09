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
31 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47     function randomDS_getSessionPubKeyHash() returns(bytes32);
48 }
49 
50 contract OraclizeAddrResolverI {
51     function getAddress() returns (address _addr);
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
314         oraclize.useCoupon(code);
315         _;
316     }
317 
318     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
319         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
320             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
321             oraclize_setNetworkName("eth_mainnet");
322             return true;
323         }
324         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
325             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
326             oraclize_setNetworkName("eth_ropsten3");
327             return true;
328         }
329         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
330             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
331             oraclize_setNetworkName("eth_kovan");
332             return true;
333         }
334         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
335             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
336             oraclize_setNetworkName("eth_rinkeby");
337             return true;
338         }
339         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
340             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
341             return true;
342         }
343         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
344             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
345             return true;
346         }
347         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
348             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
349             return true;
350         }
351         return false;
352     }
353 
354     function __callback(bytes32 myid, string result) {
355         __callback(myid, result, new bytes(0));
356     }
357     function __callback(bytes32 myid, string result, bytes proof) {
358     }
359 
360     function oraclize_useCoupon(string code) oraclizeAPI internal {
361         oraclize.useCoupon(code);
362     }
363 
364     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
365         return oraclize.getPrice(datasource);
366     }
367 
368     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
369         return oraclize.getPrice(datasource, gaslimit);
370     }
371 
372     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource);
374         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
375         return oraclize.query.value(price)(0, datasource, arg);
376     }
377     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource);
379         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
380         return oraclize.query.value(price)(timestamp, datasource, arg);
381     }
382     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
386     }
387     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource, gaslimit);
389         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
390         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
391     }
392     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
396     }
397     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource);
399         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
400         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
401     }
402     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
406     }
407     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource, gaslimit);
409         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
410         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
411     }
412     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource);
414         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
415         bytes memory args = stra2cbor(argN);
416         return oraclize.queryN.value(price)(0, datasource, args);
417     }
418     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource);
420         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN.value(price)(timestamp, datasource, args);
423     }
424     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource, gaslimit);
426         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
427         bytes memory args = stra2cbor(argN);
428         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
429     }
430     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         bytes memory args = stra2cbor(argN);
434         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
435     }
436     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
437         string[] memory dynargs = new string[](1);
438         dynargs[0] = args[0];
439         return oraclize_query(datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(timestamp, datasource, dynargs);
445     }
446     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
450     }
451     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](1);
453         dynargs[0] = args[0];
454         return oraclize_query(datasource, dynargs, gaslimit);
455     }
456 
457     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](2);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(timestamp, datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](2);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
474     }
475     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](2);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](3);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         return oraclize_query(datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](3);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](3);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
501     }
502     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](3);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         return oraclize_query(datasource, dynargs, gaslimit);
508     }
509 
510     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](4);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         dynargs[3] = args[3];
516         return oraclize_query(datasource, dynargs);
517     }
518     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
519         string[] memory dynargs = new string[](4);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         return oraclize_query(timestamp, datasource, dynargs);
525     }
526     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](4);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](4);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         return oraclize_query(datasource, dynargs, gaslimit);
541     }
542     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
543         string[] memory dynargs = new string[](5);
544         dynargs[0] = args[0];
545         dynargs[1] = args[1];
546         dynargs[2] = args[2];
547         dynargs[3] = args[3];
548         dynargs[4] = args[4];
549         return oraclize_query(datasource, dynargs);
550     }
551     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](5);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         dynargs[3] = args[3];
557         dynargs[4] = args[4];
558         return oraclize_query(timestamp, datasource, dynargs);
559     }
560     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](5);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         dynargs[4] = args[4];
567         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
568     }
569     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
570         string[] memory dynargs = new string[](5);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         dynargs[4] = args[4];
576         return oraclize_query(datasource, dynargs, gaslimit);
577     }
578     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
579         uint price = oraclize.getPrice(datasource);
580         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
581         bytes memory args = ba2cbor(argN);
582         return oraclize.queryN.value(price)(0, datasource, args);
583     }
584     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource);
586         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN.value(price)(timestamp, datasource, args);
589     }
590     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource, gaslimit);
592         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
593         bytes memory args = ba2cbor(argN);
594         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
595     }
596     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
597         uint price = oraclize.getPrice(datasource, gaslimit);
598         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
599         bytes memory args = ba2cbor(argN);
600         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
601     }
602     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
603         bytes[] memory dynargs = new bytes[](1);
604         dynargs[0] = args[0];
605         return oraclize_query(datasource, dynargs);
606     }
607     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](1);
609         dynargs[0] = args[0];
610         return oraclize_query(timestamp, datasource, dynargs);
611     }
612     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](1);
614         dynargs[0] = args[0];
615         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](1);
619         dynargs[0] = args[0];
620         return oraclize_query(datasource, dynargs, gaslimit);
621     }
622 
623     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](2);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         return oraclize_query(datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](2);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
640     }
641     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](2);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         return oraclize_query(datasource, dynargs, gaslimit);
646     }
647     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](3);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         return oraclize_query(datasource, dynargs);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](3);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         return oraclize_query(timestamp, datasource, dynargs);
660     }
661     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](3);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
667     }
668     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](3);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         dynargs[2] = args[2];
673         return oraclize_query(datasource, dynargs, gaslimit);
674     }
675 
676     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](4);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         dynargs[3] = args[3];
682         return oraclize_query(datasource, dynargs);
683     }
684     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
685         bytes[] memory dynargs = new bytes[](4);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         dynargs[3] = args[3];
690         return oraclize_query(timestamp, datasource, dynargs);
691     }
692     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](4);
694         dynargs[0] = args[0];
695         dynargs[1] = args[1];
696         dynargs[2] = args[2];
697         dynargs[3] = args[3];
698         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](4);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         return oraclize_query(datasource, dynargs, gaslimit);
707     }
708     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
709         bytes[] memory dynargs = new bytes[](5);
710         dynargs[0] = args[0];
711         dynargs[1] = args[1];
712         dynargs[2] = args[2];
713         dynargs[3] = args[3];
714         dynargs[4] = args[4];
715         return oraclize_query(datasource, dynargs);
716     }
717     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](5);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         dynargs[3] = args[3];
723         dynargs[4] = args[4];
724         return oraclize_query(timestamp, datasource, dynargs);
725     }
726     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](5);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         dynargs[4] = args[4];
733         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
734     }
735     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](5);
737         dynargs[0] = args[0];
738         dynargs[1] = args[1];
739         dynargs[2] = args[2];
740         dynargs[3] = args[3];
741         dynargs[4] = args[4];
742         return oraclize_query(datasource, dynargs, gaslimit);
743     }
744 
745     function oraclize_cbAddress() oraclizeAPI internal returns (address){
746         return oraclize.cbAddress();
747     }
748     function oraclize_setProof(byte proofP) oraclizeAPI internal {
749         return oraclize.setProofType(proofP);
750     }
751     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
752         return oraclize.setCustomGasPrice(gasPrice);
753     }
754     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
755         return oraclize.setConfig(config);
756     }
757 
758     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
759         return oraclize.randomDS_getSessionPubKeyHash();
760     }
761 
762     function getCodeSize(address _addr) constant internal returns(uint _size) {
763         assembly {
764             _size := extcodesize(_addr)
765         }
766     }
767 
768     function parseAddr(string _a) internal returns (address){
769         bytes memory tmp = bytes(_a);
770         uint160 iaddr = 0;
771         uint160 b1;
772         uint160 b2;
773         for (uint i=2; i<2+2*20; i+=2){
774             iaddr *= 256;
775             b1 = uint160(tmp[i]);
776             b2 = uint160(tmp[i+1]);
777             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
778             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
779             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
780             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
781             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
782             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
783             iaddr += (b1*16+b2);
784         }
785         return address(iaddr);
786     }
787 
788     function strCompare(string _a, string _b) internal returns (int) {
789         bytes memory a = bytes(_a);
790         bytes memory b = bytes(_b);
791         uint minLength = a.length;
792         if (b.length < minLength) minLength = b.length;
793         for (uint i = 0; i < minLength; i ++)
794             if (a[i] < b[i])
795                 return -1;
796             else if (a[i] > b[i])
797                 return 1;
798         if (a.length < b.length)
799             return -1;
800         else if (a.length > b.length)
801             return 1;
802         else
803             return 0;
804     }
805 
806     function indexOf(string _haystack, string _needle) internal returns (int) {
807         bytes memory h = bytes(_haystack);
808         bytes memory n = bytes(_needle);
809         if(h.length < 1 || n.length < 1 || (n.length > h.length))
810             return -1;
811         else if(h.length > (2**128 -1))
812             return -1;
813         else
814         {
815             uint subindex = 0;
816             for (uint i = 0; i < h.length; i ++)
817             {
818                 if (h[i] == n[0])
819                 {
820                     subindex = 1;
821                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
822                     {
823                         subindex++;
824                     }
825                     if(subindex == n.length)
826                         return int(i);
827                 }
828             }
829             return -1;
830         }
831     }
832 
833     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
834         bytes memory _ba = bytes(_a);
835         bytes memory _bb = bytes(_b);
836         bytes memory _bc = bytes(_c);
837         bytes memory _bd = bytes(_d);
838         bytes memory _be = bytes(_e);
839         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
840         bytes memory babcde = bytes(abcde);
841         uint k = 0;
842         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
843         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
844         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
845         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
846         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
847         return string(babcde);
848     }
849 
850     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
851         return strConcat(_a, _b, _c, _d, "");
852     }
853 
854     function strConcat(string _a, string _b, string _c) internal returns (string) {
855         return strConcat(_a, _b, _c, "", "");
856     }
857 
858     function strConcat(string _a, string _b) internal returns (string) {
859         return strConcat(_a, _b, "", "", "");
860     }
861 
862     // parseInt
863     function parseInt(string _a) internal returns (uint) {
864         return parseInt(_a, 0);
865     }
866 
867     // parseInt(parseFloat*10^_b)
868     function parseInt(string _a, uint _b) internal returns (uint) {
869         bytes memory bresult = bytes(_a);
870         uint mint = 0;
871         bool decimals = false;
872         for (uint i=0; i<bresult.length; i++){
873             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
874                 if (decimals){
875                    if (_b == 0) break;
876                     else _b--;
877                 }
878                 mint *= 10;
879                 mint += uint(bresult[i]) - 48;
880             } else if (bresult[i] == 46) decimals = true;
881         }
882         if (_b > 0) mint *= 10**_b;
883         return mint;
884     }
885 
886     function uint2str(uint i) internal returns (string){
887         if (i == 0) return "0";
888         uint j = i;
889         uint len;
890         while (j != 0){
891             len++;
892             j /= 10;
893         }
894         bytes memory bstr = new bytes(len);
895         uint k = len - 1;
896         while (i != 0){
897             bstr[k--] = byte(48 + i % 10);
898             i /= 10;
899         }
900         return string(bstr);
901     }
902 
903     using CBOR for Buffer.buffer;
904     function stra2cbor(string[] arr) internal returns (bytes) {
905         Buffer.buffer memory buf;
906         Buffer.init(buf, 1024);
907         buf.startArray();
908         for (uint i = 0; i < arr.length; i++) {
909             buf.encodeString(arr[i]);
910         }
911         buf.endSequence();
912         return buf.buf;
913     }
914 
915     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
916         Buffer.buffer memory buf;
917         Buffer.init(buf, 1024);
918         buf.startArray();
919         for (uint i = 0; i < arr.length; i++) {
920             buf.encodeBytes(arr[i]);
921         }
922         buf.endSequence();
923         return buf.buf;
924     }
925 
926     string oraclize_network_name;
927     function oraclize_setNetworkName(string _network_name) internal {
928         oraclize_network_name = _network_name;
929     }
930 
931     function oraclize_getNetworkName() internal returns (string) {
932         return oraclize_network_name;
933     }
934 
935     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
936         if ((_nbytes == 0)||(_nbytes > 32)) throw;
937 	// Convert from seconds to ledger timer ticks
938         _delay *= 10;
939         bytes memory nbytes = new bytes(1);
940         nbytes[0] = byte(_nbytes);
941         bytes memory unonce = new bytes(32);
942         bytes memory sessionKeyHash = new bytes(32);
943         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
944         assembly {
945             mstore(unonce, 0x20)
946             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
947             mstore(sessionKeyHash, 0x20)
948             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
949         }
950         bytes memory delay = new bytes(32);
951         assembly {
952             mstore(add(delay, 0x20), _delay)
953         }
954 
955         bytes memory delay_bytes8 = new bytes(8);
956         copyBytes(delay, 24, 8, delay_bytes8, 0);
957 
958         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
959         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
960 
961         bytes memory delay_bytes8_left = new bytes(8);
962 
963         assembly {
964             let x := mload(add(delay_bytes8, 0x20))
965             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
973 
974         }
975 
976         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
977         return queryId;
978     }
979 
980     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
981         oraclize_randomDS_args[queryId] = commitment;
982     }
983 
984     mapping(bytes32=>bytes32) oraclize_randomDS_args;
985     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
986 
987     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
988         bool sigok;
989         address signer;
990 
991         bytes32 sigr;
992         bytes32 sigs;
993 
994         bytes memory sigr_ = new bytes(32);
995         uint offset = 4+(uint(dersig[3]) - 0x20);
996         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
997         bytes memory sigs_ = new bytes(32);
998         offset += 32 + 2;
999         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1000 
1001         assembly {
1002             sigr := mload(add(sigr_, 32))
1003             sigs := mload(add(sigs_, 32))
1004         }
1005 
1006 
1007         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1008         if (address(sha3(pubkey)) == signer) return true;
1009         else {
1010             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1011             return (address(sha3(pubkey)) == signer);
1012         }
1013     }
1014 
1015     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1016         bool sigok;
1017 
1018         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1019         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1020         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1021 
1022         bytes memory appkey1_pubkey = new bytes(64);
1023         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1024 
1025         bytes memory tosign2 = new bytes(1+65+32);
1026         tosign2[0] = 1; //role
1027         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1028         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1029         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1030         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1031 
1032         if (sigok == false) return false;
1033 
1034 
1035         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1036         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1037 
1038         bytes memory tosign3 = new bytes(1+65);
1039         tosign3[0] = 0xFE;
1040         copyBytes(proof, 3, 65, tosign3, 1);
1041 
1042         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1043         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1044 
1045         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1046 
1047         return sigok;
1048     }
1049 
1050     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1051         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1052         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1053 
1054         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1055         if (proofVerified == false) throw;
1056 
1057         _;
1058     }
1059 
1060     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1061         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1062         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1063 
1064         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1065         if (proofVerified == false) return 2;
1066 
1067         return 0;
1068     }
1069 
1070     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1071         bool match_ = true;
1072 
1073 	if (prefix.length != n_random_bytes) throw;
1074 
1075         for (uint256 i=0; i< n_random_bytes; i++) {
1076             if (content[i] != prefix[i]) match_ = false;
1077         }
1078 
1079         return match_;
1080     }
1081 
1082     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1083 
1084         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1085         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1086         bytes memory keyhash = new bytes(32);
1087         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1088         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1089 
1090         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1091         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1092 
1093         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1094         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1095 
1096         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1097         // This is to verify that the computed args match with the ones specified in the query.
1098         bytes memory commitmentSlice1 = new bytes(8+1+32);
1099         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1100 
1101         bytes memory sessionPubkey = new bytes(64);
1102         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1103         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1104 
1105         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1106         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1107             delete oraclize_randomDS_args[queryId];
1108         } else return false;
1109 
1110 
1111         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1112         bytes memory tosign1 = new bytes(32+8+1+32);
1113         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1114         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1115 
1116         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1117         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1118             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1119         }
1120 
1121         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1122     }
1123 
1124 
1125     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1126     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1127         uint minLength = length + toOffset;
1128 
1129         if (to.length < minLength) {
1130             // Buffer too small
1131             throw; // Should be a better way?
1132         }
1133 
1134         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1135         uint i = 32 + fromOffset;
1136         uint j = 32 + toOffset;
1137 
1138         while (i < (32 + fromOffset + length)) {
1139             assembly {
1140                 let tmp := mload(add(from, i))
1141                 mstore(add(to, j), tmp)
1142             }
1143             i += 32;
1144             j += 32;
1145         }
1146 
1147         return to;
1148     }
1149 
1150     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1151     // Duplicate Solidity's ecrecover, but catching the CALL return value
1152     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1153         // We do our own memory management here. Solidity uses memory offset
1154         // 0x40 to store the current end of memory. We write past it (as
1155         // writes are memory extensions), but don't update the offset so
1156         // Solidity will reuse it. The memory used here is only needed for
1157         // this context.
1158 
1159         // FIXME: inline assembly can't access return values
1160         bool ret;
1161         address addr;
1162 
1163         assembly {
1164             let size := mload(0x40)
1165             mstore(size, hash)
1166             mstore(add(size, 32), v)
1167             mstore(add(size, 64), r)
1168             mstore(add(size, 96), s)
1169 
1170             // NOTE: we can reuse the request memory because we deal with
1171             //       the return code
1172             ret := call(3000, 1, 0, size, 128, size, 32)
1173             addr := mload(size)
1174         }
1175 
1176         return (ret, addr);
1177     }
1178 
1179     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1180     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1181         bytes32 r;
1182         bytes32 s;
1183         uint8 v;
1184 
1185         if (sig.length != 65)
1186           return (false, 0);
1187 
1188         // The signature format is a compact form of:
1189         //   {bytes32 r}{bytes32 s}{uint8 v}
1190         // Compact means, uint8 is not padded to 32 bytes.
1191         assembly {
1192             r := mload(add(sig, 32))
1193             s := mload(add(sig, 64))
1194 
1195             // Here we are loading the last 32 bytes. We exploit the fact that
1196             // 'mload' will pad with zeroes if we overread.
1197             // There is no 'mload8' to do this, but that would be nicer.
1198             v := byte(0, mload(add(sig, 96)))
1199 
1200             // Alternative solution:
1201             // 'byte' is not working due to the Solidity parser, so lets
1202             // use the second best option, 'and'
1203             // v := and(mload(add(sig, 65)), 255)
1204         }
1205 
1206         // albeit non-transactional signatures are not specified by the YP, one would expect it
1207         // to match the YP range of [27, 28]
1208         //
1209         // geth uses [0, 1] and some clients have followed. This might change, see:
1210         //  https://github.com/ethereum/go-ethereum/issues/2053
1211         if (v < 27)
1212           v += 27;
1213 
1214         if (v != 27 && v != 28)
1215             return (false, 0);
1216 
1217         return safer_ecrecover(hash, v, r, s);
1218     }
1219 
1220 }
1221 // </ORACLIZE_API>
1222 
1223 
1224 
1225 /*
1226  * @title String & slice utility library for Solidity contracts.
1227  * @author Nick Johnson <arachnid@notdot.net>
1228  *
1229  * @dev Functionality in this library is largely implemented using an
1230  *      abstraction called a 'slice'. A slice represents a part of a string -
1231  *      anything from the entire string to a single character, or even no
1232  *      characters at all (a 0-length slice). Since a slice only has to specify
1233  *      an offset and a length, copying and manipulating slices is a lot less
1234  *      expensive than copying and manipulating the strings they reference.
1235  *
1236  *      To further reduce gas costs, most functions on slice that need to return
1237  *      a slice modify the original one instead of allocating a new one; for
1238  *      instance, `s.split(".")` will return the text up to the first '.',
1239  *      modifying s to only contain the remainder of the string after the '.'.
1240  *      In situations where you do not want to modify the original slice, you
1241  *      can make a copy first with `.copy()`, for example:
1242  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1243  *      Solidity has no memory management, it will result in allocating many
1244  *      short-lived slices that are later discarded.
1245  *
1246  *      Functions that return two slices come in two versions: a non-allocating
1247  *      version that takes the second slice as an argument, modifying it in
1248  *      place, and an allocating version that allocates and returns the second
1249  *      slice; see `nextRune` for example.
1250  *
1251  *      Functions that have to copy string data will return strings rather than
1252  *      slices; these can be cast back to slices for further processing if
1253  *      required.
1254  *
1255  *      For convenience, some functions are provided with non-modifying
1256  *      variants that create a new slice and return both; for instance,
1257  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1258  *      corresponding to the left and right parts of the string.
1259  */
1260 
1261 library strings {
1262     struct slice {
1263         uint _len;
1264         uint _ptr;
1265     }
1266 
1267     function memcpy(uint dest, uint src, uint len) private {
1268         // Copy word-length chunks while possible
1269         for(; len >= 32; len -= 32) {
1270             assembly {
1271                 mstore(dest, mload(src))
1272             }
1273             dest += 32;
1274             src += 32;
1275         }
1276 
1277         // Copy remaining bytes
1278         uint mask = 256 ** (32 - len) - 1;
1279         assembly {
1280             let srcpart := and(mload(src), not(mask))
1281             let destpart := and(mload(dest), mask)
1282             mstore(dest, or(destpart, srcpart))
1283         }
1284     }
1285 
1286     /*
1287      * @dev Returns a slice containing the entire string.
1288      * @param self The string to make a slice from.
1289      * @return A newly allocated slice containing the entire string.
1290      */
1291     function toSlice(string self) internal returns (slice) {
1292         uint ptr;
1293         assembly {
1294             ptr := add(self, 0x20)
1295         }
1296         return slice(bytes(self).length, ptr);
1297     }
1298 
1299     /*
1300      * @dev Returns the length of a null-terminated bytes32 string.
1301      * @param self The value to find the length of.
1302      * @return The length of the string, from 0 to 32.
1303      */
1304     function len(bytes32 self) internal returns (uint) {
1305         uint ret;
1306         if (self == 0)
1307             return 0;
1308         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1309             ret += 16;
1310             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1311         }
1312         if (self & 0xffffffffffffffff == 0) {
1313             ret += 8;
1314             self = bytes32(uint(self) / 0x10000000000000000);
1315         }
1316         if (self & 0xffffffff == 0) {
1317             ret += 4;
1318             self = bytes32(uint(self) / 0x100000000);
1319         }
1320         if (self & 0xffff == 0) {
1321             ret += 2;
1322             self = bytes32(uint(self) / 0x10000);
1323         }
1324         if (self & 0xff == 0) {
1325             ret += 1;
1326         }
1327         return 32 - ret;
1328     }
1329 
1330     /*
1331      * @dev Returns a slice containing the entire bytes32, interpreted as a
1332      *      null-termintaed utf-8 string.
1333      * @param self The bytes32 value to convert to a slice.
1334      * @return A new slice containing the value of the input argument up to the
1335      *         first null.
1336      */
1337     function toSliceB32(bytes32 self) internal returns (slice ret) {
1338         // Allocate space for `self` in memory, copy it there, and point ret at it
1339         assembly {
1340             let ptr := mload(0x40)
1341             mstore(0x40, add(ptr, 0x20))
1342             mstore(ptr, self)
1343             mstore(add(ret, 0x20), ptr)
1344         }
1345         ret._len = len(self);
1346     }
1347 
1348     /*
1349      * @dev Returns a new slice containing the same data as the current slice.
1350      * @param self The slice to copy.
1351      * @return A new slice containing the same data as `self`.
1352      */
1353     function copy(slice self) internal returns (slice) {
1354         return slice(self._len, self._ptr);
1355     }
1356 
1357     /*
1358      * @dev Copies a slice to a new string.
1359      * @param self The slice to copy.
1360      * @return A newly allocated string containing the slice's text.
1361      */
1362     function toString(slice self) internal returns (string) {
1363         var ret = new string(self._len);
1364         uint retptr;
1365         assembly { retptr := add(ret, 32) }
1366 
1367         memcpy(retptr, self._ptr, self._len);
1368         return ret;
1369     }
1370 
1371     /*
1372      * @dev Returns the length in runes of the slice. Note that this operation
1373      *      takes time proportional to the length of the slice; avoid using it
1374      *      in loops, and call `slice.empty()` if you only need to know whether
1375      *      the slice is empty or not.
1376      * @param self The slice to operate on.
1377      * @return The length of the slice in runes.
1378      */
1379     function len(slice self) internal returns (uint l) {
1380         // Starting at ptr-31 means the LSB will be the byte we care about
1381         var ptr = self._ptr - 31;
1382         var end = ptr + self._len;
1383         for (l = 0; ptr < end; l++) {
1384             uint8 b;
1385             assembly { b := and(mload(ptr), 0xFF) }
1386             if (b < 0x80) {
1387                 ptr += 1;
1388             } else if(b < 0xE0) {
1389                 ptr += 2;
1390             } else if(b < 0xF0) {
1391                 ptr += 3;
1392             } else if(b < 0xF8) {
1393                 ptr += 4;
1394             } else if(b < 0xFC) {
1395                 ptr += 5;
1396             } else {
1397                 ptr += 6;
1398             }
1399         }
1400     }
1401 
1402     /*
1403      * @dev Returns true if the slice is empty (has a length of 0).
1404      * @param self The slice to operate on.
1405      * @return True if the slice is empty, False otherwise.
1406      */
1407     function empty(slice self) internal returns (bool) {
1408         return self._len == 0;
1409     }
1410 
1411     /*
1412      * @dev Returns a positive number if `other` comes lexicographically after
1413      *      `self`, a negative number if it comes before, or zero if the
1414      *      contents of the two slices are equal. Comparison is done per-rune,
1415      *      on unicode codepoints.
1416      * @param self The first slice to compare.
1417      * @param other The second slice to compare.
1418      * @return The result of the comparison.
1419      */
1420     function compare(slice self, slice other) internal returns (int) {
1421         uint shortest = self._len;
1422         if (other._len < self._len)
1423             shortest = other._len;
1424 
1425         var selfptr = self._ptr;
1426         var otherptr = other._ptr;
1427         for (uint idx = 0; idx < shortest; idx += 32) {
1428             uint a;
1429             uint b;
1430             assembly {
1431                 a := mload(selfptr)
1432                 b := mload(otherptr)
1433             }
1434             if (a != b) {
1435                 // Mask out irrelevant bytes and check again
1436                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1437                 var diff = (a & mask) - (b & mask);
1438                 if (diff != 0)
1439                     return int(diff);
1440             }
1441             selfptr += 32;
1442             otherptr += 32;
1443         }
1444         return int(self._len) - int(other._len);
1445     }
1446 
1447     /*
1448      * @dev Returns true if the two slices contain the same text.
1449      * @param self The first slice to compare.
1450      * @param self The second slice to compare.
1451      * @return True if the slices are equal, false otherwise.
1452      */
1453     function equals(slice self, slice other) internal returns (bool) {
1454         return compare(self, other) == 0;
1455     }
1456 
1457     /*
1458      * @dev Extracts the first rune in the slice into `rune`, advancing the
1459      *      slice to point to the next rune and returning `self`.
1460      * @param self The slice to operate on.
1461      * @param rune The slice that will contain the first rune.
1462      * @return `rune`.
1463      */
1464     function nextRune(slice self, slice rune) internal returns (slice) {
1465         rune._ptr = self._ptr;
1466 
1467         if (self._len == 0) {
1468             rune._len = 0;
1469             return rune;
1470         }
1471 
1472         uint len;
1473         uint b;
1474         // Load the first byte of the rune into the LSBs of b
1475         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1476         if (b < 0x80) {
1477             len = 1;
1478         } else if(b < 0xE0) {
1479             len = 2;
1480         } else if(b < 0xF0) {
1481             len = 3;
1482         } else {
1483             len = 4;
1484         }
1485 
1486         // Check for truncated codepoints
1487         if (len > self._len) {
1488             rune._len = self._len;
1489             self._ptr += self._len;
1490             self._len = 0;
1491             return rune;
1492         }
1493 
1494         self._ptr += len;
1495         self._len -= len;
1496         rune._len = len;
1497         return rune;
1498     }
1499 
1500     /*
1501      * @dev Returns the first rune in the slice, advancing the slice to point
1502      *      to the next rune.
1503      * @param self The slice to operate on.
1504      * @return A slice containing only the first rune from `self`.
1505      */
1506     function nextRune(slice self) internal returns (slice ret) {
1507         nextRune(self, ret);
1508     }
1509 
1510     /*
1511      * @dev Returns the number of the first codepoint in the slice.
1512      * @param self The slice to operate on.
1513      * @return The number of the first codepoint in the slice.
1514      */
1515     function ord(slice self) internal returns (uint ret) {
1516         if (self._len == 0) {
1517             return 0;
1518         }
1519 
1520         uint word;
1521         uint length;
1522         uint divisor = 2 ** 248;
1523 
1524         // Load the rune into the MSBs of b
1525         assembly { word:= mload(mload(add(self, 32))) }
1526         var b = word / divisor;
1527         if (b < 0x80) {
1528             ret = b;
1529             length = 1;
1530         } else if(b < 0xE0) {
1531             ret = b & 0x1F;
1532             length = 2;
1533         } else if(b < 0xF0) {
1534             ret = b & 0x0F;
1535             length = 3;
1536         } else {
1537             ret = b & 0x07;
1538             length = 4;
1539         }
1540 
1541         // Check for truncated codepoints
1542         if (length > self._len) {
1543             return 0;
1544         }
1545 
1546         for (uint i = 1; i < length; i++) {
1547             divisor = divisor / 256;
1548             b = (word / divisor) & 0xFF;
1549             if (b & 0xC0 != 0x80) {
1550                 // Invalid UTF-8 sequence
1551                 return 0;
1552             }
1553             ret = (ret * 64) | (b & 0x3F);
1554         }
1555 
1556         return ret;
1557     }
1558 
1559     /*
1560      * @dev Returns the keccak-256 hash of the slice.
1561      * @param self The slice to hash.
1562      * @return The hash of the slice.
1563      */
1564     function keccak(slice self) internal returns (bytes32 ret) {
1565         assembly {
1566             ret := keccak256(mload(add(self, 32)), mload(self))
1567         }
1568     }
1569 
1570     /*
1571      * @dev Returns true if `self` starts with `needle`.
1572      * @param self The slice to operate on.
1573      * @param needle The slice to search for.
1574      * @return True if the slice starts with the provided text, false otherwise.
1575      */
1576     function startsWith(slice self, slice needle) internal returns (bool) {
1577         if (self._len < needle._len) {
1578             return false;
1579         }
1580 
1581         if (self._ptr == needle._ptr) {
1582             return true;
1583         }
1584 
1585         bool equal;
1586         assembly {
1587             let length := mload(needle)
1588             let selfptr := mload(add(self, 0x20))
1589             let needleptr := mload(add(needle, 0x20))
1590             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1591         }
1592         return equal;
1593     }
1594 
1595     /*
1596      * @dev If `self` starts with `needle`, `needle` is removed from the
1597      *      beginning of `self`. Otherwise, `self` is unmodified.
1598      * @param self The slice to operate on.
1599      * @param needle The slice to search for.
1600      * @return `self`
1601      */
1602     function beyond(slice self, slice needle) internal returns (slice) {
1603         if (self._len < needle._len) {
1604             return self;
1605         }
1606 
1607         bool equal = true;
1608         if (self._ptr != needle._ptr) {
1609             assembly {
1610                 let length := mload(needle)
1611                 let selfptr := mload(add(self, 0x20))
1612                 let needleptr := mload(add(needle, 0x20))
1613                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1614             }
1615         }
1616 
1617         if (equal) {
1618             self._len -= needle._len;
1619             self._ptr += needle._len;
1620         }
1621 
1622         return self;
1623     }
1624 
1625     /*
1626      * @dev Returns true if the slice ends with `needle`.
1627      * @param self The slice to operate on.
1628      * @param needle The slice to search for.
1629      * @return True if the slice starts with the provided text, false otherwise.
1630      */
1631     function endsWith(slice self, slice needle) internal returns (bool) {
1632         if (self._len < needle._len) {
1633             return false;
1634         }
1635 
1636         var selfptr = self._ptr + self._len - needle._len;
1637 
1638         if (selfptr == needle._ptr) {
1639             return true;
1640         }
1641 
1642         bool equal;
1643         assembly {
1644             let length := mload(needle)
1645             let needleptr := mload(add(needle, 0x20))
1646             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1647         }
1648 
1649         return equal;
1650     }
1651 
1652     /*
1653      * @dev If `self` ends with `needle`, `needle` is removed from the
1654      *      end of `self`. Otherwise, `self` is unmodified.
1655      * @param self The slice to operate on.
1656      * @param needle The slice to search for.
1657      * @return `self`
1658      */
1659     function until(slice self, slice needle) internal returns (slice) {
1660         if (self._len < needle._len) {
1661             return self;
1662         }
1663 
1664         var selfptr = self._ptr + self._len - needle._len;
1665         bool equal = true;
1666         if (selfptr != needle._ptr) {
1667             assembly {
1668                 let length := mload(needle)
1669                 let needleptr := mload(add(needle, 0x20))
1670                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1671             }
1672         }
1673 
1674         if (equal) {
1675             self._len -= needle._len;
1676         }
1677 
1678         return self;
1679     }
1680 
1681     // Returns the memory address of the first byte of the first occurrence of
1682     // `needle` in `self`, or the first byte after `self` if not found.
1683     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1684         uint ptr;
1685         uint idx;
1686 
1687         if (needlelen <= selflen) {
1688             if (needlelen <= 32) {
1689                 // Optimized assembly for 68 gas per byte on short strings
1690                 assembly {
1691                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1692                     let needledata := and(mload(needleptr), mask)
1693                     let end := add(selfptr, sub(selflen, needlelen))
1694                     ptr := selfptr
1695                     loop:
1696                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1697                     ptr := add(ptr, 1)
1698                     jumpi(loop, lt(sub(ptr, 1), end))
1699                     ptr := add(selfptr, selflen)
1700                     exit:
1701                 }
1702                 return ptr;
1703             } else {
1704                 // For long needles, use hashing
1705                 bytes32 hash;
1706                 assembly { hash := sha3(needleptr, needlelen) }
1707                 ptr = selfptr;
1708                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1709                     bytes32 testHash;
1710                     assembly { testHash := sha3(ptr, needlelen) }
1711                     if (hash == testHash)
1712                         return ptr;
1713                     ptr += 1;
1714                 }
1715             }
1716         }
1717         return selfptr + selflen;
1718     }
1719 
1720     // Returns the memory address of the first byte after the last occurrence of
1721     // `needle` in `self`, or the address of `self` if not found.
1722     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1723         uint ptr;
1724 
1725         if (needlelen <= selflen) {
1726             if (needlelen <= 32) {
1727                 // Optimized assembly for 69 gas per byte on short strings
1728                 assembly {
1729                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1730                     let needledata := and(mload(needleptr), mask)
1731                     ptr := add(selfptr, sub(selflen, needlelen))
1732                     loop:
1733                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1734                     ptr := sub(ptr, 1)
1735                     jumpi(loop, gt(add(ptr, 1), selfptr))
1736                     ptr := selfptr
1737                     jump(exit)
1738                     ret:
1739                     ptr := add(ptr, needlelen)
1740                     exit:
1741                 }
1742                 return ptr;
1743             } else {
1744                 // For long needles, use hashing
1745                 bytes32 hash;
1746                 assembly { hash := sha3(needleptr, needlelen) }
1747                 ptr = selfptr + (selflen - needlelen);
1748                 while (ptr >= selfptr) {
1749                     bytes32 testHash;
1750                     assembly { testHash := sha3(ptr, needlelen) }
1751                     if (hash == testHash)
1752                         return ptr + needlelen;
1753                     ptr -= 1;
1754                 }
1755             }
1756         }
1757         return selfptr;
1758     }
1759 
1760     /*
1761      * @dev Modifies `self` to contain everything from the first occurrence of
1762      *      `needle` to the end of the slice. `self` is set to the empty slice
1763      *      if `needle` is not found.
1764      * @param self The slice to search and modify.
1765      * @param needle The text to search for.
1766      * @return `self`.
1767      */
1768     function find(slice self, slice needle) internal returns (slice) {
1769         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1770         self._len -= ptr - self._ptr;
1771         self._ptr = ptr;
1772         return self;
1773     }
1774 
1775     /*
1776      * @dev Modifies `self` to contain the part of the string from the start of
1777      *      `self` to the end of the first occurrence of `needle`. If `needle`
1778      *      is not found, `self` is set to the empty slice.
1779      * @param self The slice to search and modify.
1780      * @param needle The text to search for.
1781      * @return `self`.
1782      */
1783     function rfind(slice self, slice needle) internal returns (slice) {
1784         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1785         self._len = ptr - self._ptr;
1786         return self;
1787     }
1788 
1789     /*
1790      * @dev Splits the slice, setting `self` to everything after the first
1791      *      occurrence of `needle`, and `token` to everything before it. If
1792      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1793      *      and `token` is set to the entirety of `self`.
1794      * @param self The slice to split.
1795      * @param needle The text to search for in `self`.
1796      * @param token An output parameter to which the first token is written.
1797      * @return `token`.
1798      */
1799     function split(slice self, slice needle, slice token) internal returns (slice) {
1800         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1801         token._ptr = self._ptr;
1802         token._len = ptr - self._ptr;
1803         if (ptr == self._ptr + self._len) {
1804             // Not found
1805             self._len = 0;
1806         } else {
1807             self._len -= token._len + needle._len;
1808             self._ptr = ptr + needle._len;
1809         }
1810         return token;
1811     }
1812 
1813     /*
1814      * @dev Splits the slice, setting `self` to everything after the first
1815      *      occurrence of `needle`, and returning everything before it. If
1816      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1817      *      and the entirety of `self` is returned.
1818      * @param self The slice to split.
1819      * @param needle The text to search for in `self`.
1820      * @return The part of `self` up to the first occurrence of `delim`.
1821      */
1822     function split(slice self, slice needle) internal returns (slice token) {
1823         split(self, needle, token);
1824     }
1825 
1826     /*
1827      * @dev Splits the slice, setting `self` to everything before the last
1828      *      occurrence of `needle`, and `token` to everything after it. If
1829      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1830      *      and `token` is set to the entirety of `self`.
1831      * @param self The slice to split.
1832      * @param needle The text to search for in `self`.
1833      * @param token An output parameter to which the first token is written.
1834      * @return `token`.
1835      */
1836     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1837         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1838         token._ptr = ptr;
1839         token._len = self._len - (ptr - self._ptr);
1840         if (ptr == self._ptr) {
1841             // Not found
1842             self._len = 0;
1843         } else {
1844             self._len -= token._len + needle._len;
1845         }
1846         return token;
1847     }
1848 
1849     /*
1850      * @dev Splits the slice, setting `self` to everything before the last
1851      *      occurrence of `needle`, and returning everything after it. If
1852      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1853      *      and the entirety of `self` is returned.
1854      * @param self The slice to split.
1855      * @param needle The text to search for in `self`.
1856      * @return The part of `self` after the last occurrence of `delim`.
1857      */
1858     function rsplit(slice self, slice needle) internal returns (slice token) {
1859         rsplit(self, needle, token);
1860     }
1861 
1862     /*
1863      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1864      * @param self The slice to search.
1865      * @param needle The text to search for in `self`.
1866      * @return The number of occurrences of `needle` found in `self`.
1867      */
1868     function count(slice self, slice needle) internal returns (uint cnt) {
1869         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1870         while (ptr <= self._ptr + self._len) {
1871             cnt++;
1872             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1873         }
1874     }
1875 
1876     /*
1877      * @dev Returns True if `self` contains `needle`.
1878      * @param self The slice to search.
1879      * @param needle The text to search for in `self`.
1880      * @return True if `needle` is found in `self`, false otherwise.
1881      */
1882     function contains(slice self, slice needle) internal returns (bool) {
1883         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1884     }
1885 
1886     /*
1887      * @dev Returns a newly allocated string containing the concatenation of
1888      *      `self` and `other`.
1889      * @param self The first slice to concatenate.
1890      * @param other The second slice to concatenate.
1891      * @return The concatenation of the two strings.
1892      */
1893     function concat(slice self, slice other) internal returns (string) {
1894         var ret = new string(self._len + other._len);
1895         uint retptr;
1896         assembly { retptr := add(ret, 32) }
1897         memcpy(retptr, self._ptr, self._len);
1898         memcpy(retptr + self._len, other._ptr, other._len);
1899         return ret;
1900     }
1901 
1902     /*
1903      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1904      *      newly allocated string.
1905      * @param self The delimiter to use.
1906      * @param parts A list of slices to join.
1907      * @return A newly allocated string containing all the slices in `parts`,
1908      *         joined with `self`.
1909      */
1910     function join(slice self, slice[] parts) internal returns (string) {
1911         if (parts.length == 0)
1912             return "";
1913 
1914         uint length = self._len * (parts.length - 1);
1915         for(uint i = 0; i < parts.length; i++)
1916             length += parts[i]._len;
1917 
1918         var ret = new string(length);
1919         uint retptr;
1920         assembly { retptr := add(ret, 32) }
1921 
1922         for(i = 0; i < parts.length; i++) {
1923             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1924             retptr += parts[i]._len;
1925             if (i < parts.length - 1) {
1926                 memcpy(retptr, self._ptr, self._len);
1927                 retptr += self._len;
1928             }
1929         }
1930 
1931         return ret;
1932     }
1933 }
1934 
1935 
1936 
1937 contract DSSafeAddSub {
1938     function safeToAdd(uint a, uint b) internal returns (bool) {
1939         return (a + b >= a);
1940     }
1941     function safeAdd(uint a, uint b) internal returns (uint) {
1942         if (!safeToAdd(a, b)) throw;
1943         return a + b;
1944     }
1945 
1946     function safeToSubtract(uint a, uint b) internal returns (bool) {
1947         return (b <= a);
1948     }
1949 
1950     function safeSub(uint a, uint b) internal returns (uint) {
1951         if (!safeToSubtract(a, b)) throw;
1952         return a - b;
1953     } 
1954 }
1955 
1956 contract Bandit is usingOraclize, DSSafeAddSub {
1957 
1958 	/*
1959      * allow to recieve money
1960     */
1961 	function () public payable {}
1962 
1963     using strings for *;
1964 	
1965 	/*
1966      * checks game is currently active
1967     */
1968     modifier gameIsActive {
1969         if(gamePaused == true) throw;
1970 		_;
1971     }
1972 	
1973 	/*
1974      * checks player bet size is within range
1975     */
1976     modifier betIsValid(uint _betSize) {      
1977 		if(_betSize < minBet || _betSize > maxBet) throw;
1978 		_;
1979     }
1980 	
1981 	/*
1982      * checks only Oraclize address is calling
1983     */
1984     modifier onlyOraclize {
1985         if (msg.sender != oraclize_cbAddress()) throw;
1986         _;
1987     }
1988 	
1989 	
1990 	/*
1991      * checks only owner address is calling
1992     */
1993     modifier onlyOwner {
1994          if (msg.sender != owner) throw;
1995          _;
1996     }
1997 	
1998 	
1999 	/*
2000      * game vars
2001     */
2002 	bool public gamePaused;
2003 	address public owner;
2004 	uint public minBet;
2005 	uint public maxBet;
2006 	uint32 public gasForOraclize;
2007 	int public totalBets = 0;
2008 	uint public totalWeiWagered = 0;
2009 	uint public totalWeiWon = 0;
2010 	uint public randomQueryID;
2011 	
2012 	/*
2013      * player vars
2014     */
2015     mapping (bytes32 => address) playerAddress;
2016     mapping (bytes32 => address) playerTempAddress;
2017     mapping (bytes32 => bytes32) playerBetId;
2018     mapping (bytes32 => uint) playerBetValue;
2019     mapping (bytes32 => uint) playerTempBetValue;       
2020     mapping (bytes32 => string) playerDieResult;
2021     mapping (address => uint) playerPendingWithdrawals;      
2022     mapping (bytes32 => uint) playerTempReward;
2023 	
2024 	
2025 	/*
2026      * events
2027     */
2028     /* log bets + output to web3 for precise 'payout on win' field in UI */
2029     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint BetValue);      
2030     /* output to web3 UI on bet result*/
2031     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
2032 	event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, string DiceResult, uint Value, uint Multiplier, int Status, bytes Proof);   
2033     /* log manual refunds */
2034     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
2035     /* log owner transfers */
2036     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
2037 	
2038 	
2039 	/*
2040      * init
2041     */
2042     function Bandit() {
2043 
2044         owner = msg.sender;     
2045         /* use TLSNotary for oraclize call */
2046         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
2047         /* init min bet (0.1 ether) */
2048         ownerSetMinBet(50000000000000000);
2049 		ownerSetMaxBet(1000000000000000000);
2050         /* init gas for oraclize */        
2051         gasForOraclize = 250000;
2052         /* init gas price for callback (default 20 gwei)*/
2053         oraclize_setCustomGasPrice(20000000000 wei);		
2054 
2055     }
2056 	
2057 	
2058 	/*
2059      * public function
2060      * player submit bet
2061      * only if game is active & bet is valid can query oraclize and set player vars     
2062     */
2063     function playerPull() public 
2064         payable
2065         gameIsActive
2066         betIsValid(msg.value)
2067 	{       
2068 
2069         /*
2070         * assign partially encrypted query to oraclize
2071         * only the apiKey is encrypted 
2072         * integer query is in plain text
2073         */               
2074 		randomQueryID += 1;
2075         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BLZ8vZRQmLd5fkKkvByDhERZrrM9fPZRBSORtfzLooOhTaYlCP8aLDOACqDuSPL6tX75mlJVZxrBJFoqyS9X2BfwrsKih76dfkB946Gii8eDyQk3bvLdswaHqtq7m87lbmhw/6ZF9MY9iz0p9jtvulRS4EzMU8E=},\"n\":3,\"min\":1,\"max\":20,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":";
2076         string memory queryString2 = uint2str(randomQueryID);
2077         string memory queryString3 = "${[identity] \"}\"}']";
2078 		
2079 		string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
2080 
2081         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
2082 
2083         bytes32 rngId = oraclize_query("nested", queryString1_2_3, gasForOraclize);
2084 		
2085 		
2086 		
2087         /* map bet id to this oraclize query */
2088 		playerBetId[rngId] = rngId;
2089         /* map value of wager to this oraclize query */
2090         playerBetValue[rngId] = msg.value;
2091         /* map player address to this oraclize query */
2092         playerAddress[rngId] = msg.sender;
2093 		
2094 		
2095         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
2096         LogBet(playerBetId[rngId], playerAddress[rngId], playerBetValue[rngId]);          
2097 
2098     }
2099 	
2100 	
2101 	/*
2102     * semi-public function - only oraclize can call
2103     */
2104     /*TLSNotary for oraclize call */
2105 	function __callback(bytes32 myid, string result, bytes proof) public   
2106 		onlyOraclize
2107 	{  
2108 
2109         /* player address mapped to query id does not exist */
2110         if (playerAddress[myid]==0x0) throw;	
2111 		
2112         
2113         /* keep oraclize honest by retrieving the serialNumber from random.org result */
2114         var sl_result = result.toSlice();
2115         sl_result.beyond("[".toSlice()).until("]".toSlice());
2116         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());      
2117 		
2118 		
2119 
2120 	    /* map result to player */
2121         playerDieResult[myid] = sl_result.beyond("[".toSlice()).until("]".toSlice()).toString();
2122 		
2123 		/* parse a number for each barrel */
2124 		var first_barrel = parseInt(sl_result.split(', '.toSlice()).toString());
2125 		var second_barrel = parseInt(sl_result.split(', '.toSlice()).toString());
2126 		var third_barrel = parseInt(sl_result.split(', '.toSlice()).toString());
2127         
2128         /* get the playerAddress for this query id */
2129         playerTempAddress[myid] = playerAddress[myid];
2130         /* delete playerAddress for this query id */
2131         delete playerAddress[myid];         
2132 
2133         /* map the playerBetValue for this query id */
2134         playerTempBetValue[myid] = playerBetValue[myid];
2135         /* set  playerBetValue for this query id to 0 */
2136         playerBetValue[myid] = 0;
2137 		/* set  miltiplier for this query 0 */
2138 		var miltiplier = 0;		
2139 
2140         /* total number of bets */
2141         totalBets += 1;
2142 
2143         /* total wagered */
2144         totalWeiWagered += playerTempBetValue[myid];                                                           
2145 
2146         /*
2147         * refund
2148         * if result is 0 result is empty or no proof refund original bet value
2149         * if refund fails save refund value to playerPendingWithdrawals
2150         */
2151         if(parseInt(playerDieResult[myid])==0 || bytes(result).length == 0 || bytes(proof).length == 0){                                                     
2152 
2153              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerDieResult[myid], playerTempBetValue[myid], miltiplier, 3, proof);            
2154 
2155             /*
2156             * send refund - external call to an untrusted contract
2157             * if send fails map refund value to playerPendingWithdrawals[address]
2158             * for withdrawal later via playerWithdrawPendingTransactions
2159             */
2160             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
2161                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerDieResult[myid], playerTempBetValue[myid], miltiplier, 4, proof);              
2162                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2163                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
2164             }
2165 
2166             return;
2167         }
2168 
2169 		
2170 		
2171 		/*
2172 		*Count miltiplier
2173 		*/
2174 		
2175 		/*
2176 		Cast Jackpot - 777
2177 		*/
2178 		if(first_barrel == 7 && second_barrel == 7 && third_barrel == 7)
2179 		{
2180 			miltiplier = 20;
2181 		}
2182 		
2183 		/*
2184 		Any Cherry
2185 		*/
2186 		if(first_barrel == 4 || first_barrel == 11 || first_barrel == 18 || second_barrel == 13 || second_barrel == 19 || third_barrel == 5 || third_barrel == 11 || third_barrel == 18)
2187 		{
2188 			miltiplier = 2;
2189 		}
2190 		
2191 		/*
2192 		3 Cherry
2193 		*/
2194 		if((first_barrel == 4 || first_barrel == 11 || first_barrel == 18) && (second_barrel == 13 || second_barrel == 19) && (third_barrel == 5 || third_barrel == 11 || third_barrel == 18))
2195 		{
2196 			miltiplier = 7;
2197 		}
2198 		
2199 		/*
2200 		3 Bananas
2201 		*/
2202 		if((first_barrel == 1 || first_barrel == 5 || first_barrel == 12 || first_barrel == 14 || first_barrel == 16 || first_barrel == 20) && (second_barrel == 2 || second_barrel == 5|| second_barrel == 8|| second_barrel == 10 || second_barrel == 16 || second_barrel == 20) && (third_barrel == 2 || third_barrel == 4 || third_barrel == 8 || third_barrel == 13 || third_barrel == 15))
2203 		{
2204 			miltiplier = 3;
2205 		}
2206 		
2207 		/*
2208 		3 Any bars
2209 		*/
2210 		if((first_barrel == 2 || first_barrel == 6 || first_barrel == 9 || first_barrel == 13) && (second_barrel == 1 || second_barrel == 3 || second_barrel == 9 || second_barrel == 11 || second_barrel == 17) && (third_barrel == 1 || third_barrel == 3 || third_barrel == 6 || third_barrel == 9 || third_barrel == 12 || third_barrel == 14 || third_barrel == 20))
2211 		{
2212 			miltiplier = 5;
2213 		}
2214 		
2215 		/*
2216 		3 One bars
2217 		*/
2218 		if((first_barrel == 2 || first_barrel == 9) && (second_barrel == 3 || second_barrel == 17) && (third_barrel == 3 || third_barrel == 12 || third_barrel == 14))
2219 		{
2220 			miltiplier = 10;
2221 		}
2222 		
2223 		/*
2224 		3 Two bars
2225 		*/
2226 		if((first_barrel == 6) && (second_barrel == 1 || second_barrel == 11) && (third_barrel == 6 || third_barrel == 9))
2227 		{
2228 			miltiplier = 12;
2229 		}
2230 		
2231 		/*
2232 		3 Three bars
2233 		*/
2234 		if((first_barrel == 13) && (second_barrel == 9) && (third_barrel == 1 || third_barrel == 20))
2235 		{
2236 			miltiplier = 15;
2237 		}
2238 		
2239 		
2240         /*
2241 		* count profit
2242         * pay winner
2243         * send reward
2244         * if send of reward fails save value to playerPendingWithdrawals        
2245         */
2246         if(miltiplier > 0){ 
2247 
2248 			playerTempReward[myid] = playerTempBetValue[myid] * miltiplier;
2249 
2250             /* update total wei won */
2251             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
2252 
2253             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerDieResult[myid], playerTempReward[myid], miltiplier, 1, proof);                            
2254 
2255             
2256             /*
2257             * send win - external call to an untrusted contract
2258             * if send fails map reward value to playerPendingWithdrawals[address]
2259             * for withdrawal later via playerWithdrawPendingTransactions
2260             */
2261             if(!playerTempAddress[myid].send(playerTempReward[myid])){
2262                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerDieResult[myid], playerTempReward[myid], miltiplier, 2, proof);                   
2263                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2264                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
2265             }
2266 
2267             return;
2268 
2269         }
2270 
2271         /*
2272         * no win
2273         * send 1 wei to a losing bet
2274         * update contract balance
2275         */
2276         if(miltiplier == 0){
2277 
2278             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerDieResult[myid], playerTempBetValue[myid], miltiplier, 0, proof);                                                                                                      
2279 
2280             /*
2281             * send 1 wei - external call to an untrusted contract                  
2282             */
2283             if(!playerTempAddress[myid].send(1)){
2284                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
2285                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
2286             }                                   
2287 
2288             return;
2289 
2290         }
2291 
2292     }
2293 
2294 
2295 	
2296 	
2297 	/*
2298     * public function
2299     * in case of a failed refund or win send
2300     */
2301     function playerWithdrawPendingTransactions() public 
2302         returns (bool)
2303      {
2304         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
2305         playerPendingWithdrawals[msg.sender] = 0;
2306         /* external call to untrusted contract */
2307         if (msg.sender.call.value(withdrawAmount)()) {
2308             return true;
2309         } else {
2310             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
2311             /* player can try to withdraw again later */
2312             playerPendingWithdrawals[msg.sender] = withdrawAmount;
2313             return false;
2314         }
2315     }
2316 	
2317 	
2318 	/* check for pending withdrawals  */
2319     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
2320         return playerPendingWithdrawals[addressToCheck];
2321     }
2322 	
2323 	
2324 	/*
2325     * internal function
2326     */
2327 	
2328 	
2329     /* Only owner address can do manual refund
2330     * used only if bet placed + oraclize failed to __callback
2331     * filter LogBet by address and/or playerBetId:
2332     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerBetValue[rngId], playerNumber[rngId]);
2333     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
2334     * LogResult or LogRefund
2335     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
2336     */
2337     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
2338 		onlyOwner
2339     {
2340         /* send refund */
2341         if(!sendTo.send(originalPlayerBetValue)) throw;
2342         /* log refunds */
2343         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
2344     }  	
2345 	
2346 	/*set gas for oraclize query */
2347     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
2348 		onlyOwner
2349 	{
2350     	gasForOraclize = newSafeGasToOraclize;
2351     }
2352 	
2353 	/* only owner address can set minBet */
2354     function ownerSetMinBet(uint newMinimumBet) public 
2355 		onlyOwner
2356     {
2357         minBet = newMinimumBet;
2358     }
2359 	
2360 	/* only owner address can set maxBet */
2361     function ownerSetMaxBet(uint newMaxBet) public 
2362 		onlyOwner
2363     {
2364         maxBet = newMaxBet;
2365     } 
2366 	
2367 	
2368 	/* only owner address can set emergency pause #1 */
2369     function ownerPauseGame(bool newStatus) public 
2370 		onlyOwner
2371     {
2372 		gamePaused = newStatus;
2373     }
2374 	
2375 	/* only owner address can set owner address */
2376     function ownerChangeOwner(address newOwner) public 
2377 		onlyOwner
2378 	{
2379         owner = newOwner;
2380     }
2381 	
2382 	/* only owner address can suicide - emergency */
2383     function ownerkill() public 
2384 		onlyOwner
2385 	{
2386 		suicide(owner);
2387 	}
2388 	
2389 	/* only owner address can withdraw */
2390     function withdrawBalance(uint256 cash) public 
2391 		onlyOwner
2392 	{
2393 		uint256 balance = this.balance;
2394         if (balance > cash) {
2395             owner.send(cash);
2396         }
2397 	} 
2398 	
2399 }