1 /**
2  *  https://GreenRabbit.site
3  *
4  * Attack random Green Rabbit's smart Kingdom!
5  *
6  * Send 0.01 ether for attack random kingdom.
7  * Use 150000 of Gas limit for your transactions.
8  *
9  */
10 
11 pragma solidity ^0.4.25;
12 
13 // <ORACLIZE_API>
14 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
15 /*
16 Copyright (c) 2015-2016 Oraclize SRL
17 Copyright (c) 2016 Oraclize LTD
18 Permission is hereby granted, free of charge, to any person obtaining a copy
19 of this software and associated documentation files (the "Software"), to deal
20 in the Software without restriction, including without limitation the rights
21 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 copies of the Software, and to permit persons to whom the Software is
23 furnished to do so, subject to the following conditions:
24 The above copyright notice and this permission notice shall be included in
25 all copies or substantial portions of the Software.
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32 THE SOFTWARE.
33 */
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
43     function getPrice(string _datasource) public returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
45     function setProofType(byte _proofType) external;
46     function setCustomGasPrice(uint _gasPrice) external;
47     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
48 }
49 
50 contract OraclizeAddrResolverI {
51     function getAddress() public returns (address _addr);
52 }
53 
54 /*
55 Begin solidity-cborutils
56 https://github.com/smartcontractkit/solidity-cborutils
57 MIT License
58 Copyright (c) 2018 SmartContract ChainLink, Ltd.
59 Permission is hereby granted, free of charge, to any person obtaining a copy
60 of this software and associated documentation files (the "Software"), to deal
61 in the Software without restriction, including without limitation the rights
62 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
63 copies of the Software, and to permit persons to whom the Software is
64 furnished to do so, subject to the following conditions:
65 The above copyright notice and this permission notice shall be included in all
66 copies or substantial portions of the Software.
67 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
68 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
69 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
70 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
71 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
72 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
73 SOFTWARE.
74  */
75 
76 library Buffer {
77     struct buffer {
78         bytes buf;
79         uint capacity;
80     }
81 
82     function init(buffer memory buf, uint _capacity) internal pure {
83         uint capacity = _capacity;
84         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
85         // Allocate space for the buffer data
86         buf.capacity = capacity;
87         assembly {
88             let ptr := mload(0x40)
89             mstore(buf, ptr)
90             mstore(ptr, 0)
91             mstore(0x40, add(ptr, capacity))
92         }
93     }
94 
95     function resize(buffer memory buf, uint capacity) private pure {
96         bytes memory oldbuf = buf.buf;
97         init(buf, capacity);
98         append(buf, oldbuf);
99     }
100 
101     function max(uint a, uint b) private pure returns(uint) {
102         if(a > b) {
103             return a;
104         }
105         return b;
106     }
107 
108     /**
109      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
110      *      would exceed the capacity of the buffer.
111      * @param buf The buffer to append to.
112      * @param data The data to append.
113      * @return The original buffer.
114      */
115     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
116         if(data.length + buf.buf.length > buf.capacity) {
117             resize(buf, max(buf.capacity, data.length) * 2);
118         }
119 
120         uint dest;
121         uint src;
122         uint len = data.length;
123         assembly {
124             // Memory address of the buffer data
125             let bufptr := mload(buf)
126             // Length of existing buffer data
127             let buflen := mload(bufptr)
128             // Start address = buffer address + buffer length + sizeof(buffer length)
129             dest := add(add(bufptr, buflen), 32)
130             // Update buffer length
131             mstore(bufptr, add(buflen, mload(data)))
132             src := add(data, 32)
133         }
134 
135         // Copy word-length chunks while possible
136         for(; len >= 32; len -= 32) {
137             assembly {
138                 mstore(dest, mload(src))
139             }
140             dest += 32;
141             src += 32;
142         }
143 
144         // Copy remaining bytes
145         uint mask = 256 ** (32 - len) - 1;
146         assembly {
147             let srcpart := and(mload(src), not(mask))
148             let destpart := and(mload(dest), mask)
149             mstore(dest, or(destpart, srcpart))
150         }
151 
152         return buf;
153     }
154 
155     /**
156      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
157      * exceed the capacity of the buffer.
158      * @param buf The buffer to append to.
159      * @param data The data to append.
160      * @return The original buffer.
161      */
162     function append(buffer memory buf, uint8 data) internal pure {
163         if(buf.buf.length + 1 > buf.capacity) {
164             resize(buf, buf.capacity * 2);
165         }
166 
167         assembly {
168             // Memory address of the buffer data
169             let bufptr := mload(buf)
170             // Length of existing buffer data
171             let buflen := mload(bufptr)
172             // Address = buffer address + buffer length + sizeof(buffer length)
173             let dest := add(add(bufptr, buflen), 32)
174             mstore8(dest, data)
175             // Update buffer length
176             mstore(bufptr, add(buflen, 1))
177         }
178     }
179 
180     /**
181      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
182      * exceed the capacity of the buffer.
183      * @param buf The buffer to append to.
184      * @param data The data to append.
185      * @return The original buffer.
186      */
187     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
188         if(len + buf.buf.length > buf.capacity) {
189             resize(buf, max(buf.capacity, len) * 2);
190         }
191 
192         uint mask = 256 ** len - 1;
193         assembly {
194             // Memory address of the buffer data
195             let bufptr := mload(buf)
196             // Length of existing buffer data
197             let buflen := mload(bufptr)
198             // Address = buffer address + buffer length + sizeof(buffer length) + len
199             let dest := add(add(bufptr, buflen), len)
200             mstore(dest, or(and(mload(dest), not(mask)), data))
201             // Update buffer length
202             mstore(bufptr, add(buflen, len))
203         }
204         return buf;
205     }
206 }
207 
208 library CBOR {
209     using Buffer for Buffer.buffer;
210 
211     uint8 private constant MAJOR_TYPE_INT = 0;
212     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
213     uint8 private constant MAJOR_TYPE_BYTES = 2;
214     uint8 private constant MAJOR_TYPE_STRING = 3;
215     uint8 private constant MAJOR_TYPE_ARRAY = 4;
216     uint8 private constant MAJOR_TYPE_MAP = 5;
217     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
218 
219     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
220         if(value <= 23) {
221             buf.append(uint8((major << 5) | value));
222         } else if(value <= 0xFF) {
223             buf.append(uint8((major << 5) | 24));
224             buf.appendInt(value, 1);
225         } else if(value <= 0xFFFF) {
226             buf.append(uint8((major << 5) | 25));
227             buf.appendInt(value, 2);
228         } else if(value <= 0xFFFFFFFF) {
229             buf.append(uint8((major << 5) | 26));
230             buf.appendInt(value, 4);
231         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
232             buf.append(uint8((major << 5) | 27));
233             buf.appendInt(value, 8);
234         }
235     }
236 
237     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
238         buf.append(uint8((major << 5) | 31));
239     }
240 
241     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
242         encodeType(buf, MAJOR_TYPE_INT, value);
243     }
244 
245     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
246         if(value >= 0) {
247             encodeType(buf, MAJOR_TYPE_INT, uint(value));
248         } else {
249             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
250         }
251     }
252 
253     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
254         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
255         buf.append(value);
256     }
257 
258     function encodeString(Buffer.buffer memory buf, string value) internal pure {
259         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
260         buf.append(bytes(value));
261     }
262 
263     function startArray(Buffer.buffer memory buf) internal pure {
264         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
265     }
266 
267     function startMap(Buffer.buffer memory buf) internal pure {
268         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
269     }
270 
271     function endSequence(Buffer.buffer memory buf) internal pure {
272         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
273     }
274 }
275 
276 /*
277 End solidity-cborutils
278  */
279 
280 contract usingOraclize {
281     uint constant day = 60*60*24;
282     uint constant week = 60*60*24*7;
283     uint constant month = 60*60*24*30;
284     byte constant proofType_NONE = 0x00;
285     byte constant proofType_TLSNotary = 0x10;
286     byte constant proofType_Ledger = 0x30;
287     byte constant proofType_Android = 0x40;
288     byte constant proofType_Native = 0xF0;
289     byte constant proofStorage_IPFS = 0x01;
290     uint8 constant networkID_auto = 0;
291     uint8 constant networkID_mainnet = 1;
292     uint8 constant networkID_testnet = 2;
293     uint8 constant networkID_morden = 2;
294     uint8 constant networkID_consensys = 161;
295 
296     OraclizeAddrResolverI OAR;
297 
298     OraclizeI oraclize;
299     modifier oraclizeAPI {
300         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
301             oraclize_setNetwork(networkID_auto);
302 
303         if(address(oraclize) != OAR.getAddress())
304             oraclize = OraclizeI(OAR.getAddress());
305 
306         _;
307     }
308     modifier coupon(string code){
309         oraclize = OraclizeI(OAR.getAddress());
310         _;
311     }
312 
313     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
314       return oraclize_setNetwork();
315       networkID; // silence the warning and remain backwards compatible
316     }
317     function oraclize_setNetwork() internal returns(bool){
318         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
319             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
320             oraclize_setNetworkName("eth_mainnet");
321             return true;
322         }
323         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
324             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
325             oraclize_setNetworkName("eth_ropsten3");
326             return true;
327         }
328         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
329             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
330             oraclize_setNetworkName("eth_kovan");
331             return true;
332         }
333         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
334             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
335             oraclize_setNetworkName("eth_rinkeby");
336             return true;
337         }
338         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
339             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
340             return true;
341         }
342         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
343             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
344             return true;
345         }
346         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
347             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
348             return true;
349         }
350         return false;
351     }
352 
353     function __callback(bytes32 myid, string result) public {
354         __callback(myid, result, new bytes(0));
355     }
356     function __callback(bytes32 myid, string result, bytes proof) public {
357       return;
358       // Following should never be reached with a preceding return, however
359       // this is just a placeholder function, ideally meant to be defined in
360       // child contract when proofs are used
361       myid; result; proof; // Silence compiler warnings
362       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
363     }
364 
365     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
366         return oraclize.getPrice(datasource);
367     }
368 
369     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
370         return oraclize.getPrice(datasource, gaslimit);
371     }
372 
373     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
374         uint price = oraclize.getPrice(datasource);
375         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
376         return oraclize.query.value(price)(0, datasource, arg);
377     }
378     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource);
380         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
381         return oraclize.query.value(price)(timestamp, datasource, arg);
382     }
383     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource, gaslimit);
385         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
386         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
387     }
388     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource, gaslimit);
390         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
391         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
392     }
393     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource);
395         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
396         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
397     }
398     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource);
400         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
401         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
402     }
403     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
404         uint price = oraclize.getPrice(datasource, gaslimit);
405         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
406         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
407     }
408     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource, gaslimit);
410         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
411         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
412     }
413     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource);
415         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
416         bytes memory args = stra2cbor(argN);
417         return oraclize.queryN.value(price)(0, datasource, args);
418     }
419     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource);
421         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
422         bytes memory args = stra2cbor(argN);
423         return oraclize.queryN.value(price)(timestamp, datasource, args);
424     }
425     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource, gaslimit);
427         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
428         bytes memory args = stra2cbor(argN);
429         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
430     }
431     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource, gaslimit);
433         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
434         bytes memory args = stra2cbor(argN);
435         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
436     }
437     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
438         string[] memory dynargs = new string[](1);
439         dynargs[0] = args[0];
440         return oraclize_query(datasource, dynargs);
441     }
442     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
443         string[] memory dynargs = new string[](1);
444         dynargs[0] = args[0];
445         return oraclize_query(timestamp, datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](1);
449         dynargs[0] = args[0];
450         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](1);
454         dynargs[0] = args[0];
455         return oraclize_query(datasource, dynargs, gaslimit);
456     }
457 
458     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](2);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         return oraclize_query(datasource, dynargs);
463     }
464     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
465         string[] memory dynargs = new string[](2);
466         dynargs[0] = args[0];
467         dynargs[1] = args[1];
468         return oraclize_query(timestamp, datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](2);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](2);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         return oraclize_query(datasource, dynargs, gaslimit);
481     }
482     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
483         string[] memory dynargs = new string[](3);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](3);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         return oraclize_query(timestamp, datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](3);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](3);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         return oraclize_query(datasource, dynargs, gaslimit);
509     }
510 
511     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](4);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         dynargs[2] = args[2];
516         dynargs[3] = args[3];
517         return oraclize_query(datasource, dynargs);
518     }
519     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
520         string[] memory dynargs = new string[](4);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         dynargs[3] = args[3];
525         return oraclize_query(timestamp, datasource, dynargs);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](4);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         dynargs[3] = args[3];
533         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
534     }
535     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
536         string[] memory dynargs = new string[](4);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         return oraclize_query(datasource, dynargs, gaslimit);
542     }
543     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](5);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         dynargs[4] = args[4];
550         return oraclize_query(datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](5);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         dynargs[4] = args[4];
559         return oraclize_query(timestamp, datasource, dynargs);
560     }
561     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         string[] memory dynargs = new string[](5);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         dynargs[4] = args[4];
568         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
569     }
570     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
571         string[] memory dynargs = new string[](5);
572         dynargs[0] = args[0];
573         dynargs[1] = args[1];
574         dynargs[2] = args[2];
575         dynargs[3] = args[3];
576         dynargs[4] = args[4];
577         return oraclize_query(datasource, dynargs, gaslimit);
578     }
579     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
580         uint price = oraclize.getPrice(datasource);
581         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
582         bytes memory args = ba2cbor(argN);
583         return oraclize.queryN.value(price)(0, datasource, args);
584     }
585     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
586         uint price = oraclize.getPrice(datasource);
587         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
588         bytes memory args = ba2cbor(argN);
589         return oraclize.queryN.value(price)(timestamp, datasource, args);
590     }
591     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
592         uint price = oraclize.getPrice(datasource, gaslimit);
593         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
594         bytes memory args = ba2cbor(argN);
595         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
596     }
597     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
598         uint price = oraclize.getPrice(datasource, gaslimit);
599         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
600         bytes memory args = ba2cbor(argN);
601         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
602     }
603     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](1);
605         dynargs[0] = args[0];
606         return oraclize_query(datasource, dynargs);
607     }
608     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
609         bytes[] memory dynargs = new bytes[](1);
610         dynargs[0] = args[0];
611         return oraclize_query(timestamp, datasource, dynargs);
612     }
613     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](1);
615         dynargs[0] = args[0];
616         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
617     }
618     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](1);
620         dynargs[0] = args[0];
621         return oraclize_query(datasource, dynargs, gaslimit);
622     }
623 
624     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](2);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         return oraclize_query(datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
631         bytes[] memory dynargs = new bytes[](2);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         return oraclize_query(timestamp, datasource, dynargs);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](2);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
641     }
642     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](2);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         return oraclize_query(datasource, dynargs, gaslimit);
647     }
648     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
649         bytes[] memory dynargs = new bytes[](3);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         dynargs[2] = args[2];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](3);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         return oraclize_query(timestamp, datasource, dynargs);
661     }
662     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](3);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](3);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         return oraclize_query(datasource, dynargs, gaslimit);
675     }
676 
677     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](4);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         dynargs[2] = args[2];
682         dynargs[3] = args[3];
683         return oraclize_query(datasource, dynargs);
684     }
685     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
686         bytes[] memory dynargs = new bytes[](4);
687         dynargs[0] = args[0];
688         dynargs[1] = args[1];
689         dynargs[2] = args[2];
690         dynargs[3] = args[3];
691         return oraclize_query(timestamp, datasource, dynargs);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](4);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         dynargs[3] = args[3];
699         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
700     }
701     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
702         bytes[] memory dynargs = new bytes[](4);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         dynargs[3] = args[3];
707         return oraclize_query(datasource, dynargs, gaslimit);
708     }
709     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](5);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         dynargs[3] = args[3];
715         dynargs[4] = args[4];
716         return oraclize_query(datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
719         bytes[] memory dynargs = new bytes[](5);
720         dynargs[0] = args[0];
721         dynargs[1] = args[1];
722         dynargs[2] = args[2];
723         dynargs[3] = args[3];
724         dynargs[4] = args[4];
725         return oraclize_query(timestamp, datasource, dynargs);
726     }
727     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
728         bytes[] memory dynargs = new bytes[](5);
729         dynargs[0] = args[0];
730         dynargs[1] = args[1];
731         dynargs[2] = args[2];
732         dynargs[3] = args[3];
733         dynargs[4] = args[4];
734         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
735     }
736     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
737         bytes[] memory dynargs = new bytes[](5);
738         dynargs[0] = args[0];
739         dynargs[1] = args[1];
740         dynargs[2] = args[2];
741         dynargs[3] = args[3];
742         dynargs[4] = args[4];
743         return oraclize_query(datasource, dynargs, gaslimit);
744     }
745 
746     function oraclize_cbAddress() oraclizeAPI internal returns (address){
747         return oraclize.cbAddress();
748     }
749     function oraclize_setProof(byte proofP) oraclizeAPI internal {
750         return oraclize.setProofType(proofP);
751     }
752     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
753         return oraclize.setCustomGasPrice(gasPrice);
754     }
755 
756     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
757         return oraclize.randomDS_getSessionPubKeyHash();
758     }
759 
760     function getCodeSize(address _addr) view internal returns(uint _size) {
761         assembly {
762             _size := extcodesize(_addr)
763         }
764     }
765 
766     function parseAddr(string _a) internal pure returns (address){
767         bytes memory tmp = bytes(_a);
768         uint160 iaddr = 0;
769         uint160 b1;
770         uint160 b2;
771         for (uint i=2; i<2+2*20; i+=2){
772             iaddr *= 256;
773             b1 = uint160(tmp[i]);
774             b2 = uint160(tmp[i+1]);
775             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
776             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
777             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
778             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
779             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
780             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
781             iaddr += (b1*16+b2);
782         }
783         return address(iaddr);
784     }
785 
786     function strCompare(string _a, string _b) internal pure returns (int) {
787         bytes memory a = bytes(_a);
788         bytes memory b = bytes(_b);
789         uint minLength = a.length;
790         if (b.length < minLength) minLength = b.length;
791         for (uint i = 0; i < minLength; i ++)
792             if (a[i] < b[i])
793                 return -1;
794             else if (a[i] > b[i])
795                 return 1;
796         if (a.length < b.length)
797             return -1;
798         else if (a.length > b.length)
799             return 1;
800         else
801             return 0;
802     }
803 
804     function indexOf(string _haystack, string _needle) internal pure returns (int) {
805         bytes memory h = bytes(_haystack);
806         bytes memory n = bytes(_needle);
807         if(h.length < 1 || n.length < 1 || (n.length > h.length))
808             return -1;
809         else if(h.length > (2**128 -1))
810             return -1;
811         else
812         {
813             uint subindex = 0;
814             for (uint i = 0; i < h.length; i ++)
815             {
816                 if (h[i] == n[0])
817                 {
818                     subindex = 1;
819                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
820                     {
821                         subindex++;
822                     }
823                     if(subindex == n.length)
824                         return int(i);
825                 }
826             }
827             return -1;
828         }
829     }
830 
831     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
832         bytes memory _ba = bytes(_a);
833         bytes memory _bb = bytes(_b);
834         bytes memory _bc = bytes(_c);
835         bytes memory _bd = bytes(_d);
836         bytes memory _be = bytes(_e);
837         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
838         bytes memory babcde = bytes(abcde);
839         uint k = 0;
840         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
841         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
842         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
843         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
844         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
845         return string(babcde);
846     }
847 
848     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
849         return strConcat(_a, _b, _c, _d, "");
850     }
851 
852     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
853         return strConcat(_a, _b, _c, "", "");
854     }
855 
856     function strConcat(string _a, string _b) internal pure returns (string) {
857         return strConcat(_a, _b, "", "", "");
858     }
859 
860     // parseInt
861     function parseInt(string _a) internal pure returns (uint) {
862         return parseInt(_a, 0);
863     }
864 
865     // parseInt(parseFloat*10^_b)
866     function parseInt(string _a, uint _b) internal pure returns (uint) {
867         bytes memory bresult = bytes(_a);
868         uint mint = 0;
869         bool decimals = false;
870         for (uint i=0; i<bresult.length; i++){
871             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
872                 if (decimals){
873                    if (_b == 0) break;
874                     else _b--;
875                 }
876                 mint *= 10;
877                 mint += uint(bresult[i]) - 48;
878             } else if (bresult[i] == 46) decimals = true;
879         }
880         if (_b > 0) mint *= 10**_b;
881         return mint;
882     }
883 
884     function uint2str(uint i) internal pure returns (string){
885         if (i == 0) return "0";
886         uint j = i;
887         uint len;
888         while (j != 0){
889             len++;
890             j /= 10;
891         }
892         bytes memory bstr = new bytes(len);
893         uint k = len - 1;
894         while (i != 0){
895             bstr[k--] = byte(48 + i % 10);
896             i /= 10;
897         }
898         return string(bstr);
899     }
900 
901     using CBOR for Buffer.buffer;
902     function stra2cbor(string[] arr) internal pure returns (bytes) {
903         safeMemoryCleaner();
904         Buffer.buffer memory buf;
905         Buffer.init(buf, 1024);
906         buf.startArray();
907         for (uint i = 0; i < arr.length; i++) {
908             buf.encodeString(arr[i]);
909         }
910         buf.endSequence();
911         return buf.buf;
912     }
913 
914     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
915         safeMemoryCleaner();
916         Buffer.buffer memory buf;
917         Buffer.init(buf, 1024);
918         buf.startArray();
919         for (uint i = 0; i < arr.length; i++) {
920             buf.encodeBytes(arr[i]);
921         }
922         buf.endSequence();
923         return buf.buf;
924     }
925 
926     string oraclize_network_name;
927     function oraclize_setNetworkName(string _network_name) internal {
928         oraclize_network_name = _network_name;
929     }
930 
931     function oraclize_getNetworkName() internal view returns (string) {
932         return oraclize_network_name;
933     }
934 
935     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
936         require((_nbytes > 0) && (_nbytes <= 32));
937         // Convert from seconds to ledger timer ticks
938         _delay *= 10;
939         bytes memory nbytes = new bytes(1);
940         nbytes[0] = byte(_nbytes);
941         bytes memory unonce = new bytes(32);
942         bytes memory sessionKeyHash = new bytes(32);
943         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
944         assembly {
945             mstore(unonce, 0x20)
946             // the following variables can be relaxed
947             // check relaxed random contract under ethereum-examples repo
948             // for an idea on how to override and replace comit hash vars
949             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
950             mstore(sessionKeyHash, 0x20)
951             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
952         }
953         bytes memory delay = new bytes(32);
954         assembly {
955             mstore(add(delay, 0x20), _delay)
956         }
957 
958         bytes memory delay_bytes8 = new bytes(8);
959         copyBytes(delay, 24, 8, delay_bytes8, 0);
960 
961         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
962         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
963 
964         bytes memory delay_bytes8_left = new bytes(8);
965 
966         assembly {
967             let x := mload(add(delay_bytes8, 0x20))
968             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
976 
977         }
978 
979         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
980         return queryId;
981     }
982 
983     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
984         oraclize_randomDS_args[queryId] = commitment;
985     }
986 
987     mapping(bytes32=>bytes32) oraclize_randomDS_args;
988     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
989 
990     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
991         bool sigok;
992         address signer;
993 
994         bytes32 sigr;
995         bytes32 sigs;
996 
997         bytes memory sigr_ = new bytes(32);
998         uint offset = 4+(uint(dersig[3]) - 0x20);
999         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1000         bytes memory sigs_ = new bytes(32);
1001         offset += 32 + 2;
1002         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1003 
1004         assembly {
1005             sigr := mload(add(sigr_, 32))
1006             sigs := mload(add(sigs_, 32))
1007         }
1008 
1009 
1010         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1011         if (address(keccak256(pubkey)) == signer) return true;
1012         else {
1013             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1014             return (address(keccak256(pubkey)) == signer);
1015         }
1016     }
1017 
1018     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1019         bool sigok;
1020 
1021         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1022         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1023         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1024 
1025         bytes memory appkey1_pubkey = new bytes(64);
1026         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1027 
1028         bytes memory tosign2 = new bytes(1+65+32);
1029         tosign2[0] = byte(1); //role
1030         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1031         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1032         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1033         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1034 
1035         if (sigok == false) return false;
1036 
1037 
1038         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1039         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1040 
1041         bytes memory tosign3 = new bytes(1+65);
1042         tosign3[0] = 0xFE;
1043         copyBytes(proof, 3, 65, tosign3, 1);
1044 
1045         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1046         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1047 
1048         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1049 
1050         return sigok;
1051     }
1052 
1053     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1054         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1055         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1056 
1057         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1058         require(proofVerified);
1059 
1060         _;
1061     }
1062 
1063     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1064         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1065         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1066 
1067         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1068         if (proofVerified == false) return 2;
1069 
1070         return 0;
1071     }
1072 
1073     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1074         bool match_ = true;
1075 
1076         require(prefix.length == n_random_bytes);
1077 
1078         for (uint256 i=0; i< n_random_bytes; i++) {
1079             if (content[i] != prefix[i]) match_ = false;
1080         }
1081 
1082         return match_;
1083     }
1084 
1085     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1086 
1087         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1088         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1089         bytes memory keyhash = new bytes(32);
1090         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1091         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1092 
1093         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1094         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1095 
1096         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1097         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1098 
1099         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1100         // This is to verify that the computed args match with the ones specified in the query.
1101         bytes memory commitmentSlice1 = new bytes(8+1+32);
1102         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1103 
1104         bytes memory sessionPubkey = new bytes(64);
1105         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1106         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1107 
1108         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1109         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1110             delete oraclize_randomDS_args[queryId];
1111         } else return false;
1112 
1113 
1114         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1115         bytes memory tosign1 = new bytes(32+8+1+32);
1116         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1117         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1118 
1119         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1120         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1121             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1122         }
1123 
1124         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1125     }
1126 
1127     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1128     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1129         uint minLength = length + toOffset;
1130 
1131         // Buffer too small
1132         require(to.length >= minLength); // Should be a better way?
1133 
1134         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1135         uint i = 32 + fromOffset;
1136         uint j = 32 + toOffset;
1137 
1138         while (i < (32 + fromOffset + length)) {
1139             assembly {
1140                 let tmp := mload(add(from, i))
1141                 mstore(add(to, j), tmp)
1142             }
1143             i += 32;
1144             j += 32;
1145         }
1146 
1147         return to;
1148     }
1149 
1150     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1151     // Duplicate Solidity's ecrecover, but catching the CALL return value
1152     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1153         // We do our own memory management here. Solidity uses memory offset
1154         // 0x40 to store the current end of memory. We write past it (as
1155         // writes are memory extensions), but don't update the offset so
1156         // Solidity will reuse it. The memory used here is only needed for
1157         // this context.
1158 
1159         // FIXME: inline assembly can't access return values
1160         bool ret;
1161         address addr;
1162 
1163         assembly {
1164             let size := mload(0x40)
1165             mstore(size, hash)
1166             mstore(add(size, 32), v)
1167             mstore(add(size, 64), r)
1168             mstore(add(size, 96), s)
1169 
1170             // NOTE: we can reuse the request memory because we deal with
1171             //       the return code
1172             ret := call(3000, 1, 0, size, 128, size, 32)
1173             addr := mload(size)
1174         }
1175 
1176         return (ret, addr);
1177     }
1178 
1179     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1180     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1181         bytes32 r;
1182         bytes32 s;
1183         uint8 v;
1184 
1185         if (sig.length != 65)
1186           return (false, 0);
1187 
1188         // The signature format is a compact form of:
1189         //   {bytes32 r}{bytes32 s}{uint8 v}
1190         // Compact means, uint8 is not padded to 32 bytes.
1191         assembly {
1192             r := mload(add(sig, 32))
1193             s := mload(add(sig, 64))
1194 
1195             // Here we are loading the last 32 bytes. We exploit the fact that
1196             // 'mload' will pad with zeroes if we overread.
1197             // There is no 'mload8' to do this, but that would be nicer.
1198             v := byte(0, mload(add(sig, 96)))
1199 
1200             // Alternative solution:
1201             // 'byte' is not working due to the Solidity parser, so lets
1202             // use the second best option, 'and'
1203             // v := and(mload(add(sig, 65)), 255)
1204         }
1205 
1206         // albeit non-transactional signatures are not specified by the YP, one would expect it
1207         // to match the YP range of [27, 28]
1208         //
1209         // geth uses [0, 1] and some clients have followed. This might change, see:
1210         //  https://github.com/ethereum/go-ethereum/issues/2053
1211         if (v < 27)
1212           v += 27;
1213 
1214         if (v != 27 && v != 28)
1215             return (false, 0);
1216 
1217         return safer_ecrecover(hash, v, r, s);
1218     }
1219 
1220     function safeMemoryCleaner() internal pure {
1221         assembly {
1222             let fmem := mload(0x40)
1223             codecopy(fmem, codesize, sub(msize, fmem))
1224         }
1225     }
1226 
1227 }
1228 // </ORACLIZE_API>
1229 
1230 interface GreenRabbitKingdom {
1231     function attackKingdom(address invader, uint256 random) external returns(bool);
1232 }
1233 
1234 contract GreenRabbitInvader is usingOraclize {
1235     
1236     address admin;
1237 	address kingdomAddress;
1238 	uint attackCost = 0.01 ether;
1239 	uint gasLimit;
1240 	mapping (bytes32 => address) private kingdomInvaders;
1241 
1242     modifier onlyAdmin() {
1243         require(msg.sender == admin);
1244         _;
1245     }
1246 
1247     constructor() public {
1248 		admin = msg.sender;
1249 		gasLimit = 200000;
1250         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1251     }
1252 	
1253     function() external payable {
1254         attackKingdom();
1255     }	
1256     
1257     // the callback function is called by Oraclize when the result is ready
1258     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1259     // the proof validity is fully verified on-chain
1260     function __callback(bytes32 _queryId, string _result, bytes _proof) public
1261     { 
1262         require (msg.sender == oraclize_cbAddress());
1263         
1264         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
1265             // the proof verification has passed
1266             // now that we know that the random number was safely generated, let's use it..
1267             // for simplicity of use, let's also convert the random bytes to uint if we need
1268             uint maxRange = 2**(8* 7); // [maxRange - 1] is the highest uint we want to get.The variable maxRange should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
1269             uint randomNumber = uint(keccak256(abi.encodePacked(_result))) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange-1] range
1270 			
1271 			GreenRabbitKingdom kingdom;
1272 
1273 			kingdom = GreenRabbitKingdom(kingdomAddress); 
1274 			
1275 			require(kingdom.attackKingdom(kingdomInvaders[_queryId], randomNumber));
1276         }
1277     }
1278     
1279     function attackKingdom() payable public {
1280 		require (msg.value == attackCost);
1281 		
1282         uint N = 7; // number of random bytes we want the datasource to return
1283         uint delay = 0; // number of seconds to wait before the execution takes place
1284         uint callbackGas = gasLimit; // amount of gas we want Oraclize to set for the callback function
1285         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
1286 		kingdomInvaders[queryId] = msg.sender;
1287     }
1288 	
1289 	function setKingdomAddress (address _address) public onlyAdmin {
1290 		// only one time
1291 	    require (kingdomAddress == address(0));
1292 		kingdomAddress = _address;
1293 	}
1294 	
1295 	function setGasLimit (uint _gasLimit) public onlyAdmin {
1296 		require (_gasLimit > 200000);
1297 		gasLimit = _gasLimit;
1298 	}	
1299 	
1300 	function withdraw() public onlyAdmin {
1301 		//Remainder of attack payment is admin fee
1302 		msg.sender.transfer(address(this).balance);
1303 	}  	
1304     
1305 }