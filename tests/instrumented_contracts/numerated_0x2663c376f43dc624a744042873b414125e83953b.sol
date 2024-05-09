1 pragma solidity ^0.4.24;
2 
3 
4 // <ORACLIZE_API>
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
34 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
35 
36 //pragma solidity ^0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
37 
38 contract OraclizeI {
39     address public cbAddress;
40     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
41     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
42     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
43     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
44     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
45     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
46     function getPrice(string _datasource) public returns (uint _dsprice);
47     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
48     function setProofType(byte _proofType) external;
49     function setCustomGasPrice(uint _gasPrice) external;
50     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
51 }
52 
53 contract OraclizeAddrResolverI {
54     function getAddress() public returns (address _addr);
55 }
56 
57 /*
58 Begin solidity-cborutils
59 
60 https://github.com/smartcontractkit/solidity-cborutils
61 
62 MIT License
63 
64 Copyright (c) 2018 SmartContract ChainLink, Ltd.
65 
66 Permission is hereby granted, free of charge, to any person obtaining a copy
67 of this software and associated documentation files (the "Software"), to deal
68 in the Software without restriction, including without limitation the rights
69 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
70 copies of the Software, and to permit persons to whom the Software is
71 furnished to do so, subject to the following conditions:
72 
73 The above copyright notice and this permission notice shall be included in all
74 copies or substantial portions of the Software.
75 
76 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
77 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
78 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
79 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
80 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
81 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
82 SOFTWARE.
83  */
84 
85 library Buffer {
86     struct buffer {
87         bytes buf;
88         uint capacity;
89     }
90 
91     function init(buffer memory buf, uint _capacity) internal pure {
92         uint capacity = _capacity;
93         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
94         // Allocate space for the buffer data
95         buf.capacity = capacity;
96         assembly {
97             let ptr := mload(0x40)
98             mstore(buf, ptr)
99             mstore(ptr, 0)
100             mstore(0x40, add(ptr, capacity))
101         }
102     }
103 
104     function resize(buffer memory buf, uint capacity) private pure {
105         bytes memory oldbuf = buf.buf;
106         init(buf, capacity);
107         append(buf, oldbuf);
108     }
109 
110     function max(uint a, uint b) private pure returns(uint) {
111         if(a > b) {
112             return a;
113         }
114         return b;
115     }
116 
117     /**
118      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
119      *      would exceed the capacity of the buffer.
120      * @param buf The buffer to append to.
121      * @param data The data to append.
122      * @return The original buffer.
123      */
124     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
125         if(data.length + buf.buf.length > buf.capacity) {
126             resize(buf, max(buf.capacity, data.length) * 2);
127         }
128 
129         uint dest;
130         uint src;
131         uint len = data.length;
132         assembly {
133             // Memory address of the buffer data
134             let bufptr := mload(buf)
135             // Length of existing buffer data
136             let buflen := mload(bufptr)
137             // Start address = buffer address + buffer length + sizeof(buffer length)
138             dest := add(add(bufptr, buflen), 32)
139             // Update buffer length
140             mstore(bufptr, add(buflen, mload(data)))
141             src := add(data, 32)
142         }
143 
144         // Copy word-length chunks while possible
145         for(; len >= 32; len -= 32) {
146             assembly {
147                 mstore(dest, mload(src))
148             }
149             dest += 32;
150             src += 32;
151         }
152 
153         // Copy remaining bytes
154         uint mask = 256 ** (32 - len) - 1;
155         assembly {
156             let srcpart := and(mload(src), not(mask))
157             let destpart := and(mload(dest), mask)
158             mstore(dest, or(destpart, srcpart))
159         }
160 
161         return buf;
162     }
163 
164     /**
165      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
166      * exceed the capacity of the buffer.
167      * @param buf The buffer to append to.
168      * @param data The data to append.
169      * @return The original buffer.
170      */
171     function append(buffer memory buf, uint8 data) internal pure {
172         if(buf.buf.length + 1 > buf.capacity) {
173             resize(buf, buf.capacity * 2);
174         }
175 
176         assembly {
177             // Memory address of the buffer data
178             let bufptr := mload(buf)
179             // Length of existing buffer data
180             let buflen := mload(bufptr)
181             // Address = buffer address + buffer length + sizeof(buffer length)
182             let dest := add(add(bufptr, buflen), 32)
183             mstore8(dest, data)
184             // Update buffer length
185             mstore(bufptr, add(buflen, 1))
186         }
187     }
188 
189     /**
190      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
191      * exceed the capacity of the buffer.
192      * @param buf The buffer to append to.
193      * @param data The data to append.
194      * @return The original buffer.
195      */
196     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
197         if(len + buf.buf.length > buf.capacity) {
198             resize(buf, max(buf.capacity, len) * 2);
199         }
200 
201         uint mask = 256 ** len - 1;
202         assembly {
203             // Memory address of the buffer data
204             let bufptr := mload(buf)
205             // Length of existing buffer data
206             let buflen := mload(bufptr)
207             // Address = buffer address + buffer length + sizeof(buffer length) + len
208             let dest := add(add(bufptr, buflen), len)
209             mstore(dest, or(and(mload(dest), not(mask)), data))
210             // Update buffer length
211             mstore(bufptr, add(buflen, len))
212         }
213         return buf;
214     }
215 }
216 
217 library CBOR {
218     using Buffer for Buffer.buffer;
219 
220     uint8 private constant MAJOR_TYPE_INT = 0;
221     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
222     uint8 private constant MAJOR_TYPE_BYTES = 2;
223     uint8 private constant MAJOR_TYPE_STRING = 3;
224     uint8 private constant MAJOR_TYPE_ARRAY = 4;
225     uint8 private constant MAJOR_TYPE_MAP = 5;
226     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
227 
228     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
229         if(value <= 23) {
230             buf.append(uint8((major << 5) | value));
231         } else if(value <= 0xFF) {
232             buf.append(uint8((major << 5) | 24));
233             buf.appendInt(value, 1);
234         } else if(value <= 0xFFFF) {
235             buf.append(uint8((major << 5) | 25));
236             buf.appendInt(value, 2);
237         } else if(value <= 0xFFFFFFFF) {
238             buf.append(uint8((major << 5) | 26));
239             buf.appendInt(value, 4);
240         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
241             buf.append(uint8((major << 5) | 27));
242             buf.appendInt(value, 8);
243         }
244     }
245 
246     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
247         buf.append(uint8((major << 5) | 31));
248     }
249 
250     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
251         encodeType(buf, MAJOR_TYPE_INT, value);
252     }
253 
254     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
255         if(value >= 0) {
256             encodeType(buf, MAJOR_TYPE_INT, uint(value));
257         } else {
258             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
259         }
260     }
261 
262     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
263         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
264         buf.append(value);
265     }
266 
267     function encodeString(Buffer.buffer memory buf, string value) internal pure {
268         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
269         buf.append(bytes(value));
270     }
271 
272     function startArray(Buffer.buffer memory buf) internal pure {
273         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
274     }
275 
276     function startMap(Buffer.buffer memory buf) internal pure {
277         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
278     }
279 
280     function endSequence(Buffer.buffer memory buf) internal pure {
281         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
282     }
283 }
284 
285 /*
286 End solidity-cborutils
287  */
288 
289 contract usingOraclize {
290     uint constant day = 60*60*24;
291     uint constant week = 60*60*24*7;
292     uint constant month = 60*60*24*30;
293     byte constant proofType_NONE = 0x00;
294     byte constant proofType_TLSNotary = 0x10;
295     byte constant proofType_Ledger = 0x30;
296     byte constant proofType_Android = 0x40;
297     byte constant proofType_Native = 0xF0;
298     byte constant proofStorage_IPFS = 0x01;
299     uint8 constant networkID_auto = 0;
300     uint8 constant networkID_mainnet = 1;
301     uint8 constant networkID_testnet = 2;
302     uint8 constant networkID_morden = 2;
303     uint8 constant networkID_consensys = 161;
304 
305     OraclizeAddrResolverI OAR;
306 
307     OraclizeI oraclize;
308     modifier oraclizeAPI {
309         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
310             oraclize_setNetwork(networkID_auto);
311 
312         if(address(oraclize) != OAR.getAddress())
313             oraclize = OraclizeI(OAR.getAddress());
314 
315         _;
316     }
317     modifier coupon(string code){
318         oraclize = OraclizeI(OAR.getAddress());
319         _;
320     }
321 
322     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
323       return oraclize_setNetwork();
324       networkID; // silence the warning and remain backwards compatible
325     }
326     function oraclize_setNetwork() internal returns(bool){
327         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
328             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
329             oraclize_setNetworkName("eth_mainnet");
330             return true;
331         }
332         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
333             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
334             oraclize_setNetworkName("eth_ropsten3");
335             return true;
336         }
337         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
338             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
339             oraclize_setNetworkName("eth_kovan");
340             return true;
341         }
342         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
343             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
344             oraclize_setNetworkName("eth_rinkeby");
345             return true;
346         }
347         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
348             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
349             return true;
350         }
351         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
352             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
353             return true;
354         }
355         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
356             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
357             return true;
358         }
359         return false;
360     }
361 
362     function __callback(bytes32 myid, string result) public {
363         __callback(myid, result, new bytes(0));
364     }
365     function __callback(bytes32 myid, string result, bytes proof) public {
366       return;
367       myid; result; proof; // Silence compiler warnings
368     }
369 
370     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
371         return oraclize.getPrice(datasource);
372     }
373 
374     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
375         return oraclize.getPrice(datasource, gaslimit);
376     }
377 
378     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource);
380         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
381         return oraclize.query.value(price)(0, datasource, arg);
382     }
383     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         return oraclize.query.value(price)(timestamp, datasource, arg);
387     }
388     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource, gaslimit);
390         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
391         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
392     }
393     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource, gaslimit);
395         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
396         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
397     }
398     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource);
400         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
401         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
402     }
403     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
404         uint price = oraclize.getPrice(datasource);
405         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
406         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
407     }
408     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource, gaslimit);
410         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
411         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
412     }
413     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource, gaslimit);
415         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
416         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
417     }
418     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource);
420         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
421         bytes memory args = stra2cbor(argN);
422         return oraclize.queryN.value(price)(0, datasource, args);
423     }
424     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource);
426         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
427         bytes memory args = stra2cbor(argN);
428         return oraclize.queryN.value(price)(timestamp, datasource, args);
429     }
430     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         bytes memory args = stra2cbor(argN);
434         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
435     }
436     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource, gaslimit);
438         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
439         bytes memory args = stra2cbor(argN);
440         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
441     }
442     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
443         string[] memory dynargs = new string[](1);
444         dynargs[0] = args[0];
445         return oraclize_query(datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](1);
449         dynargs[0] = args[0];
450         return oraclize_query(timestamp, datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](1);
454         dynargs[0] = args[0];
455         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
456     }
457     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](1);
459         dynargs[0] = args[0];
460         return oraclize_query(datasource, dynargs, gaslimit);
461     }
462 
463     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](2);
465         dynargs[0] = args[0];
466         dynargs[1] = args[1];
467         return oraclize_query(datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](2);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         return oraclize_query(timestamp, datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](2);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
480     }
481     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](2);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         return oraclize_query(datasource, dynargs, gaslimit);
486     }
487     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
488         string[] memory dynargs = new string[](3);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         return oraclize_query(datasource, dynargs);
493     }
494     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](3);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         return oraclize_query(timestamp, datasource, dynargs);
500     }
501     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         string[] memory dynargs = new string[](3);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
507     }
508     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](3);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         return oraclize_query(datasource, dynargs, gaslimit);
514     }
515 
516     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](4);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         dynargs[3] = args[3];
522         return oraclize_query(datasource, dynargs);
523     }
524     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](4);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         dynargs[3] = args[3];
530         return oraclize_query(timestamp, datasource, dynargs);
531     }
532     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](4);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](4);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         return oraclize_query(datasource, dynargs, gaslimit);
547     }
548     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](5);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         dynargs[4] = args[4];
555         return oraclize_query(datasource, dynargs);
556     }
557     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](5);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         dynargs[3] = args[3];
563         dynargs[4] = args[4];
564         return oraclize_query(timestamp, datasource, dynargs);
565     }
566     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](5);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         dynargs[3] = args[3];
572         dynargs[4] = args[4];
573         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
574     }
575     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
576         string[] memory dynargs = new string[](5);
577         dynargs[0] = args[0];
578         dynargs[1] = args[1];
579         dynargs[2] = args[2];
580         dynargs[3] = args[3];
581         dynargs[4] = args[4];
582         return oraclize_query(datasource, dynargs, gaslimit);
583     }
584     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource);
586         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
587         bytes memory args = ba2cbor(argN);
588         return oraclize.queryN.value(price)(0, datasource, args);
589     }
590     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource);
592         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
593         bytes memory args = ba2cbor(argN);
594         return oraclize.queryN.value(price)(timestamp, datasource, args);
595     }
596     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
597         uint price = oraclize.getPrice(datasource, gaslimit);
598         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
599         bytes memory args = ba2cbor(argN);
600         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
601     }
602     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
603         uint price = oraclize.getPrice(datasource, gaslimit);
604         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
605         bytes memory args = ba2cbor(argN);
606         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
607     }
608     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
609         bytes[] memory dynargs = new bytes[](1);
610         dynargs[0] = args[0];
611         return oraclize_query(datasource, dynargs);
612     }
613     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](1);
615         dynargs[0] = args[0];
616         return oraclize_query(timestamp, datasource, dynargs);
617     }
618     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](1);
620         dynargs[0] = args[0];
621         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
622     }
623     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](1);
625         dynargs[0] = args[0];
626         return oraclize_query(datasource, dynargs, gaslimit);
627     }
628 
629     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](2);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         return oraclize_query(datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](2);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         return oraclize_query(timestamp, datasource, dynargs);
640     }
641     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](2);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
646     }
647     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](2);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         return oraclize_query(datasource, dynargs, gaslimit);
652     }
653     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
654         bytes[] memory dynargs = new bytes[](3);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         return oraclize_query(datasource, dynargs);
659     }
660     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](3);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         return oraclize_query(timestamp, datasource, dynargs);
666     }
667     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
668         bytes[] memory dynargs = new bytes[](3);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         dynargs[2] = args[2];
672         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
673     }
674     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](3);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         return oraclize_query(datasource, dynargs, gaslimit);
680     }
681 
682     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](4);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         return oraclize_query(datasource, dynargs);
689     }
690     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
691         bytes[] memory dynargs = new bytes[](4);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         return oraclize_query(timestamp, datasource, dynargs);
697     }
698     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](4);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         dynargs[2] = args[2];
703         dynargs[3] = args[3];
704         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
705     }
706     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](4);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         return oraclize_query(datasource, dynargs, gaslimit);
713     }
714     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
715         bytes[] memory dynargs = new bytes[](5);
716         dynargs[0] = args[0];
717         dynargs[1] = args[1];
718         dynargs[2] = args[2];
719         dynargs[3] = args[3];
720         dynargs[4] = args[4];
721         return oraclize_query(datasource, dynargs);
722     }
723     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](5);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         dynargs[4] = args[4];
730         return oraclize_query(timestamp, datasource, dynargs);
731     }
732     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](5);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         dynargs[3] = args[3];
738         dynargs[4] = args[4];
739         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
740     }
741     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
742         bytes[] memory dynargs = new bytes[](5);
743         dynargs[0] = args[0];
744         dynargs[1] = args[1];
745         dynargs[2] = args[2];
746         dynargs[3] = args[3];
747         dynargs[4] = args[4];
748         return oraclize_query(datasource, dynargs, gaslimit);
749     }
750 
751     function oraclize_cbAddress() oraclizeAPI internal returns (address){
752         return oraclize.cbAddress();
753     }
754     function oraclize_setProof(byte proofP) oraclizeAPI internal {
755         return oraclize.setProofType(proofP);
756     }
757     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
758         return oraclize.setCustomGasPrice(gasPrice);
759     }
760 
761     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
762         return oraclize.randomDS_getSessionPubKeyHash();
763     }
764 
765     function getCodeSize(address _addr) constant internal returns(uint _size) {
766         assembly {
767             _size := extcodesize(_addr)
768         }
769     }
770 
771     function parseAddr(string _a) internal pure returns (address){
772         bytes memory tmp = bytes(_a);
773         uint160 iaddr = 0;
774         uint160 b1;
775         uint160 b2;
776         for (uint i=2; i<2+2*20; i+=2){
777             iaddr *= 256;
778             b1 = uint160(tmp[i]);
779             b2 = uint160(tmp[i+1]);
780             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
781             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
782             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
783             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
784             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
785             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
786             iaddr += (b1*16+b2);
787         }
788         return address(iaddr);
789     }
790 
791     function strCompare(string _a, string _b) internal pure returns (int) {
792         bytes memory a = bytes(_a);
793         bytes memory b = bytes(_b);
794         uint minLength = a.length;
795         if (b.length < minLength) minLength = b.length;
796         for (uint i = 0; i < minLength; i ++)
797             if (a[i] < b[i])
798                 return -1;
799             else if (a[i] > b[i])
800                 return 1;
801         if (a.length < b.length)
802             return -1;
803         else if (a.length > b.length)
804             return 1;
805         else
806             return 0;
807     }
808 
809     function indexOf(string _haystack, string _needle) internal pure returns (int) {
810         bytes memory h = bytes(_haystack);
811         bytes memory n = bytes(_needle);
812         if(h.length < 1 || n.length < 1 || (n.length > h.length))
813             return -1;
814         else if(h.length > (2**128 -1))
815             return -1;
816         else
817         {
818             uint subindex = 0;
819             for (uint i = 0; i < h.length; i ++)
820             {
821                 if (h[i] == n[0])
822                 {
823                     subindex = 1;
824                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
825                     {
826                         subindex++;
827                     }
828                     if(subindex == n.length)
829                         return int(i);
830                 }
831             }
832             return -1;
833         }
834     }
835 
836     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
837         bytes memory _ba = bytes(_a);
838         bytes memory _bb = bytes(_b);
839         bytes memory _bc = bytes(_c);
840         bytes memory _bd = bytes(_d);
841         bytes memory _be = bytes(_e);
842         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
843         bytes memory babcde = bytes(abcde);
844         uint k = 0;
845         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
846         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
847         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
848         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
849         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
850         return string(babcde);
851     }
852 
853     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
854         return strConcat(_a, _b, _c, _d, "");
855     }
856 
857     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
858         return strConcat(_a, _b, _c, "", "");
859     }
860 
861     function strConcat(string _a, string _b) internal pure returns (string) {
862         return strConcat(_a, _b, "", "", "");
863     }
864 
865     // parseInt
866     function parseInt(string _a) internal pure returns (uint) {
867         return parseInt(_a, 0);
868     }
869 
870     // parseInt(parseFloat*10^_b)
871     function parseInt(string _a, uint _b) internal pure returns (uint) {
872         bytes memory bresult = bytes(_a);
873         uint mint = 0;
874         bool decimals = false;
875         for (uint i=0; i<bresult.length; i++){
876             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
877                 if (decimals){
878                    if (_b == 0) break;
879                     else _b--;
880                 }
881                 mint *= 10;
882                 mint += uint(bresult[i]) - 48;
883             } else if (bresult[i] == 46) decimals = true;
884         }
885         if (_b > 0) mint *= 10**_b;
886         return mint;
887     }
888 
889     function uint2str(uint i) internal pure returns (string){
890         if (i == 0) return "0";
891         uint j = i;
892         uint len;
893         while (j != 0){
894             len++;
895             j /= 10;
896         }
897         bytes memory bstr = new bytes(len);
898         uint k = len - 1;
899         while (i != 0){
900             bstr[k--] = byte(48 + i % 10);
901             i /= 10;
902         }
903         return string(bstr);
904     }
905 
906     using CBOR for Buffer.buffer;
907     function stra2cbor(string[] arr) internal pure returns (bytes) {
908         safeMemoryCleaner();
909         Buffer.buffer memory buf;
910         Buffer.init(buf, 1024);
911         buf.startArray();
912         for (uint i = 0; i < arr.length; i++) {
913             buf.encodeString(arr[i]);
914         }
915         buf.endSequence();
916         return buf.buf;
917     }
918 
919     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
920         safeMemoryCleaner();
921         Buffer.buffer memory buf;
922         Buffer.init(buf, 1024);
923         buf.startArray();
924         for (uint i = 0; i < arr.length; i++) {
925             buf.encodeBytes(arr[i]);
926         }
927         buf.endSequence();
928         return buf.buf;
929     }
930 
931     string oraclize_network_name;
932     function oraclize_setNetworkName(string _network_name) internal {
933         oraclize_network_name = _network_name;
934     }
935 
936     function oraclize_getNetworkName() internal view returns (string) {
937         return oraclize_network_name;
938     }
939 
940     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
941         require((_nbytes > 0) && (_nbytes <= 32));
942         // Convert from seconds to ledger timer ticks
943         _delay *= 10;
944         bytes memory nbytes = new bytes(1);
945         nbytes[0] = byte(_nbytes);
946         bytes memory unonce = new bytes(32);
947         bytes memory sessionKeyHash = new bytes(32);
948         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
949         assembly {
950             mstore(unonce, 0x20)
951             // the following variables can be relaxed
952             // check relaxed random contract under ethereum-examples repo
953             // for an idea on how to override and replace comit hash vars
954             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
955             mstore(sessionKeyHash, 0x20)
956             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
957         }
958         bytes memory delay = new bytes(32);
959         assembly {
960             mstore(add(delay, 0x20), _delay)
961         }
962 
963         bytes memory delay_bytes8 = new bytes(8);
964         copyBytes(delay, 24, 8, delay_bytes8, 0);
965 
966         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
967         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
968 
969         bytes memory delay_bytes8_left = new bytes(8);
970 
971         assembly {
972             let x := mload(add(delay_bytes8, 0x20))
973             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
978             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
979             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
980             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
981 
982         }
983 
984         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
985         return queryId;
986     }
987 
988     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
989         oraclize_randomDS_args[queryId] = commitment;
990     }
991 
992     mapping(bytes32=>bytes32) oraclize_randomDS_args;
993     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
994 
995     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
996         bool sigok;
997         address signer;
998 
999         bytes32 sigr;
1000         bytes32 sigs;
1001 
1002         bytes memory sigr_ = new bytes(32);
1003         uint offset = 4+(uint(dersig[3]) - 0x20);
1004         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1005         bytes memory sigs_ = new bytes(32);
1006         offset += 32 + 2;
1007         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1008 
1009         assembly {
1010             sigr := mload(add(sigr_, 32))
1011             sigs := mload(add(sigs_, 32))
1012         }
1013 
1014 
1015         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1016         if (address(keccak256(pubkey)) == signer) return true;
1017         else {
1018             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1019             return (address(keccak256(pubkey)) == signer);
1020         }
1021     }
1022 
1023     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1024         bool sigok;
1025 
1026         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1027         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1028         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1029 
1030         bytes memory appkey1_pubkey = new bytes(64);
1031         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1032 
1033         bytes memory tosign2 = new bytes(1+65+32);
1034         tosign2[0] = byte(1); //role
1035         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1036         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1037         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1038         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1039 
1040         if (sigok == false) return false;
1041 
1042 
1043         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1044         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1045 
1046         bytes memory tosign3 = new bytes(1+65);
1047         tosign3[0] = 0xFE;
1048         copyBytes(proof, 3, 65, tosign3, 1);
1049 
1050         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1051         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1052 
1053         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1054 
1055         return sigok;
1056     }
1057 
1058     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1059         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1060         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1061 
1062         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1063         require(proofVerified);
1064 
1065         _;
1066     }
1067 
1068     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1069         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1070         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1071 
1072         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1073         if (proofVerified == false) return 2;
1074 
1075         return 0;
1076     }
1077 
1078     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1079         bool match_ = true;
1080 
1081         require(prefix.length == n_random_bytes);
1082 
1083         for (uint256 i=0; i< n_random_bytes; i++) {
1084             if (content[i] != prefix[i]) match_ = false;
1085         }
1086 
1087         return match_;
1088     }
1089 
1090     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1091 
1092         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1093         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1094         bytes memory keyhash = new bytes(32);
1095         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1096         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1097 
1098         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1099         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1100 
1101         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1102         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1103 
1104         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1105         // This is to verify that the computed args match with the ones specified in the query.
1106         bytes memory commitmentSlice1 = new bytes(8+1+32);
1107         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1108 
1109         bytes memory sessionPubkey = new bytes(64);
1110         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1111         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1112 
1113         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1114         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1115             delete oraclize_randomDS_args[queryId];
1116         } else return false;
1117 
1118 
1119         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1120         bytes memory tosign1 = new bytes(32+8+1+32);
1121         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1122         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1123 
1124         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1125         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1126             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1127         }
1128 
1129         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1130     }
1131 
1132     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1133     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1134         uint minLength = length + toOffset;
1135 
1136         // Buffer too small
1137         require(to.length >= minLength); // Should be a better way?
1138 
1139         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1140         uint i = 32 + fromOffset;
1141         uint j = 32 + toOffset;
1142 
1143         while (i < (32 + fromOffset + length)) {
1144             assembly {
1145                 let tmp := mload(add(from, i))
1146                 mstore(add(to, j), tmp)
1147             }
1148             i += 32;
1149             j += 32;
1150         }
1151 
1152         return to;
1153     }
1154 
1155     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1156     // Duplicate Solidity's ecrecover, but catching the CALL return value
1157     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1158         // We do our own memory management here. Solidity uses memory offset
1159         // 0x40 to store the current end of memory. We write past it (as
1160         // writes are memory extensions), but don't update the offset so
1161         // Solidity will reuse it. The memory used here is only needed for
1162         // this context.
1163 
1164         // FIXME: inline assembly can't access return values
1165         bool ret;
1166         address addr;
1167 
1168         assembly {
1169             let size := mload(0x40)
1170             mstore(size, hash)
1171             mstore(add(size, 32), v)
1172             mstore(add(size, 64), r)
1173             mstore(add(size, 96), s)
1174 
1175             // NOTE: we can reuse the request memory because we deal with
1176             //       the return code
1177             ret := call(3000, 1, 0, size, 128, size, 32)
1178             addr := mload(size)
1179         }
1180 
1181         return (ret, addr);
1182     }
1183 
1184     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1185     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1186         bytes32 r;
1187         bytes32 s;
1188         uint8 v;
1189 
1190         if (sig.length != 65)
1191           return (false, 0);
1192 
1193         // The signature format is a compact form of:
1194         //   {bytes32 r}{bytes32 s}{uint8 v}
1195         // Compact means, uint8 is not padded to 32 bytes.
1196         assembly {
1197             r := mload(add(sig, 32))
1198             s := mload(add(sig, 64))
1199 
1200             // Here we are loading the last 32 bytes. We exploit the fact that
1201             // 'mload' will pad with zeroes if we overread.
1202             // There is no 'mload8' to do this, but that would be nicer.
1203             v := byte(0, mload(add(sig, 96)))
1204 
1205             // Alternative solution:
1206             // 'byte' is not working due to the Solidity parser, so lets
1207             // use the second best option, 'and'
1208             // v := and(mload(add(sig, 65)), 255)
1209         }
1210 
1211         // albeit non-transactional signatures are not specified by the YP, one would expect it
1212         // to match the YP range of [27, 28]
1213         //
1214         // geth uses [0, 1] and some clients have followed. This might change, see:
1215         //  https://github.com/ethereum/go-ethereum/issues/2053
1216         if (v < 27)
1217           v += 27;
1218 
1219         if (v != 27 && v != 28)
1220             return (false, 0);
1221 
1222         return safer_ecrecover(hash, v, r, s);
1223     }
1224 
1225     function safeMemoryCleaner() internal pure {
1226         assembly {
1227             let fmem := mload(0x40)
1228             codecopy(fmem, codesize, sub(msize, fmem))
1229         }
1230     }
1231 
1232 }
1233 // </ORACLIZE_API>
1234 
1235 
1236 /*
1237  * Ownable
1238  *
1239  * Base contract with an owner.
1240  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
1241  */
1242 
1243 contract Ownable {
1244     address public owner;
1245     function Ownable() {
1246         owner = msg.sender;
1247     }
1248 
1249     modifier onlyOwner() {
1250         if (msg.sender == owner)
1251         _;
1252     }
1253 
1254     function transferOwnership(address newOwner) onlyOwner {
1255         if (newOwner != address(0)) owner = newOwner;
1256     }
1257 
1258 }
1259 
1260 library SafeMath {
1261 
1262     /**
1263     * @dev Multiplies two numbers, throws on overflow.
1264     */
1265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1266         if (a == 0) {
1267             return 0;
1268         }
1269         uint256 c = a * b;
1270         assert(c / a == b);
1271         return c;
1272     }
1273 
1274     /**
1275     * @dev Integer division of two numbers, truncating the quotient.
1276     */
1277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1278         // assert(b > 0); // Solidity automatically throws when dividing by 0
1279         // uint256 c = a / b;
1280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1281         return a / b;
1282     }
1283 
1284     /**
1285     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1286     */
1287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1288         assert(b <= a);
1289         return a - b;
1290     }
1291 
1292     /**
1293     * @dev Adds two numbers, throws on overflow.
1294     */
1295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1296         uint256 c = a + b;
1297         assert(c >= a);
1298         return c;
1299     }
1300 }
1301 
1302 library strings {
1303     struct slice {
1304         uint _len;
1305         uint _ptr;
1306     }
1307 
1308     function memcpy(uint dest, uint src, uint len) private {
1309         // Copy word-length chunks while possible
1310         for(; len >= 32; len -= 32) {
1311             assembly {
1312                 mstore(dest, mload(src))
1313             }
1314             dest += 32;
1315             src += 32;
1316         }
1317 
1318         // Copy remaining bytes
1319         uint mask = 256 ** (32 - len) - 1;
1320         assembly {
1321             let srcpart := and(mload(src), not(mask))
1322             let destpart := and(mload(dest), mask)
1323             mstore(dest, or(destpart, srcpart))
1324         }
1325     }
1326 
1327     /*
1328      * @dev Returns a slice containing the entire string.
1329      * @param self The string to make a slice from.
1330      * @return A newly allocated slice containing the entire string.
1331      */
1332     function toSlice(string self) internal returns (slice) {
1333         uint ptr;
1334         assembly {
1335             ptr := add(self, 0x20)
1336         }
1337         return slice(bytes(self).length, ptr);
1338     }
1339 
1340     /*
1341      * @dev Returns the length of a null-terminated bytes32 string.
1342      * @param self The value to find the length of.
1343      * @return The length of the string, from 0 to 32.
1344      */
1345     function len(bytes32 self) internal returns (uint) {
1346         uint ret;
1347         if (self == 0)
1348             return 0;
1349         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1350             ret += 16;
1351             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1352         }
1353         if (self & 0xffffffffffffffff == 0) {
1354             ret += 8;
1355             self = bytes32(uint(self) / 0x10000000000000000);
1356         }
1357         if (self & 0xffffffff == 0) {
1358             ret += 4;
1359             self = bytes32(uint(self) / 0x100000000);
1360         }
1361         if (self & 0xffff == 0) {
1362             ret += 2;
1363             self = bytes32(uint(self) / 0x10000);
1364         }
1365         if (self & 0xff == 0) {
1366             ret += 1;
1367         }
1368         return 32 - ret;
1369     }
1370 
1371     /*
1372      * @dev Returns a slice containing the entire bytes32, interpreted as a
1373      *      null-termintaed utf-8 string.
1374      * @param self The bytes32 value to convert to a slice.
1375      * @return A new slice containing the value of the input argument up to the
1376      *         first null.
1377      */
1378     function toSliceB32(bytes32 self) internal returns (slice ret) {
1379         // Allocate space for `self` in memory, copy it there, and point ret at it
1380         assembly {
1381             let ptr := mload(0x40)
1382             mstore(0x40, add(ptr, 0x20))
1383             mstore(ptr, self)
1384             mstore(add(ret, 0x20), ptr)
1385         }
1386         ret._len = len(self);
1387     }
1388 
1389     /*
1390      * @dev Returns a new slice containing the same data as the current slice.
1391      * @param self The slice to copy.
1392      * @return A new slice containing the same data as `self`.
1393      */
1394     function copy(slice self) internal returns (slice) {
1395         return slice(self._len, self._ptr);
1396     }
1397 
1398     /*
1399      * @dev Copies a slice to a new string.
1400      * @param self The slice to copy.
1401      * @return A newly allocated string containing the slice's text.
1402      */
1403     function toString(slice self) internal returns (string) {
1404         var ret = new string(self._len);
1405         uint retptr;
1406         assembly { retptr := add(ret, 32) }
1407 
1408         memcpy(retptr, self._ptr, self._len);
1409         return ret;
1410     }
1411 
1412     /*
1413      * @dev Returns the length in runes of the slice. Note that this operation
1414      *      takes time proportional to the length of the slice; avoid using it
1415      *      in loops, and call `slice.empty()` if you only need to know whether
1416      *      the slice is empty or not.
1417      * @param self The slice to operate on.
1418      * @return The length of the slice in runes.
1419      */
1420     function len(slice self) internal returns (uint) {
1421         // Starting at ptr-31 means the LSB will be the byte we care about
1422         var ptr = self._ptr - 31;
1423         var end = ptr + self._len;
1424         for (uint len = 0; ptr < end; len++) {
1425             uint8 b;
1426             assembly { b := and(mload(ptr), 0xFF) }
1427             if (b < 0x80) {
1428                 ptr += 1;
1429             } else if(b < 0xE0) {
1430                 ptr += 2;
1431             } else if(b < 0xF0) {
1432                 ptr += 3;
1433             } else if(b < 0xF8) {
1434                 ptr += 4;
1435             } else if(b < 0xFC) {
1436                 ptr += 5;
1437             } else {
1438                 ptr += 6;
1439             }
1440         }
1441         return len;
1442     }
1443 
1444     /*
1445      * @dev Returns true if the slice is empty (has a length of 0).
1446      * @param self The slice to operate on.
1447      * @return True if the slice is empty, False otherwise.
1448      */
1449     function empty(slice self) internal returns (bool) {
1450         return self._len == 0;
1451     }
1452 
1453     /*
1454      * @dev Returns a positive number if `other` comes lexicographically after
1455      *      `self`, a negative number if it comes before, or zero if the
1456      *      contents of the two slices are equal. Comparison is done per-rune,
1457      *      on unicode codepoints.
1458      * @param self The first slice to compare.
1459      * @param other The second slice to compare.
1460      * @return The result of the comparison.
1461      */
1462     function compare(slice self, slice other) internal returns (int) {
1463         uint shortest = self._len;
1464         if (other._len < self._len)
1465             shortest = other._len;
1466 
1467         var selfptr = self._ptr;
1468         var otherptr = other._ptr;
1469         for (uint idx = 0; idx < shortest; idx += 32) {
1470             uint a;
1471             uint b;
1472             assembly {
1473                 a := mload(selfptr)
1474                 b := mload(otherptr)
1475             }
1476             if (a != b) {
1477                 // Mask out irrelevant bytes and check again
1478                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1479                 var diff = (a & mask) - (b & mask);
1480                 if (diff != 0)
1481                     return int(diff);
1482             }
1483             selfptr += 32;
1484             otherptr += 32;
1485         }
1486         return int(self._len) - int(other._len);
1487     }
1488 
1489     /*
1490      * @dev Returns true if the two slices contain the same text.
1491      * @param self The first slice to compare.
1492      * @param self The second slice to compare.
1493      * @return True if the slices are equal, false otherwise.
1494      */
1495     function equals(slice self, slice other) internal returns (bool) {
1496         return compare(self, other) == 0;
1497     }
1498 
1499     /*
1500      * @dev Extracts the first rune in the slice into `rune`, advancing the
1501      *      slice to point to the next rune and returning `self`.
1502      * @param self The slice to operate on.
1503      * @param rune The slice that will contain the first rune.
1504      * @return `rune`.
1505      */
1506     function nextRune(slice self, slice rune) internal returns (slice) {
1507         rune._ptr = self._ptr;
1508 
1509         if (self._len == 0) {
1510             rune._len = 0;
1511             return rune;
1512         }
1513 
1514         uint len;
1515         uint b;
1516         // Load the first byte of the rune into the LSBs of b
1517         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1518         if (b < 0x80) {
1519             len = 1;
1520         } else if(b < 0xE0) {
1521             len = 2;
1522         } else if(b < 0xF0) {
1523             len = 3;
1524         } else {
1525             len = 4;
1526         }
1527 
1528         // Check for truncated codepoints
1529         if (len > self._len) {
1530             rune._len = self._len;
1531             self._ptr += self._len;
1532             self._len = 0;
1533             return rune;
1534         }
1535 
1536         self._ptr += len;
1537         self._len -= len;
1538         rune._len = len;
1539         return rune;
1540     }
1541 
1542     /*
1543      * @dev Returns the first rune in the slice, advancing the slice to point
1544      *      to the next rune.
1545      * @param self The slice to operate on.
1546      * @return A slice containing only the first rune from `self`.
1547      */
1548     function nextRune(slice self) internal returns (slice ret) {
1549         nextRune(self, ret);
1550     }
1551 
1552     /*
1553      * @dev Returns the number of the first codepoint in the slice.
1554      * @param self The slice to operate on.
1555      * @return The number of the first codepoint in the slice.
1556      */
1557     function ord(slice self) internal returns (uint ret) {
1558         if (self._len == 0) {
1559             return 0;
1560         }
1561 
1562         uint word;
1563         uint len;
1564         uint div = 2 ** 248;
1565 
1566         // Load the rune into the MSBs of b
1567         assembly { word:= mload(mload(add(self, 32))) }
1568         var b = word / div;
1569         if (b < 0x80) {
1570             ret = b;
1571             len = 1;
1572         } else if(b < 0xE0) {
1573             ret = b & 0x1F;
1574             len = 2;
1575         } else if(b < 0xF0) {
1576             ret = b & 0x0F;
1577             len = 3;
1578         } else {
1579             ret = b & 0x07;
1580             len = 4;
1581         }
1582 
1583         // Check for truncated codepoints
1584         if (len > self._len) {
1585             return 0;
1586         }
1587 
1588         for (uint i = 1; i < len; i++) {
1589             div = div / 256;
1590             b = (word / div) & 0xFF;
1591             if (b & 0xC0 != 0x80) {
1592                 // Invalid UTF-8 sequence
1593                 return 0;
1594             }
1595             ret = (ret * 64) | (b & 0x3F);
1596         }
1597 
1598         return ret;
1599     }
1600 
1601     /*
1602      * @dev Returns the keccak-256 hash of the slice.
1603      * @param self The slice to hash.
1604      * @return The hash of the slice.
1605      */
1606     function keccak(slice self) internal returns (bytes32 ret) {
1607         assembly {
1608             ret := sha3(mload(add(self, 32)), mload(self))
1609         }
1610     }
1611 
1612     /*
1613      * @dev Returns true if `self` starts with `needle`.
1614      * @param self The slice to operate on.
1615      * @param needle The slice to search for.
1616      * @return True if the slice starts with the provided text, false otherwise.
1617      */
1618     function startsWith(slice self, slice needle) internal returns (bool) {
1619         if (self._len < needle._len) {
1620             return false;
1621         }
1622 
1623         if (self._ptr == needle._ptr) {
1624             return true;
1625         }
1626 
1627         bool equal;
1628         assembly {
1629             let len := mload(needle)
1630             let selfptr := mload(add(self, 0x20))
1631             let needleptr := mload(add(needle, 0x20))
1632             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1633         }
1634         return equal;
1635     }
1636 
1637     /*
1638      * @dev If `self` starts with `needle`, `needle` is removed from the
1639      *      beginning of `self`. Otherwise, `self` is unmodified.
1640      * @param self The slice to operate on.
1641      * @param needle The slice to search for.
1642      * @return `self`
1643      */
1644     function beyond(slice self, slice needle) internal returns (slice) {
1645         if (self._len < needle._len) {
1646             return self;
1647         }
1648 
1649         bool equal = true;
1650         if (self._ptr != needle._ptr) {
1651             assembly {
1652                 let len := mload(needle)
1653                 let selfptr := mload(add(self, 0x20))
1654                 let needleptr := mload(add(needle, 0x20))
1655                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1656             }
1657         }
1658 
1659         if (equal) {
1660             self._len -= needle._len;
1661             self._ptr += needle._len;
1662         }
1663 
1664         return self;
1665     }
1666 
1667     /*
1668      * @dev Returns true if the slice ends with `needle`.
1669      * @param self The slice to operate on.
1670      * @param needle The slice to search for.
1671      * @return True if the slice starts with the provided text, false otherwise.
1672      */
1673     function endsWith(slice self, slice needle) internal returns (bool) {
1674         if (self._len < needle._len) {
1675             return false;
1676         }
1677 
1678         var selfptr = self._ptr + self._len - needle._len;
1679 
1680         if (selfptr == needle._ptr) {
1681             return true;
1682         }
1683 
1684         bool equal;
1685         assembly {
1686             let len := mload(needle)
1687             let needleptr := mload(add(needle, 0x20))
1688             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1689         }
1690 
1691         return equal;
1692     }
1693 
1694     /*
1695      * @dev If `self` ends with `needle`, `needle` is removed from the
1696      *      end of `self`. Otherwise, `self` is unmodified.
1697      * @param self The slice to operate on.
1698      * @param needle The slice to search for.
1699      * @return `self`
1700      */
1701     function until(slice self, slice needle) internal returns (slice) {
1702         if (self._len < needle._len) {
1703             return self;
1704         }
1705 
1706         var selfptr = self._ptr + self._len - needle._len;
1707         bool equal = true;
1708         if (selfptr != needle._ptr) {
1709             assembly {
1710                 let len := mload(needle)
1711                 let needleptr := mload(add(needle, 0x20))
1712                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1713             }
1714         }
1715 
1716         if (equal) {
1717             self._len -= needle._len;
1718         }
1719 
1720         return self;
1721     }
1722 
1723     // Returns the memory address of the first byte of the first occurrence of
1724     // `needle` in `self`, or the first byte after `self` if not found.
1725     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1726         uint ptr;
1727         uint idx;
1728 
1729         if (needlelen <= selflen) {
1730             if (needlelen <= 32) {
1731                 // Optimized assembly for 68 gas per byte on short strings
1732                 assembly {
1733                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1734                     let needledata := and(mload(needleptr), mask)
1735                     let end := add(selfptr, sub(selflen, needlelen))
1736                     ptr := selfptr
1737                     loop:
1738                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1739                     ptr := add(ptr, 1)
1740                     jumpi(loop, lt(sub(ptr, 1), end))
1741                     ptr := add(selfptr, selflen)
1742                     exit:
1743                 }
1744                 return ptr;
1745             } else {
1746                 // For long needles, use hashing
1747                 bytes32 hash;
1748                 assembly { hash := sha3(needleptr, needlelen) }
1749                 ptr = selfptr;
1750                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1751                     bytes32 testHash;
1752                     assembly { testHash := sha3(ptr, needlelen) }
1753                     if (hash == testHash)
1754                         return ptr;
1755                     ptr += 1;
1756                 }
1757             }
1758         }
1759         return selfptr + selflen;
1760     }
1761 
1762     // Returns the memory address of the first byte after the last occurrence of
1763     // `needle` in `self`, or the address of `self` if not found.
1764     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1765         uint ptr;
1766 
1767         if (needlelen <= selflen) {
1768             if (needlelen <= 32) {
1769                 // Optimized assembly for 69 gas per byte on short strings
1770                 assembly {
1771                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1772                     let needledata := and(mload(needleptr), mask)
1773                     ptr := add(selfptr, sub(selflen, needlelen))
1774                     loop:
1775                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1776                     ptr := sub(ptr, 1)
1777                     jumpi(loop, gt(add(ptr, 1), selfptr))
1778                     ptr := selfptr
1779                     jump(exit)
1780                     ret:
1781                     ptr := add(ptr, needlelen)
1782                     exit:
1783                 }
1784                 return ptr;
1785             } else {
1786                 // For long needles, use hashing
1787                 bytes32 hash;
1788                 assembly { hash := sha3(needleptr, needlelen) }
1789                 ptr = selfptr + (selflen - needlelen);
1790                 while (ptr >= selfptr) {
1791                     bytes32 testHash;
1792                     assembly { testHash := sha3(ptr, needlelen) }
1793                     if (hash == testHash)
1794                         return ptr + needlelen;
1795                     ptr -= 1;
1796                 }
1797             }
1798         }
1799         return selfptr;
1800     }
1801 
1802     /*
1803      * @dev Modifies `self` to contain everything from the first occurrence of
1804      *      `needle` to the end of the slice. `self` is set to the empty slice
1805      *      if `needle` is not found.
1806      * @param self The slice to search and modify.
1807      * @param needle The text to search for.
1808      * @return `self`.
1809      */
1810     function find(slice self, slice needle) internal returns (slice) {
1811         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1812         self._len -= ptr - self._ptr;
1813         self._ptr = ptr;
1814         return self;
1815     }
1816 
1817     /*
1818      * @dev Modifies `self` to contain the part of the string from the start of
1819      *      `self` to the end of the first occurrence of `needle`. If `needle`
1820      *      is not found, `self` is set to the empty slice.
1821      * @param self The slice to search and modify.
1822      * @param needle The text to search for.
1823      * @return `self`.
1824      */
1825     function rfind(slice self, slice needle) internal returns (slice) {
1826         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1827         self._len = ptr - self._ptr;
1828         return self;
1829     }
1830 
1831     /*
1832      * @dev Splits the slice, setting `self` to everything after the first
1833      *      occurrence of `needle`, and `token` to everything before it. If
1834      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1835      *      and `token` is set to the entirety of `self`.
1836      * @param self The slice to split.
1837      * @param needle The text to search for in `self`.
1838      * @param token An output parameter to which the first token is written.
1839      * @return `token`.
1840      */
1841     function split(slice self, slice needle, slice token) internal returns (slice) {
1842         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1843         token._ptr = self._ptr;
1844         token._len = ptr - self._ptr;
1845         if (ptr == self._ptr + self._len) {
1846             // Not found
1847             self._len = 0;
1848         } else {
1849             self._len -= token._len + needle._len;
1850             self._ptr = ptr + needle._len;
1851         }
1852         return token;
1853     }
1854 
1855     /*
1856      * @dev Splits the slice, setting `self` to everything after the first
1857      *      occurrence of `needle`, and returning everything before it. If
1858      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1859      *      and the entirety of `self` is returned.
1860      * @param self The slice to split.
1861      * @param needle The text to search for in `self`.
1862      * @return The part of `self` up to the first occurrence of `delim`.
1863      */
1864     function split(slice self, slice needle) internal returns (slice token) {
1865         split(self, needle, token);
1866     }
1867 
1868     /*
1869      * @dev Splits the slice, setting `self` to everything before the last
1870      *      occurrence of `needle`, and `token` to everything after it. If
1871      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1872      *      and `token` is set to the entirety of `self`.
1873      * @param self The slice to split.
1874      * @param needle The text to search for in `self`.
1875      * @param token An output parameter to which the first token is written.
1876      * @return `token`.
1877      */
1878     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1879         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1880         token._ptr = ptr;
1881         token._len = self._len - (ptr - self._ptr);
1882         if (ptr == self._ptr) {
1883             // Not found
1884             self._len = 0;
1885         } else {
1886             self._len -= token._len + needle._len;
1887         }
1888         return token;
1889     }
1890 
1891     /*
1892      * @dev Splits the slice, setting `self` to everything before the last
1893      *      occurrence of `needle`, and returning everything after it. If
1894      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1895      *      and the entirety of `self` is returned.
1896      * @param self The slice to split.
1897      * @param needle The text to search for in `self`.
1898      * @return The part of `self` after the last occurrence of `delim`.
1899      */
1900     function rsplit(slice self, slice needle) internal returns (slice token) {
1901         rsplit(self, needle, token);
1902     }
1903 
1904     /*
1905      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1906      * @param self The slice to search.
1907      * @param needle The text to search for in `self`.
1908      * @return The number of occurrences of `needle` found in `self`.
1909      */
1910     function count(slice self, slice needle) internal returns (uint count) {
1911         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1912         while (ptr <= self._ptr + self._len) {
1913             count++;
1914             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1915         }
1916     }
1917 
1918     /*
1919      * @dev Returns True if `self` contains `needle`.
1920      * @param self The slice to search.
1921      * @param needle The text to search for in `self`.
1922      * @return True if `needle` is found in `self`, false otherwise.
1923      */
1924     function contains(slice self, slice needle) internal returns (bool) {
1925         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1926     }
1927 
1928     /*
1929      * @dev Returns a newly allocated string containing the concatenation of
1930      *      `self` and `other`.
1931      * @param self The first slice to concatenate.
1932      * @param other The second slice to concatenate.
1933      * @return The concatenation of the two strings.
1934      */
1935     function concat(slice self, slice other) internal returns (string) {
1936         var ret = new string(self._len + other._len);
1937         uint retptr;
1938         assembly { retptr := add(ret, 32) }
1939         memcpy(retptr, self._ptr, self._len);
1940         memcpy(retptr + self._len, other._ptr, other._len);
1941         return ret;
1942     }
1943 
1944     /*
1945      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1946      *      newly allocated string.
1947      * @param self The delimiter to use.
1948      * @param parts A list of slices to join.
1949      * @return A newly allocated string containing all the slices in `parts`,
1950      *         joined with `self`.
1951      */
1952     function join(slice self, slice[] parts) internal returns (string) {
1953         if (parts.length == 0)
1954             return "";
1955 
1956         uint len = self._len * (parts.length - 1);
1957         for(uint i = 0; i < parts.length; i++)
1958             len += parts[i]._len;
1959 
1960         var ret = new string(len);
1961         uint retptr;
1962         assembly { retptr := add(ret, 32) }
1963 
1964         for(i = 0; i < parts.length; i++) {
1965             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1966             retptr += parts[i]._len;
1967             if (i < parts.length - 1) {
1968                 memcpy(retptr, self._ptr, self._len);
1969                 retptr += self._len;
1970             }
1971         }
1972 
1973         return ret;
1974     }
1975 }
1976 
1977 
1978 contract DiceChainBase is Ownable {
1979     
1980     /**
1981      * Base contract description
1982      */
1983     
1984     /**
1985      * 
1986      *  
1987      *      ╔═╗╦  ╦╔═╗╔╗╔╦╗╔═╗
1988      *      ║╣ ╚╗╔╝║╣ ║║║║ ╚═╗
1989      *      ╚═╝ ╚╝ ╚═╝╝╚╝╩ ╚═╝
1990      *    
1991      * 
1992      */
1993      
1994     /**
1995      * @dev Fires whenever a DiceChain roll results are received.
1996      */
1997     event RollResults(
1998         address playerAddress,
1999         uint256 rollUnder,
2000         uint256 rollResult,
2001         uint256 serialNumber,
2002         uint256 jackpot,
2003         uint256 gameRound,
2004         bool isGameWon
2005         );
2006         
2007     /**
2008      * @dev Fires whenever a query is sent to Oraclize.
2009      */
2010     event RollQuery(
2011         address playerAddress,
2012         uint256 rollUnder,
2013         uint256 playerBid,
2014         uint256 expectedJackpot,
2015         uint256 gameRound
2016         );
2017     /**
2018      * @dev Fires whenever a progress has been resetted.
2019      */
2020     event ResetProgress(
2021         address playerAddress,
2022         bool isResetted
2023     );
2024         
2025     /**
2026      * @dev Fires whenever a player is refunded.
2027      */
2028     event PlayerRefund(
2029         address playerAddress,
2030         uint256 refundAmount
2031         );
2032     
2033     /**
2034      * @dev Fires whenever ether is manually added to the balance by the CEO.
2035      */
2036     event balanceUpdated(
2037         uint256 amountAdded
2038         );
2039         
2040     /**
2041      *
2042      * 
2043      *      ╦  ╦╔═╗╦═╗╦╔═╗╔╗ ╦  ╔═╗╔═╗
2044      *      ╚╗╔╝╠═╣╠╦╝║╠═╣╠╩╗║  ║╣ ╚═╗
2045      *       ╚╝ ╩ ╩╩╚═╩╩ ╩╚═╝╩═╝╚═╝╚═╝
2046      *
2047      * 
2048      */
2049      
2050     /// Public constants for DiceChain contract.
2051     string public constant NAME = "DiceChain";
2052     
2053     /// The minimum bid amount.
2054     uint256 public minBid = 0.1 ether;
2055     
2056     /// The maximum bid amount.
2057     uint256 public maxBid = 25 ether;
2058     
2059     /// The bid fee amount.
2060     uint256 public bidFee = 0 ether;
2061     
2062     /// The counter for total rolls  won.
2063     uint256 public totalRollsWon = 0;
2064     
2065     /// The counter for total games played.
2066     uint256 public totalGamesPlayed = 0;
2067 
2068     /// The counter for total Ether wagered.
2069     uint256 public totalEtherWagered = 0;
2070     
2071     /// The counter for total Ether  won.
2072     uint256 public totalEtherWon = 0 ether;
2073 
2074     /// @dev The CEO address to transfer the house edge.
2075     address public ceoAddress;
2076     
2077     /// @dev The platform cut (as denumenator in the payout value calculation).
2078     uint256 public platformCut = 99;
2079 
2080     /// @dev The platform cut (as denumenator in the profit calculation)
2081     uint256 public platformCutPayout = 990;
2082 
2083     /// @dev The platform cut divisor
2084     uint256 public platformCutPayoutDivisor = 1000;
2085     
2086     /// @dev Contract activation switch.
2087     bool public activated_ = false;
2088     
2089     /// @dev Sanity check for maximum and minimum roll inputs.
2090     uint256 public minRoll;
2091     uint256 public maxRoll;
2092     
2093     /// @dev Gas for Oraclize.
2094     uint32 public gasForOraclize;
2095     
2096     /// @dev Oraclize random Query ID counter.
2097     uint256 public randomQueryId;
2098     
2099     /// @dev A mapping form a queryId to the player's address.
2100     mapping (bytes32 => address) senderAddresses;
2101     
2102     /// @dev A mapping form a queryId to the roll under.
2103     mapping (bytes32 => uint256) playerRollUnder;
2104     
2105     /// @dev A mapping form a queryId to the player bid.
2106     mapping (bytes32 => uint256) playerQueryToBid;
2107     
2108     /// @dev A mapping from the queryId to the expected jackpot.
2109     mapping (bytes32 => uint256) playerExpectedJackpot;
2110     
2111     /// @dev A mapping from the player address to the pending withdrawal amount.
2112     mapping (address => uint256) playerFundsToWithdraw;
2113     
2114     /// @dev A mapping from the playe address to the player's current progress (game round).
2115     mapping (address => uint256) playerCurrentProgress;
2116     
2117     /// @dev A mapping from the palyer's address to the player's current bid.
2118     mapping (address => uint256) playerAddressToBid;
2119     
2120     /// @dev A mapping from the palyer's address to the player's current roll under number.
2121     mapping (address => uint256) playerAddressToRollUnder;
2122     
2123     
2124     /**
2125      *
2126      * 
2127      *      ╔╦╗╔═╗╔╦╗╦╔═╗╦╔═╗╦═╗╔═╗
2128      *      ║║║║ ║ ║║║╠╣ ║║╣ ╠╦╝╚═╗
2129      *      ╩ ╩╚═╝═╩╝╩╚  ╩╚═╝╩╚═╚═╝
2130      *
2131      * 
2132      */
2133 
2134     /// @dev Access only to the CEO-functionality.
2135     modifier onlyCEO() {
2136         require(msg.sender == ceoAddress, "This action is available only to the current CEO");
2137         _;
2138     }
2139     
2140     /// @dev Checks for contract activation.
2141     modifier isActivated() {
2142         require(activated_ == true, "The contract is inactive");
2143         _;
2144     }
2145     
2146     /// @dev Sanity check for incoming transactions
2147     modifier isWithinLimits(uint256 _eth) {
2148         require(_eth >= 1000000000, "Too little");
2149         require(_eth <= 100000000000000000000000, "Woah! Too much!");
2150         _;    
2151     }
2152     
2153     /// @dev Checks for human interaction
2154     modifier isHuman() {
2155         address _addr = msg.sender;
2156         uint256 _codeLength;
2157         
2158         assembly {_codeLength := extcodesize(_addr)}
2159         require(_codeLength == 0, "This function can be called only by a human");
2160         _;
2161     }
2162 
2163 }
2164 
2165 
2166 contract DiceChainHelper is DiceChainBase {
2167     
2168     using SafeMath for *;
2169     using strings for *;
2170     
2171     /**
2172      *
2173      * 
2174      *      ╦ ╦╔═╗╦  ╔═╗╔═╗╦═╗  ╔═╗╦ ╦╔╗╔╔═╗╔╦╗╦╔═╗╔╗╔╔═╗
2175      *      ╠═╣║╣ ║  ╠═╝║╣ ╠╦╝  ╠╣ ║ ║║║║║   ║ ║║ ║║║║╚═╗
2176      *      ╩ ╩╚═╝╩═╝╩  ╚═╝╩╚═  ╚  ╚═╝╝╚╝╚═╝ ╩ ╩╚═╝╝╚╝╚═╝
2177      *
2178      * 
2179      */
2180     
2181     /**
2182      * @dev Activates the contract.
2183      */
2184     function activate() 
2185         external 
2186         onlyCEO {
2187             
2188             require(msg.sender != address(0));
2189         
2190             activated_ = !activated_;
2191         }
2192     
2193     /**
2194      * @dev Deactivates the contract.
2195      */    
2196     function deactivate() 
2197         external 
2198         onlyCEO {
2199             
2200             require(msg.sender != address(0));
2201         
2202             activated_ = false;
2203         }
2204     
2205     /**
2206      * @dev Sets the new CEO address. Only available to the current CFO. 
2207      */
2208     function setCEO(address _newCEO) 
2209         external 
2210         onlyCEO 
2211         isHuman {
2212             
2213             require(_newCEO != address(0));
2214 
2215             ceoAddress = _newCEO;
2216         }
2217     
2218     /**
2219      * @dev Sets the Bid fee. Only available to the 
2220      * current CEO. 
2221      */
2222     function setNewBidFee(uint256 _newBidFee) 
2223         external 
2224         onlyCEO 
2225         isHuman 
2226         isWithinLimits(_newBidFee) {
2227             
2228             bidFee = _newBidFee;
2229         }
2230     
2231     /**
2232      * @dev Sets the platform cut denumenator percentage. 
2233      * Only available to the current CEO. 
2234      */
2235     function setPlatformCut(uint256 _newPlatformCut)
2236         external
2237         onlyCEO
2238         isHuman {
2239             
2240             platformCut = _newPlatformCut;
2241             
2242         }
2243 
2244     /**
2245      * @dev Sets the platform cut payout denumenator percentage. 
2246      * Only available to the current CEO. 
2247      */
2248     function setPlatformCutPayout(uint256 _newPlatformCutPayout)
2249         external
2250         onlyCEO
2251         isHuman {
2252             
2253             platformCutPayout = _newPlatformCutPayout;
2254             
2255         }
2256         
2257     /**
2258      * @dev Sets the gas limit for Oraclize Query.
2259      */
2260     function setGasForOraclize(uint32 _newGasLimit)
2261         external
2262         onlyCEO
2263         isHuman {
2264             
2265             gasForOraclize = _newGasLimit;
2266             
2267         }
2268     
2269     /**
2270      * @dev Updates the contract balance. Only available to the current CEO. 
2271      */
2272     function updateBalance()
2273         public
2274         payable
2275         onlyCEO
2276         isWithinLimits(msg.value) {
2277         
2278             emit balanceUpdated(msg.value);
2279         
2280         }
2281 
2282     /**
2283      * @dev Returns the balance.
2284      */
2285     function getBalance()
2286         public
2287         view
2288         returns (uint256) {
2289 
2290             return address(this).balance;
2291 
2292         }
2293     
2294     /**
2295      * @dev Player manually withdraws funds if there was a transaction error.
2296      */
2297     function withdrawPendingTransactions() 
2298         public 
2299         isHuman
2300         isActivated
2301         returns (bool) {
2302             
2303             uint256 amount = playerFundsToWithdraw[msg.sender];
2304             
2305             playerFundsToWithdraw[msg.sender] = 0;
2306         
2307             if (msg.sender.call.value(amount)()) {
2308                 
2309                 return true;
2310                 
2311             } else {
2312             
2313                 // Can try to refund later if goes wrong.
2314                 playerFundsToWithdraw[msg.sender] = amount;
2315             
2316                 return false;
2317             }
2318         }
2319     
2320     /**
2321      * @dev Checks for the pending withdrawals.
2322      */
2323 
2324     function getPendingTransactions(address playerAddress) 
2325         public 
2326         constant
2327         returns (uint256) {
2328             
2329             return playerFundsToWithdraw[playerAddress];
2330             
2331         }
2332     
2333     /**
2334      * @dev Resets the player's current progress.
2335      */
2336     function resetProgress()
2337         public
2338         returns (bool) {
2339             
2340             if (playerCurrentProgress[msg.sender] > 0) {
2341                 
2342                 playerCurrentProgress[msg.sender] = 0;
2343                 
2344                 playerAddressToBid[msg.sender] = 0;
2345                 
2346                 playerAddressToRollUnder[msg.sender] = 0;
2347 
2348                 emit ResetProgress(
2349                     msg.sender, 
2350                     true
2351                 );
2352 
2353                 return true;
2354                
2355             } else {
2356                 
2357                 return false;
2358             }
2359             
2360         }
2361         
2362     /**
2363      * @dev Resets the player's current progress internally.
2364     */
2365     function _resetProgress(address playerAddress)
2366         internal
2367         returns (uint256) {
2368             
2369             playerCurrentProgress[playerAddress] = 0;
2370             
2371             playerAddressToBid[playerAddress] = 0;
2372             
2373             playerAddressToRollUnder[playerAddress] = 0;
2374             
2375             return playerCurrentProgress[playerAddress];
2376             
2377         }
2378         
2379     
2380     /**
2381      * @dev Calculates the payout based on roll under in Wei.
2382      */
2383     function _calculatePayout(
2384         uint256 rollUnder,
2385         uint256 value)
2386         internal
2387         view
2388         isWithinLimits(value)
2389         returns (uint256) {
2390             
2391             require(rollUnder >= minRoll && rollUnder <= maxRoll, "invalid roll under number!");
2392             
2393             uint256 _totalPayout = 0 wei;
2394             
2395             _totalPayout = ((((value * (100-(SafeMath.sub(rollUnder,1)))) / (SafeMath.sub(rollUnder,1))+value))*platformCutPayout/platformCutPayoutDivisor)-value;
2396             
2397             return _totalPayout;
2398         }
2399 
2400     /**
2401      * @dev Gets player's progress.
2402      */
2403     function getPlayerProgress()
2404     public
2405     view
2406     returns(uint256, uint256, uint256) {
2407         
2408         return (playerCurrentProgress[msg.sender], 
2409                 playerAddressToBid[msg.sender], 
2410                 playerAddressToRollUnder[msg.sender]);
2411 
2412     }
2413         
2414 }
2415 
2416 
2417 contract DiceChainCore is DiceChainHelper, usingOraclize {
2418     
2419     /// @dev checks only Oraclize address is calling
2420     modifier onlyOraclize {
2421         require(msg.sender == oraclize_cbAddress());
2422         _;
2423     }
2424     
2425     /**
2426      * @dev Initiates the DiceChain roll.
2427      */
2428     function rollDice(
2429         uint256 rollUnder
2430         )
2431         public
2432         payable
2433         isHuman
2434         isActivated
2435         isWithinLimits (msg.value) {
2436             
2437             uint256 playerBid = SafeMath.sub(msg.value, bidFee);
2438             
2439             playerAddressToBid[msg.sender] = playerBid;
2440             
2441             playerAddressToRollUnder[msg.sender] = rollUnder;
2442             
2443             uint256 _profit = _calculatePayout(rollUnder, playerBid);
2444             
2445             uint256 _totalPayout = SafeMath.add(playerBid, _profit);
2446             
2447             require(address(this).balance > _totalPayout, "Rolling back, Insufficient funds!");
2448             
2449             require(rollUnder >= minRoll && rollUnder <= maxRoll, "The roll under value is invalid!");
2450             
2451             randomQueryId += 1;
2452             
2453             // Compose the Oraclize query
2454             string memory queryStringOne = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BMpnOiuRP+aVYNno0xjguEnZ2A6x7xWoF10eDVKoGsKmbA07R50/XCWZfTG9yENk9q9NGJi17N+48Sp3ooFWvSNwwPveieaYf/wEJFdvnJv8KaSW0kKK3m8mVtJL84Mmt5zCKuhYKGqiIpbYmLdjSQ8JJDoY}\",\"n\":1,\"min\":1,\"max\":100,\"replacement\":false,\"base\":10${[identity] \"}\"},\"id\":";
2455             
2456             string memory queryStringTwo = uint2str(randomQueryId);
2457             string memory queryStringThree = "${[identity] \"}\"}']";
2458             
2459             string memory queryStringOne_Two = queryStringOne.toSlice().concat(queryStringTwo.toSlice());
2460             string memory queryStringOne_Two_Three = queryStringOne_Two.toSlice().concat(queryStringThree.toSlice());
2461             
2462             bytes32 queryId = oraclize_query("nested", queryStringOne_Two_Three, gasForOraclize);
2463             
2464             senderAddresses[queryId] = msg.sender;
2465             
2466             playerRollUnder[queryId] = rollUnder;
2467             
2468             playerFundsToWithdraw[msg.sender] = playerBid;
2469             
2470             if (playerCurrentProgress[msg.sender] <= 11) {
2471                 
2472                 playerCurrentProgress[msg.sender]++;
2473                 
2474                 if (playerCurrentProgress[msg.sender] == 3) {
2475                     
2476                     _totalPayout *= 2;
2477                     
2478                 } else if (playerCurrentProgress[msg.sender] == 6) {
2479                     
2480                     _totalPayout *= 3;
2481                     
2482                 } else if (playerCurrentProgress[msg.sender] == 11) {
2483                     
2484                     _totalPayout *= 5;
2485                     
2486                     playerCurrentProgress[msg.sender] = 0;
2487                     
2488                 }
2489                 
2490             } else if (playerCurrentProgress[msg.sender] > 11) {
2491                 
2492                 return;
2493                 
2494             }
2495             
2496             playerExpectedJackpot[queryId] = _totalPayout;
2497             
2498             playerQueryToBid[queryId] = playerBid;
2499 
2500             totalGamesPlayed ++;
2501 
2502             totalEtherWagered += playerBid;
2503             
2504             ceoAddress.transfer(bidFee);
2505             
2506             emit RollQuery(
2507                 msg.sender,
2508                 rollUnder,
2509                 playerBid,
2510                 _totalPayout,
2511                 playerCurrentProgress[msg.sender]
2512             );
2513                 
2514         }
2515     
2516 }
2517 
2518 
2519 contract DiceResult is DiceChainCore {
2520     
2521     function _rollResult(
2522         address playerAddress,
2523         string result,
2524         uint256 rollUnder,
2525         uint256 playerBid,
2526         uint256 expectedJackpot,
2527         uint256 gameRound
2528         ) internal {
2529         
2530             // Sanity check
2531             require(rollUnder != 0, "Invalid game, refunded!");
2532             
2533             if (expectedJackpot >= address(this).balance ||
2534                 bytes(result).length == 0) {
2535                 
2536                 if (!playerAddress.send(playerBid)) {
2537                 
2538                     playerFundsToWithdraw[playerAddress] = playerBid;                     
2539                 }
2540             
2541                 emit PlayerRefund(
2542                     playerAddress,
2543                     playerBid  
2544                 );
2545                     
2546             playerAddress = 0x0;
2547             playerBid = 0;
2548                     
2549             return;
2550                 
2551             }
2552                 
2553             strings.slice memory res = result.toSlice();
2554                 
2555             strings.slice memory delim = " ".toSlice();
2556                 
2557             uint256[] memory parts = new uint256[](res.count(delim) + 1);
2558                 
2559             for (uint256 i = 0; i < parts.length; i ++) {
2560                 parts[i] = parseInt(res.split(delim).toString());
2561             }
2562             
2563             if (parts[1] <= rollUnder) {
2564                 
2565                 totalGamesPlayed ++;
2566                 totalRollsWon ++;
2567                         
2568                 // Calculating the eligible payout
2569                 uint256 eligiblePayout = SafeMath.div(SafeMath.mul(expectedJackpot, platformCut), 100);
2570                 uint256 platformCutPayout = SafeMath.sub(expectedJackpot, eligiblePayout);
2571                     
2572                 playerAddress.transfer(eligiblePayout);
2573                 
2574                 totalEtherWon += eligiblePayout;
2575                     
2576                 ceoAddress.transfer(platformCutPayout);           
2577                 
2578                 emit RollResults(
2579                     playerAddress,
2580                     rollUnder,
2581                     parts[1],
2582                     parts[0],
2583                     eligiblePayout,
2584                     gameRound,
2585                     true
2586                 );
2587                 
2588                 //rollUnder = 0;
2589                 
2590                 expectedJackpot = 0;
2591                 
2592                 //playerBid = 0;
2593                 
2594             } else if (parts[1] >= rollUnder) {
2595 
2596                 uint256 resetProgress = _resetProgress(playerAddress);
2597                 
2598                 emit RollResults(
2599                     playerAddress,
2600                     rollUnder,
2601                     parts[1],
2602                     parts[0],
2603                     eligiblePayout,
2604                     resetProgress,
2605                     false
2606                 );
2607                 
2608                 //rollUnder = 0;
2609                 
2610                 expectedJackpot = 0;
2611                 
2612                 //playerBid = 0;
2613                 
2614             }
2615 
2616         }
2617     
2618 }
2619 
2620 
2621 contract DiceChain is DiceResult {
2622     
2623     /**
2624      * 
2625      *    _______ _            ____  _            _    _____  _                               * 
2626      *   |__   __| |          |  _ \| |          | |  |  __ \| |                           
2627      *      | |  | |__   ___  | |_) | | ___   ___| | _| |__) | | __ _ _   _     
2628      *      | |  | '_ \ / _ \ |  _ <| |/ _ \ / __| |/ /  ___/| |/ _` | | | |    
2629      *      | |  | | | |  __/ | |_) | | (_) | (__|   <| |    | | (_| | |_| |    
2630      *      |_|  |_| |_|\___| |____/|_|\___/ \___|_|\_\_|    |_|\__,_|\__, |    
2631      *                                                                 __/ |                  *        
2632      *                                                                |___/                   *        
2633      *                      
2634      *                                ╔═╗╦═╗╔═╗╦ ╦╔╦╗╦ ╦ ╦   
2635      *                                ╠═╝╠╦╝║ ║║ ║ ║║║ ╚╦╝   
2636      *                                ╩  ╩╚═╚═╝╚═╝═╩╝╩═╝╩    
2637      *                              ╔═╗╦═╗╔═╗╔═╗╔═╗╔╗╔╦╗╔═╗
2638      *                              ╠═╝╠╦╝║╣ ╚═╗║╣ ║║║║ ╚═╗
2639      *                              ╩  ╩╚═╚═╝╚═╝╚═╝╝╚╝╩ ╚═╝
2640      * 
2641      *
2642      * 
2643      *  
2644      *  
2645      *  ██████╗ ██╗ ██████╗███████╗ ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗
2646      *  ██╔══██╗██║██╔════╝██╔════╝██╔════╝██║  ██║██╔══██╗██║████╗  ██║
2647      *  ██║  ██║██║██║     █████╗  ██║     ███████║███████║██║██╔██╗ ██║
2648      *  ██║  ██║██║██║     ██╔══╝  ██║     ██╔══██║██╔══██║██║██║╚██╗██║
2649      *  ██████╔╝██║╚██████╗███████╗╚██████╗██║  ██║██║  ██║██║██║ ╚████║
2650      *  ╚═════╝ ╚═╝ ╚═════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
2651      *                                                        
2652      *
2653      *                                                                              
2654      *
2655      * 
2656      * 
2657      * Dicechain is an Ethereum-based provably fair roll game where players
2658      * need to roll under a number to win Ether. The game features the chain of
2659      * progress which multiplies the payout by 2, 3, or 5 times based on the
2660      * player's progress. 
2661      * 
2662      * The smart contract uses Oraclize and random.org to generate random roll
2663      * numbers. 
2664      * 
2665      * 
2666      * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2667      * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2668      * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
2669      * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2670      * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2671      * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
2672      * THE SOFTWARE.
2673      * 
2674      * 
2675      * 
2676      */
2677      
2678     /**
2679      * 
2680      *
2681      *      ╔═╗╔═╗╔╗╔╔═╗╔╦╗╦═╗╦ ╦╔═╗╔╦╗╔═╗╦═╗
2682      *      ║  ║ ║║║║╚═╗ ║ ╠╦╝║ ║║   ║ ║ ║╠╦╝
2683      *      ╚═╝╚═╝╝╚╝╚═╝ ╩ ╩╚═╚═╝╚═╝ ╩ ╚═╝╩╚═
2684      *
2685      * 
2686      */
2687      
2688     constructor() public {
2689         
2690         /// Activating the contract.
2691         activated_ = true;
2692         
2693         /// Setting the initial address of the CEO.
2694         ceoAddress = msg.sender;
2695         
2696         /// Setting the gas amount for Oraclize.
2697         gasForOraclize = 180000;
2698         
2699         /// Setting the initial value for the randomQueryId
2700         randomQueryId = 555;
2701         
2702         /// Sets the min and max numbers.
2703         minRoll = 2;
2704         maxRoll = 96;
2705         
2706     }
2707     
2708     /**
2709      * @dev The Oraclize callback function.
2710      */
2711     
2712     function __callback(
2713         bytes32 myid,
2714         string result
2715         ) 
2716         public   
2717 		onlyOraclize
2718 		isActivated {
2719 
2720             require(senderAddresses[myid] != address(0), "Wrong player address!");
2721             
2722             _rollResult(
2723                 senderAddresses[myid],
2724                 result,
2725                 playerRollUnder[myid],
2726                 playerQueryToBid[myid],
2727                 playerExpectedJackpot[myid],
2728                 playerCurrentProgress[senderAddresses[myid]]
2729             );
2730         
2731         }
2732     
2733 }