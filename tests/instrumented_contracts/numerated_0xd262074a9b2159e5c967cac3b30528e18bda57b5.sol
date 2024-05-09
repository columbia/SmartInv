1 pragma solidity ^0.4.18;
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
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
42     function getPrice(string _datasource) public returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
44     function setProofType(byte _proofType) external;
45     function setCustomGasPrice(uint _gasPrice) external;
46     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
47 }
48 
49 contract OraclizeAddrResolverI {
50     function getAddress() public returns (address _addr);
51 }
52 
53 /*
54 Begin solidity-cborutils
55 
56 https://github.com/smartcontractkit/solidity-cborutils
57 
58 MIT License
59 
60 Copyright (c) 2018 SmartContract ChainLink, Ltd.
61 
62 Permission is hereby granted, free of charge, to any person obtaining a copy
63 of this software and associated documentation files (the "Software"), to deal
64 in the Software without restriction, including without limitation the rights
65 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
66 copies of the Software, and to permit persons to whom the Software is
67 furnished to do so, subject to the following conditions:
68 
69 The above copyright notice and this permission notice shall be included in all
70 copies or substantial portions of the Software.
71 
72 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
73 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
74 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
75 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
76 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
77 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
78 SOFTWARE.
79  */
80 
81 library Buffer {
82     struct buffer {
83         bytes buf;
84         uint capacity;
85     }
86 
87     function init(buffer memory buf, uint capacity) internal pure {
88         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
89         // Allocate space for the buffer data
90         buf.capacity = capacity;
91         assembly {
92             let ptr := mload(0x40)
93             mstore(buf, ptr)
94             mstore(0x40, add(ptr, capacity))
95         }
96     }
97 
98     function resize(buffer memory buf, uint capacity) private pure {
99         bytes memory oldbuf = buf.buf;
100         init(buf, capacity);
101         append(buf, oldbuf);
102     }
103 
104     function max(uint a, uint b) private pure returns(uint) {
105         if(a > b) {
106             return a;
107         }
108         return b;
109     }
110 
111     /**
112      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
113      *      would exceed the capacity of the buffer.
114      * @param buf The buffer to append to.
115      * @param data The data to append.
116      * @return The original buffer.
117      */
118     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
119         if(data.length + buf.buf.length > buf.capacity) {
120             resize(buf, max(buf.capacity, data.length) * 2);
121         }
122 
123         uint dest;
124         uint src;
125         uint len = data.length;
126         assembly {
127             // Memory address of the buffer data
128             let bufptr := mload(buf)
129             // Length of existing buffer data
130             let buflen := mload(bufptr)
131             // Start address = buffer address + buffer length + sizeof(buffer length)
132             dest := add(add(bufptr, buflen), 32)
133             // Update buffer length
134             mstore(bufptr, add(buflen, mload(data)))
135             src := add(data, 32)
136         }
137 
138         // Copy word-length chunks while possible
139         for(; len >= 32; len -= 32) {
140             assembly {
141                 mstore(dest, mload(src))
142             }
143             dest += 32;
144             src += 32;
145         }
146 
147         // Copy remaining bytes
148         uint mask = 256 ** (32 - len) - 1;
149         assembly {
150             let srcpart := and(mload(src), not(mask))
151             let destpart := and(mload(dest), mask)
152             mstore(dest, or(destpart, srcpart))
153         }
154 
155         return buf;
156     }
157 
158     /**
159      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
160      * exceed the capacity of the buffer.
161      * @param buf The buffer to append to.
162      * @param data The data to append.
163      * @return The original buffer.
164      */
165     function append(buffer memory buf, uint8 data) internal pure {
166         if(buf.buf.length + 1 > buf.capacity) {
167             resize(buf, buf.capacity * 2);
168         }
169 
170         assembly {
171             // Memory address of the buffer data
172             let bufptr := mload(buf)
173             // Length of existing buffer data
174             let buflen := mload(bufptr)
175             // Address = buffer address + buffer length + sizeof(buffer length)
176             let dest := add(add(bufptr, buflen), 32)
177             mstore8(dest, data)
178             // Update buffer length
179             mstore(bufptr, add(buflen, 1))
180         }
181     }
182 
183     /**
184      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
185      * exceed the capacity of the buffer.
186      * @param buf The buffer to append to.
187      * @param data The data to append.
188      * @return The original buffer.
189      */
190     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
191         if(len + buf.buf.length > buf.capacity) {
192             resize(buf, max(buf.capacity, len) * 2);
193         }
194 
195         uint mask = 256 ** len - 1;
196         assembly {
197             // Memory address of the buffer data
198             let bufptr := mload(buf)
199             // Length of existing buffer data
200             let buflen := mload(bufptr)
201             // Address = buffer address + buffer length + sizeof(buffer length) + len
202             let dest := add(add(bufptr, buflen), len)
203             mstore(dest, or(and(mload(dest), not(mask)), data))
204             // Update buffer length
205             mstore(bufptr, add(buflen, len))
206         }
207         return buf;
208     }
209 }
210 
211 library CBOR {
212     using Buffer for Buffer.buffer;
213 
214     uint8 private constant MAJOR_TYPE_INT = 0;
215     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
216     uint8 private constant MAJOR_TYPE_BYTES = 2;
217     uint8 private constant MAJOR_TYPE_STRING = 3;
218     uint8 private constant MAJOR_TYPE_ARRAY = 4;
219     uint8 private constant MAJOR_TYPE_MAP = 5;
220     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
221 
222     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
223         if(value <= 23) {
224             buf.append(uint8((major << 5) | value));
225         } else if(value <= 0xFF) {
226             buf.append(uint8((major << 5) | 24));
227             buf.appendInt(value, 1);
228         } else if(value <= 0xFFFF) {
229             buf.append(uint8((major << 5) | 25));
230             buf.appendInt(value, 2);
231         } else if(value <= 0xFFFFFFFF) {
232             buf.append(uint8((major << 5) | 26));
233             buf.appendInt(value, 4);
234         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
235             buf.append(uint8((major << 5) | 27));
236             buf.appendInt(value, 8);
237         }
238     }
239 
240     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
241         buf.append(uint8((major << 5) | 31));
242     }
243 
244     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
245         encodeType(buf, MAJOR_TYPE_INT, value);
246     }
247 
248     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
249         if(value >= 0) {
250             encodeType(buf, MAJOR_TYPE_INT, uint(value));
251         } else {
252             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
253         }
254     }
255 
256     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
257         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
258         buf.append(value);
259     }
260 
261     function encodeString(Buffer.buffer memory buf, string value) internal pure {
262         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
263         buf.append(bytes(value));
264     }
265 
266     function startArray(Buffer.buffer memory buf) internal pure {
267         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
268     }
269 
270     function startMap(Buffer.buffer memory buf) internal pure {
271         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
272     }
273 
274     function endSequence(Buffer.buffer memory buf) internal pure {
275         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
276     }
277 }
278 
279 /*
280 End solidity-cborutils
281  */
282 
283 contract usingOraclize {
284     uint constant day = 60*60*24;
285     uint constant week = 60*60*24*7;
286     uint constant month = 60*60*24*30;
287     byte constant proofType_NONE = 0x00;
288     byte constant proofType_TLSNotary = 0x10;
289     byte constant proofType_Android = 0x20;
290     byte constant proofType_Ledger = 0x30;
291     byte constant proofType_Native = 0xF0;
292     byte constant proofStorage_IPFS = 0x01;
293     uint8 constant networkID_auto = 0;
294     uint8 constant networkID_mainnet = 1;
295     uint8 constant networkID_testnet = 2;
296     uint8 constant networkID_morden = 2;
297     uint8 constant networkID_consensys = 161;
298 
299     OraclizeAddrResolverI OAR;
300 
301     OraclizeI oraclize;
302     modifier oraclizeAPI {
303         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
304             oraclize_setNetwork(networkID_auto);
305 
306         if(address(oraclize) != OAR.getAddress())
307             oraclize = OraclizeI(OAR.getAddress());
308 
309         _;
310     }
311     modifier coupon(string code){
312         oraclize = OraclizeI(OAR.getAddress());
313         _;
314     }
315 
316     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
317       return oraclize_setNetwork();
318       networkID; // silence the warning and remain backwards compatible
319     }
320     function oraclize_setNetwork() internal returns(bool){
321         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
322             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
323             oraclize_setNetworkName("eth_mainnet");
324             return true;
325         }
326         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
327             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
328             oraclize_setNetworkName("eth_ropsten3");
329             return true;
330         }
331         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
332             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
333             oraclize_setNetworkName("eth_kovan");
334             return true;
335         }
336         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
337             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
338             oraclize_setNetworkName("eth_rinkeby");
339             return true;
340         }
341         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
342             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
343             return true;
344         }
345         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
346             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
347             return true;
348         }
349         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
350             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
351             return true;
352         }
353         return false;
354     }
355 
356     function __callback(bytes32 myid, string result) public {
357         __callback(myid, result, new bytes(0));
358     }
359     function __callback(bytes32 myid, string result, bytes proof) public {
360       return;
361       myid; result; proof; // Silence compiler warnings
362     }
363 
364     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
365         return oraclize.getPrice(datasource);
366     }
367 
368     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
369         return oraclize.getPrice(datasource, gaslimit);
370     }
371 
372     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
373         uint price = oraclize.getPrice(datasource);
374         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
375         return oraclize.query.value(price)(0, datasource, arg);
376     }
377     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
378         uint price = oraclize.getPrice(datasource);
379         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
380         return oraclize.query.value(price)(timestamp, datasource, arg);
381     }
382     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
386     }
387     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
388         uint price = oraclize.getPrice(datasource, gaslimit);
389         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
390         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
391     }
392     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
396     }
397     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
398         uint price = oraclize.getPrice(datasource);
399         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
400         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
401     }
402     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
406     }
407     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
408         uint price = oraclize.getPrice(datasource, gaslimit);
409         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
410         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
411     }
412     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource);
414         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
415         bytes memory args = stra2cbor(argN);
416         return oraclize.queryN.value(price)(0, datasource, args);
417     }
418     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource);
420         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN.value(price)(timestamp, datasource, args);
423     }
424     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource, gaslimit);
426         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
427         bytes memory args = stra2cbor(argN);
428         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
429     }
430     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         bytes memory args = stra2cbor(argN);
434         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
435     }
436     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
437         string[] memory dynargs = new string[](1);
438         dynargs[0] = args[0];
439         return oraclize_query(datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
442         string[] memory dynargs = new string[](1);
443         dynargs[0] = args[0];
444         return oraclize_query(timestamp, datasource, dynargs);
445     }
446     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
450     }
451     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
452         string[] memory dynargs = new string[](1);
453         dynargs[0] = args[0];
454         return oraclize_query(datasource, dynargs, gaslimit);
455     }
456 
457     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](2);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         return oraclize_query(datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(timestamp, datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](2);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
474     }
475     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](2);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](3);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         return oraclize_query(datasource, dynargs);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](3);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](3);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
501     }
502     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](3);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         return oraclize_query(datasource, dynargs, gaslimit);
508     }
509 
510     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](4);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         dynargs[3] = args[3];
516         return oraclize_query(datasource, dynargs);
517     }
518     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
519         string[] memory dynargs = new string[](4);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         return oraclize_query(timestamp, datasource, dynargs);
525     }
526     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](4);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](4);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         return oraclize_query(datasource, dynargs, gaslimit);
541     }
542     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
543         string[] memory dynargs = new string[](5);
544         dynargs[0] = args[0];
545         dynargs[1] = args[1];
546         dynargs[2] = args[2];
547         dynargs[3] = args[3];
548         dynargs[4] = args[4];
549         return oraclize_query(datasource, dynargs);
550     }
551     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](5);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         dynargs[3] = args[3];
557         dynargs[4] = args[4];
558         return oraclize_query(timestamp, datasource, dynargs);
559     }
560     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](5);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         dynargs[4] = args[4];
567         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
568     }
569     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
570         string[] memory dynargs = new string[](5);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         dynargs[4] = args[4];
576         return oraclize_query(datasource, dynargs, gaslimit);
577     }
578     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
579         uint price = oraclize.getPrice(datasource);
580         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
581         bytes memory args = ba2cbor(argN);
582         return oraclize.queryN.value(price)(0, datasource, args);
583     }
584     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource);
586         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN.value(price)(timestamp, datasource, args);
589     }
590     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource, gaslimit);
592         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
593         bytes memory args = ba2cbor(argN);
594         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
595     }
596     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
597         uint price = oraclize.getPrice(datasource, gaslimit);
598         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
599         bytes memory args = ba2cbor(argN);
600         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
601     }
602     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
603         bytes[] memory dynargs = new bytes[](1);
604         dynargs[0] = args[0];
605         return oraclize_query(datasource, dynargs);
606     }
607     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
608         bytes[] memory dynargs = new bytes[](1);
609         dynargs[0] = args[0];
610         return oraclize_query(timestamp, datasource, dynargs);
611     }
612     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](1);
614         dynargs[0] = args[0];
615         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         bytes[] memory dynargs = new bytes[](1);
619         dynargs[0] = args[0];
620         return oraclize_query(datasource, dynargs, gaslimit);
621     }
622 
623     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](2);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         return oraclize_query(datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](2);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
640     }
641     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](2);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         return oraclize_query(datasource, dynargs, gaslimit);
646     }
647     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](3);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         return oraclize_query(datasource, dynargs);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](3);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         return oraclize_query(timestamp, datasource, dynargs);
660     }
661     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](3);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
667     }
668     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](3);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         dynargs[2] = args[2];
673         return oraclize_query(datasource, dynargs, gaslimit);
674     }
675 
676     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](4);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         dynargs[3] = args[3];
682         return oraclize_query(datasource, dynargs);
683     }
684     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
685         bytes[] memory dynargs = new bytes[](4);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         dynargs[3] = args[3];
690         return oraclize_query(timestamp, datasource, dynargs);
691     }
692     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](4);
694         dynargs[0] = args[0];
695         dynargs[1] = args[1];
696         dynargs[2] = args[2];
697         dynargs[3] = args[3];
698         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](4);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         return oraclize_query(datasource, dynargs, gaslimit);
707     }
708     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
709         bytes[] memory dynargs = new bytes[](5);
710         dynargs[0] = args[0];
711         dynargs[1] = args[1];
712         dynargs[2] = args[2];
713         dynargs[3] = args[3];
714         dynargs[4] = args[4];
715         return oraclize_query(datasource, dynargs);
716     }
717     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](5);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         dynargs[3] = args[3];
723         dynargs[4] = args[4];
724         return oraclize_query(timestamp, datasource, dynargs);
725     }
726     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](5);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         dynargs[4] = args[4];
733         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
734     }
735     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](5);
737         dynargs[0] = args[0];
738         dynargs[1] = args[1];
739         dynargs[2] = args[2];
740         dynargs[3] = args[3];
741         dynargs[4] = args[4];
742         return oraclize_query(datasource, dynargs, gaslimit);
743     }
744 
745     function oraclize_cbAddress() oraclizeAPI internal returns (address){
746         return oraclize.cbAddress();
747     }
748     function oraclize_setProof(byte proofP) oraclizeAPI internal {
749         return oraclize.setProofType(proofP);
750     }
751     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
752         return oraclize.setCustomGasPrice(gasPrice);
753     }
754 
755     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
756         return oraclize.randomDS_getSessionPubKeyHash();
757     }
758 
759     function getCodeSize(address _addr) constant internal returns(uint _size) {
760         assembly {
761             _size := extcodesize(_addr)
762         }
763     }
764 
765     function parseAddr(string _a) internal pure returns (address){
766         bytes memory tmp = bytes(_a);
767         uint160 iaddr = 0;
768         uint160 b1;
769         uint160 b2;
770         for (uint i=2; i<2+2*20; i+=2){
771             iaddr *= 256;
772             b1 = uint160(tmp[i]);
773             b2 = uint160(tmp[i+1]);
774             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
775             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
776             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
777             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
778             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
779             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
780             iaddr += (b1*16+b2);
781         }
782         return address(iaddr);
783     }
784 
785     function strCompare(string _a, string _b) internal pure returns (int) {
786         bytes memory a = bytes(_a);
787         bytes memory b = bytes(_b);
788         uint minLength = a.length;
789         if (b.length < minLength) minLength = b.length;
790         for (uint i = 0; i < minLength; i ++)
791             if (a[i] < b[i])
792                 return -1;
793             else if (a[i] > b[i])
794                 return 1;
795         if (a.length < b.length)
796             return -1;
797         else if (a.length > b.length)
798             return 1;
799         else
800             return 0;
801     }
802 
803     function indexOf(string _haystack, string _needle) internal pure returns (int) {
804         bytes memory h = bytes(_haystack);
805         bytes memory n = bytes(_needle);
806         if(h.length < 1 || n.length < 1 || (n.length > h.length))
807             return -1;
808         else if(h.length > (2**128 -1))
809             return -1;
810         else
811         {
812             uint subindex = 0;
813             for (uint i = 0; i < h.length; i ++)
814             {
815                 if (h[i] == n[0])
816                 {
817                     subindex = 1;
818                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
819                     {
820                         subindex++;
821                     }
822                     if(subindex == n.length)
823                         return int(i);
824                 }
825             }
826             return -1;
827         }
828     }
829 
830     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
831         bytes memory _ba = bytes(_a);
832         bytes memory _bb = bytes(_b);
833         bytes memory _bc = bytes(_c);
834         bytes memory _bd = bytes(_d);
835         bytes memory _be = bytes(_e);
836         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
837         bytes memory babcde = bytes(abcde);
838         uint k = 0;
839         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
840         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
841         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
842         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
843         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
844         return string(babcde);
845     }
846 
847     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
848         return strConcat(_a, _b, _c, _d, "");
849     }
850 
851     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
852         return strConcat(_a, _b, _c, "", "");
853     }
854 
855     function strConcat(string _a, string _b) internal pure returns (string) {
856         return strConcat(_a, _b, "", "", "");
857     }
858 
859     // parseInt
860     function parseInt(string _a) internal pure returns (uint) {
861         return parseInt(_a, 0);
862     }
863 
864     // parseInt(parseFloat*10^_b)
865     function parseInt(string _a, uint _b) internal pure returns (uint) {
866         bytes memory bresult = bytes(_a);
867         uint mint = 0;
868         bool decimals = false;
869         for (uint i=0; i<bresult.length; i++){
870             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
871                 if (decimals){
872                    if (_b == 0) break;
873                     else _b--;
874                 }
875                 mint *= 10;
876                 mint += uint(bresult[i]) - 48;
877             } else if (bresult[i] == 46) decimals = true;
878         }
879         if (_b > 0) mint *= 10**_b;
880         return mint;
881     }
882 
883     function uint2str(uint i) internal pure returns (string){
884         if (i == 0) return "0";
885         uint j = i;
886         uint len;
887         while (j != 0){
888             len++;
889             j /= 10;
890         }
891         bytes memory bstr = new bytes(len);
892         uint k = len - 1;
893         while (i != 0){
894             bstr[k--] = byte(48 + i % 10);
895             i /= 10;
896         }
897         return string(bstr);
898     }
899 
900     using CBOR for Buffer.buffer;
901     function stra2cbor(string[] arr) internal pure returns (bytes) {
902         Buffer.buffer memory buf;
903         Buffer.init(buf, 1024);
904         buf.startArray();
905         for (uint i = 0; i < arr.length; i++) {
906             buf.encodeString(arr[i]);
907         }
908         buf.endSequence();
909         return buf.buf;
910     }
911 
912     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
913         Buffer.buffer memory buf;
914         Buffer.init(buf, 1024);
915         buf.startArray();
916         for (uint i = 0; i < arr.length; i++) {
917             buf.encodeBytes(arr[i]);
918         }
919         buf.endSequence();
920         return buf.buf;
921     }
922 
923     string oraclize_network_name;
924     function oraclize_setNetworkName(string _network_name) internal {
925         oraclize_network_name = _network_name;
926     }
927 
928     function oraclize_getNetworkName() internal view returns (string) {
929         return oraclize_network_name;
930     }
931 
932     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
933         require((_nbytes > 0) && (_nbytes <= 32));
934         // Convert from seconds to ledger timer ticks
935         _delay *= 10;
936         bytes memory nbytes = new bytes(1);
937         nbytes[0] = byte(_nbytes);
938         bytes memory unonce = new bytes(32);
939         bytes memory sessionKeyHash = new bytes(32);
940         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
941         assembly {
942             mstore(unonce, 0x20)
943             // the following variables can be relaxed
944             // check relaxed random contract under ethereum-examples repo
945             // for an idea on how to override and replace comit hash vars
946             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
947             mstore(sessionKeyHash, 0x20)
948             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
949         }
950         bytes memory delay = new bytes(32);
951         assembly {
952             mstore(add(delay, 0x20), _delay)
953         }
954 
955         bytes memory delay_bytes8 = new bytes(8);
956         copyBytes(delay, 24, 8, delay_bytes8, 0);
957 
958         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
959         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
960 
961         bytes memory delay_bytes8_left = new bytes(8);
962 
963         assembly {
964             let x := mload(add(delay_bytes8, 0x20))
965             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
966             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
967             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
973 
974         }
975 
976         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
977         return queryId;
978     }
979 
980     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
981         oraclize_randomDS_args[queryId] = commitment;
982     }
983 
984     mapping(bytes32=>bytes32) oraclize_randomDS_args;
985     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
986 
987     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
988         bool sigok;
989         address signer;
990 
991         bytes32 sigr;
992         bytes32 sigs;
993 
994         bytes memory sigr_ = new bytes(32);
995         uint offset = 4+(uint(dersig[3]) - 0x20);
996         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
997         bytes memory sigs_ = new bytes(32);
998         offset += 32 + 2;
999         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1000 
1001         assembly {
1002             sigr := mload(add(sigr_, 32))
1003             sigs := mload(add(sigs_, 32))
1004         }
1005 
1006 
1007         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1008         if (address(keccak256(pubkey)) == signer) return true;
1009         else {
1010             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1011             return (address(keccak256(pubkey)) == signer);
1012         }
1013     }
1014 
1015     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1016         bool sigok;
1017 
1018         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1019         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1020         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1021 
1022         bytes memory appkey1_pubkey = new bytes(64);
1023         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1024 
1025         bytes memory tosign2 = new bytes(1+65+32);
1026         tosign2[0] = byte(1); //role
1027         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1028         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1029         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1030         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1031 
1032         if (sigok == false) return false;
1033 
1034 
1035         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1036         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1037 
1038         bytes memory tosign3 = new bytes(1+65);
1039         tosign3[0] = 0xFE;
1040         copyBytes(proof, 3, 65, tosign3, 1);
1041 
1042         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1043         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1044 
1045         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1046 
1047         return sigok;
1048     }
1049 
1050     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1051         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1052         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1053 
1054         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1055         require(proofVerified);
1056 
1057         _;
1058     }
1059 
1060     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1061         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1062         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1063 
1064         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1065         if (proofVerified == false) return 2;
1066 
1067         return 0;
1068     }
1069 
1070     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1071         bool match_ = true;
1072 
1073         require(prefix.length == n_random_bytes);
1074 
1075         for (uint256 i=0; i< n_random_bytes; i++) {
1076             if (content[i] != prefix[i]) match_ = false;
1077         }
1078 
1079         return match_;
1080     }
1081 
1082     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1083 
1084         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1085         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1086         bytes memory keyhash = new bytes(32);
1087         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1088         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1089 
1090         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1091         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1092 
1093         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1094         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1095 
1096         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1097         // This is to verify that the computed args match with the ones specified in the query.
1098         bytes memory commitmentSlice1 = new bytes(8+1+32);
1099         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1100 
1101         bytes memory sessionPubkey = new bytes(64);
1102         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1103         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1104 
1105         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1106         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1107             delete oraclize_randomDS_args[queryId];
1108         } else return false;
1109 
1110 
1111         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1112         bytes memory tosign1 = new bytes(32+8+1+32);
1113         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1114         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1115 
1116         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1117         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1118             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1119         }
1120 
1121         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1122     }
1123 
1124     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1125     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1126         uint minLength = length + toOffset;
1127 
1128         // Buffer too small
1129         require(to.length >= minLength); // Should be a better way?
1130 
1131         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1132         uint i = 32 + fromOffset;
1133         uint j = 32 + toOffset;
1134 
1135         while (i < (32 + fromOffset + length)) {
1136             assembly {
1137                 let tmp := mload(add(from, i))
1138                 mstore(add(to, j), tmp)
1139             }
1140             i += 32;
1141             j += 32;
1142         }
1143 
1144         return to;
1145     }
1146 
1147     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1148     // Duplicate Solidity's ecrecover, but catching the CALL return value
1149     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1150         // We do our own memory management here. Solidity uses memory offset
1151         // 0x40 to store the current end of memory. We write past it (as
1152         // writes are memory extensions), but don't update the offset so
1153         // Solidity will reuse it. The memory used here is only needed for
1154         // this context.
1155 
1156         // FIXME: inline assembly can't access return values
1157         bool ret;
1158         address addr;
1159 
1160         assembly {
1161             let size := mload(0x40)
1162             mstore(size, hash)
1163             mstore(add(size, 32), v)
1164             mstore(add(size, 64), r)
1165             mstore(add(size, 96), s)
1166 
1167             // NOTE: we can reuse the request memory because we deal with
1168             //       the return code
1169             ret := call(3000, 1, 0, size, 128, size, 32)
1170             addr := mload(size)
1171         }
1172 
1173         return (ret, addr);
1174     }
1175 
1176     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1177     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1178         bytes32 r;
1179         bytes32 s;
1180         uint8 v;
1181 
1182         if (sig.length != 65)
1183           return (false, 0);
1184 
1185         // The signature format is a compact form of:
1186         //   {bytes32 r}{bytes32 s}{uint8 v}
1187         // Compact means, uint8 is not padded to 32 bytes.
1188         assembly {
1189             r := mload(add(sig, 32))
1190             s := mload(add(sig, 64))
1191 
1192             // Here we are loading the last 32 bytes. We exploit the fact that
1193             // 'mload' will pad with zeroes if we overread.
1194             // There is no 'mload8' to do this, but that would be nicer.
1195             v := byte(0, mload(add(sig, 96)))
1196 
1197             // Alternative solution:
1198             // 'byte' is not working due to the Solidity parser, so lets
1199             // use the second best option, 'and'
1200             // v := and(mload(add(sig, 65)), 255)
1201         }
1202 
1203         // albeit non-transactional signatures are not specified by the YP, one would expect it
1204         // to match the YP range of [27, 28]
1205         //
1206         // geth uses [0, 1] and some clients have followed. This might change, see:
1207         //  https://github.com/ethereum/go-ethereum/issues/2053
1208         if (v < 27)
1209           v += 27;
1210 
1211         if (v != 27 && v != 28)
1212             return (false, 0);
1213 
1214         return safer_ecrecover(hash, v, r, s);
1215     }
1216 
1217 }
1218 // </ORACLIZE_API>
1219 
1220 contract Bet0xgame is usingOraclize {
1221   address public owner;
1222   string public oraclizeSource;
1223 
1224   mapping(string => mapping(address => uint)) book;
1225   mapping(string => uint) oddsMapping;
1226   mapping(bytes32 => bool) validQueryIds;
1227 
1228   mapping(string => uint) teamMapping;
1229   mapping(bool => uint) boolMapping;
1230 
1231   mapping(address => mapping(string => Player)) playerData;
1232   struct Player {
1233     uint betAmount;
1234     string team;
1235     bool withdrawn;
1236   }
1237 
1238   string public WINNER;
1239   string public loserOne;
1240   string public loserTwo;
1241 
1242   string public teamOne;
1243   string public teamTwo;
1244   string public draw;
1245 
1246   uint public betsCloseAt;
1247   uint public endsAt;
1248 
1249   event PlayerJoined(
1250     address indexed playerAddress,
1251     uint indexed betAmount,
1252     string indexed team
1253   );
1254 
1255   event RewardWithdrawn(
1256     address indexed withdrawer,
1257     uint indexed withdrawnAmount
1258   );
1259 
1260   event WinningTeamSet(string indexed team);
1261   event OraclizeQuery(string indexed description);
1262 
1263   modifier onlyOwner {
1264     require(msg.sender == address(owner));
1265     _;
1266   }
1267 
1268   modifier onlyValidTeam(string _team) {
1269     require(
1270       keccak256(bytes(_team)) == keccak256(bytes(teamOne)) ||
1271         keccak256(bytes(_team)) == keccak256(bytes(teamTwo)) ||
1272           keccak256(bytes(_team)) == keccak256(bytes(draw))
1273     );
1274     _;
1275   }
1276 
1277   modifier onlyAfterEndTime() {
1278     require(now >= endsAt);
1279     _;
1280   }
1281 
1282   modifier onlyIfWinnerIsMissing() {
1283     bytes memory winnerBytes = bytes(WINNER);
1284     require(winnerBytes.length == 0);
1285     _;
1286   }
1287 
1288   modifier onlyIfWinnerIsSet() {
1289     bytes memory winnerBytes = bytes(WINNER);
1290     require(winnerBytes.length != 0);
1291     _;
1292   }
1293 
1294   modifier endsAtAfterBetsCloseAt(uint _betsCloseAt, uint _endsAt) {
1295     require(_betsCloseAt < _endsAt);
1296     _;
1297   }
1298 
1299   modifier onlyBeforeBetsCloseAt() {
1300     require(now < betsCloseAt);
1301     _;
1302   }
1303 
1304   function Bet0xgame(string _teamOne, string _teamTwo, uint _endsAt, uint _betsCloseAt, string _oraclizeSource) public
1305     endsAtAfterBetsCloseAt(_betsCloseAt, _endsAt)
1306   {
1307     oraclize_setProof(proofType_TLSNotary);
1308     owner = msg.sender;
1309 
1310     teamOne = _teamOne;
1311     teamTwo = _teamTwo;
1312     draw = "draw";
1313     oraclizeSource = _oraclizeSource;
1314 
1315     buildTeamMapping(teamOne, teamTwo, draw);
1316     buildBoolMapping();
1317 
1318     betsCloseAt = _betsCloseAt;
1319     endsAt = _endsAt;
1320   }
1321 
1322   function bet(string _team) public payable
1323     onlyValidTeam(_team)
1324     onlyBeforeBetsCloseAt()
1325   {
1326     book[_team][msg.sender] += msg.value;
1327     oddsMapping[_team] += msg.value;
1328 
1329     if (playerData[msg.sender][_team].betAmount == 0) {
1330       playerData[msg.sender][_team] = Player(msg.value, _team, false);
1331     } else {
1332       playerData[msg.sender][_team].betAmount += msg.value;
1333     }
1334 
1335     PlayerJoined(msg.sender, msg.value, _team);
1336   }
1337 
1338   function withdrawReward() public onlyAfterEndTime() onlyIfWinnerIsSet() {
1339     uint betAmount = book[WINNER][msg.sender];
1340     uint reward = betAmount + (betAmount * (oddsMapping[loserOne] + oddsMapping[loserTwo]) / oddsMapping[WINNER]);
1341 
1342     address(msg.sender).transfer(reward);
1343 
1344     playerData[msg.sender][WINNER].withdrawn = true;
1345     book[WINNER][msg.sender] = 0;
1346 
1347     RewardWithdrawn(msg.sender, reward);
1348   }
1349 
1350   function __callback(bytes32 _queryId, string _result, bytes _proof) public
1351     onlyValidTeam(_result)
1352   {
1353     if (!validQueryIds[_queryId]) revert();
1354     if (msg.sender != oraclize_cbAddress()) revert();
1355 
1356     WINNER = _result;
1357     delete validQueryIds[_queryId];
1358 
1359     WinningTeamSet(_result);
1360     setLosers();
1361   }
1362 
1363   function oraclizeSetWinner(uint _callback_wei, uint _callback_gas_limit) public payable
1364     onlyAfterEndTime
1365     onlyIfWinnerIsMissing
1366   {
1367     require(oraclize_getPrice("URL", _callback_gas_limit) < msg.value);
1368 
1369     oraclize_setCustomGasPrice(_callback_wei);
1370 
1371     if (oraclize_getPrice("URL") > address(this).balance) {
1372       OraclizeQuery("Oraclize query not sent, balance too low");
1373     } else {
1374       bytes32 queryId = oraclize_query("URL", oraclizeSource, _callback_gas_limit);
1375       validQueryIds[queryId] = true;
1376 
1377       OraclizeQuery("Oraclize query sent!");
1378     }
1379   }
1380 
1381   //  see private method buildTeamMapping, buildBoolMapping
1382   //  first element in the nested array represents the team user betted on:
1383   //    (teamOne -> 0, teamTwo -> 1, draw -> 2)
1384   //  second element in nested array is the bet amount
1385   //  third element in nested array represents withdrawal status:
1386   //    (false -> 0, true -> 1)
1387   //  additionally (applies to first level elements):
1388   //    first array holds player data for teamOne
1389   //    second array holds player data for teamTwo
1390   //    third array holds pleyer data for draw
1391   function getPlayerData(address _playerAddress) public view returns(uint[3][3]) {
1392     return [
1393       [
1394         teamMapping[playerData[_playerAddress][teamOne].team],
1395         playerData[_playerAddress][teamOne].betAmount,
1396         boolMapping[playerData[_playerAddress][teamOne].withdrawn]
1397       ],
1398       [
1399         teamMapping[playerData[_playerAddress][teamTwo].team],
1400         playerData[_playerAddress][teamTwo].betAmount,
1401         boolMapping[playerData[_playerAddress][teamTwo].withdrawn]
1402       ],
1403       [
1404         teamMapping[playerData[_playerAddress][draw].team],
1405         playerData[_playerAddress][draw].betAmount,
1406         boolMapping[playerData[_playerAddress][draw].withdrawn]
1407       ]
1408     ];
1409   }
1410 
1411   function getPoolAmounts() public view returns(uint[3]) {
1412     return [oddsMapping[teamOne], oddsMapping[teamTwo], oddsMapping[draw]];
1413   }
1414 
1415   function withdrawRemainingRewards() public
1416     onlyOwner
1417     onlyAfterEndTime
1418     onlyIfWinnerIsSet
1419   {
1420     address(owner).transfer(address(this).balance);
1421   }
1422 
1423   function setLosers() private returns(string) {
1424     if (keccak256(bytes(WINNER)) == keccak256(bytes(teamOne))) {
1425       loserOne = teamTwo;
1426       loserTwo = draw;
1427     } else if (keccak256(bytes(WINNER)) == keccak256(bytes(teamTwo))) {
1428       loserOne = teamOne;
1429       loserTwo = draw;
1430     } else if (keccak256(bytes(WINNER)) == keccak256(bytes(draw))) {
1431       loserOne = teamOne;
1432       loserTwo = teamTwo;
1433     }
1434   }
1435 
1436   function buildTeamMapping(string _teamOne, string _teamTwo, string _draw) private {
1437     teamMapping[_teamOne] = 0;
1438     teamMapping[_teamTwo] = 1;
1439     teamMapping[_draw] = 2;
1440   }
1441 
1442   function buildBoolMapping() private {
1443     boolMapping[false] = 0;
1444     boolMapping[true] = 1;
1445   }
1446 
1447   function () public payable {}
1448 }