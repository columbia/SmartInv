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
1977 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
1978 
1979 contract PowerEtherBase is Ownable {
1980     
1981     /**
1982      * 
1983      *  
1984      *      ╔═╗╦  ╦╔═╗╔╗╔╦╗╔═╗
1985      *      ║╣ ╚╗╔╝║╣ ║║║║ ╚═╗
1986      *      ╚═╝ ╚╝ ╚═╝╝╚╝╩ ╚═╝
1987      *    
1988      * 
1989      */
1990     
1991     /**
1992      * @dev Fired whenever a PowerEther game is won or lost.
1993      */
1994     event PowerEtherResults(
1995         address playerAddress,
1996         uint256 resultSerialNumber,
1997         uint256 gameType,           // 1 - PowerOne, 2 - PowerTwo, 4 - PowerFour
1998         uint256 powerNumberOne,
1999         uint256 powerNumberTwo,
2000         uint256 powerNumberThree,
2001         uint256 powerNumberFour,
2002         uint256 jackpot,
2003         bool isGameWon,
2004         bool isMegaJackpotWon
2005         );
2006     
2007     /**
2008      * @dev Fired, whenever a MegaJackpot is won via reached cap.
2009      */
2010     event MegaJackpotCapWin(
2011         address playerAddress,
2012         uint256 megaJackpot
2013         );
2014     
2015     /**
2016      * @dev Fired, whenever a refund is initiated.
2017      */
2018     event Refund(
2019         address playerAddress,
2020         uint256 gameType
2021         );
2022     
2023     /**
2024      * @dev Fired to log the Oraclize query.
2025      */
2026     event LogQuery(
2027         address playerAddress,  
2028         uint256 gameType,           // 1 - PowerOne, 2 - PowerTwo, 4 - PowerFour
2029         uint256 randomQueryId,
2030         uint256 powerNumberOne,
2031         uint256 powerNumberTwo,
2032         uint256 powerNumberThree,
2033         uint256 powerNumberFour
2034         );
2035         
2036     /**
2037      * @dev Fired whenever ether is manually added to the balance by the CEO.
2038      */
2039     event balanceUpdated(
2040         uint256 _amount
2041         );
2042         
2043     /**
2044      *
2045      * 
2046      *      ╦  ╦╔═╗╦═╗╦╔═╗╔╗ ╦  ╔═╗╔═╗
2047      *      ╚╗╔╝╠═╣╠╦╝║╠═╣╠╩╗║  ║╣ ╚═╗
2048      *       ╚╝ ╩ ╩╩╚═╩╩ ╩╚═╝╩═╝╚═╝╚═╝
2049      *
2050      * 
2051      */
2052     
2053     /// Public constants for PromiseCoin contract.
2054     string public constant NAME = "PowerEther";
2055     
2056     /// The bid amount for PowerOne game.
2057     uint256 public powerOneBid = 0.03 ether;
2058     
2059     /// The fee amount for PowerOne game.
2060     uint256 public powerOneFee = 0.01 ether;
2061     
2062     /// The bid amount for PowerTwo game.
2063     uint256 public powerTwoBid = 0.02 ether;
2064     
2065     /// The fee amount for PowerTwo game.
2066     uint256 public powerTwoFee = 0.01 ether;
2067     
2068     /// The bid amount for PowerFour game.
2069     uint256 public powerFourBid = 0.01 ether;
2070     
2071     /// The fee amount for PowerTwo game.
2072     uint256 public powerFourFee = 0.01 ether;
2073     
2074     /// The jackpot of PowerOne game.
2075     uint256 public powerOneJackpot = 0 ether;
2076     
2077     /// The jackpot of PowerTwo game.
2078     uint256 public powerTwoJackpot = 0 ether;
2079     
2080     /// The jackpot of PowerFour game.
2081     uint256 public powerFourJackpot = 0 ether;
2082     
2083     /// The MegaJackpot that is won whenever a PowerFour game has been won.
2084     uint256 public megaJackpot = 0 ether;
2085     
2086     /// The MegaJackpot that is won whenever a PowerFour game has been won.
2087     uint256 public megaJackpotFee = 0.01 ether;
2088     
2089     /**
2090      * @dev Sets the hard cap of the MegaJackpot. Once reached, the MegaJackpot
2091      * is split among the last 1000 players.
2092      */
2093     uint256 public megaJackpotCap = 100 ether;
2094     
2095     /// Counts MegaJacpot wins.
2096     uint256 public megaJackpotWinCount = 0;
2097     
2098     /// The counter for PowerOne game.
2099     uint256 public powerOneWinCounter = 0;
2100     
2101     /// The counter for PowerTwo game.
2102     uint256 public powerTwoWinCounter = 0;
2103     
2104     /// The counter for PowerFour game.
2105     uint256 public powerFourWinCounter = 0;
2106 
2107     /// @dev The CEO address to transfer the cut.
2108     address public ceoAddress;
2109     
2110     /// @dev The platform cut (as denumenator in the calculation equation).
2111     uint256 public platformCut = 95;
2112     
2113     /// @dev Counts uncollected fees for PowerOne.
2114     uint256 public powerOneFeesToCollect;
2115     
2116     /// @dev Counts uncollected fees for PowerTwo.
2117     uint256 public powerTwoFeesToCollect;
2118     
2119     /// @dev Counts uncollected fees for PowerFour.
2120     uint256 public powerFourFeesToCollect;
2121     
2122     /// @dev Contract activation switch.
2123     bool public activated_ = false;
2124     
2125     /// @dev Sanity check for maximum and minimum inputs.
2126     uint256 public minNumber;
2127     uint256 public maxNumber;
2128     
2129     /// @dev Gas for Oraclize.
2130     uint32 public gasForOraclize;
2131     
2132     /// @dev Oraclize random Query ID counter.
2133     uint256 public randomQueryId;
2134 
2135     /// @dev Stats - total Ether won.
2136     uint256 public totalEtherWon;
2137 
2138     /// @dev Stats - total games played.
2139     uint256 public totalGamesPlayed;
2140     
2141     /// @dev A mapping form a queryId to the player's address.
2142     mapping (bytes32 => address) senderAddresses;
2143     
2144     /// @dev A mapping form a queryId to the game type.
2145     mapping (bytes32 => uint256) gameTypes;
2146     
2147     /// @dev A mapping form a queryId to the first Power Number.
2148     mapping (bytes32 => uint256) powerNumberOne;
2149     
2150     /// @dev A mapping form a queryId to the second Power Number.
2151     mapping (bytes32 => uint256) powerNumberTwo;
2152     
2153     /// @dev A mapping form a queryId to the third Power Number.
2154     mapping (bytes32 => uint256) powerNumberThree;
2155     
2156     /// @dev A mapping form a queryId to the fourth Power Number.
2157     mapping (bytes32 => uint256) powerNumberFour;
2158     
2159     /// @dev A mapping from the player address to the pending withdrawal amount.
2160     mapping (address => uint256) playerFundsToWithdraw;
2161     
2162     /**
2163      *
2164      * 
2165      *      ╔╦╗╔═╗╔╦╗╦╔═╗╦╔═╗╦═╗╔═╗
2166      *      ║║║║ ║ ║║║╠╣ ║║╣ ╠╦╝╚═╗
2167      *      ╩ ╩╚═╝═╩╝╩╚  ╩╚═╝╩╚═╚═╝
2168      *
2169      * 
2170      */
2171 
2172     /// @dev Access only to the CEO-functionality.
2173     modifier onlyCEO() {
2174         require(msg.sender == ceoAddress, "This action is available only to the current CEO");
2175         _;
2176     }
2177     
2178     /// @dev Checks for contract activation.
2179     modifier isActivated() {
2180         require(activated_ == true, "The contract is inactive");
2181         _;
2182     }
2183     
2184     /// @dev Sanity check for incoming transactions
2185     modifier isWithinLimits(uint256 _eth) {
2186         require(_eth >= 1000000000, "Too little");
2187         require(_eth <= 100000000000000000000000, "Woah! Too much!");
2188         _;    
2189     }
2190     
2191     /// @dev Checks for human interaction
2192     modifier isHuman() {
2193         address _addr = msg.sender;
2194         uint256 _codeLength;
2195         
2196         assembly {_codeLength := extcodesize(_addr)}
2197         require(_codeLength == 0, "This contract can interact only with humans");
2198         _;
2199     }
2200     
2201 }
2202 
2203 contract PowerEtherHelper is PowerEtherBase {
2204     
2205     using SafeMath for *;
2206     using strings for *;
2207     
2208     /**
2209      *
2210      * 
2211      *      ╦ ╦╔═╗╦  ╔═╗╔═╗╦═╗  ╔═╗╦ ╦╔╗╔╔═╗╔╦╗╦╔═╗╔╗╔╔═╗
2212      *      ╠═╣║╣ ║  ╠═╝║╣ ╠╦╝  ╠╣ ║ ║║║║║   ║ ║║ ║║║║╚═╗
2213      *      ╩ ╩╚═╝╩═╝╩  ╚═╝╩╚═  ╚  ╚═╝╝╚╝╚═╝ ╩ ╩╚═╝╝╚╝╚═╝
2214      *
2215      * 
2216      */
2217     
2218     /**
2219      * @dev Activates the contract.
2220      */
2221     function activate() 
2222         external 
2223         onlyCEO {
2224             
2225             require(msg.sender != address(0));
2226         
2227             activated_ = !activated_;
2228         }
2229     
2230     /**
2231      * @dev Deactivates the contract.
2232      */    
2233     function deactivate() 
2234         external 
2235         onlyCEO {
2236             
2237             require(msg.sender != address(0));
2238         
2239             activated_ = false;
2240         }
2241     
2242     /**
2243      * @dev Sets the new CEO address. Only available to the current CFO. 
2244      */
2245     function setCEO(address _newCEO) 
2246         external 
2247         onlyCEO 
2248         isHuman {
2249             
2250             require(_newCEO != address(0));
2251 
2252             ceoAddress = _newCEO;
2253         }
2254     
2255     /**
2256      * @dev Sets the Bid price for the PowerOne game. Only available to the 
2257      * current CEO. 
2258      */
2259     function setPowerOneBidPrice(uint256 _newBid) 
2260         external 
2261         onlyCEO 
2262         isHuman 
2263         isWithinLimits(_newBid) {
2264             
2265             powerOneBid = _newBid;
2266         }
2267     
2268     /**
2269      * @dev Sets the Fee price for the PowerOne game. Only available to the
2270      * current CEO. 
2271      */
2272     function setPowerOneFeePrice(uint256 _newFee) 
2273         external 
2274         onlyCEO 
2275         isHuman 
2276         isWithinLimits(_newFee) {
2277             
2278             powerOneFee = _newFee;
2279         }
2280     
2281     /**
2282      * @dev Sets the Bid price for the PowerTwo game. Only available to the 
2283      * current CEO. 
2284      */
2285     function setPowerTwoBidPrice(uint256 _newBid) 
2286         external 
2287         onlyCEO 
2288         isHuman 
2289         isWithinLimits(_newBid) {
2290             
2291             powerTwoBid = _newBid;
2292         }
2293     
2294     /**
2295      * @dev Sets the Fee price for the PowerTwo game. Only available to the
2296      * current CEO. 
2297      */
2298     function setPowerTwoFeePrice(uint256 _newFee) 
2299         external 
2300         onlyCEO 
2301         isHuman 
2302         isWithinLimits(_newFee) {
2303             
2304             powerTwoFee = _newFee;
2305         }
2306     
2307     /**
2308      * @dev Sets the Bid price for the PowerFour game. Only available to the 
2309      * current CEO. 
2310      */
2311     function setPowerFourBidPrice(uint256 _newBid) 
2312         external 
2313         onlyCEO 
2314         isHuman 
2315         isWithinLimits(_newBid) {
2316             
2317             powerFourBid = _newBid;
2318         }
2319     
2320     /**
2321      * @dev Sets the Fee price for the PowerFour game. Only available to the
2322      * current CEO. 
2323      */
2324     function setPowerFourFeePrice(uint256 _newFee) 
2325         external 
2326         onlyCEO 
2327         isHuman 
2328         isWithinLimits(_newFee) {
2329             
2330             powerFourFee = _newFee;
2331         }
2332     
2333     /**
2334      * @dev Sets the platform cut denumenator percentage. 
2335      * Only available to the current CEO. 
2336      */
2337     function setPlatformCut(uint256 _newPlatformCut)
2338         external
2339         onlyCEO
2340         isHuman {
2341             
2342             platformCut = _newPlatformCut;
2343             
2344         }
2345     
2346     /**
2347      * @dev Sets the new limit for the megaJackpotCap. Only available to the
2348      * current CEO.
2349      */
2350     function setMegaJackpotCap(uint256 _newCap)
2351         external
2352         onlyCEO
2353         isHuman {
2354             
2355             megaJackpotCap = _newCap;
2356             
2357         }
2358         
2359     /**
2360      * @dev Sets the new MegaJackpot fee.
2361      */
2362     function setMegaJackpotFee(uint256 _newMegaJackpotFee)
2363         external
2364         onlyCEO
2365         isHuman {
2366             
2367             megaJackpotFee = _newMegaJackpotFee;
2368             
2369         }
2370         
2371     /**
2372      * @dev Sets the gas limit for Oraclize Query.
2373      */
2374     function setGasForOraclize(uint32 _newGasLimit)
2375         external
2376         onlyCEO
2377         isHuman {
2378             
2379             gasForOraclize = _newGasLimit;
2380             
2381         }
2382         
2383     /**
2384      * @dev Sets the new minNumber.
2385      */
2386     function setMinNumber(uint256 _newMinNumber)
2387         external
2388         onlyCEO
2389         isHuman {
2390             
2391             minNumber = _newMinNumber;
2392             
2393         }
2394     
2395     /**
2396      * @dev Sets the new maxNumber.
2397      */
2398     function setMaxNumber(uint256 _newMaxNumber)
2399         external
2400         onlyCEO
2401         isHuman {
2402             
2403             maxNumber = _newMaxNumber;
2404             
2405         }
2406     
2407     /**
2408      * @dev Internal function to check the PowerNumbers of PowerTwo Game.
2409      */
2410     function _checkTwo(
2411         uint256 _resultNumberOne,
2412         uint256 _resultNumberTwo,
2413         uint256 _powerNumberOne,
2414         uint256 _powerNumberTwo
2415         ) 
2416         internal 
2417         returns (bool) {
2418             if ((_resultNumberOne == _powerNumberOne ||
2419                 _resultNumberOne == _powerNumberTwo) &&
2420                 (_resultNumberTwo == _powerNumberOne ||
2421                 _resultNumberTwo == _powerNumberTwo)
2422                 ) {
2423                     return (true);
2424                 } else {
2425                     return (false);
2426                 }
2427         }
2428     
2429     /**
2430      * @dev Internal function to check the PowerNumbers of PowerFour Game.
2431      */
2432     function _checkFour(
2433         uint256 _resultNumberOne,
2434         uint256 _resultNumberTwo,
2435         uint256 _resultNumberThree,
2436         uint256 _resultNumberFour,
2437         uint256 _powerNumberOne,
2438         uint256 _powerNumberTwo,
2439         uint256 _powerNumberThree,
2440         uint256 _powerNumberFour
2441         )
2442         internal
2443         returns (bool) {
2444             if ((_resultNumberOne == _powerNumberOne ||
2445                 _resultNumberOne == _powerNumberTwo ||
2446                 _resultNumberOne == _powerNumberThree ||
2447                 _resultNumberOne == _powerNumberFour) &&
2448                 (_resultNumberTwo == _powerNumberOne ||
2449                 _resultNumberTwo == _powerNumberTwo ||
2450                 _resultNumberTwo == _powerNumberThree ||
2451                 _resultNumberTwo == _powerNumberFour) &&
2452                 (_resultNumberThree == _powerNumberOne ||
2453                 _resultNumberThree == _powerNumberTwo ||
2454                 _resultNumberThree == _powerNumberThree ||
2455                 _resultNumberThree == _powerNumberFour) &&
2456                 (_resultNumberFour == _powerNumberOne ||
2457                 _resultNumberFour == _powerNumberTwo ||
2458                 _resultNumberFour == _powerNumberThree ||
2459                 _resultNumberFour == _powerNumberFour)) {
2460                     return true;
2461                 } else {
2462                     return false;
2463                 }
2464         }
2465         
2466     /**
2467      * @dev Collects the fees for transactions. Only available to the current
2468      * CEO.
2469      */
2470     function collectFees()
2471         external
2472         onlyCEO
2473         isHuman {
2474             
2475             uint256 powerOnePayouts = SafeMath.mul(powerOneFee, powerOneFeesToCollect);
2476             uint256 powerTwoPayouts = SafeMath.mul(powerTwoFee, powerTwoFeesToCollect);
2477             uint256 powerFourPayouts = SafeMath.mul(powerFourFee, powerFourFeesToCollect);
2478             
2479             uint256 totalOneTwo = SafeMath.add(powerOnePayouts, powerTwoPayouts);
2480             uint256 totalAll = SafeMath.add(totalOneTwo, powerFourPayouts);
2481             
2482             require(totalAll <= address(this).balance, "Insufficient funds!");
2483             
2484             ceoAddress.transfer(totalAll);
2485             
2486             // reset the counters
2487             powerOneFeesToCollect = 0;
2488             powerTwoFeesToCollect = 0;
2489             powerFourFeesToCollect = 0;
2490             
2491         }
2492     
2493     /**
2494      * @dev Checks whether the MegaJackpotCap has been reached. If so,
2495      * transfers the MegaJackpot to the current player.
2496      */
2497     function _checkMegaJackpotCap(address playerAddress) 
2498         internal
2499         returns (bool) {
2500             
2501         // Checking for the MegaJackpotCap.
2502         if (megaJackpot >= megaJackpotCap) {
2503                     
2504         require(megaJackpot <= address(this).balance, "Insufficient funds!");
2505                     
2506         uint256 megaJackpotPayout = SafeMath.div(SafeMath.mul(megaJackpot, platformCut), 100);
2507         uint256 platformMegaCutPayout = SafeMath.sub(megaJackpot, megaJackpotPayout);
2508                         
2509         emit MegaJackpotCapWin(
2510             playerAddress,
2511             megaJackpotPayout
2512         );
2513                     
2514         playerAddress.transfer(megaJackpotPayout);
2515         ceoAddress.transfer(platformMegaCutPayout);
2516                     
2517         megaJackpot = 0;
2518         megaJackpotWinCount ++;
2519 
2520         totalEtherWon += megaJackpotPayout;
2521 
2522         return true;
2523                     
2524         }
2525         return false;
2526     }
2527     
2528     /**
2529      * @dev Updates the contract balance. Only available to the current CEO. 
2530      */
2531     function updateBalance(uint256 etherToAdd)
2532         public
2533         payable
2534         onlyCEO {
2535         
2536             emit balanceUpdated(etherToAdd);
2537         
2538         }
2539     
2540     /**
2541      * @dev Updates the PowerOne balance. Only available to the current CEO. 
2542      */
2543     function updatePowerOneBalance(uint256 etherToAdd)
2544         public
2545         payable
2546         onlyCEO {
2547             
2548             powerOneJackpot += etherToAdd;
2549             emit balanceUpdated(etherToAdd);
2550         
2551         }
2552     
2553     /**
2554      * @dev Updates the PowerTwo balance. Only available to the current CEO. 
2555      */
2556     function updatePowerTwoBalance(uint256 etherToAdd)
2557         public
2558         payable
2559         onlyCEO {
2560             
2561             powerTwoJackpot += etherToAdd;
2562             emit balanceUpdated(etherToAdd);
2563         
2564         }
2565     
2566     /**
2567      * @dev Updates the PowerFour balance. Only available to the current CEO. 
2568      */
2569     function updatePowerFourBalance(uint256 etherToAdd)
2570         public
2571         payable
2572         onlyCEO {
2573             
2574             powerFourJackpot += etherToAdd;
2575             emit balanceUpdated(etherToAdd);
2576         
2577         }
2578     
2579     /**
2580      * @dev Player manually withdraws funds if there was a transaction error.
2581      */
2582     function withdrawPendingTransactions() 
2583         public 
2584         isHuman
2585         isActivated
2586         returns (bool) {
2587             
2588             uint256 amount = playerFundsToWithdraw[msg.sender];
2589             
2590             playerFundsToWithdraw[msg.sender] = 0;
2591         
2592             if (msg.sender.call.value(amount)()) {
2593                 
2594                 return true;
2595                 
2596             } else {
2597             
2598             // Can try to refund later if goes wrong.
2599             playerFundsToWithdraw[msg.sender] = amount;
2600             
2601             return false;
2602         }
2603     }
2604     
2605     /**
2606      * @dev Checks for the pending withdrawals.
2607      */
2608 
2609     function getPendingTransactions(address playerAddress) 
2610         public 
2611         constant 
2612         returns (uint256) {
2613             
2614             return playerFundsToWithdraw[playerAddress];
2615         }
2616     
2617 }
2618 
2619 
2620 contract PowerOne is PowerEtherHelper, usingOraclize {
2621     
2622     /// @dev checks only Oraclize address is calling
2623     modifier onlyOraclize {
2624         require(msg.sender == oraclize_cbAddress());
2625         _;
2626     }
2627     
2628     /**
2629      * @dev Makes the bid to the PowerOne game.
2630      */
2631     function makePowerOneBid(uint256 numberOne)
2632         public
2633         payable
2634         isHuman
2635         isActivated {
2636             
2637             require(numberOne >= minNumber && numberOne <= maxNumber, "The number chosen is invalid!");
2638             
2639             uint256 payment = SafeMath.add(powerOneBid, powerOneFee);
2640             uint256 totalPayment = SafeMath.add(payment, megaJackpotFee);
2641             
2642             require(msg.value == totalPayment, "Wrong payment value!");
2643             
2644             randomQueryId += 1;
2645             
2646             powerOneFeesToCollect ++;
2647             
2648             // Compose the Oraclize query
2649             string memory queryStringOne = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BEna2ojyJ8x3euQmExkugHrukwYeMH2Z7o3e9XEqATmN1ApOokRElT5IJEp1JNFhbn3dvdEo3wLaDaZJu5PqRUaoI4ZnbDTwAmMtkfLP1jBD7OldcYReDzG4cc5tdjCdP2KbzhIOEuXskoW3PzkqHzGq641e}\",\"n\":1,\"min\":1,\"max\":10,\"replacement\":false,\"base\":10${[identity] \"}\"},\"id\":";
2650             string memory queryStringTwo = uint2str(randomQueryId);
2651             string memory queryStringThree = "${[identity] \"}\"}']";
2652             
2653             string memory queryStringOne_Two = queryStringOne.toSlice().concat(queryStringTwo.toSlice());
2654             string memory queryStringOne_Two_Three = queryStringOne_Two.toSlice().concat(queryStringThree.toSlice());
2655             
2656             bytes32 queryId = oraclize_query("nested", queryStringOne_Two_Three, gasForOraclize);
2657             
2658             senderAddresses[queryId] = msg.sender;
2659             
2660             gameTypes[queryId] = 1;
2661             
2662             powerNumberOne[queryId] = numberOne;
2663             
2664             powerOneJackpot += powerOneBid;
2665             
2666             megaJackpot += megaJackpotFee;
2667 
2668             totalGamesPlayed ++;
2669             
2670             emit LogQuery(
2671                 msg.sender,
2672                 1,
2673                 randomQueryId,
2674                 numberOne,
2675                 0,
2676                 0,
2677                 0
2678                 );
2679                 
2680         }
2681     
2682     /**
2683      * @dev Internal core logic of the PowerOne game
2684      */
2685     function _powerOne(
2686         string result,
2687         uint256 pnOne,
2688         address playerAddress
2689         ) internal {
2690         // Sanity check
2691         require(pnOne != 0, "Invalid game, refunded!");
2692                 
2693         require(powerOneJackpot <= address(this).balance, "Insufficient funds!");
2694                 
2695         strings.slice memory res = result.toSlice();
2696         strings.slice memory delim = " ".toSlice();
2697         uint256[] memory parts = new uint256[](res.count(delim) + 1);
2698         for (uint256 i = 0; i < parts.length; i ++) {
2699             parts[i] = parseInt(res.split(delim).toString());
2700         }
2701                 
2702         // Refunding if the result is 0 or no proof is provided.       
2703         if (bytes(result).length == 0) {
2704                     
2705             emit Refund(
2706                 playerAddress,
2707                 1
2708                 );
2709                 
2710             if (!playerAddress.send(SafeMath.add(powerOneBid, powerOneFee))) {
2711                 
2712                 playerFundsToWithdraw[playerAddress] = SafeMath.add(powerOneBid, powerOneFee);                     
2713             }
2714                     
2715             playerAddress = 0x0;
2716                     
2717             return;
2718                     
2719         }
2720                 
2721         if (parts[1] == pnOne) {
2722                     
2723             if(_checkMegaJackpotCap(playerAddress)) {
2724                 bool checkResult = true;
2725             } else {
2726                 checkResult = false;
2727             }
2728                        
2729             powerOneWinCounter ++;
2730                     
2731             // Calculating the eligible payout
2732             uint256 eligiblePayout = SafeMath.div(SafeMath.mul(powerOneJackpot, platformCut), 100);
2733             uint256 platformCutPayout = SafeMath.sub(powerOneJackpot, eligiblePayout);
2734                     
2735             playerAddress.transfer(eligiblePayout);
2736                     
2737             ceoAddress.transfer(platformCutPayout);
2738 
2739             emit PowerEtherResults(
2740                 playerAddress,
2741                 parts[0],
2742                 1,
2743                 pnOne,
2744                 0,
2745                 0,
2746                 0,
2747                 eligiblePayout,
2748                 true,
2749                 checkResult
2750                 );
2751 
2752             totalEtherWon += eligiblePayout;
2753                     
2754             powerOneJackpot = 0;
2755                     
2756             playerAddress = 0x0;            
2757 
2758         } else if (parts[1] != pnOne) {
2759                     
2760             emit PowerEtherResults(
2761                 playerAddress,
2762                 parts[0],
2763                 1,
2764                 pnOne,
2765                 0,
2766                 0,
2767                 0,
2768                 eligiblePayout,
2769                 false,
2770                 false
2771                 );
2772                     
2773             playerAddress = 0x0;
2774 
2775         }
2776         
2777     }
2778     
2779 }
2780 
2781 contract PowerTwo is PowerOne {
2782     
2783     /**
2784      * @dev Makes the bid to the PowerTwo game.
2785      */
2786     function makePowerTwoBid(
2787         uint256 numberOne,
2788         uint256 numberTwo
2789         )
2790         public
2791         payable
2792         isHuman
2793         isActivated {
2794             
2795             require(numberOne >= minNumber && numberOne <= maxNumber, "The first  number chosen is invalid!");
2796             require(numberTwo >= minNumber && numberTwo <= maxNumber, "The second number chosen is invalid!");
2797             
2798             uint256 payment = SafeMath.add(powerTwoBid, powerTwoFee);
2799             uint256 totalPayment = SafeMath.add(payment, megaJackpotFee);
2800             
2801             require(msg.value == totalPayment, "Wrong payment value!");
2802             
2803             randomQueryId += 1;
2804             
2805             powerTwoFeesToCollect ++;
2806             
2807             // Compose the Oraclize query
2808             string memory queryStringOne = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BEna2ojyJ8x3euQmExkugHrukwYeMH2Z7o3e9XEqATmN1ApOokRElT5IJEp1JNFhbn3dvdEo3wLaDaZJu5PqRUaoI4ZnbDTwAmMtkfLP1jBD7OldcYReDzG4cc5tdjCdP2KbzhIOEuXskoW3PzkqHzGq641e}\",\"n\":2,\"min\":1,\"max\":10,\"replacement\":false,\"base\":10${[identity] \"}\"},\"id\":";
2809             string memory queryStringTwo = uint2str(randomQueryId);
2810             string memory queryStringThree = "${[identity] \"}\"}']";
2811             
2812             string memory queryStringOne_Two = queryStringOne.toSlice().concat(queryStringTwo.toSlice());
2813             string memory queryStringOne_Two_Three = queryStringOne_Two.toSlice().concat(queryStringThree.toSlice());
2814             
2815             bytes32 queryId = oraclize_query("nested", queryStringOne_Two_Three, gasForOraclize);
2816             
2817             senderAddresses[queryId] = msg.sender;
2818             
2819             gameTypes[queryId] = 2;
2820             
2821             powerNumberOne[queryId] = numberOne;
2822             powerNumberTwo[queryId] = numberTwo;
2823             
2824             powerTwoJackpot += powerTwoBid;
2825             
2826             megaJackpot += megaJackpotFee;
2827 
2828             totalGamesPlayed ++;
2829             
2830             emit LogQuery(
2831                 msg.sender,
2832                 2,
2833                 randomQueryId,
2834                 numberOne,
2835                 numberTwo,
2836                 0,
2837                 0
2838                 );
2839                 
2840         }
2841     
2842     /**
2843      * @dev Internal core logic of the PowerTwo game
2844      */
2845     function _powerTwo(
2846         string result,
2847         uint256 pnOne,
2848         uint256 pnTwo,
2849         address playerAddress
2850         ) internal {
2851             
2852         // Sanity check
2853         require(pnOne != 0, "Invalid game, refunded!");
2854         require(pnTwo != 0, "Invalid game, refunded!");
2855                 
2856         require(powerTwoJackpot <= address(this).balance, "Insufficient funds!");
2857                 
2858         strings.slice memory res = result.toSlice();
2859         strings.slice memory delim = " ".toSlice();
2860         uint256[] memory parts = new uint256[](res.count(delim) + 1);
2861         for (uint256 i = 0; i < parts.length; i ++) {
2862             parts[i] = parseInt(res.split(delim).toString());
2863         }
2864                 
2865         // Refunding if the result is 0 or no proof is provided.
2866         if (bytes(result).length == 0) {
2867                     
2868             emit Refund(
2869                 playerAddress,
2870                 1
2871                 );
2872                 
2873             if (!playerAddress.send(SafeMath.add(powerTwoBid, powerTwoFee))) {
2874                 
2875                 playerFundsToWithdraw[playerAddress] = SafeMath.add(powerTwoBid, powerTwoFee);                     
2876             }
2877                     
2878             playerAddress = 0x0;
2879                     
2880             return;
2881                     
2882         }
2883                 
2884         if (_checkTwo(
2885             parts[1],
2886             parts[2],
2887             pnOne,
2888             pnTwo)) {
2889                         
2890             if(_checkMegaJackpotCap(playerAddress)) {
2891                 bool checkResult = true;
2892             } else {
2893                 checkResult = false;
2894             }
2895                     
2896             powerTwoWinCounter ++;
2897                     
2898             // Calculating the eligible payout
2899             uint256 eligiblePayout = SafeMath.div(SafeMath.mul(powerTwoJackpot, platformCut), 100);
2900             uint256 platformCutPayout = SafeMath.sub(powerTwoJackpot, eligiblePayout);
2901                     
2902             playerAddress.transfer(SafeMath.div(SafeMath.mul(powerTwoJackpot, platformCut), 100));
2903                     
2904             ceoAddress.transfer(platformCutPayout);
2905 
2906             emit PowerEtherResults(
2907                 playerAddress,
2908                 parts[0],
2909                 2,
2910                 pnOne,
2911                 pnTwo,
2912                 0,
2913                 0,
2914                 eligiblePayout,
2915                 true,
2916                 checkResult
2917                 );
2918 
2919             totalEtherWon += eligiblePayout;
2920                     
2921             powerTwoJackpot = 0;
2922                         
2923             playerAddress = 0x0;
2924 
2925         } else if (!_checkTwo(
2926             parts[1],
2927             parts[2],
2928             pnOne,
2929             pnTwo)) {
2930                     
2931             emit PowerEtherResults(
2932                 playerAddress,
2933                 parts[0],
2934                 2,
2935                 pnOne,
2936                 pnTwo,
2937                 0,
2938                 0,
2939                 eligiblePayout,
2940                 false,
2941                 false
2942                 );
2943                     
2944             playerAddress = 0x0;
2945 
2946         }
2947         
2948     }
2949     
2950 }
2951 
2952 
2953 contract PowerFour is PowerTwo {
2954     
2955     /**
2956      * @dev Makes the bid to the PowerFour game.
2957      */
2958     function makePowerFourBid(
2959         uint256 numberOne,
2960         uint256 numberTwo,
2961         uint256 numberThree,
2962         uint256 numberFour
2963         )
2964         public
2965         payable
2966         isHuman
2967         isActivated {
2968             
2969             require(numberOne >= minNumber && numberOne <= maxNumber, "The first number chosen is invalid!");
2970             require(numberTwo >= minNumber && numberTwo <= maxNumber, "The second number chosen is invalid!");
2971             require(numberThree >= minNumber && numberThree <= maxNumber, "The third number chosen is invalid!");
2972             require(numberFour >= minNumber && numberFour <= maxNumber, "The fourth chosen is invalid!");
2973             
2974             uint256 payment = SafeMath.add(powerFourBid, powerFourFee);
2975             uint256 totalPayment = SafeMath.add(payment, megaJackpotFee);
2976             
2977             require(msg.value == totalPayment, "Wrong payment value!");
2978             
2979             randomQueryId += 1;
2980             
2981             powerFourFeesToCollect ++;
2982             
2983             // Compose the Oraclize query
2984             string memory queryStringOne = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BEna2ojyJ8x3euQmExkugHrukwYeMH2Z7o3e9XEqATmN1ApOokRElT5IJEp1JNFhbn3dvdEo3wLaDaZJu5PqRUaoI4ZnbDTwAmMtkfLP1jBD7OldcYReDzG4cc5tdjCdP2KbzhIOEuXskoW3PzkqHzGq641e}\",\"n\":4,\"min\":1,\"max\":10,\"replacement\":false,\"base\":10${[identity] \"}\"},\"id\":";
2985             string memory queryStringTwo = uint2str(randomQueryId);
2986             string memory queryStringThree = "${[identity] \"}\"}']";
2987             
2988             string memory queryStringOne_Two = queryStringOne.toSlice().concat(queryStringTwo.toSlice());
2989             string memory queryStringOne_Two_Three = queryStringOne_Two.toSlice().concat(queryStringThree.toSlice());
2990             
2991             bytes32 queryId = oraclize_query("nested", queryStringOne_Two_Three, gasForOraclize);
2992             
2993             senderAddresses[queryId] = msg.sender;
2994             
2995             gameTypes[queryId] = 4;
2996             
2997             powerNumberOne[queryId] = numberOne;
2998             powerNumberTwo[queryId] = numberTwo;
2999             powerNumberThree[queryId] = numberThree;
3000             powerNumberFour[queryId] = numberFour;
3001             
3002             powerFourJackpot += powerFourBid;
3003             
3004             megaJackpot += megaJackpotFee;
3005 
3006             totalGamesPlayed ++;
3007                 
3008         }
3009         
3010     /**
3011      * @dev Internal core logic of the PowerFour game
3012      */
3013     
3014     function _powerFour(
3015         string result,
3016         uint256 pnOne,
3017         uint256 pnTwo,
3018         uint256 pnThree,
3019         uint256 pnFour,
3020         address playerAddress
3021         ) internal {
3022             
3023         // Sanity check
3024         require(pnOne != 0, "Invalid game, refunded!");
3025         require(pnTwo != 0, "Invalid game, refunded!");
3026         require(pnThree != 0, "Invalid game, refunded!");
3027         require(pnFour != 0, "Invalid game, refunded!");
3028                 
3029         require(powerFourJackpot <= address(this).balance, "Insufficient funds!");
3030                 
3031         strings.slice memory res = result.toSlice();
3032         strings.slice memory delim = " ".toSlice();
3033         uint256[] memory parts = new uint256[](res.count(delim) + 1);
3034         for (uint256 i = 0; i < parts.length; i ++) {
3035             parts[i] = parseInt(res.split(delim).toString());
3036         }
3037                 
3038         // Refunding if the result is 0 or no proof is provided.
3039         if (bytes(result).length == 0) {
3040                       
3041             emit Refund(
3042                 playerAddress,
3043                 1
3044                 );
3045                 
3046             if (!playerAddress.send(SafeMath.add(powerFourBid, powerFourFee))) {
3047                 
3048                 playerFundsToWithdraw[playerAddress] = SafeMath.add(powerFourBid, powerFourFee);                  
3049             }
3050                     
3051             playerAddress = 0x0;
3052                     
3053             return;
3054                     
3055         }
3056                 
3057         if (_checkFour(
3058             parts[1],
3059             parts[2],
3060             parts[3],
3061             parts[4],
3062             pnOne,
3063             pnTwo,
3064             pnThree,
3065             pnFour)) {
3066                         
3067             _checkMegaJackpotCap(playerAddress);
3068                     
3069             // Calculating the eligible payout
3070             uint256 eligiblePayout = SafeMath.div(SafeMath.mul(powerFourJackpot, platformCut), 100);
3071             uint256 platformCutPayout = SafeMath.sub(powerFourJackpot, eligiblePayout);
3072                     
3073             playerAddress.transfer(eligiblePayout);
3074                     
3075             // Transfering the MegaJackpot to the winner
3076             playerAddress.transfer(megaJackpot);
3077                     
3078             ceoAddress.transfer(platformCutPayout);
3079 
3080             emit PowerEtherResults(
3081                 playerAddress,
3082                 parts[0],
3083                 4,
3084                 pnOne,
3085                 pnTwo,
3086                 pnThree,
3087                 pnFour,
3088                 eligiblePayout,
3089                 true,
3090                 true
3091                 );
3092 
3093             totalEtherWon += eligiblePayout;
3094                     
3095             powerFourWinCounter ++;
3096                     
3097             megaJackpot = 0;
3098                     
3099             powerFourJackpot = 0;
3100                     
3101             playerAddress = 0x0;
3102 
3103         } else if (!_checkFour(
3104             parts[1],
3105             parts[2],
3106             parts[3],
3107             parts[4],
3108             pnOne,
3109             pnTwo,
3110             pnThree,
3111             pnFour)) {
3112                         
3113             emit PowerEtherResults(
3114                 playerAddress,
3115                 parts[0],
3116                 4,
3117                 pnOne,
3118                 pnTwo,
3119                 pnThree,
3120                 pnFour,
3121                 eligiblePayout,
3122                 false,
3123                 false
3124                 );
3125 
3126             playerAddress = 0x0;
3127 
3128         }
3129         
3130     }
3131     
3132 }
3133 
3134 
3135 contract PowerEther is PowerFour {
3136     
3137     /**
3138      * 
3139      *    _______ _            ____  _            _    _____  _                                  
3140      *   |__   __| |          |  _ \| |          | |  |  __ \| |                           
3141      *      | |  | |__   ___  | |_) | | ___   ___| | _| |__) | | __ _ _   _     
3142      *      | |  | '_ \ / _ \ |  _ <| |/ _ \ / __| |/ /  ___/| |/ _` | | | |    
3143      *      | |  | | | |  __/ | |_) | | (_) | (__|   <| |    | | (_| | |_| |    
3144      *      |_|  |_| |_|\___| |____/|_|\___/ \___|_|\_\_|    |_|\__,_|\__, |    
3145      *                                                                 __/ |                            
3146      *                                                                |___/                             
3147      *                      
3148      *                                ╔═╗╦═╗╔═╗╦ ╦╔╦╗╦ ╦ ╦   
3149      *                                ╠═╝╠╦╝║ ║║ ║ ║║║ ╚╦╝   
3150      *                                ╩  ╩╚═╚═╝╚═╝═╩╝╩═╝╩    
3151      *                              ╔═╗╦═╗╔═╗╔═╗╔═╗╔╗╔╦╗╔═╗
3152      *                              ╠═╝╠╦╝║╣ ╚═╗║╣ ║║║║ ╚═╗
3153      *                              ╩  ╩╚═╚═╝╚═╝╚═╝╝╚╝╩ ╚═╝
3154      * 
3155      *
3156      * 
3157      *  
3158      *  ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███████╗████████╗██╗  ██╗███████╗██████╗ 
3159      *  ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗
3160      *  ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝█████╗     ██║   ███████║█████╗  ██████╔╝
3161      *  ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗
3162      *  ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║███████╗   ██║   ██║  ██║███████╗██║  ██║
3163      *  ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
3164      *                                                                              
3165      *
3166      * 
3167      * 
3168      * PowerEther is the first honest Ethereum lottery based on PowerBall
3169      * mechanics. There are three types of games: PowerOne - guess one number,
3170      * PowerTwo - guess two numbers, and PowerFour - guess four numbers.
3171      * 
3172      * The rules are simple: if the player does not win the round, the bid is
3173      * added to the balance of that certain game type. If the game is won, the
3174      * player gets all the balance of that certain game.
3175      * 
3176      * Every time a player loses, a small amount is transferred to the
3177      * MegaJackpot. the MegaJackpot is won either whenever a PowerFour game is
3178      * won, or when the hard cap has been reached. If the cap
3179      * has been reached, the first winner of ANY game gets the MegaJacpot!
3180      * 
3181      * Play PowerEther and win TONS of Ether!
3182      * 
3183      * 
3184      * 
3185      */
3186      
3187     /**
3188      * 
3189      *
3190      *      ╔═╗╔═╗╔╗╔╔═╗╔╦╗╦═╗╦ ╦╔═╗╔╦╗╔═╗╦═╗
3191      *      ║  ║ ║║║║╚═╗ ║ ╠╦╝║ ║║   ║ ║ ║╠╦╝
3192      *      ╚═╝╚═╝╝╚╝╚═╝ ╩ ╩╚═╚═╝╚═╝ ╩ ╚═╝╩╚═
3193      *
3194      * 
3195      */
3196      
3197     constructor() public {
3198         
3199         /// Activating the contract.
3200         activated_ = true;
3201         
3202         /// Setting the initial address of the CEO.
3203         ceoAddress = msg.sender;
3204         
3205         /// Setting the gas amount for Oraclize.
3206         gasForOraclize = 335000;
3207         
3208         /// Setting the initial value for the randomQueryId
3209         randomQueryId = 777;
3210         
3211         /// Sets the min and max numbers.
3212         minNumber = 1;
3213         maxNumber = 10;
3214         
3215     }
3216     
3217     /**
3218      * @dev The Oraclize callback function.
3219      */
3220     
3221     function __callback(
3222         bytes32 myid, 
3223         string result) 
3224         public   
3225 		onlyOraclize
3226 		isActivated {
3227 
3228             require(senderAddresses[myid] != address(0), "Wrong player address!");
3229             
3230             if (gameTypes[myid] == 1) {
3231                 
3232                 _powerOne(result, powerNumberOne[myid], senderAddresses[myid]);
3233                 
3234             } else if (gameTypes[myid] == 2) {
3235                 
3236                 _powerTwo(result, powerNumberOne[myid], powerNumberTwo[myid], senderAddresses[myid]);
3237                 
3238             } else if (gameTypes[myid] == 4) {
3239 
3240                 _powerFour(result, powerNumberOne[myid], powerNumberTwo[myid], powerNumberThree[myid], powerNumberFour[myid], senderAddresses[myid]);
3241                     
3242         }
3243         
3244     }
3245     
3246 }