1 // File: contracts\oraclize.sol
2 
3 // <ORACLIZE_API>
4 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
5 /*
6 Copyright (c) 2015-2016 Oraclize SRL
7 Copyright (c) 2016 Oraclize LTD
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 The above copyright notice and this permission notice shall be included in
15 all copies or substantial portions of the Software.
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
22 THE SOFTWARE.
23 */
24 
25 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
26 
27 pragma solidity 0.4.25;
28 
29 contract OraclizeI {
30     address public cbAddress;
31     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
32     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
33     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
34     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
35     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
36     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
37     function getPrice(string _datasource) public returns (uint _dsprice);
38     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
39     function setProofType(byte _proofType) external;
40     function setCustomGasPrice(uint _gasPrice) external;
41     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
42 }
43 
44 contract OraclizeAddrResolverI {
45     function getAddress() public returns (address _addr);
46 }
47 
48 /*
49 Begin solidity-cborutils
50 https://github.com/smartcontractkit/solidity-cborutils
51 MIT License
52 Copyright (c) 2018 SmartContract ChainLink, Ltd.
53 Permission is hereby granted, free of charge, to any person obtaining a copy
54 of this software and associated documentation files (the "Software"), to deal
55 in the Software without restriction, including without limitation the rights
56 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
57 copies of the Software, and to permit persons to whom the Software is
58 furnished to do so, subject to the following conditions:
59 The above copyright notice and this permission notice shall be included in all
60 copies or substantial portions of the Software.
61 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
62 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
63 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
64 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
65 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
66 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
67 SOFTWARE.
68  */
69 
70 library Buffer {
71     struct buffer {
72         bytes buf;
73         uint capacity;
74     }
75 
76     function init(buffer memory buf, uint _capacity) internal pure {
77         uint capacity = _capacity;
78         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
79         // Allocate space for the buffer data
80         buf.capacity = capacity;
81         assembly {
82             let ptr := mload(0x40)
83             mstore(buf, ptr)
84             mstore(ptr, 0)
85             mstore(0x40, add(ptr, capacity))
86         }
87     }
88 
89     function resize(buffer memory buf, uint capacity) private pure {
90         bytes memory oldbuf = buf.buf;
91         init(buf, capacity);
92         append(buf, oldbuf);
93     }
94 
95     function max(uint a, uint b) private pure returns(uint) {
96         if(a > b) {
97             return a;
98         }
99         return b;
100     }
101 
102     /**
103      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
104      *      would exceed the capacity of the buffer.
105      * @param buf The buffer to append to.
106      * @param data The data to append.
107      * @return The original buffer.
108      */
109     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
110         if(data.length + buf.buf.length > buf.capacity) {
111             resize(buf, max(buf.capacity, data.length) * 2);
112         }
113 
114         uint dest;
115         uint src;
116         uint len = data.length;
117         assembly {
118         // Memory address of the buffer data
119             let bufptr := mload(buf)
120         // Length of existing buffer data
121             let buflen := mload(bufptr)
122         // Start address = buffer address + buffer length + sizeof(buffer length)
123             dest := add(add(bufptr, buflen), 32)
124         // Update buffer length
125             mstore(bufptr, add(buflen, mload(data)))
126             src := add(data, 32)
127         }
128 
129         // Copy word-length chunks while possible
130         for(; len >= 32; len -= 32) {
131             assembly {
132                 mstore(dest, mload(src))
133             }
134             dest += 32;
135             src += 32;
136         }
137 
138         // Copy remaining bytes
139         uint mask = 256 ** (32 - len) - 1;
140         assembly {
141             let srcpart := and(mload(src), not(mask))
142             let destpart := and(mload(dest), mask)
143             mstore(dest, or(destpart, srcpart))
144         }
145 
146         return buf;
147     }
148 
149     /**
150      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
151      * exceed the capacity of the buffer.
152      * @param buf The buffer to append to.
153      * @param data The data to append.
154      * @return The original buffer.
155      */
156     function append(buffer memory buf, uint8 data) internal pure {
157         if(buf.buf.length + 1 > buf.capacity) {
158             resize(buf, buf.capacity * 2);
159         }
160 
161         assembly {
162         // Memory address of the buffer data
163             let bufptr := mload(buf)
164         // Length of existing buffer data
165             let buflen := mload(bufptr)
166         // Address = buffer address + buffer length + sizeof(buffer length)
167             let dest := add(add(bufptr, buflen), 32)
168             mstore8(dest, data)
169         // Update buffer length
170             mstore(bufptr, add(buflen, 1))
171         }
172     }
173 
174     /**
175      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
176      * exceed the capacity of the buffer.
177      * @param buf The buffer to append to.
178      * @param data The data to append.
179      * @return The original buffer.
180      */
181     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
182         if(len + buf.buf.length > buf.capacity) {
183             resize(buf, max(buf.capacity, len) * 2);
184         }
185 
186         uint mask = 256 ** len - 1;
187         assembly {
188         // Memory address of the buffer data
189             let bufptr := mload(buf)
190         // Length of existing buffer data
191             let buflen := mload(bufptr)
192         // Address = buffer address + buffer length + sizeof(buffer length) + len
193             let dest := add(add(bufptr, buflen), len)
194             mstore(dest, or(and(mload(dest), not(mask)), data))
195         // Update buffer length
196             mstore(bufptr, add(buflen, len))
197         }
198         return buf;
199     }
200 }
201 
202 library CBOR {
203     using Buffer for Buffer.buffer;
204 
205     uint8 private constant MAJOR_TYPE_INT = 0;
206     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
207     uint8 private constant MAJOR_TYPE_BYTES = 2;
208     uint8 private constant MAJOR_TYPE_STRING = 3;
209     uint8 private constant MAJOR_TYPE_ARRAY = 4;
210     uint8 private constant MAJOR_TYPE_MAP = 5;
211     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
212 
213     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
214         if(value <= 23) {
215             buf.append(uint8((major << 5) | value));
216         } else if(value <= 0xFF) {
217             buf.append(uint8((major << 5) | 24));
218             buf.appendInt(value, 1);
219         } else if(value <= 0xFFFF) {
220             buf.append(uint8((major << 5) | 25));
221             buf.appendInt(value, 2);
222         } else if(value <= 0xFFFFFFFF) {
223             buf.append(uint8((major << 5) | 26));
224             buf.appendInt(value, 4);
225         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
226             buf.append(uint8((major << 5) | 27));
227             buf.appendInt(value, 8);
228         }
229     }
230 
231     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
232         buf.append(uint8((major << 5) | 31));
233     }
234 
235     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
236         encodeType(buf, MAJOR_TYPE_INT, value);
237     }
238 
239     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
240         if(value >= 0) {
241             encodeType(buf, MAJOR_TYPE_INT, uint(value));
242         } else {
243             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
244         }
245     }
246 
247     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
248         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
249         buf.append(value);
250     }
251 
252     function encodeString(Buffer.buffer memory buf, string value) internal pure {
253         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
254         buf.append(bytes(value));
255     }
256 
257     function startArray(Buffer.buffer memory buf) internal pure {
258         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
259     }
260 
261     function startMap(Buffer.buffer memory buf) internal pure {
262         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
263     }
264 
265     function endSequence(Buffer.buffer memory buf) internal pure {
266         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
267     }
268 }
269 
270 /*
271 End solidity-cborutils
272  */
273 
274 contract usingOraclize {
275     uint constant day = 60*60*24;
276     uint constant week = 60*60*24*7;
277     uint constant month = 60*60*24*30;
278     byte constant proofType_NONE = 0x00;
279     byte constant proofType_TLSNotary = 0x10;
280     byte constant proofType_Ledger = 0x30;
281     byte constant proofType_Android = 0x40;
282     byte constant proofType_Native = 0xF0;
283     byte constant proofStorage_IPFS = 0x01;
284     uint8 constant networkID_auto = 0;
285     uint8 constant networkID_mainnet = 1;
286     uint8 constant networkID_testnet = 2;
287     uint8 constant networkID_morden = 2;
288     uint8 constant networkID_consensys = 161;
289 
290     OraclizeAddrResolverI OAR;
291 
292     OraclizeI oraclize;
293     modifier oraclizeAPI {
294         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
295             oraclize_setNetwork(networkID_auto);
296 
297         if(address(oraclize) != OAR.getAddress())
298             oraclize = OraclizeI(OAR.getAddress());
299 
300         _;
301     }
302     modifier coupon(string code){
303         oraclize = OraclizeI(OAR.getAddress());
304         _;
305     }
306 
307     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
308         return oraclize_setNetwork();
309         networkID; // silence the warning and remain backwards compatible
310     }
311     function oraclize_setNetwork() internal returns(bool){
312         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
313             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
314             oraclize_setNetworkName("eth_mainnet");
315             return true;
316         }
317         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
318             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
319             oraclize_setNetworkName("eth_ropsten3");
320             return true;
321         }
322         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
323             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
324             oraclize_setNetworkName("eth_kovan");
325             return true;
326         }
327         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
328             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
329             oraclize_setNetworkName("eth_rinkeby");
330             return true;
331         }
332         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
333             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
334             return true;
335         }
336         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
337             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
338             return true;
339         }
340         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
341             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
342             return true;
343         }
344         return false;
345     }
346 
347     function __callback(bytes32 myid, string result) public {
348         __callback(myid, result, new bytes(0));
349     }
350     function __callback(bytes32 myid, string result, bytes proof) public {
351         return;
352         // Following should never be reached with a preceding return, however
353         // this is just a placeholder function, ideally meant to be defined in
354         // child contract when proofs are used
355         myid; result; proof; // Silence compiler warnings
356         oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
357     }
358 
359     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
360         return oraclize.getPrice(datasource);
361     }
362 
363     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
364         return oraclize.getPrice(datasource, gaslimit);
365     }
366 
367     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
368         uint price = oraclize.getPrice(datasource);
369         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
370         return oraclize.query.value(price)(0, datasource, arg);
371     }
372     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource);
374         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
375         return oraclize.query.value(price)(timestamp, datasource, arg);
376     }
377     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource, gaslimit);
379         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
380         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
381     }
382     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
386     }
387     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource);
389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
391     }
392     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
396     }
397     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource, gaslimit);
399         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
400         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
401     }
402     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
406     }
407     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource);
409         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410         bytes memory args = stra2cbor(argN);
411         return oraclize.queryN.value(price)(0, datasource, args);
412     }
413     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource);
415         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
416         bytes memory args = stra2cbor(argN);
417         return oraclize.queryN.value(price)(timestamp, datasource, args);
418     }
419     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource, gaslimit);
421         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
422         bytes memory args = stra2cbor(argN);
423         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
424     }
425     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource, gaslimit);
427         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
428         bytes memory args = stra2cbor(argN);
429         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
430     }
431     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
432         string[] memory dynargs = new string[](1);
433         dynargs[0] = args[0];
434         return oraclize_query(datasource, dynargs);
435     }
436     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
437         string[] memory dynargs = new string[](1);
438         dynargs[0] = args[0];
439         return oraclize_query(timestamp, datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(datasource, dynargs, gaslimit);
450     }
451 
452     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](2);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         return oraclize_query(datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](2);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](2);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         return oraclize_query(datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](3);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         return oraclize_query(datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](3);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         return oraclize_query(timestamp, datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](3);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
496     }
497     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](3);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         return oraclize_query(datasource, dynargs, gaslimit);
503     }
504 
505     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(datasource, dynargs);
512     }
513     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
514         string[] memory dynargs = new string[](4);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         return oraclize_query(timestamp, datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](4);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
528     }
529     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](4);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         return oraclize_query(datasource, dynargs, gaslimit);
536     }
537     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
538         string[] memory dynargs = new string[](5);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         dynargs[4] = args[4];
544         return oraclize_query(datasource, dynargs);
545     }
546     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
547         string[] memory dynargs = new string[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(timestamp, datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
556         string[] memory dynargs = new string[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
563     }
564     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         string[] memory dynargs = new string[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
574         uint price = oraclize.getPrice(datasource);
575         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
576         bytes memory args = ba2cbor(argN);
577         return oraclize.queryN.value(price)(0, datasource, args);
578     }
579     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
580         uint price = oraclize.getPrice(datasource);
581         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
582         bytes memory args = ba2cbor(argN);
583         return oraclize.queryN.value(price)(timestamp, datasource, args);
584     }
585     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
586         uint price = oraclize.getPrice(datasource, gaslimit);
587         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
588         bytes memory args = ba2cbor(argN);
589         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
590     }
591     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
592         uint price = oraclize.getPrice(datasource, gaslimit);
593         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
594         bytes memory args = ba2cbor(argN);
595         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
596     }
597     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
598         bytes[] memory dynargs = new bytes[](1);
599         dynargs[0] = args[0];
600         return oraclize_query(datasource, dynargs);
601     }
602     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
603         bytes[] memory dynargs = new bytes[](1);
604         dynargs[0] = args[0];
605         return oraclize_query(timestamp, datasource, dynargs);
606     }
607     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](1);
609         dynargs[0] = args[0];
610         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](1);
614         dynargs[0] = args[0];
615         return oraclize_query(datasource, dynargs, gaslimit);
616     }
617 
618     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](2);
620         dynargs[0] = args[0];
621         dynargs[1] = args[1];
622         return oraclize_query(datasource, dynargs);
623     }
624     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](2);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         return oraclize_query(timestamp, datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](2);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
635     }
636     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](2);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         return oraclize_query(datasource, dynargs, gaslimit);
641     }
642     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](3);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         dynargs[2] = args[2];
647         return oraclize_query(datasource, dynargs);
648     }
649     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](3);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         dynargs[2] = args[2];
654         return oraclize_query(timestamp, datasource, dynargs);
655     }
656     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](3);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
662     }
663     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](3);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         return oraclize_query(datasource, dynargs, gaslimit);
669     }
670 
671     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](4);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         return oraclize_query(datasource, dynargs);
678     }
679     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
680         bytes[] memory dynargs = new bytes[](4);
681         dynargs[0] = args[0];
682         dynargs[1] = args[1];
683         dynargs[2] = args[2];
684         dynargs[3] = args[3];
685         return oraclize_query(timestamp, datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](4);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         dynargs[3] = args[3];
693         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
694     }
695     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](4);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         dynargs[3] = args[3];
701         return oraclize_query(datasource, dynargs, gaslimit);
702     }
703     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
704         bytes[] memory dynargs = new bytes[](5);
705         dynargs[0] = args[0];
706         dynargs[1] = args[1];
707         dynargs[2] = args[2];
708         dynargs[3] = args[3];
709         dynargs[4] = args[4];
710         return oraclize_query(datasource, dynargs);
711     }
712     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
713         bytes[] memory dynargs = new bytes[](5);
714         dynargs[0] = args[0];
715         dynargs[1] = args[1];
716         dynargs[2] = args[2];
717         dynargs[3] = args[3];
718         dynargs[4] = args[4];
719         return oraclize_query(timestamp, datasource, dynargs);
720     }
721     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
722         bytes[] memory dynargs = new bytes[](5);
723         dynargs[0] = args[0];
724         dynargs[1] = args[1];
725         dynargs[2] = args[2];
726         dynargs[3] = args[3];
727         dynargs[4] = args[4];
728         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
729     }
730     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
731         bytes[] memory dynargs = new bytes[](5);
732         dynargs[0] = args[0];
733         dynargs[1] = args[1];
734         dynargs[2] = args[2];
735         dynargs[3] = args[3];
736         dynargs[4] = args[4];
737         return oraclize_query(datasource, dynargs, gaslimit);
738     }
739 
740     function oraclize_cbAddress() oraclizeAPI internal returns (address){
741         return oraclize.cbAddress();
742     }
743     function oraclize_setProof(byte proofP) oraclizeAPI internal {
744         return oraclize.setProofType(proofP);
745     }
746     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
747         return oraclize.setCustomGasPrice(gasPrice);
748     }
749 
750     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
751         return oraclize.randomDS_getSessionPubKeyHash();
752     }
753 
754     function getCodeSize(address _addr) view internal returns(uint _size) {
755         assembly {
756             _size := extcodesize(_addr)
757         }
758     }
759 
760     function parseAddr(string _a) internal pure returns (address){
761         bytes memory tmp = bytes(_a);
762         uint160 iaddr = 0;
763         uint160 b1;
764         uint160 b2;
765         for (uint i=2; i<2+2*20; i+=2){
766             iaddr *= 256;
767             b1 = uint160(tmp[i]);
768             b2 = uint160(tmp[i+1]);
769             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
770             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
771             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
772             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
773             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
774             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
775             iaddr += (b1*16+b2);
776         }
777         return address(iaddr);
778     }
779 
780     function strCompare(string _a, string _b) internal pure returns (int) {
781         bytes memory a = bytes(_a);
782         bytes memory b = bytes(_b);
783         uint minLength = a.length;
784         if (b.length < minLength) minLength = b.length;
785         for (uint i = 0; i < minLength; i ++)
786             if (a[i] < b[i])
787                 return -1;
788             else if (a[i] > b[i])
789                 return 1;
790         if (a.length < b.length)
791             return -1;
792         else if (a.length > b.length)
793             return 1;
794         else
795             return 0;
796     }
797 
798     function indexOf(string _haystack, string _needle) internal pure returns (int) {
799         bytes memory h = bytes(_haystack);
800         bytes memory n = bytes(_needle);
801         if(h.length < 1 || n.length < 1 || (n.length > h.length))
802             return -1;
803         else if(h.length > (2**128 -1))
804             return -1;
805         else
806         {
807             uint subindex = 0;
808             for (uint i = 0; i < h.length; i ++)
809             {
810                 if (h[i] == n[0])
811                 {
812                     subindex = 1;
813                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
814                     {
815                         subindex++;
816                     }
817                     if(subindex == n.length)
818                         return int(i);
819                 }
820             }
821             return -1;
822         }
823     }
824 
825     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
826         bytes memory _ba = bytes(_a);
827         bytes memory _bb = bytes(_b);
828         bytes memory _bc = bytes(_c);
829         bytes memory _bd = bytes(_d);
830         bytes memory _be = bytes(_e);
831         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
832         bytes memory babcde = bytes(abcde);
833         uint k = 0;
834         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
835         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
836         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
837         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
838         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
839         return string(babcde);
840     }
841 
842     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
843         return strConcat(_a, _b, _c, _d, "");
844     }
845 
846     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
847         return strConcat(_a, _b, _c, "", "");
848     }
849 
850     function strConcat(string _a, string _b) internal pure returns (string) {
851         return strConcat(_a, _b, "", "", "");
852     }
853 
854     // parseInt
855     function parseInt(string _a) internal pure returns (uint) {
856         return parseInt(_a, 0);
857     }
858 
859     // parseInt(parseFloat*10^_b)
860     function parseInt(string _a, uint _b) internal pure returns (uint) {
861         bytes memory bresult = bytes(_a);
862         uint mint = 0;
863         bool decimals = false;
864         for (uint i=0; i<bresult.length; i++){
865             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
866                 if (decimals){
867                     if (_b == 0) break;
868                     else _b--;
869                 }
870                 mint *= 10;
871                 mint += uint(bresult[i]) - 48;
872             } else if (bresult[i] == 46) decimals = true;
873         }
874         if (_b > 0) mint *= 10**_b;
875         return mint;
876     }
877 
878     function uint2str(uint i) internal pure returns (string){
879         if (i == 0) return "0";
880         uint j = i;
881         uint len;
882         while (j != 0){
883             len++;
884             j /= 10;
885         }
886         bytes memory bstr = new bytes(len);
887         uint k = len - 1;
888         while (i != 0){
889             bstr[k--] = byte(48 + i % 10);
890             i /= 10;
891         }
892         return string(bstr);
893     }
894 
895     using CBOR for Buffer.buffer;
896     function stra2cbor(string[] arr) internal pure returns (bytes) {
897         safeMemoryCleaner();
898         Buffer.buffer memory buf;
899         Buffer.init(buf, 1024);
900         buf.startArray();
901         for (uint i = 0; i < arr.length; i++) {
902             buf.encodeString(arr[i]);
903         }
904         buf.endSequence();
905         return buf.buf;
906     }
907 
908     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
909         safeMemoryCleaner();
910         Buffer.buffer memory buf;
911         Buffer.init(buf, 1024);
912         buf.startArray();
913         for (uint i = 0; i < arr.length; i++) {
914             buf.encodeBytes(arr[i]);
915         }
916         buf.endSequence();
917         return buf.buf;
918     }
919 
920     string oraclize_network_name;
921     function oraclize_setNetworkName(string _network_name) internal {
922         oraclize_network_name = _network_name;
923     }
924 
925     function oraclize_getNetworkName() internal view returns (string) {
926         return oraclize_network_name;
927     }
928 
929     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
930         require((_nbytes > 0) && (_nbytes <= 32));
931         // Convert from seconds to ledger timer ticks
932         _delay *= 10;
933         bytes memory nbytes = new bytes(1);
934         nbytes[0] = byte(_nbytes);
935         bytes memory unonce = new bytes(32);
936         bytes memory sessionKeyHash = new bytes(32);
937         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
938         assembly {
939             mstore(unonce, 0x20)
940         // the following variables can be relaxed
941         // check relaxed random contract under ethereum-examples repo
942         // for an idea on how to override and replace comit hash vars
943             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
944             mstore(sessionKeyHash, 0x20)
945             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
946         }
947         bytes memory delay = new bytes(32);
948         assembly {
949             mstore(add(delay, 0x20), _delay)
950         }
951 
952         bytes memory delay_bytes8 = new bytes(8);
953         copyBytes(delay, 24, 8, delay_bytes8, 0);
954 
955         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
956         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
957 
958         bytes memory delay_bytes8_left = new bytes(8);
959 
960         assembly {
961             let x := mload(add(delay_bytes8, 0x20))
962             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
970 
971         }
972 
973         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
974         return queryId;
975     }
976 
977     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
978         oraclize_randomDS_args[queryId] = commitment;
979     }
980 
981     mapping(bytes32=>bytes32) oraclize_randomDS_args;
982     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
983 
984     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
985         bool sigok;
986         address signer;
987 
988         bytes32 sigr;
989         bytes32 sigs;
990 
991         bytes memory sigr_ = new bytes(32);
992         uint offset = 4+(uint(dersig[3]) - 0x20);
993         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
994         bytes memory sigs_ = new bytes(32);
995         offset += 32 + 2;
996         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
997 
998         assembly {
999             sigr := mload(add(sigr_, 32))
1000             sigs := mload(add(sigs_, 32))
1001         }
1002 
1003 
1004         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1005         if (address(keccak256(pubkey)) == signer) return true;
1006         else {
1007             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1008             return (address(keccak256(pubkey)) == signer);
1009         }
1010     }
1011 
1012     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1013         bool sigok;
1014 
1015         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1016         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1017         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1018 
1019         bytes memory appkey1_pubkey = new bytes(64);
1020         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1021 
1022         bytes memory tosign2 = new bytes(1+65+32);
1023         tosign2[0] = byte(1); //role
1024         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1025         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1026         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1027         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1028 
1029         if (sigok == false) return false;
1030 
1031 
1032         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1033         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1034 
1035         bytes memory tosign3 = new bytes(1+65);
1036         tosign3[0] = 0xFE;
1037         copyBytes(proof, 3, 65, tosign3, 1);
1038 
1039         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1040         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1041 
1042         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1043 
1044         return sigok;
1045     }
1046 
1047     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1048         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1049         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1050 
1051         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1052         require(proofVerified);
1053 
1054         _;
1055     }
1056 
1057     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1058         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1059         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1060 
1061         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1062         if (proofVerified == false) return 2;
1063 
1064         return 0;
1065     }
1066 
1067     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1068         bool match_ = true;
1069 
1070         require(prefix.length == n_random_bytes);
1071 
1072         for (uint256 i=0; i< n_random_bytes; i++) {
1073             if (content[i] != prefix[i]) match_ = false;
1074         }
1075 
1076         return match_;
1077     }
1078 
1079     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1080 
1081         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1082         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1083         bytes memory keyhash = new bytes(32);
1084         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1085         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1086 
1087         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1088         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1089 
1090         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1091         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1092 
1093         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1094         // This is to verify that the computed args match with the ones specified in the query.
1095         bytes memory commitmentSlice1 = new bytes(8+1+32);
1096         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1097 
1098         bytes memory sessionPubkey = new bytes(64);
1099         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1100         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1101 
1102         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1103         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1104             delete oraclize_randomDS_args[queryId];
1105         } else return false;
1106 
1107 
1108         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1109         bytes memory tosign1 = new bytes(32+8+1+32);
1110         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1111         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1112 
1113         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1114         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1115             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1116         }
1117 
1118         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1119     }
1120 
1121     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1122     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1123         uint minLength = length + toOffset;
1124 
1125         // Buffer too small
1126         require(to.length >= minLength); // Should be a better way?
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
1164         // NOTE: we can reuse the request memory because we deal with
1165         //       the return code
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
1180             return (false, 0);
1181 
1182         // The signature format is a compact form of:
1183         //   {bytes32 r}{bytes32 s}{uint8 v}
1184         // Compact means, uint8 is not padded to 32 bytes.
1185         assembly {
1186             r := mload(add(sig, 32))
1187             s := mload(add(sig, 64))
1188 
1189         // Here we are loading the last 32 bytes. We exploit the fact that
1190         // 'mload' will pad with zeroes if we overread.
1191         // There is no 'mload8' to do this, but that would be nicer.
1192             v := byte(0, mload(add(sig, 96)))
1193 
1194         // Alternative solution:
1195         // 'byte' is not working due to the Solidity parser, so lets
1196         // use the second best option, 'and'
1197         // v := and(mload(add(sig, 65)), 255)
1198         }
1199 
1200         // albeit non-transactional signatures are not specified by the YP, one would expect it
1201         // to match the YP range of [27, 28]
1202         //
1203         // geth uses [0, 1] and some clients have followed. This might change, see:
1204         //  https://github.com/ethereum/go-ethereum/issues/2053
1205         if (v < 27)
1206             v += 27;
1207 
1208         if (v != 27 && v != 28)
1209             return (false, 0);
1210 
1211         return safer_ecrecover(hash, v, r, s);
1212     }
1213 
1214     function safeMemoryCleaner() internal pure {
1215         assembly {
1216             let fmem := mload(0x40)
1217             codecopy(fmem, codesize, sub(msize, fmem))
1218         }
1219     }
1220 
1221 }
1222 // </ORACLIZE_API>
1223 
1224 // File: contracts\DrawContract.sol
1225 
1226 /**
1227  * Copyright (c) 2019 GG International Ltd
1228  */
1229 
1230 pragma solidity 0.4.25;
1231 
1232 
1233 contract DrawContract is usingOraclize {
1234 
1235     mapping(bytes32 => bool) validIds;
1236 
1237     event LogQueryId(bytes32 queryId);
1238     event LogNewOraclizeQuery(string description);
1239 
1240     address owner;
1241 
1242     constructor () payable public {
1243         owner = msg.sender;
1244     }
1245 
1246     function __callback(bytes32 myid, string result) public {
1247         if (!validIds[myid]) revert();
1248         if (msg.sender != oraclize_cbAddress()) revert();
1249         delete validIds[myid];
1250     }
1251 
1252     function draw(string url, string lotterySlug, string drawDate) payable external {
1253         require(msg.sender == owner);
1254         if (oraclize_getPrice("URL") > address(this).balance) {
1255             emit LogNewOraclizeQuery("false");
1256         } else {
1257             bytes32 queryId = oraclize_query("URL", url);
1258             validIds[queryId] = true;
1259             emit LogQueryId(queryId);
1260             emit LogNewOraclizeQuery("true");
1261         }
1262     }
1263 }