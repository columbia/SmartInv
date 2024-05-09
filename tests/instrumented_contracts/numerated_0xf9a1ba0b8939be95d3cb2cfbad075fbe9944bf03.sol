1 pragma solidity ^0.4.0;
2 
3 contract Mortal {
4     /* Define variable owner of the type address*/
5     address owner;
6 
7     /* this function is executed at initialization and sets the owner of the contract */
8     function Mortal() { owner = msg.sender; }
9 
10     /* Function to recover the funds on the contract */
11     function kill() { if (msg.sender == owner) selfdestruct(owner); }
12 
13     modifier onlyOwner {
14       require(msg.sender == owner);
15       _;
16     }
17 }
18 
19 // <ORACLIZE_API>
20 /*
21 Copyright (c) 2015-2016 Oraclize SRL
22 Copyright (c) 2016 Oraclize LTD
23 
24 
25 
26 Permission is hereby granted, free of charge, to any person obtaining a copy
27 of this software and associated documentation files (the "Software"), to deal
28 in the Software without restriction, including without limitation the rights
29 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
30 copies of the Software, and to permit persons to whom the Software is
31 furnished to do so, subject to the following conditions:
32 
33 
34 
35 The above copyright notice and this permission notice shall be included in
36 all copies or substantial portions of the Software.
37 
38 
39 
40 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
41 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
42 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
43 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
44 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
45 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
46 THE SOFTWARE.
47 */
48 
49 pragma solidity >=0.4.1;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.x
50 
51 contract OraclizeI {
52     address public cbAddress;
53     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
54     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
55     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
56     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
57     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
58     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
59     function getPrice(string _datasource) returns (uint _dsprice);
60     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
61     function useCoupon(string _coupon);
62     function setProofType(byte _proofType);
63     function setConfig(bytes32 _config);
64     function setCustomGasPrice(uint _gasPrice);
65     function randomDS_getSessionPubKeyHash() returns(bytes32);
66 }
67 
68 contract OraclizeAddrResolverI {
69     function getAddress() returns (address _addr);
70 }
71 
72 /*
73 Begin solidity-cborutils
74 
75 https://github.com/smartcontractkit/solidity-cborutils
76 
77 MIT License
78 
79 Copyright (c) 2018 SmartContract ChainLink, Ltd.
80 
81 Permission is hereby granted, free of charge, to any person obtaining a copy
82 of this software and associated documentation files (the "Software"), to deal
83 in the Software without restriction, including without limitation the rights
84 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
85 copies of the Software, and to permit persons to whom the Software is
86 furnished to do so, subject to the following conditions:
87 
88 The above copyright notice and this permission notice shall be included in all
89 copies or substantial portions of the Software.
90 
91 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
92 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
93 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
94 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
95 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
96 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
97 SOFTWARE.
98  */
99 
100 library Buffer {
101     struct buffer {
102         bytes buf;
103         uint capacity;
104     }
105 
106     function init(buffer memory buf, uint capacity) internal constant {
107         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
108         // Allocate space for the buffer data
109         buf.capacity = capacity;
110         assembly {
111             let ptr := mload(0x40)
112             mstore(buf, ptr)
113             mstore(0x40, add(ptr, capacity))
114         }
115     }
116 
117     function resize(buffer memory buf, uint capacity) private constant {
118         bytes memory oldbuf = buf.buf;
119         init(buf, capacity);
120         append(buf, oldbuf);
121     }
122 
123     function max(uint a, uint b) private constant returns(uint) {
124         if(a > b) {
125             return a;
126         }
127         return b;
128     }
129 
130     /**
131      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
132      *      would exceed the capacity of the buffer.
133      * @param buf The buffer to append to.
134      * @param data The data to append.
135      * @return The original buffer.
136      */
137     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
138         if(data.length + buf.buf.length > buf.capacity) {
139             resize(buf, max(buf.capacity, data.length) * 2);
140         }
141 
142         uint dest;
143         uint src;
144         uint len = data.length;
145         assembly {
146             // Memory address of the buffer data
147             let bufptr := mload(buf)
148             // Length of existing buffer data
149             let buflen := mload(bufptr)
150             // Start address = buffer address + buffer length + sizeof(buffer length)
151             dest := add(add(bufptr, buflen), 32)
152             // Update buffer length
153             mstore(bufptr, add(buflen, mload(data)))
154             src := add(data, 32)
155         }
156 
157         // Copy word-length chunks while possible
158         for(; len >= 32; len -= 32) {
159             assembly {
160                 mstore(dest, mload(src))
161             }
162             dest += 32;
163             src += 32;
164         }
165 
166         // Copy remaining bytes
167         uint mask = 256 ** (32 - len) - 1;
168         assembly {
169             let srcpart := and(mload(src), not(mask))
170             let destpart := and(mload(dest), mask)
171             mstore(dest, or(destpart, srcpart))
172         }
173 
174         return buf;
175     }
176 
177     /**
178      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
179      * exceed the capacity of the buffer.
180      * @param buf The buffer to append to.
181      * @param data The data to append.
182      * @return The original buffer.
183      */
184     function append(buffer memory buf, uint8 data) internal constant {
185         if(buf.buf.length + 1 > buf.capacity) {
186             resize(buf, buf.capacity * 2);
187         }
188 
189         assembly {
190             // Memory address of the buffer data
191             let bufptr := mload(buf)
192             // Length of existing buffer data
193             let buflen := mload(bufptr)
194             // Address = buffer address + buffer length + sizeof(buffer length)
195             let dest := add(add(bufptr, buflen), 32)
196             mstore8(dest, data)
197             // Update buffer length
198             mstore(bufptr, add(buflen, 1))
199         }
200     }
201 
202     /**
203      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
204      * exceed the capacity of the buffer.
205      * @param buf The buffer to append to.
206      * @param data The data to append.
207      * @return The original buffer.
208      */
209     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
210         if(len + buf.buf.length > buf.capacity) {
211             resize(buf, max(buf.capacity, len) * 2);
212         }
213 
214         uint mask = 256 ** len - 1;
215         assembly {
216             // Memory address of the buffer data
217             let bufptr := mload(buf)
218             // Length of existing buffer data
219             let buflen := mload(bufptr)
220             // Address = buffer address + buffer length + sizeof(buffer length) + len
221             let dest := add(add(bufptr, buflen), len)
222             mstore(dest, or(and(mload(dest), not(mask)), data))
223             // Update buffer length
224             mstore(bufptr, add(buflen, len))
225         }
226         return buf;
227     }
228 }
229 
230 library CBOR {
231     using Buffer for Buffer.buffer;
232 
233     uint8 private constant MAJOR_TYPE_INT = 0;
234     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
235     uint8 private constant MAJOR_TYPE_BYTES = 2;
236     uint8 private constant MAJOR_TYPE_STRING = 3;
237     uint8 private constant MAJOR_TYPE_ARRAY = 4;
238     uint8 private constant MAJOR_TYPE_MAP = 5;
239     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
240 
241     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
242         return x * (2 ** y);
243     }
244 
245     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
246         if(value <= 23) {
247             buf.append(uint8(shl8(major, 5) | value));
248         } else if(value <= 0xFF) {
249             buf.append(uint8(shl8(major, 5) | 24));
250             buf.appendInt(value, 1);
251         } else if(value <= 0xFFFF) {
252             buf.append(uint8(shl8(major, 5) | 25));
253             buf.appendInt(value, 2);
254         } else if(value <= 0xFFFFFFFF) {
255             buf.append(uint8(shl8(major, 5) | 26));
256             buf.appendInt(value, 4);
257         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
258             buf.append(uint8(shl8(major, 5) | 27));
259             buf.appendInt(value, 8);
260         }
261     }
262 
263     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
264         buf.append(uint8(shl8(major, 5) | 31));
265     }
266 
267     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
268         encodeType(buf, MAJOR_TYPE_INT, value);
269     }
270 
271     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
272         if(value >= 0) {
273             encodeType(buf, MAJOR_TYPE_INT, uint(value));
274         } else {
275             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
276         }
277     }
278 
279     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
280         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
281         buf.append(value);
282     }
283 
284     function encodeString(Buffer.buffer memory buf, string value) internal constant {
285         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
286         buf.append(bytes(value));
287     }
288 
289     function startArray(Buffer.buffer memory buf) internal constant {
290         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
291     }
292 
293     function startMap(Buffer.buffer memory buf) internal constant {
294         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
295     }
296 
297     function endSequence(Buffer.buffer memory buf) internal constant {
298         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
299     }
300 }
301 
302 /*
303 End solidity-cborutils
304  */
305 
306 contract usingOraclize {
307     uint constant day = 60*60*24;
308     uint constant week = 60*60*24*7;
309     uint constant month = 60*60*24*30;
310     byte constant proofType_NONE = 0x00;
311     byte constant proofType_TLSNotary = 0x10;
312     byte constant proofType_Android = 0x20;
313     byte constant proofType_Ledger = 0x30;
314     byte constant proofType_Native = 0xF0;
315     byte constant proofStorage_IPFS = 0x01;
316     uint8 constant networkID_auto = 0;
317     uint8 constant networkID_mainnet = 1;
318     uint8 constant networkID_testnet = 2;
319     uint8 constant networkID_morden = 2;
320     uint8 constant networkID_consensys = 161;
321 
322     OraclizeAddrResolverI OAR;
323 
324     OraclizeI oraclize;
325     modifier oraclizeAPI {
326         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
327             oraclize_setNetwork(networkID_auto);
328 
329         if(address(oraclize) != OAR.getAddress())
330             oraclize = OraclizeI(OAR.getAddress());
331 
332         _;
333     }
334     modifier coupon(string code){
335         oraclize = OraclizeI(OAR.getAddress());
336         oraclize.useCoupon(code);
337         _;
338     }
339 
340     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
341         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
342             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
343             oraclize_setNetworkName("eth_mainnet");
344             return true;
345         }
346         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
347             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
348             oraclize_setNetworkName("eth_ropsten3");
349             return true;
350         }
351         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
352             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
353             oraclize_setNetworkName("eth_kovan");
354             return true;
355         }
356         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
357             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
358             oraclize_setNetworkName("eth_rinkeby");
359             return true;
360         }
361         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
362             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
363             return true;
364         }
365         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
366             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
367             return true;
368         }
369         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
370             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
371             return true;
372         }
373         return false;
374     }
375 
376     function __callback(bytes32 myid, string result) {
377         __callback(myid, result, new bytes(0));
378     }
379     function __callback(bytes32 myid, string result, bytes proof) {
380     }
381 
382     function oraclize_useCoupon(string code) oraclizeAPI internal {
383         oraclize.useCoupon(code);
384     }
385 
386     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
387         return oraclize.getPrice(datasource);
388     }
389 
390     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
391         return oraclize.getPrice(datasource, gaslimit);
392     }
393 
394     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource);
396         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
397         return oraclize.query.value(price)(0, datasource, arg);
398     }
399     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource);
401         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
402         return oraclize.query.value(price)(timestamp, datasource, arg);
403     }
404     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource, gaslimit);
406         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
407         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
408     }
409     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource, gaslimit);
411         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
412         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
413     }
414     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource);
416         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
417         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
418     }
419     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource);
421         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
422         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
423     }
424     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource, gaslimit);
426         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
427         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
428     }
429     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource, gaslimit);
431         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
432         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
433     }
434     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource);
436         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
437         bytes memory args = stra2cbor(argN);
438         return oraclize.queryN.value(price)(0, datasource, args);
439     }
440     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource);
442         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
443         bytes memory args = stra2cbor(argN);
444         return oraclize.queryN.value(price)(timestamp, datasource, args);
445     }
446     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
447         uint price = oraclize.getPrice(datasource, gaslimit);
448         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
449         bytes memory args = stra2cbor(argN);
450         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
451     }
452     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
453         uint price = oraclize.getPrice(datasource, gaslimit);
454         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
455         bytes memory args = stra2cbor(argN);
456         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
457     }
458     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](1);
460         dynargs[0] = args[0];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](1);
465         dynargs[0] = args[0];
466         return oraclize_query(timestamp, datasource, dynargs);
467     }
468     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](1);
470         dynargs[0] = args[0];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](1);
475         dynargs[0] = args[0];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478 
479     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(datasource, dynargs);
484     }
485     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](2);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         return oraclize_query(timestamp, datasource, dynargs);
490     }
491     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         string[] memory dynargs = new string[](2);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
496     }
497     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](2);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         return oraclize_query(datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](3);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         return oraclize_query(datasource, dynargs);
509     }
510     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](3);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         return oraclize_query(timestamp, datasource, dynargs);
516     }
517     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](3);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
523     }
524     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](3);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         return oraclize_query(datasource, dynargs, gaslimit);
530     }
531 
532     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](4);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         return oraclize_query(datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](4);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         return oraclize_query(timestamp, datasource, dynargs);
547     }
548     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](4);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
555     }
556     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](4);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         dynargs[3] = args[3];
562         return oraclize_query(datasource, dynargs, gaslimit);
563     }
564     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
565         string[] memory dynargs = new string[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(datasource, dynargs);
572     }
573     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(timestamp, datasource, dynargs);
581     }
582     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
583         string[] memory dynargs = new string[](5);
584         dynargs[0] = args[0];
585         dynargs[1] = args[1];
586         dynargs[2] = args[2];
587         dynargs[3] = args[3];
588         dynargs[4] = args[4];
589         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
590     }
591     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
592         string[] memory dynargs = new string[](5);
593         dynargs[0] = args[0];
594         dynargs[1] = args[1];
595         dynargs[2] = args[2];
596         dynargs[3] = args[3];
597         dynargs[4] = args[4];
598         return oraclize_query(datasource, dynargs, gaslimit);
599     }
600     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
601         uint price = oraclize.getPrice(datasource);
602         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
603         bytes memory args = ba2cbor(argN);
604         return oraclize.queryN.value(price)(0, datasource, args);
605     }
606     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
607         uint price = oraclize.getPrice(datasource);
608         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
609         bytes memory args = ba2cbor(argN);
610         return oraclize.queryN.value(price)(timestamp, datasource, args);
611     }
612     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
613         uint price = oraclize.getPrice(datasource, gaslimit);
614         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
615         bytes memory args = ba2cbor(argN);
616         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
617     }
618     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
619         uint price = oraclize.getPrice(datasource, gaslimit);
620         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
621         bytes memory args = ba2cbor(argN);
622         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
623     }
624     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](1);
626         dynargs[0] = args[0];
627         return oraclize_query(datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](1);
631         dynargs[0] = args[0];
632         return oraclize_query(timestamp, datasource, dynargs);
633     }
634     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](1);
636         dynargs[0] = args[0];
637         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
638     }
639     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](1);
641         dynargs[0] = args[0];
642         return oraclize_query(datasource, dynargs, gaslimit);
643     }
644 
645     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](2);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         return oraclize_query(datasource, dynargs);
650     }
651     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](2);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         return oraclize_query(timestamp, datasource, dynargs);
656     }
657     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
658         bytes[] memory dynargs = new bytes[](2);
659         dynargs[0] = args[0];
660         dynargs[1] = args[1];
661         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
662     }
663     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](2);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         return oraclize_query(datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](3);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         return oraclize_query(datasource, dynargs);
675     }
676     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](3);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         return oraclize_query(timestamp, datasource, dynargs);
682     }
683     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](3);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
689     }
690     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
691         bytes[] memory dynargs = new bytes[](3);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         return oraclize_query(datasource, dynargs, gaslimit);
696     }
697 
698     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](4);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         dynargs[2] = args[2];
703         dynargs[3] = args[3];
704         return oraclize_query(datasource, dynargs);
705     }
706     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](4);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         return oraclize_query(timestamp, datasource, dynargs);
713     }
714     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
715         bytes[] memory dynargs = new bytes[](4);
716         dynargs[0] = args[0];
717         dynargs[1] = args[1];
718         dynargs[2] = args[2];
719         dynargs[3] = args[3];
720         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
721     }
722     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
723         bytes[] memory dynargs = new bytes[](4);
724         dynargs[0] = args[0];
725         dynargs[1] = args[1];
726         dynargs[2] = args[2];
727         dynargs[3] = args[3];
728         return oraclize_query(datasource, dynargs, gaslimit);
729     }
730     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
731         bytes[] memory dynargs = new bytes[](5);
732         dynargs[0] = args[0];
733         dynargs[1] = args[1];
734         dynargs[2] = args[2];
735         dynargs[3] = args[3];
736         dynargs[4] = args[4];
737         return oraclize_query(datasource, dynargs);
738     }
739     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](5);
741         dynargs[0] = args[0];
742         dynargs[1] = args[1];
743         dynargs[2] = args[2];
744         dynargs[3] = args[3];
745         dynargs[4] = args[4];
746         return oraclize_query(timestamp, datasource, dynargs);
747     }
748     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](5);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         dynargs[4] = args[4];
755         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
756     }
757     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
758         bytes[] memory dynargs = new bytes[](5);
759         dynargs[0] = args[0];
760         dynargs[1] = args[1];
761         dynargs[2] = args[2];
762         dynargs[3] = args[3];
763         dynargs[4] = args[4];
764         return oraclize_query(datasource, dynargs, gaslimit);
765     }
766 
767     function oraclize_cbAddress() oraclizeAPI internal returns (address){
768         return oraclize.cbAddress();
769     }
770     function oraclize_setProof(byte proofP) oraclizeAPI internal {
771         return oraclize.setProofType(proofP);
772     }
773     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
774         return oraclize.setCustomGasPrice(gasPrice);
775     }
776     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
777         return oraclize.setConfig(config);
778     }
779 
780     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
781         return oraclize.randomDS_getSessionPubKeyHash();
782     }
783 
784     function getCodeSize(address _addr) constant internal returns(uint _size) {
785         assembly {
786             _size := extcodesize(_addr)
787         }
788     }
789 
790     function parseAddr(string _a) internal returns (address){
791         bytes memory tmp = bytes(_a);
792         uint160 iaddr = 0;
793         uint160 b1;
794         uint160 b2;
795         for (uint i=2; i<2+2*20; i+=2){
796             iaddr *= 256;
797             b1 = uint160(tmp[i]);
798             b2 = uint160(tmp[i+1]);
799             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
800             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
801             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
802             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
803             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
804             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
805             iaddr += (b1*16+b2);
806         }
807         return address(iaddr);
808     }
809 
810     function strCompare(string _a, string _b) internal returns (int) {
811         bytes memory a = bytes(_a);
812         bytes memory b = bytes(_b);
813         uint minLength = a.length;
814         if (b.length < minLength) minLength = b.length;
815         for (uint i = 0; i < minLength; i ++)
816             if (a[i] < b[i])
817                 return -1;
818             else if (a[i] > b[i])
819                 return 1;
820         if (a.length < b.length)
821             return -1;
822         else if (a.length > b.length)
823             return 1;
824         else
825             return 0;
826     }
827 
828     function indexOf(string _haystack, string _needle) internal returns (int) {
829         bytes memory h = bytes(_haystack);
830         bytes memory n = bytes(_needle);
831         if(h.length < 1 || n.length < 1 || (n.length > h.length))
832             return -1;
833         else if(h.length > (2**128 -1))
834             return -1;
835         else
836         {
837             uint subindex = 0;
838             for (uint i = 0; i < h.length; i ++)
839             {
840                 if (h[i] == n[0])
841                 {
842                     subindex = 1;
843                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
844                     {
845                         subindex++;
846                     }
847                     if(subindex == n.length)
848                         return int(i);
849                 }
850             }
851             return -1;
852         }
853     }
854 
855     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
856         bytes memory _ba = bytes(_a);
857         bytes memory _bb = bytes(_b);
858         bytes memory _bc = bytes(_c);
859         bytes memory _bd = bytes(_d);
860         bytes memory _be = bytes(_e);
861         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
862         bytes memory babcde = bytes(abcde);
863         uint k = 0;
864         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
865         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
866         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
867         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
868         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
869         return string(babcde);
870     }
871 
872     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
873         return strConcat(_a, _b, _c, _d, "");
874     }
875 
876     function strConcat(string _a, string _b, string _c) internal returns (string) {
877         return strConcat(_a, _b, _c, "", "");
878     }
879 
880     function strConcat(string _a, string _b) internal returns (string) {
881         return strConcat(_a, _b, "", "", "");
882     }
883 
884     // parseInt
885     function parseInt(string _a) internal returns (uint) {
886         return parseInt(_a, 0);
887     }
888 
889     // parseInt(parseFloat*10^_b)
890     function parseInt(string _a, uint _b) internal returns (uint) {
891         bytes memory bresult = bytes(_a);
892         uint mint = 0;
893         bool decimals = false;
894         for (uint i=0; i<bresult.length; i++){
895             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
896                 if (decimals){
897                    if (_b == 0) break;
898                     else _b--;
899                 }
900                 mint *= 10;
901                 mint += uint(bresult[i]) - 48;
902             } else if (bresult[i] == 46) decimals = true;
903         }
904         if (_b > 0) mint *= 10**_b;
905         return mint;
906     }
907 
908     function uint2str(uint i) internal returns (string){
909         if (i == 0) return "0";
910         uint j = i;
911         uint len;
912         while (j != 0){
913             len++;
914             j /= 10;
915         }
916         bytes memory bstr = new bytes(len);
917         uint k = len - 1;
918         while (i != 0){
919             bstr[k--] = byte(48 + i % 10);
920             i /= 10;
921         }
922         return string(bstr);
923     }
924 
925     using CBOR for Buffer.buffer;
926     function stra2cbor(string[] arr) internal constant returns (bytes) {
927         Buffer.buffer memory buf;
928         Buffer.init(buf, 1024);
929         buf.startArray();
930         for (uint i = 0; i < arr.length; i++) {
931             buf.encodeString(arr[i]);
932         }
933         buf.endSequence();
934         return buf.buf;
935     }
936 
937     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
938         Buffer.buffer memory buf;
939         Buffer.init(buf, 1024);
940         buf.startArray();
941         for (uint i = 0; i < arr.length; i++) {
942             buf.encodeBytes(arr[i]);
943         }
944         buf.endSequence();
945         return buf.buf;
946     }
947 
948     string oraclize_network_name;
949     function oraclize_setNetworkName(string _network_name) internal {
950         oraclize_network_name = _network_name;
951     }
952 
953     function oraclize_getNetworkName() internal returns (string) {
954         return oraclize_network_name;
955     }
956 
957     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
958         if ((_nbytes == 0)||(_nbytes > 32)) throw;
959 	// Convert from seconds to ledger timer ticks
960         _delay *= 10;
961         bytes memory nbytes = new bytes(1);
962         nbytes[0] = byte(_nbytes);
963         bytes memory unonce = new bytes(32);
964         bytes memory sessionKeyHash = new bytes(32);
965         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
966         assembly {
967             mstore(unonce, 0x20)
968             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
969             mstore(sessionKeyHash, 0x20)
970             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
971         }
972         bytes memory delay = new bytes(32);
973         assembly {
974             mstore(add(delay, 0x20), _delay)
975         }
976 
977         bytes memory delay_bytes8 = new bytes(8);
978         copyBytes(delay, 24, 8, delay_bytes8, 0);
979 
980         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
981         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
982 
983         bytes memory delay_bytes8_left = new bytes(8);
984 
985         assembly {
986             let x := mload(add(delay_bytes8, 0x20))
987             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
988             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
989             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
990             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
991             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
992             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
993             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
994             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
995 
996         }
997 
998         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
999         return queryId;
1000     }
1001 
1002     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1003         oraclize_randomDS_args[queryId] = commitment;
1004     }
1005 
1006     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1007     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1008 
1009     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1010         bool sigok;
1011         address signer;
1012 
1013         bytes32 sigr;
1014         bytes32 sigs;
1015 
1016         bytes memory sigr_ = new bytes(32);
1017         uint offset = 4+(uint(dersig[3]) - 0x20);
1018         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1019         bytes memory sigs_ = new bytes(32);
1020         offset += 32 + 2;
1021         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1022 
1023         assembly {
1024             sigr := mload(add(sigr_, 32))
1025             sigs := mload(add(sigs_, 32))
1026         }
1027 
1028 
1029         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1030         if (address(sha3(pubkey)) == signer) return true;
1031         else {
1032             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1033             return (address(sha3(pubkey)) == signer);
1034         }
1035     }
1036 
1037     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1038         bool sigok;
1039 
1040         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1041         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1042         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1043 
1044         bytes memory appkey1_pubkey = new bytes(64);
1045         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1046 
1047         bytes memory tosign2 = new bytes(1+65+32);
1048         tosign2[0] = 1; //role
1049         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1050         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1051         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1052         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1053 
1054         if (sigok == false) return false;
1055 
1056 
1057         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1058         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1059 
1060         bytes memory tosign3 = new bytes(1+65);
1061         tosign3[0] = 0xFE;
1062         copyBytes(proof, 3, 65, tosign3, 1);
1063 
1064         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1065         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1066 
1067         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1068 
1069         return sigok;
1070     }
1071 
1072     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1073         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1074         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1075 
1076         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1077         if (proofVerified == false) throw;
1078 
1079         _;
1080     }
1081 
1082     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1083         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1084         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1085 
1086         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1087         if (proofVerified == false) return 2;
1088 
1089         return 0;
1090     }
1091 
1092     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1093         bool match_ = true;
1094 
1095 	if (prefix.length != n_random_bytes) throw;
1096 
1097         for (uint256 i=0; i< n_random_bytes; i++) {
1098             if (content[i] != prefix[i]) match_ = false;
1099         }
1100 
1101         return match_;
1102     }
1103 
1104     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1105 
1106         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1107         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1108         bytes memory keyhash = new bytes(32);
1109         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1110         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1111 
1112         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1113         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1114 
1115         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1116         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1117 
1118         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1119         // This is to verify that the computed args match with the ones specified in the query.
1120         bytes memory commitmentSlice1 = new bytes(8+1+32);
1121         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1122 
1123         bytes memory sessionPubkey = new bytes(64);
1124         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1125         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1126 
1127         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1128         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1129             delete oraclize_randomDS_args[queryId];
1130         } else return false;
1131 
1132 
1133         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1134         bytes memory tosign1 = new bytes(32+8+1+32);
1135         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1136         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1137 
1138         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1139         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1140             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1141         }
1142 
1143         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1144     }
1145 
1146 
1147     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1148     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1149         uint minLength = length + toOffset;
1150 
1151         if (to.length < minLength) {
1152             // Buffer too small
1153             throw; // Should be a better way?
1154         }
1155 
1156         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1157         uint i = 32 + fromOffset;
1158         uint j = 32 + toOffset;
1159 
1160         while (i < (32 + fromOffset + length)) {
1161             assembly {
1162                 let tmp := mload(add(from, i))
1163                 mstore(add(to, j), tmp)
1164             }
1165             i += 32;
1166             j += 32;
1167         }
1168 
1169         return to;
1170     }
1171 
1172     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1173     // Duplicate Solidity's ecrecover, but catching the CALL return value
1174     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1175         // We do our own memory management here. Solidity uses memory offset
1176         // 0x40 to store the current end of memory. We write past it (as
1177         // writes are memory extensions), but don't update the offset so
1178         // Solidity will reuse it. The memory used here is only needed for
1179         // this context.
1180 
1181         // FIXME: inline assembly can't access return values
1182         bool ret;
1183         address addr;
1184 
1185         assembly {
1186             let size := mload(0x40)
1187             mstore(size, hash)
1188             mstore(add(size, 32), v)
1189             mstore(add(size, 64), r)
1190             mstore(add(size, 96), s)
1191 
1192             // NOTE: we can reuse the request memory because we deal with
1193             //       the return code
1194             ret := call(3000, 1, 0, size, 128, size, 32)
1195             addr := mload(size)
1196         }
1197 
1198         return (ret, addr);
1199     }
1200 
1201     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1202     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1203         bytes32 r;
1204         bytes32 s;
1205         uint8 v;
1206 
1207         if (sig.length != 65)
1208           return (false, 0);
1209 
1210         // The signature format is a compact form of:
1211         //   {bytes32 r}{bytes32 s}{uint8 v}
1212         // Compact means, uint8 is not padded to 32 bytes.
1213         assembly {
1214             r := mload(add(sig, 32))
1215             s := mload(add(sig, 64))
1216 
1217             // Here we are loading the last 32 bytes. We exploit the fact that
1218             // 'mload' will pad with zeroes if we overread.
1219             // There is no 'mload8' to do this, but that would be nicer.
1220             v := byte(0, mload(add(sig, 96)))
1221 
1222             // Alternative solution:
1223             // 'byte' is not working due to the Solidity parser, so lets
1224             // use the second best option, 'and'
1225             // v := and(mload(add(sig, 65)), 255)
1226         }
1227 
1228         // albeit non-transactional signatures are not specified by the YP, one would expect it
1229         // to match the YP range of [27, 28]
1230         //
1231         // geth uses [0, 1] and some clients have followed. This might change, see:
1232         //  https://github.com/ethereum/go-ethereum/issues/2053
1233         if (v < 27)
1234           v += 27;
1235 
1236         if (v != 27 && v != 28)
1237             return (false, 0);
1238 
1239         return safer_ecrecover(hash, v, r, s);
1240     }
1241 
1242 }
1243 // </ORACLIZE_API>
1244  
1245 
1246 contract cosmicDice is usingOraclize, Mortal {
1247     
1248     uint constant minbet = 0.01 ether;
1249     uint constant maxbet = 1 ether;
1250     uint public totalPlayCount = 0;  //total game play count
1251     mapping(address => uint) public playerPlayCount; //player play count
1252     mapping(uint => address) public player; //player mapping
1253     mapping(address => uint) public ln;  //user chosen lucky number
1254     mapping(address => uint) public prn; //psuedo random number
1255     mapping(address => uint) public trn; //true random number
1256     mapping(address => uint) public crn; //combined random number
1257     mapping(address => uint) public payout; //payout calculated for each play
1258     mapping(address => uint) public nval; //max n value
1259     mapping(address => uint) public multiplier; //multuplier for win payout
1260     uint public bl;  //another prn
1261 
1262     function cosmicDice() public payable {
1263         
1264     }
1265     
1266     function() public payable {
1267         
1268     }
1269     
1270     function deposit() public payable {
1271         
1272     }
1273     
1274     function withdraw(uint _withdrawAmount) public {
1275         
1276         require(msg.sender == owner);
1277         msg.sender.transfer(_withdrawAmount); //withdraw amount must be in Wei and inside double quotes so the javascript solidity browser can read it as a BigNumber
1278     }
1279     
1280     event message(string result, uint ln, uint crn);
1281 
1282     function play(uint _luckynum, uint _trueRand, uint _nval) payable {
1283         require(msg.value >= minbet && msg.value <= maxbet);
1284         require(_nval==2||_nval==6||_nval==10||_nval==20||_nval==50||_nval==100||_nval==500||_nval==1000);
1285         totalPlayCount ++; // index play count
1286         update();  // update the psuedo random number from wolfram alpha
1287         bl = uint(sha3(block.timestamp));
1288         player[totalPlayCount] = msg.sender;
1289         playerPlayCount[player[totalPlayCount]] ++; //index player play count
1290         if (_nval == 2) {
1291             multiplier[player[totalPlayCount]] = (300*_nval)/4;
1292         }
1293         else {
1294             multiplier[player[totalPlayCount]] = 100*_nval/2;
1295         }
1296         nval[player[totalPlayCount]] = _nval;
1297         payout[player[totalPlayCount]] = (msg.value * multiplier[player[totalPlayCount]])/100; // set the payout multiplier
1298         ln[player[totalPlayCount]] = _luckynum;
1299         trn[player[totalPlayCount]] = _trueRand;
1300         prn[player[totalPlayCount]] = randnum;
1301         crn[player[totalPlayCount]] = ((trn[player[totalPlayCount]] + prn[player[totalPlayCount]] + bl) % nval[player[totalPlayCount]]) + 1;
1302         compareNums();
1303     }
1304 
1305     function compareNums() private {
1306         if (ln[player[totalPlayCount]] == crn[player[totalPlayCount]]) {
1307             //return true;
1308             emit message("Congratulations, you win!", ln[player[totalPlayCount]], crn[player[totalPlayCount]]);
1309             player[totalPlayCount].transfer(payout[player[totalPlayCount]]);
1310             payout[player[totalPlayCount]] = 0;
1311         }
1312         else {
1313             //return false;
1314             emit message("Sorry, try again.", ln[player[totalPlayCount]], crn[player[totalPlayCount]]);
1315         }
1316     }
1317 
1318 /// Begin oraclize
1319 
1320     uint public randnum;
1321     uint public gasPrice;
1322 
1323     event newOraclizeQuery(string description);
1324     event newRandNum(string rnum);
1325     
1326     function setCustomGasPrice(uint _gasPrice) public payable{
1327         require(msg.sender == owner);
1328         gasPrice = _gasPrice;
1329         oraclize_setCustomGasPrice(gasPrice); // testing
1330     }
1331 
1332     function __callback(bytes32 myid, string result) {
1333         if (msg.sender != oraclize_cbAddress()) revert();
1334         emit newRandNum(result);
1335         randnum = parseInt(result);
1336     }
1337     
1338     function update() payable {
1339         emit newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1340 //        oraclize_query("URL", "json(https://qrng.anu.edu.au/API/jsonI.php?length=1&type=uint8).data[0]");
1341         oraclize_query("WolframAlpha", "random number between 1 and 10");
1342     }
1343 
1344 }