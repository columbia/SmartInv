1 pragma solidity ^0.4.21;
2 // <ORACLIZE_API>
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 
7 
8 
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 
16 
17 
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 
21 
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
24 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
25 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
26 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
27 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
28 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
29 THE SOFTWARE.
30 */
31 
32 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
41     function getPrice(string _datasource) public returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
43     function setProofType(byte _proofType) external;
44     function setCustomGasPrice(uint _gasPrice) external;
45     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
46 }
47 
48 contract OraclizeAddrResolverI {
49     function getAddress() public returns (address _addr);
50 }
51 
52 /*
53 Begin solidity-cborutils
54 
55 https://github.com/smartcontractkit/solidity-cborutils
56 
57 MIT License
58 
59 Copyright (c) 2018 SmartContract ChainLink, Ltd.
60 
61 Permission is hereby granted, free of charge, to any person obtaining a copy
62 of this software and associated documentation files (the "Software"), to deal
63 in the Software without restriction, including without limitation the rights
64 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
65 copies of the Software, and to permit persons to whom the Software is
66 furnished to do so, subject to the following conditions:
67 
68 The above copyright notice and this permission notice shall be included in all
69 copies or substantial portions of the Software.
70 
71 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
72 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
73 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
74 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
75 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
76 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
77 SOFTWARE.
78  */
79 
80 library Buffer {
81     struct buffer {
82         bytes buf;
83         uint capacity;
84     }
85 
86     function init(buffer memory buf, uint capacity) internal pure {
87         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
88         // Allocate space for the buffer data
89         buf.capacity = capacity;
90         assembly {
91             let ptr := mload(0x40)
92             mstore(buf, ptr)
93             mstore(0x40, add(ptr, capacity))
94         }
95     }
96 
97     function resize(buffer memory buf, uint capacity) private pure {
98         bytes memory oldbuf = buf.buf;
99         init(buf, capacity);
100         append(buf, oldbuf);
101     }
102 
103     function max(uint a, uint b) private pure returns(uint) {
104         if(a > b) {
105             return a;
106         }
107         return b;
108     }
109 
110     /**
111      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
112      *      would exceed the capacity of the buffer.
113      * @param buf The buffer to append to.
114      * @param data The data to append.
115      * @return The original buffer.
116      */
117     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
118         if(data.length + buf.buf.length > buf.capacity) {
119             resize(buf, max(buf.capacity, data.length) * 2);
120         }
121 
122         uint dest;
123         uint src;
124         uint len = data.length;
125         assembly {
126             // Memory address of the buffer data
127             let bufptr := mload(buf)
128             // Length of existing buffer data
129             let buflen := mload(bufptr)
130             // Start address = buffer address + buffer length + sizeof(buffer length)
131             dest := add(add(bufptr, buflen), 32)
132             // Update buffer length
133             mstore(bufptr, add(buflen, mload(data)))
134             src := add(data, 32)
135         }
136 
137         // Copy word-length chunks while possible
138         for(; len >= 32; len -= 32) {
139             assembly {
140                 mstore(dest, mload(src))
141             }
142             dest += 32;
143             src += 32;
144         }
145 
146         // Copy remaining bytes
147         uint mask = 256 ** (32 - len) - 1;
148         assembly {
149             let srcpart := and(mload(src), not(mask))
150             let destpart := and(mload(dest), mask)
151             mstore(dest, or(destpart, srcpart))
152         }
153 
154         return buf;
155     }
156 
157     /**
158      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
159      * exceed the capacity of the buffer.
160      * @param buf The buffer to append to.
161      * @param data The data to append.
162      * @return The original buffer.
163      */
164     function append(buffer memory buf, uint8 data) internal pure {
165         if(buf.buf.length + 1 > buf.capacity) {
166             resize(buf, buf.capacity * 2);
167         }
168 
169         assembly {
170             // Memory address of the buffer data
171             let bufptr := mload(buf)
172             // Length of existing buffer data
173             let buflen := mload(bufptr)
174             // Address = buffer address + buffer length + sizeof(buffer length)
175             let dest := add(add(bufptr, buflen), 32)
176             mstore8(dest, data)
177             // Update buffer length
178             mstore(bufptr, add(buflen, 1))
179         }
180     }
181 
182     /**
183      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
184      * exceed the capacity of the buffer.
185      * @param buf The buffer to append to.
186      * @param data The data to append.
187      * @return The original buffer.
188      */
189     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
190         if(len + buf.buf.length > buf.capacity) {
191             resize(buf, max(buf.capacity, len) * 2);
192         }
193 
194         uint mask = 256 ** len - 1;
195         assembly {
196             // Memory address of the buffer data
197             let bufptr := mload(buf)
198             // Length of existing buffer data
199             let buflen := mload(bufptr)
200             // Address = buffer address + buffer length + sizeof(buffer length) + len
201             let dest := add(add(bufptr, buflen), len)
202             mstore(dest, or(and(mload(dest), not(mask)), data))
203             // Update buffer length
204             mstore(bufptr, add(buflen, len))
205         }
206         return buf;
207     }
208 }
209 
210 library CBOR {
211     using Buffer for Buffer.buffer;
212 
213     uint8 private constant MAJOR_TYPE_INT = 0;
214     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
215     uint8 private constant MAJOR_TYPE_BYTES = 2;
216     uint8 private constant MAJOR_TYPE_STRING = 3;
217     uint8 private constant MAJOR_TYPE_ARRAY = 4;
218     uint8 private constant MAJOR_TYPE_MAP = 5;
219     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
220 
221     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
222         if(value <= 23) {
223             buf.append(uint8((major << 5) | value));
224         } else if(value <= 0xFF) {
225             buf.append(uint8((major << 5) | 24));
226             buf.appendInt(value, 1);
227         } else if(value <= 0xFFFF) {
228             buf.append(uint8((major << 5) | 25));
229             buf.appendInt(value, 2);
230         } else if(value <= 0xFFFFFFFF) {
231             buf.append(uint8((major << 5) | 26));
232             buf.appendInt(value, 4);
233         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
234             buf.append(uint8((major << 5) | 27));
235             buf.appendInt(value, 8);
236         }
237     }
238 
239     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
240         buf.append(uint8((major << 5) | 31));
241     }
242 
243     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
244         encodeType(buf, MAJOR_TYPE_INT, value);
245     }
246 
247     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
248         if(value >= 0) {
249             encodeType(buf, MAJOR_TYPE_INT, uint(value));
250         } else {
251             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
252         }
253     }
254 
255     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
256         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
257         buf.append(value);
258     }
259 
260     function encodeString(Buffer.buffer memory buf, string value) internal pure {
261         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
262         buf.append(bytes(value));
263     }
264 
265     function startArray(Buffer.buffer memory buf) internal pure {
266         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
267     }
268 
269     function startMap(Buffer.buffer memory buf) internal pure {
270         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
271     }
272 
273     function endSequence(Buffer.buffer memory buf) internal pure {
274         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
275     }
276 }
277 
278 /*
279 End solidity-cborutils
280  */
281 
282 contract usingOraclize {
283     uint constant day = 60*60*24;
284     uint constant week = 60*60*24*7;
285     uint constant month = 60*60*24*30;
286     byte constant proofType_NONE = 0x00;
287     byte constant proofType_TLSNotary = 0x10;
288     byte constant proofType_Android = 0x20;
289     byte constant proofType_Ledger = 0x30;
290     byte constant proofType_Native = 0xF0;
291     byte constant proofStorage_IPFS = 0x01;
292     uint8 constant networkID_auto = 0;
293     uint8 constant networkID_mainnet = 1;
294     uint8 constant networkID_testnet = 2;
295     uint8 constant networkID_morden = 2;
296     uint8 constant networkID_consensys = 161;
297 
298     OraclizeAddrResolverI OAR;
299 
300     OraclizeI oraclize;
301     modifier oraclizeAPI {
302         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
303             oraclize_setNetwork(networkID_auto);
304 
305         if(address(oraclize) != OAR.getAddress())
306             oraclize = OraclizeI(OAR.getAddress());
307 
308         _;
309     }
310     modifier coupon(string code){
311         oraclize = OraclizeI(OAR.getAddress());
312         _;
313     }
314 
315     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
316       return oraclize_setNetwork();
317       networkID; // silence the warning and remain backwards compatible
318     }
319     function oraclize_setNetwork() internal returns(bool){
320         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
321             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
322             oraclize_setNetworkName("eth_mainnet");
323             return true;
324         }
325         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
326             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
327             oraclize_setNetworkName("eth_ropsten3");
328             return true;
329         }
330         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
331             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
332             oraclize_setNetworkName("eth_kovan");
333             return true;
334         }
335         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
336             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
337             oraclize_setNetworkName("eth_rinkeby");
338             return true;
339         }
340         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
341             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
342             return true;
343         }
344         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
345             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
346             return true;
347         }
348         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
349             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
350             return true;
351         }
352         return false;
353     }
354 
355     function __callback(bytes32 myid, string result) public {
356         __callback(myid, result, new bytes(0));
357     }
358     function __callback(bytes32 myid, string result, bytes proof) public {
359       return;
360       myid; result; proof; // Silence compiler warnings
361     }
362 
363     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
364         return oraclize.getPrice(datasource);
365     }
366 
367     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
368         return oraclize.getPrice(datasource, gaslimit);
369     }
370 
371     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
372         uint price = oraclize.getPrice(datasource);
373         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
374         return oraclize.query.value(price)(0, datasource, arg);
375     }
376     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource);
378         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
379         return oraclize.query.value(price)(timestamp, datasource, arg);
380     }
381     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource, gaslimit);
383         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
384         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
385     }
386     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource, gaslimit);
388         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
389         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
390     }
391     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource);
393         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
394         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
395     }
396     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource);
398         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
399         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
400     }
401     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
405     }
406     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource, gaslimit);
408         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
409         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
410     }
411     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource);
413         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
414         bytes memory args = stra2cbor(argN);
415         return oraclize.queryN.value(price)(0, datasource, args);
416     }
417     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
418         uint price = oraclize.getPrice(datasource);
419         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
420         bytes memory args = stra2cbor(argN);
421         return oraclize.queryN.value(price)(timestamp, datasource, args);
422     }
423     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
424         uint price = oraclize.getPrice(datasource, gaslimit);
425         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
426         bytes memory args = stra2cbor(argN);
427         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
428     }
429     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource, gaslimit);
431         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
432         bytes memory args = stra2cbor(argN);
433         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
434     }
435     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
436         string[] memory dynargs = new string[](1);
437         dynargs[0] = args[0];
438         return oraclize_query(datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(timestamp, datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
449     }
450     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(datasource, dynargs, gaslimit);
454     }
455 
456     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](2);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         return oraclize_query(datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](2);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         return oraclize_query(timestamp, datasource, dynargs);
467     }
468     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](2);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         string[] memory dynargs = new string[](2);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](3);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         return oraclize_query(datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
488         string[] memory dynargs = new string[](3);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         return oraclize_query(timestamp, datasource, dynargs);
493     }
494     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](3);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
500     }
501     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         string[] memory dynargs = new string[](3);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         return oraclize_query(datasource, dynargs, gaslimit);
507     }
508 
509     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](4);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         dynargs[3] = args[3];
515         return oraclize_query(datasource, dynargs);
516     }
517     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](4);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         dynargs[2] = args[2];
522         dynargs[3] = args[3];
523         return oraclize_query(timestamp, datasource, dynargs);
524     }
525     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
526         string[] memory dynargs = new string[](4);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         dynargs[2] = args[2];
530         dynargs[3] = args[3];
531         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
532     }
533     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](4);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         dynargs[2] = args[2];
538         dynargs[3] = args[3];
539         return oraclize_query(datasource, dynargs, gaslimit);
540     }
541     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
542         string[] memory dynargs = new string[](5);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         dynargs[3] = args[3];
547         dynargs[4] = args[4];
548         return oraclize_query(datasource, dynargs);
549     }
550     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](5);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         dynargs[3] = args[3];
556         dynargs[4] = args[4];
557         return oraclize_query(timestamp, datasource, dynargs);
558     }
559     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](5);
561         dynargs[0] = args[0];
562         dynargs[1] = args[1];
563         dynargs[2] = args[2];
564         dynargs[3] = args[3];
565         dynargs[4] = args[4];
566         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
567     }
568     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](5);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         dynargs[2] = args[2];
573         dynargs[3] = args[3];
574         dynargs[4] = args[4];
575         return oraclize_query(datasource, dynargs, gaslimit);
576     }
577     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
578         uint price = oraclize.getPrice(datasource);
579         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
580         bytes memory args = ba2cbor(argN);
581         return oraclize.queryN.value(price)(0, datasource, args);
582     }
583     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
584         uint price = oraclize.getPrice(datasource);
585         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
586         bytes memory args = ba2cbor(argN);
587         return oraclize.queryN.value(price)(timestamp, datasource, args);
588     }
589     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
590         uint price = oraclize.getPrice(datasource, gaslimit);
591         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
592         bytes memory args = ba2cbor(argN);
593         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
594     }
595     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
596         uint price = oraclize.getPrice(datasource, gaslimit);
597         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
598         bytes memory args = ba2cbor(argN);
599         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
600     }
601     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
602         bytes[] memory dynargs = new bytes[](1);
603         dynargs[0] = args[0];
604         return oraclize_query(datasource, dynargs);
605     }
606     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](1);
608         dynargs[0] = args[0];
609         return oraclize_query(timestamp, datasource, dynargs);
610     }
611     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](1);
613         dynargs[0] = args[0];
614         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
615     }
616     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](1);
618         dynargs[0] = args[0];
619         return oraclize_query(datasource, dynargs, gaslimit);
620     }
621 
622     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](2);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         return oraclize_query(datasource, dynargs);
627     }
628     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](2);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         return oraclize_query(timestamp, datasource, dynargs);
633     }
634     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](2);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
639     }
640     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
641         bytes[] memory dynargs = new bytes[](2);
642         dynargs[0] = args[0];
643         dynargs[1] = args[1];
644         return oraclize_query(datasource, dynargs, gaslimit);
645     }
646     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](3);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         dynargs[2] = args[2];
651         return oraclize_query(datasource, dynargs);
652     }
653     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
654         bytes[] memory dynargs = new bytes[](3);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         return oraclize_query(timestamp, datasource, dynargs);
659     }
660     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](3);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
666     }
667     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
668         bytes[] memory dynargs = new bytes[](3);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         dynargs[2] = args[2];
672         return oraclize_query(datasource, dynargs, gaslimit);
673     }
674 
675     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](4);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         dynargs[2] = args[2];
680         dynargs[3] = args[3];
681         return oraclize_query(datasource, dynargs);
682     }
683     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](4);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         dynargs[3] = args[3];
689         return oraclize_query(timestamp, datasource, dynargs);
690     }
691     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
692         bytes[] memory dynargs = new bytes[](4);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
698     }
699     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](4);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         dynargs[3] = args[3];
705         return oraclize_query(datasource, dynargs, gaslimit);
706     }
707     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
708         bytes[] memory dynargs = new bytes[](5);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         dynargs[2] = args[2];
712         dynargs[3] = args[3];
713         dynargs[4] = args[4];
714         return oraclize_query(datasource, dynargs);
715     }
716     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](5);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         dynargs[3] = args[3];
722         dynargs[4] = args[4];
723         return oraclize_query(timestamp, datasource, dynargs);
724     }
725     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
726         bytes[] memory dynargs = new bytes[](5);
727         dynargs[0] = args[0];
728         dynargs[1] = args[1];
729         dynargs[2] = args[2];
730         dynargs[3] = args[3];
731         dynargs[4] = args[4];
732         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
733     }
734     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](5);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         dynargs[2] = args[2];
739         dynargs[3] = args[3];
740         dynargs[4] = args[4];
741         return oraclize_query(datasource, dynargs, gaslimit);
742     }
743 
744     function oraclize_cbAddress() oraclizeAPI internal returns (address){
745         return oraclize.cbAddress();
746     }
747     function oraclize_setProof(byte proofP) oraclizeAPI internal {
748         return oraclize.setProofType(proofP);
749     }
750     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
751         return oraclize.setCustomGasPrice(gasPrice);
752     }
753 
754     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
755         return oraclize.randomDS_getSessionPubKeyHash();
756     }
757 
758     function getCodeSize(address _addr) constant internal returns(uint _size) {
759         assembly {
760             _size := extcodesize(_addr)
761         }
762     }
763 
764     function parseAddr(string _a) internal pure returns (address){
765         bytes memory tmp = bytes(_a);
766         uint160 iaddr = 0;
767         uint160 b1;
768         uint160 b2;
769         for (uint i=2; i<2+2*20; i+=2){
770             iaddr *= 256;
771             b1 = uint160(tmp[i]);
772             b2 = uint160(tmp[i+1]);
773             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
774             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
775             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
776             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
777             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
778             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
779             iaddr += (b1*16+b2);
780         }
781         return address(iaddr);
782     }
783 
784     function strCompare(string _a, string _b) internal pure returns (int) {
785         bytes memory a = bytes(_a);
786         bytes memory b = bytes(_b);
787         uint minLength = a.length;
788         if (b.length < minLength) minLength = b.length;
789         for (uint i = 0; i < minLength; i ++)
790             if (a[i] < b[i])
791                 return -1;
792             else if (a[i] > b[i])
793                 return 1;
794         if (a.length < b.length)
795             return -1;
796         else if (a.length > b.length)
797             return 1;
798         else
799             return 0;
800     }
801 
802     function indexOf(string _haystack, string _needle) internal pure returns (int) {
803         bytes memory h = bytes(_haystack);
804         bytes memory n = bytes(_needle);
805         if(h.length < 1 || n.length < 1 || (n.length > h.length))
806             return -1;
807         else if(h.length > (2**128 -1))
808             return -1;
809         else
810         {
811             uint subindex = 0;
812             for (uint i = 0; i < h.length; i ++)
813             {
814                 if (h[i] == n[0])
815                 {
816                     subindex = 1;
817                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
818                     {
819                         subindex++;
820                     }
821                     if(subindex == n.length)
822                         return int(i);
823                 }
824             }
825             return -1;
826         }
827     }
828 
829     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
830         bytes memory _ba = bytes(_a);
831         bytes memory _bb = bytes(_b);
832         bytes memory _bc = bytes(_c);
833         bytes memory _bd = bytes(_d);
834         bytes memory _be = bytes(_e);
835         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
836         bytes memory babcde = bytes(abcde);
837         uint k = 0;
838         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
839         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
840         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
841         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
842         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
843         return string(babcde);
844     }
845 
846     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
847         return strConcat(_a, _b, _c, _d, "");
848     }
849 
850     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
851         return strConcat(_a, _b, _c, "", "");
852     }
853 
854     function strConcat(string _a, string _b) internal pure returns (string) {
855         return strConcat(_a, _b, "", "", "");
856     }
857 
858     // parseInt
859     function parseInt(string _a) internal pure returns (uint) {
860         return parseInt(_a, 0);
861     }
862 
863     // parseInt(parseFloat*10^_b)
864     function parseInt(string _a, uint _b) internal pure returns (uint) {
865         bytes memory bresult = bytes(_a);
866         uint mint = 0;
867         bool decimals = false;
868         for (uint i=0; i<bresult.length; i++){
869             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
870                 if (decimals){
871                    if (_b == 0) break;
872                     else _b--;
873                 }
874                 mint *= 10;
875                 mint += uint(bresult[i]) - 48;
876             } else if (bresult[i] == 46) decimals = true;
877         }
878         if (_b > 0) mint *= 10**_b;
879         return mint;
880     }
881 
882     function uint2str(uint i) internal pure returns (string){
883         if (i == 0) return "0";
884         uint j = i;
885         uint len;
886         while (j != 0){
887             len++;
888             j /= 10;
889         }
890         bytes memory bstr = new bytes(len);
891         uint k = len - 1;
892         while (i != 0){
893             bstr[k--] = byte(48 + i % 10);
894             i /= 10;
895         }
896         return string(bstr);
897     }
898 
899     using CBOR for Buffer.buffer;
900     function stra2cbor(string[] arr) internal pure returns (bytes) {
901         Buffer.buffer memory buf;
902         Buffer.init(buf, 1024);
903         buf.startArray();
904         for (uint i = 0; i < arr.length; i++) {
905             buf.encodeString(arr[i]);
906         }
907         buf.endSequence();
908         return buf.buf;
909     }
910 
911     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
912         Buffer.buffer memory buf;
913         Buffer.init(buf, 1024);
914         buf.startArray();
915         for (uint i = 0; i < arr.length; i++) {
916             buf.encodeBytes(arr[i]);
917         }
918         buf.endSequence();
919         return buf.buf;
920     }
921 
922     string oraclize_network_name;
923     function oraclize_setNetworkName(string _network_name) internal {
924         oraclize_network_name = _network_name;
925     }
926 
927     function oraclize_getNetworkName() internal view returns (string) {
928         return oraclize_network_name;
929     }
930 
931     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
932         require((_nbytes > 0) && (_nbytes <= 32));
933         // Convert from seconds to ledger timer ticks
934         _delay *= 10;
935         bytes memory nbytes = new bytes(1);
936         nbytes[0] = byte(_nbytes);
937         bytes memory unonce = new bytes(32);
938         bytes memory sessionKeyHash = new bytes(32);
939         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
940         assembly {
941             mstore(unonce, 0x20)
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
972         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
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
1084         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
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
1102         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
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
1163             // NOTE: we can reuse the request memory because we deal with
1164             //       the return code
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
1179           return (false, 0);
1180 
1181         // The signature format is a compact form of:
1182         //   {bytes32 r}{bytes32 s}{uint8 v}
1183         // Compact means, uint8 is not padded to 32 bytes.
1184         assembly {
1185             r := mload(add(sig, 32))
1186             s := mload(add(sig, 64))
1187 
1188             // Here we are loading the last 32 bytes. We exploit the fact that
1189             // 'mload' will pad with zeroes if we overread.
1190             // There is no 'mload8' to do this, but that would be nicer.
1191             v := byte(0, mload(add(sig, 96)))
1192 
1193             // Alternative solution:
1194             // 'byte' is not working due to the Solidity parser, so lets
1195             // use the second best option, 'and'
1196             // v := and(mload(add(sig, 65)), 255)
1197         }
1198 
1199         // albeit non-transactional signatures are not specified by the YP, one would expect it
1200         // to match the YP range of [27, 28]
1201         //
1202         // geth uses [0, 1] and some clients have followed. This might change, see:
1203         //  https://github.com/ethereum/go-ethereum/issues/2053
1204         if (v < 27)
1205           v += 27;
1206 
1207         if (v != 27 && v != 28)
1208             return (false, 0);
1209 
1210         return safer_ecrecover(hash, v, r, s);
1211     }
1212 
1213 }
1214 // </ORACLIZE_API>
1215 /*
1216  * @title String & slice utility library for Solidity contracts.
1217  * @author Nick Johnson <arachnid@notdot.net>
1218  *
1219  * @dev Functionality in this library is largely implemented using an
1220  *      abstraction called a 'slice'. A slice represents a part of a string -
1221  *      anything from the entire string to a single character, or even no
1222  *      characters at all (a 0-length slice). Since a slice only has to specify
1223  *      an offset and a length, copying and manipulating slices is a lot less
1224  *      expensive than copying and manipulating the strings they reference.
1225  *
1226  *      To further reduce gas costs, most functions on slice that need to return
1227  *      a slice modify the original one instead of allocating a new one; for
1228  *      instance, `s.split(".")` will return the text up to the first '.',
1229  *      modifying s to only contain the remainder of the string after the '.'.
1230  *      In situations where you do not want to modify the original slice, you
1231  *      can make a copy first with `.copy()`, for example:
1232  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1233  *      Solidity has no memory management, it will result in allocating many
1234  *      short-lived slices that are later discarded.
1235  *
1236  *      Functions that return two slices come in two versions: a non-allocating
1237  *      version that takes the second slice as an argument, modifying it in
1238  *      place, and an allocating version that allocates and returns the second
1239  *      slice; see `nextRune` for example.
1240  *
1241  *      Functions that have to copy string data will return strings rather than
1242  *      slices; these can be cast back to slices for further processing if
1243  *      required.
1244  *
1245  *      For convenience, some functions are provided with non-modifying
1246  *      variants that create a new slice and return both; for instance,
1247  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1248  *      corresponding to the left and right parts of the string.
1249  */
1250 library strings {
1251     struct slice {
1252         uint _len;
1253         uint _ptr;
1254     }
1255 
1256     function memcpy(uint dest, uint src, uint len) private pure {
1257         // Copy word-length chunks while possible
1258         for(; len >= 32; len -= 32) {
1259             assembly {
1260                 mstore(dest, mload(src))
1261             }
1262             dest += 32;
1263             src += 32;
1264         }
1265 
1266         // Copy remaining bytes
1267         uint mask = 256 ** (32 - len) - 1;
1268         assembly {
1269             let srcpart := and(mload(src), not(mask))
1270             let destpart := and(mload(dest), mask)
1271             mstore(dest, or(destpart, srcpart))
1272         }
1273     }
1274 
1275     /*
1276      * @dev Returns a slice containing the entire string.
1277      * @param self The string to make a slice from.
1278      * @return A newly allocated slice containing the entire string.
1279      */
1280     function toSlice(string self) internal pure returns (slice) {
1281         uint ptr;
1282         assembly {
1283             ptr := add(self, 0x20)
1284         }
1285         return slice(bytes(self).length, ptr);
1286     }
1287 
1288     /*
1289      * @dev Returns the length of a null-terminated bytes32 string.
1290      * @param self The value to find the length of.
1291      * @return The length of the string, from 0 to 32.
1292      */
1293     function len(bytes32 self) internal pure returns (uint) {
1294         uint ret;
1295         if (self == 0)
1296             return 0;
1297         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1298             ret += 16;
1299             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1300         }
1301         if (self & 0xffffffffffffffff == 0) {
1302             ret += 8;
1303             self = bytes32(uint(self) / 0x10000000000000000);
1304         }
1305         if (self & 0xffffffff == 0) {
1306             ret += 4;
1307             self = bytes32(uint(self) / 0x100000000);
1308         }
1309         if (self & 0xffff == 0) {
1310             ret += 2;
1311             self = bytes32(uint(self) / 0x10000);
1312         }
1313         if (self & 0xff == 0) {
1314             ret += 1;
1315         }
1316         return 32 - ret;
1317     }
1318 
1319     /*
1320      * @dev Returns a slice containing the entire bytes32, interpreted as a
1321      *      null-termintaed utf-8 string.
1322      * @param self The bytes32 value to convert to a slice.
1323      * @return A new slice containing the value of the input argument up to the
1324      *         first null.
1325      */
1326     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
1327         // Allocate space for `self` in memory, copy it there, and point ret at it
1328         assembly {
1329             let ptr := mload(0x40)
1330             mstore(0x40, add(ptr, 0x20))
1331             mstore(ptr, self)
1332             mstore(add(ret, 0x20), ptr)
1333         }
1334         ret._len = len(self);
1335     }
1336 
1337     /*
1338      * @dev Returns a new slice containing the same data as the current slice.
1339      * @param self The slice to copy.
1340      * @return A new slice containing the same data as `self`.
1341      */
1342     function copy(slice self) internal pure returns (slice) {
1343         return slice(self._len, self._ptr);
1344     }
1345 
1346     /*
1347      * @dev Copies a slice to a new string.
1348      * @param self The slice to copy.
1349      * @return A newly allocated string containing the slice's text.
1350      */
1351     function toString(slice self) internal pure returns (string) {
1352         string memory ret = new string(self._len);
1353         uint retptr;
1354         assembly { retptr := add(ret, 32) }
1355 
1356         memcpy(retptr, self._ptr, self._len);
1357         return ret;
1358     }
1359 
1360     /*
1361      * @dev Returns the length in runes of the slice. Note that this operation
1362      *      takes time proportional to the length of the slice; avoid using it
1363      *      in loops, and call `slice.empty()` if you only need to know whether
1364      *      the slice is empty or not.
1365      * @param self The slice to operate on.
1366      * @return The length of the slice in runes.
1367      */
1368     function len(slice self) internal pure returns (uint l) {
1369         // Starting at ptr-31 means the LSB will be the byte we care about
1370         uint ptr = self._ptr - 31;
1371         uint end = ptr + self._len;
1372         for (l = 0; ptr < end; l++) {
1373             uint8 b;
1374             assembly { b := and(mload(ptr), 0xFF) }
1375             if (b < 0x80) {
1376                 ptr += 1;
1377             } else if(b < 0xE0) {
1378                 ptr += 2;
1379             } else if(b < 0xF0) {
1380                 ptr += 3;
1381             } else if(b < 0xF8) {
1382                 ptr += 4;
1383             } else if(b < 0xFC) {
1384                 ptr += 5;
1385             } else {
1386                 ptr += 6;
1387             }
1388         }
1389     }
1390 
1391     /*
1392      * @dev Returns true if the slice is empty (has a length of 0).
1393      * @param self The slice to operate on.
1394      * @return True if the slice is empty, False otherwise.
1395      */
1396     function empty(slice self) internal pure returns (bool) {
1397         return self._len == 0;
1398     }
1399 
1400     /*
1401      * @dev Returns a positive number if `other` comes lexicographically after
1402      *      `self`, a negative number if it comes before, or zero if the
1403      *      contents of the two slices are equal. Comparison is done per-rune,
1404      *      on unicode codepoints.
1405      * @param self The first slice to compare.
1406      * @param other The second slice to compare.
1407      * @return The result of the comparison.
1408      */
1409     function compare(slice self, slice other) internal pure returns (int) {
1410         uint shortest = self._len;
1411         if (other._len < self._len)
1412             shortest = other._len;
1413 
1414         uint selfptr = self._ptr;
1415         uint otherptr = other._ptr;
1416         for (uint idx = 0; idx < shortest; idx += 32) {
1417             uint a;
1418             uint b;
1419             assembly {
1420                 a := mload(selfptr)
1421                 b := mload(otherptr)
1422             }
1423             if (a != b) {
1424                 // Mask out irrelevant bytes and check again
1425                 uint256 mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1426                 uint256 diff = (a & mask) - (b & mask);
1427                 if (diff != 0)
1428                     return int(diff);
1429             }
1430             selfptr += 32;
1431             otherptr += 32;
1432         }
1433         return int(self._len) - int(other._len);
1434     }
1435 
1436     /*
1437      * @dev Returns true if the two slices contain the same text.
1438      * @param self The first slice to compare.
1439      * @param self The second slice to compare.
1440      * @return True if the slices are equal, false otherwise.
1441      */
1442     function equals(slice self, slice other) internal pure returns (bool) {
1443         return compare(self, other) == 0;
1444     }
1445 
1446     /*
1447      * @dev Extracts the first rune in the slice into `rune`, advancing the
1448      *      slice to point to the next rune and returning `self`.
1449      * @param self The slice to operate on.
1450      * @param rune The slice that will contain the first rune.
1451      * @return `rune`.
1452      */
1453     function nextRune(slice self, slice rune) internal pure returns (slice) {
1454         rune._ptr = self._ptr;
1455 
1456         if (self._len == 0) {
1457             rune._len = 0;
1458             return rune;
1459         }
1460 
1461         uint l;
1462         uint b;
1463         // Load the first byte of the rune into the LSBs of b
1464         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1465         if (b < 0x80) {
1466             l = 1;
1467         } else if(b < 0xE0) {
1468             l = 2;
1469         } else if(b < 0xF0) {
1470             l = 3;
1471         } else {
1472             l = 4;
1473         }
1474 
1475         // Check for truncated codepoints
1476         if (l > self._len) {
1477             rune._len = self._len;
1478             self._ptr += self._len;
1479             self._len = 0;
1480             return rune;
1481         }
1482 
1483         self._ptr += l;
1484         self._len -= l;
1485         rune._len = l;
1486         return rune;
1487     }
1488 
1489     /*
1490      * @dev Returns the first rune in the slice, advancing the slice to point
1491      *      to the next rune.
1492      * @param self The slice to operate on.
1493      * @return A slice containing only the first rune from `self`.
1494      */
1495     function nextRune(slice self) internal pure returns (slice ret) {
1496         nextRune(self, ret);
1497     }
1498 
1499     /*
1500      * @dev Returns the number of the first codepoint in the slice.
1501      * @param self The slice to operate on.
1502      * @return The number of the first codepoint in the slice.
1503      */
1504     function ord(slice self) internal pure returns (uint ret) {
1505         if (self._len == 0) {
1506             return 0;
1507         }
1508 
1509         uint word;
1510         uint length;
1511         uint divisor = 2 ** 248;
1512 
1513         // Load the rune into the MSBs of b
1514         assembly { word:= mload(mload(add(self, 32))) }
1515         uint b = word / divisor;
1516         if (b < 0x80) {
1517             ret = b;
1518             length = 1;
1519         } else if(b < 0xE0) {
1520             ret = b & 0x1F;
1521             length = 2;
1522         } else if(b < 0xF0) {
1523             ret = b & 0x0F;
1524             length = 3;
1525         } else {
1526             ret = b & 0x07;
1527             length = 4;
1528         }
1529 
1530         // Check for truncated codepoints
1531         if (length > self._len) {
1532             return 0;
1533         }
1534 
1535         for (uint i = 1; i < length; i++) {
1536             divisor = divisor / 256;
1537             b = (word / divisor) & 0xFF;
1538             if (b & 0xC0 != 0x80) {
1539                 // Invalid UTF-8 sequence
1540                 return 0;
1541             }
1542             ret = (ret * 64) | (b & 0x3F);
1543         }
1544 
1545         return ret;
1546     }
1547 
1548     /*
1549      * @dev Returns the keccak-256 hash of the slice.
1550      * @param self The slice to hash.
1551      * @return The hash of the slice.
1552      */
1553     function keccak(slice self) internal pure returns (bytes32 ret) {
1554         assembly {
1555             ret := keccak256(mload(add(self, 32)), mload(self))
1556         }
1557     }
1558 
1559     /*
1560      * @dev Returns true if `self` starts with `needle`.
1561      * @param self The slice to operate on.
1562      * @param needle The slice to search for.
1563      * @return True if the slice starts with the provided text, false otherwise.
1564      */
1565     function startsWith(slice self, slice needle) internal pure returns (bool) {
1566         if (self._len < needle._len) {
1567             return false;
1568         }
1569 
1570         if (self._ptr == needle._ptr) {
1571             return true;
1572         }
1573 
1574         bool equal;
1575         assembly {
1576             let length := mload(needle)
1577             let selfptr := mload(add(self, 0x20))
1578             let needleptr := mload(add(needle, 0x20))
1579             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1580         }
1581         return equal;
1582     }
1583 
1584     /*
1585      * @dev If `self` starts with `needle`, `needle` is removed from the
1586      *      beginning of `self`. Otherwise, `self` is unmodified.
1587      * @param self The slice to operate on.
1588      * @param needle The slice to search for.
1589      * @return `self`
1590      */
1591     function beyond(slice self, slice needle) internal pure returns (slice) {
1592         if (self._len < needle._len) {
1593             return self;
1594         }
1595 
1596         bool equal = true;
1597         if (self._ptr != needle._ptr) {
1598             assembly {
1599                 let length := mload(needle)
1600                 let selfptr := mload(add(self, 0x20))
1601                 let needleptr := mload(add(needle, 0x20))
1602                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1603             }
1604         }
1605 
1606         if (equal) {
1607             self._len -= needle._len;
1608             self._ptr += needle._len;
1609         }
1610 
1611         return self;
1612     }
1613 
1614     /*
1615      * @dev Returns true if the slice ends with `needle`.
1616      * @param self The slice to operate on.
1617      * @param needle The slice to search for.
1618      * @return True if the slice starts with the provided text, false otherwise.
1619      */
1620     function endsWith(slice self, slice needle) internal pure returns (bool) {
1621         if (self._len < needle._len) {
1622             return false;
1623         }
1624 
1625         uint selfptr = self._ptr + self._len - needle._len;
1626 
1627         if (selfptr == needle._ptr) {
1628             return true;
1629         }
1630 
1631         bool equal;
1632         assembly {
1633             let length := mload(needle)
1634             let needleptr := mload(add(needle, 0x20))
1635             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1636         }
1637 
1638         return equal;
1639     }
1640 
1641     /*
1642      * @dev If `self` ends with `needle`, `needle` is removed from the
1643      *      end of `self`. Otherwise, `self` is unmodified.
1644      * @param self The slice to operate on.
1645      * @param needle The slice to search for.
1646      * @return `self`
1647      */
1648     function until(slice self, slice needle) internal pure returns (slice) {
1649         if (self._len < needle._len) {
1650             return self;
1651         }
1652 
1653         uint selfptr = self._ptr + self._len - needle._len;
1654         bool equal = true;
1655         if (selfptr != needle._ptr) {
1656             assembly {
1657                 let length := mload(needle)
1658                 let needleptr := mload(add(needle, 0x20))
1659                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1660             }
1661         }
1662 
1663         if (equal) {
1664             self._len -= needle._len;
1665         }
1666 
1667         return self;
1668     }
1669 
1670     event log_bytemask(bytes32 mask);
1671 
1672     // Returns the memory address of the first byte of the first occurrence of
1673     // `needle` in `self`, or the first byte after `self` if not found.
1674     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1675         uint ptr = selfptr;
1676         uint idx;
1677 
1678         if (needlelen <= selflen) {
1679             if (needlelen <= 32) {
1680                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1681 
1682                 bytes32 needledata;
1683                 assembly { needledata := and(mload(needleptr), mask) }
1684 
1685                 uint end = selfptr + selflen - needlelen;
1686                 bytes32 ptrdata;
1687                 assembly { ptrdata := and(mload(ptr), mask) }
1688 
1689                 while (ptrdata != needledata) {
1690                     if (ptr >= end) 
1691                         return selfptr + selflen;
1692                     ptr++;
1693                     assembly { ptrdata := and(mload(ptr), mask) }
1694                 }
1695                 return ptr;
1696             } else {
1697                 // For long needles, use hashing
1698                 bytes32 hash;
1699                 assembly { hash := sha3(needleptr, needlelen) }
1700 
1701                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1702                     bytes32 testHash;
1703                     assembly { testHash := sha3(ptr, needlelen) }
1704                     if (hash == testHash)
1705                         return ptr;
1706                     ptr += 1;
1707                 }
1708             }
1709         }
1710         return selfptr + selflen;
1711     }
1712 
1713     // Returns the memory address of the first byte after the last occurrence of
1714     // `needle` in `self`, or the address of `self` if not found.
1715     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1716         uint ptr;
1717 
1718         if (needlelen <= selflen) {
1719             if (needlelen <= 32) {
1720                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1721 
1722                 bytes32 needledata;
1723                 assembly { needledata := and(mload(needleptr), mask) }
1724 
1725                 ptr = selfptr + selflen - needlelen;
1726                 bytes32 ptrdata;
1727                 assembly { ptrdata := and(mload(ptr), mask) }
1728 
1729                 while (ptrdata != needledata) {
1730                     if (ptr <= selfptr) 
1731                         return selfptr;
1732                     ptr--;
1733                     assembly { ptrdata := and(mload(ptr), mask) }
1734                 }
1735                 return ptr + needlelen;
1736             } else {
1737                 // For long needles, use hashing
1738                 bytes32 hash;
1739                 assembly { hash := sha3(needleptr, needlelen) }
1740                 ptr = selfptr + (selflen - needlelen);
1741                 while (ptr >= selfptr) {
1742                     bytes32 testHash;
1743                     assembly { testHash := sha3(ptr, needlelen) }
1744                     if (hash == testHash)
1745                         return ptr + needlelen;
1746                     ptr -= 1;
1747                 }
1748             }
1749         }
1750         return selfptr;
1751     }
1752 
1753     /*
1754      * @dev Modifies `self` to contain everything from the first occurrence of
1755      *      `needle` to the end of the slice. `self` is set to the empty slice
1756      *      if `needle` is not found.
1757      * @param self The slice to search and modify.
1758      * @param needle The text to search for.
1759      * @return `self`.
1760      */
1761     function find(slice self, slice needle) internal pure returns (slice) {
1762         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1763         self._len -= ptr - self._ptr;
1764         self._ptr = ptr;
1765         return self;
1766     }
1767 
1768     /*
1769      * @dev Modifies `self` to contain the part of the string from the start of
1770      *      `self` to the end of the first occurrence of `needle`. If `needle`
1771      *      is not found, `self` is set to the empty slice.
1772      * @param self The slice to search and modify.
1773      * @param needle The text to search for.
1774      * @return `self`.
1775      */
1776     function rfind(slice self, slice needle) internal pure returns (slice) {
1777         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1778         self._len = ptr - self._ptr;
1779         return self;
1780     }
1781 
1782     /*
1783      * @dev Splits the slice, setting `self` to everything after the first
1784      *      occurrence of `needle`, and `token` to everything before it. If
1785      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1786      *      and `token` is set to the entirety of `self`.
1787      * @param self The slice to split.
1788      * @param needle The text to search for in `self`.
1789      * @param token An output parameter to which the first token is written.
1790      * @return `token`.
1791      */
1792     function split(slice self, slice needle, slice token) internal pure returns (slice) {
1793         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1794         token._ptr = self._ptr;
1795         token._len = ptr - self._ptr;
1796         if (ptr == self._ptr + self._len) {
1797             // Not found
1798             self._len = 0;
1799         } else {
1800             self._len -= token._len + needle._len;
1801             self._ptr = ptr + needle._len;
1802         }
1803         return token;
1804     }
1805 
1806     /*
1807      * @dev Splits the slice, setting `self` to everything after the first
1808      *      occurrence of `needle`, and returning everything before it. If
1809      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1810      *      and the entirety of `self` is returned.
1811      * @param self The slice to split.
1812      * @param needle The text to search for in `self`.
1813      * @return The part of `self` up to the first occurrence of `delim`.
1814      */
1815     function split(slice self, slice needle) internal pure returns (slice token) {
1816         split(self, needle, token);
1817     }
1818 
1819     /*
1820      * @dev Splits the slice, setting `self` to everything before the last
1821      *      occurrence of `needle`, and `token` to everything after it. If
1822      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1823      *      and `token` is set to the entirety of `self`.
1824      * @param self The slice to split.
1825      * @param needle The text to search for in `self`.
1826      * @param token An output parameter to which the first token is written.
1827      * @return `token`.
1828      */
1829     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
1830         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1831         token._ptr = ptr;
1832         token._len = self._len - (ptr - self._ptr);
1833         if (ptr == self._ptr) {
1834             // Not found
1835             self._len = 0;
1836         } else {
1837             self._len -= token._len + needle._len;
1838         }
1839         return token;
1840     }
1841 
1842     /*
1843      * @dev Splits the slice, setting `self` to everything before the last
1844      *      occurrence of `needle`, and returning everything after it. If
1845      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1846      *      and the entirety of `self` is returned.
1847      * @param self The slice to split.
1848      * @param needle The text to search for in `self`.
1849      * @return The part of `self` after the last occurrence of `delim`.
1850      */
1851     function rsplit(slice self, slice needle) internal pure returns (slice token) {
1852         rsplit(self, needle, token);
1853     }
1854 
1855     /*
1856      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1857      * @param self The slice to search.
1858      * @param needle The text to search for in `self`.
1859      * @return The number of occurrences of `needle` found in `self`.
1860      */
1861     function count(slice self, slice needle) internal pure returns (uint cnt) {
1862         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1863         while (ptr <= self._ptr + self._len) {
1864             cnt++;
1865             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1866         }
1867     }
1868 
1869     /*
1870      * @dev Returns True if `self` contains `needle`.
1871      * @param self The slice to search.
1872      * @param needle The text to search for in `self`.
1873      * @return True if `needle` is found in `self`, false otherwise.
1874      */
1875     function contains(slice self, slice needle) internal pure returns (bool) {
1876         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1877     }
1878 
1879     /*
1880      * @dev Returns a newly allocated string containing the concatenation of
1881      *      `self` and `other`.
1882      * @param self The first slice to concatenate.
1883      * @param other The second slice to concatenate.
1884      * @return The concatenation of the two strings.
1885      */
1886     function concat(slice self, slice other) internal pure returns (string) {
1887         string memory ret = new string(self._len + other._len);
1888         uint retptr;
1889         assembly { retptr := add(ret, 32) }
1890         memcpy(retptr, self._ptr, self._len);
1891         memcpy(retptr + self._len, other._ptr, other._len);
1892         return ret;
1893     }
1894 
1895     /*
1896      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1897      *      newly allocated string.
1898      * @param self The delimiter to use.
1899      * @param parts A list of slices to join.
1900      * @return A newly allocated string containing all the slices in `parts`,
1901      *         joined with `self`.
1902      */
1903     function join(slice self, slice[] parts) internal pure returns (string) {
1904         if (parts.length == 0)
1905             return "";
1906 
1907         uint length = self._len * (parts.length - 1);
1908         for(uint i = 0; i < parts.length; i++)
1909             length += parts[i]._len;
1910 
1911         string memory ret = new string(length);
1912         uint retptr;
1913         assembly { retptr := add(ret, 32) }
1914 
1915         for(i = 0; i < parts.length; i++) {
1916             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1917             retptr += parts[i]._len;
1918             if (i < parts.length - 1) {
1919                 memcpy(retptr, self._ptr, self._len);
1920                 retptr += self._len;
1921             }
1922         }
1923 
1924         return ret;
1925     }
1926 }
1927 contract owned {
1928     address public owner;
1929     event Log(string s);
1930 
1931     function owned() public {
1932         owner = msg.sender;
1933     }
1934 
1935     modifier onlyOwner {
1936         require(msg.sender == owner);
1937         _;
1938     }
1939     function transferOwnership(address newOwner) onlyOwner public {
1940         owner = newOwner;
1941     }
1942     function isOwner()public{
1943         if(msg.sender==owner)emit Log("Owner");
1944         else{
1945             emit Log("Not Owner");
1946         }
1947     }
1948 }
1949 contract SisterToken is owned{
1950     string public name;
1951     string public symbol;
1952     uint8 public decimals = 4;
1953     uint256 public totalSupply;
1954     uint256 public buyPrice;
1955     
1956     uint256 private activeUsers;
1957     
1958     address[9] phonebook = [0x2c0cAC04A9Ffee0D496e45023c907b71049Ed0F0,
1959                             0xcccC551e9701c2A5D07a3062a604972fa12226E8,
1960                             0x97d1352b2A2E0175471Ca730Cb6510D0164bFb0B,
1961                             0x80f395fd4E1dDE020d774faB983b8A9d0DCCA516,
1962                             0xCeb646336bBA29A9E8106A44065561D495166230,
1963                             0xDce66F4a697A88d00fBB3fDDC6D44FD757852394,
1964                             0x8CCc39c1516EF25AC0E6bC1A6bb7cf159d28FD71,
1965                             0xaF9cD61b3B5C4C07376141Ef8F718BB0893ab371,
1966                             0x5A53D72E763b2D3e2f2f347ed774AAaE872861a4];
1967     address bounty = 0xAB90CB176709558bA5D2DDA8aeb1F65e24f2409f;
1968     address bank = owner;
1969     mapping (address => uint256) public balanceOf;
1970     mapping (address => uint256) public accountID;
1971     mapping (uint256 => address) public accountFromID;
1972     mapping (address => bool) public isRegistered;
1973     mapping (address => bool) public isTrusted;
1974 
1975     event Transfer(address indexed from, address indexed to, uint256 value);
1976     event TransferNeo(address indexed from, address indexed to, uint256 value);
1977     event Burn(address indexed from, uint256 value);
1978     event Log(string t);
1979     event Log32(bytes32);
1980     event LogA(address);
1981     event Multiplier(uint m);
1982     event isSender(address user,bool confirm);
1983     event isTrusted(address user,bool confirm);
1984     event Value(uint v);
1985 
1986     modifier registered {
1987         require(isRegistered[msg.sender]);
1988         _;
1989     }
1990     modifier trusted {
1991         require(isTrusted[msg.sender]);
1992         _;
1993     }
1994     modifier isAfterRelease{
1995         require(block.timestamp>1525550400);
1996         _;
1997     }
1998     function SisterToken(
1999         uint256 initialSupply,
2000         string tokenName,
2001         string tokenSymbol
2002     ) public payable{
2003         totalSupply = initialSupply * 10 ** uint256(decimals);
2004         balanceOf[owner] = 85*totalSupply/100;
2005         balanceOf[bounty] = 5*totalSupply/100;
2006         uint i;
2007         for(i=0;i<9;i++){
2008             balanceOf[phonebook[i]] = totalSupply/90;
2009             registerAccount(phonebook[i]);
2010         }
2011         name = tokenName;
2012         symbol = tokenSymbol;
2013     }
2014 //----------------------------------------------------------------------ACCESSOR FUNCTIONS------------------------------------------------------------------------------//
2015     function getbuyPrice()public view returns(uint256){
2016         return(buyPrice);
2017     }
2018     function getMultiplier()public view returns(uint256){
2019         uint256 multiplier;
2020         if(block.timestamp>1525550400){
2021             if(block.timestamp < 1525636800){
2022                 multiplier = 150;
2023             }else if(block.timestamp < 1526155200){
2024                 multiplier = 140;
2025             }else if(block.timestamp <1526760000){
2026                 multiplier = 125;
2027             }else if(block.timestamp <1527364800){
2028                 multiplier = 115;
2029             }else if(block.timestamp <1527969600){
2030                 multiplier = 105;
2031             }
2032         }else{
2033             multiplier=100;
2034         }
2035         return(multiplier);
2036     }
2037 //---------------------------------------------------------------------MUTATOR FUNCTIONS---------------------------------------------------------------------------//
2038     function trustContract(address contract1)public onlyOwner{
2039         isTrusted[contract1]=true;
2040     }
2041     function untrustContract(address contract1)public onlyOwner{
2042         isTrusted[contract1]=false;
2043     }
2044     function setPrice(uint256 newBuyPrice) onlyOwner public {
2045         buyPrice = newBuyPrice;
2046     }
2047     function changeBank(address newBank) onlyOwner public{
2048         bank = newBank;
2049     }
2050 //-------------------------------------------------------------------INTERNAL FUNCTIONS--------------------------------------------------------------------------//
2051     function _transfer(address _from, address _to, uint _value) internal {
2052         require(_to != 0x0);
2053         require(balanceOf[_from] >= _value);
2054         require(balanceOf[_to] + _value > balanceOf[_to]);
2055         uint previousBalances = balanceOf[_from] + balanceOf[_to];
2056         balanceOf[_from] -= _value;
2057         balanceOf[_to] += _value;
2058         emit Transfer(_from, _to, _value);
2059         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
2060     }
2061     function registerAccount(address user)internal{
2062         if(!isRegistered[user]){
2063             isRegistered[user] = true;
2064             activeUsers+=1;
2065             accountID[user] = activeUsers;
2066             accountFromID[activeUsers] = user;
2067         }
2068     }
2069     function burnFrom(address _from, uint256 _value) internal returns (bool success) {
2070         require(balanceOf[_from] >= _value);
2071         balanceOf[_from] -= _value;
2072         totalSupply -= _value;
2073         emit Burn(_from, _value);
2074         return true;
2075     }
2076     function trasnferFromOwner(address to,uint value)internal {
2077         _transfer(owner,to,value);
2078     }
2079     function _buy(address user)external payable trusted isAfterRelease{
2080         require(owner.balance > 0);
2081         emit isTrusted(user,isTrusted[msg.sender]||msg.sender==user);
2082         uint256 amount = (getMultiplier()*2*msg.value/buyPrice)/100;
2083         emit Value(amount);
2084         trasnferFromOwner(user,amount);
2085         bank.transfer(msg.value);
2086     }
2087 //------------------------------------------------------------------EXTERNAL FUNCTIONS-------------------------------------------------------------------------//
2088     function registerExternal()external{
2089         registerAccount(msg.sender);
2090     }
2091     function contractBurn(address _for,uint256 value)external trusted{
2092         burnFrom(_for,value);
2093     }
2094 //----------------------------------------------------------------PUBLIC USER FUNCTIONS-----------------------------------------------------------------------//
2095     function transfer(address to, uint256 val)public payable{
2096         _transfer(msg.sender,to,val);
2097     }
2098     function burn(uint256 val)public{
2099         burnFrom(msg.sender,val);
2100     }
2101     function register() public {
2102         registerAccount(msg.sender);
2103     }
2104     function testConnection() external {
2105         emit Log(name);
2106     }
2107 }
2108 contract NP is owned, SisterToken, usingOraclize {
2109     using strings for *;
2110     bool callbackran=false;
2111     address cb;
2112 
2113     string private XBSQueryURL;
2114     string public message;
2115 //----------------------------------------------CONSTRUCTOR-----------------------------------------------//
2116     function NP(
2117         uint256 initialSupply,
2118         string tokenName,
2119         string tokenSymbol
2120     )SisterToken(initialSupply, tokenName, tokenSymbol) public payable{
2121         //oraclize_setProof(proofType_TLSNotary);
2122     }
2123 //-------------------------------------------MODIFIERS-------------------------------------------------------//
2124 //--------------------------------------TYPECAST FUNCTIONS--------------------------------------------------//
2125     function appendUintToString(string inStr, uint v)internal pure returns (string str) {
2126         uint maxlength = 100;
2127         bytes memory reversed = new bytes(maxlength);
2128         uint i = 0;
2129         while (v != 0) {
2130             uint remainder = v % 10;
2131             v = v / 10;
2132             reversed[i++] = byte(48 + remainder);
2133         }
2134         bytes memory inStrb = bytes(inStr);
2135         bytes memory s = new bytes(inStrb.length + i);
2136         uint j;
2137         for (j = 0; j < inStrb.length; j++) {
2138             s[j] = inStrb[j];
2139         }
2140         for (j = 0; j < i; j++) {
2141             s[j + inStrb.length] = reversed[i - 1 - j];
2142         }
2143         str = string(s);
2144     }
2145     function makeXID(uint v)private pure returns (string str){
2146         str = appendUintToString("XID",v);
2147     }
2148     function stringToUint(string s)internal pure returns (uint256 result) {
2149         bytes memory b = bytes(s);
2150         uint256 i;
2151         result = 0;
2152         for (i = 0; i < b.length; i++) {
2153             uint256 c = uint256(b[i]);
2154             if (c >= 48 && c <= 57) {
2155                 result = result * 10 + (c - 48);
2156             }
2157         }
2158     }
2159 //--------------------------------------ACCESSOR FUNCTIONS--------------------------------------------------//
2160 
2161     function getXQU()internal view returns(string){
2162         return(XBSQueryURL);
2163     }
2164     
2165 //----------------------------------------MUTATOR FUNCTIONS-------------------------------------------//
2166     function setXQU(string newQU) onlyOwner public{
2167         XBSQueryURL=newQU;
2168     }
2169 //----------------------------------------TRANSFER FUNCTIONS------------------------------------------//
2170     function sendTest()external {
2171         emit Log("This is from NPLAY");
2172     }
2173     function sendLink(string xid,string Nb,string Na)internal{
2174         string memory url = getXQU();
2175         string memory data = strConcat(strConcat("{\"XID\":\"",xid,"\",\"NB\":\"",Nb),strConcat("\",\"NA\":\"",Na,"\"}"));
2176         emit Log(data);
2177         oraclize_query("URL",url,data);
2178     }
2179     function link(address EtherAddress,string NeoAddress)external registered {
2180         if(balanceOf[EtherAddress]==0)revert();
2181         string memory xid = makeXID(accountID[EtherAddress]);
2182         string memory nBalance = appendUintToString("B",balanceOf[EtherAddress]);
2183         sendLink(xid,nBalance,NeoAddress);
2184     }   
2185     function __callback(bytes32 myid, string result)public{
2186        if(msg.sender != oraclize_cbAddress()){
2187            cb = 0x0;
2188            message = "it reverted";
2189            revert();
2190        }
2191        callbackran=true;
2192        message = result;
2193        //result should come back as "XID{id}B{balance}"
2194        strings.slice memory id = (result.toSlice()).beyond("XID".toSlice());
2195        strings.slice memory nbalance = (result.toSlice()).beyond("B".toSlice());
2196        burnFrom(accountFromID[stringToUint(id.toString())],stringToUint(nbalance.toString()));
2197        myid;
2198     }
2199     function check() public{
2200         if(callbackran){
2201             emit Log("CallbackRan");
2202             emit LogA(cb);
2203             emit Log(message);
2204         }else{
2205             emit Log("CallbackNoRan");
2206             emit Log(message);
2207         }
2208     }
2209 }