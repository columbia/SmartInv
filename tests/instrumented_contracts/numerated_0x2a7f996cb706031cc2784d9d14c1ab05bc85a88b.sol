1 pragma solidity ^0.4.21;
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
88     function init(buffer memory buf, uint _capacity) internal constant {
89         uint capacity = _capacity;
90         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
91         // Allocate space for the buffer data
92         buf.capacity = capacity;
93         assembly {
94             let ptr := mload(0x40)
95             mstore(buf, ptr)
96             mstore(ptr, 0)
97             mstore(0x40, add(ptr, capacity))
98         }
99     }
100 
101     function resize(buffer memory buf, uint capacity) private constant {
102         bytes memory oldbuf = buf.buf;
103         init(buf, capacity);
104         append(buf, oldbuf);
105     }
106 
107     function max(uint a, uint b) private constant returns(uint) {
108         if(a > b) {
109             return a;
110         }
111         return b;
112     }
113 
114     /**
115      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
116      *      would exceed the capacity of the buffer.
117      * @param buf The buffer to append to.
118      * @param data The data to append.
119      * @return The original buffer.
120      */
121     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
122         if(data.length + buf.buf.length > buf.capacity) {
123             resize(buf, max(buf.capacity, data.length) * 2);
124         }
125 
126         uint dest;
127         uint src;
128         uint len = data.length;
129         assembly {
130             // Memory address of the buffer data
131             let bufptr := mload(buf)
132             // Length of existing buffer data
133             let buflen := mload(bufptr)
134             // Start address = buffer address + buffer length + sizeof(buffer length)
135             dest := add(add(bufptr, buflen), 32)
136             // Update buffer length
137             mstore(bufptr, add(buflen, mload(data)))
138             src := add(data, 32)
139         }
140 
141         // Copy word-length chunks while possible
142         for(; len >= 32; len -= 32) {
143             assembly {
144                 mstore(dest, mload(src))
145             }
146             dest += 32;
147             src += 32;
148         }
149 
150         // Copy remaining bytes
151         uint mask = 256 ** (32 - len) - 1;
152         assembly {
153             let srcpart := and(mload(src), not(mask))
154             let destpart := and(mload(dest), mask)
155             mstore(dest, or(destpart, srcpart))
156         }
157 
158         return buf;
159     }
160 
161     /**
162      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
163      * exceed the capacity of the buffer.
164      * @param buf The buffer to append to.
165      * @param data The data to append.
166      * @return The original buffer.
167      */
168     function append(buffer memory buf, uint8 data) internal constant {
169         if(buf.buf.length + 1 > buf.capacity) {
170             resize(buf, buf.capacity * 2);
171         }
172 
173         assembly {
174             // Memory address of the buffer data
175             let bufptr := mload(buf)
176             // Length of existing buffer data
177             let buflen := mload(bufptr)
178             // Address = buffer address + buffer length + sizeof(buffer length)
179             let dest := add(add(bufptr, buflen), 32)
180             mstore8(dest, data)
181             // Update buffer length
182             mstore(bufptr, add(buflen, 1))
183         }
184     }
185 
186     /**
187      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
188      * exceed the capacity of the buffer.
189      * @param buf The buffer to append to.
190      * @param data The data to append.
191      * @return The original buffer.
192      */
193     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
194         if(len + buf.buf.length > buf.capacity) {
195             resize(buf, max(buf.capacity, len) * 2);
196         }
197 
198         uint mask = 256 ** len - 1;
199         assembly {
200             // Memory address of the buffer data
201             let bufptr := mload(buf)
202             // Length of existing buffer data
203             let buflen := mload(bufptr)
204             // Address = buffer address + buffer length + sizeof(buffer length) + len
205             let dest := add(add(bufptr, buflen), len)
206             mstore(dest, or(and(mload(dest), not(mask)), data))
207             // Update buffer length
208             mstore(bufptr, add(buflen, len))
209         }
210         return buf;
211     }
212 }
213 
214 library CBOR {
215     using Buffer for Buffer.buffer;
216 
217     uint8 private constant MAJOR_TYPE_INT = 0;
218     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
219     uint8 private constant MAJOR_TYPE_BYTES = 2;
220     uint8 private constant MAJOR_TYPE_STRING = 3;
221     uint8 private constant MAJOR_TYPE_ARRAY = 4;
222     uint8 private constant MAJOR_TYPE_MAP = 5;
223     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
224 
225     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
226         return x * (2 ** y);
227     }
228 
229     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
230         if(value <= 23) {
231             buf.append(uint8(shl8(major, 5) | value));
232         } else if(value <= 0xFF) {
233             buf.append(uint8(shl8(major, 5) | 24));
234             buf.appendInt(value, 1);
235         } else if(value <= 0xFFFF) {
236             buf.append(uint8(shl8(major, 5) | 25));
237             buf.appendInt(value, 2);
238         } else if(value <= 0xFFFFFFFF) {
239             buf.append(uint8(shl8(major, 5) | 26));
240             buf.appendInt(value, 4);
241         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
242             buf.append(uint8(shl8(major, 5) | 27));
243             buf.appendInt(value, 8);
244         }
245     }
246 
247     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
248         buf.append(uint8(shl8(major, 5) | 31));
249     }
250 
251     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
252         encodeType(buf, MAJOR_TYPE_INT, value);
253     }
254 
255     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
256         if(value >= 0) {
257             encodeType(buf, MAJOR_TYPE_INT, uint(value));
258         } else {
259             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
260         }
261     }
262 
263     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
264         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
265         buf.append(value);
266     }
267 
268     function encodeString(Buffer.buffer memory buf, string value) internal constant {
269         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
270         buf.append(bytes(value));
271     }
272 
273     function startArray(Buffer.buffer memory buf) internal constant {
274         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
275     }
276 
277     function startMap(Buffer.buffer memory buf) internal constant {
278         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
279     }
280 
281     function endSequence(Buffer.buffer memory buf) internal constant {
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
320         oraclize.useCoupon(code);
321         _;
322     }
323 
324     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
325         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
326             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
327             oraclize_setNetworkName("eth_mainnet");
328             return true;
329         }
330         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
331             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
332             oraclize_setNetworkName("eth_ropsten3");
333             return true;
334         }
335         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
336             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
337             oraclize_setNetworkName("eth_kovan");
338             return true;
339         }
340         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
341             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
342             oraclize_setNetworkName("eth_rinkeby");
343             return true;
344         }
345         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
346             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
347             return true;
348         }
349         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
350             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
351             return true;
352         }
353         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
354             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
355             return true;
356         }
357         return false;
358     }
359 
360     function __callback(bytes32 myid, string result) {
361         __callback(myid, result, new bytes(0));
362     }
363     function __callback(bytes32 myid, string result, bytes proof) {
364     }
365 
366     function oraclize_useCoupon(string code) oraclizeAPI internal {
367         oraclize.useCoupon(code);
368     }
369 
370     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
371         return oraclize.getPrice(datasource);
372     }
373 
374     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
375         return oraclize.getPrice(datasource, gaslimit);
376     }
377 
378     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource);
380         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
381         return oraclize.query.value(price)(0, datasource, arg);
382     }
383     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         return oraclize.query.value(price)(timestamp, datasource, arg);
387     }
388     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource, gaslimit);
390         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
391         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
392     }
393     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource, gaslimit);
395         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
396         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
397     }
398     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource);
400         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
401         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
402     }
403     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
404         uint price = oraclize.getPrice(datasource);
405         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
406         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
407     }
408     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource, gaslimit);
410         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
411         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
412     }
413     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource, gaslimit);
415         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
416         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
417     }
418     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource);
420         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN.value(price)(0, datasource, args);
423     }
424     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource);
426         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
427         bytes memory args = stra2cbor(argN);
428         return oraclize.queryN.value(price)(timestamp, datasource, args);
429     }
430     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         bytes memory args = stra2cbor(argN);
434         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
435     }
436     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource, gaslimit);
438         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
439         bytes memory args = stra2cbor(argN);
440         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
441     }
442     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
443         string[] memory dynargs = new string[](1);
444         dynargs[0] = args[0];
445         return oraclize_query(datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](1);
449         dynargs[0] = args[0];
450         return oraclize_query(timestamp, datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](1);
454         dynargs[0] = args[0];
455         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
456     }
457     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](1);
459         dynargs[0] = args[0];
460         return oraclize_query(datasource, dynargs, gaslimit);
461     }
462 
463     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](2);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         return oraclize_query(timestamp, datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](2);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
480     }
481     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](2);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         return oraclize_query(datasource, dynargs, gaslimit);
486     }
487     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
488         string[] memory dynargs = new string[](3);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         return oraclize_query(datasource, dynargs);
493     }
494     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](3);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         return oraclize_query(timestamp, datasource, dynargs);
500     }
501     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         string[] memory dynargs = new string[](3);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
507     }
508     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](3);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         return oraclize_query(datasource, dynargs, gaslimit);
514     }
515 
516     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](4);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         dynargs[3] = args[3];
522         return oraclize_query(datasource, dynargs);
523     }
524     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](4);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         dynargs[3] = args[3];
530         return oraclize_query(timestamp, datasource, dynargs);
531     }
532     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](4);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](4);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         return oraclize_query(datasource, dynargs, gaslimit);
547     }
548     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](5);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         dynargs[4] = args[4];
555         return oraclize_query(datasource, dynargs);
556     }
557     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](5);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         dynargs[3] = args[3];
563         dynargs[4] = args[4];
564         return oraclize_query(timestamp, datasource, dynargs);
565     }
566     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](5);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         dynargs[3] = args[3];
572         dynargs[4] = args[4];
573         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
574     }
575     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
576         string[] memory dynargs = new string[](5);
577         dynargs[0] = args[0];
578         dynargs[1] = args[1];
579         dynargs[2] = args[2];
580         dynargs[3] = args[3];
581         dynargs[4] = args[4];
582         return oraclize_query(datasource, dynargs, gaslimit);
583     }
584     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource);
586         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN.value(price)(0, datasource, args);
589     }
590     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource);
592         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
593         bytes memory args = ba2cbor(argN);
594         return oraclize.queryN.value(price)(timestamp, datasource, args);
595     }
596     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
597         uint price = oraclize.getPrice(datasource, gaslimit);
598         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
599         bytes memory args = ba2cbor(argN);
600         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
601     }
602     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
603         uint price = oraclize.getPrice(datasource, gaslimit);
604         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
605         bytes memory args = ba2cbor(argN);
606         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
607     }
608     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
609         bytes[] memory dynargs = new bytes[](1);
610         dynargs[0] = args[0];
611         return oraclize_query(datasource, dynargs);
612     }
613     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](1);
615         dynargs[0] = args[0];
616         return oraclize_query(timestamp, datasource, dynargs);
617     }
618     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](1);
620         dynargs[0] = args[0];
621         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
622     }
623     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](1);
625         dynargs[0] = args[0];
626         return oraclize_query(datasource, dynargs, gaslimit);
627     }
628 
629     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](2);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         return oraclize_query(timestamp, datasource, dynargs);
640     }
641     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](2);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
646     }
647     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](2);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         return oraclize_query(datasource, dynargs, gaslimit);
652     }
653     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
654         bytes[] memory dynargs = new bytes[](3);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         return oraclize_query(datasource, dynargs);
659     }
660     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](3);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         return oraclize_query(timestamp, datasource, dynargs);
666     }
667     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
668         bytes[] memory dynargs = new bytes[](3);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         dynargs[2] = args[2];
672         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
673     }
674     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](3);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         return oraclize_query(datasource, dynargs, gaslimit);
680     }
681 
682     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](4);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         return oraclize_query(datasource, dynargs);
689     }
690     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
691         bytes[] memory dynargs = new bytes[](4);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         return oraclize_query(timestamp, datasource, dynargs);
697     }
698     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](4);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         dynargs[2] = args[2];
703         dynargs[3] = args[3];
704         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
705     }
706     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](4);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         return oraclize_query(datasource, dynargs, gaslimit);
713     }
714     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
715         bytes[] memory dynargs = new bytes[](5);
716         dynargs[0] = args[0];
717         dynargs[1] = args[1];
718         dynargs[2] = args[2];
719         dynargs[3] = args[3];
720         dynargs[4] = args[4];
721         return oraclize_query(datasource, dynargs);
722     }
723     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](5);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         dynargs[4] = args[4];
730         return oraclize_query(timestamp, datasource, dynargs);
731     }
732     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](5);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         dynargs[3] = args[3];
738         dynargs[4] = args[4];
739         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
740     }
741     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
742         bytes[] memory dynargs = new bytes[](5);
743         dynargs[0] = args[0];
744         dynargs[1] = args[1];
745         dynargs[2] = args[2];
746         dynargs[3] = args[3];
747         dynargs[4] = args[4];
748         return oraclize_query(datasource, dynargs, gaslimit);
749     }
750 
751     function oraclize_cbAddress() oraclizeAPI internal returns (address){
752         return oraclize.cbAddress();
753     }
754     function oraclize_setProof(byte proofP) oraclizeAPI internal {
755         return oraclize.setProofType(proofP);
756     }
757     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
758         return oraclize.setCustomGasPrice(gasPrice);
759     }
760     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
761         return oraclize.setConfig(config);
762     }
763 
764     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
765         return oraclize.randomDS_getSessionPubKeyHash();
766     }
767 
768     function getCodeSize(address _addr) constant internal returns(uint _size) {
769         assembly {
770             _size := extcodesize(_addr)
771         }
772     }
773 
774     function parseAddr(string _a) internal returns (address){
775         bytes memory tmp = bytes(_a);
776         uint160 iaddr = 0;
777         uint160 b1;
778         uint160 b2;
779         for (uint i=2; i<2+2*20; i+=2){
780             iaddr *= 256;
781             b1 = uint160(tmp[i]);
782             b2 = uint160(tmp[i+1]);
783             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
784             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
785             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
786             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
787             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
788             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
789             iaddr += (b1*16+b2);
790         }
791         return address(iaddr);
792     }
793 
794     function strCompare(string _a, string _b) internal returns (int) {
795         bytes memory a = bytes(_a);
796         bytes memory b = bytes(_b);
797         uint minLength = a.length;
798         if (b.length < minLength) minLength = b.length;
799         for (uint i = 0; i < minLength; i ++)
800             if (a[i] < b[i])
801                 return -1;
802             else if (a[i] > b[i])
803                 return 1;
804         if (a.length < b.length)
805             return -1;
806         else if (a.length > b.length)
807             return 1;
808         else
809             return 0;
810     }
811 
812     function indexOf(string _haystack, string _needle) internal returns (int) {
813         bytes memory h = bytes(_haystack);
814         bytes memory n = bytes(_needle);
815         if(h.length < 1 || n.length < 1 || (n.length > h.length))
816             return -1;
817         else if(h.length > (2**128 -1))
818             return -1;
819         else
820         {
821             uint subindex = 0;
822             for (uint i = 0; i < h.length; i ++)
823             {
824                 if (h[i] == n[0])
825                 {
826                     subindex = 1;
827                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
828                     {
829                         subindex++;
830                     }
831                     if(subindex == n.length)
832                         return int(i);
833                 }
834             }
835             return -1;
836         }
837     }
838 
839     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
840         bytes memory _ba = bytes(_a);
841         bytes memory _bb = bytes(_b);
842         bytes memory _bc = bytes(_c);
843         bytes memory _bd = bytes(_d);
844         bytes memory _be = bytes(_e);
845         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
846         bytes memory babcde = bytes(abcde);
847         uint k = 0;
848         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
849         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
850         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
851         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
852         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
853         return string(babcde);
854     }
855 
856     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
857         return strConcat(_a, _b, _c, _d, "");
858     }
859 
860     function strConcat(string _a, string _b, string _c) internal returns (string) {
861         return strConcat(_a, _b, _c, "", "");
862     }
863 
864     function strConcat(string _a, string _b) internal returns (string) {
865         return strConcat(_a, _b, "", "", "");
866     }
867 
868     // parseInt
869     function parseInt(string _a) internal returns (uint) {
870         return parseInt(_a, 0);
871     }
872 
873     // parseInt(parseFloat*10^_b)
874     function parseInt(string _a, uint _b) internal returns (uint) {
875         bytes memory bresult = bytes(_a);
876         uint mint = 0;
877         bool decimals = false;
878         for (uint i=0; i<bresult.length; i++){
879             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
880                 if (decimals){
881                    if (_b == 0) break;
882                     else _b--;
883                 }
884                 mint *= 10;
885                 mint += uint(bresult[i]) - 48;
886             } else if (bresult[i] == 46) decimals = true;
887         }
888         if (_b > 0) mint *= 10**_b;
889         return mint;
890     }
891 
892     function uint2str(uint i) internal returns (string){
893         if (i == 0) return "0";
894         uint j = i;
895         uint len;
896         while (j != 0){
897             len++;
898             j /= 10;
899         }
900         bytes memory bstr = new bytes(len);
901         uint k = len - 1;
902         while (i != 0){
903             bstr[k--] = byte(48 + i % 10);
904             i /= 10;
905         }
906         return string(bstr);
907     }
908 
909     using CBOR for Buffer.buffer;
910     function stra2cbor(string[] arr) internal constant returns (bytes) {
911         safeMemoryCleaner();
912         Buffer.buffer memory buf;
913         Buffer.init(buf, 1024);
914         buf.startArray();
915         for (uint i = 0; i < arr.length; i++) {
916             buf.encodeString(arr[i]);
917         }
918         buf.endSequence();
919         return buf.buf;
920     }
921 
922     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
923         safeMemoryCleaner();
924         Buffer.buffer memory buf;
925         Buffer.init(buf, 1024);
926         buf.startArray();
927         for (uint i = 0; i < arr.length; i++) {
928             buf.encodeBytes(arr[i]);
929         }
930         buf.endSequence();
931         return buf.buf;
932     }
933 
934     string oraclize_network_name;
935     function oraclize_setNetworkName(string _network_name) internal {
936         oraclize_network_name = _network_name;
937     }
938 
939     function oraclize_getNetworkName() internal returns (string) {
940         return oraclize_network_name;
941     }
942 
943     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
944         if ((_nbytes == 0)||(_nbytes > 32)) throw;
945 	// Convert from seconds to ledger timer ticks
946         _delay *= 10;
947         bytes memory nbytes = new bytes(1);
948         nbytes[0] = byte(_nbytes);
949         bytes memory unonce = new bytes(32);
950         bytes memory sessionKeyHash = new bytes(32);
951         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
952         assembly {
953             mstore(unonce, 0x20)
954             // the following variables can be relaxed
955             // check relaxed random contract under ethereum-examples repo
956             // for an idea on how to override and replace comit hash vars
957             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
958             mstore(sessionKeyHash, 0x20)
959             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
960         }
961         bytes memory delay = new bytes(32);
962         assembly {
963             mstore(add(delay, 0x20), _delay)
964         }
965 
966         bytes memory delay_bytes8 = new bytes(8);
967         copyBytes(delay, 24, 8, delay_bytes8, 0);
968 
969         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
970         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
971 
972         bytes memory delay_bytes8_left = new bytes(8);
973 
974         assembly {
975             let x := mload(add(delay_bytes8, 0x20))
976             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
978             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
979             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
980             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
981             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
982             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
983             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
984 
985         }
986 
987         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
988         return queryId;
989     }
990 
991     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
992         oraclize_randomDS_args[queryId] = commitment;
993     }
994 
995     mapping(bytes32=>bytes32) oraclize_randomDS_args;
996     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
997 
998     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
999         bool sigok;
1000         address signer;
1001 
1002         bytes32 sigr;
1003         bytes32 sigs;
1004 
1005         bytes memory sigr_ = new bytes(32);
1006         uint offset = 4+(uint(dersig[3]) - 0x20);
1007         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1008         bytes memory sigs_ = new bytes(32);
1009         offset += 32 + 2;
1010         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1011 
1012         assembly {
1013             sigr := mload(add(sigr_, 32))
1014             sigs := mload(add(sigs_, 32))
1015         }
1016 
1017 
1018         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1019         if (address(sha3(pubkey)) == signer) return true;
1020         else {
1021             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1022             return (address(sha3(pubkey)) == signer);
1023         }
1024     }
1025 
1026     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1027         bool sigok;
1028 
1029         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1030         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1031         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1032 
1033         bytes memory appkey1_pubkey = new bytes(64);
1034         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1035 
1036         bytes memory tosign2 = new bytes(1+65+32);
1037         tosign2[0] = 1; //role
1038         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1039         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1040         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1041         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1042 
1043         if (sigok == false) return false;
1044 
1045 
1046         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1047         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1048 
1049         bytes memory tosign3 = new bytes(1+65);
1050         tosign3[0] = 0xFE;
1051         copyBytes(proof, 3, 65, tosign3, 1);
1052 
1053         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1054         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1055 
1056         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1057 
1058         return sigok;
1059     }
1060 
1061     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1062         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1063         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1064 
1065         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1066         if (proofVerified == false) throw;
1067 
1068         _;
1069     }
1070 
1071     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1072         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1073         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1074 
1075         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1076         if (proofVerified == false) return 2;
1077 
1078         return 0;
1079     }
1080 
1081     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1082         bool match_ = true;
1083 
1084 	if (prefix.length != n_random_bytes) throw;
1085 
1086         for (uint256 i=0; i< n_random_bytes; i++) {
1087             if (content[i] != prefix[i]) match_ = false;
1088         }
1089 
1090         return match_;
1091     }
1092 
1093     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1094 
1095         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1096         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1097         bytes memory keyhash = new bytes(32);
1098         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1099         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1100 
1101         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1102         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1103 
1104         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1105         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1106 
1107         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1108         // This is to verify that the computed args match with the ones specified in the query.
1109         bytes memory commitmentSlice1 = new bytes(8+1+32);
1110         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1111 
1112         bytes memory sessionPubkey = new bytes(64);
1113         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1114         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1115 
1116         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1117         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1118             delete oraclize_randomDS_args[queryId];
1119         } else return false;
1120 
1121 
1122         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1123         bytes memory tosign1 = new bytes(32+8+1+32);
1124         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1125         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1126 
1127         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1128         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1129             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1130         }
1131 
1132         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1133     }
1134 
1135 
1136     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1137     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1138         uint minLength = length + toOffset;
1139 
1140         if (to.length < minLength) {
1141             // Buffer too small
1142             throw; // Should be a better way?
1143         }
1144 
1145         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1146         uint i = 32 + fromOffset;
1147         uint j = 32 + toOffset;
1148 
1149         while (i < (32 + fromOffset + length)) {
1150             assembly {
1151                 let tmp := mload(add(from, i))
1152                 mstore(add(to, j), tmp)
1153             }
1154             i += 32;
1155             j += 32;
1156         }
1157 
1158         return to;
1159     }
1160 
1161     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1162     // Duplicate Solidity's ecrecover, but catching the CALL return value
1163     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1164         // We do our own memory management here. Solidity uses memory offset
1165         // 0x40 to store the current end of memory. We write past it (as
1166         // writes are memory extensions), but don't update the offset so
1167         // Solidity will reuse it. The memory used here is only needed for
1168         // this context.
1169 
1170         // FIXME: inline assembly can't access return values
1171         bool ret;
1172         address addr;
1173 
1174         assembly {
1175             let size := mload(0x40)
1176             mstore(size, hash)
1177             mstore(add(size, 32), v)
1178             mstore(add(size, 64), r)
1179             mstore(add(size, 96), s)
1180 
1181             // NOTE: we can reuse the request memory because we deal with
1182             //       the return code
1183             ret := call(3000, 1, 0, size, 128, size, 32)
1184             addr := mload(size)
1185         }
1186 
1187         return (ret, addr);
1188     }
1189 
1190     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1191     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1192         bytes32 r;
1193         bytes32 s;
1194         uint8 v;
1195 
1196         if (sig.length != 65)
1197           return (false, 0);
1198 
1199         // The signature format is a compact form of:
1200         //   {bytes32 r}{bytes32 s}{uint8 v}
1201         // Compact means, uint8 is not padded to 32 bytes.
1202         assembly {
1203             r := mload(add(sig, 32))
1204             s := mload(add(sig, 64))
1205 
1206             // Here we are loading the last 32 bytes. We exploit the fact that
1207             // 'mload' will pad with zeroes if we overread.
1208             // There is no 'mload8' to do this, but that would be nicer.
1209             v := byte(0, mload(add(sig, 96)))
1210 
1211             // Alternative solution:
1212             // 'byte' is not working due to the Solidity parser, so lets
1213             // use the second best option, 'and'
1214             // v := and(mload(add(sig, 65)), 255)
1215         }
1216 
1217         // albeit non-transactional signatures are not specified by the YP, one would expect it
1218         // to match the YP range of [27, 28]
1219         //
1220         // geth uses [0, 1] and some clients have followed. This might change, see:
1221         //  https://github.com/ethereum/go-ethereum/issues/2053
1222         if (v < 27)
1223           v += 27;
1224 
1225         if (v != 27 && v != 28)
1226             return (false, 0);
1227 
1228         return safer_ecrecover(hash, v, r, s);
1229     }
1230 
1231     function safeMemoryCleaner() internal constant {
1232         assembly {
1233             let fmem := mload(0x40)
1234             codecopy(fmem, codesize, sub(msize, fmem))
1235         }
1236     }
1237 }
1238 // </ORACLIZE_API>
1239 
1240 contract Line is usingOraclize {
1241 
1242     address private owner;
1243 
1244     uint constant public jackpotNumerator = 50;
1245     uint constant public winNumerator = 5;
1246     uint constant public denominator = 100;
1247 
1248     uint public jackpot = 0;
1249 
1250     address[] internal addresses;
1251     mapping(address => SpinRec) internal spinsByAddr; //TODO: queryIdByAddr?
1252     mapping(bytes32 => SpinRec) internal spinsByQuery;
1253 
1254     struct SpinRec {
1255         uint id;
1256         bytes32 queryId;
1257         uint bet;
1258         uint token;
1259     }
1260 
1261 
1262     event Jackpot(uint line, address addr, uint date, uint prize, uint left);
1263     event Win(uint line, address addr, uint date, uint prize, uint left);
1264     event KeepSpinning(uint line, address addr, uint date, uint prize, uint left);
1265     event Spin(address addr, bytes32 queryId, uint bet, uint jackpot);
1266 
1267     modifier onlyOwner {
1268         require(msg.sender == owner);
1269         _;
1270     }
1271 
1272     function getQueryId() constant public returns (uint) {
1273         return uint(spinsByAddr[msg.sender].queryId);
1274     }
1275 
1276     function getTokenFor(uint queryId) constant public returns (uint) {
1277         return spinsByQuery[bytes32(queryId)].token;
1278     }
1279 
1280     function getToken() constant public returns (uint) {
1281         return spinsByAddr[msg.sender].token;
1282     }
1283 
1284     function getQueryIdBytes() constant public returns (bytes32) {
1285         return spinsByAddr[msg.sender].queryId;
1286     }
1287 
1288     function getTokenForBytes(bytes32 queryId) constant public returns (uint) {
1289         return spinsByQuery[queryId].token;
1290     }
1291 
1292     function revealResult(uint token, bytes32 queryId) internal {
1293 
1294         SpinRec storage spin = spinsByQuery[queryId];
1295 
1296         require(spin.id != 0);
1297 
1298         spin.token = token;
1299         address player = addresses[spin.id];
1300         spinsByAddr[player].token = token;
1301 
1302         uint prizeNumerator = 0;
1303 
1304         if (token == 444) {
1305             prizeNumerator = jackpotNumerator;
1306         } else if (token == 333 || token == 222 || token == 111) {
1307             prizeNumerator = winNumerator;
1308         }
1309 
1310         uint prize = 0;
1311         if (prizeNumerator > 0) {
1312             prize = this.balance / 100 * prizeNumerator;
1313             if (player.send(prize)) {
1314                 if (prizeNumerator == jackpotNumerator) {
1315                     emit Jackpot(token, player, now, prize, this.balance);
1316                 } else {
1317                     emit Win(token, player, now, prize, this.balance);
1318                 }
1319                 owner.transfer(this.balance / 100);
1320             }
1321         } else if (token % 2 == 0) {
1322             prize = spin.bet / 2;
1323             if (player.send(prize)) {
1324                 emit KeepSpinning(token, player, now, prize, this.balance);
1325             }
1326         }
1327     }
1328 
1329     function recordSpin(bytes32 queryId) internal {
1330 
1331         SpinRec storage spin = spinsByAddr[msg.sender];
1332 
1333         if (spin.id == 0) {
1334 
1335             msg.sender.transfer(0 wei); 
1336 
1337             spin.id = addresses.length;
1338             addresses.push(msg.sender);
1339         }
1340 
1341         spin.bet = msg.value;
1342         spin.queryId = queryId;
1343         spinsByQuery[queryId] = spin;
1344     }
1345 
1346     function waiver() private {
1347 
1348         delete owner;
1349     }
1350 
1351     function reset() onlyOwner public {
1352 
1353         owner.transfer(this.balance);
1354     }
1355 
1356     function() payable public {
1357 
1358         jackpot += msg.value;
1359 
1360         require(msg.value > 10);
1361 
1362         bytes32 queryId = requestRandom();
1363 
1364         recordSpin(queryId);
1365 
1366         emit Spin(msg.sender, queryId, msg.value, jackpot);
1367     }
1368 
1369     uint constant public randomSize = 5; // number of random bytes
1370 
1371     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
1372         if (msg.sender != oraclize_cbAddress()) throw;
1373 
1374         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1375             // TODO:
1376         } else {
1377 
1378             uint maxRange = 2**(8 * randomSize); 
1379             uint randomNumber = uint(sha3(_result)) % maxRange;
1380 
1381             revealResult(randomNumber%345 + 100, _queryId);
1382         }
1383     }
1384 
1385 
1386     function requestRandom() internal returns (bytes32) {
1387 
1388         uint callbackGas = 200000;
1389         // this function internally generates the correct oraclize_query and returns its queryId
1390         bytes32 queryId = oraclize_newRandomDSQuery(0, randomSize, callbackGas); 
1391         return queryId;
1392     }
1393 
1394     function Line() public {
1395 
1396         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1397         delete addresses;
1398         addresses.length = 1;
1399         owner = msg.sender;
1400     }
1401 }