1 /*! crypto_bets.sol | (c) 2019 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 // <ORACLIZE_API>
6     // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
7     /*
8     Copyright (c) 2015-2016 Oraclize SRL
9     Copyright (c) 2016 Oraclize LTD
10 
11 
12 
13     Permission is hereby granted, free of charge, to any person obtaining a copy
14     of this software and associated documentation files (the "Software"), to deal
15     in the Software without restriction, including without limitation the rights
16     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
17     copies of the Software, and to permit persons to whom the Software is
18     furnished to do so, subject to the following conditions:
19 
20 
21 
22     The above copyright notice and this permission notice shall be included in
23     all copies or substantial portions of the Software.
24 
25 
26 
27     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
30     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
33     THE SOFTWARE.
34     */
35 
36     // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
37 
38     contract OraclizeI {
39         address public cbAddress;
40         function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
41         function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
42         function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
43         function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
44         function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
45         function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
46         function getPrice(string _datasource) public returns (uint _dsprice);
47         function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
48         function setProofType(byte _proofType) external;
49         function setCustomGasPrice(uint _gasPrice) external;
50         function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
51     }
52 
53     contract OraclizeAddrResolverI {
54         function getAddress() public returns (address _addr);
55     }
56 
57     /*
58     Begin solidity-cborutils
59 
60     https://github.com/smartcontractkit/solidity-cborutils
61 
62     MIT License
63 
64     Copyright (c) 2018 SmartContract ChainLink, Ltd.
65 
66     Permission is hereby granted, free of charge, to any person obtaining a copy
67     of this software and associated documentation files (the "Software"), to deal
68     in the Software without restriction, including without limitation the rights
69     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
70     copies of the Software, and to permit persons to whom the Software is
71     furnished to do so, subject to the following conditions:
72 
73     The above copyright notice and this permission notice shall be included in all
74     copies or substantial portions of the Software.
75 
76     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
77     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
78     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
79     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
80     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
81     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
82     SOFTWARE.
83     */
84 
85     library Buffer {
86         struct buffer {
87             bytes buf;
88             uint capacity;
89         }
90 
91         function init(buffer memory buf, uint _capacity) internal pure {
92             uint capacity = _capacity;
93             if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
94             // Allocate space for the buffer data
95             buf.capacity = capacity;
96             assembly {
97                 let ptr := mload(0x40)
98                 mstore(buf, ptr)
99                 mstore(ptr, 0)
100                 mstore(0x40, add(ptr, capacity))
101             }
102         }
103 
104         function resize(buffer memory buf, uint capacity) private pure {
105             bytes memory oldbuf = buf.buf;
106             init(buf, capacity);
107             append(buf, oldbuf);
108         }
109 
110         function max(uint a, uint b) private pure returns(uint) {
111             if(a > b) {
112                 return a;
113             }
114             return b;
115         }
116 
117         /**
118         * @dev Appends a byte array to the end of the buffer. Resizes if doing so
119         *      would exceed the capacity of the buffer.
120         * @param buf The buffer to append to.
121         * @param data The data to append.
122         * @return The original buffer.
123         */
124         function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
125             if(data.length + buf.buf.length > buf.capacity) {
126                 resize(buf, max(buf.capacity, data.length) * 2);
127             }
128 
129             uint dest;
130             uint src;
131             uint len = data.length;
132             assembly {
133                 // Memory address of the buffer data
134                 let bufptr := mload(buf)
135                 // Length of existing buffer data
136                 let buflen := mload(bufptr)
137                 // Start address = buffer address + buffer length + sizeof(buffer length)
138                 dest := add(add(bufptr, buflen), 32)
139                 // Update buffer length
140                 mstore(bufptr, add(buflen, mload(data)))
141                 src := add(data, 32)
142             }
143 
144             // Copy word-length chunks while possible
145             for(; len >= 32; len -= 32) {
146                 assembly {
147                     mstore(dest, mload(src))
148                 }
149                 dest += 32;
150                 src += 32;
151             }
152 
153             // Copy remaining bytes
154             uint mask = 256 ** (32 - len) - 1;
155             assembly {
156                 let srcpart := and(mload(src), not(mask))
157                 let destpart := and(mload(dest), mask)
158                 mstore(dest, or(destpart, srcpart))
159             }
160 
161             return buf;
162         }
163 
164         /**
165         * @dev Appends a byte to the end of the buffer. Resizes if doing so would
166         * exceed the capacity of the buffer.
167         * @param buf The buffer to append to.
168         * @param data The data to append.
169         * @return The original buffer.
170         */
171         function append(buffer memory buf, uint8 data) internal pure {
172             if(buf.buf.length + 1 > buf.capacity) {
173                 resize(buf, buf.capacity * 2);
174             }
175 
176             assembly {
177                 // Memory address of the buffer data
178                 let bufptr := mload(buf)
179                 // Length of existing buffer data
180                 let buflen := mload(bufptr)
181                 // Address = buffer address + buffer length + sizeof(buffer length)
182                 let dest := add(add(bufptr, buflen), 32)
183                 mstore8(dest, data)
184                 // Update buffer length
185                 mstore(bufptr, add(buflen, 1))
186             }
187         }
188 
189         /**
190         * @dev Appends a byte to the end of the buffer. Resizes if doing so would
191         * exceed the capacity of the buffer.
192         * @param buf The buffer to append to.
193         * @param data The data to append.
194         * @return The original buffer.
195         */
196         function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
197             if(len + buf.buf.length > buf.capacity) {
198                 resize(buf, max(buf.capacity, len) * 2);
199             }
200 
201             uint mask = 256 ** len - 1;
202             assembly {
203                 // Memory address of the buffer data
204                 let bufptr := mload(buf)
205                 // Length of existing buffer data
206                 let buflen := mload(bufptr)
207                 // Address = buffer address + buffer length + sizeof(buffer length) + len
208                 let dest := add(add(bufptr, buflen), len)
209                 mstore(dest, or(and(mload(dest), not(mask)), data))
210                 // Update buffer length
211                 mstore(bufptr, add(buflen, len))
212             }
213             return buf;
214         }
215     }
216 
217     library CBOR {
218         using Buffer for Buffer.buffer;
219 
220         uint8 private constant MAJOR_TYPE_INT = 0;
221         uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
222         uint8 private constant MAJOR_TYPE_BYTES = 2;
223         uint8 private constant MAJOR_TYPE_STRING = 3;
224         uint8 private constant MAJOR_TYPE_ARRAY = 4;
225         uint8 private constant MAJOR_TYPE_MAP = 5;
226         uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
227 
228         function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
229             if(value <= 23) {
230                 buf.append(uint8((major << 5) | value));
231             } else if(value <= 0xFF) {
232                 buf.append(uint8((major << 5) | 24));
233                 buf.appendInt(value, 1);
234             } else if(value <= 0xFFFF) {
235                 buf.append(uint8((major << 5) | 25));
236                 buf.appendInt(value, 2);
237             } else if(value <= 0xFFFFFFFF) {
238                 buf.append(uint8((major << 5) | 26));
239                 buf.appendInt(value, 4);
240             } else if(value <= 0xFFFFFFFFFFFFFFFF) {
241                 buf.append(uint8((major << 5) | 27));
242                 buf.appendInt(value, 8);
243             }
244         }
245 
246         function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
247             buf.append(uint8((major << 5) | 31));
248         }
249 
250         function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
251             encodeType(buf, MAJOR_TYPE_INT, value);
252         }
253 
254         function encodeInt(Buffer.buffer memory buf, int value) internal pure {
255             if(value >= 0) {
256                 encodeType(buf, MAJOR_TYPE_INT, uint(value));
257             } else {
258                 encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
259             }
260         }
261 
262         function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
263             encodeType(buf, MAJOR_TYPE_BYTES, value.length);
264             buf.append(value);
265         }
266 
267         function encodeString(Buffer.buffer memory buf, string value) internal pure {
268             encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
269             buf.append(bytes(value));
270         }
271 
272         function startArray(Buffer.buffer memory buf) internal pure {
273             encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
274         }
275 
276         function startMap(Buffer.buffer memory buf) internal pure {
277             encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
278         }
279 
280         function endSequence(Buffer.buffer memory buf) internal pure {
281             encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
282         }
283     }
284 
285     /*
286     End solidity-cborutils
287     */
288 
289     contract usingOraclize {
290         uint constant day = 60*60*24;
291         uint constant week = 60*60*24*7;
292         uint constant month = 60*60*24*30;
293         byte constant proofType_NONE = 0x00;
294         byte constant proofType_TLSNotary = 0x10;
295         byte constant proofType_Ledger = 0x30;
296         byte constant proofType_Android = 0x40;
297         byte constant proofType_Native = 0xF0;
298         byte constant proofStorage_IPFS = 0x01;
299         uint8 constant networkID_auto = 0;
300         uint8 constant networkID_mainnet = 1;
301         uint8 constant networkID_testnet = 2;
302         uint8 constant networkID_morden = 2;
303         uint8 constant networkID_consensys = 161;
304 
305         OraclizeAddrResolverI OAR;
306 
307         OraclizeI oraclize;
308         modifier oraclizeAPI {
309             if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
310                 oraclize_setNetwork(networkID_auto);
311 
312             if(address(oraclize) != OAR.getAddress())
313                 oraclize = OraclizeI(OAR.getAddress());
314 
315             _;
316         }
317         modifier coupon(string code){
318             oraclize = OraclizeI(OAR.getAddress());
319             _;
320         }
321 
322         function oraclize_setNetwork(uint8 networkID) internal returns(bool){
323         return oraclize_setNetwork();
324         networkID; // silence the warning and remain backwards compatible
325         }
326         function oraclize_setNetwork() internal returns(bool){
327             if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
328                 OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
329                 oraclize_setNetworkName("eth_mainnet");
330                 return true;
331             }
332             if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
333                 OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
334                 oraclize_setNetworkName("eth_ropsten3");
335                 return true;
336             }
337             if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
338                 OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
339                 oraclize_setNetworkName("eth_kovan");
340                 return true;
341             }
342             if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
343                 OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
344                 oraclize_setNetworkName("eth_rinkeby");
345                 return true;
346             }
347             if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
348                 OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
349                 return true;
350             }
351             if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
352                 OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
353                 return true;
354             }
355             if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
356                 OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
357                 return true;
358             }
359             return false;
360         }
361 
362         function __callback(bytes32 myid, string result) public {
363             __callback(myid, result, new bytes(0));
364         }
365         function __callback(bytes32 myid, string result, bytes proof) public {
366         return;
367         // Following should never be reached with a preceding return, however
368         // this is just a placeholder function, ideally meant to be defined in
369         // child contract when proofs are used
370         myid; result; proof; // Silence compiler warnings
371         oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
372         }
373 
374         function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
375             return oraclize.getPrice(datasource);
376         }
377 
378         function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
379             return oraclize.getPrice(datasource, gaslimit);
380         }
381 
382         function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
383             uint price = oraclize.getPrice(datasource);
384             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
385             return oraclize.query.value(price)(0, datasource, arg);
386         }
387         function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
388             uint price = oraclize.getPrice(datasource);
389             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390             return oraclize.query.value(price)(timestamp, datasource, arg);
391         }
392         function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
393             uint price = oraclize.getPrice(datasource, gaslimit);
394             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
395             return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
396         }
397         function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
398             uint price = oraclize.getPrice(datasource, gaslimit);
399             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
400             return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
401         }
402         function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
403             uint price = oraclize.getPrice(datasource);
404             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
405             return oraclize.query2.value(price)(0, datasource, arg1, arg2);
406         }
407         function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
408             uint price = oraclize.getPrice(datasource);
409             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410             return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
411         }
412         function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
413             uint price = oraclize.getPrice(datasource, gaslimit);
414             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
415             return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
416         }
417         function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
418             uint price = oraclize.getPrice(datasource, gaslimit);
419             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
420             return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
421         }
422         function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
423             uint price = oraclize.getPrice(datasource);
424             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425             bytes memory args = stra2cbor(argN);
426             return oraclize.queryN.value(price)(0, datasource, args);
427         }
428         function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
429             uint price = oraclize.getPrice(datasource);
430             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
431             bytes memory args = stra2cbor(argN);
432             return oraclize.queryN.value(price)(timestamp, datasource, args);
433         }
434         function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435             uint price = oraclize.getPrice(datasource, gaslimit);
436             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437             bytes memory args = stra2cbor(argN);
438             return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
439         }
440         function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
441             uint price = oraclize.getPrice(datasource, gaslimit);
442             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
443             bytes memory args = stra2cbor(argN);
444             return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
445         }
446         function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
447             string[] memory dynargs = new string[](1);
448             dynargs[0] = args[0];
449             return oraclize_query(datasource, dynargs);
450         }
451         function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
452             string[] memory dynargs = new string[](1);
453             dynargs[0] = args[0];
454             return oraclize_query(timestamp, datasource, dynargs);
455         }
456         function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457             string[] memory dynargs = new string[](1);
458             dynargs[0] = args[0];
459             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
460         }
461         function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462             string[] memory dynargs = new string[](1);
463             dynargs[0] = args[0];
464             return oraclize_query(datasource, dynargs, gaslimit);
465         }
466 
467         function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
468             string[] memory dynargs = new string[](2);
469             dynargs[0] = args[0];
470             dynargs[1] = args[1];
471             return oraclize_query(datasource, dynargs);
472         }
473         function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
474             string[] memory dynargs = new string[](2);
475             dynargs[0] = args[0];
476             dynargs[1] = args[1];
477             return oraclize_query(timestamp, datasource, dynargs);
478         }
479         function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480             string[] memory dynargs = new string[](2);
481             dynargs[0] = args[0];
482             dynargs[1] = args[1];
483             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
484         }
485         function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
486             string[] memory dynargs = new string[](2);
487             dynargs[0] = args[0];
488             dynargs[1] = args[1];
489             return oraclize_query(datasource, dynargs, gaslimit);
490         }
491         function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
492             string[] memory dynargs = new string[](3);
493             dynargs[0] = args[0];
494             dynargs[1] = args[1];
495             dynargs[2] = args[2];
496             return oraclize_query(datasource, dynargs);
497         }
498         function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
499             string[] memory dynargs = new string[](3);
500             dynargs[0] = args[0];
501             dynargs[1] = args[1];
502             dynargs[2] = args[2];
503             return oraclize_query(timestamp, datasource, dynargs);
504         }
505         function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506             string[] memory dynargs = new string[](3);
507             dynargs[0] = args[0];
508             dynargs[1] = args[1];
509             dynargs[2] = args[2];
510             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
511         }
512         function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513             string[] memory dynargs = new string[](3);
514             dynargs[0] = args[0];
515             dynargs[1] = args[1];
516             dynargs[2] = args[2];
517             return oraclize_query(datasource, dynargs, gaslimit);
518         }
519 
520         function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
521             string[] memory dynargs = new string[](4);
522             dynargs[0] = args[0];
523             dynargs[1] = args[1];
524             dynargs[2] = args[2];
525             dynargs[3] = args[3];
526             return oraclize_query(datasource, dynargs);
527         }
528         function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
529             string[] memory dynargs = new string[](4);
530             dynargs[0] = args[0];
531             dynargs[1] = args[1];
532             dynargs[2] = args[2];
533             dynargs[3] = args[3];
534             return oraclize_query(timestamp, datasource, dynargs);
535         }
536         function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
537             string[] memory dynargs = new string[](4);
538             dynargs[0] = args[0];
539             dynargs[1] = args[1];
540             dynargs[2] = args[2];
541             dynargs[3] = args[3];
542             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
543         }
544         function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545             string[] memory dynargs = new string[](4);
546             dynargs[0] = args[0];
547             dynargs[1] = args[1];
548             dynargs[2] = args[2];
549             dynargs[3] = args[3];
550             return oraclize_query(datasource, dynargs, gaslimit);
551         }
552         function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
553             string[] memory dynargs = new string[](5);
554             dynargs[0] = args[0];
555             dynargs[1] = args[1];
556             dynargs[2] = args[2];
557             dynargs[3] = args[3];
558             dynargs[4] = args[4];
559             return oraclize_query(datasource, dynargs);
560         }
561         function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
562             string[] memory dynargs = new string[](5);
563             dynargs[0] = args[0];
564             dynargs[1] = args[1];
565             dynargs[2] = args[2];
566             dynargs[3] = args[3];
567             dynargs[4] = args[4];
568             return oraclize_query(timestamp, datasource, dynargs);
569         }
570         function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
571             string[] memory dynargs = new string[](5);
572             dynargs[0] = args[0];
573             dynargs[1] = args[1];
574             dynargs[2] = args[2];
575             dynargs[3] = args[3];
576             dynargs[4] = args[4];
577             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
578         }
579         function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
580             string[] memory dynargs = new string[](5);
581             dynargs[0] = args[0];
582             dynargs[1] = args[1];
583             dynargs[2] = args[2];
584             dynargs[3] = args[3];
585             dynargs[4] = args[4];
586             return oraclize_query(datasource, dynargs, gaslimit);
587         }
588         function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
589             uint price = oraclize.getPrice(datasource);
590             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
591             bytes memory args = ba2cbor(argN);
592             return oraclize.queryN.value(price)(0, datasource, args);
593         }
594         function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
595             uint price = oraclize.getPrice(datasource);
596             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
597             bytes memory args = ba2cbor(argN);
598             return oraclize.queryN.value(price)(timestamp, datasource, args);
599         }
600         function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
601             uint price = oraclize.getPrice(datasource, gaslimit);
602             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
603             bytes memory args = ba2cbor(argN);
604             return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
605         }
606         function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
607             uint price = oraclize.getPrice(datasource, gaslimit);
608             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
609             bytes memory args = ba2cbor(argN);
610             return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
611         }
612         function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
613             bytes[] memory dynargs = new bytes[](1);
614             dynargs[0] = args[0];
615             return oraclize_query(datasource, dynargs);
616         }
617         function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
618             bytes[] memory dynargs = new bytes[](1);
619             dynargs[0] = args[0];
620             return oraclize_query(timestamp, datasource, dynargs);
621         }
622         function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623             bytes[] memory dynargs = new bytes[](1);
624             dynargs[0] = args[0];
625             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
626         }
627         function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
628             bytes[] memory dynargs = new bytes[](1);
629             dynargs[0] = args[0];
630             return oraclize_query(datasource, dynargs, gaslimit);
631         }
632 
633         function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
634             bytes[] memory dynargs = new bytes[](2);
635             dynargs[0] = args[0];
636             dynargs[1] = args[1];
637             return oraclize_query(datasource, dynargs);
638         }
639         function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
640             bytes[] memory dynargs = new bytes[](2);
641             dynargs[0] = args[0];
642             dynargs[1] = args[1];
643             return oraclize_query(timestamp, datasource, dynargs);
644         }
645         function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646             bytes[] memory dynargs = new bytes[](2);
647             dynargs[0] = args[0];
648             dynargs[1] = args[1];
649             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
650         }
651         function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
652             bytes[] memory dynargs = new bytes[](2);
653             dynargs[0] = args[0];
654             dynargs[1] = args[1];
655             return oraclize_query(datasource, dynargs, gaslimit);
656         }
657         function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
658             bytes[] memory dynargs = new bytes[](3);
659             dynargs[0] = args[0];
660             dynargs[1] = args[1];
661             dynargs[2] = args[2];
662             return oraclize_query(datasource, dynargs);
663         }
664         function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
665             bytes[] memory dynargs = new bytes[](3);
666             dynargs[0] = args[0];
667             dynargs[1] = args[1];
668             dynargs[2] = args[2];
669             return oraclize_query(timestamp, datasource, dynargs);
670         }
671         function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672             bytes[] memory dynargs = new bytes[](3);
673             dynargs[0] = args[0];
674             dynargs[1] = args[1];
675             dynargs[2] = args[2];
676             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
677         }
678         function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
679             bytes[] memory dynargs = new bytes[](3);
680             dynargs[0] = args[0];
681             dynargs[1] = args[1];
682             dynargs[2] = args[2];
683             return oraclize_query(datasource, dynargs, gaslimit);
684         }
685 
686         function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
687             bytes[] memory dynargs = new bytes[](4);
688             dynargs[0] = args[0];
689             dynargs[1] = args[1];
690             dynargs[2] = args[2];
691             dynargs[3] = args[3];
692             return oraclize_query(datasource, dynargs);
693         }
694         function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
695             bytes[] memory dynargs = new bytes[](4);
696             dynargs[0] = args[0];
697             dynargs[1] = args[1];
698             dynargs[2] = args[2];
699             dynargs[3] = args[3];
700             return oraclize_query(timestamp, datasource, dynargs);
701         }
702         function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
703             bytes[] memory dynargs = new bytes[](4);
704             dynargs[0] = args[0];
705             dynargs[1] = args[1];
706             dynargs[2] = args[2];
707             dynargs[3] = args[3];
708             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
709         }
710         function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
711             bytes[] memory dynargs = new bytes[](4);
712             dynargs[0] = args[0];
713             dynargs[1] = args[1];
714             dynargs[2] = args[2];
715             dynargs[3] = args[3];
716             return oraclize_query(datasource, dynargs, gaslimit);
717         }
718         function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
719             bytes[] memory dynargs = new bytes[](5);
720             dynargs[0] = args[0];
721             dynargs[1] = args[1];
722             dynargs[2] = args[2];
723             dynargs[3] = args[3];
724             dynargs[4] = args[4];
725             return oraclize_query(datasource, dynargs);
726         }
727         function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
728             bytes[] memory dynargs = new bytes[](5);
729             dynargs[0] = args[0];
730             dynargs[1] = args[1];
731             dynargs[2] = args[2];
732             dynargs[3] = args[3];
733             dynargs[4] = args[4];
734             return oraclize_query(timestamp, datasource, dynargs);
735         }
736         function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
737             bytes[] memory dynargs = new bytes[](5);
738             dynargs[0] = args[0];
739             dynargs[1] = args[1];
740             dynargs[2] = args[2];
741             dynargs[3] = args[3];
742             dynargs[4] = args[4];
743             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
744         }
745         function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
746             bytes[] memory dynargs = new bytes[](5);
747             dynargs[0] = args[0];
748             dynargs[1] = args[1];
749             dynargs[2] = args[2];
750             dynargs[3] = args[3];
751             dynargs[4] = args[4];
752             return oraclize_query(datasource, dynargs, gaslimit);
753         }
754 
755         function oraclize_cbAddress() oraclizeAPI internal returns (address){
756             return oraclize.cbAddress();
757         }
758         function oraclize_setProof(byte proofP) oraclizeAPI internal {
759             return oraclize.setProofType(proofP);
760         }
761         function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
762             return oraclize.setCustomGasPrice(gasPrice);
763         }
764 
765         function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
766             return oraclize.randomDS_getSessionPubKeyHash();
767         }
768 
769         function getCodeSize(address _addr) view internal returns(uint _size) {
770             assembly {
771                 _size := extcodesize(_addr)
772             }
773         }
774 
775         function parseAddr(string _a) internal pure returns (address){
776             bytes memory tmp = bytes(_a);
777             uint160 iaddr = 0;
778             uint160 b1;
779             uint160 b2;
780             for (uint i=2; i<2+2*20; i+=2){
781                 iaddr *= 256;
782                 b1 = uint160(tmp[i]);
783                 b2 = uint160(tmp[i+1]);
784                 if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
785                 else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
786                 else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
787                 if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
788                 else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
789                 else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
790                 iaddr += (b1*16+b2);
791             }
792             return address(iaddr);
793         }
794 
795         function strCompare(string _a, string _b) internal pure returns (int) {
796             bytes memory a = bytes(_a);
797             bytes memory b = bytes(_b);
798             uint minLength = a.length;
799             if (b.length < minLength) minLength = b.length;
800             for (uint i = 0; i < minLength; i ++)
801                 if (a[i] < b[i])
802                     return -1;
803                 else if (a[i] > b[i])
804                     return 1;
805             if (a.length < b.length)
806                 return -1;
807             else if (a.length > b.length)
808                 return 1;
809             else
810                 return 0;
811         }
812 
813         function indexOf(string _haystack, string _needle) internal pure returns (int) {
814             bytes memory h = bytes(_haystack);
815             bytes memory n = bytes(_needle);
816             if(h.length < 1 || n.length < 1 || (n.length > h.length))
817                 return -1;
818             else if(h.length > (2**128 -1))
819                 return -1;
820             else
821             {
822                 uint subindex = 0;
823                 for (uint i = 0; i < h.length; i ++)
824                 {
825                     if (h[i] == n[0])
826                     {
827                         subindex = 1;
828                         while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
829                         {
830                             subindex++;
831                         }
832                         if(subindex == n.length)
833                             return int(i);
834                     }
835                 }
836                 return -1;
837             }
838         }
839 
840         function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
841             bytes memory _ba = bytes(_a);
842             bytes memory _bb = bytes(_b);
843             bytes memory _bc = bytes(_c);
844             bytes memory _bd = bytes(_d);
845             bytes memory _be = bytes(_e);
846             string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
847             bytes memory babcde = bytes(abcde);
848             uint k = 0;
849             for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
850             for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
851             for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
852             for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
853             for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
854             return string(babcde);
855         }
856 
857         function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
858             return strConcat(_a, _b, _c, _d, "");
859         }
860 
861         function strConcat(string _a, string _b, string _c) internal pure returns (string) {
862             return strConcat(_a, _b, _c, "", "");
863         }
864 
865         function strConcat(string _a, string _b) internal pure returns (string) {
866             return strConcat(_a, _b, "", "", "");
867         }
868 
869         // parseInt
870         function parseInt(string _a) internal pure returns (uint) {
871             return parseInt(_a, 0);
872         }
873 
874         // parseInt(parseFloat*10^_b)
875         function parseInt(string _a, uint _b) internal pure returns (uint) {
876             bytes memory bresult = bytes(_a);
877             uint mint = 0;
878             bool decimals = false;
879             for (uint i=0; i<bresult.length; i++){
880                 if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
881                     if (decimals){
882                     if (_b == 0) break;
883                         else _b--;
884                     }
885                     mint *= 10;
886                     mint += uint(bresult[i]) - 48;
887                 } else if (bresult[i] == 46) decimals = true;
888             }
889             if (_b > 0) mint *= 10**_b;
890             return mint;
891         }
892 
893         function uint2str(uint i) internal pure returns (string){
894             if (i == 0) return "0";
895             uint j = i;
896             uint len;
897             while (j != 0){
898                 len++;
899                 j /= 10;
900             }
901             bytes memory bstr = new bytes(len);
902             uint k = len - 1;
903             while (i != 0){
904                 bstr[k--] = byte(48 + i % 10);
905                 i /= 10;
906             }
907             return string(bstr);
908         }
909 
910         using CBOR for Buffer.buffer;
911         function stra2cbor(string[] arr) internal pure returns (bytes) {
912             safeMemoryCleaner();
913             Buffer.buffer memory buf;
914             Buffer.init(buf, 1024);
915             buf.startArray();
916             for (uint i = 0; i < arr.length; i++) {
917                 buf.encodeString(arr[i]);
918             }
919             buf.endSequence();
920             return buf.buf;
921         }
922 
923         function ba2cbor(bytes[] arr) internal pure returns (bytes) {
924             safeMemoryCleaner();
925             Buffer.buffer memory buf;
926             Buffer.init(buf, 1024);
927             buf.startArray();
928             for (uint i = 0; i < arr.length; i++) {
929                 buf.encodeBytes(arr[i]);
930             }
931             buf.endSequence();
932             return buf.buf;
933         }
934 
935         string oraclize_network_name;
936         function oraclize_setNetworkName(string _network_name) internal {
937             oraclize_network_name = _network_name;
938         }
939 
940         function oraclize_getNetworkName() internal view returns (string) {
941             return oraclize_network_name;
942         }
943 
944         function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
945             require((_nbytes > 0) && (_nbytes <= 32));
946             // Convert from seconds to ledger timer ticks
947             _delay *= 10;
948             bytes memory nbytes = new bytes(1);
949             nbytes[0] = byte(_nbytes);
950             bytes memory unonce = new bytes(32);
951             bytes memory sessionKeyHash = new bytes(32);
952             bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
953             assembly {
954                 mstore(unonce, 0x20)
955                 // the following variables can be relaxed
956                 // check relaxed random contract under ethereum-examples repo
957                 // for an idea on how to override and replace comit hash vars
958                 mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
959                 mstore(sessionKeyHash, 0x20)
960                 mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
961             }
962             bytes memory delay = new bytes(32);
963             assembly {
964                 mstore(add(delay, 0x20), _delay)
965             }
966 
967             bytes memory delay_bytes8 = new bytes(8);
968             copyBytes(delay, 24, 8, delay_bytes8, 0);
969 
970             bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
971             bytes32 queryId = oraclize_query("random", args, _customGasLimit);
972 
973             bytes memory delay_bytes8_left = new bytes(8);
974 
975             assembly {
976                 let x := mload(add(delay_bytes8, 0x20))
977                 mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
978                 mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
979                 mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
980                 mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
981                 mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
982                 mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
983                 mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
984                 mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
985 
986             }
987 
988             oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
989             return queryId;
990         }
991 
992         function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
993             oraclize_randomDS_args[queryId] = commitment;
994         }
995 
996         mapping(bytes32=>bytes32) oraclize_randomDS_args;
997         mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
998 
999         function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1000             bool sigok;
1001             address signer;
1002 
1003             bytes32 sigr;
1004             bytes32 sigs;
1005 
1006             bytes memory sigr_ = new bytes(32);
1007             uint offset = 4+(uint(dersig[3]) - 0x20);
1008             sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1009             bytes memory sigs_ = new bytes(32);
1010             offset += 32 + 2;
1011             sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1012 
1013             assembly {
1014                 sigr := mload(add(sigr_, 32))
1015                 sigs := mload(add(sigs_, 32))
1016             }
1017 
1018 
1019             (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1020             if (address(keccak256(pubkey)) == signer) return true;
1021             else {
1022                 (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1023                 return (address(keccak256(pubkey)) == signer);
1024             }
1025         }
1026 
1027         function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1028             bool sigok;
1029 
1030             // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1031             bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1032             copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1033 
1034             bytes memory appkey1_pubkey = new bytes(64);
1035             copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1036 
1037             bytes memory tosign2 = new bytes(1+65+32);
1038             tosign2[0] = byte(1); //role
1039             copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1040             bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1041             copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1042             sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1043 
1044             if (sigok == false) return false;
1045 
1046 
1047             // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1048             bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1049 
1050             bytes memory tosign3 = new bytes(1+65);
1051             tosign3[0] = 0xFE;
1052             copyBytes(proof, 3, 65, tosign3, 1);
1053 
1054             bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1055             copyBytes(proof, 3+65, sig3.length, sig3, 0);
1056 
1057             sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1058 
1059             return sigok;
1060         }
1061 
1062         modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1063             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1064             require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1065 
1066             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1067             require(proofVerified);
1068 
1069             _;
1070         }
1071 
1072         function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1073             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1074             if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1075 
1076             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1077             if (proofVerified == false) return 2;
1078 
1079             return 0;
1080         }
1081 
1082         function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1083             bool match_ = true;
1084 
1085             require(prefix.length == n_random_bytes);
1086 
1087             for (uint256 i=0; i< n_random_bytes; i++) {
1088                 if (content[i] != prefix[i]) match_ = false;
1089             }
1090 
1091             return match_;
1092         }
1093 
1094         function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1095 
1096             // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1097             uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1098             bytes memory keyhash = new bytes(32);
1099             copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1100             if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1101 
1102             bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1103             copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1104 
1105             // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1106             if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1107 
1108             // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1109             // This is to verify that the computed args match with the ones specified in the query.
1110             bytes memory commitmentSlice1 = new bytes(8+1+32);
1111             copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1112 
1113             bytes memory sessionPubkey = new bytes(64);
1114             uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1115             copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1116 
1117             bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1118             if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1119                 delete oraclize_randomDS_args[queryId];
1120             } else return false;
1121 
1122 
1123             // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1124             bytes memory tosign1 = new bytes(32+8+1+32);
1125             copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1126             if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1127 
1128             // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1129             if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1130                 oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1131             }
1132 
1133             return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1134         }
1135 
1136         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1137         function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1138             uint minLength = length + toOffset;
1139 
1140             // Buffer too small
1141             require(to.length >= minLength); // Should be a better way?
1142 
1143             // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1144             uint i = 32 + fromOffset;
1145             uint j = 32 + toOffset;
1146 
1147             while (i < (32 + fromOffset + length)) {
1148                 assembly {
1149                     let tmp := mload(add(from, i))
1150                     mstore(add(to, j), tmp)
1151                 }
1152                 i += 32;
1153                 j += 32;
1154             }
1155 
1156             return to;
1157         }
1158 
1159         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1160         // Duplicate Solidity's ecrecover, but catching the CALL return value
1161         function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1162             // We do our own memory management here. Solidity uses memory offset
1163             // 0x40 to store the current end of memory. We write past it (as
1164             // writes are memory extensions), but don't update the offset so
1165             // Solidity will reuse it. The memory used here is only needed for
1166             // this context.
1167 
1168             // FIXME: inline assembly can't access return values
1169             bool ret;
1170             address addr;
1171 
1172             assembly {
1173                 let size := mload(0x40)
1174                 mstore(size, hash)
1175                 mstore(add(size, 32), v)
1176                 mstore(add(size, 64), r)
1177                 mstore(add(size, 96), s)
1178 
1179                 // NOTE: we can reuse the request memory because we deal with
1180                 //       the return code
1181                 ret := call(3000, 1, 0, size, 128, size, 32)
1182                 addr := mload(size)
1183             }
1184 
1185             return (ret, addr);
1186         }
1187 
1188         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1189         function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1190             bytes32 r;
1191             bytes32 s;
1192             uint8 v;
1193 
1194             if (sig.length != 65)
1195             return (false, 0);
1196 
1197             // The signature format is a compact form of:
1198             //   {bytes32 r}{bytes32 s}{uint8 v}
1199             // Compact means, uint8 is not padded to 32 bytes.
1200             assembly {
1201                 r := mload(add(sig, 32))
1202                 s := mload(add(sig, 64))
1203 
1204                 // Here we are loading the last 32 bytes. We exploit the fact that
1205                 // 'mload' will pad with zeroes if we overread.
1206                 // There is no 'mload8' to do this, but that would be nicer.
1207                 v := byte(0, mload(add(sig, 96)))
1208 
1209                 // Alternative solution:
1210                 // 'byte' is not working due to the Solidity parser, so lets
1211                 // use the second best option, 'and'
1212                 // v := and(mload(add(sig, 65)), 255)
1213             }
1214 
1215             // albeit non-transactional signatures are not specified by the YP, one would expect it
1216             // to match the YP range of [27, 28]
1217             //
1218             // geth uses [0, 1] and some clients have followed. This might change, see:
1219             //  https://github.com/ethereum/go-ethereum/issues/2053
1220             if (v < 27)
1221             v += 27;
1222 
1223             if (v != 27 && v != 28)
1224                 return (false, 0);
1225 
1226             return safer_ecrecover(hash, v, r, s);
1227         }
1228 
1229         function safeMemoryCleaner() internal pure {
1230             assembly {
1231                 let fmem := mload(0x40)
1232                 codecopy(fmem, codesize, sub(msize, fmem))
1233             }
1234         }
1235 
1236     }
1237 // </ORACLIZE_API>
1238 
1239 contract Ownable {
1240     address private _owner;
1241 
1242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1243 
1244     constructor() internal {
1245         _owner = msg.sender;
1246 
1247         emit OwnershipTransferred(address(0), _owner);
1248     }
1249 
1250     function owner() public view returns(address) {
1251         return _owner;
1252     }
1253 
1254     modifier onlyOwner() {
1255         require(isOwner(), "Access denied");
1256         _;
1257     }
1258 
1259     function isOwner() public view returns(bool) {
1260         return msg.sender == _owner;
1261     }
1262 
1263     function renounceOwnership() public onlyOwner {
1264         emit OwnershipTransferred(_owner, address(0));
1265 
1266         _owner = address(0);
1267     }
1268 
1269     function transferOwnership(address newOwner) public onlyOwner {
1270         _transferOwnership(newOwner);
1271     }
1272 
1273     function _transferOwnership(address newOwner) internal {
1274         require(newOwner != address(0), "Zero address");
1275 
1276         emit OwnershipTransferred(_owner, newOwner);
1277 
1278         _owner = newOwner;
1279     }
1280 }
1281 
1282 contract CryptoBets is Ownable, usingOraclize {
1283     struct Room {
1284         address author;
1285         uint bet;
1286         uint max_players;
1287         string pass;
1288         bool run;
1289         bool closed;
1290         address[] players;
1291     }
1292 
1293     uint public min_bet = 0.1 ether;
1294     uint public max_bet = 3 ether;
1295     uint public min_players = 2;
1296     uint public max_players = 10;
1297     uint[] public ref_payouts = [3, 2, 1];
1298     uint public jackpot_max_players = 100;
1299     uint public jackpot_bank = 0;
1300     uint public commision = 0;
1301     uint public oraclize_gas_limit = 250000;
1302 
1303     Room[] public rooms;
1304     mapping(bytes32 => uint) public games;
1305     mapping(address => address) public refferals;
1306     address[] public jackpot_players;
1307 
1308     mapping(address => bool) public managers;
1309     mapping(address => uint) public withdraws;
1310 
1311     event NewRoom(uint indexed room_id, address indexed author, uint bet, uint max_players, string pass);
1312     event NewBet(uint indexed room_id, address indexed addr);
1313     event Run(uint indexed room_id, bytes32 indexed id);
1314     event FinishRoom(uint indexed room_id, address indexed winner);
1315     event Withdraw(address indexed to, uint value);
1316     
1317     modifier onlyManager() {
1318         require(managers[msg.sender], "Access denied");
1319         _;
1320     }
1321 
1322     constructor() payable public {
1323         // Managers
1324         managers[0x909bf2E71fe8f8cEDb8D55E1818E152b003c5612] = true;
1325         managers[0xB224A65FA9a76d6cc0f3c96A181894Be342fcB63] = true;
1326         managers[0x5BC1987a3f4E43650b2E3FbE7C404c4C5ffF1531] = true;
1327         managers[0xF20175D17Be5d6b215b6063EAaAc158969064ee8] = true;
1328         managers[0xA745ac0BB1F88EeCF9EC0Db369Ed29F07CD42966] = true;
1329         managers[0xdc0B815316383BA4d087a2dBB9268CB5346b88aa] = true;
1330         managers[0x2431CfCDEa6abc4112EA67a41910D986D7475ac5] = true;
1331         managers[0x756F9B5DAd8d119fA7442FB636Db7f3bDF5435eF] = true;
1332         managers[0xecC78D8DA24F9625F615374279F0627c97da9379] = true;
1333         managers[0xcBE575FFa93d7D9eE1CC7aACC72a5C93FD1e08c3] = true;
1334     }
1335     
1336     function() payable external {}
1337 
1338     function __callback(bytes32 id, string res) public {
1339         require(msg.sender == oraclize_cbAddress(), "Permission denied");
1340 
1341         Room storage room = rooms[games[id]];
1342         
1343         require(room.author != address(0), "Room not found");
1344         require(!room.closed, "Room already closed");
1345 
1346         uint result = parseInt(res);
1347         uint win = room.bet * room.players.length;
1348         uint comm = 14;
1349         uint oc = oraclize_getPrice("URL");
1350 
1351         jackpot_bank += win / 100;
1352 
1353         address ref = refferals[room.players[result]];
1354         if(ref != room.players[result]) {
1355             for(uint i = 0; i < ref_payouts.length; i++) {
1356                 if(ref != address(0)) {
1357                     uint p = win * ref_payouts[i] / 100;
1358 
1359                     comm -= ref_payouts[i];
1360 
1361                     ref.transfer(p);
1362                     ref = refferals[ref];
1363                 }
1364                 else break;
1365             }
1366         }
1367 
1368         room.players[result].transfer(win - (win * 15 / 100));
1369 
1370         if(win * comm / 100 > oc) {
1371             commision += (win * comm / 100) - oc;
1372         }
1373 
1374         emit FinishRoom(games[id], room.players[result]);
1375 
1376         room.closed = true;
1377 
1378         delete games[id];
1379 
1380         if(jackpot_players.length >= jackpot_max_players) {
1381             uint jp_winner = (uint(blockhash(block.number - 1)) + result) % jackpot_players.length;
1382 
1383             if(jackpot_players[jp_winner] != address(0)) {
1384                 jackpot_players[jp_winner].transfer(jackpot_bank);
1385 
1386                 jackpot_bank = 0;
1387                 jackpot_players.length = 0;
1388             }
1389         }
1390     }
1391 
1392     function createRoom(uint players, string pass, address refferal) payable external {
1393         require(msg.value >= min_bet && msg.value <= max_bet, "Bet does not match the interval");
1394         require(players >= min_players && players <= max_players, "Players does not match the interval");
1395 
1396         address[] memory pls;
1397 
1398         rooms.push(Room({
1399             author: msg.sender,
1400             bet: msg.value,
1401             max_players: players,
1402             pass: pass,
1403             run: false,
1404             closed: false,
1405             players: pls
1406         }));
1407 
1408         emit NewRoom(rooms.length - 1, msg.sender, msg.value, players, pass);
1409 
1410         _joinRoom(msg.value, msg.sender, rooms.length - 1, pass, refferal);
1411     }
1412 
1413     function _joinRoom(uint value, address to, uint room_id, string pass, address refferal) private {
1414         require(rooms[room_id].author != address(0), "Room not found");
1415         require(!rooms[room_id].closed, "Room already closed");
1416         require(value == rooms[room_id].bet, "Insufficient funds");
1417         require(strCompare(pass, rooms[room_id].pass) == 0, "Invalid password");
1418         require(rooms[room_id].max_players > rooms[room_id].players.length, "Room is full");
1419 
1420         rooms[room_id].players.push(msg.sender);
1421         jackpot_players.push(msg.sender);
1422 
1423         if(refferals[msg.sender] == address(0)) {
1424             refferals[msg.sender] = refferal != address(0) ? refferal : msg.sender;
1425         }
1426 
1427         emit NewBet(room_id, to);
1428 
1429         if(rooms[room_id].max_players == rooms[room_id].players.length) {
1430             _play(room_id);
1431         }
1432     }
1433 
1434     function joinRoom(uint room_id, string pass, address refferal) payable external {
1435         _joinRoom(msg.value, msg.sender, room_id, pass, refferal);
1436     }
1437 
1438     function _play(uint room_id) private {
1439         require(rooms[room_id].author != address(0), "Room not found");
1440         require(!rooms[room_id].closed, "Room already closed");
1441         require(rooms[room_id].max_players == rooms[room_id].players.length, "Room is empty");
1442         require(oraclize_getPrice("URL") <= address(this).balance, "Insufficient funds");
1443         
1444         bytes32 id = oraclize_query("WolframAlpha", strConcat("RandomInteger[{0, ", uint2str(rooms[room_id].players.length - 1), "}]"), oraclize_gas_limit);
1445         
1446         rooms[room_id].run = true;
1447         games[id] = room_id;
1448 
1449         emit Run(room_id, id);
1450     }
1451 
1452     function play(uint room_id) onlyManager external {
1453         _play(room_id);
1454     }
1455     
1456     function withdraw() onlyManager external {
1457         uint s = commision / 10;
1458         uint b = withdraws[msg.sender] < s ? s - withdraws[msg.sender] : 0;
1459 
1460         require(b > 0 && address(this).balance >= b, "Insufficient funds");
1461 
1462         withdraws[msg.sender] += b;
1463 
1464         msg.sender.transfer(b);
1465 
1466         emit Withdraw(msg.sender, b);
1467     }
1468 
1469     function setJackpotMaxPlayers(uint value) onlyOwner external {
1470         jackpot_max_players = value;
1471     }
1472 
1473     function setOraclizeGasLimit(uint value) onlyOwner external {
1474         oraclize_gas_limit = value;
1475     }
1476 
1477     function setOraclizeGasPrice(uint value) onlyOwner external {
1478         oraclize_setCustomGasPrice(value);
1479     }
1480 }