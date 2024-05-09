1 pragma solidity ^0.4.20;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 The above copyright notice and this permission notice shall be included in
14 all copies or substantial portions of the Software.
15 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
16 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
17 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
18 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
19 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
21 THE SOFTWARE.
22 */
23 
24 pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
25 
26 contract OraclizeI {
27     address public cbAddress;
28     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
29     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
30     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
31     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
32     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
33     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
34     function getPrice(string _datasource) returns (uint _dsprice);
35     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
36     function useCoupon(string _coupon);
37     function setProofType(byte _proofType);
38     function setConfig(bytes32 _config);
39     function setCustomGasPrice(uint _gasPrice);
40     function randomDS_getSessionPubKeyHash() returns(bytes32);
41 }
42 
43 contract OraclizeAddrResolverI {
44     function getAddress() returns (address _addr);
45 }
46 
47 /*
48 Begin solidity-cborutils
49 https://github.com/smartcontractkit/solidity-cborutils
50 MIT License
51 Copyright (c) 2018 SmartContract ChainLink, Ltd.
52 Permission is hereby granted, free of charge, to any person obtaining a copy
53 of this software and associated documentation files (the "Software"), to deal
54 in the Software without restriction, including without limitation the rights
55 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
56 copies of the Software, and to permit persons to whom the Software is
57 furnished to do so, subject to the following conditions:
58 The above copyright notice and this permission notice shall be included in all
59 copies or substantial portions of the Software.
60 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
61 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
62 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
63 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
64 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
65 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
66 SOFTWARE.
67  */
68 
69 library Buffer {
70     struct buffer {
71         bytes buf;
72         uint capacity;
73     }
74 
75     function init(buffer memory buf, uint capacity) internal constant {
76         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
77         // Allocate space for the buffer data
78         buf.capacity = capacity;
79         assembly {
80             let ptr := mload(0x40)
81             mstore(buf, ptr)
82             mstore(0x40, add(ptr, capacity))
83         }
84     }
85 
86     function resize(buffer memory buf, uint capacity) private constant {
87         bytes memory oldbuf = buf.buf;
88         init(buf, capacity);
89         append(buf, oldbuf);
90     }
91 
92     function max(uint a, uint b) private constant returns(uint) {
93         if(a > b) {
94             return a;
95         }
96         return b;
97     }
98 
99     /**
100      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
101      *      would exceed the capacity of the buffer.
102      * @param buf The buffer to append to.
103      * @param data The data to append.
104      * @return The original buffer.
105      */
106     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
107         if(data.length + buf.buf.length > buf.capacity) {
108             resize(buf, max(buf.capacity, data.length) * 2);
109         }
110 
111         uint dest;
112         uint src;
113         uint len = data.length;
114         assembly {
115             // Memory address of the buffer data
116             let bufptr := mload(buf)
117             // Length of existing buffer data
118             let buflen := mload(bufptr)
119             // Start address = buffer address + buffer length + sizeof(buffer length)
120             dest := add(add(bufptr, buflen), 32)
121             // Update buffer length
122             mstore(bufptr, add(buflen, mload(data)))
123             src := add(data, 32)
124         }
125 
126         // Copy word-length chunks while possible
127         for(; len >= 32; len -= 32) {
128             assembly {
129                 mstore(dest, mload(src))
130             }
131             dest += 32;
132             src += 32;
133         }
134 
135         // Copy remaining bytes
136         uint mask = 256 ** (32 - len) - 1;
137         assembly {
138             let srcpart := and(mload(src), not(mask))
139             let destpart := and(mload(dest), mask)
140             mstore(dest, or(destpart, srcpart))
141         }
142 
143         return buf;
144     }
145 
146     /**
147      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
148      * exceed the capacity of the buffer.
149      * @param buf The buffer to append to.
150      * @param data The data to append.
151      * @return The original buffer.
152      */
153     function append(buffer memory buf, uint8 data) internal constant {
154         if(buf.buf.length + 1 > buf.capacity) {
155             resize(buf, buf.capacity * 2);
156         }
157 
158         assembly {
159             // Memory address of the buffer data
160             let bufptr := mload(buf)
161             // Length of existing buffer data
162             let buflen := mload(bufptr)
163             // Address = buffer address + buffer length + sizeof(buffer length)
164             let dest := add(add(bufptr, buflen), 32)
165             mstore8(dest, data)
166             // Update buffer length
167             mstore(bufptr, add(buflen, 1))
168         }
169     }
170 
171     /**
172      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
173      * exceed the capacity of the buffer.
174      * @param buf The buffer to append to.
175      * @param data The data to append.
176      * @return The original buffer.
177      */
178     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
179         if(len + buf.buf.length > buf.capacity) {
180             resize(buf, max(buf.capacity, len) * 2);
181         }
182 
183         uint mask = 256 ** len - 1;
184         assembly {
185             // Memory address of the buffer data
186             let bufptr := mload(buf)
187             // Length of existing buffer data
188             let buflen := mload(bufptr)
189             // Address = buffer address + buffer length + sizeof(buffer length) + len
190             let dest := add(add(bufptr, buflen), len)
191             mstore(dest, or(and(mload(dest), not(mask)), data))
192             // Update buffer length
193             mstore(bufptr, add(buflen, len))
194         }
195         return buf;
196     }
197 }
198 
199 library CBOR {
200     using Buffer for Buffer.buffer;
201 
202     uint8 private constant MAJOR_TYPE_INT = 0;
203     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
204     uint8 private constant MAJOR_TYPE_BYTES = 2;
205     uint8 private constant MAJOR_TYPE_STRING = 3;
206     uint8 private constant MAJOR_TYPE_ARRAY = 4;
207     uint8 private constant MAJOR_TYPE_MAP = 5;
208     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
209 
210     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
211         return x * (2 ** y);
212     }
213 
214     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
215         if(value <= 23) {
216             buf.append(uint8(shl8(major, 5) | value));
217         } else if(value <= 0xFF) {
218             buf.append(uint8(shl8(major, 5) | 24));
219             buf.appendInt(value, 1);
220         } else if(value <= 0xFFFF) {
221             buf.append(uint8(shl8(major, 5) | 25));
222             buf.appendInt(value, 2);
223         } else if(value <= 0xFFFFFFFF) {
224             buf.append(uint8(shl8(major, 5) | 26));
225             buf.appendInt(value, 4);
226         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
227             buf.append(uint8(shl8(major, 5) | 27));
228             buf.appendInt(value, 8);
229         }
230     }
231 
232     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
233         buf.append(uint8(shl8(major, 5) | 31));
234     }
235 
236     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
237         encodeType(buf, MAJOR_TYPE_INT, value);
238     }
239 
240     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
241         if(value >= 0) {
242             encodeType(buf, MAJOR_TYPE_INT, uint(value));
243         } else {
244             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
245         }
246     }
247 
248     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
249         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
250         buf.append(value);
251     }
252 
253     function encodeString(Buffer.buffer memory buf, string value) internal constant {
254         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
255         buf.append(bytes(value));
256     }
257 
258     function startArray(Buffer.buffer memory buf) internal constant {
259         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
260     }
261 
262     function startMap(Buffer.buffer memory buf) internal constant {
263         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
264     }
265 
266     function endSequence(Buffer.buffer memory buf) internal constant {
267         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
268     }
269 }
270 
271 /*
272 End solidity-cborutils
273  */
274 
275 contract usingOraclize {
276     uint constant day = 60*60*24;
277     uint constant week = 60*60*24*7;
278     uint constant month = 60*60*24*30;
279     byte constant proofType_NONE = 0x00;
280     byte constant proofType_TLSNotary = 0x10;
281     byte constant proofType_Android = 0x20;
282     byte constant proofType_Ledger = 0x30;
283     byte constant proofType_Native = 0xF0;
284     byte constant proofStorage_IPFS = 0x01;
285     uint8 constant networkID_auto = 0;
286     uint8 constant networkID_mainnet = 1;
287     uint8 constant networkID_testnet = 2;
288     uint8 constant networkID_morden = 2;
289     uint8 constant networkID_consensys = 161;
290 
291     OraclizeAddrResolverI OAR;
292 
293     OraclizeI oraclize;
294     modifier oraclizeAPI {
295         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
296             oraclize_setNetwork(networkID_auto);
297 
298         if(address(oraclize) != OAR.getAddress())
299             oraclize = OraclizeI(OAR.getAddress());
300 
301         _;
302     }
303     modifier coupon(string code){
304         oraclize = OraclizeI(OAR.getAddress());
305         oraclize.useCoupon(code);
306         _;
307     }
308 
309     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
310         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
311             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
312             oraclize_setNetworkName("eth_mainnet");
313             return true;
314         }
315         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
316             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
317             oraclize_setNetworkName("eth_ropsten3");
318             return true;
319         }
320         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
321             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
322             oraclize_setNetworkName("eth_kovan");
323             return true;
324         }
325         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
326             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
327             oraclize_setNetworkName("eth_rinkeby");
328             return true;
329         }
330         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
331             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
332             return true;
333         }
334         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
335             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
336             return true;
337         }
338         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
339             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
340             return true;
341         }
342         return false;
343     }
344 
345     function __callback(bytes32 myid, string result) {
346         __callback(myid, result, new bytes(0));
347     }
348     function __callback(bytes32 myid, string result, bytes proof) {
349     }
350 
351     function oraclize_useCoupon(string code) oraclizeAPI internal {
352         oraclize.useCoupon(code);
353     }
354 
355     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
356         return oraclize.getPrice(datasource);
357     }
358 
359     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
360         return oraclize.getPrice(datasource, gaslimit);
361     }
362 
363     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
364         uint price = oraclize.getPrice(datasource);
365         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
366         return oraclize.query.value(price)(0, datasource, arg);
367     }
368     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
369         uint price = oraclize.getPrice(datasource);
370         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
371         return oraclize.query.value(price)(timestamp, datasource, arg);
372     }
373     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
374         uint price = oraclize.getPrice(datasource, gaslimit);
375         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
376         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
377     }
378     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource, gaslimit);
380         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
381         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
382     }
383     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
387     }
388     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource);
390         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
391         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
392     }
393     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource, gaslimit);
395         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
396         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
397     }
398     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource, gaslimit);
400         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
401         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
402     }
403     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
404         uint price = oraclize.getPrice(datasource);
405         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
406         bytes memory args = stra2cbor(argN);
407         return oraclize.queryN.value(price)(0, datasource, args);
408     }
409     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource);
411         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
412         bytes memory args = stra2cbor(argN);
413         return oraclize.queryN.value(price)(timestamp, datasource, args);
414     }
415     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
416         uint price = oraclize.getPrice(datasource, gaslimit);
417         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
418         bytes memory args = stra2cbor(argN);
419         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
420     }
421     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource, gaslimit);
423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
424         bytes memory args = stra2cbor(argN);
425         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
426     }
427     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
428         string[] memory dynargs = new string[](1);
429         dynargs[0] = args[0];
430         return oraclize_query(datasource, dynargs);
431     }
432     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
433         string[] memory dynargs = new string[](1);
434         dynargs[0] = args[0];
435         return oraclize_query(timestamp, datasource, dynargs);
436     }
437     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
438         string[] memory dynargs = new string[](1);
439         dynargs[0] = args[0];
440         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
441     }
442     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
443         string[] memory dynargs = new string[](1);
444         dynargs[0] = args[0];
445         return oraclize_query(datasource, dynargs, gaslimit);
446     }
447 
448     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
449         string[] memory dynargs = new string[](2);
450         dynargs[0] = args[0];
451         dynargs[1] = args[1];
452         return oraclize_query(datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
455         string[] memory dynargs = new string[](2);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         return oraclize_query(timestamp, datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         string[] memory dynargs = new string[](2);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
465     }
466     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         string[] memory dynargs = new string[](2);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         return oraclize_query(datasource, dynargs, gaslimit);
471     }
472     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](3);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         dynargs[2] = args[2];
477         return oraclize_query(datasource, dynargs);
478     }
479     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](3);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         return oraclize_query(timestamp, datasource, dynargs);
485     }
486     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
487         string[] memory dynargs = new string[](3);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
492     }
493     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
494         string[] memory dynargs = new string[](3);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         return oraclize_query(datasource, dynargs, gaslimit);
499     }
500 
501     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
502         string[] memory dynargs = new string[](4);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         dynargs[3] = args[3];
507         return oraclize_query(datasource, dynargs);
508     }
509     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](4);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         return oraclize_query(timestamp, datasource, dynargs);
516     }
517     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](4);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         dynargs[3] = args[3];
523         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
524     }
525     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
526         string[] memory dynargs = new string[](4);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         dynargs[2] = args[2];
530         dynargs[3] = args[3];
531         return oraclize_query(datasource, dynargs, gaslimit);
532     }
533     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](5);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         dynargs[2] = args[2];
538         dynargs[3] = args[3];
539         dynargs[4] = args[4];
540         return oraclize_query(datasource, dynargs);
541     }
542     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
543         string[] memory dynargs = new string[](5);
544         dynargs[0] = args[0];
545         dynargs[1] = args[1];
546         dynargs[2] = args[2];
547         dynargs[3] = args[3];
548         dynargs[4] = args[4];
549         return oraclize_query(timestamp, datasource, dynargs);
550     }
551     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](5);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         dynargs[3] = args[3];
557         dynargs[4] = args[4];
558         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
559     }
560     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](5);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         dynargs[4] = args[4];
567         return oraclize_query(datasource, dynargs, gaslimit);
568     }
569     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
570         uint price = oraclize.getPrice(datasource);
571         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
572         bytes memory args = ba2cbor(argN);
573         return oraclize.queryN.value(price)(0, datasource, args);
574     }
575     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
576         uint price = oraclize.getPrice(datasource);
577         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
578         bytes memory args = ba2cbor(argN);
579         return oraclize.queryN.value(price)(timestamp, datasource, args);
580     }
581     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
582         uint price = oraclize.getPrice(datasource, gaslimit);
583         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
584         bytes memory args = ba2cbor(argN);
585         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
586     }
587     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
588         uint price = oraclize.getPrice(datasource, gaslimit);
589         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
590         bytes memory args = ba2cbor(argN);
591         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
592     }
593     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
594         bytes[] memory dynargs = new bytes[](1);
595         dynargs[0] = args[0];
596         return oraclize_query(datasource, dynargs);
597     }
598     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
599         bytes[] memory dynargs = new bytes[](1);
600         dynargs[0] = args[0];
601         return oraclize_query(timestamp, datasource, dynargs);
602     }
603     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](1);
605         dynargs[0] = args[0];
606         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
607     }
608     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
609         bytes[] memory dynargs = new bytes[](1);
610         dynargs[0] = args[0];
611         return oraclize_query(datasource, dynargs, gaslimit);
612     }
613 
614     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
615         bytes[] memory dynargs = new bytes[](2);
616         dynargs[0] = args[0];
617         dynargs[1] = args[1];
618         return oraclize_query(datasource, dynargs);
619     }
620     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
621         bytes[] memory dynargs = new bytes[](2);
622         dynargs[0] = args[0];
623         dynargs[1] = args[1];
624         return oraclize_query(timestamp, datasource, dynargs);
625     }
626     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
627         bytes[] memory dynargs = new bytes[](2);
628         dynargs[0] = args[0];
629         dynargs[1] = args[1];
630         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
631     }
632     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
633         bytes[] memory dynargs = new bytes[](2);
634         dynargs[0] = args[0];
635         dynargs[1] = args[1];
636         return oraclize_query(datasource, dynargs, gaslimit);
637     }
638     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
639         bytes[] memory dynargs = new bytes[](3);
640         dynargs[0] = args[0];
641         dynargs[1] = args[1];
642         dynargs[2] = args[2];
643         return oraclize_query(datasource, dynargs);
644     }
645     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](3);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         return oraclize_query(timestamp, datasource, dynargs);
651     }
652     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
653         bytes[] memory dynargs = new bytes[](3);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         dynargs[2] = args[2];
657         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
658     }
659     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
660         bytes[] memory dynargs = new bytes[](3);
661         dynargs[0] = args[0];
662         dynargs[1] = args[1];
663         dynargs[2] = args[2];
664         return oraclize_query(datasource, dynargs, gaslimit);
665     }
666 
667     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
668         bytes[] memory dynargs = new bytes[](4);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         dynargs[2] = args[2];
672         dynargs[3] = args[3];
673         return oraclize_query(datasource, dynargs);
674     }
675     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](4);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         dynargs[2] = args[2];
680         dynargs[3] = args[3];
681         return oraclize_query(timestamp, datasource, dynargs);
682     }
683     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](4);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         dynargs[3] = args[3];
689         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
690     }
691     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
692         bytes[] memory dynargs = new bytes[](4);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         return oraclize_query(datasource, dynargs, gaslimit);
698     }
699     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](5);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         dynargs[3] = args[3];
705         dynargs[4] = args[4];
706         return oraclize_query(datasource, dynargs);
707     }
708     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
709         bytes[] memory dynargs = new bytes[](5);
710         dynargs[0] = args[0];
711         dynargs[1] = args[1];
712         dynargs[2] = args[2];
713         dynargs[3] = args[3];
714         dynargs[4] = args[4];
715         return oraclize_query(timestamp, datasource, dynargs);
716     }
717     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](5);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         dynargs[3] = args[3];
723         dynargs[4] = args[4];
724         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
725     }
726     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](5);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         dynargs[4] = args[4];
733         return oraclize_query(datasource, dynargs, gaslimit);
734     }
735 
736     function oraclize_cbAddress() oraclizeAPI internal returns (address){
737         return oraclize.cbAddress();
738     }
739     function oraclize_setProof(byte proofP) oraclizeAPI internal {
740         return oraclize.setProofType(proofP);
741     }
742     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
743         return oraclize.setCustomGasPrice(gasPrice);
744     }
745     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
746         return oraclize.setConfig(config);
747     }
748 
749     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
750         return oraclize.randomDS_getSessionPubKeyHash();
751     }
752 
753     function getCodeSize(address _addr) constant internal returns(uint _size) {
754         assembly {
755             _size := extcodesize(_addr)
756         }
757     }
758 
759     function parseAddr(string _a) internal returns (address){
760         bytes memory tmp = bytes(_a);
761         uint160 iaddr = 0;
762         uint160 b1;
763         uint160 b2;
764         for (uint i=2; i<2+2*20; i+=2){
765             iaddr *= 256;
766             b1 = uint160(tmp[i]);
767             b2 = uint160(tmp[i+1]);
768             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
769             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
770             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
771             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
772             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
773             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
774             iaddr += (b1*16+b2);
775         }
776         return address(iaddr);
777     }
778 
779     function strCompare(string _a, string _b) internal returns (int) {
780         bytes memory a = bytes(_a);
781         bytes memory b = bytes(_b);
782         uint minLength = a.length;
783         if (b.length < minLength) minLength = b.length;
784         for (uint i = 0; i < minLength; i ++)
785             if (a[i] < b[i])
786                 return -1;
787             else if (a[i] > b[i])
788                 return 1;
789         if (a.length < b.length)
790             return -1;
791         else if (a.length > b.length)
792             return 1;
793         else
794             return 0;
795     }
796 
797     function indexOf(string _haystack, string _needle) internal returns (int) {
798         bytes memory h = bytes(_haystack);
799         bytes memory n = bytes(_needle);
800         if(h.length < 1 || n.length < 1 || (n.length > h.length))
801             return -1;
802         else if(h.length > (2**128 -1))
803             return -1;
804         else
805         {
806             uint subindex = 0;
807             for (uint i = 0; i < h.length; i ++)
808             {
809                 if (h[i] == n[0])
810                 {
811                     subindex = 1;
812                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
813                     {
814                         subindex++;
815                     }
816                     if(subindex == n.length)
817                         return int(i);
818                 }
819             }
820             return -1;
821         }
822     }
823 
824     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
825         bytes memory _ba = bytes(_a);
826         bytes memory _bb = bytes(_b);
827         bytes memory _bc = bytes(_c);
828         bytes memory _bd = bytes(_d);
829         bytes memory _be = bytes(_e);
830         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
831         bytes memory babcde = bytes(abcde);
832         uint k = 0;
833         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
834         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
835         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
836         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
837         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
838         return string(babcde);
839     }
840 
841     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
842         return strConcat(_a, _b, _c, _d, "");
843     }
844 
845     function strConcat(string _a, string _b, string _c) internal returns (string) {
846         return strConcat(_a, _b, _c, "", "");
847     }
848 
849     function strConcat(string _a, string _b) internal returns (string) {
850         return strConcat(_a, _b, "", "", "");
851     }
852 
853     // parseInt
854     function parseInt(string _a) internal returns (uint) {
855         return parseInt(_a, 0);
856     }
857 
858     // parseInt(parseFloat*10^_b)
859     function parseInt(string _a, uint _b) internal returns (uint) {
860         bytes memory bresult = bytes(_a);
861         uint mint = 0;
862         bool decimals = false;
863         for (uint i=0; i<bresult.length; i++){
864             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
865                 if (decimals){
866                    if (_b == 0) break;
867                     else _b--;
868                 }
869                 mint *= 10;
870                 mint += uint(bresult[i]) - 48;
871             } else if (bresult[i] == 46) decimals = true;
872         }
873         if (_b > 0) mint *= 10**_b;
874         return mint;
875     }
876 
877     function uint2str(uint i) internal returns (string){
878         if (i == 0) return "0";
879         uint j = i;
880         uint len;
881         while (j != 0){
882             len++;
883             j /= 10;
884         }
885         bytes memory bstr = new bytes(len);
886         uint k = len - 1;
887         while (i != 0){
888             bstr[k--] = byte(48 + i % 10);
889             i /= 10;
890         }
891         return string(bstr);
892     }
893 
894     using CBOR for Buffer.buffer;
895     function stra2cbor(string[] arr) internal constant returns (bytes) {
896         Buffer.buffer memory buf;
897         Buffer.init(buf, 1024);
898         buf.startArray();
899         for (uint i = 0; i < arr.length; i++) {
900             buf.encodeString(arr[i]);
901         }
902         buf.endSequence();
903         return buf.buf;
904     }
905 
906     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
907         Buffer.buffer memory buf;
908         Buffer.init(buf, 1024);
909         buf.startArray();
910         for (uint i = 0; i < arr.length; i++) {
911             buf.encodeBytes(arr[i]);
912         }
913         buf.endSequence();
914         return buf.buf;
915     }
916 
917     string oraclize_network_name;
918     function oraclize_setNetworkName(string _network_name) internal {
919         oraclize_network_name = _network_name;
920     }
921 
922     function oraclize_getNetworkName() internal returns (string) {
923         return oraclize_network_name;
924     }
925 
926     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
927         if ((_nbytes == 0)||(_nbytes > 32)) throw;
928 	// Convert from seconds to ledger timer ticks
929         _delay *= 10;
930         bytes memory nbytes = new bytes(1);
931         nbytes[0] = byte(_nbytes);
932         bytes memory unonce = new bytes(32);
933         bytes memory sessionKeyHash = new bytes(32);
934         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
935         assembly {
936             mstore(unonce, 0x20)
937             // the following variables can be relaxed
938             // check relaxed random contract under ethereum-examples repo
939             // for an idea on how to override and replace comit hash vars
940             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
941             mstore(sessionKeyHash, 0x20)
942             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
943         }
944         bytes memory delay = new bytes(32);
945         assembly {
946             mstore(add(delay, 0x20), _delay)
947         }
948 
949         bytes memory delay_bytes8 = new bytes(8);
950         copyBytes(delay, 24, 8, delay_bytes8, 0);
951 
952         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
953         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
954 
955         bytes memory delay_bytes8_left = new bytes(8);
956 
957         assembly {
958             let x := mload(add(delay_bytes8, 0x20))
959             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
960             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
961             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
962             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
967 
968         }
969 
970         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
971         return queryId;
972     }
973 
974     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
975         oraclize_randomDS_args[queryId] = commitment;
976     }
977 
978     mapping(bytes32=>bytes32) oraclize_randomDS_args;
979     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
980 
981     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
982         bool sigok;
983         address signer;
984 
985         bytes32 sigr;
986         bytes32 sigs;
987 
988         bytes memory sigr_ = new bytes(32);
989         uint offset = 4+(uint(dersig[3]) - 0x20);
990         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
991         bytes memory sigs_ = new bytes(32);
992         offset += 32 + 2;
993         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
994 
995         assembly {
996             sigr := mload(add(sigr_, 32))
997             sigs := mload(add(sigs_, 32))
998         }
999 
1000 
1001         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1002         if (address(sha3(pubkey)) == signer) return true;
1003         else {
1004             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1005             return (address(sha3(pubkey)) == signer);
1006         }
1007     }
1008 
1009     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1010         bool sigok;
1011 
1012         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1013         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1014         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1015 
1016         bytes memory appkey1_pubkey = new bytes(64);
1017         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1018 
1019         bytes memory tosign2 = new bytes(1+65+32);
1020         tosign2[0] = 1; //role
1021         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1022         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1023         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1024         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1025 
1026         if (sigok == false) return false;
1027 
1028 
1029         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1030         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1031 
1032         bytes memory tosign3 = new bytes(1+65);
1033         tosign3[0] = 0xFE;
1034         copyBytes(proof, 3, 65, tosign3, 1);
1035 
1036         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1037         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1038 
1039         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1040 
1041         return sigok;
1042     }
1043 
1044     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1045         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1046         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1047 
1048         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1049         if (proofVerified == false) throw;
1050 
1051         _;
1052     }
1053 
1054     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1055         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1056         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1057 
1058         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1059         if (proofVerified == false) return 2;
1060 
1061         return 0;
1062     }
1063 
1064     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1065         bool match_ = true;
1066 
1067 	if (prefix.length != n_random_bytes) throw;
1068 
1069         for (uint256 i=0; i< n_random_bytes; i++) {
1070             if (content[i] != prefix[i]) match_ = false;
1071         }
1072 
1073         return match_;
1074     }
1075 
1076     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1077 
1078         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1079         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1080         bytes memory keyhash = new bytes(32);
1081         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1082         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1083 
1084         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1085         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1086 
1087         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1088         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1089 
1090         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1091         // This is to verify that the computed args match with the ones specified in the query.
1092         bytes memory commitmentSlice1 = new bytes(8+1+32);
1093         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1094 
1095         bytes memory sessionPubkey = new bytes(64);
1096         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1097         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1098 
1099         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1100         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1101             delete oraclize_randomDS_args[queryId];
1102         } else return false;
1103 
1104 
1105         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1106         bytes memory tosign1 = new bytes(32+8+1+32);
1107         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1108         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1109 
1110         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1111         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1112             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1113         }
1114 
1115         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1116     }
1117 
1118 
1119     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1120     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1121         uint minLength = length + toOffset;
1122 
1123         if (to.length < minLength) {
1124             // Buffer too small
1125             throw; // Should be a better way?
1126         }
1127 
1128         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1129         uint i = 32 + fromOffset;
1130         uint j = 32 + toOffset;
1131 
1132         while (i < (32 + fromOffset + length)) {
1133             assembly {
1134                 let tmp := mload(add(from, i))
1135                 mstore(add(to, j), tmp)
1136             }
1137             i += 32;
1138             j += 32;
1139         }
1140 
1141         return to;
1142     }
1143 
1144     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1145     // Duplicate Solidity's ecrecover, but catching the CALL return value
1146     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1147         // We do our own memory management here. Solidity uses memory offset
1148         // 0x40 to store the current end of memory. We write past it (as
1149         // writes are memory extensions), but don't update the offset so
1150         // Solidity will reuse it. The memory used here is only needed for
1151         // this context.
1152 
1153         // FIXME: inline assembly can't access return values
1154         bool ret;
1155         address addr;
1156 
1157         assembly {
1158             let size := mload(0x40)
1159             mstore(size, hash)
1160             mstore(add(size, 32), v)
1161             mstore(add(size, 64), r)
1162             mstore(add(size, 96), s)
1163 
1164             // NOTE: we can reuse the request memory because we deal with
1165             //       the return code
1166             ret := call(3000, 1, 0, size, 128, size, 32)
1167             addr := mload(size)
1168         }
1169 
1170         return (ret, addr);
1171     }
1172 
1173     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1174     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1175         bytes32 r;
1176         bytes32 s;
1177         uint8 v;
1178 
1179         if (sig.length != 65)
1180           return (false, 0);
1181 
1182         // The signature format is a compact form of:
1183         //   {bytes32 r}{bytes32 s}{uint8 v}
1184         // Compact means, uint8 is not padded to 32 bytes.
1185         assembly {
1186             r := mload(add(sig, 32))
1187             s := mload(add(sig, 64))
1188 
1189             // Here we are loading the last 32 bytes. We exploit the fact that
1190             // 'mload' will pad with zeroes if we overread.
1191             // There is no 'mload8' to do this, but that would be nicer.
1192             v := byte(0, mload(add(sig, 96)))
1193 
1194             // Alternative solution:
1195             // 'byte' is not working due to the Solidity parser, so lets
1196             // use the second best option, 'and'
1197             // v := and(mload(add(sig, 65)), 255)
1198         }
1199 
1200         // albeit non-transactional signatures are not specified by the YP, one would expect it
1201         // to match the YP range of [27, 28]
1202         //
1203         // geth uses [0, 1] and some clients have followed. This might change, see:
1204         //  https://github.com/ethereum/go-ethereum/issues/2053
1205         if (v < 27)
1206           v += 27;
1207 
1208         if (v != 27 && v != 28)
1209             return (false, 0);
1210 
1211         return safer_ecrecover(hash, v, r, s);
1212     }
1213 
1214 }
1215 // </ORACLIZE_API>
1216 
1217 contract Roll100 is usingOraclize {
1218   address public owner;
1219   uint public gasLimitForOraclize;
1220   uint public gasPriceForOraclize;
1221   bool public gamePaused;
1222   uint public minBet;
1223   uint public lockedShares;
1224   uint public fee;
1225   uint public bankersLimit;
1226   address[] public bankers;
1227   bytes32[] public queryIds;
1228   uint public allShares;
1229 
1230   mapping (address => uint) bankerShare;
1231   mapping (bytes32 => address) playerAddress;
1232   mapping (bytes32 => uint) playerRatio;
1233   mapping (bytes32 => uint) playerValue;
1234   mapping (bytes32 => uint) playerLuckyNumber;
1235 
1236   event LogPlayerBet(address indexed PlayerAddress, bytes32 indexed QueryId, uint Ratio, uint BetValue);
1237   event LogBetResult(address indexed PlayerAddress, bytes32 indexed QueryId, uint LuckyNumber);
1238   event LogBeBanker(address indexed BankerAddress, uint Share);
1239 	event LogQuitBanker(address indexed BankerAddress, uint Payout);
1240   event LogString(string str);
1241 
1242   modifier onlyOwner() {
1243     require(msg.sender == owner);
1244     _;
1245   }
1246 
1247   function Roll100() public {
1248     owner = msg.sender;
1249 
1250     minBet = 0.2 ether;
1251     lockedShares = 0;
1252     fee = 200;
1253     bankersLimit = 10;
1254     gasLimitForOraclize = 200000;
1255     ownerSetGasPrice(15000000000 wei); // 15 gwei
1256     oraclize_setProof(proofType_Ledger); 
1257   }
1258   
1259   function ownerPauseGame(bool newStatus) public onlyOwner {
1260 	  gamePaused = newStatus;
1261   }
1262 
1263   function ownerSetMinBet(uint newMinimumBet) public onlyOwner {
1264     minBet = newMinimumBet;
1265   }
1266 
1267   function ownerSetFee(uint newFee) public onlyOwner {
1268     fee = newFee;
1269   }
1270 
1271   function ownerSetBankersLimit(uint newBankersLimit) public onlyOwner {
1272     bankersLimit = newBankersLimit;
1273   }
1274 
1275   function ownerSetGasLimit(uint newGasLimit) public onlyOwner {
1276     gasLimitForOraclize = newGasLimit;
1277   }
1278 
1279   function ownerSetGasPrice(uint newGasPrice) public onlyOwner {
1280     gasPriceForOraclize = newGasPrice;
1281     oraclize_setCustomGasPrice(gasPriceForOraclize);
1282   }
1283 
1284   function ownerResetLockedShares() public onlyOwner {
1285     lockedShares = 0;
1286   }
1287 
1288   function fixNoCallback(bytes32 _queryId) public onlyOwner {
1289     require (playerLuckyNumber[_queryId] == 0);
1290 
1291     address player = playerAddress[_queryId];
1292     uint ratio = playerRatio[_queryId];
1293     uint value = playerValue[_queryId];
1294     uint amount = mul(value, ratio);
1295     lockedShares = sub(lockedShares, amount);
1296     playerLuckyNumber[_queryId] = 999;
1297     player.transfer(value);
1298   }
1299 
1300   function playerBet(uint ratio) public payable {
1301     require(gamePaused == false);
1302     require(ratio == 2 || ratio == 4 || ratio == 10);
1303     require(msg.value >= minBet);
1304     require(sub(address(this).balance, allShares) > oraclize_getPrice("random", gasLimitForOraclize));
1305     uint amount = mul(msg.value, ratio);
1306     require(amount <= sub(allShares, lockedShares));
1307 
1308     lockedShares = add(lockedShares, amount);
1309     bytes32 queryId = oraclize_newRandomDSQuery(0, 5, gasLimitForOraclize);
1310     queryIds.push(queryId);
1311     playerAddress[queryId] = msg.sender;
1312     playerRatio[queryId] = ratio;
1313     playerValue[queryId] = msg.value;
1314 
1315     LogPlayerBet(msg.sender, queryId, ratio, msg.value);
1316   }
1317 
1318   function __callback(bytes32 _queryId, string _result, bytes _proof) public { 
1319     require(msg.sender == oraclize_cbAddress());
1320     require (playerLuckyNumber[_queryId] == 0);
1321     require(playerAddress[_queryId] != 0x0 && playerRatio[_queryId] > 0 && playerValue[_queryId] > 0);
1322     
1323     address player = playerAddress[_queryId];
1324     uint ratio = playerRatio[_queryId];
1325     uint value = playerValue[_queryId];
1326     uint amount = mul(value, ratio);
1327     lockedShares = sub(lockedShares, amount);
1328 
1329     if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
1330       uint luckyNumber = uint(keccak256(_result)) % 100 + 1;
1331       playerLuckyNumber[_queryId] = luckyNumber;
1332 
1333       if ((ratio == 2 && luckyNumber > 51) ||
1334           (ratio == 4 && luckyNumber > 76) ||
1335           (ratio == 10 && luckyNumber > 91)) {
1336             subShares(sub(amount, value));
1337             amount = subFees(amount);
1338             player.transfer(amount);
1339       } else {
1340         addShares(value);
1341       }
1342       LogBetResult(player, _queryId, luckyNumber);
1343     } else {
1344       playerLuckyNumber[_queryId] = 999;
1345       player.transfer(value);
1346       LogString("oraclize error!!!");
1347     }
1348   }
1349 
1350   function allQueryIds() public view returns (bytes32[]) {
1351     return queryIds;
1352   }
1353 
1354   function betInfo(bytes32 queryId) public view returns (address, uint, uint, uint) {
1355     return (playerAddress[queryId], playerRatio[queryId], playerValue[queryId], playerLuckyNumber[queryId]);
1356   }
1357 
1358   function beBanker() public payable returns (bool) {
1359     require(msg.value >= 1 ether);
1360     if (bankerShare[msg.sender] > 0) {
1361       bankerShare[msg.sender] += msg.value;
1362     } else {
1363       require(bankers.length < bankersLimit);
1364       bankers.push(msg.sender);
1365       bankerShare[msg.sender] = msg.value;
1366     }
1367     allShares = add(allShares, msg.value);
1368     
1369     LogBeBanker(msg.sender, msg.value);
1370     return true;
1371   }
1372 
1373   function quitBanker() public returns (bool) {
1374     require(bankerShare[msg.sender] > 0);
1375     require(bankerShare[msg.sender] <= sub(allShares, lockedShares));
1376     bool contains = false;
1377     uint index;
1378     for (uint i = 0; i < bankers.length; i++) {
1379       if (bankers[i] == msg.sender) {
1380         contains = true;
1381         index = i;
1382       }
1383     }
1384     if (contains) {
1385       bankers[index] = bankers[bankers.length - 1];
1386       delete bankers[bankers.length - 1];
1387       bankers.length--;
1388     }
1389 
1390     uint value = bankerShare[msg.sender];
1391     delete bankerShare[msg.sender];
1392     allShares = sub(allShares, value);
1393     value = subFees(value);
1394     msg.sender.transfer(value);
1395 
1396     LogQuitBanker(msg.sender, value);
1397     return true;
1398   }
1399 
1400   function allBankers() public view returns (address[]) {
1401     return bankers;
1402   }
1403 
1404   function queryShare(address banker) public view returns (uint) {
1405     return bankerShare[banker];
1406   }
1407 
1408   function addShares(uint change) internal {
1409     uint amount = 0;
1410     for (uint i = 0; i < bankers.length; i++) {
1411       uint share = bankerShare[bankers[i]];
1412       uint value = wmul(wdiv(share, allShares), change);
1413       bankerShare[bankers[i]] = add(share, value);
1414       amount = add(amount, value);
1415     }
1416     allShares = add(allShares, amount);
1417   }
1418 
1419   function subShares(uint change) internal {
1420     uint amount = 0;
1421     for (uint i = 0; i < bankers.length; i++) {
1422       uint share = bankerShare[bankers[i]];
1423       uint value =  wmul(wdiv(share, allShares), change);
1424       bankerShare[bankers[i]] = sub(share, value);
1425       amount = add(amount, value);
1426     }
1427     allShares = sub(allShares, amount);
1428   }
1429 
1430   function subFees(uint amount) internal view returns (uint) {
1431     return wmul(amount, wdiv(sub(10000, fee), 10000));
1432   }
1433 
1434   function withdrawFees(uint amount) external onlyOwner returns (bool) {
1435     uint value = address(this).balance;
1436     value = sub(value, allShares);
1437     if (amount <= value) {
1438       owner.transfer(amount);
1439       return true;
1440     } else {
1441       return false;
1442     }
1443   }
1444 
1445   function () public payable {
1446   }
1447 
1448   function add(uint x, uint y) internal pure returns (uint z) {
1449     require((z = x + y) >= x);
1450   }
1451 
1452   function sub(uint x, uint y) internal pure returns (uint z) {
1453     require((z = x - y) <= x);
1454   }
1455 
1456   function mul(uint x, uint y) internal pure returns (uint z) {
1457     require(y == 0 || (z = x * y) / y == x);
1458   }
1459 
1460   uint constant WAD = 10 ** 18;
1461 
1462   function wmul(uint x, uint y) internal pure returns (uint z) {
1463     z = add(mul(x, y), WAD / 2) / WAD;
1464   }
1465 
1466   function wdiv(uint x, uint y) internal pure returns (uint z) {
1467     z = add(mul(x, WAD), y / 2) / y;
1468   }
1469 }