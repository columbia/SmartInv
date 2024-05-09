1 pragma solidity ^0.4.25;
2 
3 // <ORACLIZE_API>
4 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
5 /*
6 Copyright (c) 2015-2016 Oraclize SRL
7 Copyright (c) 2016 Oraclize LTD
8 
9 
10 
11 Permission is hereby granted, free of charge, to any person obtaining a copy
12 of this software and associated documentation files (the "Software"), to deal
13 in the Software without restriction, including without limitation the rights
14 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
15 copies of the Software, and to permit persons to whom the Software is
16 furnished to do so, subject to the following conditions:
17 
18 
19 
20 The above copyright notice and this permission notice shall be included in
21 all copies or substantial portions of the Software.
22 
23 
24 
25 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
28 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
31 THE SOFTWARE.
32 */
33 
34 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
35 
36 
37 contract OraclizeI {
38     address public cbAddress;
39     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
40     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
41     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
43     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
44     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
45     function getPrice(string _datasource) public returns (uint _dsprice);
46     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
47     function setProofType(byte _proofType) external;
48     function setCustomGasPrice(uint _gasPrice) external;
49     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
50 }
51 
52 contract OraclizeAddrResolverI {
53     function getAddress() public returns (address _addr);
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
90     function init(buffer memory buf, uint _capacity) internal pure {
91         uint capacity = _capacity;
92         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
93         // Allocate space for the buffer data
94         buf.capacity = capacity;
95         assembly {
96             let ptr := mload(0x40)
97             mstore(buf, ptr)
98             mstore(ptr, 0)
99             mstore(0x40, add(ptr, capacity))
100         }
101     }
102 
103     function resize(buffer memory buf, uint capacity) private pure {
104         bytes memory oldbuf = buf.buf;
105         init(buf, capacity);
106         append(buf, oldbuf);
107     }
108 
109     function max(uint a, uint b) private pure returns(uint) {
110         if(a > b) {
111             return a;
112         }
113         return b;
114     }
115 
116     /**
117      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
118      *      would exceed the capacity of the buffer.
119      * @param buf The buffer to append to.
120      * @param data The data to append.
121      * @return The original buffer.
122      */
123     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
124         if(data.length + buf.buf.length > buf.capacity) {
125             resize(buf, max(buf.capacity, data.length) * 2);
126         }
127 
128         uint dest;
129         uint src;
130         uint len = data.length;
131         assembly {
132             // Memory address of the buffer data
133             let bufptr := mload(buf)
134             // Length of existing buffer data
135             let buflen := mload(bufptr)
136             // Start address = buffer address + buffer length + sizeof(buffer length)
137             dest := add(add(bufptr, buflen), 32)
138             // Update buffer length
139             mstore(bufptr, add(buflen, mload(data)))
140             src := add(data, 32)
141         }
142 
143         // Copy word-length chunks while possible
144         for(; len >= 32; len -= 32) {
145             assembly {
146                 mstore(dest, mload(src))
147             }
148             dest += 32;
149             src += 32;
150         }
151 
152         // Copy remaining bytes
153         uint mask = 256 ** (32 - len) - 1;
154         assembly {
155             let srcpart := and(mload(src), not(mask))
156             let destpart := and(mload(dest), mask)
157             mstore(dest, or(destpart, srcpart))
158         }
159 
160         return buf;
161     }
162 
163     /**
164      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
165      * exceed the capacity of the buffer.
166      * @param buf The buffer to append to.
167      * @param data The data to append.
168      * @return The original buffer.
169      */
170     function append(buffer memory buf, uint8 data) internal pure {
171         if(buf.buf.length + 1 > buf.capacity) {
172             resize(buf, buf.capacity * 2);
173         }
174 
175         assembly {
176             // Memory address of the buffer data
177             let bufptr := mload(buf)
178             // Length of existing buffer data
179             let buflen := mload(bufptr)
180             // Address = buffer address + buffer length + sizeof(buffer length)
181             let dest := add(add(bufptr, buflen), 32)
182             mstore8(dest, data)
183             // Update buffer length
184             mstore(bufptr, add(buflen, 1))
185         }
186     }
187 
188     /**
189      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
190      * exceed the capacity of the buffer.
191      * @param buf The buffer to append to.
192      * @param data The data to append.
193      * @return The original buffer.
194      */
195     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
196         if(len + buf.buf.length > buf.capacity) {
197             resize(buf, max(buf.capacity, len) * 2);
198         }
199 
200         uint mask = 256 ** len - 1;
201         assembly {
202             // Memory address of the buffer data
203             let bufptr := mload(buf)
204             // Length of existing buffer data
205             let buflen := mload(bufptr)
206             // Address = buffer address + buffer length + sizeof(buffer length) + len
207             let dest := add(add(bufptr, buflen), len)
208             mstore(dest, or(and(mload(dest), not(mask)), data))
209             // Update buffer length
210             mstore(bufptr, add(buflen, len))
211         }
212         return buf;
213     }
214 }
215 
216 library CBOR {
217     using Buffer for Buffer.buffer;
218 
219     uint8 private constant MAJOR_TYPE_INT = 0;
220     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
221     uint8 private constant MAJOR_TYPE_BYTES = 2;
222     uint8 private constant MAJOR_TYPE_STRING = 3;
223     uint8 private constant MAJOR_TYPE_ARRAY = 4;
224     uint8 private constant MAJOR_TYPE_MAP = 5;
225     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
226 
227     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
228         if(value <= 23) {
229             buf.append(uint8((major << 5) | value));
230         } else if(value <= 0xFF) {
231             buf.append(uint8((major << 5) | 24));
232             buf.appendInt(value, 1);
233         } else if(value <= 0xFFFF) {
234             buf.append(uint8((major << 5) | 25));
235             buf.appendInt(value, 2);
236         } else if(value <= 0xFFFFFFFF) {
237             buf.append(uint8((major << 5) | 26));
238             buf.appendInt(value, 4);
239         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
240             buf.append(uint8((major << 5) | 27));
241             buf.appendInt(value, 8);
242         }
243     }
244 
245     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
246         buf.append(uint8((major << 5) | 31));
247     }
248 
249     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
250         encodeType(buf, MAJOR_TYPE_INT, value);
251     }
252 
253     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
254         if(value >= 0) {
255             encodeType(buf, MAJOR_TYPE_INT, uint(value));
256         } else {
257             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
258         }
259     }
260 
261     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
262         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
263         buf.append(value);
264     }
265 
266     function encodeString(Buffer.buffer memory buf, string value) internal pure {
267         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
268         buf.append(bytes(value));
269     }
270 
271     function startArray(Buffer.buffer memory buf) internal pure {
272         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
273     }
274 
275     function startMap(Buffer.buffer memory buf) internal pure {
276         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
277     }
278 
279     function endSequence(Buffer.buffer memory buf) internal pure {
280         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
281     }
282 }
283 
284 /*
285 End solidity-cborutils
286  */
287 
288 contract usingOraclize {
289     uint constant day = 60*60*24;
290     uint constant week = 60*60*24*7;
291     uint constant month = 60*60*24*30;
292     byte constant proofType_NONE = 0x00;
293     byte constant proofType_TLSNotary = 0x10;
294     byte constant proofType_Ledger = 0x30;
295     byte constant proofType_Android = 0x40;
296     byte constant proofType_Native = 0xF0;
297     byte constant proofStorage_IPFS = 0x01;
298     uint8 constant networkID_auto = 0;
299     uint8 constant networkID_mainnet = 1;
300     uint8 constant networkID_testnet = 2;
301     uint8 constant networkID_morden = 2;
302     uint8 constant networkID_consensys = 161;
303 
304     OraclizeAddrResolverI OAR;
305 
306     OraclizeI oraclize;
307     modifier oraclizeAPI {
308         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
309             oraclize_setNetwork(networkID_auto);
310 
311         if(address(oraclize) != OAR.getAddress())
312             oraclize = OraclizeI(OAR.getAddress());
313 
314         _;
315     }
316     modifier coupon(string code){
317         oraclize = OraclizeI(OAR.getAddress());
318         _;
319     }
320 
321     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
322       return oraclize_setNetwork();
323       networkID; // silence the warning and remain backwards compatible
324     }
325     function oraclize_setNetwork() internal returns(bool){
326         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
327             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
328             oraclize_setNetworkName("eth_mainnet");
329             return true;
330         }
331         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
332             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
333             oraclize_setNetworkName("eth_ropsten3");
334             return true;
335         }
336         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
337             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
338             oraclize_setNetworkName("eth_kovan");
339             return true;
340         }
341         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
342             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
343             oraclize_setNetworkName("eth_rinkeby");
344             return true;
345         }
346         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
347             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
348             return true;
349         }
350         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
351             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
352             return true;
353         }
354         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
355             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
356             return true;
357         }
358         return false;
359     }
360 
361     function __callback(bytes32 myid, string result) public {
362         __callback(myid, result, new bytes(0));
363     }
364     function __callback(bytes32 myid, string result, bytes proof) public {
365       return;
366       // Following should never be reached with a preceding return, however
367       // this is just a placeholder function, ideally meant to be defined in
368       // child contract when proofs are used
369       myid; result; proof; // Silence compiler warnings
370       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
371     }
372 
373     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
374         return oraclize.getPrice(datasource);
375     }
376 
377     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
378         return oraclize.getPrice(datasource, gaslimit);
379     }
380 
381     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource);
383         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
384         return oraclize.query.value(price)(0, datasource, arg);
385     }
386     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource);
388         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
389         return oraclize.query.value(price)(timestamp, datasource, arg);
390     }
391     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource, gaslimit);
393         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
394         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
395     }
396     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource, gaslimit);
398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
399         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
400     }
401     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource);
403         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
404         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
405     }
406     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource);
408         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
409         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
410     }
411     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource, gaslimit);
413         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
414         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
415     }
416     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource, gaslimit);
418         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
419         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
420     }
421     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource);
423         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
424         bytes memory args = stra2cbor(argN);
425         return oraclize.queryN.value(price)(0, datasource, args);
426     }
427     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
428         uint price = oraclize.getPrice(datasource);
429         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
430         bytes memory args = stra2cbor(argN);
431         return oraclize.queryN.value(price)(timestamp, datasource, args);
432     }
433     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
434         uint price = oraclize.getPrice(datasource, gaslimit);
435         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
436         bytes memory args = stra2cbor(argN);
437         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
438     }
439     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
440         uint price = oraclize.getPrice(datasource, gaslimit);
441         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
442         bytes memory args = stra2cbor(argN);
443         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
444     }
445     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(timestamp, datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](1);
457         dynargs[0] = args[0];
458         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
459     }
460     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         string[] memory dynargs = new string[](1);
462         dynargs[0] = args[0];
463         return oraclize_query(datasource, dynargs, gaslimit);
464     }
465 
466     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
467         string[] memory dynargs = new string[](2);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         return oraclize_query(datasource, dynargs);
471     }
472     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](2);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         return oraclize_query(timestamp, datasource, dynargs);
477     }
478     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](2);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
483     }
484     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](2);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         return oraclize_query(datasource, dynargs, gaslimit);
489     }
490     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](3);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         return oraclize_query(datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](3);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         return oraclize_query(timestamp, datasource, dynargs);
503     }
504     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         string[] memory dynargs = new string[](3);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
510     }
511     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](3);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         dynargs[2] = args[2];
516         return oraclize_query(datasource, dynargs, gaslimit);
517     }
518 
519     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
520         string[] memory dynargs = new string[](4);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         dynargs[3] = args[3];
525         return oraclize_query(datasource, dynargs);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](4);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         dynargs[3] = args[3];
533         return oraclize_query(timestamp, datasource, dynargs);
534     }
535     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
536         string[] memory dynargs = new string[](4);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
542     }
543     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](4);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         return oraclize_query(datasource, dynargs, gaslimit);
550     }
551     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](5);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         dynargs[3] = args[3];
557         dynargs[4] = args[4];
558         return oraclize_query(datasource, dynargs);
559     }
560     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](5);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         dynargs[4] = args[4];
567         return oraclize_query(timestamp, datasource, dynargs);
568     }
569     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
570         string[] memory dynargs = new string[](5);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         dynargs[4] = args[4];
576         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
577     }
578     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](5);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         dynargs[2] = args[2];
583         dynargs[3] = args[3];
584         dynargs[4] = args[4];
585         return oraclize_query(datasource, dynargs, gaslimit);
586     }
587     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
588         uint price = oraclize.getPrice(datasource);
589         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
590         bytes memory args = ba2cbor(argN);
591         return oraclize.queryN.value(price)(0, datasource, args);
592     }
593     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
594         uint price = oraclize.getPrice(datasource);
595         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
596         bytes memory args = ba2cbor(argN);
597         return oraclize.queryN.value(price)(timestamp, datasource, args);
598     }
599     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
600         uint price = oraclize.getPrice(datasource, gaslimit);
601         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
602         bytes memory args = ba2cbor(argN);
603         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
604     }
605     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
606         uint price = oraclize.getPrice(datasource, gaslimit);
607         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
608         bytes memory args = ba2cbor(argN);
609         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
610     }
611     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](1);
613         dynargs[0] = args[0];
614         return oraclize_query(datasource, dynargs);
615     }
616     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](1);
618         dynargs[0] = args[0];
619         return oraclize_query(timestamp, datasource, dynargs);
620     }
621     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](1);
623         dynargs[0] = args[0];
624         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
625     }
626     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
627         bytes[] memory dynargs = new bytes[](1);
628         dynargs[0] = args[0];
629         return oraclize_query(datasource, dynargs, gaslimit);
630     }
631 
632     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
633         bytes[] memory dynargs = new bytes[](2);
634         dynargs[0] = args[0];
635         dynargs[1] = args[1];
636         return oraclize_query(datasource, dynargs);
637     }
638     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
639         bytes[] memory dynargs = new bytes[](2);
640         dynargs[0] = args[0];
641         dynargs[1] = args[1];
642         return oraclize_query(timestamp, datasource, dynargs);
643     }
644     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
645         bytes[] memory dynargs = new bytes[](2);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
649     }
650     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](2);
652         dynargs[0] = args[0];
653         dynargs[1] = args[1];
654         return oraclize_query(datasource, dynargs, gaslimit);
655     }
656     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](3);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         return oraclize_query(datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](3);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         return oraclize_query(timestamp, datasource, dynargs);
669     }
670     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
671         bytes[] memory dynargs = new bytes[](3);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         dynargs[2] = args[2];
675         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
676     }
677     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](3);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         dynargs[2] = args[2];
682         return oraclize_query(datasource, dynargs, gaslimit);
683     }
684 
685     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
686         bytes[] memory dynargs = new bytes[](4);
687         dynargs[0] = args[0];
688         dynargs[1] = args[1];
689         dynargs[2] = args[2];
690         dynargs[3] = args[3];
691         return oraclize_query(datasource, dynargs);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](4);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         dynargs[3] = args[3];
699         return oraclize_query(timestamp, datasource, dynargs);
700     }
701     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
702         bytes[] memory dynargs = new bytes[](4);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         dynargs[3] = args[3];
707         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
708     }
709     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](4);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         dynargs[3] = args[3];
715         return oraclize_query(datasource, dynargs, gaslimit);
716     }
717     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](5);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         dynargs[3] = args[3];
723         dynargs[4] = args[4];
724         return oraclize_query(datasource, dynargs);
725     }
726     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](5);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         dynargs[4] = args[4];
733         return oraclize_query(timestamp, datasource, dynargs);
734     }
735     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](5);
737         dynargs[0] = args[0];
738         dynargs[1] = args[1];
739         dynargs[2] = args[2];
740         dynargs[3] = args[3];
741         dynargs[4] = args[4];
742         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
743     }
744     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](5);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         dynargs[2] = args[2];
749         dynargs[3] = args[3];
750         dynargs[4] = args[4];
751         return oraclize_query(datasource, dynargs, gaslimit);
752     }
753 
754     function oraclize_cbAddress() oraclizeAPI internal returns (address){
755         return oraclize.cbAddress();
756     }
757     function oraclize_setProof(byte proofP) oraclizeAPI internal {
758         return oraclize.setProofType(proofP);
759     }
760     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
761         return oraclize.setCustomGasPrice(gasPrice);
762     }
763 
764     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
765         return oraclize.randomDS_getSessionPubKeyHash();
766     }
767 
768     function getCodeSize(address _addr) view internal returns(uint _size) {
769         assembly {
770             _size := extcodesize(_addr)
771         }
772     }
773 
774     function parseAddr(string _a) internal pure returns (address){
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
794     function strCompare(string _a, string _b) internal pure returns (int) {
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
812     function indexOf(string _haystack, string _needle) internal pure returns (int) {
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
839     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
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
856     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
857         return strConcat(_a, _b, _c, _d, "");
858     }
859 
860     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
861         return strConcat(_a, _b, _c, "", "");
862     }
863 
864     function strConcat(string _a, string _b) internal pure returns (string) {
865         return strConcat(_a, _b, "", "", "");
866     }
867 
868     // parseInt
869     function parseInt(string _a) internal pure returns (uint) {
870         return parseInt(_a, 0);
871     }
872 
873     // parseInt(parseFloat*10^_b)
874     function parseInt(string _a, uint _b) internal pure returns (uint) {
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
892     function uint2str(uint i) internal pure returns (string){
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
910     function stra2cbor(string[] arr) internal pure returns (bytes) {
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
922     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
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
939     function oraclize_getNetworkName() internal view returns (string) {
940         return oraclize_network_name;
941     }
942 
943     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
944         require((_nbytes > 0) && (_nbytes <= 32));
945         // Convert from seconds to ledger timer ticks
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
987         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
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
1019         if (address(keccak256(pubkey)) == signer) return true;
1020         else {
1021             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1022             return (address(keccak256(pubkey)) == signer);
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
1037         tosign2[0] = byte(1); //role
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
1063         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1064 
1065         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1066         require(proofVerified);
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
1081     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1082         bool match_ = true;
1083 
1084         require(prefix.length == n_random_bytes);
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
1099         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1100 
1101         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1102         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1103 
1104         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1105         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1106 
1107         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1108         // This is to verify that the computed args match with the ones specified in the query.
1109         bytes memory commitmentSlice1 = new bytes(8+1+32);
1110         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1111 
1112         bytes memory sessionPubkey = new bytes(64);
1113         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1114         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1115 
1116         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1117         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
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
1135     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1136     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1137         uint minLength = length + toOffset;
1138 
1139         // Buffer too small
1140         require(to.length >= minLength); // Should be a better way?
1141 
1142         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1143         uint i = 32 + fromOffset;
1144         uint j = 32 + toOffset;
1145 
1146         while (i < (32 + fromOffset + length)) {
1147             assembly {
1148                 let tmp := mload(add(from, i))
1149                 mstore(add(to, j), tmp)
1150             }
1151             i += 32;
1152             j += 32;
1153         }
1154 
1155         return to;
1156     }
1157 
1158     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1159     // Duplicate Solidity's ecrecover, but catching the CALL return value
1160     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1161         // We do our own memory management here. Solidity uses memory offset
1162         // 0x40 to store the current end of memory. We write past it (as
1163         // writes are memory extensions), but don't update the offset so
1164         // Solidity will reuse it. The memory used here is only needed for
1165         // this context.
1166 
1167         // FIXME: inline assembly can't access return values
1168         bool ret;
1169         address addr;
1170 
1171         assembly {
1172             let size := mload(0x40)
1173             mstore(size, hash)
1174             mstore(add(size, 32), v)
1175             mstore(add(size, 64), r)
1176             mstore(add(size, 96), s)
1177 
1178             // NOTE: we can reuse the request memory because we deal with
1179             //       the return code
1180             ret := call(3000, 1, 0, size, 128, size, 32)
1181             addr := mload(size)
1182         }
1183 
1184         return (ret, addr);
1185     }
1186 
1187     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1188     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1189         bytes32 r;
1190         bytes32 s;
1191         uint8 v;
1192 
1193         if (sig.length != 65)
1194           return (false, 0);
1195 
1196         // The signature format is a compact form of:
1197         //   {bytes32 r}{bytes32 s}{uint8 v}
1198         // Compact means, uint8 is not padded to 32 bytes.
1199         assembly {
1200             r := mload(add(sig, 32))
1201             s := mload(add(sig, 64))
1202 
1203             // Here we are loading the last 32 bytes. We exploit the fact that
1204             // 'mload' will pad with zeroes if we overread.
1205             // There is no 'mload8' to do this, but that would be nicer.
1206             v := byte(0, mload(add(sig, 96)))
1207 
1208             // Alternative solution:
1209             // 'byte' is not working due to the Solidity parser, so lets
1210             // use the second best option, 'and'
1211             // v := and(mload(add(sig, 65)), 255)
1212         }
1213 
1214         // albeit non-transactional signatures are not specified by the YP, one would expect it
1215         // to match the YP range of [27, 28]
1216         //
1217         // geth uses [0, 1] and some clients have followed. This might change, see:
1218         //  https://github.com/ethereum/go-ethereum/issues/2053
1219         if (v < 27)
1220           v += 27;
1221 
1222         if (v != 27 && v != 28)
1223             return (false, 0);
1224 
1225         return safer_ecrecover(hash, v, r, s);
1226     }
1227 
1228     function safeMemoryCleaner() internal pure {
1229         assembly {
1230             let fmem := mload(0x40)
1231             codecopy(fmem, codesize, sub(msize, fmem))
1232         }
1233     }
1234 
1235 }
1236 // </ORACLIZE_API>
1237 
1238 
1239 contract DrawTicket is usingOraclize {
1240     
1241     address public owner;
1242 
1243     //uint public lastRandomNumber;
1244     uint private _fromTicket;
1245     uint private _toTicket;
1246     string private _potName;
1247     
1248     // struct DrawingResult
1249     // {
1250     //     uint fromTicket;
1251     //     uint toTicket;
1252     //     uint winningTicket;
1253     // }
1254     
1255     // mapping (string => DrawingResult) drawingResults;
1256     
1257     event newRandomNumber_bytes(bytes number);
1258     event newRandomNumber_uint(uint number);
1259     event LogNewOraclizeQuery(string description);
1260     event LogResults(string potName, uint fromTicket, uint toTicket, uint winningTicket);
1261 
1262     function DrawTicket() {
1263         owner = msg.sender;
1264         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1265         //update(); // let's ask for N random bytes immediately when the contract is created!
1266     }
1267     
1268     // the callback function is called by Oraclize when the result is ready
1269     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1270     // the proof validity is fully verified on-chain
1271     function __callback(bytes32 _queryId, string _result, bytes _proof)
1272     { 
1273         if (msg.sender != oraclize_cbAddress()) throw;
1274         
1275         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1276             // the proof verification has failed, do we need to take any action here? (depends on the use case)
1277         } else {
1278             // the proof verification has passed
1279             // now that we know that the random number was safely generated, let's use it..
1280             
1281             uint maxRange = (_toTicket - _fromTicket) + 1;
1282             uint winningTicket = _fromTicket + uint(sha3(_result)) % maxRange;
1283 
1284             LogResults(_potName, _fromTicket, _toTicket, winningTicket);
1285         }
1286     }
1287 
1288     
1289     function getWinningTicket(string potName, uint fromTicket, uint toTicket, uint gasPrice, uint gasLimit) payable {
1290         require(msg.sender == owner);
1291 
1292         _fromTicket = fromTicket;
1293         _toTicket = toTicket;
1294         _potName = potName;
1295 
1296         if (oraclize_getPrice("Random") > this.balance) {
1297            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1298         } else {
1299             LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1300         }
1301 
1302         uint N = 7;
1303         uint delay = 0; // number of seconds to wait before the execution takes place
1304         uint callbackGas = gasLimit; // amount of gas we want Oraclize to set for the callback function
1305         oraclize_setCustomGasPrice(gasPrice);
1306         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
1307     }
1308 
1309     function storeETH() payable public {}
1310 
1311     function withdrawETH() {
1312         require(msg.sender == owner);
1313         owner.send(this.balance);
1314     }
1315     
1316 }