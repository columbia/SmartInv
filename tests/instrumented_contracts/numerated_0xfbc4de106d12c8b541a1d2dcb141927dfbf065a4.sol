1 pragma solidity ^0.4.16;
2 
3 
4  // METADOLLAR (DOL) VAULT - COPYRIGHT 2018 METADOLLAR.ORG
5  // ERC Token Standard #20 Interface
6  // https://github.com/ethereum/EIPs/issues/20
7  
8  contract OraclizeI {
9     address public cbAddress;
10     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
11     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
12     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
13     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
14     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
15     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
16     function getPrice(string _datasource) public returns (uint _dsprice);
17     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
18     function setProofType(byte _proofType) external;
19     function setCustomGasPrice(uint _gasPrice) external;
20     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
21 }
22 
23 contract OraclizeAddrResolverI {
24     function getAddress() public returns (address _addr);
25 }
26 
27 /*
28 Begin solidity-cborutils
29 
30 https://github.com/smartcontractkit/solidity-cborutils
31 
32 MIT License
33 
34 Copyright (c) 2018 SmartContract ChainLink, Ltd.
35 
36 Permission is hereby granted, free of charge, to any person obtaining a copy
37 of this software and associated documentation files (the "Software"), to deal
38 in the Software without restriction, including without limitation the rights
39 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
40 copies of the Software, and to permit persons to whom the Software is
41 furnished to do so, subject to the following conditions:
42 
43 The above copyright notice and this permission notice shall be included in all
44 copies or substantial portions of the Software.
45 
46 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
47 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
48 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
49 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
50 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
51 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
52 SOFTWARE.
53  */
54 
55 library Buffer {
56     struct buffer {
57         bytes buf;
58         uint capacity;
59     }
60 
61     function init(buffer memory buf, uint capacity) internal pure {
62         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
63         // Allocate space for the buffer data
64         buf.capacity = capacity;
65         assembly {
66             let ptr := mload(0x40)
67             mstore(buf, ptr)
68             mstore(0x40, add(ptr, capacity))
69         }
70     }
71 
72     function resize(buffer memory buf, uint capacity) private pure {
73         bytes memory oldbuf = buf.buf;
74         init(buf, capacity);
75         append(buf, oldbuf);
76     }
77 
78     function max(uint a, uint b) private pure returns(uint) {
79         if(a > b) {
80             return a;
81         }
82         return b;
83     }
84 
85     /**
86      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
87      *      would exceed the capacity of the buffer.
88      * @param buf The buffer to append to.
89      * @param data The data to append.
90      * @return The original buffer.
91      */
92     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
93         if(data.length + buf.buf.length > buf.capacity) {
94             resize(buf, max(buf.capacity, data.length) * 2);
95         }
96 
97         uint dest;
98         uint src;
99         uint len = data.length;
100         assembly {
101             // Memory address of the buffer data
102             let bufptr := mload(buf)
103             // Length of existing buffer data
104             let buflen := mload(bufptr)
105             // Start address = buffer address + buffer length + sizeof(buffer length)
106             dest := add(add(bufptr, buflen), 32)
107             // Update buffer length
108             mstore(bufptr, add(buflen, mload(data)))
109             src := add(data, 32)
110         }
111 
112         // Copy word-length chunks while possible
113         for(; len >= 32; len -= 32) {
114             assembly {
115                 mstore(dest, mload(src))
116             }
117             dest += 32;
118             src += 32;
119         }
120 
121         // Copy remaining bytes
122         uint mask = 256 ** (32 - len) - 1;
123         assembly {
124             let srcpart := and(mload(src), not(mask))
125             let destpart := and(mload(dest), mask)
126             mstore(dest, or(destpart, srcpart))
127         }
128 
129         return buf;
130     }
131 
132     /**
133      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
134      * exceed the capacity of the buffer.
135      * @param buf The buffer to append to.
136      * @param data The data to append.
137      * @return The original buffer.
138      */
139     function append(buffer memory buf, uint8 data) internal pure {
140         if(buf.buf.length + 1 > buf.capacity) {
141             resize(buf, buf.capacity * 2);
142         }
143 
144         assembly {
145             // Memory address of the buffer data
146             let bufptr := mload(buf)
147             // Length of existing buffer data
148             let buflen := mload(bufptr)
149             // Address = buffer address + buffer length + sizeof(buffer length)
150             let dest := add(add(bufptr, buflen), 32)
151             mstore8(dest, data)
152             // Update buffer length
153             mstore(bufptr, add(buflen, 1))
154         }
155     }
156 
157     /**
158      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
159      * exceed the capacity of the buffer.
160      * @param buf The buffer to append to.
161      * @param data The data to append.
162      * @return The original buffer.
163      */
164     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
165         if(len + buf.buf.length > buf.capacity) {
166             resize(buf, max(buf.capacity, len) * 2);
167         }
168 
169         uint mask = 256 ** len - 1;
170         assembly {
171             // Memory address of the buffer data
172             let bufptr := mload(buf)
173             // Length of existing buffer data
174             let buflen := mload(bufptr)
175             // Address = buffer address + buffer length + sizeof(buffer length) + len
176             let dest := add(add(bufptr, buflen), len)
177             mstore(dest, or(and(mload(dest), not(mask)), data))
178             // Update buffer length
179             mstore(bufptr, add(buflen, len))
180         }
181         return buf;
182     }
183 }
184 
185 library CBOR {
186     using Buffer for Buffer.buffer;
187 
188     uint8 private constant MAJOR_TYPE_INT = 0;
189     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
190     uint8 private constant MAJOR_TYPE_BYTES = 2;
191     uint8 private constant MAJOR_TYPE_STRING = 3;
192     uint8 private constant MAJOR_TYPE_ARRAY = 4;
193     uint8 private constant MAJOR_TYPE_MAP = 5;
194     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
195 
196     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
197         if(value <= 23) {
198             buf.append(uint8((major << 5) | value));
199         } else if(value <= 0xFF) {
200             buf.append(uint8((major << 5) | 24));
201             buf.appendInt(value, 1);
202         } else if(value <= 0xFFFF) {
203             buf.append(uint8((major << 5) | 25));
204             buf.appendInt(value, 2);
205         } else if(value <= 0xFFFFFFFF) {
206             buf.append(uint8((major << 5) | 26));
207             buf.appendInt(value, 4);
208         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
209             buf.append(uint8((major << 5) | 27));
210             buf.appendInt(value, 8);
211         }
212     }
213 
214     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
215         buf.append(uint8((major << 5) | 31));
216     }
217 
218     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
219         encodeType(buf, MAJOR_TYPE_INT, value);
220     }
221 
222     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
223         if(value >= 0) {
224             encodeType(buf, MAJOR_TYPE_INT, uint(value));
225         } else {
226             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
227         }
228     }
229 
230     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
231         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
232         buf.append(value);
233     }
234 
235     function encodeString(Buffer.buffer memory buf, string value) internal pure {
236         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
237         buf.append(bytes(value));
238     }
239 
240     function startArray(Buffer.buffer memory buf) internal pure {
241         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
242     }
243 
244     function startMap(Buffer.buffer memory buf) internal pure {
245         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
246     }
247 
248     function endSequence(Buffer.buffer memory buf) internal pure {
249         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
250     }
251 }
252 
253 /*
254 End solidity-cborutils
255  */
256 
257 contract usingOraclize {
258     uint constant day = 60*60*24;
259     uint constant week = 60*60*24*7;
260     uint constant month = 60*60*24*30;
261     byte constant proofType_NONE = 0x00;
262     byte constant proofType_TLSNotary = 0x10;
263     byte constant proofType_Android = 0x20;
264     byte constant proofType_Ledger = 0x30;
265     byte constant proofType_Native = 0xF0;
266     byte constant proofStorage_IPFS = 0x01;
267     uint8 constant networkID_auto = 0;
268     uint8 constant networkID_mainnet = 1;
269     uint8 constant networkID_testnet = 2;
270     uint8 constant networkID_morden = 2;
271     uint8 constant networkID_consensys = 161;
272 
273     OraclizeAddrResolverI OAR;
274 
275     OraclizeI oraclize;
276     modifier oraclizeAPI {
277         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
278             oraclize_setNetwork(networkID_auto);
279 
280         if(address(oraclize) != OAR.getAddress())
281             oraclize = OraclizeI(OAR.getAddress());
282 
283         _;
284     }
285     modifier coupon(string code){
286         oraclize = OraclizeI(OAR.getAddress());
287         _;
288     }
289 
290     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
291       return oraclize_setNetwork();
292       networkID; // silence the warning and remain backwards compatible
293     }
294     function oraclize_setNetwork() internal returns(bool){
295         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
296             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
297             oraclize_setNetworkName("eth_mainnet");
298             return true;
299         }
300         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
301             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
302             oraclize_setNetworkName("eth_ropsten3");
303             return true;
304         }
305         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
306             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
307             oraclize_setNetworkName("eth_kovan");
308             return true;
309         }
310         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
311             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
312             oraclize_setNetworkName("eth_rinkeby");
313             return true;
314         }
315         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
316             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
317             return true;
318         }
319         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
320             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
321             return true;
322         }
323         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
324             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
325             return true;
326         }
327         return false;
328     }
329 
330     function __callback(bytes32 myid, string result) public {
331         __callback(myid, result, new bytes(0));
332     }
333     function __callback(bytes32 myid, string result, bytes proof) public {
334       return;
335       myid; result; proof; // Silence compiler warnings
336     }
337 
338     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
339         return oraclize.getPrice(datasource);
340     }
341 
342     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
343         return oraclize.getPrice(datasource, gaslimit);
344     }
345 
346     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
347         uint price = oraclize.getPrice(datasource);
348         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
349         return oraclize.query.value(price)(0, datasource, arg);
350     }
351     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
352         uint price = oraclize.getPrice(datasource);
353         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
354         return oraclize.query.value(price)(timestamp, datasource, arg);
355     }
356     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource, gaslimit);
358         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
359         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
360     }
361     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
362         uint price = oraclize.getPrice(datasource, gaslimit);
363         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
364         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
365     }
366     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource);
368         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
369         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
370     }
371     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
372         uint price = oraclize.getPrice(datasource);
373         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
374         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
375     }
376     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
380     }
381     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource, gaslimit);
383         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
384         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
385     }
386     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource);
388         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
389         bytes memory args = stra2cbor(argN);
390         return oraclize.queryN.value(price)(0, datasource, args);
391     }
392     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
393         uint price = oraclize.getPrice(datasource);
394         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
395         bytes memory args = stra2cbor(argN);
396         return oraclize.queryN.value(price)(timestamp, datasource, args);
397     }
398     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource, gaslimit);
400         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
401         bytes memory args = stra2cbor(argN);
402         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
403     }
404     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource, gaslimit);
406         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
407         bytes memory args = stra2cbor(argN);
408         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
409     }
410     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
411         string[] memory dynargs = new string[](1);
412         dynargs[0] = args[0];
413         return oraclize_query(datasource, dynargs);
414     }
415     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
416         string[] memory dynargs = new string[](1);
417         dynargs[0] = args[0];
418         return oraclize_query(timestamp, datasource, dynargs);
419     }
420     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
421         string[] memory dynargs = new string[](1);
422         dynargs[0] = args[0];
423         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
424     }
425     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
426         string[] memory dynargs = new string[](1);
427         dynargs[0] = args[0];
428         return oraclize_query(datasource, dynargs, gaslimit);
429     }
430 
431     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
432         string[] memory dynargs = new string[](2);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         return oraclize_query(datasource, dynargs);
436     }
437     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
438         string[] memory dynargs = new string[](2);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         return oraclize_query(timestamp, datasource, dynargs);
442     }
443     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
444         string[] memory dynargs = new string[](2);
445         dynargs[0] = args[0];
446         dynargs[1] = args[1];
447         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
448     }
449     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
450         string[] memory dynargs = new string[](2);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         return oraclize_query(datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](3);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         dynargs[2] = args[2];
460         return oraclize_query(datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](3);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         return oraclize_query(timestamp, datasource, dynargs);
468     }
469     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         string[] memory dynargs = new string[](3);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
475     }
476     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
477         string[] memory dynargs = new string[](3);
478         dynargs[0] = args[0];
479         dynargs[1] = args[1];
480         dynargs[2] = args[2];
481         return oraclize_query(datasource, dynargs, gaslimit);
482     }
483 
484     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](4);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         dynargs[3] = args[3];
490         return oraclize_query(datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
493         string[] memory dynargs = new string[](4);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         dynargs[3] = args[3];
498         return oraclize_query(timestamp, datasource, dynargs);
499     }
500     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](4);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         dynargs[3] = args[3];
506         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
507     }
508     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](4);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         dynargs[3] = args[3];
514         return oraclize_query(datasource, dynargs, gaslimit);
515     }
516     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](5);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         dynargs[3] = args[3];
522         dynargs[4] = args[4];
523         return oraclize_query(datasource, dynargs);
524     }
525     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
526         string[] memory dynargs = new string[](5);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         dynargs[2] = args[2];
530         dynargs[3] = args[3];
531         dynargs[4] = args[4];
532         return oraclize_query(timestamp, datasource, dynargs);
533     }
534     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](5);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         dynargs[4] = args[4];
541         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
542     }
543     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](5);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         dynargs[4] = args[4];
550         return oraclize_query(datasource, dynargs, gaslimit);
551     }
552     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
553         uint price = oraclize.getPrice(datasource);
554         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
555         bytes memory args = ba2cbor(argN);
556         return oraclize.queryN.value(price)(0, datasource, args);
557     }
558     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
559         uint price = oraclize.getPrice(datasource);
560         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
561         bytes memory args = ba2cbor(argN);
562         return oraclize.queryN.value(price)(timestamp, datasource, args);
563     }
564     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
565         uint price = oraclize.getPrice(datasource, gaslimit);
566         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
567         bytes memory args = ba2cbor(argN);
568         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
569     }
570     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
571         uint price = oraclize.getPrice(datasource, gaslimit);
572         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
573         bytes memory args = ba2cbor(argN);
574         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
575     }
576     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
577         bytes[] memory dynargs = new bytes[](1);
578         dynargs[0] = args[0];
579         return oraclize_query(datasource, dynargs);
580     }
581     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
582         bytes[] memory dynargs = new bytes[](1);
583         dynargs[0] = args[0];
584         return oraclize_query(timestamp, datasource, dynargs);
585     }
586     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         bytes[] memory dynargs = new bytes[](1);
588         dynargs[0] = args[0];
589         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
590     }
591     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
592         bytes[] memory dynargs = new bytes[](1);
593         dynargs[0] = args[0];
594         return oraclize_query(datasource, dynargs, gaslimit);
595     }
596 
597     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
598         bytes[] memory dynargs = new bytes[](2);
599         dynargs[0] = args[0];
600         dynargs[1] = args[1];
601         return oraclize_query(datasource, dynargs);
602     }
603     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](2);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         return oraclize_query(timestamp, datasource, dynargs);
608     }
609     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
610         bytes[] memory dynargs = new bytes[](2);
611         dynargs[0] = args[0];
612         dynargs[1] = args[1];
613         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
614     }
615     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
616         bytes[] memory dynargs = new bytes[](2);
617         dynargs[0] = args[0];
618         dynargs[1] = args[1];
619         return oraclize_query(datasource, dynargs, gaslimit);
620     }
621     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](3);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         dynargs[2] = args[2];
626         return oraclize_query(datasource, dynargs);
627     }
628     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](3);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         dynargs[2] = args[2];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         bytes[] memory dynargs = new bytes[](3);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         dynargs[2] = args[2];
640         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
641     }
642     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
643         bytes[] memory dynargs = new bytes[](3);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         dynargs[2] = args[2];
647         return oraclize_query(datasource, dynargs, gaslimit);
648     }
649 
650     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](4);
652         dynargs[0] = args[0];
653         dynargs[1] = args[1];
654         dynargs[2] = args[2];
655         dynargs[3] = args[3];
656         return oraclize_query(datasource, dynargs);
657     }
658     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
659         bytes[] memory dynargs = new bytes[](4);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         dynargs[2] = args[2];
663         dynargs[3] = args[3];
664         return oraclize_query(timestamp, datasource, dynargs);
665     }
666     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](4);
668         dynargs[0] = args[0];
669         dynargs[1] = args[1];
670         dynargs[2] = args[2];
671         dynargs[3] = args[3];
672         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
673     }
674     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](4);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         dynargs[3] = args[3];
680         return oraclize_query(datasource, dynargs, gaslimit);
681     }
682     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](5);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         dynargs[4] = args[4];
689         return oraclize_query(datasource, dynargs);
690     }
691     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
692         bytes[] memory dynargs = new bytes[](5);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         dynargs[4] = args[4];
698         return oraclize_query(timestamp, datasource, dynargs);
699     }
700     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](5);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         dynargs[4] = args[4];
707         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
708     }
709     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](5);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         dynargs[3] = args[3];
715         dynargs[4] = args[4];
716         return oraclize_query(datasource, dynargs, gaslimit);
717     }
718 
719     function oraclize_cbAddress() oraclizeAPI internal returns (address){
720         return oraclize.cbAddress();
721     }
722     function oraclize_setProof(byte proofP) oraclizeAPI internal {
723         return oraclize.setProofType(proofP);
724     }
725     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
726         return oraclize.setCustomGasPrice(gasPrice);
727     }
728 
729     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
730         return oraclize.randomDS_getSessionPubKeyHash();
731     }
732 
733     function getCodeSize(address _addr) constant internal returns(uint _size) {
734         assembly {
735             _size := extcodesize(_addr)
736         }
737     }
738 
739     function parseAddr(string _a) internal pure returns (address){
740         bytes memory tmp = bytes(_a);
741         uint160 iaddr = 0;
742         uint160 b1;
743         uint160 b2;
744         for (uint i=2; i<2+2*20; i+=2){
745             iaddr *= 256;
746             b1 = uint160(tmp[i]);
747             b2 = uint160(tmp[i+1]);
748             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
749             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
750             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
751             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
752             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
753             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
754             iaddr += (b1*16+b2);
755         }
756         return address(iaddr);
757     }
758 
759     function strCompare(string _a, string _b) internal pure returns (int) {
760         bytes memory a = bytes(_a);
761         bytes memory b = bytes(_b);
762         uint minLength = a.length;
763         if (b.length < minLength) minLength = b.length;
764         for (uint i = 0; i < minLength; i ++)
765             if (a[i] < b[i])
766                 return -1;
767             else if (a[i] > b[i])
768                 return 1;
769         if (a.length < b.length)
770             return -1;
771         else if (a.length > b.length)
772             return 1;
773         else
774             return 0;
775     }
776 
777     function indexOf(string _haystack, string _needle) internal pure returns (int) {
778         bytes memory h = bytes(_haystack);
779         bytes memory n = bytes(_needle);
780         if(h.length < 1 || n.length < 1 || (n.length > h.length))
781             return -1;
782         else if(h.length > (2**128 -1))
783             return -1;
784         else
785         {
786             uint subindex = 0;
787             for (uint i = 0; i < h.length; i ++)
788             {
789                 if (h[i] == n[0])
790                 {
791                     subindex = 1;
792                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
793                     {
794                         subindex++;
795                     }
796                     if(subindex == n.length)
797                         return int(i);
798                 }
799             }
800             return -1;
801         }
802     }
803 
804     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
805         bytes memory _ba = bytes(_a);
806         bytes memory _bb = bytes(_b);
807         bytes memory _bc = bytes(_c);
808         bytes memory _bd = bytes(_d);
809         bytes memory _be = bytes(_e);
810         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
811         bytes memory babcde = bytes(abcde);
812         uint k = 0;
813         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
814         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
815         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
816         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
817         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
818         return string(babcde);
819     }
820 
821     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
822         return strConcat(_a, _b, _c, _d, "");
823     }
824 
825     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
826         return strConcat(_a, _b, _c, "", "");
827     }
828 
829     function strConcat(string _a, string _b) internal pure returns (string) {
830         return strConcat(_a, _b, "", "", "");
831     }
832 
833     // parseInt
834     function parseInt(string _a) internal pure returns (uint) {
835         return parseInt(_a, 0);
836     }
837 
838     // parseInt(parseFloat*10^_b)
839     function parseInt(string _a, uint _b) internal pure returns (uint) {
840         bytes memory bresult = bytes(_a);
841         uint mint = 0;
842         bool decimals = false;
843         for (uint i=0; i<bresult.length; i++){
844             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
845                 if (decimals){
846                    if (_b == 0) break;
847                     else _b--;
848                 }
849                 mint *= 10;
850                 mint += uint(bresult[i]) - 48;
851             } else if (bresult[i] == 46) decimals = true;
852         }
853         if (_b > 0) mint *= 10**_b;
854         return mint;
855     }
856 
857     function uint2str(uint i) internal pure returns (string){
858         if (i == 0) return "0";
859         uint j = i;
860         uint len;
861         while (j != 0){
862             len++;
863             j /= 10;
864         }
865         bytes memory bstr = new bytes(len);
866         uint k = len - 1;
867         while (i != 0){
868             bstr[k--] = byte(48 + i % 10);
869             i /= 10;
870         }
871         return string(bstr);
872     }
873 
874     using CBOR for Buffer.buffer;
875     function stra2cbor(string[] arr) internal pure returns (bytes) {
876         Buffer.buffer memory buf;
877         Buffer.init(buf, 1024);
878         buf.startArray();
879         for (uint i = 0; i < arr.length; i++) {
880             buf.encodeString(arr[i]);
881         }
882         buf.endSequence();
883         return buf.buf;
884     }
885 
886     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
887         Buffer.buffer memory buf;
888         Buffer.init(buf, 1024);
889         buf.startArray();
890         for (uint i = 0; i < arr.length; i++) {
891             buf.encodeBytes(arr[i]);
892         }
893         buf.endSequence();
894         return buf.buf;
895     }
896 
897     string oraclize_network_name;
898     function oraclize_setNetworkName(string _network_name) internal {
899         oraclize_network_name = _network_name;
900     }
901 
902     function oraclize_getNetworkName() internal view returns (string) {
903         return oraclize_network_name;
904     }
905 
906     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
907         require((_nbytes > 0) && (_nbytes <= 32));
908         // Convert from seconds to ledger timer ticks
909         _delay *= 10;
910         bytes memory nbytes = new bytes(1);
911         nbytes[0] = byte(_nbytes);
912         bytes memory unonce = new bytes(32);
913         bytes memory sessionKeyHash = new bytes(32);
914         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
915         assembly {
916             mstore(unonce, 0x20)
917             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
918             mstore(sessionKeyHash, 0x20)
919             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
920         }
921         bytes memory delay = new bytes(32);
922         assembly {
923             mstore(add(delay, 0x20), _delay)
924         }
925 
926         bytes memory delay_bytes8 = new bytes(8);
927         copyBytes(delay, 24, 8, delay_bytes8, 0);
928 
929         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
930         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
931 
932         bytes memory delay_bytes8_left = new bytes(8);
933 
934         assembly {
935             let x := mload(add(delay_bytes8, 0x20))
936             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
937             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
938             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
939             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
940             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
941             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
942             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
943             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
944 
945         }
946 
947         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
948         return queryId;
949     }
950 
951     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
952         oraclize_randomDS_args[queryId] = commitment;
953     }
954 
955     mapping(bytes32=>bytes32) oraclize_randomDS_args;
956     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
957 
958     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
959         bool sigok;
960         address signer;
961 
962         bytes32 sigr;
963         bytes32 sigs;
964 
965         bytes memory sigr_ = new bytes(32);
966         uint offset = 4+(uint(dersig[3]) - 0x20);
967         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
968         bytes memory sigs_ = new bytes(32);
969         offset += 32 + 2;
970         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
971 
972         assembly {
973             sigr := mload(add(sigr_, 32))
974             sigs := mload(add(sigs_, 32))
975         }
976 
977 
978         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
979         if (address(keccak256(pubkey)) == signer) return true;
980         else {
981             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
982             return (address(keccak256(pubkey)) == signer);
983         }
984     }
985 
986     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
987         bool sigok;
988 
989         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
990         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
991         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
992 
993         bytes memory appkey1_pubkey = new bytes(64);
994         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
995 
996         bytes memory tosign2 = new bytes(1+65+32);
997         tosign2[0] = byte(1); //role
998         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
999         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1000         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1001         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1002 
1003         if (sigok == false) return false;
1004 
1005 
1006         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1007         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1008 
1009         bytes memory tosign3 = new bytes(1+65);
1010         tosign3[0] = 0xFE;
1011         copyBytes(proof, 3, 65, tosign3, 1);
1012 
1013         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1014         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1015 
1016         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1017 
1018         return sigok;
1019     }
1020 
1021     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1022         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1023         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1024 
1025         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1026         require(proofVerified);
1027 
1028         _;
1029     }
1030 
1031     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1032         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1033         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1034 
1035         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1036         if (proofVerified == false) return 2;
1037 
1038         return 0;
1039     }
1040 
1041     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1042         bool match_ = true;
1043 
1044         require(prefix.length == n_random_bytes);
1045 
1046         for (uint256 i=0; i< n_random_bytes; i++) {
1047             if (content[i] != prefix[i]) match_ = false;
1048         }
1049 
1050         return match_;
1051     }
1052 
1053     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1054 
1055         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1056         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1057         bytes memory keyhash = new bytes(32);
1058         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1059         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1060 
1061         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1062         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1063 
1064         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1065         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1066 
1067         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1068         // This is to verify that the computed args match with the ones specified in the query.
1069         bytes memory commitmentSlice1 = new bytes(8+1+32);
1070         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1071 
1072         bytes memory sessionPubkey = new bytes(64);
1073         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1074         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1075 
1076         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1077         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1078             delete oraclize_randomDS_args[queryId];
1079         } else return false;
1080 
1081 
1082         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1083         bytes memory tosign1 = new bytes(32+8+1+32);
1084         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1085         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1086 
1087         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1088         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1089             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1090         }
1091 
1092         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1093     }
1094 
1095     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1096     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1097         uint minLength = length + toOffset;
1098 
1099         // Buffer too small
1100         require(to.length >= minLength); // Should be a better way?
1101 
1102         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1103         uint i = 32 + fromOffset;
1104         uint j = 32 + toOffset;
1105 
1106         while (i < (32 + fromOffset + length)) {
1107             assembly {
1108                 let tmp := mload(add(from, i))
1109                 mstore(add(to, j), tmp)
1110             }
1111             i += 32;
1112             j += 32;
1113         }
1114 
1115         return to;
1116     }
1117 
1118     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1119     // Duplicate Solidity's ecrecover, but catching the CALL return value
1120     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1121         // We do our own memory management here. Solidity uses memory offset
1122         // 0x40 to store the current end of memory. We write past it (as
1123         // writes are memory extensions), but don't update the offset so
1124         // Solidity will reuse it. The memory used here is only needed for
1125         // this context.
1126 
1127         // FIXME: inline assembly can't access return values
1128         bool ret;
1129         address addr;
1130 
1131         assembly {
1132             let size := mload(0x40)
1133             mstore(size, hash)
1134             mstore(add(size, 32), v)
1135             mstore(add(size, 64), r)
1136             mstore(add(size, 96), s)
1137 
1138             // NOTE: we can reuse the request memory because we deal with
1139             //       the return code
1140             ret := call(3000, 1, 0, size, 128, size, 32)
1141             addr := mload(size)
1142         }
1143 
1144         return (ret, addr);
1145     }
1146 
1147     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1148     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1149         bytes32 r;
1150         bytes32 s;
1151         uint8 v;
1152 
1153         if (sig.length != 65)
1154           return (false, 0);
1155 
1156         // The signature format is a compact form of:
1157         //   {bytes32 r}{bytes32 s}{uint8 v}
1158         // Compact means, uint8 is not padded to 32 bytes.
1159         assembly {
1160             r := mload(add(sig, 32))
1161             s := mload(add(sig, 64))
1162 
1163             // Here we are loading the last 32 bytes. We exploit the fact that
1164             // 'mload' will pad with zeroes if we overread.
1165             // There is no 'mload8' to do this, but that would be nicer.
1166             v := byte(0, mload(add(sig, 96)))
1167 
1168             // Alternative solution:
1169             // 'byte' is not working due to the Solidity parser, so lets
1170             // use the second best option, 'and'
1171             // v := and(mload(add(sig, 65)), 255)
1172         }
1173 
1174         // albeit non-transactional signatures are not specified by the YP, one would expect it
1175         // to match the YP range of [27, 28]
1176         //
1177         // geth uses [0, 1] and some clients have followed. This might change, see:
1178         //  https://github.com/ethereum/go-ethereum/issues/2053
1179         if (v < 27)
1180           v += 27;
1181 
1182         if (v != 27 && v != 28)
1183             return (false, 0);
1184 
1185         return safer_ecrecover(hash, v, r, s);
1186     }
1187 
1188 }
1189 
1190  
1191 contract SafeMath {
1192   function safeMul(uint a, uint b) internal returns (uint) {
1193     uint c = a * b;
1194     assert(a == 0 || c / a == b);
1195     return c;
1196   }
1197 
1198   function safeSub(uint a, uint b) internal returns (uint) {
1199     assert(b <= a);
1200     return a - b;
1201   }
1202 
1203   function safeAdd(uint a, uint b) internal returns (uint) {
1204     uint c = a + b;
1205     assert(c>=a && c>=b);
1206     return c;
1207   }
1208 
1209   function assert(bool assertion) internal {
1210     if (!assertion) throw;
1211   }
1212 }
1213 
1214  contract ERC20Interface {
1215 	/// @notice Total supply of Metadollar
1216 	function totalSupply() constant returns (uint256 totalAmount);
1217 
1218 	/// @notice  Get the account balance of another account with address_owner
1219 	function balanceOf(address _owner) constant returns (uint256 balance);
1220 
1221 	/// @notice  Send_value amount of tokens to address_to
1222 	function transfer(address _to, uint256 _value) returns (bool success);
1223 
1224 	/// @notice  Send_value amount of tokens from address_from to address_to
1225 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
1226 
1227 	/// @notice  Allow_spender to withdraw from your account, multiple times, up to the _value amount.
1228 	/// @notice  If this function is called again it overwrites the current allowance with _value.
1229 	function approve(address _spender, uint256 _value) returns (bool success);
1230 
1231 	/// @notice  Returns the amount which _spender is still allowed to withdraw from _owner
1232 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
1233 
1234 	/// @notice  Triggered when tokens are transferred.
1235 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
1236 
1237 	/// @notice  Triggered whenever approve(address _spender, uint256 _value) is called.
1238 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1239  }
1240  
1241  contract owned{
1242 	address public owner;
1243 	address constant supervisor  = 0x772F3122a8687ee3401bafCA91e873CC37106a7A;//0x97f7298435e5a8180747E89DBa7759674c5c35a5;
1244 	
1245 	function owned(){
1246 		owner = msg.sender;
1247 	}
1248 
1249 	/// @notice Functions with this modifier can only be executed by the owner
1250 	modifier isOwner {
1251 		assert(msg.sender == owner || msg.sender == supervisor);
1252 		_;
1253 	}
1254 	
1255 	/// @notice Transfer the ownership of this contract
1256 	function transferOwnership(address newOwner);
1257 	
1258 	event ownerChanged(address whoTransferredOwnership, address formerOwner, address newOwner);
1259  }
1260 
1261 contract METADOLLAR is ERC20Interface, owned, SafeMath, usingOraclize {
1262 
1263 	string public constant name = "METADOLLAR";
1264 	string public constant symbol = "DOL";
1265 	uint public constant decimals = 18;
1266 	uint256 public _totalSupply = 1000000000000000000000000000;
1267 	uint256 public icoMin = 1000000000000000000000000000;
1268 	uint256 public preIcoLimit = 1;
1269 	uint256 public countHolders = 0;				// Number of DOL holders
1270 	uint256 public amountOfInvestments = 0;	// amount of collected wei
1271 	uint256 bank;
1272 	uint256 preICOprice;
1273 	uint256 ICOprice;
1274 	uint256 public currentTokenPrice;				// Current Price of DOL
1275 	uint256 public commRate;
1276 	bool public preIcoIsRunning;
1277 	bool public minimalGoalReached;
1278 	bool public icoIsClosed;
1279 	bool icoExitIsPossible;
1280 	
1281 
1282 	//Balances for each account
1283 	mapping (address => uint256) public tokenBalanceOf;
1284 
1285 	// Owner of account approves the transfer of an amount to another account
1286 	mapping(address => mapping (address => uint256)) allowed;
1287 	
1288 	//list with information about frozen accounts
1289 	mapping(address => bool) frozenAccount;
1290 	
1291 	//this generate a public event on a blockchain that will notify clients
1292 	event FrozenFunds(address initiator, address account, string status);
1293 	
1294 	//this generate a public event on a blockchain that will notify clients
1295 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
1296 	
1297 	//this generate a public event on a blockchain that will notify clients
1298 	event minGoalReached(uint256 minIcoAmount, string notice);
1299 	
1300 	//this generate a public event on a blockchain that will notify clients
1301 	event preIcoEnded(uint256 preIcoAmount, string notice);
1302 	
1303 	//this generate a public event on a blockchain that will notify clients
1304 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
1305 	
1306 	//this generate a public event on a blockchain that will notify clients
1307 	event withdrawed(address _to, uint256 summe, string notice);
1308 	
1309 	//this generate a public event on a blockchain that will notify clients
1310 	event deposited(address _from, uint256 summe, string notice);
1311 	
1312 	//this generate a public event on a blockchain that will notify clients
1313 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
1314 	
1315 	//this generate a public event on a blockchain that will notify clients
1316 	event tokenCreated(address _creator, uint256 summe, string notice);
1317 	
1318 	//this generate a public event on a blockchain that will notify clients
1319 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
1320 	
1321 	//this generate a public event on a blockchain that will notify clients
1322 	event icoStatusUpdated(address _initiator, string status);
1323 
1324 	/// @notice Constructor of the contract
1325 	function METADOLLAR() {
1326 		preIcoIsRunning = false;
1327 		minimalGoalReached = true;
1328 		icoExitIsPossible = false;
1329 		icoIsClosed = false;
1330 		tokenBalanceOf[this] += _totalSupply;
1331 		allowed[this][owner] = _totalSupply;
1332 		allowed[this][supervisor] = _totalSupply;
1333 		currentTokenPrice = 728;
1334 		preICOprice = 780;
1335 		ICOprice = 1;
1336 		commRate = 100;
1337 		updatePrices();
1338 		updateICOPrice();
1339 	}
1340 
1341 	function () payable {
1342 		require(!frozenAccount[msg.sender]);
1343 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
1344 			buyToken();
1345 		}
1346 	}
1347 
1348     	/// @notice Returns a whole amount of DOL
1349 	function totalSupply() constant returns (uint256 totalAmount) {
1350 		totalAmount = _totalSupply;
1351 	}
1352 
1353 	/// @notice What is the balance of a particular account?
1354 	function balanceOf(address _owner) constant returns (uint256 balance) {
1355 		return tokenBalanceOf[_owner];
1356 	}
1357 
1358 	/// @notice Shows how much tokens _spender can spend from _owner address
1359 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1360 		return allowed[_owner][_spender];
1361 	}
1362 	
1363 	/// @notice Calculates amount of ETH needed to buy DOL
1364 	/// @param howManyTokenToBuy - Amount of tokens to calculate
1365 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
1366 		if(howManyTokenToBuy > 0) {
1367 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
1368 		}else {
1369 			summarizedPriceInWeis = 0;
1370 		}
1371 	}
1372 	
1373 	/// @notice Shows if account is frozen
1374 	/// @param account - Accountaddress to check
1375 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
1376 		accountIsFrozen = frozenAccount[account];
1377 	}
1378 
1379 	/// @notice Buy DOL from VAULT by sending ETH
1380 	function buy() payable public {
1381 		require(!frozenAccount[msg.sender]);
1382 		require(msg.value > 0);
1383 		buyToken();
1384 	}
1385 
1386 	/// @notice Sell DOL and receive ETH from VAULT
1387 	function sell(uint256 amount) {
1388 		require(!frozenAccount[msg.sender]);
1389 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
1390 		require(amount > 0);
1391 		require(currentTokenPrice > 0);
1392 		_transfer(msg.sender, this, amount);
1393 		uint256 revenue = amount / currentTokenPrice;
1394 		uint256 detractSell = revenue / commRate;
1395 		require(this.balance >= revenue);
1396 		msg.sender.transfer(revenue - detractSell);  // sends ether to the seller: it's important to do this last to prevent recursion attacks
1397 	}
1398 	
1399 	
1400 	/// @notice Transfer amount of tokens from own wallet to someone else
1401 	function transfer(address _to, uint256 _value) returns (bool success) {
1402 		assert(msg.sender != address(0));
1403 		assert(_to != address(0));
1404 		require(!frozenAccount[msg.sender]);
1405 		require(!frozenAccount[_to]);
1406 		require(tokenBalanceOf[msg.sender] >= _value);
1407 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
1408 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
1409 		require(_value > 0);
1410 		_transfer(msg.sender, _to, _value);
1411 		return true;
1412 	}
1413 
1414 	/// @notice  Send _value amount of tokens from address _from to address _to
1415 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
1416 		assert(msg.sender != address(0));
1417 		assert(_from != address(0));
1418 		assert(_to != address(0));
1419 		require(!frozenAccount[msg.sender]);
1420 		require(!frozenAccount[_from]);
1421 		require(!frozenAccount[_to]);
1422 		require(tokenBalanceOf[_from] >= _value);
1423 		require(allowed[_from][msg.sender] >= _value);
1424 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
1425 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
1426 		require(_value > 0);
1427 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
1428 		_transfer(_from, _to, _value);
1429 		allowed[_from][msg.sender] -= _value;
1430 		return true;
1431 	}
1432 
1433 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1434 	/// @notice If this function is called again it overwrites the current allowance with _value.
1435 	function approve(address _spender, uint256 _value) returns (bool success) {
1436 		require(!frozenAccount[msg.sender]);
1437 		assert(_spender != address(0));
1438 		require(_value >= 0);
1439 		allowed[msg.sender][_spender] = _value;
1440 		return true;
1441 	}
1442 
1443 	/// @notice Check if minimal goal is reached
1444 	function checkMinimalGoal() internal {
1445 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
1446 			minimalGoalReached = true;
1447 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
1448 		}
1449 	}
1450 
1451 	/// @notice Check if service is ended
1452 	function checkPreIcoStatus() internal {
1453 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
1454 			preIcoIsRunning = false;
1455 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
1456 		}
1457 	}
1458 
1459 	/// @notice Processing each buying
1460 	function buyToken() internal {
1461 		uint256 value = msg.value;
1462 		address sender = msg.sender;
1463 		address bank = 0xC51B05696Db965cE6C8efD69Aa1c6BA5540a92d7; // DEPOSIT
1464 		require(!icoIsClosed);
1465 		require(!frozenAccount[sender]);
1466 		require(value > 0);
1467 		require(currentTokenPrice > 0);
1468 		uint256 amount = value * currentTokenPrice;	// calculates amount of tokens
1469 		uint256 detract = amount / commRate;
1470 		uint256 detract2 = value / commRate;
1471 		uint256 finalvalue = value - detract2;
1472 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
1473 		amountOfInvestments = amountOfInvestments + (value);
1474 		updatePrices();
1475 		_transfer(this, sender, amount - detract);
1476 		require(this.balance >= finalvalue);
1477 		bank.transfer(finalvalue);
1478 		if(!minimalGoalReached) {
1479 			checkMinimalGoal();
1480 		}
1481 	
1482 	}
1483 
1484 	/// @notice Internal transfer, can only be called by this contract
1485 	function _transfer(address _from, address _to, uint256 _value) internal {
1486 		assert(_from != address(0));
1487 		assert(_to != address(0));
1488 		require(_value > 0);
1489 		require(tokenBalanceOf[_from] >= _value);
1490 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
1491 		require(!frozenAccount[_from]);
1492 		require(!frozenAccount[_to]);
1493 		if(tokenBalanceOf[_to] == 0){
1494 			countHolders += 1;
1495 		}
1496 		tokenBalanceOf[_from] -= _value;
1497 		if(tokenBalanceOf[_from] == 0){
1498 			countHolders -= 1;
1499 		}
1500 		tokenBalanceOf[_to] += _value;
1501 		allowed[this][owner] = tokenBalanceOf[this];
1502 		allowed[this][supervisor] = tokenBalanceOf[this];
1503 		Transfer(_from, _to, _value);
1504 	}
1505 
1506 	/// @notice Set current DOL prices
1507 	function updatePrices() internal {
1508 		uint256 oldPrice = currentTokenPrice;
1509 		if(preIcoIsRunning) {
1510 			checkPreIcoStatus();
1511 		}
1512 		if(preIcoIsRunning) {
1513 			currentTokenPrice = preICOprice;
1514 		}else{
1515 			currentTokenPrice = ICOprice;
1516 		}
1517 		
1518 		if(oldPrice != currentTokenPrice) {
1519 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
1520 		}
1521 	}
1522 
1523     /// @notice Set current  price rate A
1524 	/// @param priceForPreIcoInWei - is the amount in wei for one token
1525 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
1526 		require(priceForPreIcoInWei > 0);
1527 		require(preICOprice != priceForPreIcoInWei);
1528 		preICOprice = priceForPreIcoInWei;
1529 		updatePrices();
1530 	}
1531 
1532 	/// @notice Set current price rate B
1533 	/// @param priceForIcoInWei - is the amount in wei for one token
1534 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
1535 		require(priceForIcoInWei > 0);
1536 		require(ICOprice != priceForIcoInWei);
1537 		ICOprice = priceForIcoInWei;
1538 		updatePrices();
1539 	}
1540 
1541 	/// @notice Set both prices at the same time
1542 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
1543 	/// @param priceForIcoInWei - Price of the token in ICO
1544 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
1545 		require(priceForPreIcoInWei > 0);
1546 		require(priceForIcoInWei > 0);
1547 		preICOprice = priceForPreIcoInWei;
1548 		ICOprice = priceForIcoInWei;
1549 		updatePrices();
1550 	}
1551 	
1552 	/// @notice Set current Commission Rate
1553 	/// @param newCommRate - is the amount in wei for one token
1554 	function commRate(uint256 newCommRate) isOwner {
1555 		require(newCommRate > 0);
1556 		require(commRate != newCommRate);
1557 		commRate = newCommRate;
1558 		updatePrices();
1559 	}
1560 	
1561 	/// @notice Set New Bank
1562 	/// @param newBank - is the new bank address
1563 	function changeBank(uint256 newBank) isOwner {
1564 		require(bank != newBank);
1565 		bank = newBank;
1566 		updatePrices();
1567 	}
1568     
1569   
1570 
1571 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
1572 	/// @param account - address to be frozen
1573 	/// @param freeze - select is the account frozen or not
1574 	function freezeAccount(address account, bool freeze) isOwner {
1575 		require(account != owner);
1576 		require(account != supervisor);
1577 		frozenAccount[account] = freeze;
1578 		if(freeze) {
1579 			FrozenFunds(msg.sender, account, "Account set frozen!");
1580 		}else {
1581 			FrozenFunds(msg.sender, account, "Account set free for use!");
1582 		}
1583 	}
1584 
1585 	/// @notice Create an amount of DOL
1586 	/// @param amount - DOL to create
1587 	function mintToken(uint256 amount) isOwner {
1588 		require(amount > 0);
1589 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
1590 		require(_totalSupply + amount > _totalSupply);
1591 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
1592 		_totalSupply += amount;
1593 		tokenBalanceOf[this] += amount;
1594 		allowed[this][owner] = tokenBalanceOf[this];
1595 		allowed[this][supervisor] = tokenBalanceOf[this];
1596 		tokenCreated(msg.sender, amount, "Additional tokens created!");
1597 	}
1598 
1599 	/// @notice Destroy an amount of DOL
1600 	/// @param amount - DOL to destroy
1601 	function destroyToken(uint256 amount) isOwner {
1602 		require(amount > 0);
1603 		require(tokenBalanceOf[this] >= amount);
1604 		require(_totalSupply >= amount);
1605 		require(tokenBalanceOf[this] - amount >= 0);
1606 		require(_totalSupply - amount >= 0);
1607 		tokenBalanceOf[this] -= amount;
1608 		_totalSupply -= amount;
1609 		allowed[this][owner] = tokenBalanceOf[this];
1610 		allowed[this][supervisor] = tokenBalanceOf[this];
1611 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
1612 	}
1613 
1614 	/// @notice Transfer the ownership to another account
1615 	/// @param newOwner - address who get the ownership
1616 	function transferOwnership(address newOwner) isOwner {
1617 		assert(newOwner != address(0));
1618 		address oldOwner = owner;
1619 		owner = newOwner;
1620 		ownerChanged(msg.sender, oldOwner, newOwner);
1621 		allowed[this][oldOwner] = 0;
1622 		allowed[this][newOwner] = tokenBalanceOf[this];
1623 	}
1624 
1625 	/// @notice Transfer ether from smartcontract to admin
1626 	function collect() isOwner {
1627         require(this.balance > 0);
1628 		withdraw(this.balance);
1629     }
1630 
1631 	/// @notice Withdraw an amount of ether from VAULT
1632 	/// @param summeInWei - amout to withdraw
1633 	function withdraw(uint256 summeInWei) isOwner {
1634 		uint256 contractbalance = this.balance;
1635 		address sender = msg.sender;
1636 		require(contractbalance >= summeInWei);
1637 		withdrawed(sender, summeInWei, "wei withdrawed");
1638         sender.transfer(summeInWei);
1639 	}
1640 
1641 	/// @notice Deposit an amount of ETH in the VAULT
1642 	function deposit() payable isOwner {
1643 		require(msg.value > 0);
1644 		require(msg.sender.balance >= msg.value);
1645 		deposited(msg.sender, msg.value, "wei deposited");
1646 	}
1647 
1648 
1649 	/// @notice Stop running VAULT
1650 	/// @param icoIsStopped - status if this ICO is stopped
1651 	function stopThisIco(bool icoIsStopped) isOwner {
1652 		require(icoIsClosed != icoIsStopped);
1653 		icoIsClosed = icoIsStopped;
1654 		if(icoIsStopped) {
1655 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
1656 		}else {
1657 			icoStatusUpdated(msg.sender, "Coin offering is running!");
1658 		}
1659 	}
1660 	
1661 	
1662 	// the function for setting of ICOPrice
1663 	function setICOPriceatDollar(uint val){
1664 	    ICOprice = val;
1665 	}
1666 	
1667 	
1668 	event Log(string text);
1669 	
1670 	function __callback(bytes32 _myid, string _result) {
1671         require (msg.sender == oraclize_cbAddress());
1672         Log(_result);
1673         ICOprice = parseInt(_result); // let's save it as $ cents
1674     }
1675     
1676     function updateICOPrice() payable {
1677         Log("Oraclize query was sent, waiting for the answer..");
1678         oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1679     }
1680 }