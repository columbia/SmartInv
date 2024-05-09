1 pragma solidity 0.4.25;
2 // <ORACLIZE_API>
3 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
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
24 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
25 
26 pragma solidity >= 0.4.22 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
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
117         // Memory address of the buffer data
118             let bufptr := mload(buf)
119         // Length of existing buffer data
120             let buflen := mload(bufptr)
121         // Start address = buffer address + buffer length + sizeof(buffer length)
122             dest := add(add(bufptr, buflen), 32)
123         // Update buffer length
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
161         // Memory address of the buffer data
162             let bufptr := mload(buf)
163         // Length of existing buffer data
164             let buflen := mload(bufptr)
165         // Address = buffer address + buffer length + sizeof(buffer length)
166             let dest := add(add(bufptr, buflen), 32)
167             mstore8(dest, data)
168         // Update buffer length
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
187         // Memory address of the buffer data
188             let bufptr := mload(buf)
189         // Length of existing buffer data
190             let buflen := mload(bufptr)
191         // Address = buffer address + buffer length + sizeof(buffer length) + len
192             let dest := add(add(bufptr, buflen), len)
193             mstore(dest, or(and(mload(dest), not(mask)), data))
194         // Update buffer length
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
307         return oraclize_setNetwork();
308         networkID; // silence the warning and remain backwards compatible
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
350         return;
351         // Following should never be reached with a preceding return, however
352         // this is just a placeholder function, ideally meant to be defined in
353         // child contract when proofs are used
354         myid; result; proof; // Silence compiler warnings
355         oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
356     }
357 
358     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
359         return oraclize.getPrice(datasource);
360     }
361 
362     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
363         return oraclize.getPrice(datasource, gaslimit);
364     }
365 
366     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource);
368         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
369         return oraclize.query.value(price)(0, datasource, arg);
370     }
371     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
372         uint price = oraclize.getPrice(datasource);
373         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
374         return oraclize.query.value(price)(timestamp, datasource, arg);
375     }
376     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
380     }
381     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource, gaslimit);
383         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
384         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
385     }
386     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource);
388         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
389         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
390     }
391     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource);
393         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
394         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
395     }
396     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource, gaslimit);
398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
399         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
400     }
401     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
405     }
406     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource);
408         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
409         bytes memory args = stra2cbor(argN);
410         return oraclize.queryN.value(price)(0, datasource, args);
411     }
412     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource);
414         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
415         bytes memory args = stra2cbor(argN);
416         return oraclize.queryN.value(price)(timestamp, datasource, args);
417     }
418     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource, gaslimit);
420         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
423     }
424     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource, gaslimit);
426         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
427         bytes memory args = stra2cbor(argN);
428         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
429     }
430     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
431         string[] memory dynargs = new string[](1);
432         dynargs[0] = args[0];
433         return oraclize_query(datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
436         string[] memory dynargs = new string[](1);
437         dynargs[0] = args[0];
438         return oraclize_query(timestamp, datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
444     }
445     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(datasource, dynargs, gaslimit);
449     }
450 
451     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](2);
453         dynargs[0] = args[0];
454         dynargs[1] = args[1];
455         return oraclize_query(datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](2);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         return oraclize_query(timestamp, datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](2);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         return oraclize_query(datasource, dynargs, gaslimit);
474     }
475     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](3);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         return oraclize_query(datasource, dynargs);
481     }
482     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
483         string[] memory dynargs = new string[](3);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         return oraclize_query(timestamp, datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](3);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
495     }
496     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](3);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         return oraclize_query(datasource, dynargs, gaslimit);
502     }
503 
504     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
505         string[] memory dynargs = new string[](4);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         dynargs[3] = args[3];
510         return oraclize_query(datasource, dynargs);
511     }
512     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
513         string[] memory dynargs = new string[](4);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         return oraclize_query(timestamp, datasource, dynargs);
519     }
520     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
521         string[] memory dynargs = new string[](4);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         dynargs[3] = args[3];
526         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
527     }
528     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
529         string[] memory dynargs = new string[](4);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         dynargs[2] = args[2];
533         dynargs[3] = args[3];
534         return oraclize_query(datasource, dynargs, gaslimit);
535     }
536     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
537         string[] memory dynargs = new string[](5);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         dynargs[3] = args[3];
542         dynargs[4] = args[4];
543         return oraclize_query(datasource, dynargs);
544     }
545     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](5);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         dynargs[2] = args[2];
550         dynargs[3] = args[3];
551         dynargs[4] = args[4];
552         return oraclize_query(timestamp, datasource, dynargs);
553     }
554     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
555         string[] memory dynargs = new string[](5);
556         dynargs[0] = args[0];
557         dynargs[1] = args[1];
558         dynargs[2] = args[2];
559         dynargs[3] = args[3];
560         dynargs[4] = args[4];
561         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
562     }
563     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
564         string[] memory dynargs = new string[](5);
565         dynargs[0] = args[0];
566         dynargs[1] = args[1];
567         dynargs[2] = args[2];
568         dynargs[3] = args[3];
569         dynargs[4] = args[4];
570         return oraclize_query(datasource, dynargs, gaslimit);
571     }
572     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
573         uint price = oraclize.getPrice(datasource);
574         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
575         bytes memory args = ba2cbor(argN);
576         return oraclize.queryN.value(price)(0, datasource, args);
577     }
578     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
579         uint price = oraclize.getPrice(datasource);
580         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
581         bytes memory args = ba2cbor(argN);
582         return oraclize.queryN.value(price)(timestamp, datasource, args);
583     }
584     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource, gaslimit);
586         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
589     }
590     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource, gaslimit);
592         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
593         bytes memory args = ba2cbor(argN);
594         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
595     }
596     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
597         bytes[] memory dynargs = new bytes[](1);
598         dynargs[0] = args[0];
599         return oraclize_query(datasource, dynargs);
600     }
601     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
602         bytes[] memory dynargs = new bytes[](1);
603         dynargs[0] = args[0];
604         return oraclize_query(timestamp, datasource, dynargs);
605     }
606     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](1);
608         dynargs[0] = args[0];
609         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
610     }
611     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](1);
613         dynargs[0] = args[0];
614         return oraclize_query(datasource, dynargs, gaslimit);
615     }
616 
617     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](2);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         return oraclize_query(datasource, dynargs);
622     }
623     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](2);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         return oraclize_query(timestamp, datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
634     }
635     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](2);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         return oraclize_query(datasource, dynargs, gaslimit);
640     }
641     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](3);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         dynargs[2] = args[2];
646         return oraclize_query(datasource, dynargs);
647     }
648     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
649         bytes[] memory dynargs = new bytes[](3);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         dynargs[2] = args[2];
653         return oraclize_query(timestamp, datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](3);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
661     }
662     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](3);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         return oraclize_query(datasource, dynargs, gaslimit);
668     }
669 
670     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
671         bytes[] memory dynargs = new bytes[](4);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         dynargs[2] = args[2];
675         dynargs[3] = args[3];
676         return oraclize_query(datasource, dynargs);
677     }
678     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
679         bytes[] memory dynargs = new bytes[](4);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         dynargs[3] = args[3];
684         return oraclize_query(timestamp, datasource, dynargs);
685     }
686     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
687         bytes[] memory dynargs = new bytes[](4);
688         dynargs[0] = args[0];
689         dynargs[1] = args[1];
690         dynargs[2] = args[2];
691         dynargs[3] = args[3];
692         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
693     }
694     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
695         bytes[] memory dynargs = new bytes[](4);
696         dynargs[0] = args[0];
697         dynargs[1] = args[1];
698         dynargs[2] = args[2];
699         dynargs[3] = args[3];
700         return oraclize_query(datasource, dynargs, gaslimit);
701     }
702     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](5);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         dynargs[3] = args[3];
708         dynargs[4] = args[4];
709         return oraclize_query(datasource, dynargs);
710     }
711     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](5);
713         dynargs[0] = args[0];
714         dynargs[1] = args[1];
715         dynargs[2] = args[2];
716         dynargs[3] = args[3];
717         dynargs[4] = args[4];
718         return oraclize_query(timestamp, datasource, dynargs);
719     }
720     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
721         bytes[] memory dynargs = new bytes[](5);
722         dynargs[0] = args[0];
723         dynargs[1] = args[1];
724         dynargs[2] = args[2];
725         dynargs[3] = args[3];
726         dynargs[4] = args[4];
727         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
728     }
729     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
730         bytes[] memory dynargs = new bytes[](5);
731         dynargs[0] = args[0];
732         dynargs[1] = args[1];
733         dynargs[2] = args[2];
734         dynargs[3] = args[3];
735         dynargs[4] = args[4];
736         return oraclize_query(datasource, dynargs, gaslimit);
737     }
738 
739     function oraclize_cbAddress() oraclizeAPI internal returns (address){
740         return oraclize.cbAddress();
741     }
742     function oraclize_setProof(byte proofP) oraclizeAPI internal {
743         return oraclize.setProofType(proofP);
744     }
745     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
746         return oraclize.setCustomGasPrice(gasPrice);
747     }
748 
749     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
750         return oraclize.randomDS_getSessionPubKeyHash();
751     }
752 
753     function getCodeSize(address _addr) view internal returns(uint _size) {
754         assembly {
755             _size := extcodesize(_addr)
756         }
757     }
758 
759     function parseAddr(string _a) internal pure returns (address){
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
779     function strCompare(string _a, string _b) internal pure returns (int) {
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
797     function indexOf(string _haystack, string _needle) internal pure returns (int) {
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
824     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
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
841     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
842         return strConcat(_a, _b, _c, _d, "");
843     }
844 
845     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
846         return strConcat(_a, _b, _c, "", "");
847     }
848 
849     function strConcat(string _a, string _b) internal pure returns (string) {
850         return strConcat(_a, _b, "", "", "");
851     }
852 
853     // parseInt
854     function parseInt(string _a) internal pure returns (uint) {
855         return parseInt(_a, 0);
856     }
857 
858     // parseInt(parseFloat*10^_b)
859     function parseInt(string _a, uint _b) internal pure returns (uint) {
860         bytes memory bresult = bytes(_a);
861         uint mint = 0;
862         bool decimals = false;
863         for (uint i=0; i<bresult.length; i++){
864             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
865                 if (decimals){
866                     if (_b == 0) break;
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
877     function uint2str(uint i) internal pure returns (string){
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
895     function stra2cbor(string[] arr) internal pure returns (bytes) {
896         safeMemoryCleaner();
897         Buffer.buffer memory buf;
898         Buffer.init(buf, 1024);
899         buf.startArray();
900         for (uint i = 0; i < arr.length; i++) {
901             buf.encodeString(arr[i]);
902         }
903         buf.endSequence();
904         return buf.buf;
905     }
906 
907     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
908         safeMemoryCleaner();
909         Buffer.buffer memory buf;
910         Buffer.init(buf, 1024);
911         buf.startArray();
912         for (uint i = 0; i < arr.length; i++) {
913             buf.encodeBytes(arr[i]);
914         }
915         buf.endSequence();
916         return buf.buf;
917     }
918 
919     string oraclize_network_name;
920     function oraclize_setNetworkName(string _network_name) internal {
921         oraclize_network_name = _network_name;
922     }
923 
924     function oraclize_getNetworkName() internal view returns (string) {
925         return oraclize_network_name;
926     }
927 
928     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
929         require((_nbytes > 0) && (_nbytes <= 32));
930         // Convert from seconds to ledger timer ticks
931         _delay *= 10;
932         bytes memory nbytes = new bytes(1);
933         nbytes[0] = byte(_nbytes);
934         bytes memory unonce = new bytes(32);
935         bytes memory sessionKeyHash = new bytes(32);
936         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
937         assembly {
938             mstore(unonce, 0x20)
939         // the following variables can be relaxed
940         // check relaxed random contract under ethereum-examples repo
941         // for an idea on how to override and replace comit hash vars
942             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
943             mstore(sessionKeyHash, 0x20)
944             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
945         }
946         bytes memory delay = new bytes(32);
947         assembly {
948             mstore(add(delay, 0x20), _delay)
949         }
950 
951         bytes memory delay_bytes8 = new bytes(8);
952         copyBytes(delay, 24, 8, delay_bytes8, 0);
953 
954         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
955         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
956 
957         bytes memory delay_bytes8_left = new bytes(8);
958 
959         assembly {
960             let x := mload(add(delay_bytes8, 0x20))
961             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
962             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
963             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
964             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
965             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
969 
970         }
971 
972         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
973         return queryId;
974     }
975 
976     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
977         oraclize_randomDS_args[queryId] = commitment;
978     }
979 
980     mapping(bytes32=>bytes32) oraclize_randomDS_args;
981     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
982 
983     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
984         bool sigok;
985         address signer;
986 
987         bytes32 sigr;
988         bytes32 sigs;
989 
990         bytes memory sigr_ = new bytes(32);
991         uint offset = 4+(uint(dersig[3]) - 0x20);
992         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
993         bytes memory sigs_ = new bytes(32);
994         offset += 32 + 2;
995         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
996 
997         assembly {
998             sigr := mload(add(sigr_, 32))
999             sigs := mload(add(sigs_, 32))
1000         }
1001 
1002 
1003         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1004         if (address(keccak256(pubkey)) == signer) return true;
1005         else {
1006             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1007             return (address(keccak256(pubkey)) == signer);
1008         }
1009     }
1010 
1011     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1012         bool sigok;
1013 
1014         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1015         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1016         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1017 
1018         bytes memory appkey1_pubkey = new bytes(64);
1019         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1020 
1021         bytes memory tosign2 = new bytes(1+65+32);
1022         tosign2[0] = byte(1); //role
1023         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1024         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1025         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1026         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1027 
1028         if (sigok == false) return false;
1029 
1030 
1031         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1032         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1033 
1034         bytes memory tosign3 = new bytes(1+65);
1035         tosign3[0] = 0xFE;
1036         copyBytes(proof, 3, 65, tosign3, 1);
1037 
1038         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1039         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1040 
1041         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1042 
1043         return sigok;
1044     }
1045 
1046     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1047         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1048         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1049 
1050         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1051         require(proofVerified);
1052 
1053         _;
1054     }
1055 
1056     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1057         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1058         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1059 
1060         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1061         if (proofVerified == false) return 2;
1062 
1063         return 0;
1064     }
1065 
1066     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1067         bool match_ = true;
1068 
1069         require(prefix.length == n_random_bytes);
1070 
1071         for (uint256 i=0; i< n_random_bytes; i++) {
1072             if (content[i] != prefix[i]) match_ = false;
1073         }
1074 
1075         return match_;
1076     }
1077 
1078     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1079 
1080         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1081         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1082         bytes memory keyhash = new bytes(32);
1083         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1084         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1085 
1086         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1087         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1088 
1089         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1090         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1091 
1092         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1093         // This is to verify that the computed args match with the ones specified in the query.
1094         bytes memory commitmentSlice1 = new bytes(8+1+32);
1095         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1096 
1097         bytes memory sessionPubkey = new bytes(64);
1098         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1099         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1100 
1101         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1102         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1103             delete oraclize_randomDS_args[queryId];
1104         } else return false;
1105 
1106 
1107         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1108         bytes memory tosign1 = new bytes(32+8+1+32);
1109         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1110         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1111 
1112         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1113         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1114             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1115         }
1116 
1117         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1118     }
1119 
1120     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1121     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1122         uint minLength = length + toOffset;
1123 
1124         // Buffer too small
1125         require(to.length >= minLength); // Should be a better way?
1126 
1127         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1128         uint i = 32 + fromOffset;
1129         uint j = 32 + toOffset;
1130 
1131         while (i < (32 + fromOffset + length)) {
1132             assembly {
1133                 let tmp := mload(add(from, i))
1134                 mstore(add(to, j), tmp)
1135             }
1136             i += 32;
1137             j += 32;
1138         }
1139 
1140         return to;
1141     }
1142 
1143     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1144     // Duplicate Solidity's ecrecover, but catching the CALL return value
1145     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1146         // We do our own memory management here. Solidity uses memory offset
1147         // 0x40 to store the current end of memory. We write past it (as
1148         // writes are memory extensions), but don't update the offset so
1149         // Solidity will reuse it. The memory used here is only needed for
1150         // this context.
1151 
1152         // FIXME: inline assembly can't access return values
1153         bool ret;
1154         address addr;
1155 
1156         assembly {
1157             let size := mload(0x40)
1158             mstore(size, hash)
1159             mstore(add(size, 32), v)
1160             mstore(add(size, 64), r)
1161             mstore(add(size, 96), s)
1162 
1163         // NOTE: we can reuse the request memory because we deal with
1164         //       the return code
1165             ret := call(3000, 1, 0, size, 128, size, 32)
1166             addr := mload(size)
1167         }
1168 
1169         return (ret, addr);
1170     }
1171 
1172     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1173     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1174         bytes32 r;
1175         bytes32 s;
1176         uint8 v;
1177 
1178         if (sig.length != 65)
1179             return (false, 0);
1180 
1181         // The signature format is a compact form of:
1182         //   {bytes32 r}{bytes32 s}{uint8 v}
1183         // Compact means, uint8 is not padded to 32 bytes.
1184         assembly {
1185             r := mload(add(sig, 32))
1186             s := mload(add(sig, 64))
1187 
1188         // Here we are loading the last 32 bytes. We exploit the fact that
1189         // 'mload' will pad with zeroes if we overread.
1190         // There is no 'mload8' to do this, but that would be nicer.
1191             v := byte(0, mload(add(sig, 96)))
1192 
1193         // Alternative solution:
1194         // 'byte' is not working due to the Solidity parser, so lets
1195         // use the second best option, 'and'
1196         // v := and(mload(add(sig, 65)), 255)
1197         }
1198 
1199         // albeit non-transactional signatures are not specified by the YP, one would expect it
1200         // to match the YP range of [27, 28]
1201         //
1202         // geth uses [0, 1] and some clients have followed. This might change, see:
1203         //  https://github.com/ethereum/go-ethereum/issues/2053
1204         if (v < 27)
1205             v += 27;
1206 
1207         if (v != 27 && v != 28)
1208             return (false, 0);
1209 
1210         return safer_ecrecover(hash, v, r, s);
1211     }
1212 
1213     function safeMemoryCleaner() internal pure {
1214         assembly {
1215             let fmem := mload(0x40)
1216             codecopy(fmem, codesize, sub(msize, fmem))
1217         }
1218     }
1219 
1220 }
1221 // </ORACLIZE_API>
1222 
1223 /**
1224  * @title ERC20 interface
1225  * @dev see https://github.com/ethereum/EIPs/issues/20
1226  */
1227 interface IERC20 {
1228     function totalSupply() external view returns (uint256);
1229 
1230     function balanceOf(address who) external view returns (uint256);
1231 
1232     function allowance(address owner, address spender) external view returns (uint256);
1233 
1234     function transfer(address to, uint256 value) external returns (bool);
1235 
1236     function approve(address spender, uint256 value) external returns (bool);
1237 
1238     function transferFrom(address from, address to, uint256 value) external returns (bool);
1239 
1240     event Transfer(address indexed from, address indexed to, uint256 value);
1241 
1242     event Approval(address indexed owner, address indexed spender, uint256 value);
1243 }
1244 
1245 /**
1246  * @title SafeMath
1247  * @dev Math operations with safety checks that revert on error
1248  */
1249 library SafeMath {
1250     int256 constant private INT256_MIN = - 2 ** 255;
1251 
1252     /**
1253     * @dev Multiplies two unsigned integers, reverts on overflow.
1254     */
1255     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1256         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1257         // benefit is lost if 'b' is also tested.
1258         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1259         if (a == 0) {
1260             return 0;
1261         }
1262 
1263         uint256 c = a * b;
1264         require(c / a == b);
1265 
1266         return c;
1267     }
1268 
1269     /**
1270     * @dev Multiplies two signed integers, reverts on overflow.
1271     */
1272     function mul(int256 a, int256 b) internal pure returns (int256) {
1273         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1274         // benefit is lost if 'b' is also tested.
1275         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1276         if (a == 0) {
1277             return 0;
1278         }
1279 
1280         require(!(a == - 1 && b == INT256_MIN));
1281         // This is the only case of overflow not detected by the check below
1282 
1283         int256 c = a * b;
1284         require(c / a == b);
1285 
1286         return c;
1287     }
1288 
1289     /**
1290     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1291     */
1292     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1293         // Solidity only automatically asserts when dividing by 0
1294         require(b > 0);
1295         uint256 c = a / b;
1296         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1297 
1298         return c;
1299     }
1300 
1301     /**
1302     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
1303     */
1304     function div(int256 a, int256 b) internal pure returns (int256) {
1305         require(b != 0);
1306         // Solidity only automatically asserts when dividing by 0
1307         require(!(b == - 1 && a == INT256_MIN));
1308         // This is the only case of overflow
1309 
1310         int256 c = a / b;
1311 
1312         return c;
1313     }
1314 
1315     /**
1316     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1317     */
1318     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1319         require(b <= a);
1320         uint256 c = a - b;
1321 
1322         return c;
1323     }
1324 
1325     /**
1326     * @dev Subtracts two signed integers, reverts on overflow.
1327     */
1328     function sub(int256 a, int256 b) internal pure returns (int256) {
1329         int256 c = a - b;
1330         require((b >= 0 && c <= a) || (b < 0 && c > a));
1331 
1332         return c;
1333     }
1334 
1335     /**
1336     * @dev Adds two unsigned integers, reverts on overflow.
1337     */
1338     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1339         uint256 c = a + b;
1340         require(c >= a);
1341 
1342         return c;
1343     }
1344 
1345     /**
1346     * @dev Adds two signed integers, reverts on overflow.
1347     */
1348     function add(int256 a, int256 b) internal pure returns (int256) {
1349         int256 c = a + b;
1350         require((b >= 0 && c >= a) || (b < 0 && c < a));
1351 
1352         return c;
1353     }
1354 
1355     /**
1356     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1357     * reverts when dividing by zero.
1358     */
1359     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1360         require(b != 0);
1361         return a % b;
1362     }
1363 }
1364 
1365 /**
1366  * @title Standard ERC20 token
1367  *
1368  * @dev Implementation of the basic standard token.
1369  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
1370  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1371  *
1372  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
1373  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
1374  * compliant implementations may not do it.
1375  */
1376 contract ERC20 is IERC20 {
1377     using SafeMath for uint256;
1378 
1379     mapping(address => uint256) private _balances;
1380 
1381     mapping(address => mapping(address => uint256)) private _allowed;
1382 
1383     uint256 private _totalSupply;
1384 
1385     /**
1386     * @dev Total number of tokens in existence
1387     */
1388     function totalSupply() public view returns (uint256) {
1389         return _totalSupply;
1390     }
1391 
1392     /**
1393     * @dev Gets the balance of the specified address.
1394     * @param owner The address to query the balance of.
1395     * @return An uint256 representing the amount owned by the passed address.
1396     */
1397     function balanceOf(address owner) public view returns (uint256) {
1398         return _balances[owner];
1399     }
1400 
1401     /**
1402      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1403      * @param owner address The address which owns the funds.
1404      * @param spender address The address which will spend the funds.
1405      * @return A uint256 specifying the amount of tokens still available for the spender.
1406      */
1407     function allowance(address owner, address spender) public view returns (uint256) {
1408         return _allowed[owner][spender];
1409     }
1410 
1411     /**
1412     * @dev Transfer token for a specified address
1413     * @param to The address to transfer to.
1414     * @param value The amount to be transferred.
1415     */
1416     function transfer(address to, uint256 value) public returns (bool) {
1417         _transfer(msg.sender, to, value);
1418         return true;
1419     }
1420 
1421     /**
1422      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1423      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1424      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1425      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1426      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1427      * @param spender The address which will spend the funds.
1428      * @param value The amount of tokens to be spent.
1429      */
1430     function approve(address spender, uint256 value) public returns (bool) {
1431         require(spender != address(0));
1432 
1433         _allowed[msg.sender][spender] = value;
1434         emit Approval(msg.sender, spender, value);
1435         return true;
1436     }
1437 
1438     /**
1439      * @dev Transfer tokens from one address to another.
1440      * Note that while this function emits an Approval event, this is not required as per the specification,
1441      * and other compliant implementations may not emit the event.
1442      * @param from address The address which you want to send tokens from
1443      * @param to address The address which you want to transfer to
1444      * @param value uint256 the amount of tokens to be transferred
1445      */
1446     function transferFrom(address from, address to, uint256 value) public returns (bool) {
1447         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1448         _transfer(from, to, value);
1449         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
1450         return true;
1451     }
1452 
1453     /**
1454      * @dev Increase the amount of tokens that an owner allowed to a spender.
1455      * approve should be called when allowed_[_spender] == 0. To increment
1456      * allowed value is better to use this function to avoid 2 calls (and wait until
1457      * the first transaction is mined)
1458      * From MonolithDAO Token.sol
1459      * Emits an Approval event.
1460      * @param spender The address which will spend the funds.
1461      * @param addedValue The amount of tokens to increase the allowance by.
1462      */
1463     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1464         require(spender != address(0));
1465 
1466         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
1467         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1468         return true;
1469     }
1470 
1471     /**
1472      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1473      * approve should be called when allowed_[_spender] == 0. To decrement
1474      * allowed value is better to use this function to avoid 2 calls (and wait until
1475      * the first transaction is mined)
1476      * From MonolithDAO Token.sol
1477      * Emits an Approval event.
1478      * @param spender The address which will spend the funds.
1479      * @param subtractedValue The amount of tokens to decrease the allowance by.
1480      */
1481     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1482         require(spender != address(0));
1483 
1484         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
1485         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1486         return true;
1487     }
1488 
1489     /**
1490     * @dev Transfer token for a specified addresses
1491     * @param from The address to transfer from.
1492     * @param to The address to transfer to.
1493     * @param value The amount to be transferred.
1494     */
1495     function _transfer(address from, address to, uint256 value) internal {
1496         require(to != address(0));
1497 
1498         _balances[from] = _balances[from].sub(value);
1499         _balances[to] = _balances[to].add(value);
1500         emit Transfer(from, to, value);
1501     }
1502 
1503     /**
1504      * @dev Internal function that mints an amount of the token and assigns it to
1505      * an account. This encapsulates the modification of balances such that the
1506      * proper events are emitted.
1507      * @param account The account that will receive the created tokens.
1508      * @param value The amount that will be created.
1509      */
1510     function _mint(address account, uint256 value) internal {
1511         require(account != address(0));
1512 
1513         _totalSupply = _totalSupply.add(value);
1514         _balances[account] = _balances[account].add(value);
1515         emit Transfer(address(0), account, value);
1516     }
1517 
1518     /**
1519      * @dev Internal function that burns an amount of the token of a given
1520      * account.
1521      * @param account The account whose tokens will be burnt.
1522      * @param value The amount that will be burnt.
1523      */
1524     function _burn(address account, uint256 value) internal {
1525         require(account != address(0));
1526 
1527         _totalSupply = _totalSupply.sub(value);
1528         _balances[account] = _balances[account].sub(value);
1529         emit Transfer(account, address(0), value);
1530     }
1531 
1532     /**
1533      * @dev Internal function that burns an amount of the token of a given
1534      * account, deducting from the sender's allowance for said account. Uses the
1535      * internal burn function.
1536      * Emits an Approval event (reflecting the reduced allowance).
1537      * @param account The account whose tokens will be burnt.
1538      * @param value The amount that will be burnt.
1539      */
1540     function _burnFrom(address account, uint256 value) internal {
1541         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
1542         _burn(account, value);
1543         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
1544     }
1545 }
1546 
1547 /**
1548  * @title Ownable
1549  * @dev The Ownable contract has an owner address, and provides basic authorization control
1550  * functions, this simplifies the implementation of "user permissions".
1551  */
1552 contract Ownable {
1553     address private _owner;
1554 
1555     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1556 
1557     /**
1558      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1559      * account.
1560      */
1561     constructor () internal {
1562         _owner = msg.sender;
1563         emit OwnershipTransferred(address(0), _owner);
1564     }
1565 
1566     /**
1567      * @return the address of the owner.
1568      */
1569     function owner() public view returns (address) {
1570         return _owner;
1571     }
1572 
1573     /**
1574      * @dev Throws if called by any account other than the owner.
1575      */
1576     modifier onlyOwner() {
1577         require(isOwner());
1578         _;
1579     }
1580 
1581     /**
1582      * @return true if `msg.sender` is the owner of the contract.
1583      */
1584     function isOwner() public view returns (bool) {
1585         return msg.sender == _owner;
1586     }
1587 
1588     /**
1589      * @dev Allows the current owner to relinquish control of the contract.
1590      * @notice Renouncing to ownership will leave the contract without an owner.
1591      * It will not be possible to call the functions with the `onlyOwner`
1592      * modifier anymore.
1593      */
1594     function renounceOwnership() public onlyOwner {
1595         emit OwnershipTransferred(_owner, address(0));
1596         _owner = address(0);
1597     }
1598 
1599     /**
1600      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1601      * @param newOwner The address to transfer ownership to.
1602      */
1603     function transferOwnership(address newOwner) public onlyOwner {
1604         _transferOwnership(newOwner);
1605     }
1606 
1607     /**
1608      * @dev Transfers control of the contract to a newOwner.
1609      * @param newOwner The address to transfer ownership to.
1610      */
1611     function _transferOwnership(address newOwner) internal {
1612         require(newOwner != address(0));
1613         emit OwnershipTransferred(_owner, newOwner);
1614         _owner = newOwner;
1615     }
1616 }
1617 
1618 /**
1619  * @title ERC20Detailed token
1620  * @dev The decimals are only for visualization purposes.
1621  * All the operations are done using the smallest and indivisible token unit,
1622  * just as on Ethereum all the operations are done in wei.
1623  */
1624 contract ERC20Detailed is ERC20, Ownable {
1625     string private _name = 'Viribustoken';
1626     string private _symbol = 'VRBS';
1627     uint8 private _decimals = 18;
1628 
1629     /**
1630      * @return the name of the token.
1631      */
1632     function name() public view returns (string) {
1633         return _name;
1634     }
1635 
1636     /**
1637      * @return the symbol of the token.
1638      */
1639     function symbol() public view returns (string) {
1640         return _symbol;
1641     }
1642 
1643     /**
1644      * @return the number of decimals of the token.
1645      */
1646     function decimals() public view returns (uint8) {
1647         return _decimals;
1648     }
1649 
1650     /**
1651      * @dev Burns a specific amount of tokens.
1652      * @param value The amount of token to be burned.
1653      */
1654     function burn(uint256 value) public {
1655         _burn(msg.sender, value);
1656     }
1657 
1658     /**
1659      * @dev Burns a specific amount of tokens from the target address and decrements allowance
1660      * @param from address The address which you want to send tokens from
1661      * @param value uint256 The amount of token to be burned
1662      */
1663     function burnFrom(address from, uint256 value) public {
1664         _burnFrom(from, value);
1665     }
1666 
1667     /**
1668      * @dev Function to mint tokens
1669      * @param to The address that will receive the minted tokens.
1670      * @param value The amount of tokens to mint.
1671      * @return A boolean that indicates if the operation was successful.
1672      */
1673     function mint(address to, uint256 value) public onlyOwner returns (bool) {
1674         _mint(to, value);
1675         return true;
1676     }
1677 }
1678 
1679 contract VRBS is ERC20Detailed, usingOraclize {
1680     using SafeMath for uint256;
1681 
1682     address public holder;
1683     uint256 public cursETHtoUSD = 150;
1684     uint256 public costUSD = 6600;
1685     uint256 public costETH;
1686     uint256 public DEC = 10 ** 18;
1687     bool public salesOpen = true;
1688     uint256 public emissionCap = 19700 * DEC;
1689 
1690     event SwitchSales(bool open);
1691     event NewCostETH(uint newCostETH);
1692     event LogPriceUpdated(string price);
1693     event LogNewOraclizeQuery(string description);
1694     event Sell(address sender, uint256 tokens, uint256 cursETHtoUSD, uint256 costUSD);
1695 
1696     constructor() public {
1697         holder = msg.sender;
1698         updateCostETH();
1699         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1700     }
1701 
1702     function __callback(bytes32 myid, string result, bytes proof) public {
1703         if (msg.sender != oraclize_cbAddress()) revert();
1704         cursETHtoUSD = parseInt(result);
1705         updateCostETH();
1706         updatePrice();
1707     }
1708 
1709     modifier sellIsOpen() {
1710         require(salesOpen == true, "Selling are closed");
1711         _;
1712     }
1713 
1714     function updatePrice() sellIsOpen payable public {
1715         if (oraclize_getPrice("URL") > address(this).balance) {
1716             emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1717         } else {
1718             emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1719             //43200 = 12 hour
1720             oraclize_query(43200, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1721         }
1722     }
1723 
1724     function setGasPrice(uint _newPrice) onlyOwner public {
1725         oraclize_setCustomGasPrice(_newPrice * 1 wei);
1726     }
1727 
1728     function addBalanceForOraclize() payable external { }
1729 
1730     function setSalesState(bool newSalesState) public onlyOwner {
1731         salesOpen = newSalesState;
1732         emit SwitchSales(newSalesState);
1733     }
1734 
1735     function setHolder(address newHolder) public onlyOwner {
1736         holder = newHolder;
1737     }
1738 
1739     function updateCursETHtoUSD(uint _value) onlyOwner public {
1740         cursETHtoUSD = _value;
1741         updateCostETH();
1742     }
1743 
1744     function updateCostUSD(uint _value) onlyOwner public {
1745         costUSD = _value;
1746         updateCostETH();
1747     }
1748 
1749     function updateCostETH() internal {
1750         costETH = (costUSD * 1 ether).div(cursETHtoUSD);
1751         emit NewCostETH(costETH);
1752     }
1753 
1754     function setEmissionCap(uint newEmissionCap) public onlyOwner {
1755         require(totalSupply() <= newEmissionCap * DEC, "totalSupply mustn't be great than newEmissionCap.");
1756         emissionCap = newEmissionCap * DEC;
1757     }
1758 
1759     function createTokens() public sellIsOpen payable {
1760         require(msg.value > 0, "Amount must be greater than 0");
1761         uint tokens = msg.value.mul(DEC).div(costETH);
1762         require(tokens > 0, "Amount must be greater");
1763         require(totalSupply().add(tokens) <= emissionCap, "emissionCap reached");
1764         holder.transfer(msg.value);
1765         _mint(msg.sender, tokens);
1766         emit Sell(msg.sender, tokens, cursETHtoUSD, costUSD);
1767     }
1768 
1769     function() public payable {
1770         createTokens();
1771     }
1772 }