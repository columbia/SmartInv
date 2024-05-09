1 pragma solidity ^0.4.11;
2 // <ORACLIZE_API>
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 The above copyright notice and this permission notice shall be included in
13 all copies or substantial portions of the Software.
14 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
17 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
18 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
20 THE SOFTWARE.
21 */
22 
23 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
24 
25 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
26 
27 contract OraclizeI {
28     address public cbAddress;
29     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
30     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
31     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
32     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
33     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
34     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
35     function getPrice(string _datasource) public returns (uint _dsprice);
36     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
37     function setProofType(byte _proofType) external;
38     function setCustomGasPrice(uint _gasPrice) external;
39     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
40 }
41 
42 contract OraclizeAddrResolverI {
43     function getAddress() public returns (address _addr);
44 }
45 
46 /*
47 Begin solidity-cborutils
48 https://github.com/smartcontractkit/solidity-cborutils
49 MIT License
50 Copyright (c) 2018 SmartContract ChainLink, Ltd.
51 Permission is hereby granted, free of charge, to any person obtaining a copy
52 of this software and associated documentation files (the "Software"), to deal
53 in the Software without restriction, including without limitation the rights
54 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
55 copies of the Software, and to permit persons to whom the Software is
56 furnished to do so, subject to the following conditions:
57 The above copyright notice and this permission notice shall be included in all
58 copies or substantial portions of the Software.
59 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
60 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
61 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
62 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
63 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
64 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
65 SOFTWARE.
66  */
67 
68 library Buffer {
69     struct buffer {
70         bytes buf;
71         uint capacity;
72     }
73 
74     function init(buffer memory buf, uint _capacity) internal pure {
75         uint capacity = _capacity;
76         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
77         // Allocate space for the buffer data
78         buf.capacity = capacity;
79         assembly {
80             let ptr := mload(0x40)
81             mstore(buf, ptr)
82             mstore(ptr, 0)
83             mstore(0x40, add(ptr, capacity))
84         }
85     }
86 
87     function resize(buffer memory buf, uint capacity) private pure {
88         bytes memory oldbuf = buf.buf;
89         init(buf, capacity);
90         append(buf, oldbuf);
91     }
92 
93     function max(uint a, uint b) private pure returns(uint) {
94         if(a > b) {
95             return a;
96         }
97         return b;
98     }
99 
100     /**
101      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
102      *      would exceed the capacity of the buffer.
103      * @param buf The buffer to append to.
104      * @param data The data to append.
105      * @return The original buffer.
106      */
107     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
108         if(data.length + buf.buf.length > buf.capacity) {
109             resize(buf, max(buf.capacity, data.length) * 2);
110         }
111 
112         uint dest;
113         uint src;
114         uint len = data.length;
115         assembly {
116             // Memory address of the buffer data
117             let bufptr := mload(buf)
118             // Length of existing buffer data
119             let buflen := mload(bufptr)
120             // Start address = buffer address + buffer length + sizeof(buffer length)
121             dest := add(add(bufptr, buflen), 32)
122             // Update buffer length
123             mstore(bufptr, add(buflen, mload(data)))
124             src := add(data, 32)
125         }
126 
127         // Copy word-length chunks while possible
128         for(; len >= 32; len -= 32) {
129             assembly {
130                 mstore(dest, mload(src))
131             }
132             dest += 32;
133             src += 32;
134         }
135 
136         // Copy remaining bytes
137         uint mask = 256 ** (32 - len) - 1;
138         assembly {
139             let srcpart := and(mload(src), not(mask))
140             let destpart := and(mload(dest), mask)
141             mstore(dest, or(destpart, srcpart))
142         }
143 
144         return buf;
145     }
146 
147     /**
148      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
149      * exceed the capacity of the buffer.
150      * @param buf The buffer to append to.
151      * @param data The data to append.
152      * @return The original buffer.
153      */
154     function append(buffer memory buf, uint8 data) internal pure {
155         if(buf.buf.length + 1 > buf.capacity) {
156             resize(buf, buf.capacity * 2);
157         }
158 
159         assembly {
160             // Memory address of the buffer data
161             let bufptr := mload(buf)
162             // Length of existing buffer data
163             let buflen := mload(bufptr)
164             // Address = buffer address + buffer length + sizeof(buffer length)
165             let dest := add(add(bufptr, buflen), 32)
166             mstore8(dest, data)
167             // Update buffer length
168             mstore(bufptr, add(buflen, 1))
169         }
170     }
171 
172     /**
173      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
174      * exceed the capacity of the buffer.
175      * @param buf The buffer to append to.
176      * @param data The data to append.
177      * @return The original buffer.
178      */
179     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
180         if(len + buf.buf.length > buf.capacity) {
181             resize(buf, max(buf.capacity, len) * 2);
182         }
183 
184         uint mask = 256 ** len - 1;
185         assembly {
186             // Memory address of the buffer data
187             let bufptr := mload(buf)
188             // Length of existing buffer data
189             let buflen := mload(bufptr)
190             // Address = buffer address + buffer length + sizeof(buffer length) + len
191             let dest := add(add(bufptr, buflen), len)
192             mstore(dest, or(and(mload(dest), not(mask)), data))
193             // Update buffer length
194             mstore(bufptr, add(buflen, len))
195         }
196         return buf;
197     }
198 }
199 
200 library CBOR {
201     using Buffer for Buffer.buffer;
202 
203     uint8 private constant MAJOR_TYPE_INT = 0;
204     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
205     uint8 private constant MAJOR_TYPE_BYTES = 2;
206     uint8 private constant MAJOR_TYPE_STRING = 3;
207     uint8 private constant MAJOR_TYPE_ARRAY = 4;
208     uint8 private constant MAJOR_TYPE_MAP = 5;
209     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
210 
211     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
212         if(value <= 23) {
213             buf.append(uint8((major << 5) | value));
214         } else if(value <= 0xFF) {
215             buf.append(uint8((major << 5) | 24));
216             buf.appendInt(value, 1);
217         } else if(value <= 0xFFFF) {
218             buf.append(uint8((major << 5) | 25));
219             buf.appendInt(value, 2);
220         } else if(value <= 0xFFFFFFFF) {
221             buf.append(uint8((major << 5) | 26));
222             buf.appendInt(value, 4);
223         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
224             buf.append(uint8((major << 5) | 27));
225             buf.appendInt(value, 8);
226         }
227     }
228 
229     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
230         buf.append(uint8((major << 5) | 31));
231     }
232 
233     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
234         encodeType(buf, MAJOR_TYPE_INT, value);
235     }
236 
237     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
238         if(value >= 0) {
239             encodeType(buf, MAJOR_TYPE_INT, uint(value));
240         } else {
241             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
242         }
243     }
244 
245     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
246         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
247         buf.append(value);
248     }
249 
250     function encodeString(Buffer.buffer memory buf, string value) internal pure {
251         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
252         buf.append(bytes(value));
253     }
254 
255     function startArray(Buffer.buffer memory buf) internal pure {
256         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
257     }
258 
259     function startMap(Buffer.buffer memory buf) internal pure {
260         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
261     }
262 
263     function endSequence(Buffer.buffer memory buf) internal pure {
264         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
265     }
266 }
267 
268 /*
269 End solidity-cborutils
270  */
271 
272 contract usingOraclize {
273     uint constant day = 60*60*24;
274     uint constant week = 60*60*24*7;
275     uint constant month = 60*60*24*30;
276     byte constant proofType_NONE = 0x00;
277     byte constant proofType_TLSNotary = 0x10;
278     byte constant proofType_Ledger = 0x30;
279     byte constant proofType_Android = 0x40;
280     byte constant proofType_Native = 0xF0;
281     byte constant proofStorage_IPFS = 0x01;
282     uint8 constant networkID_auto = 0;
283     uint8 constant networkID_mainnet = 1;
284     uint8 constant networkID_testnet = 2;
285     uint8 constant networkID_morden = 2;
286     uint8 constant networkID_consensys = 161;
287 
288     OraclizeAddrResolverI OAR;
289 
290     OraclizeI oraclize;
291     modifier oraclizeAPI {
292         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
293             oraclize_setNetwork(networkID_auto);
294 
295         if(address(oraclize) != OAR.getAddress())
296             oraclize = OraclizeI(OAR.getAddress());
297 
298         _;
299     }
300     modifier coupon(string code){
301         oraclize = OraclizeI(OAR.getAddress());
302         _;
303     }
304 
305     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
306       return oraclize_setNetwork();
307       networkID; // silence the warning and remain backwards compatible
308     }
309     function oraclize_setNetwork() internal returns(bool){
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
345     function __callback(bytes32 myid, string result) public {
346         __callback(myid, result, new bytes(0));
347     }
348     function __callback(bytes32 myid, string result, bytes proof) public {
349       return;
350       myid; result; proof; // Silence compiler warnings
351     }
352 
353     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
354         return oraclize.getPrice(datasource);
355     }
356 
357     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
358         return oraclize.getPrice(datasource, gaslimit);
359     }
360 
361     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource);
363         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
364         return oraclize.query.value(price)(0, datasource, arg);
365     }
366     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource);
368         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
369         return oraclize.query.value(price)(timestamp, datasource, arg);
370     }
371     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
372         uint price = oraclize.getPrice(datasource, gaslimit);
373         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
374         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
375     }
376     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
380     }
381     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource);
383         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
384         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
385     }
386     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource);
388         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
389         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
390     }
391     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource, gaslimit);
393         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
394         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
395     }
396     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource, gaslimit);
398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
399         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
400     }
401     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource);
403         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
404         bytes memory args = stra2cbor(argN);
405         return oraclize.queryN.value(price)(0, datasource, args);
406     }
407     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource);
409         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410         bytes memory args = stra2cbor(argN);
411         return oraclize.queryN.value(price)(timestamp, datasource, args);
412     }
413     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource, gaslimit);
415         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
416         bytes memory args = stra2cbor(argN);
417         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
418     }
419     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource, gaslimit);
421         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
422         bytes memory args = stra2cbor(argN);
423         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
424     }
425     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
426         string[] memory dynargs = new string[](1);
427         dynargs[0] = args[0];
428         return oraclize_query(datasource, dynargs);
429     }
430     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
431         string[] memory dynargs = new string[](1);
432         dynargs[0] = args[0];
433         return oraclize_query(timestamp, datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
436         string[] memory dynargs = new string[](1);
437         dynargs[0] = args[0];
438         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
439     }
440     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(datasource, dynargs, gaslimit);
444     }
445 
446     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](2);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         return oraclize_query(timestamp, datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](2);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
463     }
464     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](3);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         return oraclize_query(datasource, dynargs);
476     }
477     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
478         string[] memory dynargs = new string[](3);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         dynargs[2] = args[2];
482         return oraclize_query(timestamp, datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](3);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
490     }
491     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         string[] memory dynargs = new string[](3);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         return oraclize_query(datasource, dynargs, gaslimit);
497     }
498 
499     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](4);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         dynargs[3] = args[3];
505         return oraclize_query(datasource, dynargs);
506     }
507     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
508         string[] memory dynargs = new string[](4);
509         dynargs[0] = args[0];
510         dynargs[1] = args[1];
511         dynargs[2] = args[2];
512         dynargs[3] = args[3];
513         return oraclize_query(timestamp, datasource, dynargs);
514     }
515     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](4);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         dynargs[3] = args[3];
521         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
522     }
523     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
524         string[] memory dynargs = new string[](4);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         dynargs[2] = args[2];
528         dynargs[3] = args[3];
529         return oraclize_query(datasource, dynargs, gaslimit);
530     }
531     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
532         string[] memory dynargs = new string[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(timestamp, datasource, dynargs);
548     }
549     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
550         string[] memory dynargs = new string[](5);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         dynargs[4] = args[4];
556         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
557     }
558     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](5);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         dynargs[4] = args[4];
565         return oraclize_query(datasource, dynargs, gaslimit);
566     }
567     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
568         uint price = oraclize.getPrice(datasource);
569         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
570         bytes memory args = ba2cbor(argN);
571         return oraclize.queryN.value(price)(0, datasource, args);
572     }
573     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
574         uint price = oraclize.getPrice(datasource);
575         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
576         bytes memory args = ba2cbor(argN);
577         return oraclize.queryN.value(price)(timestamp, datasource, args);
578     }
579     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
580         uint price = oraclize.getPrice(datasource, gaslimit);
581         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
582         bytes memory args = ba2cbor(argN);
583         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
584     }
585     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
586         uint price = oraclize.getPrice(datasource, gaslimit);
587         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
588         bytes memory args = ba2cbor(argN);
589         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
590     }
591     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
592         bytes[] memory dynargs = new bytes[](1);
593         dynargs[0] = args[0];
594         return oraclize_query(datasource, dynargs);
595     }
596     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
597         bytes[] memory dynargs = new bytes[](1);
598         dynargs[0] = args[0];
599         return oraclize_query(timestamp, datasource, dynargs);
600     }
601     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
602         bytes[] memory dynargs = new bytes[](1);
603         dynargs[0] = args[0];
604         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
605     }
606     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](1);
608         dynargs[0] = args[0];
609         return oraclize_query(datasource, dynargs, gaslimit);
610     }
611 
612     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](2);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         return oraclize_query(datasource, dynargs);
617     }
618     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](2);
620         dynargs[0] = args[0];
621         dynargs[1] = args[1];
622         return oraclize_query(timestamp, datasource, dynargs);
623     }
624     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](2);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
629     }
630     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](2);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         return oraclize_query(datasource, dynargs, gaslimit);
635     }
636     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](3);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         dynargs[2] = args[2];
641         return oraclize_query(datasource, dynargs);
642     }
643     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
644         bytes[] memory dynargs = new bytes[](3);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         dynargs[2] = args[2];
648         return oraclize_query(timestamp, datasource, dynargs);
649     }
650     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](3);
652         dynargs[0] = args[0];
653         dynargs[1] = args[1];
654         dynargs[2] = args[2];
655         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
656     }
657     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
658         bytes[] memory dynargs = new bytes[](3);
659         dynargs[0] = args[0];
660         dynargs[1] = args[1];
661         dynargs[2] = args[2];
662         return oraclize_query(datasource, dynargs, gaslimit);
663     }
664 
665     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](4);
667         dynargs[0] = args[0];
668         dynargs[1] = args[1];
669         dynargs[2] = args[2];
670         dynargs[3] = args[3];
671         return oraclize_query(datasource, dynargs);
672     }
673     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
674         bytes[] memory dynargs = new bytes[](4);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         dynargs[3] = args[3];
679         return oraclize_query(timestamp, datasource, dynargs);
680     }
681     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](4);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         dynargs[3] = args[3];
687         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
688     }
689     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
690         bytes[] memory dynargs = new bytes[](4);
691         dynargs[0] = args[0];
692         dynargs[1] = args[1];
693         dynargs[2] = args[2];
694         dynargs[3] = args[3];
695         return oraclize_query(datasource, dynargs, gaslimit);
696     }
697     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
698         bytes[] memory dynargs = new bytes[](5);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         dynargs[2] = args[2];
702         dynargs[3] = args[3];
703         dynargs[4] = args[4];
704         return oraclize_query(datasource, dynargs);
705     }
706     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](5);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         dynargs[4] = args[4];
713         return oraclize_query(timestamp, datasource, dynargs);
714     }
715     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
716         bytes[] memory dynargs = new bytes[](5);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         dynargs[4] = args[4];
722         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
723     }
724     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](5);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         dynargs[3] = args[3];
730         dynargs[4] = args[4];
731         return oraclize_query(datasource, dynargs, gaslimit);
732     }
733 
734     function oraclize_cbAddress() oraclizeAPI internal returns (address){
735         return oraclize.cbAddress();
736     }
737     function oraclize_setProof(byte proofP) oraclizeAPI internal {
738         return oraclize.setProofType(proofP);
739     }
740     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
741         return oraclize.setCustomGasPrice(gasPrice);
742     }
743 
744     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
745         return oraclize.randomDS_getSessionPubKeyHash();
746     }
747 
748     function getCodeSize(address _addr) constant internal returns(uint _size) {
749         assembly {
750             _size := extcodesize(_addr)
751         }
752     }
753 
754     function parseAddr(string _a) internal pure returns (address){
755         bytes memory tmp = bytes(_a);
756         uint160 iaddr = 0;
757         uint160 b1;
758         uint160 b2;
759         for (uint i=2; i<2+2*20; i+=2){
760             iaddr *= 256;
761             b1 = uint160(tmp[i]);
762             b2 = uint160(tmp[i+1]);
763             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
764             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
765             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
766             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
767             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
768             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
769             iaddr += (b1*16+b2);
770         }
771         return address(iaddr);
772     }
773 
774     function strCompare(string _a, string _b) internal pure returns (int) {
775         bytes memory a = bytes(_a);
776         bytes memory b = bytes(_b);
777         uint minLength = a.length;
778         if (b.length < minLength) minLength = b.length;
779         for (uint i = 0; i < minLength; i ++)
780             if (a[i] < b[i])
781                 return -1;
782             else if (a[i] > b[i])
783                 return 1;
784         if (a.length < b.length)
785             return -1;
786         else if (a.length > b.length)
787             return 1;
788         else
789             return 0;
790     }
791 
792     function indexOf(string _haystack, string _needle) internal pure returns (int) {
793         bytes memory h = bytes(_haystack);
794         bytes memory n = bytes(_needle);
795         if(h.length < 1 || n.length < 1 || (n.length > h.length))
796             return -1;
797         else if(h.length > (2**128 -1))
798             return -1;
799         else
800         {
801             uint subindex = 0;
802             for (uint i = 0; i < h.length; i ++)
803             {
804                 if (h[i] == n[0])
805                 {
806                     subindex = 1;
807                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
808                     {
809                         subindex++;
810                     }
811                     if(subindex == n.length)
812                         return int(i);
813                 }
814             }
815             return -1;
816         }
817     }
818 
819     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
820         bytes memory _ba = bytes(_a);
821         bytes memory _bb = bytes(_b);
822         bytes memory _bc = bytes(_c);
823         bytes memory _bd = bytes(_d);
824         bytes memory _be = bytes(_e);
825         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
826         bytes memory babcde = bytes(abcde);
827         uint k = 0;
828         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
829         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
830         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
831         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
832         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
833         return string(babcde);
834     }
835 
836     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
837         return strConcat(_a, _b, _c, _d, "");
838     }
839 
840     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
841         return strConcat(_a, _b, _c, "", "");
842     }
843 
844     function strConcat(string _a, string _b) internal pure returns (string) {
845         return strConcat(_a, _b, "", "", "");
846     }
847 
848     // parseInt
849     function parseInt(string _a) internal pure returns (uint) {
850         return parseInt(_a, 0);
851     }
852 
853     // parseInt(parseFloat*10^_b)
854     function parseInt(string _a, uint _b) internal pure returns (uint) {
855         bytes memory bresult = bytes(_a);
856         uint mint = 0;
857         bool decimals = false;
858         for (uint i=0; i<bresult.length; i++){
859             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
860                 if (decimals){
861                    if (_b == 0) break;
862                     else _b--;
863                 }
864                 mint *= 10;
865                 mint += uint(bresult[i]) - 48;
866             } else if (bresult[i] == 46) decimals = true;
867         }
868         if (_b > 0) mint *= 10**_b;
869         return mint;
870     }
871 
872     function uint2str(uint i) internal pure returns (string){
873         if (i == 0) return "0";
874         uint j = i;
875         uint len;
876         while (j != 0){
877             len++;
878             j /= 10;
879         }
880         bytes memory bstr = new bytes(len);
881         uint k = len - 1;
882         while (i != 0){
883             bstr[k--] = byte(48 + i % 10);
884             i /= 10;
885         }
886         return string(bstr);
887     }
888 
889     using CBOR for Buffer.buffer;
890     function stra2cbor(string[] arr) internal pure returns (bytes) {
891         safeMemoryCleaner();
892         Buffer.buffer memory buf;
893         Buffer.init(buf, 1024);
894         buf.startArray();
895         for (uint i = 0; i < arr.length; i++) {
896             buf.encodeString(arr[i]);
897         }
898         buf.endSequence();
899         return buf.buf;
900     }
901 
902     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
903         safeMemoryCleaner();
904         Buffer.buffer memory buf;
905         Buffer.init(buf, 1024);
906         buf.startArray();
907         for (uint i = 0; i < arr.length; i++) {
908             buf.encodeBytes(arr[i]);
909         }
910         buf.endSequence();
911         return buf.buf;
912     }
913 
914     string oraclize_network_name;
915     function oraclize_setNetworkName(string _network_name) internal {
916         oraclize_network_name = _network_name;
917     }
918 
919     function oraclize_getNetworkName() internal view returns (string) {
920         return oraclize_network_name;
921     }
922 
923     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
924         require((_nbytes > 0) && (_nbytes <= 32));
925         // Convert from seconds to ledger timer ticks
926         _delay *= 10;
927         bytes memory nbytes = new bytes(1);
928         nbytes[0] = byte(_nbytes);
929         bytes memory unonce = new bytes(32);
930         bytes memory sessionKeyHash = new bytes(32);
931         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
932         assembly {
933             mstore(unonce, 0x20)
934             // the following variables can be relaxed
935             // check relaxed random contract under ethereum-examples repo
936             // for an idea on how to override and replace comit hash vars
937             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
938             mstore(sessionKeyHash, 0x20)
939             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
940         }
941         bytes memory delay = new bytes(32);
942         assembly {
943             mstore(add(delay, 0x20), _delay)
944         }
945 
946         bytes memory delay_bytes8 = new bytes(8);
947         copyBytes(delay, 24, 8, delay_bytes8, 0);
948 
949         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
950         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
951 
952         bytes memory delay_bytes8_left = new bytes(8);
953 
954         assembly {
955             let x := mload(add(delay_bytes8, 0x20))
956             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
957             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
958             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
959             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
960             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
961             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
962             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
964 
965         }
966 
967         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
968         return queryId;
969     }
970 
971     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
972         oraclize_randomDS_args[queryId] = commitment;
973     }
974 
975     mapping(bytes32=>bytes32) oraclize_randomDS_args;
976     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
977 
978     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
979         bool sigok;
980         address signer;
981 
982         bytes32 sigr;
983         bytes32 sigs;
984 
985         bytes memory sigr_ = new bytes(32);
986         uint offset = 4+(uint(dersig[3]) - 0x20);
987         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
988         bytes memory sigs_ = new bytes(32);
989         offset += 32 + 2;
990         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
991 
992         assembly {
993             sigr := mload(add(sigr_, 32))
994             sigs := mload(add(sigs_, 32))
995         }
996 
997 
998         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
999         if (address(keccak256(pubkey)) == signer) return true;
1000         else {
1001             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1002             return (address(keccak256(pubkey)) == signer);
1003         }
1004     }
1005 
1006     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1007         bool sigok;
1008 
1009         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1010         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1011         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1012 
1013         bytes memory appkey1_pubkey = new bytes(64);
1014         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1015 
1016         bytes memory tosign2 = new bytes(1+65+32);
1017         tosign2[0] = byte(1); //role
1018         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1019         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1020         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1021         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1022 
1023         if (sigok == false) return false;
1024 
1025 
1026         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1027         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1028 
1029         bytes memory tosign3 = new bytes(1+65);
1030         tosign3[0] = 0xFE;
1031         copyBytes(proof, 3, 65, tosign3, 1);
1032 
1033         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1034         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1035 
1036         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1037 
1038         return sigok;
1039     }
1040 
1041     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1042         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1043         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1044 
1045         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1046         require(proofVerified);
1047 
1048         _;
1049     }
1050 
1051     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1052         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1053         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1054 
1055         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1056         if (proofVerified == false) return 2;
1057 
1058         return 0;
1059     }
1060 
1061     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1062         bool match_ = true;
1063 
1064         require(prefix.length == n_random_bytes);
1065 
1066         for (uint256 i=0; i< n_random_bytes; i++) {
1067             if (content[i] != prefix[i]) match_ = false;
1068         }
1069 
1070         return match_;
1071     }
1072 
1073     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1074 
1075         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1076         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1077         bytes memory keyhash = new bytes(32);
1078         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1079         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1080 
1081         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1082         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1083 
1084         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1085         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1086 
1087         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1088         // This is to verify that the computed args match with the ones specified in the query.
1089         bytes memory commitmentSlice1 = new bytes(8+1+32);
1090         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1091 
1092         bytes memory sessionPubkey = new bytes(64);
1093         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1094         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1095 
1096         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1097         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1098             delete oraclize_randomDS_args[queryId];
1099         } else return false;
1100 
1101 
1102         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1103         bytes memory tosign1 = new bytes(32+8+1+32);
1104         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1105         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1106 
1107         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1108         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1109             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1110         }
1111 
1112         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1113     }
1114 
1115     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1116     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1117         uint minLength = length + toOffset;
1118 
1119         // Buffer too small
1120         require(to.length >= minLength); // Should be a better way?
1121 
1122         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1123         uint i = 32 + fromOffset;
1124         uint j = 32 + toOffset;
1125 
1126         while (i < (32 + fromOffset + length)) {
1127             assembly {
1128                 let tmp := mload(add(from, i))
1129                 mstore(add(to, j), tmp)
1130             }
1131             i += 32;
1132             j += 32;
1133         }
1134 
1135         return to;
1136     }
1137 
1138     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1139     // Duplicate Solidity's ecrecover, but catching the CALL return value
1140     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1141         // We do our own memory management here. Solidity uses memory offset
1142         // 0x40 to store the current end of memory. We write past it (as
1143         // writes are memory extensions), but don't update the offset so
1144         // Solidity will reuse it. The memory used here is only needed for
1145         // this context.
1146 
1147         // FIXME: inline assembly can't access return values
1148         bool ret;
1149         address addr;
1150 
1151         assembly {
1152             let size := mload(0x40)
1153             mstore(size, hash)
1154             mstore(add(size, 32), v)
1155             mstore(add(size, 64), r)
1156             mstore(add(size, 96), s)
1157 
1158             // NOTE: we can reuse the request memory because we deal with
1159             //       the return code
1160             ret := call(3000, 1, 0, size, 128, size, 32)
1161             addr := mload(size)
1162         }
1163 
1164         return (ret, addr);
1165     }
1166 
1167     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1168     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1169         bytes32 r;
1170         bytes32 s;
1171         uint8 v;
1172 
1173         if (sig.length != 65)
1174           return (false, 0);
1175 
1176         // The signature format is a compact form of:
1177         //   {bytes32 r}{bytes32 s}{uint8 v}
1178         // Compact means, uint8 is not padded to 32 bytes.
1179         assembly {
1180             r := mload(add(sig, 32))
1181             s := mload(add(sig, 64))
1182 
1183             // Here we are loading the last 32 bytes. We exploit the fact that
1184             // 'mload' will pad with zeroes if we overread.
1185             // There is no 'mload8' to do this, but that would be nicer.
1186             v := byte(0, mload(add(sig, 96)))
1187 
1188             // Alternative solution:
1189             // 'byte' is not working due to the Solidity parser, so lets
1190             // use the second best option, 'and'
1191             // v := and(mload(add(sig, 65)), 255)
1192         }
1193 
1194         // albeit non-transactional signatures are not specified by the YP, one would expect it
1195         // to match the YP range of [27, 28]
1196         //
1197         // geth uses [0, 1] and some clients have followed. This might change, see:
1198         //  https://github.com/ethereum/go-ethereum/issues/2053
1199         if (v < 27)
1200           v += 27;
1201 
1202         if (v != 27 && v != 28)
1203             return (false, 0);
1204 
1205         return safer_ecrecover(hash, v, r, s);
1206     }
1207 
1208     function safeMemoryCleaner() internal pure {
1209         assembly {
1210             let fmem := mload(0x40)
1211             codecopy(fmem, codesize, sub(msize, fmem))
1212         }
1213     }
1214 
1215 }
1216 // </ORACLIZE_API>
1217 
1218 /**
1219  * @title SafeMath
1220  * @dev Math operations with safety checks that throw on error
1221  */
1222 library SafeMath {
1223 
1224   /**
1225   * @dev Multiplies two numbers, throws on overflow.
1226   */
1227   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1228     if (a == 0) {
1229       return 0;
1230     }
1231     uint256 c = a * b;
1232     assert(c / a == b);
1233     return c;
1234   }
1235 
1236   /**
1237   * @dev Integer division of two numbers, truncating the quotient.
1238   */
1239   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1240     // assert(b > 0); // Solidity automatically throws when dividing by 0
1241     uint256 c = a / b;
1242     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1243     return c;
1244   }
1245 
1246   /**
1247   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1248   */
1249   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1250     assert(b <= a);
1251     return a - b;
1252   }
1253 
1254   /**
1255   * @dev Adds two numbers, throws on overflow.
1256   */
1257   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1258     uint256 c = a + b;
1259     assert(c >= a);
1260     return c;
1261   }
1262 }
1263 
1264 contract owned {
1265     address public owner;
1266 
1267     constructor()  public {
1268         owner = msg.sender;
1269     }
1270 
1271     modifier onlyOwner {
1272         require(msg.sender == owner);
1273         _;
1274     }
1275 
1276     function transferOwnership(address newOwner) onlyOwner  public {
1277         owner = newOwner;
1278     }
1279 }
1280 
1281 contract ETHEquals500USD is usingOraclize, owned {
1282 
1283     using SafeMath for uint;
1284     using SafeMath for uint256;
1285 
1286     bool public priceConfirmedOver500 = false;
1287     bool public checkPriceCalled = false;
1288     bool public winnerPaid = false;
1289     uint public totalGuesses = 0;
1290     uint public totalNominees = 0;
1291     uint public winningTimestamp;
1292     uint public oraclePrice = 0;
1293     uint public lowestDiff = now; // initiate variable with arbitrarily high value
1294     address public winner; // seven day nomination period to establish winner
1295     uint internal CONTRACT_CREATED;
1296     uint constant internal SECS_IN_ONE_WEEK = 604800;
1297     uint constant internal SECS_IN_TWO_WEEKS = 1209600;
1298     mapping (address => uint) public participantId;
1299     Participant[] public participants;
1300 
1301     event EtherReceived(uint amount, address addr);
1302     event SomebodyGuessed(address guesser, uint timestamp, uint guesses);
1303     event NewNomination(address nominee, uint timestamp, uint diff);
1304     event Feedback(string message);
1305     event OraclizeResult(string message, uint result, uint timestamp);
1306     event WinnerAnnounced(string message, address winner, uint diff);
1307 
1308     struct Participant {
1309         address participant;
1310         uint participantSince; // when user made guess
1311         uint guess; // UNIX timestamp of user's guess
1312         bool hasGuessed; // ensure user can't change guess as price approaches closer to 500
1313         uint diff; // diff between winning time and guessed time, assigned once ETH hits 500 USD
1314     }
1315 
1316     constructor() public payable {
1317         CONTRACT_CREATED = block.timestamp;
1318         makeGuess(1230940800); //see below
1319     }
1320 
1321     // participants make guess by providing UNIX timestamp when they believe ETH >= 500 USD, as determined by Kraken API
1322     function makeGuess(uint timestamp) public {
1323         require(now < CONTRACT_CREATED + SECS_IN_TWO_WEEKS && !priceConfirmedOver500); // establishes guessing period of 14 days following contract creation, no guessing if price hits 500 USD within this timeframe
1324         uint id = participantId[msg.sender];
1325 
1326         if (id == 0) {
1327             participantId[msg.sender] = participants.length;
1328             id = participants.length++;
1329         }
1330 
1331         // instantiate first guess with null address (which can't win) and timestamp of 20090103 (homage to bitcoin genesis)
1332         // contract owner needs to use a different address in order to participate
1333         if (msg.sender == owner){
1334             participants[id] = Participant({participant: 0, participantSince: now, guess: timestamp, hasGuessed: true, diff: now});
1335         } else {
1336             // prevent user from changing guess, something that would happen if price approaches 500 during the guessing period
1337             if (participants[id].hasGuessed != true){
1338                 participants[id] = Participant({participant: msg.sender, participantSince: now, guess: timestamp, hasGuessed: true, diff: now});
1339                 totalGuesses++;
1340                 emit SomebodyGuessed(msg.sender, timestamp, totalGuesses);
1341             }
1342         }
1343     }
1344 
1345     function() public payable {
1346         emit EtherReceived(msg.value, msg.sender);
1347     }
1348 
1349     // Oracalize callback - https://docs.oraclize.it
1350     function __callback(bytes32 myid, string result) {
1351         if (msg.sender != oraclize_cbAddress()) throw;
1352         uint _result = parseInt(result);
1353         emit OraclizeResult("Price checked", _result, now);
1354         if (_result >= 500){ // if greater than or equal to 500USD of last trade on Kraken API
1355             priceConfirmedOver500 = true;
1356             winningTimestamp = block.timestamp;
1357         }
1358     }
1359 
1360     // Query Kraken API to check ETHUSD price, will trigger __callback method from Oracalize
1361     function checkPrice() public payable {
1362         require(!priceConfirmedOver500 && msg.value >= oraclePrice); //ensure method can't be called again once oracle confirms we've crossed 500, thereby changing winningTimestamp. Ensure function caller pays Oracle callback fee
1363         if (oraclize_getPrice("URL") > address(this).balance) {
1364             emit Feedback("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1365         } else {
1366             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1367             oraclePrice = oraclize_getPrice("URL");
1368         }
1369     }
1370 
1371     function claimCheckPriceReward() public {
1372         require(!checkPriceCalled && priceConfirmedOver500); // reward first person to call this function with 10% of the balance AFTER checkPrice() is successfully called
1373         uint tenPercentBalance = address(this).balance.div(10);
1374         msg.sender.transfer(tenPercentBalance);
1375         checkPriceCalled = true;
1376     }
1377 
1378     function nominateSelfAsWinner(address possibleWinner) public {
1379         require(priceConfirmedOver500 && possibleWinner != 0); // can only be called once oracle has established we are over 500
1380         uint id = participantId[possibleWinner];
1381         Participant storage p = participants[id];
1382         require(p.participant == possibleWinner); // ensure nominee is actually a participant already
1383 
1384         // get nominees' diffs whether they guessed before or after `winningTimestamp`
1385         if (winningTimestamp > p.guess){
1386             p.diff = winningTimestamp.sub(p.guess);
1387         } else {
1388             p.diff = p.guess.sub(winningTimestamp);
1389         }
1390 
1391         // establish which of the nominees has the lowest diff and mark them as the winner until
1392         // replaced by someone with a better guess. Note, this contract is not set up for multiple
1393         // winners in the unlikely chance two or more addresses have the correct answer. In this
1394         // case, the person who nominated themselves second (i.e., after the other nominee with the
1395         // same winning guess called this function and established themselves in the lead) would win.
1396 
1397         if (p.diff <= lowestDiff) {
1398             lowestDiff = p.diff;
1399             winner = p.participant;
1400         }
1401 
1402         totalNominees++;
1403         emit NewNomination(possibleWinner, p.guess, p.diff);
1404     }
1405 
1406     function payout() public {
1407         require(now > winningTimestamp + SECS_IN_ONE_WEEK && !winnerPaid && winner != 0); // establishes nomination period of 1 week following price hitting 500
1408 
1409         // payout contract balance to `winner`
1410         if (winner.send(address(this).balance)) {
1411             emit WinnerAnnounced("Congrats!", winner, lowestDiff);
1412             winnerPaid = true;
1413         }
1414     }
1415 
1416     // send all ETH to nonprofit Give Directly in the event of some logic error or API problem
1417     function endContract() onlyOwner public {
1418         selfdestruct(0xc7464dbcA260A8faF033460622B23467Df5AEA42);
1419     }
1420 
1421 }