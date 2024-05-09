1 // <ORACLIZE_API>
2 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
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
23 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
24 
25 pragma solidity >= 0.4.22 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
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
350       // Following should never be reached with a preceding return, however
351       // this is just a placeholder function, ideally meant to be defined in
352       // child contract when proofs are used
353       myid; result; proof; // Silence compiler warnings
354       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
355     }
356 
357     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
358         return oraclize.getPrice(datasource);
359     }
360 
361     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
362         return oraclize.getPrice(datasource, gaslimit);
363     }
364 
365     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
366         uint price = oraclize.getPrice(datasource);
367         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
368         return oraclize.query.value(price)(0, datasource, arg);
369     }
370     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource);
372         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
373         return oraclize.query.value(price)(timestamp, datasource, arg);
374     }
375     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
376         uint price = oraclize.getPrice(datasource, gaslimit);
377         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
378         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
379     }
380     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
381         uint price = oraclize.getPrice(datasource, gaslimit);
382         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
383         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
384     }
385     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
386         uint price = oraclize.getPrice(datasource);
387         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
388         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
389     }
390     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource);
392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
393         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
394     }
395     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
399     }
400     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
401         uint price = oraclize.getPrice(datasource, gaslimit);
402         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
403         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
404     }
405     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource);
407         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
408         bytes memory args = stra2cbor(argN);
409         return oraclize.queryN.value(price)(0, datasource, args);
410     }
411     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource);
413         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
414         bytes memory args = stra2cbor(argN);
415         return oraclize.queryN.value(price)(timestamp, datasource, args);
416     }
417     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
418         uint price = oraclize.getPrice(datasource, gaslimit);
419         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
420         bytes memory args = stra2cbor(argN);
421         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
422     }
423     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
424         uint price = oraclize.getPrice(datasource, gaslimit);
425         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
426         bytes memory args = stra2cbor(argN);
427         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
428     }
429     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
430         string[] memory dynargs = new string[](1);
431         dynargs[0] = args[0];
432         return oraclize_query(datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](1);
436         dynargs[0] = args[0];
437         return oraclize_query(timestamp, datasource, dynargs);
438     }
439     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
440         string[] memory dynargs = new string[](1);
441         dynargs[0] = args[0];
442         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
443     }
444     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](1);
446         dynargs[0] = args[0];
447         return oraclize_query(datasource, dynargs, gaslimit);
448     }
449 
450     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](2);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         return oraclize_query(datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](2);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         return oraclize_query(timestamp, datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](2);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
467     }
468     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](2);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         return oraclize_query(datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
475         string[] memory dynargs = new string[](3);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         return oraclize_query(datasource, dynargs);
480     }
481     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](3);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         return oraclize_query(timestamp, datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](3);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
494     }
495     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](3);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         return oraclize_query(datasource, dynargs, gaslimit);
501     }
502 
503     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](4);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         return oraclize_query(datasource, dynargs);
510     }
511     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](4);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         dynargs[2] = args[2];
516         dynargs[3] = args[3];
517         return oraclize_query(timestamp, datasource, dynargs);
518     }
519     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
520         string[] memory dynargs = new string[](4);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         dynargs[3] = args[3];
525         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
526     }
527     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](4);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         dynargs[3] = args[3];
533         return oraclize_query(datasource, dynargs, gaslimit);
534     }
535     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
536         string[] memory dynargs = new string[](5);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         dynargs[4] = args[4];
542         return oraclize_query(datasource, dynargs);
543     }
544     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](5);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         dynargs[4] = args[4];
551         return oraclize_query(timestamp, datasource, dynargs);
552     }
553     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](5);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         dynargs[3] = args[3];
559         dynargs[4] = args[4];
560         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
561     }
562     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](5);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         dynargs[2] = args[2];
567         dynargs[3] = args[3];
568         dynargs[4] = args[4];
569         return oraclize_query(datasource, dynargs, gaslimit);
570     }
571     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
572         uint price = oraclize.getPrice(datasource);
573         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
574         bytes memory args = ba2cbor(argN);
575         return oraclize.queryN.value(price)(0, datasource, args);
576     }
577     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
578         uint price = oraclize.getPrice(datasource);
579         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
580         bytes memory args = ba2cbor(argN);
581         return oraclize.queryN.value(price)(timestamp, datasource, args);
582     }
583     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
584         uint price = oraclize.getPrice(datasource, gaslimit);
585         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
586         bytes memory args = ba2cbor(argN);
587         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
588     }
589     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
590         uint price = oraclize.getPrice(datasource, gaslimit);
591         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
592         bytes memory args = ba2cbor(argN);
593         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
594     }
595     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
596         bytes[] memory dynargs = new bytes[](1);
597         dynargs[0] = args[0];
598         return oraclize_query(datasource, dynargs);
599     }
600     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](1);
602         dynargs[0] = args[0];
603         return oraclize_query(timestamp, datasource, dynargs);
604     }
605     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
606         bytes[] memory dynargs = new bytes[](1);
607         dynargs[0] = args[0];
608         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
609     }
610     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](1);
612         dynargs[0] = args[0];
613         return oraclize_query(datasource, dynargs, gaslimit);
614     }
615 
616     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](2);
618         dynargs[0] = args[0];
619         dynargs[1] = args[1];
620         return oraclize_query(datasource, dynargs);
621     }
622     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](2);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         return oraclize_query(timestamp, datasource, dynargs);
627     }
628     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](2);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
633     }
634     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](2);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         return oraclize_query(datasource, dynargs, gaslimit);
639     }
640     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
641         bytes[] memory dynargs = new bytes[](3);
642         dynargs[0] = args[0];
643         dynargs[1] = args[1];
644         dynargs[2] = args[2];
645         return oraclize_query(datasource, dynargs);
646     }
647     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](3);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         return oraclize_query(timestamp, datasource, dynargs);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](3);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
660     }
661     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](3);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         return oraclize_query(datasource, dynargs, gaslimit);
667     }
668 
669     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](4);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         dynargs[3] = args[3];
675         return oraclize_query(datasource, dynargs);
676     }
677     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](4);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         dynargs[2] = args[2];
682         dynargs[3] = args[3];
683         return oraclize_query(timestamp, datasource, dynargs);
684     }
685     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
686         bytes[] memory dynargs = new bytes[](4);
687         dynargs[0] = args[0];
688         dynargs[1] = args[1];
689         dynargs[2] = args[2];
690         dynargs[3] = args[3];
691         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
692     }
693     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](4);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         dynargs[3] = args[3];
699         return oraclize_query(datasource, dynargs, gaslimit);
700     }
701     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
702         bytes[] memory dynargs = new bytes[](5);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         dynargs[3] = args[3];
707         dynargs[4] = args[4];
708         return oraclize_query(datasource, dynargs);
709     }
710     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](5);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         dynargs[2] = args[2];
715         dynargs[3] = args[3];
716         dynargs[4] = args[4];
717         return oraclize_query(timestamp, datasource, dynargs);
718     }
719     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](5);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         dynargs[3] = args[3];
725         dynargs[4] = args[4];
726         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
727     }
728     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](5);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         dynargs[2] = args[2];
733         dynargs[3] = args[3];
734         dynargs[4] = args[4];
735         return oraclize_query(datasource, dynargs, gaslimit);
736     }
737 
738     function oraclize_cbAddress() oraclizeAPI internal returns (address){
739         return oraclize.cbAddress();
740     }
741     function oraclize_setProof(byte proofP) oraclizeAPI internal {
742         return oraclize.setProofType(proofP);
743     }
744     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
745         return oraclize.setCustomGasPrice(gasPrice);
746     }
747 
748     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
749         return oraclize.randomDS_getSessionPubKeyHash();
750     }
751 
752     function getCodeSize(address _addr) view internal returns(uint _size) {
753         assembly {
754             _size := extcodesize(_addr)
755         }
756     }
757 
758     function parseAddr(string _a) internal pure returns (address){
759         bytes memory tmp = bytes(_a);
760         uint160 iaddr = 0;
761         uint160 b1;
762         uint160 b2;
763         for (uint i=2; i<2+2*20; i+=2){
764             iaddr *= 256;
765             b1 = uint160(tmp[i]);
766             b2 = uint160(tmp[i+1]);
767             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
768             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
769             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
770             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
771             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
772             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
773             iaddr += (b1*16+b2);
774         }
775         return address(iaddr);
776     }
777 
778     function strCompare(string _a, string _b) internal pure returns (int) {
779         bytes memory a = bytes(_a);
780         bytes memory b = bytes(_b);
781         uint minLength = a.length;
782         if (b.length < minLength) minLength = b.length;
783         for (uint i = 0; i < minLength; i ++)
784             if (a[i] < b[i])
785                 return -1;
786             else if (a[i] > b[i])
787                 return 1;
788         if (a.length < b.length)
789             return -1;
790         else if (a.length > b.length)
791             return 1;
792         else
793             return 0;
794     }
795 
796     function indexOf(string _haystack, string _needle) internal pure returns (int) {
797         bytes memory h = bytes(_haystack);
798         bytes memory n = bytes(_needle);
799         if(h.length < 1 || n.length < 1 || (n.length > h.length))
800             return -1;
801         else if(h.length > (2**128 -1))
802             return -1;
803         else
804         {
805             uint subindex = 0;
806             for (uint i = 0; i < h.length; i ++)
807             {
808                 if (h[i] == n[0])
809                 {
810                     subindex = 1;
811                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
812                     {
813                         subindex++;
814                     }
815                     if(subindex == n.length)
816                         return int(i);
817                 }
818             }
819             return -1;
820         }
821     }
822 
823     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
824         bytes memory _ba = bytes(_a);
825         bytes memory _bb = bytes(_b);
826         bytes memory _bc = bytes(_c);
827         bytes memory _bd = bytes(_d);
828         bytes memory _be = bytes(_e);
829         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
830         bytes memory babcde = bytes(abcde);
831         uint k = 0;
832         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
833         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
834         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
835         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
836         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
837         return string(babcde);
838     }
839 
840     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
841         return strConcat(_a, _b, _c, _d, "");
842     }
843 
844     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
845         return strConcat(_a, _b, _c, "", "");
846     }
847 
848     function strConcat(string _a, string _b) internal pure returns (string) {
849         return strConcat(_a, _b, "", "", "");
850     }
851 
852     // parseInt
853     function parseInt(string _a) internal pure returns (uint) {
854         return parseInt(_a, 0);
855     }
856 
857     // parseInt(parseFloat*10^_b)
858     function parseInt(string _a, uint _b) internal pure returns (uint) {
859         bytes memory bresult = bytes(_a);
860         uint mint = 0;
861         bool decimals = false;
862         for (uint i=0; i<bresult.length; i++){
863             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
864                 if (decimals){
865                    if (_b == 0) break;
866                     else _b--;
867                 }
868                 mint *= 10;
869                 mint += uint(bresult[i]) - 48;
870             } else if (bresult[i] == 46) decimals = true;
871         }
872         if (_b > 0) mint *= 10**_b;
873         return mint;
874     }
875 
876     function uint2str(uint i) internal pure returns (string){
877         if (i == 0) return "0";
878         uint j = i;
879         uint len;
880         while (j != 0){
881             len++;
882             j /= 10;
883         }
884         bytes memory bstr = new bytes(len);
885         uint k = len - 1;
886         while (i != 0){
887             bstr[k--] = byte(48 + i % 10);
888             i /= 10;
889         }
890         return string(bstr);
891     }
892 
893     using CBOR for Buffer.buffer;
894     function stra2cbor(string[] arr) internal pure returns (bytes) {
895         safeMemoryCleaner();
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
906     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
907         safeMemoryCleaner();
908         Buffer.buffer memory buf;
909         Buffer.init(buf, 1024);
910         buf.startArray();
911         for (uint i = 0; i < arr.length; i++) {
912             buf.encodeBytes(arr[i]);
913         }
914         buf.endSequence();
915         return buf.buf;
916     }
917 
918     string oraclize_network_name;
919     function oraclize_setNetworkName(string _network_name) internal {
920         oraclize_network_name = _network_name;
921     }
922 
923     function oraclize_getNetworkName() internal view returns (string) {
924         return oraclize_network_name;
925     }
926 
927     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
928         require((_nbytes > 0) && (_nbytes <= 32));
929         // Convert from seconds to ledger timer ticks
930         _delay *= 10;
931         bytes memory nbytes = new bytes(1);
932         nbytes[0] = byte(_nbytes);
933         bytes memory unonce = new bytes(32);
934         bytes memory sessionKeyHash = new bytes(32);
935         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
936         assembly {
937             mstore(unonce, 0x20)
938             // the following variables can be relaxed
939             // check relaxed random contract under ethereum-examples repo
940             // for an idea on how to override and replace comit hash vars
941             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
942             mstore(sessionKeyHash, 0x20)
943             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
944         }
945         bytes memory delay = new bytes(32);
946         assembly {
947             mstore(add(delay, 0x20), _delay)
948         }
949 
950         bytes memory delay_bytes8 = new bytes(8);
951         copyBytes(delay, 24, 8, delay_bytes8, 0);
952 
953         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
954         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
955 
956         bytes memory delay_bytes8_left = new bytes(8);
957 
958         assembly {
959             let x := mload(add(delay_bytes8, 0x20))
960             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
961             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
962             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
968 
969         }
970 
971         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
972         return queryId;
973     }
974 
975     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
976         oraclize_randomDS_args[queryId] = commitment;
977     }
978 
979     mapping(bytes32=>bytes32) oraclize_randomDS_args;
980     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
981 
982     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
983         bool sigok;
984         address signer;
985 
986         bytes32 sigr;
987         bytes32 sigs;
988 
989         bytes memory sigr_ = new bytes(32);
990         uint offset = 4+(uint(dersig[3]) - 0x20);
991         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
992         bytes memory sigs_ = new bytes(32);
993         offset += 32 + 2;
994         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
995 
996         assembly {
997             sigr := mload(add(sigr_, 32))
998             sigs := mload(add(sigs_, 32))
999         }
1000 
1001 
1002         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1003         if (address(keccak256(pubkey)) == signer) return true;
1004         else {
1005             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1006             return (address(keccak256(pubkey)) == signer);
1007         }
1008     }
1009 
1010     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1011         bool sigok;
1012 
1013         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1014         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1015         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1016 
1017         bytes memory appkey1_pubkey = new bytes(64);
1018         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1019 
1020         bytes memory tosign2 = new bytes(1+65+32);
1021         tosign2[0] = byte(1); //role
1022         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1023         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1024         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1025         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1026 
1027         if (sigok == false) return false;
1028 
1029 
1030         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1031         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1032 
1033         bytes memory tosign3 = new bytes(1+65);
1034         tosign3[0] = 0xFE;
1035         copyBytes(proof, 3, 65, tosign3, 1);
1036 
1037         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1038         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1039 
1040         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1041 
1042         return sigok;
1043     }
1044 
1045     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1046         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1047         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1048 
1049         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1050         require(proofVerified);
1051 
1052         _;
1053     }
1054 
1055     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1056         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1057         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1058 
1059         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1060         if (proofVerified == false) return 2;
1061 
1062         return 0;
1063     }
1064 
1065     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1066         bool match_ = true;
1067 
1068         require(prefix.length == n_random_bytes);
1069 
1070         for (uint256 i=0; i< n_random_bytes; i++) {
1071             if (content[i] != prefix[i]) match_ = false;
1072         }
1073 
1074         return match_;
1075     }
1076 
1077     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1078 
1079         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1080         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1081         bytes memory keyhash = new bytes(32);
1082         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1083         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1084 
1085         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1086         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1087 
1088         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1089         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1090 
1091         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1092         // This is to verify that the computed args match with the ones specified in the query.
1093         bytes memory commitmentSlice1 = new bytes(8+1+32);
1094         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1095 
1096         bytes memory sessionPubkey = new bytes(64);
1097         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1098         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1099 
1100         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1101         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1102             delete oraclize_randomDS_args[queryId];
1103         } else return false;
1104 
1105 
1106         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1107         bytes memory tosign1 = new bytes(32+8+1+32);
1108         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1109         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1110 
1111         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1112         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1113             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1114         }
1115 
1116         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1117     }
1118 
1119     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1120     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1121         uint minLength = length + toOffset;
1122 
1123         // Buffer too small
1124         require(to.length >= minLength); // Should be a better way?
1125 
1126         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1127         uint i = 32 + fromOffset;
1128         uint j = 32 + toOffset;
1129 
1130         while (i < (32 + fromOffset + length)) {
1131             assembly {
1132                 let tmp := mload(add(from, i))
1133                 mstore(add(to, j), tmp)
1134             }
1135             i += 32;
1136             j += 32;
1137         }
1138 
1139         return to;
1140     }
1141 
1142     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1143     // Duplicate Solidity's ecrecover, but catching the CALL return value
1144     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1145         // We do our own memory management here. Solidity uses memory offset
1146         // 0x40 to store the current end of memory. We write past it (as
1147         // writes are memory extensions), but don't update the offset so
1148         // Solidity will reuse it. The memory used here is only needed for
1149         // this context.
1150 
1151         // FIXME: inline assembly can't access return values
1152         bool ret;
1153         address addr;
1154 
1155         assembly {
1156             let size := mload(0x40)
1157             mstore(size, hash)
1158             mstore(add(size, 32), v)
1159             mstore(add(size, 64), r)
1160             mstore(add(size, 96), s)
1161 
1162             // NOTE: we can reuse the request memory because we deal with
1163             //       the return code
1164             ret := call(3000, 1, 0, size, 128, size, 32)
1165             addr := mload(size)
1166         }
1167 
1168         return (ret, addr);
1169     }
1170 
1171     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1172     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1173         bytes32 r;
1174         bytes32 s;
1175         uint8 v;
1176 
1177         if (sig.length != 65)
1178           return (false, 0);
1179 
1180         // The signature format is a compact form of:
1181         //   {bytes32 r}{bytes32 s}{uint8 v}
1182         // Compact means, uint8 is not padded to 32 bytes.
1183         assembly {
1184             r := mload(add(sig, 32))
1185             s := mload(add(sig, 64))
1186 
1187             // Here we are loading the last 32 bytes. We exploit the fact that
1188             // 'mload' will pad with zeroes if we overread.
1189             // There is no 'mload8' to do this, but that would be nicer.
1190             v := byte(0, mload(add(sig, 96)))
1191 
1192             // Alternative solution:
1193             // 'byte' is not working due to the Solidity parser, so lets
1194             // use the second best option, 'and'
1195             // v := and(mload(add(sig, 65)), 255)
1196         }
1197 
1198         // albeit non-transactional signatures are not specified by the YP, one would expect it
1199         // to match the YP range of [27, 28]
1200         //
1201         // geth uses [0, 1] and some clients have followed. This might change, see:
1202         //  https://github.com/ethereum/go-ethereum/issues/2053
1203         if (v < 27)
1204           v += 27;
1205 
1206         if (v != 27 && v != 28)
1207             return (false, 0);
1208 
1209         return safer_ecrecover(hash, v, r, s);
1210     }
1211 
1212     function safeMemoryCleaner() internal pure {
1213         assembly {
1214             let fmem := mload(0x40)
1215             codecopy(fmem, codesize, sub(msize, fmem))
1216         }
1217     }
1218 
1219 }
1220 // </ORACLIZE_API>
1221 contract Owner {
1222     address public owner;
1223 
1224     modifier onlyOwner() {
1225         require(msg.sender == owner);
1226         _;
1227     }
1228 
1229     function Owner(address _owner) public {
1230         owner = _owner;
1231     }
1232 
1233     function changeOwner(address _newOwnerAddr) public onlyOwner {
1234         require(_newOwnerAddr != address(0));
1235         owner = _newOwnerAddr;
1236     }
1237 }
1238 
1239 /**
1240  * @title SafeMath
1241  * @dev Math operations with safety checks that throw on error
1242  */
1243 library SafeMath {
1244     /**
1245     * @dev Multiplies two numbers, throws on overflow.
1246     */
1247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1248         if (a == 0) {
1249             return 0;
1250         }
1251         uint256 c = a * b;
1252         assert(c / a == b);
1253         return c;
1254     }
1255 
1256     /**
1257     * @dev Integer division of two numbers, truncating the quotient.
1258     */
1259     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1260         // assert(b > 0); // Solidity automatically throws when dividing by 0
1261         uint256 c = a / b;
1262         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1263         return c;
1264     }
1265 
1266     /**
1267     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1268     */
1269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1270         assert(b <= a);
1271         return a - b;
1272     }
1273 
1274     /**
1275     * @dev Adds two numbers, throws on overflow.
1276     */
1277     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1278         uint256 c = a + b;
1279         assert(c >= a);
1280         return c;
1281     }
1282 }
1283 
1284 pragma solidity ^0.4.24;
1285 
1286 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1287 
1288 /**
1289  * @title Ownable
1290  * @dev The Ownable contract has an owner address, and provides basic authorization control
1291  * functions, this simplifies the implementation of "user permissions".
1292  */
1293 contract Ownable {
1294     address public owner;
1295 
1296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1297 
1298     /**
1299      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1300      * account.
1301      */
1302     constructor() public {
1303         owner = msg.sender;
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         require(msg.sender == owner);
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1316      * @param newOwner The address to transfer ownership to.
1317      */
1318     function transferOwnership(address newOwner) public onlyOwner {
1319         require(newOwner != address(0));
1320         emit OwnershipTransferred(owner, newOwner);
1321         owner = newOwner;
1322     }
1323 }
1324 
1325 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
1326 
1327 /**
1328  * @title Contracts that should not own Contracts
1329  * @author Remco Bloemen <remco@2π.com>
1330  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
1331  * of this contract to reclaim ownership of the contracts.
1332  */
1333 contract HasNoContracts is Ownable{
1334     /**
1335      * @dev Reclaim ownership of Ownable contracts
1336      * @param contractAddr The address of the Ownable to be reclaimed.
1337      */
1338     function reclaimContract(address contractAddr) external onlyOwner {
1339         Ownable contractInst = Ownable(contractAddr);
1340         contractInst.transferOwnership(owner);
1341     }
1342 }
1343 
1344 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
1345 
1346 /**
1347  * @title Contracts that should not own Ether
1348  * @author Remco Bloemen <remco@2π.com>
1349  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
1350  * in the contract, it will allow the owner to reclaim this Ether.
1351  * @notice Ether can still be sent to this contract by:
1352  * calling functions labeled `payable`
1353  * `selfdestruct(contract_address)`
1354  * mining directly to the contract address
1355  */
1356 contract HasNoEther is Ownable {
1357     /**
1358     * @dev Constructor that rejects incoming Ether
1359     * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
1360     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
1361     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
1362     * we could use assembly to access msg.value.
1363     */
1364     constructor() public payable {
1365         require(msg.value == 0);
1366     }
1367 
1368     /**
1369      * @dev Disallows direct send by setting a default function without the `payable` flag.
1370      */
1371     function() external {
1372     }
1373 
1374     /**
1375      * @dev Transfer all Ether held by the contract to the owner.
1376      */
1377     function reclaimEther() external onlyOwner {
1378         owner.transfer(address(this).balance);
1379     }
1380 }
1381 
1382 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
1383 
1384 /**
1385  * @title ERC20Basic
1386  * @dev Simpler version of ERC20 interface
1387  * @dev see https://github.com/ethereum/EIPs/issues/179
1388  */
1389 contract ERC20Basic {
1390     function totalSupply() public view returns (uint256);
1391 
1392     function balanceOf(address who) public view returns (uint256);
1393 
1394     function transfer(address to, uint256 value) public returns (bool);
1395 
1396     event Transfer(address indexed from, address indexed to, uint256 value);
1397 }
1398 
1399 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1400 
1401 /**
1402  * @title ERC20 interface
1403  * @dev see https://github.com/ethereum/EIPs/issues/20
1404  */
1405 contract ERC20 is ERC20Basic {
1406     function allowance(address owner, address spender) public view returns (uint256);
1407 
1408     function transferFrom(address from, address to, uint256 value) public returns (bool);
1409 
1410     function approve(address spender, uint256 value) public returns (bool);
1411 
1412     event Approval(address indexed owner, address indexed spender, uint256 value);
1413 }
1414 
1415 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1416 
1417 /**
1418  * @title SafeERC20
1419  * @dev Wrappers around ERC20 operations that throw on failure.
1420  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1421  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1422  */
1423 library SafeERC20 {
1424     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1425         assert(token.transfer(to, value));
1426     }
1427 
1428     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1429         assert(token.transferFrom(from, to, value));
1430     }
1431 
1432     function safeApprove(ERC20 token, address spender, uint256 value) internal {
1433         assert(token.approve(spender, value));
1434     }
1435 }
1436 
1437 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
1438 
1439 /**
1440  * @title Contracts that should be able to recover tokens
1441  * @author SylTi
1442  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1443  * This will prevent any accidental loss of tokens.
1444  */
1445 contract CanReclaimToken is Ownable {
1446     using SafeERC20 for ERC20Basic;
1447 
1448     /**
1449      * @dev Reclaim all ERC20Basic compatible tokens
1450      * @param token ERC20Basic The address of the token contract
1451      */
1452     function reclaimToken(ERC20Basic token) external onlyOwner {
1453         uint256 balance = token.balanceOf(this);
1454         token.safeTransfer(owner, balance);
1455     }
1456 }
1457 
1458 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
1459 
1460 /**
1461  * @title Contracts that should not own Tokens
1462  * @author Remco Bloemen <remco@2π.com>
1463  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
1464  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
1465  * owner to reclaim the tokens.
1466  */
1467 contract HasNoTokens is CanReclaimToken {
1468     /**
1469      * @dev Reject all ERC223 compatible tokens
1470      * @param _from address The address that is transferring the tokens
1471      * @param _value uint256 the amount of the specified token
1472      * @param _data Bytes The data passed from the caller.
1473      */
1474     function tokenFallback(address _from, uint256 _value, bytes _data) external pure {
1475         _from;
1476         _value;
1477         _data;
1478         revert();
1479     }
1480 }
1481 
1482 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
1483 
1484 /**
1485  * @title Base contract for contracts that should not own things.
1486  * @author Remco Bloemen <remco@2π.com>
1487  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
1488  * Owned contracts. See respective base contracts for details.
1489  */
1490 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
1491 }
1492 
1493 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1494 
1495 
1496 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
1497 
1498 /**
1499  * @title Claimable
1500  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
1501  * This allows the new owner to accept the transfer.
1502  */
1503 contract Claimable is Ownable {
1504     address public pendingOwner;
1505 
1506     /**
1507      * @dev Modifier throws if called by any account other than the pendingOwner.
1508      */
1509     modifier onlyPendingOwner() {
1510         require(msg.sender == pendingOwner);
1511         _;
1512     }
1513 
1514     /**
1515      * @dev Allows the current owner to set the pendingOwner address.
1516      * @param newOwner The address to transfer ownership to.
1517      */
1518     function transferOwnership(address newOwner) onlyOwner public {
1519         pendingOwner = newOwner;
1520     }
1521 
1522     /**
1523      * @dev Allows the pendingOwner address to finalize the transfer.
1524      */
1525     function claimOwnership() onlyPendingOwner public {
1526         emit OwnershipTransferred(owner, pendingOwner);
1527         owner = pendingOwner;
1528         pendingOwner = address(0);
1529     }
1530 }
1531 
1532 // File: contracts/BalanceSheet.sol
1533 
1534 // A wrapper around the balanceOf mapping.
1535 contract BalanceSheet is Claimable {
1536     using SafeMath for uint256;
1537 
1538     mapping(address => uint256) public balanceOf;
1539 
1540     function addBalance(address _addr, uint256 _value) public onlyOwner {
1541         balanceOf[_addr] = balanceOf[_addr].add(_value);
1542     }
1543 
1544     function subBalance(address _addr, uint256 _value) public onlyOwner {
1545         balanceOf[_addr] = balanceOf[_addr].sub(_value);
1546     }
1547 
1548     function setBalance(address _addr, uint256 _value) public onlyOwner {
1549         balanceOf[_addr] = _value;
1550     }
1551 }
1552 
1553 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
1554 
1555 /**
1556  * @title Basic token
1557  * @dev Basic version of StandardToken, with no allowances.
1558  */
1559 contract BasicToken is ERC20Basic, Claimable {
1560     using SafeMath for uint256;
1561 
1562     BalanceSheet public balances;
1563 
1564     uint256 totalSupply_;
1565 
1566     function setBalanceSheet(address sheet) external onlyOwner {
1567         balances = BalanceSheet(sheet);
1568         balances.claimOwnership();
1569     }
1570 
1571     /**
1572     * @dev total number of tokens in existence
1573     */
1574     function totalSupply() public view returns (uint256) {
1575         return totalSupply_;
1576     }
1577 
1578     /**
1579     * @dev transfer token for a specified address
1580     * @param _to The address to transfer to.
1581     * @param _value The amount to be transferred.
1582     */
1583     function transfer(address _to, uint256 _value) public returns (bool) {
1584         transferAllArgsNoAllowance(msg.sender, _to, _value);
1585         return true;
1586     }
1587 
1588     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
1589         require(_to != address(0));
1590         require(_from != address(0));
1591         require(_value <= balances.balanceOf(_from));
1592 
1593         // SafeMath.sub will throw if there is not enough balance.
1594         balances.subBalance(_from, _value);
1595         balances.addBalance(_to, _value);
1596         emit Transfer(_from, _to, _value);
1597     }
1598 
1599     /**
1600     * @dev Gets the balance of the specified address.
1601     * @param _owner The address to query the the balance of.
1602     * @return An uint256 representing the amount owned by the passed address.
1603     */
1604     function balanceOf(address _owner) public view returns (uint256 balance) {
1605         return balances.balanceOf(_owner);
1606     }
1607 }
1608 
1609 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
1610 
1611 /**
1612  * @title Burnable Token
1613  * @dev Token that can be irreversibly burned (destroyed).
1614  */
1615 contract BurnableToken is BasicToken{
1616     event Burn(address indexed burner, uint256 value);
1617 
1618     /**
1619      * @dev Burns a specific amount of tokens.
1620      * @param _value The amount of token to be burned.
1621      */
1622     function burn(uint256 _value) public {
1623         require(_value <= balances.balanceOf(msg.sender));
1624         // no need to require value <= totalSupply, since that would imply the
1625         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1626 
1627         address burner = msg.sender;
1628         balances.subBalance(burner, _value);
1629         totalSupply_ = totalSupply_.sub(_value);
1630         emit Burn(burner, _value);
1631         emit Transfer(burner, address(0), _value);
1632     }
1633 }
1634 
1635 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1636 
1637 /**
1638  * @title Pausable
1639  * @dev Base contract which allows children to implement an emergency stop mechanism.
1640  */
1641 contract Pausable is Ownable {
1642     event Pause();
1643     event Unpause();
1644 
1645     bool public paused = false;
1646 
1647     /**
1648      * @dev Modifier to make a function callable only when the contract is not paused.
1649      */
1650     modifier whenNotPaused() {
1651         require(!paused);
1652         _;
1653     }
1654 
1655     /**
1656      * @dev Modifier to make a function callable only when the contract is paused.
1657      */
1658     modifier whenPaused() {
1659         require(paused);
1660         _;
1661     }
1662 
1663     /**
1664      * @dev called by the owner to pause, triggers stopped state
1665      */
1666     function pause() onlyOwner whenNotPaused public {
1667         paused = true;
1668         emit Pause();
1669     }
1670 
1671     /**
1672      * @dev called by the owner to unpause, returns to normal state
1673      */
1674     function unpause() onlyOwner whenPaused public {
1675         paused = false;
1676         emit Unpause();
1677     }
1678 }
1679 
1680 // File: contracts/AllowanceSheet.sol
1681 
1682 // A wrapper around the allowanceOf mapping.
1683 contract AllowanceSheet is Claimable {
1684     using SafeMath for uint256;
1685 
1686     mapping(address => mapping(address => uint256)) public allowanceOf;
1687 
1688     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
1689         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
1690     }
1691 
1692     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
1693         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
1694     }
1695 
1696     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
1697         allowanceOf[_tokenHolder][_spender] = _value;
1698     }
1699 }
1700 
1701 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
1702 
1703 contract StandardToken is ERC20, BasicToken {
1704     AllowanceSheet public allowances;
1705 
1706     function setAllowanceSheet(address sheet) external onlyOwner {
1707         allowances = AllowanceSheet(sheet);
1708         allowances.claimOwnership();
1709     }
1710 
1711     /**
1712      * @dev Transfer tokens from one address to another
1713      * @param _from address The address which you want to send tokens from
1714      * @param _to address The address which you want to transfer to
1715      * @param _value uint256 the amount of tokens to be transferred
1716      */
1717     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1718         transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
1719         return true;
1720     }
1721 
1722     function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
1723         require(_value <= allowances.allowanceOf(_from, spender));
1724 
1725         allowances.subAllowance(_from, spender, _value);
1726         transferAllArgsNoAllowance(_from, _to, _value);
1727     }
1728 
1729     /**
1730      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1731      *
1732      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1733      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1734      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1735      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1736      * @param _spender The address which will spend the funds.
1737      * @param _value The amount of tokens to be spent.
1738      */
1739     function approve(address _spender, uint256 _value) public returns (bool) {
1740         approveAllArgs(_spender, _value, msg.sender);
1741         return true;
1742     }
1743 
1744     function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
1745         allowances.setAllowance(_tokenHolder, _spender, _value);
1746         emit Approval(_tokenHolder, _spender, _value);
1747     }
1748 
1749     /**
1750      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1751      * @param _owner address The address which owns the funds.
1752      * @param _spender address The address which will spend the funds.
1753      * @return A uint256 specifying the amount of tokens still available for the spender.
1754      */
1755     function allowance(address _owner, address _spender) public view returns (uint256) {
1756         return allowances.allowanceOf(_owner, _spender);
1757     }
1758 
1759     /**
1760      * @dev Increase the amount of tokens that an owner allowed to a spender.
1761      *
1762      * approve should be called when allowed[_spender] == 0. To increment
1763      * allowed value is better to use this function to avoid 2 calls (and wait until
1764      * the first transaction is mined)
1765      * From MonolithDAO Token.sol
1766      * @param _spender The address which will spend the funds.
1767      * @param _addedValue The amount of tokens to increase the allowance by.
1768      */
1769     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1770         increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
1771         return true;
1772     }
1773 
1774     function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
1775         allowances.addAllowance(tokenHolder, _spender, _addedValue);
1776         emit Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
1777     }
1778 
1779     /**
1780      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1781      *
1782      * approve should be called when allowed[_spender] == 0. To decrement
1783      * allowed value is better to use this function to avoid 2 calls (and wait until
1784      * the first transaction is mined)
1785      * From MonolithDAO Token.sol
1786      * @param _spender The address which will spend the funds.
1787      * @param _subtractedValue The amount of tokens to decrease the allowance by.
1788      */
1789     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1790         decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
1791         return true;
1792     }
1793 
1794     function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
1795         uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
1796         if (_subtractedValue > oldValue) {
1797             allowances.setAllowance(tokenHolder, _spender, 0);
1798         } else {
1799             allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
1800         }
1801         emit Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
1802     }
1803 }
1804 
1805 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
1806 
1807 /**
1808  * @title Pausable token
1809  * @dev StandardToken modified with pausable transfers.
1810  **/
1811 contract PausableToken is StandardToken, Pausable{
1812     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
1813         return super.transfer(_to, _value);
1814     }
1815 
1816     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
1817         return super.transferFrom(_from, _to, _value);
1818     }
1819 
1820     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
1821         return super.approve(_spender, _value);
1822     }
1823 
1824     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
1825         return super.increaseApproval(_spender, _addedValue);
1826     }
1827 
1828     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
1829         return super.decreaseApproval(_spender, _subtractedValue);
1830     }
1831 }
1832 
1833 // File: contracts/AddressList.sol
1834 
1835 contract AddressList is Claimable {
1836     string public name;
1837     mapping(address => bool) public onList;
1838 
1839     constructor(string _name, bool nullValue) public {
1840         name = _name;
1841         onList[0x0] = nullValue;
1842     }
1843 
1844     event ChangeWhiteList(address indexed to, bool onList);
1845 
1846     // Set whether _to is on the list or not. Whether 0x0 is on the list
1847     // or not cannot be set here - it is set once and for all by the constructor.
1848     function changeList(address _to, bool _onList) onlyOwner public {
1849         require(_to != 0x0);
1850         if (onList[_to] != _onList) {
1851             onList[_to] = _onList;
1852             emit ChangeWhiteList(_to, _onList);
1853         }
1854     }
1855 }
1856 
1857 // File: contracts/DelegateERC20.sol
1858 
1859 contract DelegateERC20 {
1860     function delegateTotalSupply() public view returns (uint256);
1861 
1862     function delegateBalanceOf(address who) public view returns (uint256);
1863 
1864     function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
1865 
1866     function delegateAllowance(address owner, address spender) public view returns (uint256);
1867 
1868     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
1869 
1870     function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
1871 
1872     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
1873 
1874     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
1875 }
1876 
1877 // File: contracts/CanDelegate.sol
1878 
1879 contract CanDelegate is StandardToken {
1880     // If this contract needs to be upgraded, the new contract will be stored
1881     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
1882     DelegateERC20 public delegate;
1883 
1884     event DelegateToNewContract(address indexed newContract);
1885 
1886     // Can undelegate by passing in newContract = address(0)
1887     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
1888         delegate = newContract;
1889         emit DelegateToNewContract(newContract);
1890     }
1891 
1892     // If a delegate has been designated, all ERC20 calls are forwarded to it
1893     function transfer(address to, uint256 value) public returns (bool) {
1894         if (delegate == address(0)) {
1895             return super.transfer(to, value);
1896         } else {
1897             return delegate.delegateTransfer(to, value, msg.sender);
1898         }
1899     }
1900 
1901     function transferFrom(address from, address to, uint256 value) public returns (bool) {
1902         if (delegate == address(0)) {
1903             return super.transferFrom(from, to, value);
1904         } else {
1905             return delegate.delegateTransferFrom(from, to, value, msg.sender);
1906         }
1907     }
1908 
1909     function balanceOf(address who) public view returns (uint256) {
1910         if (delegate == address(0)) {
1911             return super.balanceOf(who);
1912         } else {
1913             return delegate.delegateBalanceOf(who);
1914         }
1915     }
1916 
1917     function approve(address spender, uint256 value) public returns (bool) {
1918         if (delegate == address(0)) {
1919             return super.approve(spender, value);
1920         } else {
1921             return delegate.delegateApprove(spender, value, msg.sender);
1922         }
1923     }
1924 
1925     function allowance(address _owner, address spender) public view returns (uint256) {
1926         if (delegate == address(0)) {
1927             return super.allowance(_owner, spender);
1928         } else {
1929             return delegate.delegateAllowance(_owner, spender);
1930         }
1931     }
1932 
1933     function totalSupply() public view returns (uint256) {
1934         if (delegate == address(0)) {
1935             return super.totalSupply();
1936         } else {
1937             return delegate.delegateTotalSupply();
1938         }
1939     }
1940 
1941     function increaseApproval(address spender, uint addedValue) public returns (bool) {
1942         if (delegate == address(0)) {
1943             return super.increaseApproval(spender, addedValue);
1944         } else {
1945             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
1946         }
1947     }
1948 
1949     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
1950         if (delegate == address(0)) {
1951             return super.decreaseApproval(spender, subtractedValue);
1952         } else {
1953             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
1954         }
1955     }
1956 }
1957 
1958 // File: contracts/StandardDelegate.sol
1959 
1960 contract StandardDelegate is StandardToken, DelegateERC20 {
1961     address public delegatedFrom;
1962 
1963     modifier onlySender(address source) {
1964         require(msg.sender == source);
1965         _;
1966     }
1967 
1968     function setDelegatedFrom(address addr) onlyOwner public {
1969         delegatedFrom = addr;
1970     }
1971 
1972     // All delegate ERC20 functions are forwarded to corresponding normal functions
1973     function delegateTotalSupply() public view returns (uint256) {
1974         return totalSupply();
1975     }
1976 
1977     function delegateBalanceOf(address who) public view returns (uint256) {
1978         return balanceOf(who);
1979     }
1980 
1981     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
1982         transferAllArgsNoAllowance(origSender, to, value);
1983         return true;
1984     }
1985 
1986     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1987         return allowance(owner, spender);
1988     }
1989 
1990     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
1991         transferAllArgsYesAllowance(from, to, value, origSender);
1992         return true;
1993     }
1994 
1995     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
1996         approveAllArgs(spender, value, origSender);
1997         return true;
1998     }
1999 
2000     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
2001         increaseApprovalAllArgs(spender, addedValue, origSender);
2002         return true;
2003     }
2004 
2005     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
2006         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
2007         return true;
2008     }
2009 }
2010 
2011 // File: contracts/TrueVND.sol
2012 
2013 contract TrueVND is NoOwner, BurnableToken, CanDelegate, StandardDelegate, PausableToken {
2014     string public name = "TrueVND";
2015     string public symbol = "TVND";
2016     uint8 public constant decimals = 18;
2017 
2018     AddressList public canReceiveMintWhiteList;
2019     AddressList public canBurnWhiteList;
2020     AddressList public blackList;
2021     AddressList public noFeesList;
2022     address public staker;
2023 
2024     uint256 public burnMin = 1000 * 10 ** uint256(decimals);
2025     uint256 public burnMax = 20000000 * 10 ** uint256(decimals);
2026 
2027     uint80 public transferFeeNumerator = 8;
2028     uint80 public transferFeeDenominator = 10000;
2029     uint80 public mintFeeNumerator = 0;
2030     uint80 public mintFeeDenominator = 10000;
2031     uint256 public mintFeeFlat = 0;
2032     uint80 public burnFeeNumerator = 0;
2033     uint80 public burnFeeDenominator = 10000;
2034     uint256 public burnFeeFlat = 0;
2035 
2036     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
2037     event Mint(address indexed to, uint256 amount);
2038     event WipedAccount(address indexed account, uint256 balance);
2039 
2040     constructor() public {
2041         totalSupply_ = 0;
2042         staker = msg.sender;
2043     }
2044 
2045     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
2046         canReceiveMintWhiteList = _canReceiveMintWhiteList;
2047         canBurnWhiteList = _canBurnWhiteList;
2048         blackList = _blackList;
2049         noFeesList = _noFeesList;
2050     }
2051 
2052     function changeName(string _name, string _symbol) onlyOwner public {
2053         name = _name;
2054         symbol = _symbol;
2055     }
2056 
2057     // Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
2058     // and will send them back the equivalent amount of money (rounded down to the nearest cent).
2059     function burn(uint256 _value) public {
2060         require(canBurnWhiteList.onList(msg.sender));
2061         require(_value >= burnMin);
2062         require(_value <= burnMax);
2063         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
2064         uint256 remaining = _value.sub(fee);
2065         super.burn(remaining);
2066     }
2067 
2068     // Create _amount new tokens and transfer them to _to.
2069     // Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
2070     function mint(address _to, uint256 _amount) onlyOwner public {
2071         require(canReceiveMintWhiteList.onList(_to));
2072         totalSupply_ = totalSupply_.add(_amount);
2073         balances.addBalance(_to, _amount);
2074         emit Mint(_to, _amount);
2075         emit Transfer(address(0), _to, _amount);
2076         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
2077     }
2078 
2079     // Change the minimum and maximum amount that can be burned at once. Burning
2080     // may be disabled by setting both to 0 (this will not be done under normal
2081     // operation, but we can't add checks to disallow it without losing a lot of
2082     // flexibility since burning could also be as good as disabled
2083     // by setting the minimum extremely high, and we don't want to lock
2084     // in any particular cap for the minimum)
2085     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
2086         require(newMin <= newMax);
2087         burnMin = newMin;
2088         burnMax = newMax;
2089         emit ChangeBurnBoundsEvent(newMin, newMax);
2090     }
2091 
2092     // A blacklisted address can't call transferFrom
2093     function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
2094         require(!blackList.onList(spender));
2095         super.transferAllArgsYesAllowance(_from, _to, _value, spender);
2096     }
2097 
2098     // transfer and transferFrom both ultimately call this function, so we
2099     // check blacklist and pay staking fee here.
2100     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
2101         require(!blackList.onList(_from));
2102         require(!blackList.onList(_to));
2103         super.transferAllArgsNoAllowance(_from, _to, _value);
2104         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, burnFeeFlat, _from);
2105     }
2106 
2107     function wipeBlacklistedAccount(address account) public onlyOwner {
2108         require(blackList.onList(account));
2109         uint256 oldValue = balanceOf(account);
2110         balances.setBalance(account, 0);
2111         totalSupply_ = totalSupply_.sub(oldValue);
2112         emit WipedAccount(account, oldValue);
2113     }
2114 
2115     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
2116         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
2117             return 0;
2118         }
2119         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
2120         if (stakingFee > 0) {
2121             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
2122         }
2123         return stakingFee;
2124     }
2125 
2126     function changeStakingFees(uint80 _transferFeeNumerator,
2127         uint80 _transferFeeDenominator,
2128         uint80 _mintFeeNumerator,
2129         uint80 _mintFeeDenominator,
2130         uint256 _mintFeeFlat,
2131         uint80 _burnFeeNumerator,
2132         uint80 _burnFeeDenominator,
2133         uint256 _burnFeeFlat) public onlyOwner {
2134         require(_transferFeeDenominator != 0);
2135         require(_mintFeeDenominator != 0);
2136         require(_burnFeeDenominator != 0);
2137         transferFeeNumerator = _transferFeeNumerator;
2138         transferFeeDenominator = _transferFeeDenominator;
2139         mintFeeNumerator = _mintFeeNumerator;
2140         mintFeeDenominator = _mintFeeDenominator;
2141         mintFeeFlat = _mintFeeFlat;
2142         burnFeeNumerator = _burnFeeNumerator;
2143         burnFeeDenominator = _burnFeeDenominator;
2144         burnFeeFlat = _burnFeeFlat;
2145     }
2146 
2147     function changeStaker(address newStaker) public onlyOwner {
2148         require(newStaker != address(0));
2149         staker = newStaker;
2150     }
2151 }
2152 
2153 contract PIPOT is Owner,usingOraclize {
2154     using SafeMath for uint256;
2155     event Game(uint _game, uint indexed _time);
2156     event ChangePrice(uint _price);
2157     event Ticket(
2158         address indexed _address,
2159         uint indexed _game,
2160         uint _number,
2161         uint _time,
2162         uint _price
2163     );
2164     
2165     event ChangeFee(uint _fee);
2166     event Winner(address _winnerAddress, uint _price, uint _jackpot);
2167     event Lose(uint _price, uint _currentJackpot);
2168     event LogPrice(uint priceBTC);
2169     
2170     TrueVND tvndToken;
2171     
2172     // Game fee.
2173     uint public fee = 20;
2174     // Current game number.
2175     uint public game;
2176     // Ticket price.
2177     uint public ticketPrice = 10 ether;
2178     // All-time game jackpot.
2179     uint public allTimeJackpot = 0;
2180     // All-time game players count
2181     uint public allTimePlayers = 0;
2182 
2183     uint public winPrice = 0;
2184     
2185     // Game status.
2186     bool public isActive = true;
2187     // The variable that indicates game status switching.
2188     bool public toogleStatus = false;
2189     // The array of all games
2190     uint[] public games;
2191     
2192     // Store game jackpot.
2193     mapping(uint => uint) jackpot;
2194     // Store game players.
2195     mapping(uint => address[]) players;
2196     mapping(uint => mapping(uint => address[])) orders;
2197     //Store ref 
2198     mapping(address => address) playersWithRef;
2199 
2200     
2201     // Funds distributor address.
2202     address public fundsDistributor;
2203 
2204     /**
2205     * @dev Check sender address and compare it to an owner.
2206     */
2207     modifier onlyOwner() {
2208         require(msg.sender == owner);
2209         _;
2210     }
2211     
2212     function PIPOT(
2213         address distributor
2214     )
2215     public Owner(msg.sender)
2216     {
2217         fundsDistributor = distributor;
2218         startGame();
2219         tvndToken = TrueVND(0x3Dc0501c32beE0cc1e629d590302A4b909797474);
2220     }
2221 
2222     function getPlayedGamePlayers() 
2223         public
2224         view
2225         returns (uint)
2226     {
2227         return getPlayersInGame(game);
2228     }
2229     
2230     function addPlayer(address ref) {
2231         playersWithRef[msg.sender] = ref;
2232     }
2233 
2234     function getPlayersInGame(uint playedGame) 
2235         public 
2236         view
2237         returns (uint)
2238     {
2239         return players[playedGame].length;
2240     }
2241 
2242     function getPlayedGameJackpot() 
2243         public 
2244         view
2245         returns (uint) 
2246     {
2247         return getGameJackpot(game);
2248     }
2249     
2250     function getGameJackpot(uint playedGame) 
2251         public 
2252         view 
2253         returns(uint)
2254     {
2255         return jackpot[playedGame];
2256     }
2257     
2258     function toogleActive() public onlyOwner() {
2259         if (!isActive) {
2260             isActive = true;
2261         } else {
2262             toogleStatus = !toogleStatus;
2263         }
2264     }
2265     
2266     function __callback(bytes32 _myid, string _result) {
2267         require (msg.sender == oraclize_cbAddress());
2268         winPrice = parseInt(_result);
2269         emit LogPrice(winPrice);
2270     }
2271     
2272     function start() public onlyOwner() {
2273         startGame();
2274     }
2275     
2276 
2277     function changeTicketPrice(uint price) 
2278         public 
2279         onlyOwner() 
2280     {
2281         ticketPrice = price;
2282         emit ChangePrice(price);
2283     }
2284     
2285     function buyTicket(uint betPrice, uint256 _value) public {
2286         require(isActive);
2287         require(_value == ticketPrice);
2288         
2289         uint playerNumber =  players[game].length;
2290         
2291         uint distribute = _value * fee / 100;
2292         
2293         jackpot[game] += (_value - distribute);
2294         
2295         if(tvndToken.transferFrom(msg.sender, fundsDistributor, distribute) && tvndToken.transferFrom(msg.sender, address(this),(_value - distribute))){
2296             players[game].push(msg.sender);
2297             orders[game][betPrice].push(msg.sender);
2298         }
2299         
2300         emit Ticket(msg.sender, game, playerNumber, now, betPrice);
2301     }
2302     
2303     function getBTCPrice() public onlyOwner() payable {
2304         require(players[game].length > 0);
2305         oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD).USD");
2306     }
2307 
2308     /**
2309     * @dev Start the new game.
2310     * @dev Checks ticket price changes, if exists new ticket price the price will be changed.
2311     * @dev Checks game status changes, if exists request for changing game status game status 
2312     * @dev will be changed.
2313     */
2314     function startGame() internal {
2315         require(isActive);
2316         game = block.number;
2317         if (toogleStatus) {
2318             isActive = !isActive;
2319             toogleStatus = false;
2320         }
2321         emit Game(game, now);
2322     }
2323 
2324     function pickTheWinner() public onlyOwner(){
2325         require(winPrice > 0);
2326         uint toPlayer;
2327         uint refToPlayer;
2328         if(orders[game][winPrice].length > 0){
2329             toPlayer = jackpot[game]/orders[game][winPrice].length;
2330             refToPlayer = (jackpot[game]/orders[game][winPrice].length) * 10/100;
2331             for(uint i = 0; i < orders[game][winPrice].length;i++){
2332                 address winAddress = orders[game][winPrice][i];
2333                 
2334                 tvndToken.transfer(winAddress, toPlayer);
2335                 
2336                 allTimeJackpot += jackpot[game];
2337                 emit Winner(orders[game][winPrice][i], winPrice, toPlayer);
2338             }   
2339         }else{
2340             emit Lose(winPrice, jackpot[game]);
2341         }
2342         
2343         allTimePlayers += players[game].length;
2344         winPrice = 0;
2345     }
2346 }