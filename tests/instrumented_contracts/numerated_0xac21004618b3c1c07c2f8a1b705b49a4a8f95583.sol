1 pragma solidity ^0.4.24;
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
24 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
25 
26 // Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
27 
28 contract OraclizeI {
29     address public cbAddress;
30     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
31     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
32     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
33     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
34     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
35     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
36     function getPrice(string _datasource) public returns (uint _dsprice);
37     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
38     function setProofType(byte _proofType) external;
39     function setCustomGasPrice(uint _gasPrice) external;
40     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
41 }
42 
43 contract OraclizeAddrResolverI {
44     function getAddress() public returns (address _addr);
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
75     function init(buffer memory buf, uint _capacity) internal pure {
76         uint capacity = _capacity;
77         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
78         // Allocate space for the buffer data
79         buf.capacity = capacity;
80         assembly {
81             let ptr := mload(0x40)
82             mstore(buf, ptr)
83             mstore(ptr, 0)
84             mstore(0x40, add(ptr, capacity))
85         }
86     }
87 
88     function resize(buffer memory buf, uint capacity) private pure {
89         bytes memory oldbuf = buf.buf;
90         init(buf, capacity);
91         append(buf, oldbuf);
92     }
93 
94     function max(uint a, uint b) private pure returns(uint) {
95         if(a > b) {
96             return a;
97         }
98         return b;
99     }
100 
101     /**
102      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
103      *      would exceed the capacity of the buffer.
104      * @param buf The buffer to append to.
105      * @param data The data to append.
106      * @return The original buffer.
107      */
108     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
109         if(data.length + buf.buf.length > buf.capacity) {
110             resize(buf, max(buf.capacity, data.length) * 2);
111         }
112 
113         uint dest;
114         uint src;
115         uint len = data.length;
116         assembly {
117             // Memory address of the buffer data
118             let bufptr := mload(buf)
119             // Length of existing buffer data
120             let buflen := mload(bufptr)
121             // Start address = buffer address + buffer length + sizeof(buffer length)
122             dest := add(add(bufptr, buflen), 32)
123             // Update buffer length
124             mstore(bufptr, add(buflen, mload(data)))
125             src := add(data, 32)
126         }
127 
128         // Copy word-length chunks while possible
129         for(; len >= 32; len -= 32) {
130             assembly {
131                 mstore(dest, mload(src))
132             }
133             dest += 32;
134             src += 32;
135         }
136 
137         // Copy remaining bytes
138         uint mask = 256 ** (32 - len) - 1;
139         assembly {
140             let srcpart := and(mload(src), not(mask))
141             let destpart := and(mload(dest), mask)
142             mstore(dest, or(destpart, srcpart))
143         }
144 
145         return buf;
146     }
147 
148     /**
149      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
150      * exceed the capacity of the buffer.
151      * @param buf The buffer to append to.
152      * @param data The data to append.
153      * @return The original buffer.
154      */
155     function append(buffer memory buf, uint8 data) internal pure {
156         if(buf.buf.length + 1 > buf.capacity) {
157             resize(buf, buf.capacity * 2);
158         }
159 
160         assembly {
161             // Memory address of the buffer data
162             let bufptr := mload(buf)
163             // Length of existing buffer data
164             let buflen := mload(bufptr)
165             // Address = buffer address + buffer length + sizeof(buffer length)
166             let dest := add(add(bufptr, buflen), 32)
167             mstore8(dest, data)
168             // Update buffer length
169             mstore(bufptr, add(buflen, 1))
170         }
171     }
172 
173     /**
174      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
175      * exceed the capacity of the buffer.
176      * @param buf The buffer to append to.
177      * @param data The data to append.
178      * @return The original buffer.
179      */
180     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
181         if(len + buf.buf.length > buf.capacity) {
182             resize(buf, max(buf.capacity, len) * 2);
183         }
184 
185         uint mask = 256 ** len - 1;
186         assembly {
187             // Memory address of the buffer data
188             let bufptr := mload(buf)
189             // Length of existing buffer data
190             let buflen := mload(bufptr)
191             // Address = buffer address + buffer length + sizeof(buffer length) + len
192             let dest := add(add(bufptr, buflen), len)
193             mstore(dest, or(and(mload(dest), not(mask)), data))
194             // Update buffer length
195             mstore(bufptr, add(buflen, len))
196         }
197         return buf;
198     }
199 }
200 
201 library CBOR {
202     using Buffer for Buffer.buffer;
203 
204     uint8 private constant MAJOR_TYPE_INT = 0;
205     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
206     uint8 private constant MAJOR_TYPE_BYTES = 2;
207     uint8 private constant MAJOR_TYPE_STRING = 3;
208     uint8 private constant MAJOR_TYPE_ARRAY = 4;
209     uint8 private constant MAJOR_TYPE_MAP = 5;
210     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
211 
212     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
213         if(value <= 23) {
214             buf.append(uint8((major << 5) | value));
215         } else if(value <= 0xFF) {
216             buf.append(uint8((major << 5) | 24));
217             buf.appendInt(value, 1);
218         } else if(value <= 0xFFFF) {
219             buf.append(uint8((major << 5) | 25));
220             buf.appendInt(value, 2);
221         } else if(value <= 0xFFFFFFFF) {
222             buf.append(uint8((major << 5) | 26));
223             buf.appendInt(value, 4);
224         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
225             buf.append(uint8((major << 5) | 27));
226             buf.appendInt(value, 8);
227         }
228     }
229 
230     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
231         buf.append(uint8((major << 5) | 31));
232     }
233 
234     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
235         encodeType(buf, MAJOR_TYPE_INT, value);
236     }
237 
238     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
239         if(value >= 0) {
240             encodeType(buf, MAJOR_TYPE_INT, uint(value));
241         } else {
242             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
243         }
244     }
245 
246     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
247         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
248         buf.append(value);
249     }
250 
251     function encodeString(Buffer.buffer memory buf, string value) internal pure {
252         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
253         buf.append(bytes(value));
254     }
255 
256     function startArray(Buffer.buffer memory buf) internal pure {
257         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
258     }
259 
260     function startMap(Buffer.buffer memory buf) internal pure {
261         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
262     }
263 
264     function endSequence(Buffer.buffer memory buf) internal pure {
265         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
266     }
267 }
268 
269 /*
270 End solidity-cborutils
271  */
272 
273 contract usingOraclize {
274     uint constant day = 60*60*24;
275     uint constant week = 60*60*24*7;
276     uint constant month = 60*60*24*30;
277     byte constant proofType_NONE = 0x00;
278     byte constant proofType_TLSNotary = 0x10;
279     byte constant proofType_Ledger = 0x30;
280     byte constant proofType_Android = 0x40;
281     byte constant proofType_Native = 0xF0;
282     byte constant proofStorage_IPFS = 0x01;
283     uint8 constant networkID_auto = 0;
284     uint8 constant networkID_mainnet = 1;
285     uint8 constant networkID_testnet = 2;
286     uint8 constant networkID_morden = 2;
287     uint8 constant networkID_consensys = 161;
288 
289     OraclizeAddrResolverI OAR;
290 
291     OraclizeI oraclize;
292     modifier oraclizeAPI {
293         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
294             oraclize_setNetwork(networkID_auto);
295 
296         if(address(oraclize) != OAR.getAddress())
297             oraclize = OraclizeI(OAR.getAddress());
298 
299         _;
300     }
301     modifier coupon(string code){
302         oraclize = OraclizeI(OAR.getAddress());
303         _;
304     }
305 
306     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
307       return oraclize_setNetwork();
308       networkID; // silence the warning and remain backwards compatible
309     }
310     function oraclize_setNetwork() internal returns(bool){
311         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
312             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
313             oraclize_setNetworkName("eth_mainnet");
314             return true;
315         }
316         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
317             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
318             oraclize_setNetworkName("eth_ropsten3");
319             return true;
320         }
321         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
322             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
323             oraclize_setNetworkName("eth_kovan");
324             return true;
325         }
326         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
327             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
328             oraclize_setNetworkName("eth_rinkeby");
329             return true;
330         }
331         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
332             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
333             return true;
334         }
335         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
336             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
337             return true;
338         }
339         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
340             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
341             return true;
342         }
343         return false;
344     }
345 
346     function __callback(bytes32 myid, string result) public {
347         __callback(myid, result, new bytes(0));
348     }
349     function __callback(bytes32 myid, string result, bytes proof) public {
350       return;
351       myid; result; proof; // Silence compiler warnings
352     }
353 
354     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
355         return oraclize.getPrice(datasource);
356     }
357 
358     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
359         return oraclize.getPrice(datasource, gaslimit);
360     }
361 
362     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource);
364         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
365         return oraclize.query.value(price)(0, datasource, arg);
366     }
367     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource);
369         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
370         return oraclize.query.value(price)(timestamp, datasource, arg);
371     }
372     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource, gaslimit);
374         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
375         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
376     }
377     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource, gaslimit);
379         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
380         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
381     }
382     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource);
384         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
385         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
386     }
387     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource);
389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
391     }
392     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource, gaslimit);
394         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
395         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
396     }
397     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource, gaslimit);
399         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
400         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
401     }
402     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource);
404         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
405         bytes memory args = stra2cbor(argN);
406         return oraclize.queryN.value(price)(0, datasource, args);
407     }
408     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource);
410         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
411         bytes memory args = stra2cbor(argN);
412         return oraclize.queryN.value(price)(timestamp, datasource, args);
413     }
414     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource, gaslimit);
416         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
417         bytes memory args = stra2cbor(argN);
418         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
419     }
420     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource, gaslimit);
422         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
423         bytes memory args = stra2cbor(argN);
424         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
425     }
426     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
427         string[] memory dynargs = new string[](1);
428         dynargs[0] = args[0];
429         return oraclize_query(datasource, dynargs);
430     }
431     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
432         string[] memory dynargs = new string[](1);
433         dynargs[0] = args[0];
434         return oraclize_query(timestamp, datasource, dynargs);
435     }
436     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
437         string[] memory dynargs = new string[](1);
438         dynargs[0] = args[0];
439         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
440     }
441     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(datasource, dynargs, gaslimit);
445     }
446 
447     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](2);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         return oraclize_query(datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
454         string[] memory dynargs = new string[](2);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         return oraclize_query(timestamp, datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](2);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
464     }
465     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         string[] memory dynargs = new string[](2);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         return oraclize_query(datasource, dynargs, gaslimit);
470     }
471     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](3);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         return oraclize_query(datasource, dynargs);
477     }
478     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](3);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         return oraclize_query(timestamp, datasource, dynargs);
484     }
485     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](3);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
491     }
492     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
493         string[] memory dynargs = new string[](3);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         return oraclize_query(datasource, dynargs, gaslimit);
498     }
499 
500     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](4);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         dynargs[3] = args[3];
506         return oraclize_query(datasource, dynargs);
507     }
508     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](4);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         dynargs[3] = args[3];
514         return oraclize_query(timestamp, datasource, dynargs);
515     }
516     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](4);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         dynargs[3] = args[3];
522         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
523     }
524     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](4);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         dynargs[3] = args[3];
530         return oraclize_query(datasource, dynargs, gaslimit);
531     }
532     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](5);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         dynargs[4] = args[4];
539         return oraclize_query(datasource, dynargs);
540     }
541     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
542         string[] memory dynargs = new string[](5);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         dynargs[3] = args[3];
547         dynargs[4] = args[4];
548         return oraclize_query(timestamp, datasource, dynargs);
549     }
550     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](5);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         dynargs[3] = args[3];
556         dynargs[4] = args[4];
557         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
558     }
559     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](5);
561         dynargs[0] = args[0];
562         dynargs[1] = args[1];
563         dynargs[2] = args[2];
564         dynargs[3] = args[3];
565         dynargs[4] = args[4];
566         return oraclize_query(datasource, dynargs, gaslimit);
567     }
568     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
569         uint price = oraclize.getPrice(datasource);
570         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
571         bytes memory args = ba2cbor(argN);
572         return oraclize.queryN.value(price)(0, datasource, args);
573     }
574     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
575         uint price = oraclize.getPrice(datasource);
576         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
577         bytes memory args = ba2cbor(argN);
578         return oraclize.queryN.value(price)(timestamp, datasource, args);
579     }
580     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
581         uint price = oraclize.getPrice(datasource, gaslimit);
582         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
583         bytes memory args = ba2cbor(argN);
584         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
585     }
586     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
587         uint price = oraclize.getPrice(datasource, gaslimit);
588         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
589         bytes memory args = ba2cbor(argN);
590         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
591     }
592     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
593         bytes[] memory dynargs = new bytes[](1);
594         dynargs[0] = args[0];
595         return oraclize_query(datasource, dynargs);
596     }
597     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
598         bytes[] memory dynargs = new bytes[](1);
599         dynargs[0] = args[0];
600         return oraclize_query(timestamp, datasource, dynargs);
601     }
602     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
603         bytes[] memory dynargs = new bytes[](1);
604         dynargs[0] = args[0];
605         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
606     }
607     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](1);
609         dynargs[0] = args[0];
610         return oraclize_query(datasource, dynargs, gaslimit);
611     }
612 
613     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](2);
615         dynargs[0] = args[0];
616         dynargs[1] = args[1];
617         return oraclize_query(datasource, dynargs);
618     }
619     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
620         bytes[] memory dynargs = new bytes[](2);
621         dynargs[0] = args[0];
622         dynargs[1] = args[1];
623         return oraclize_query(timestamp, datasource, dynargs);
624     }
625     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](2);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
630     }
631     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
632         bytes[] memory dynargs = new bytes[](2);
633         dynargs[0] = args[0];
634         dynargs[1] = args[1];
635         return oraclize_query(datasource, dynargs, gaslimit);
636     }
637     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](3);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         dynargs[2] = args[2];
642         return oraclize_query(datasource, dynargs);
643     }
644     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
645         bytes[] memory dynargs = new bytes[](3);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         dynargs[2] = args[2];
649         return oraclize_query(timestamp, datasource, dynargs);
650     }
651     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](3);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         dynargs[2] = args[2];
656         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
657     }
658     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
659         bytes[] memory dynargs = new bytes[](3);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         dynargs[2] = args[2];
663         return oraclize_query(datasource, dynargs, gaslimit);
664     }
665 
666     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](4);
668         dynargs[0] = args[0];
669         dynargs[1] = args[1];
670         dynargs[2] = args[2];
671         dynargs[3] = args[3];
672         return oraclize_query(datasource, dynargs);
673     }
674     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](4);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         dynargs[3] = args[3];
680         return oraclize_query(timestamp, datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](4);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
689     }
690     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
691         bytes[] memory dynargs = new bytes[](4);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         return oraclize_query(datasource, dynargs, gaslimit);
697     }
698     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](5);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         dynargs[2] = args[2];
703         dynargs[3] = args[3];
704         dynargs[4] = args[4];
705         return oraclize_query(datasource, dynargs);
706     }
707     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
708         bytes[] memory dynargs = new bytes[](5);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         dynargs[2] = args[2];
712         dynargs[3] = args[3];
713         dynargs[4] = args[4];
714         return oraclize_query(timestamp, datasource, dynargs);
715     }
716     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](5);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         dynargs[3] = args[3];
722         dynargs[4] = args[4];
723         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
724     }
725     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
726         bytes[] memory dynargs = new bytes[](5);
727         dynargs[0] = args[0];
728         dynargs[1] = args[1];
729         dynargs[2] = args[2];
730         dynargs[3] = args[3];
731         dynargs[4] = args[4];
732         return oraclize_query(datasource, dynargs, gaslimit);
733     }
734 
735     function oraclize_cbAddress() oraclizeAPI internal returns (address){
736         return oraclize.cbAddress();
737     }
738     function oraclize_setProof(byte proofP) oraclizeAPI internal {
739         return oraclize.setProofType(proofP);
740     }
741     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
742         return oraclize.setCustomGasPrice(gasPrice);
743     }
744 
745     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
746         return oraclize.randomDS_getSessionPubKeyHash();
747     }
748 
749     function getCodeSize(address _addr) constant internal returns(uint _size) {
750         assembly {
751             _size := extcodesize(_addr)
752         }
753     }
754 
755     function parseAddr(string _a) internal pure returns (address){
756         bytes memory tmp = bytes(_a);
757         uint160 iaddr = 0;
758         uint160 b1;
759         uint160 b2;
760         for (uint i=2; i<2+2*20; i+=2){
761             iaddr *= 256;
762             b1 = uint160(tmp[i]);
763             b2 = uint160(tmp[i+1]);
764             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
765             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
766             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
767             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
768             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
769             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
770             iaddr += (b1*16+b2);
771         }
772         return address(iaddr);
773     }
774 
775     function strCompare(string _a, string _b) internal pure returns (int) {
776         bytes memory a = bytes(_a);
777         bytes memory b = bytes(_b);
778         uint minLength = a.length;
779         if (b.length < minLength) minLength = b.length;
780         for (uint i = 0; i < minLength; i ++)
781             if (a[i] < b[i])
782                 return -1;
783             else if (a[i] > b[i])
784                 return 1;
785         if (a.length < b.length)
786             return -1;
787         else if (a.length > b.length)
788             return 1;
789         else
790             return 0;
791     }
792 
793     function indexOf(string _haystack, string _needle) internal pure returns (int) {
794         bytes memory h = bytes(_haystack);
795         bytes memory n = bytes(_needle);
796         if(h.length < 1 || n.length < 1 || (n.length > h.length))
797             return -1;
798         else if(h.length > (2**128 -1))
799             return -1;
800         else
801         {
802             uint subindex = 0;
803             for (uint i = 0; i < h.length; i ++)
804             {
805                 if (h[i] == n[0])
806                 {
807                     subindex = 1;
808                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
809                     {
810                         subindex++;
811                     }
812                     if(subindex == n.length)
813                         return int(i);
814                 }
815             }
816             return -1;
817         }
818     }
819 
820     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
821         bytes memory _ba = bytes(_a);
822         bytes memory _bb = bytes(_b);
823         bytes memory _bc = bytes(_c);
824         bytes memory _bd = bytes(_d);
825         bytes memory _be = bytes(_e);
826         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
827         bytes memory babcde = bytes(abcde);
828         uint k = 0;
829         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
830         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
831         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
832         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
833         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
834         return string(babcde);
835     }
836 
837     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
838         return strConcat(_a, _b, _c, _d, "");
839     }
840 
841     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
842         return strConcat(_a, _b, _c, "", "");
843     }
844 
845     function strConcat(string _a, string _b) internal pure returns (string) {
846         return strConcat(_a, _b, "", "", "");
847     }
848 
849     // parseInt
850     function parseInt(string _a) internal pure returns (uint) {
851         return parseInt(_a, 0);
852     }
853 
854     // parseInt(parseFloat*10^_b)
855     function parseInt(string _a, uint _b) internal pure returns (uint) {
856         bytes memory bresult = bytes(_a);
857         uint mint = 0;
858         bool decimals = false;
859         for (uint i=0; i<bresult.length; i++){
860             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
861                 if (decimals){
862                    if (_b == 0) break;
863                     else _b--;
864                 }
865                 mint *= 10;
866                 mint += uint(bresult[i]) - 48;
867             } else if (bresult[i] == 46) decimals = true;
868         }
869         if (_b > 0) mint *= 10**_b;
870         return mint;
871     }
872 
873     function uint2str(uint i) internal pure returns (string){
874         if (i == 0) return "0";
875         uint j = i;
876         uint len;
877         while (j != 0){
878             len++;
879             j /= 10;
880         }
881         bytes memory bstr = new bytes(len);
882         uint k = len - 1;
883         while (i != 0){
884             bstr[k--] = byte(48 + i % 10);
885             i /= 10;
886         }
887         return string(bstr);
888     }
889 
890     using CBOR for Buffer.buffer;
891     function stra2cbor(string[] arr) internal pure returns (bytes) {
892         safeMemoryCleaner();
893         Buffer.buffer memory buf;
894         Buffer.init(buf, 1024);
895         buf.startArray();
896         for (uint i = 0; i < arr.length; i++) {
897             buf.encodeString(arr[i]);
898         }
899         buf.endSequence();
900         return buf.buf;
901     }
902 
903     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
904         safeMemoryCleaner();
905         Buffer.buffer memory buf;
906         Buffer.init(buf, 1024);
907         buf.startArray();
908         for (uint i = 0; i < arr.length; i++) {
909             buf.encodeBytes(arr[i]);
910         }
911         buf.endSequence();
912         return buf.buf;
913     }
914 
915     string oraclize_network_name;
916     function oraclize_setNetworkName(string _network_name) internal {
917         oraclize_network_name = _network_name;
918     }
919 
920     function oraclize_getNetworkName() internal view returns (string) {
921         return oraclize_network_name;
922     }
923 
924     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
925         require((_nbytes > 0) && (_nbytes <= 32));
926         // Convert from seconds to ledger timer ticks
927         _delay *= 10;
928         bytes memory nbytes = new bytes(1);
929         nbytes[0] = byte(_nbytes);
930         bytes memory unonce = new bytes(32);
931         bytes memory sessionKeyHash = new bytes(32);
932         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
933         assembly {
934             mstore(unonce, 0x20)
935             // the following variables can be relaxed
936             // check relaxed random contract under ethereum-examples repo
937             // for an idea on how to override and replace comit hash vars
938             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
939             mstore(sessionKeyHash, 0x20)
940             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
941         }
942         bytes memory delay = new bytes(32);
943         assembly {
944             mstore(add(delay, 0x20), _delay)
945         }
946 
947         bytes memory delay_bytes8 = new bytes(8);
948         copyBytes(delay, 24, 8, delay_bytes8, 0);
949 
950         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
951         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
952 
953         bytes memory delay_bytes8_left = new bytes(8);
954 
955         assembly {
956             let x := mload(add(delay_bytes8, 0x20))
957             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
958             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
959             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
960             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
961             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
962             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
965 
966         }
967 
968         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
969         return queryId;
970     }
971 
972     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
973         oraclize_randomDS_args[queryId] = commitment;
974     }
975 
976     mapping(bytes32=>bytes32) oraclize_randomDS_args;
977     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
978 
979     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
980         bool sigok;
981         address signer;
982 
983         bytes32 sigr;
984         bytes32 sigs;
985 
986         bytes memory sigr_ = new bytes(32);
987         uint offset = 4+(uint(dersig[3]) - 0x20);
988         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
989         bytes memory sigs_ = new bytes(32);
990         offset += 32 + 2;
991         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
992 
993         assembly {
994             sigr := mload(add(sigr_, 32))
995             sigs := mload(add(sigs_, 32))
996         }
997 
998 
999         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1000         if (address(keccak256(pubkey)) == signer) return true;
1001         else {
1002             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1003             return (address(keccak256(pubkey)) == signer);
1004         }
1005     }
1006 
1007     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1008         bool sigok;
1009 
1010         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1011         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1012         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1013 
1014         bytes memory appkey1_pubkey = new bytes(64);
1015         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1016 
1017         bytes memory tosign2 = new bytes(1+65+32);
1018         tosign2[0] = byte(1); //role
1019         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1020         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1021         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1022         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1023 
1024         if (sigok == false) return false;
1025 
1026 
1027         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1028         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1029 
1030         bytes memory tosign3 = new bytes(1+65);
1031         tosign3[0] = 0xFE;
1032         copyBytes(proof, 3, 65, tosign3, 1);
1033 
1034         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1035         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1036 
1037         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1038 
1039         return sigok;
1040     }
1041 
1042     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1043         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1044         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1045 
1046         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1047         require(proofVerified);
1048 
1049         _;
1050     }
1051 
1052     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1053         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1054         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1055 
1056         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1057         if (proofVerified == false) return 2;
1058 
1059         return 0;
1060     }
1061 
1062     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1063         bool match_ = true;
1064 
1065         require(prefix.length == n_random_bytes);
1066 
1067         for (uint256 i=0; i< n_random_bytes; i++) {
1068             if (content[i] != prefix[i]) match_ = false;
1069         }
1070 
1071         return match_;
1072     }
1073 
1074     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1075 
1076         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1077         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1078         bytes memory keyhash = new bytes(32);
1079         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1080         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1081 
1082         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1083         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1084 
1085         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1086         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1087 
1088         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1089         // This is to verify that the computed args match with the ones specified in the query.
1090         bytes memory commitmentSlice1 = new bytes(8+1+32);
1091         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1092 
1093         bytes memory sessionPubkey = new bytes(64);
1094         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1095         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1096 
1097         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1098         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1099             delete oraclize_randomDS_args[queryId];
1100         } else return false;
1101 
1102 
1103         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1104         bytes memory tosign1 = new bytes(32+8+1+32);
1105         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1106         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1107 
1108         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1109         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1110             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1111         }
1112 
1113         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1114     }
1115 
1116     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1117     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1118         uint minLength = length + toOffset;
1119 
1120         // Buffer too small
1121         require(to.length >= minLength); // Should be a better way?
1122 
1123         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1124         uint i = 32 + fromOffset;
1125         uint j = 32 + toOffset;
1126 
1127         while (i < (32 + fromOffset + length)) {
1128             assembly {
1129                 let tmp := mload(add(from, i))
1130                 mstore(add(to, j), tmp)
1131             }
1132             i += 32;
1133             j += 32;
1134         }
1135 
1136         return to;
1137     }
1138 
1139     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1140     // Duplicate Solidity's ecrecover, but catching the CALL return value
1141     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1142         // We do our own memory management here. Solidity uses memory offset
1143         // 0x40 to store the current end of memory. We write past it (as
1144         // writes are memory extensions), but don't update the offset so
1145         // Solidity will reuse it. The memory used here is only needed for
1146         // this context.
1147 
1148         // FIXME: inline assembly can't access return values
1149         bool ret;
1150         address addr;
1151 
1152         assembly {
1153             let size := mload(0x40)
1154             mstore(size, hash)
1155             mstore(add(size, 32), v)
1156             mstore(add(size, 64), r)
1157             mstore(add(size, 96), s)
1158 
1159             // NOTE: we can reuse the request memory because we deal with
1160             //       the return code
1161             ret := call(3000, 1, 0, size, 128, size, 32)
1162             addr := mload(size)
1163         }
1164 
1165         return (ret, addr);
1166     }
1167 
1168     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1169     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1170         bytes32 r;
1171         bytes32 s;
1172         uint8 v;
1173 
1174         if (sig.length != 65)
1175           return (false, 0);
1176 
1177         // The signature format is a compact form of:
1178         //   {bytes32 r}{bytes32 s}{uint8 v}
1179         // Compact means, uint8 is not padded to 32 bytes.
1180         assembly {
1181             r := mload(add(sig, 32))
1182             s := mload(add(sig, 64))
1183 
1184             // Here we are loading the last 32 bytes. We exploit the fact that
1185             // 'mload' will pad with zeroes if we overread.
1186             // There is no 'mload8' to do this, but that would be nicer.
1187             v := byte(0, mload(add(sig, 96)))
1188 
1189             // Alternative solution:
1190             // 'byte' is not working due to the Solidity parser, so lets
1191             // use the second best option, 'and'
1192             // v := and(mload(add(sig, 65)), 255)
1193         }
1194 
1195         // albeit non-transactional signatures are not specified by the YP, one would expect it
1196         // to match the YP range of [27, 28]
1197         //
1198         // geth uses [0, 1] and some clients have followed. This might change, see:
1199         //  https://github.com/ethereum/go-ethereum/issues/2053
1200         if (v < 27)
1201           v += 27;
1202 
1203         if (v != 27 && v != 28)
1204             return (false, 0);
1205 
1206         return safer_ecrecover(hash, v, r, s);
1207     }
1208 
1209     function safeMemoryCleaner() internal pure {
1210         assembly {
1211             let fmem := mload(0x40)
1212             codecopy(fmem, codesize, sub(msize, fmem))
1213         }
1214     }
1215 
1216 }
1217 
1218 /**
1219  * @title Ownable
1220  * @dev The Ownable contract has an owner address, and provides basic authorization control
1221  * functions, this simplifies the implementation of "user permissions".
1222  */
1223 contract Ownable {
1224   address public owner;
1225 
1226 
1227   event OwnershipRenounced(address indexed previousOwner);
1228   event OwnershipTransferred(
1229     address indexed previousOwner,
1230     address indexed newOwner
1231   );
1232 
1233 
1234   /**
1235    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1236    * account.
1237    */
1238   constructor() public {
1239     owner = msg.sender;
1240   }
1241 
1242   /**
1243    * @dev Throws if called by any account other than the owner.
1244    */
1245   modifier onlyOwner() {
1246     require(msg.sender == owner);
1247     _;
1248   }
1249 
1250   /**
1251    * @dev Allows the current owner to relinquish control of the contract.
1252    */
1253   function renounceOwnership() public onlyOwner {
1254     emit OwnershipRenounced(owner);
1255     owner = address(0);
1256   }
1257 
1258   /**
1259    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1260    * @param _newOwner The address to transfer ownership to.
1261    */
1262   function transferOwnership(address _newOwner) public onlyOwner {
1263     _transferOwnership(_newOwner);
1264   }
1265 
1266   /**
1267    * @dev Transfers control of the contract to a newOwner.
1268    * @param _newOwner The address to transfer ownership to.
1269    */
1270   function _transferOwnership(address _newOwner) internal {
1271     require(_newOwner != address(0));
1272     emit OwnershipTransferred(owner, _newOwner);
1273     owner = _newOwner;
1274   }
1275 }
1276 
1277 /**
1278  * @title SafeMath
1279  * @dev Math operations with safety checks that throw on error
1280  */
1281 library SafeMath {
1282 
1283   /**
1284   * @dev Multiplies two numbers, throws on overflow.
1285   */
1286   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1287     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1288     // benefit is lost if 'b' is also tested.
1289     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1290     if (a == 0) {
1291       return 0;
1292     }
1293 
1294     c = a * b;
1295     assert(c / a == b);
1296     return c;
1297   }
1298 
1299   /**
1300   * @dev Integer division of two numbers, truncating the quotient.
1301   */
1302   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1303     // assert(b > 0); // Solidity automatically throws when dividing by 0
1304     // uint256 c = a / b;
1305     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1306     return a / b;
1307   }
1308 
1309   /**
1310   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1311   */
1312   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1313     assert(b <= a);
1314     return a - b;
1315   }
1316 
1317   /**
1318   * @dev Adds two numbers, throws on overflow.
1319   */
1320   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1321     c = a + b;
1322     assert(c >= a);
1323     return c;
1324   }
1325 }
1326 
1327 interface IOracle {
1328 
1329     /**
1330     * @notice Returns address of oracle currency (0x0 for ETH)
1331     */
1332     function getCurrencyAddress() external view returns(address);
1333 
1334     /**
1335     * @notice Returns symbol of oracle currency (0x0 for ETH)
1336     */
1337     function getCurrencySymbol() external view returns(bytes32);
1338 
1339     /**
1340     * @notice Returns denomination of price
1341     */
1342     function getCurrencyDenominated() external view returns(bytes32);
1343 
1344     /**
1345     * @notice Returns price - should throw if not valid
1346     */
1347     function getPrice() external view returns(uint256);
1348 
1349 }
1350 
1351 contract PolyOracle is usingOraclize, IOracle, Ownable {
1352     using SafeMath for uint256;
1353 
1354     string public oracleURL = "json(https://api.coinmarketcap.com/v2/ticker/2496/?convert=USD).data.quotes.USD.price";
1355     uint256 public sanityBounds = 20*10**16;
1356     uint256 public gasLimit = 100000;
1357     uint256 public oraclizeTimeTolerance = 5 minutes;
1358     uint256 public staleTime = 6 hours;
1359 
1360     uint256 private POLYUSD;
1361     uint256 public latestUpdate;
1362     uint256 public latestScheduledUpdate;
1363 
1364     mapping (bytes32 => uint256) public requestIds;
1365     mapping (bytes32 => bool) public ignoreRequestIds;
1366 
1367     mapping (address => bool) public admin;
1368 
1369     bool public freezeOracle;
1370 
1371     event LogPriceUpdated(uint256 _price, uint256 _oldPrice, bytes32 _queryId, uint256 _time);
1372     event LogNewOraclizeQuery(uint256 _time, bytes32 _queryId, string _query);
1373     event LogAdminSet(address _admin, bool _valid, uint256 _time);
1374     event LogStalePriceUpdate(bytes32 _queryId, uint256 _time, string _result);
1375 
1376     modifier isAdminOrOwner {
1377         require(admin[msg.sender] || msg.sender == owner, "Address is not admin or owner");
1378         _;
1379     }
1380 
1381     /**
1382     * @notice Constructor - accepts ETH to initialise a balance for subsequent Oraclize queries
1383     */
1384     constructor() payable public {
1385         // Use 50 gwei for now
1386         oraclize_setCustomGasPrice(50*10**9);
1387     }
1388 
1389     /**
1390     * @notice Oraclize callback (triggered by Oraclize)
1391     * @param _requestId requestId corresponding to Oraclize query
1392     * @param _result data returned by Oraclize URL query
1393     */
1394     function __callback(bytes32 _requestId, string _result) public {
1395         require(msg.sender == oraclize_cbAddress(), "Only Oraclize can access this method");
1396         require(!freezeOracle, "Oracle is frozen");
1397         require(!ignoreRequestIds[_requestId], "Ignoring requestId");
1398         if (requestIds[_requestId] < latestUpdate) {
1399             // Result is stale, probably because it was received out of order
1400             emit LogStalePriceUpdate(_requestId, requestIds[_requestId], _result);
1401             return;
1402         }
1403         require(requestIds[_requestId] >= latestUpdate, "Result is stale");
1404         require(requestIds[_requestId] <= now + oraclizeTimeTolerance, "Result is early");
1405         uint256 newPOLYUSD = parseInt(_result, 18);
1406         uint256 bound = POLYUSD.mul(sanityBounds).div(10**18);
1407         if (latestUpdate != 0) {
1408           require(newPOLYUSD <= POLYUSD.add(bound), "Result is too large");
1409           require(newPOLYUSD >= POLYUSD.sub(bound), "Result is too small");
1410         }
1411         latestUpdate = requestIds[_requestId];
1412         emit LogPriceUpdated(newPOLYUSD, POLYUSD, _requestId, latestUpdate);
1413         POLYUSD = newPOLYUSD;
1414     }
1415 
1416     /**
1417     * @notice Allows owner to schedule future Oraclize calls
1418     * @param _times UNIX timestamps to schedule Oraclize calls as of. Empty list means trigger an immediate query.
1419     */
1420     function schedulePriceUpdatesFixed(uint256[] _times) payable isAdminOrOwner public {
1421         bytes32 requestId;
1422         uint256 maximumScheduledUpdated;
1423         if (_times.length == 0) {
1424             require(oraclize_getPrice("URL", gasLimit) <= address(this).balance, "Insufficient Funds");
1425             requestId = oraclize_query("URL", oracleURL, gasLimit);
1426             requestIds[requestId] = now;
1427             maximumScheduledUpdated = now;
1428             emit LogNewOraclizeQuery(now, requestId, oracleURL);
1429         } else {
1430             require(oraclize_getPrice("URL", gasLimit) * _times.length <= address(this).balance, "Insufficient Funds");
1431             for (uint256 i = 0; i < _times.length; i++) {
1432                 require(_times[i] >= now, "Past scheduling is not allowed and scheduled time should be absolute timestamp");
1433                 requestId = oraclize_query(_times[i], "URL", oracleURL, gasLimit);
1434                 requestIds[requestId] = _times[i];
1435                 if (maximumScheduledUpdated < requestIds[requestId]) {
1436                     maximumScheduledUpdated = requestIds[requestId];
1437                 }
1438                 emit LogNewOraclizeQuery(_times[i], requestId, oracleURL);
1439             }
1440         }
1441         if (latestScheduledUpdate < maximumScheduledUpdated) {
1442             latestScheduledUpdate = maximumScheduledUpdated;
1443         }
1444     }
1445 
1446     /**
1447     * @notice Allows owner to schedule future Oraclize calls on a rolling schedule
1448     * @param _startTime UNIX timestamp for the first scheduled Oraclize query
1449     * @param _interval how long (in seconds) between each subsequent Oraclize query
1450     * @param _iters the number of Oraclize queries to schedule.
1451     */
1452     function schedulePriceUpdatesRolling(uint256 _startTime, uint256 _interval, uint256 _iters) payable isAdminOrOwner public {
1453         bytes32 requestId;
1454         require(_interval > 0, "Interval between scheduled time should be greater than zero");
1455         require(_iters > 0, "No iterations specified");
1456         require(_startTime >= now, "Past scheduling is not allowed and scheduled time should be absolute timestamp");
1457         require(oraclize_getPrice("URL", gasLimit) * _iters <= address(this).balance, "Insufficient Funds");
1458         for (uint256 i = 0; i < _iters; i++) {
1459             uint256 scheduledTime = _startTime + (i * _interval);
1460             requestId = oraclize_query(scheduledTime, "URL", oracleURL, gasLimit);
1461             requestIds[requestId] = scheduledTime;
1462             emit LogNewOraclizeQuery(scheduledTime, requestId, oracleURL);
1463         }
1464         if (latestScheduledUpdate < requestIds[requestId]) {
1465             latestScheduledUpdate = requestIds[requestId];
1466         }
1467     }
1468 
1469     /**
1470     * @notice Allows owner to manually set POLYUSD price
1471     * @param _price POLYUSD price
1472     */
1473     function setPOLYUSD(uint256 _price) onlyOwner public {
1474         emit LogPriceUpdated(_price, POLYUSD, 0, now);
1475         POLYUSD = _price;
1476         latestUpdate = now;
1477     }
1478 
1479     /**
1480     * @notice Allows owner to set oracle to ignore all Oraclize pricce updates
1481     * @param _frozen true to freeze updates, false to reenable updates
1482     */
1483     function setFreezeOracle(bool _frozen) onlyOwner public {
1484         freezeOracle = _frozen;
1485     }
1486 
1487     /**
1488     * @notice Allows owner to set URL used in Oraclize queries
1489     * @param _oracleURL URL to use
1490     */
1491     function setOracleURL(string _oracleURL) onlyOwner public {
1492         oracleURL = _oracleURL;
1493     }
1494 
1495     /**
1496     * @notice Allows owner to set new sanity bounds for price updates
1497     * @param _sanityBounds sanity bounds as a percentage * 10**16
1498     */
1499     function setSanityBounds(uint256 _sanityBounds) onlyOwner public {
1500         sanityBounds = _sanityBounds;
1501     }
1502 
1503     /**
1504     * @notice Allows owner to set new gas price for future Oraclize queries
1505     * @notice NB - this will only impact newly scheduled Oraclize queries, not future queries which have already been scheduled
1506     * @param _gasPrice gas price to use for Oraclize callbacks
1507     */
1508     function setGasPrice(uint256 _gasPrice) onlyOwner public {
1509         oraclize_setCustomGasPrice(_gasPrice);
1510     }
1511 
1512     /**
1513     * @notice Returns price and corresponding update time
1514     * @return latest POLYUSD price
1515     * @return timestamp of latest price update
1516     */
1517     function getPriceAndTime() view public returns(uint256, uint256) {
1518         return (POLYUSD, latestUpdate);
1519     }
1520 
1521     /**
1522     * @notice Allows owner to set new gas limit on Oraclize queries
1523     * @notice NB - this will only impact newly scheduled Oraclize queries, not future queries which have already been scheduled
1524     * @param _gasLimit gas limit to use for Oraclize callbacks
1525     */
1526     function setGasLimit(uint256 _gasLimit) isAdminOrOwner public {
1527         gasLimit = _gasLimit;
1528     }
1529 
1530     /**
1531     * @notice Allows owner to set time after which price is considered stale
1532     * @param _staleTime elapsed time after which price is considered stale
1533     */
1534     function setStaleTime(uint256 _staleTime) onlyOwner public {
1535         staleTime = _staleTime;
1536     }
1537 
1538     /**
1539     * @notice Allows owner to ignore specific requestId results from Oraclize
1540     * @param _requestIds Oraclize queryIds (as logged out when Oraclize query is scheduled)
1541     * @param _ignore whether or not they should be ignored
1542     */
1543     function setIgnoreRequestIds(bytes32[] _requestIds, bool[] _ignore) onlyOwner public {
1544         require(_requestIds.length == _ignore.length, "Incorrect parameter lengths");
1545         for (uint256 i = 0; i < _requestIds.length; i++) {
1546             ignoreRequestIds[_requestIds[i]] = _ignore[i];
1547         }
1548     }
1549 
1550     /**
1551     * @notice Allows owner to set up admin addresses that can schedule updates
1552     * @param _admin Admin address
1553     * @param _valid Whether address should be added or removed from admin list
1554     */
1555     function setAdmin(address _admin, bool _valid) onlyOwner public {
1556         admin[_admin] = _valid;
1557         emit LogAdminSet(_admin, _valid, now);
1558     }
1559 
1560     /**
1561     * @notice Allows owner to set new time tolerance on Oraclize queries
1562     * @param _oraclizeTimeTolerance amount of time in seconds that an Oraclize query can be early
1563     */
1564     function setOraclizeTimeTolerance(uint256 _oraclizeTimeTolerance) onlyOwner public {
1565         oraclizeTimeTolerance = _oraclizeTimeTolerance;
1566     }
1567 
1568     /**
1569     * @notice Returns address of oracle currency (0x0 for ETH)
1570     */
1571     function getCurrencyAddress() external view returns(address) {
1572         return 0x9992eC3cF6A55b00978cdDF2b27BC6882d88D1eC;
1573     }
1574 
1575     /**
1576     * @notice Returns symbol of oracle currency (0x0 for ETH)
1577     */
1578     function getCurrencySymbol() external view returns(bytes32) {
1579         return bytes32("POLY");
1580     }
1581 
1582     /**
1583     * @notice Returns denomination of price
1584     */
1585     function getCurrencyDenominated() external view returns(bytes32) {
1586         return bytes32("USD");
1587     }
1588 
1589     /**
1590     * @notice Returns price - should throw if not valid
1591     */
1592     function getPrice() external view returns(uint256) {
1593         require(latestUpdate >= now - staleTime);
1594         return POLYUSD;
1595     }
1596 
1597     /**
1598     * @notice Returns balance to owner
1599     */
1600     function drainContract() external onlyOwner {
1601         msg.sender.transfer(address(this).balance);
1602     }
1603 
1604 }