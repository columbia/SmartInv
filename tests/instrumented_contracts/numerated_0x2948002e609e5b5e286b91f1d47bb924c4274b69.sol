1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
32 pragma solidity ^0.4.16;
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
87     function init(buffer memory buf, uint capacity) internal {
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
98     function resize(buffer memory buf, uint capacity) private {
99         bytes memory oldbuf = buf.buf;
100         init(buf, capacity);
101         append(buf, oldbuf);
102     }
103 
104     function max(uint a, uint b) private returns(uint) {
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
118     function append(buffer memory buf, bytes data) internal returns(buffer memory) {
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
165     function append(buffer memory buf, uint8 data) internal {
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
190     function appendInt(buffer memory buf, uint data, uint len) internal returns(buffer memory) {
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
222     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private {
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
240     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private {
241         buf.append(uint8((major << 5) | 31));
242     }
243 
244     function encodeUInt(Buffer.buffer memory buf, uint value) internal {
245         encodeType(buf, MAJOR_TYPE_INT, value);
246     }
247 
248     function encodeInt(Buffer.buffer memory buf, int value) internal {
249         if(value >= 0) {
250             encodeType(buf, MAJOR_TYPE_INT, uint(value));
251         } else {
252             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
253         }
254     }
255 
256     function encodeBytes(Buffer.buffer memory buf, bytes value) internal {
257         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
258         buf.append(value);
259     }
260 
261     function encodeString(Buffer.buffer memory buf, string value) internal {
262         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
263         buf.append(bytes(value));
264     }
265 
266     function startArray(Buffer.buffer memory buf) internal {
267         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
268     }
269 
270     function startMap(Buffer.buffer memory buf) internal {
271         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
272     }
273 
274     function endSequence(Buffer.buffer memory buf) internal {
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
765     function parseAddr(string _a) internal returns (address){
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
785     function strCompare(string _a, string _b) internal returns (int) {
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
803     function indexOf(string _haystack, string _needle) internal returns (int) {
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
830     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
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
847     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
848         return strConcat(_a, _b, _c, _d, "");
849     }
850 
851     function strConcat(string _a, string _b, string _c) internal returns (string) {
852         return strConcat(_a, _b, _c, "", "");
853     }
854 
855     function strConcat(string _a, string _b) internal returns (string) {
856         return strConcat(_a, _b, "", "", "");
857     }
858 
859     // parseInt
860     function parseInt(string _a) internal returns (uint) {
861         return parseInt(_a, 0);
862     }
863 
864     // parseInt(parseFloat*10^_b)
865     function parseInt(string _a, uint _b) internal returns (uint) {
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
883     function uint2str(uint i) internal returns (string){
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
901     function stra2cbor(string[] arr) internal returns (bytes) {
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
912     function ba2cbor(bytes[] arr) internal returns (bytes) {
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
973         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
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
1067     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
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
1085         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
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
1103         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
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
1122     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
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
1217 //pragma solidity ^0.4.8;
1218 
1219 contract tokenRecipient { 
1220     
1221     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
1222     
1223 }
1224 
1225 contract EtherFlipRaffleToken is usingOraclize {
1226     
1227     modifier oraclizeAction {
1228         if (msg.sender != oraclize_cbAddress()) revert();
1229         _;
1230     }
1231     
1232     modifier ownerAction {
1233          if (msg.sender != owner) revert();
1234          _;
1235     }
1236     
1237     address public etherflipContract;
1238     address public owner;
1239 
1240     token public raffleTokenReward;
1241     
1242     //~ Hashes for lookups
1243     mapping (address => uint256) public balanceOf;
1244     mapping (address => mapping (address => uint256)) public allowance;
1245     mapping (uint256 => address) public raffleAddress;
1246 
1247     //~ Events
1248     event Transfer(address indexed from, address indexed to, uint256 value);
1249     event ProofFailed(bool didFail);
1250 
1251     //~ Token Setup
1252     string public standard = 'ETIX';
1253     string public name = "EtherFlipRaffleToken";
1254     string public symbol = "ETIX";
1255     uint8 public decimals = 0;
1256     uint256 public totalSupply = 15000000;
1257     
1258     //~ Raffle Setup
1259     uint public numberInRaffle = 0;
1260     uint public winningNumber;
1261     uint public raffleRewardAmount = 1;
1262     bytes32 currentQueryID;
1263 
1264     //~ Init we set totalSupply
1265     function EtherFlipRaffleToken() {
1266         balanceOf[msg.sender] = totalSupply;
1267         owner = msg.sender;
1268     }
1269     
1270     function () payable {
1271         if (msg.sender != owner) { revert(); }
1272     }
1273 
1274     //~~ Methods based on Token.sol from Ethereum Foundation
1275     //~ Transfer
1276     function transfer(address _to, uint256 _value) {
1277         if (_to == 0x0) revert();                               
1278         if (balanceOf[msg.sender] < _value) revert();           
1279         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); 
1280         
1281         if (msg.sender == etherflipContract) {
1282             raffleAddress[numberInRaffle] = _to;
1283             // We are using numberInRaffle as our mod, when we send ETIX - numberInRaffle increases as long as it is the EFContract sending
1284             numberInRaffle += 1;
1285             
1286             // override 'value' to only pass one ETIX on each transfer; this is needed to give our current EtherFlip
1287             // contract the ability to send only one token even when we are passing a dynamic value for each token transfer
1288             balanceOf[msg.sender] -= 1;                   
1289             balanceOf[_to] += 1;                           
1290             Transfer(msg.sender, _to, 1);
1291         } else {
1292             balanceOf[msg.sender] -= _value;                   
1293             balanceOf[_to] += _value;                           
1294             Transfer(msg.sender, _to, _value);
1295         }
1296     }
1297     
1298     function __callback(bytes32 _queryId, string _result, bytes _proof) oraclizeAction { 
1299         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0 || _proof.length == 0) {
1300             ProofFailed(true);
1301         } else {
1302             // Since we are using a 7 byte integer, the mod + 1 will result in a random number (with some fringe cases)
1303             winningNumber = uint(sha3(_result)) % (numberInRaffle + 1);
1304             raffleTokenReward.transfer(raffleAddress[winningNumber], raffleRewardAmount);
1305             numberInRaffle = 0;
1306         }
1307     }
1308     
1309     function manualRaffle() ownerAction {
1310         oraclize_setProof(proofType_Ledger);
1311         uint numberOfBytes = 7;
1312         uint delay = 0;
1313         uint callbackGas = 250000;
1314         currentQueryID = oraclize_newRandomDSQuery(delay, numberOfBytes, callbackGas);
1315     }
1316     
1317     function setEFContract(address newContract, address newToken, uint awardAmount) ownerAction {
1318         etherflipContract = newContract;
1319         raffleTokenReward = token(newToken);
1320         raffleRewardAmount = awardAmount;
1321     }
1322     
1323     function refundTransfer(address outboundAddress, uint amount) ownerAction {        
1324         outboundAddress.transfer(amount);
1325     }
1326     
1327     function walletSend(address tokenAddress, uint amount, address outboundAddress) ownerAction {
1328         token chosenToken = token(tokenAddress);
1329         chosenToken.transfer(outboundAddress, amount);
1330     }
1331     
1332     function approve(address _spender, uint256 _value) returns (bool success) {
1333         allowance[msg.sender][_spender] = _value;
1334         return true;
1335     }
1336 
1337     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
1338         tokenRecipient spender = tokenRecipient(_spender);
1339         if (approve(_spender, _value)) {
1340             spender.receiveApproval(msg.sender, _value, this, _extraData);
1341             return true;
1342         }
1343     }        
1344 
1345     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
1346         if (_to == 0x0) revert();                                
1347         if (balanceOf[_from] < _value) revert();                 
1348         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  
1349         if (_value > allowance[_from][msg.sender]) revert();     
1350         balanceOf[_from] -= _value;                           
1351         balanceOf[_to] += _value;                            
1352         allowance[_from][msg.sender] -= _value;
1353         Transfer(_from, _to, _value);
1354         return true;
1355     }
1356 }
1357 
1358 contract token { function transfer(address receiver, uint amount){ receiver; amount; } }