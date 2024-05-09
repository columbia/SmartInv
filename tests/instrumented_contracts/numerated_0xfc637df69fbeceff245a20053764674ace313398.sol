1 pragma solidity ^0.4.11;
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
33 pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49     function randomDS_getSessionPubKeyHash() returns(bytes32);
50 }
51 
52 contract OraclizeAddrResolverI {
53     function getAddress() returns (address _addr);
54 }
55 
56 /*
57 Begin solidity-cborutils
58 
59 https://github.com/smartcontractkit/solidity-cborutils
60 
61 MIT License
62 
63 Copyright (c) 2018 SmartContract ChainLink, Ltd.
64 
65 Permission is hereby granted, free of charge, to any person obtaining a copy
66 of this software and associated documentation files (the "Software"), to deal
67 in the Software without restriction, including without limitation the rights
68 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
69 copies of the Software, and to permit persons to whom the Software is
70 furnished to do so, subject to the following conditions:
71 
72 The above copyright notice and this permission notice shall be included in all
73 copies or substantial portions of the Software.
74 
75 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
76 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
77 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
78 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
79 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
80 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
81 SOFTWARE.
82  */
83 
84 library Buffer {
85     struct buffer {
86         bytes buf;
87         uint capacity;
88     }
89 
90     function init(buffer memory buf, uint capacity) internal constant {
91         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
92         // Allocate space for the buffer data
93         buf.capacity = capacity;
94         assembly {
95             let ptr := mload(0x40)
96             mstore(buf, ptr)
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
115      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
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
162      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
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
187      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
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
296     byte constant proofType_Android = 0x20;
297     byte constant proofType_Ledger = 0x30;
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
911         Buffer.buffer memory buf;
912         Buffer.init(buf, 1024);
913         buf.startArray();
914         for (uint i = 0; i < arr.length; i++) {
915             buf.encodeString(arr[i]);
916         }
917         buf.endSequence();
918         return buf.buf;
919     }
920 
921     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
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
937     function oraclize_getNetworkName() internal returns (string) {
938         return oraclize_network_name;
939     }
940 
941     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
942         if ((_nbytes == 0)||(_nbytes > 32)) throw;
943 	// Convert from seconds to ledger timer ticks
944         _delay *= 10;
945         bytes memory nbytes = new bytes(1);
946         nbytes[0] = byte(_nbytes);
947         bytes memory unonce = new bytes(32);
948         bytes memory sessionKeyHash = new bytes(32);
949         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
950         assembly {
951             mstore(unonce, 0x20)
952             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
953             mstore(sessionKeyHash, 0x20)
954             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
955         }
956         bytes memory delay = new bytes(32);
957         assembly {
958             mstore(add(delay, 0x20), _delay)
959         }
960 
961         bytes memory delay_bytes8 = new bytes(8);
962         copyBytes(delay, 24, 8, delay_bytes8, 0);
963 
964         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
965         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
966 
967         bytes memory delay_bytes8_left = new bytes(8);
968 
969         assembly {
970             let x := mload(add(delay_bytes8, 0x20))
971             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
978             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
979 
980         }
981 
982         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
983         return queryId;
984     }
985 
986     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
987         oraclize_randomDS_args[queryId] = commitment;
988     }
989 
990     mapping(bytes32=>bytes32) oraclize_randomDS_args;
991     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
992 
993     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
994         bool sigok;
995         address signer;
996 
997         bytes32 sigr;
998         bytes32 sigs;
999 
1000         bytes memory sigr_ = new bytes(32);
1001         uint offset = 4+(uint(dersig[3]) - 0x20);
1002         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1003         bytes memory sigs_ = new bytes(32);
1004         offset += 32 + 2;
1005         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1006 
1007         assembly {
1008             sigr := mload(add(sigr_, 32))
1009             sigs := mload(add(sigs_, 32))
1010         }
1011 
1012 
1013         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1014         if (address(sha3(pubkey)) == signer) return true;
1015         else {
1016             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1017             return (address(sha3(pubkey)) == signer);
1018         }
1019     }
1020 
1021     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1022         bool sigok;
1023 
1024         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1025         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1026         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1027 
1028         bytes memory appkey1_pubkey = new bytes(64);
1029         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1030 
1031         bytes memory tosign2 = new bytes(1+65+32);
1032         tosign2[0] = 1; //role
1033         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1034         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1035         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1036         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1037 
1038         if (sigok == false) return false;
1039 
1040 
1041         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1042         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1043 
1044         bytes memory tosign3 = new bytes(1+65);
1045         tosign3[0] = 0xFE;
1046         copyBytes(proof, 3, 65, tosign3, 1);
1047 
1048         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1049         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1050 
1051         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1052 
1053         return sigok;
1054     }
1055 
1056     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1057         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1058         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1059 
1060         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1061         if (proofVerified == false) throw;
1062 
1063         _;
1064     }
1065 
1066     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1067         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1068         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1069 
1070         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1071         if (proofVerified == false) return 2;
1072 
1073         return 0;
1074     }
1075 
1076     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1077         bool match_ = true;
1078 
1079 	if (prefix.length != n_random_bytes) throw;
1080 
1081         for (uint256 i=0; i< n_random_bytes; i++) {
1082             if (content[i] != prefix[i]) match_ = false;
1083         }
1084 
1085         return match_;
1086     }
1087 
1088     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1089 
1090         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1091         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1092         bytes memory keyhash = new bytes(32);
1093         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1094         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1095 
1096         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1097         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1098 
1099         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1100         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1101 
1102         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1103         // This is to verify that the computed args match with the ones specified in the query.
1104         bytes memory commitmentSlice1 = new bytes(8+1+32);
1105         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1106 
1107         bytes memory sessionPubkey = new bytes(64);
1108         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1109         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1110 
1111         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1112         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1113             delete oraclize_randomDS_args[queryId];
1114         } else return false;
1115 
1116 
1117         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1118         bytes memory tosign1 = new bytes(32+8+1+32);
1119         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1120         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1121 
1122         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1123         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1124             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1125         }
1126 
1127         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1128     }
1129 
1130 
1131     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1132     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1133         uint minLength = length + toOffset;
1134 
1135         if (to.length < minLength) {
1136             // Buffer too small
1137             throw; // Should be a better way?
1138         }
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
1226 }
1227 // </ORACLIZE_API>
1228 
1229 contract ScriptCallable {
1230     address public determineWinnerScript;
1231 
1232     function ScriptCallable() public {
1233         determineWinnerScript = msg.sender;
1234     }
1235 
1236     modifier onlyScript() {
1237         assert(msg.sender == determineWinnerScript);
1238         _;
1239     }
1240 
1241     function transferOwnership(address newAddress) public onlyScript {
1242         if (newAddress != address(0)) {
1243             determineWinnerScript = newAddress;
1244         }
1245     }
1246 }
1247 
1248 contract RandomExample is usingOraclize, ScriptCallable
1249 {
1250     uint public oraclizeGasCost;
1251     uint public oraclizeGasLimit;
1252     uint public oraclizeBytes;
1253     uint public oraclizeDelay;
1254     
1255     uint public totalJackpotEven;
1256     uint public totalJackpotOdd;
1257     
1258     uint public gameIndex;
1259     
1260     uint public numElementsEven;
1261     uint public numElementsOdd;
1262 
1263     uint public minimumBet = 0.01 ether;
1264     uint public commission = 33;
1265     uint public zoomraffleFee;
1266     
1267     mapping (address => uint256) public betsEven;
1268     mapping (address => uint256) public betsOdd;
1269     
1270     mapping (address => uint256) public wins;
1271     
1272     address[] public playersEven;
1273     address[] public playersOdd;
1274 
1275     event Win(address indexed winner, uint indexed gameIndex, uint value, uint jackpot);
1276     event Bet(address betAddress, uint indexed gameIndex, uint256 value);
1277     event ProofFailed(uint indexed gameIndex);
1278 
1279 
1280     function RandomExample() payable
1281     {
1282         oraclizeGasLimit = 250000;
1283         oraclizeGasCost = 10*10**9;
1284         oraclizeBytes = 32;
1285         oraclize_setCustomGasPrice(oraclizeGasCost);
1286         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1287     }
1288 
1289     function () public payable
1290     {
1291         // Make the bet for the current game by default.
1292         placeBet(gameIndex);
1293     }
1294     
1295     function placeBet(uint _gameIndex) payable
1296     {
1297         if (gameIndex % 2 == 0)
1298         {
1299             placeBetEven(_gameIndex);
1300         }
1301         else
1302         {
1303             placeBetOdd(_gameIndex);
1304         }
1305     }
1306 
1307     function placeBetEven(uint _gameIndex) private
1308     {
1309         require(msg.value >= minimumBet);
1310         require(_gameIndex == gameIndex);
1311         if (numElementsOdd != 0) {
1312             cleanupOdd();
1313         }
1314         if (betsEven[msg.sender] == 0)
1315         {
1316             if(numElementsEven == playersEven.length) {
1317                 playersEven.length += 1;
1318             }
1319             playersEven[numElementsEven++] = msg.sender;
1320         }
1321         betsEven[msg.sender] += msg.value;
1322         totalJackpotEven += msg.value;
1323         Bet(msg.sender, gameIndex, msg.value);
1324     }
1325     
1326     function placeBetOdd(uint _gameIndex) private
1327     {
1328         require(msg.value >= minimumBet);
1329         require(_gameIndex == gameIndex);
1330         if (numElementsEven != 0) {
1331             cleanupEven();
1332         }
1333         if (betsOdd[msg.sender] == 0)
1334         {
1335             if(numElementsOdd == playersOdd.length) {
1336                 playersOdd.length += 1;
1337             }
1338             playersOdd[numElementsOdd++] = msg.sender;
1339         }
1340         betsOdd[msg.sender] += msg.value;
1341         totalJackpotOdd += msg.value;
1342         Bet(msg.sender, gameIndex, msg.value);
1343     }
1344     
1345     function determineWinner(string _result)
1346         onlyOraclize
1347         onlyTwoBetsAndMore
1348     {
1349         if (gameIndex % 2 == 0)
1350         {
1351             determineWinnerEven(_result);
1352         }
1353         else
1354         {
1355             determineWinnerOdd(_result);
1356         }
1357     }
1358 
1359     function determineWinnerEven(string _result) private
1360     {
1361         uint randomNumber = uint(sha3(_result)) % totalJackpotEven;
1362         address winner = 0;
1363         uint count = 0;
1364         for (uint i = 0; i < numElementsEven; i++)
1365         {
1366             address player = playersEven[i];
1367             count += betsEven[player];
1368             if (count >= randomNumber && winner == 0)
1369             {
1370                 Win(player, gameIndex, betsEven[player], totalJackpotEven);
1371                 winner = player;
1372             }
1373         }
1374         uint fee = totalJackpotEven / commission;
1375         zoomraffleFee += fee;
1376         totalJackpotEven = totalJackpotEven - (oraclizeGasLimit * oraclizeGasCost) - fee;
1377         wins[winner] += totalJackpotEven;
1378         gameIndex++;
1379     }
1380     
1381     function determineWinnerOdd(string _result) private
1382     {
1383         uint randomNumber = uint(sha3(_result)) % totalJackpotOdd;
1384         address winner = 0;
1385         uint count = 0;
1386         for (uint i = 0; i < numElementsOdd; i++)
1387         {
1388             address player = playersOdd[i];
1389             count += betsOdd[player];
1390             if (count >= randomNumber && winner == 0)
1391             {
1392                 Win(player, gameIndex, betsOdd[player], totalJackpotOdd);
1393                 winner = player;
1394             }
1395         }
1396         uint fee = totalJackpotOdd / commission;
1397         zoomraffleFee += fee;
1398         totalJackpotOdd = totalJackpotOdd - (oraclizeGasLimit * oraclizeGasCost) - fee;
1399         wins[winner] += totalJackpotOdd;
1400         gameIndex++;
1401     }
1402 
1403     function claimWinnings()
1404     {
1405         require(wins[msg.sender] != 0);
1406         msg.sender.transfer(wins[msg.sender]);
1407         wins[msg.sender] = 0;
1408     }
1409     
1410     function collectFees() onlyScript
1411     {
1412         determineWinnerScript.transfer(zoomraffleFee);
1413     }
1414 
1415     function getWinningsBalance(address player) constant returns (uint) {
1416         return wins[player];
1417     }
1418 
1419     function cleanupEven() private
1420     {
1421         for (uint i = 0; i < numElementsEven; i++)
1422         {
1423             address player = playersEven[i];
1424             delete betsEven[player];
1425         }
1426         delete numElementsEven;
1427         delete totalJackpotEven;
1428     }
1429     
1430     function cleanupOdd() private
1431     {
1432         for (uint i = 0; i < numElementsOdd; i++)
1433         {
1434             address player = playersOdd[i];
1435             delete betsOdd[player];
1436         }
1437         delete numElementsOdd;
1438         delete totalJackpotOdd;
1439     }
1440 
1441     function setMinimumBet(uint newMinBet) onlyScript
1442     {
1443         minimumBet = newMinBet;
1444     }
1445 
1446     function setOraclizeGasCost(uint newCost) onlyScript
1447     {
1448         oraclize_setCustomGasPrice(newCost);
1449     }
1450 
1451     function setCommission(uint newCommission) onlyScript
1452     {
1453         commission = newCommission;
1454     }
1455 
1456     function setOraclizeBytes(uint newBytes) onlyScript
1457     {
1458         oraclizeBytes = newBytes;
1459     }
1460 
1461     function setOraclizeDelay(uint newDelay) onlyScript
1462     {
1463         oraclizeDelay = newDelay;
1464     }
1465 
1466     function setOraclizeGasLimit(uint newGasLimit) onlyScript
1467     {
1468         oraclizeGasLimit = newGasLimit;
1469     }
1470 
1471     // the callback function is called by Oraclize when the result is ready
1472     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1473     // the proof validity is fully verified on-chain
1474     function __callback(bytes32 _queryId, string _result, bytes _proof) onlyOraclize
1475     {
1476         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0)
1477         {
1478             ProofFailed(gameIndex);
1479         }
1480         else
1481         {
1482             determineWinner(_result);
1483         }
1484     }
1485 
1486     modifier onlyTwoBetsAndMore() {
1487         uint numElements = (gameIndex % 2 == 0) ? numElementsEven : numElementsOdd;
1488         assert(numElements >= 2);
1489         _;
1490     }
1491 
1492     modifier onlyOraclize() {
1493         if (msg.sender != oraclize_cbAddress()) throw;
1494         _;
1495     }
1496 
1497     function update() onlyScript payable {
1498         // Oraclize fees are taken from jackpot.
1499         bytes32 queryId = oraclize_newRandomDSQuery(oraclizeDelay, oraclizeBytes, oraclizeGasLimit);
1500     }
1501 }