1 /*
2  ______   _________  ___   ___   _______    _______             ________  ______      
3 /_____/\ /________/\/__/\ /__/\ /______/\  /______/\           /_______/\/_____/\     
4 \::::_\/_\__.::.__\/\::\ \\  \ \\::::__\/__\::::__\/__         \__.::._\/\:::_ \ \    
5  \:\/___/\  \::\ \   \::\/_\ .\ \\:\ /____/\\:\ /____/\  ___      \::\ \  \:\ \ \ \   
6   \::___\/_  \::\ \   \:: ___::\ \\:\\_  _\/ \:\\_  _\/ /__/\     _\::\ \__\:\ \ \ \  
7    \:\____/\  \::\ \   \: \ \\::\ \\:\_\ \ \  \:\_\ \ \ \::\ \   /__\::\__/\\:\_\ \ \ 
8     \_____\/   \__\/    \__\/ \::\/ \_____\/   \_____\/  \:_\/   \________\/ \_____\/ 
9   ______ _______ _    _    _____  ____   ____  _____     _____          __  __ ______  _____ 
10  |  ____|__   __| |  | |  / ____|/ __ \ / __ \|  __ \   / ____|   /\   |  \/  |  ____|/ ____|
11  | |__     | |  | |__| | | |  __| |  | | |  | | |  | | | |  __   /  \  | \  / | |__  | (___  
12  |  __|    | |  |  __  | | | |_ | |  | | |  | | |  | | | | |_ | / /\ \ | |\/| |  __|  \___ \ 
13  | |____   | |  | |  | | | |__| | |__| | |__| | |__| | | |__| |/ ____ \| |  | | |____ ____) |
14  |______|  |_|  |_|  |_|  \_____|\____/ \____/|_____/   \_____/_/    \_\_|  |_|______|_____/ 
15                                                                                              
16                                                          BY : LmsSky@Gmail.com
17 */                            
18 pragma solidity ^0.4.25;
19 contract OraclizeI {
20     address public cbAddress;
21     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
22     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
23     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
24     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
25     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
26     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
27     function getPrice(string _datasource) public returns (uint _dsprice);
28     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
29     function setProofType(byte _proofType) external;
30     function setCustomGasPrice(uint _gasPrice) external;
31     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
32 }
33 
34 contract OraclizeAddrResolverI {
35     function getAddress() public returns (address _addr);
36 }
37 
38 /*
39 Begin solidity-cborutils
40 
41 https://github.com/smartcontractkit/solidity-cborutils
42 
43 MIT License
44 
45 Copyright (c) 2018 SmartContract ChainLink, Ltd.
46 
47 Permission is hereby granted, free of charge, to any person obtaining a copy
48 of this software and associated documentation files (the "Software"), to deal
49 in the Software without restriction, including without limitation the rights
50 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
51 copies of the Software, and to permit persons to whom the Software is
52 furnished to do so, subject to the following conditions:
53 
54 The above copyright notice and this permission notice shall be included in all
55 copies or substantial portions of the Software.
56 
57 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
58 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
59 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
60 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
61 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
62 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
63 SOFTWARE.
64  */
65 
66 library Buffer {
67     struct buffer {
68         bytes buf;
69         uint capacity;
70     }
71 
72     function init(buffer memory buf, uint _capacity) internal pure {
73         uint capacity = _capacity;
74         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
75         // Allocate space for the buffer data
76         buf.capacity = capacity;
77         assembly {
78             let ptr := mload(0x40)
79             mstore(buf, ptr)
80             mstore(ptr, 0)
81             mstore(0x40, add(ptr, capacity))
82         }
83     }
84 
85     function resize(buffer memory buf, uint capacity) private pure {
86         bytes memory oldbuf = buf.buf;
87         init(buf, capacity);
88         append(buf, oldbuf);
89     }
90 
91     function max(uint a, uint b) private pure returns(uint) {
92         if(a > b) {
93             return a;
94         }
95         return b;
96     }
97 
98     /**
99      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
100      *      would exceed the capacity of the buffer.
101      * @param buf The buffer to append to.
102      * @param data The data to append.
103      * @return The original buffer.
104      */
105     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
106         if(data.length + buf.buf.length > buf.capacity) {
107             resize(buf, max(buf.capacity, data.length) * 2);
108         }
109 
110         uint dest;
111         uint src;
112         uint len = data.length;
113         assembly {
114             // Memory address of the buffer data
115             let bufptr := mload(buf)
116             // Length of existing buffer data
117             let buflen := mload(bufptr)
118             // Start address = buffer address + buffer length + sizeof(buffer length)
119             dest := add(add(bufptr, buflen), 32)
120             // Update buffer length
121             mstore(bufptr, add(buflen, mload(data)))
122             src := add(data, 32)
123         }
124 
125         // Copy word-length chunks while possible
126         for(; len >= 32; len -= 32) {
127             assembly {
128                 mstore(dest, mload(src))
129             }
130             dest += 32;
131             src += 32;
132         }
133 
134         // Copy remaining bytes
135         uint mask = 256 ** (32 - len) - 1;
136         assembly {
137             let srcpart := and(mload(src), not(mask))
138             let destpart := and(mload(dest), mask)
139             mstore(dest, or(destpart, srcpart))
140         }
141 
142         return buf;
143     }
144 
145     /**
146      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
147      * exceed the capacity of the buffer.
148      * @param buf The buffer to append to.
149      * @param data The data to append.
150      * @return The original buffer.
151      */
152     function append(buffer memory buf, uint8 data) internal pure {
153         if(buf.buf.length + 1 > buf.capacity) {
154             resize(buf, buf.capacity * 2);
155         }
156 
157         assembly {
158             // Memory address of the buffer data
159             let bufptr := mload(buf)
160             // Length of existing buffer data
161             let buflen := mload(bufptr)
162             // Address = buffer address + buffer length + sizeof(buffer length)
163             let dest := add(add(bufptr, buflen), 32)
164             mstore8(dest, data)
165             // Update buffer length
166             mstore(bufptr, add(buflen, 1))
167         }
168     }
169 
170     /**
171      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
172      * exceed the capacity of the buffer.
173      * @param buf The buffer to append to.
174      * @param data The data to append.
175      * @return The original buffer.
176      */
177     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
178         if(len + buf.buf.length > buf.capacity) {
179             resize(buf, max(buf.capacity, len) * 2);
180         }
181 
182         uint mask = 256 ** len - 1;
183         assembly {
184             // Memory address of the buffer data
185             let bufptr := mload(buf)
186             // Length of existing buffer data
187             let buflen := mload(bufptr)
188             // Address = buffer address + buffer length + sizeof(buffer length) + len
189             let dest := add(add(bufptr, buflen), len)
190             mstore(dest, or(and(mload(dest), not(mask)), data))
191             // Update buffer length
192             mstore(bufptr, add(buflen, len))
193         }
194         return buf;
195     }
196 }
197 
198 library CBOR {
199     using Buffer for Buffer.buffer;
200 
201     uint8 private constant MAJOR_TYPE_INT = 0;
202     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
203     uint8 private constant MAJOR_TYPE_BYTES = 2;
204     uint8 private constant MAJOR_TYPE_STRING = 3;
205     uint8 private constant MAJOR_TYPE_ARRAY = 4;
206     uint8 private constant MAJOR_TYPE_MAP = 5;
207     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
208 
209     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
210         if(value <= 23) {
211             buf.append(uint8((major << 5) | value));
212         } else if(value <= 0xFF) {
213             buf.append(uint8((major << 5) | 24));
214             buf.appendInt(value, 1);
215         } else if(value <= 0xFFFF) {
216             buf.append(uint8((major << 5) | 25));
217             buf.appendInt(value, 2);
218         } else if(value <= 0xFFFFFFFF) {
219             buf.append(uint8((major << 5) | 26));
220             buf.appendInt(value, 4);
221         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
222             buf.append(uint8((major << 5) | 27));
223             buf.appendInt(value, 8);
224         }
225     }
226 
227     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
228         buf.append(uint8((major << 5) | 31));
229     }
230 
231     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
232         encodeType(buf, MAJOR_TYPE_INT, value);
233     }
234 
235     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
236         if(value >= 0) {
237             encodeType(buf, MAJOR_TYPE_INT, uint(value));
238         } else {
239             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
240         }
241     }
242 
243     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
244         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
245         buf.append(value);
246     }
247 
248     function encodeString(Buffer.buffer memory buf, string value) internal pure {
249         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
250         buf.append(bytes(value));
251     }
252 
253     function startArray(Buffer.buffer memory buf) internal pure {
254         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
255     }
256 
257     function startMap(Buffer.buffer memory buf) internal pure {
258         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
259     }
260 
261     function endSequence(Buffer.buffer memory buf) internal pure {
262         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
263     }
264 }
265 
266 /*
267 End solidity-cborutils
268  */
269 
270 contract usingOraclize {
271     uint constant day = 60*60*24;
272     uint constant week = 60*60*24*7;
273     uint constant month = 60*60*24*30;
274     byte constant proofType_NONE = 0x00;
275     byte constant proofType_TLSNotary = 0x10;
276     byte constant proofType_Ledger = 0x30;
277     byte constant proofType_Android = 0x40;
278     byte constant proofType_Native = 0xF0;
279     byte constant proofStorage_IPFS = 0x01;
280     uint8 constant networkID_auto = 0;
281     uint8 constant networkID_mainnet = 1;
282     uint8 constant networkID_testnet = 2;
283     uint8 constant networkID_morden = 2;
284     uint8 constant networkID_consensys = 161;
285 
286     OraclizeAddrResolverI OAR;
287 
288     OraclizeI oraclize;
289     modifier oraclizeAPI {
290         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
291             oraclize_setNetwork(networkID_auto);
292 
293         if(address(oraclize) != OAR.getAddress())
294             oraclize = OraclizeI(OAR.getAddress());
295 
296         _;
297     }
298     modifier coupon(string code){
299         oraclize = OraclizeI(OAR.getAddress());
300         _;
301     }
302 
303     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
304       return oraclize_setNetwork();
305       networkID; // silence the warning and remain backwards compatible
306     }
307     function oraclize_setNetwork() internal returns(bool){
308         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
309             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
310             oraclize_setNetworkName("eth_mainnet");
311             return true;
312         }
313         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
314             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
315             oraclize_setNetworkName("eth_ropsten3");
316             return true;
317         }
318         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
319             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
320             oraclize_setNetworkName("eth_kovan");
321             return true;
322         }
323         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
324             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
325             oraclize_setNetworkName("eth_rinkeby");
326             return true;
327         }
328         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
329             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
330             return true;
331         }
332         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
333             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
334             return true;
335         }
336         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
337             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
338             return true;
339         }
340         return false;
341     }
342 
343     function __callback(bytes32 myid, string result) public {
344         __callback(myid, result, new bytes(0));
345     }
346     function __callback(bytes32 myid, string result, bytes proof) public {
347       return;
348       myid; result; proof; // Silence compiler warnings
349     }
350 
351     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
352         return oraclize.getPrice(datasource);
353     }
354 
355     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
356         return oraclize.getPrice(datasource, gaslimit);
357     }
358 
359     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
360         uint price = oraclize.getPrice(datasource);
361         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
362         return oraclize.query.value(price)(0, datasource, arg);
363     }
364     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource);
366         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
367         return oraclize.query.value(price)(timestamp, datasource, arg);
368     }
369     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
370         uint price = oraclize.getPrice(datasource, gaslimit);
371         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
372         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
373     }
374     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
375         uint price = oraclize.getPrice(datasource, gaslimit);
376         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
377         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
378     }
379     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
380         uint price = oraclize.getPrice(datasource);
381         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
382         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
383     }
384     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource);
386         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
387         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
388     }
389     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource, gaslimit);
391         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
392         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
393     }
394     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource, gaslimit);
396         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
397         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
398     }
399     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource);
401         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
402         bytes memory args = stra2cbor(argN);
403         return oraclize.queryN.value(price)(0, datasource, args);
404     }
405     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource);
407         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
408         bytes memory args = stra2cbor(argN);
409         return oraclize.queryN.value(price)(timestamp, datasource, args);
410     }
411     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource, gaslimit);
413         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
414         bytes memory args = stra2cbor(argN);
415         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
416     }
417     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
418         uint price = oraclize.getPrice(datasource, gaslimit);
419         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
420         bytes memory args = stra2cbor(argN);
421         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
422     }
423     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
424         string[] memory dynargs = new string[](1);
425         dynargs[0] = args[0];
426         return oraclize_query(datasource, dynargs);
427     }
428     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
429         string[] memory dynargs = new string[](1);
430         dynargs[0] = args[0];
431         return oraclize_query(timestamp, datasource, dynargs);
432     }
433     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
434         string[] memory dynargs = new string[](1);
435         dynargs[0] = args[0];
436         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
437     }
438     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](1);
440         dynargs[0] = args[0];
441         return oraclize_query(datasource, dynargs, gaslimit);
442     }
443 
444     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](2);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         return oraclize_query(datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](2);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         return oraclize_query(timestamp, datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](2);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
461     }
462     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](2);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         return oraclize_query(datasource, dynargs, gaslimit);
467     }
468     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](3);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         dynargs[2] = args[2];
473         return oraclize_query(datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](3);
477         dynargs[0] = args[0];
478         dynargs[1] = args[1];
479         dynargs[2] = args[2];
480         return oraclize_query(timestamp, datasource, dynargs);
481     }
482     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
483         string[] memory dynargs = new string[](3);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
488     }
489     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](3);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         return oraclize_query(datasource, dynargs, gaslimit);
495     }
496 
497     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](4);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         return oraclize_query(datasource, dynargs);
504     }
505     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(timestamp, datasource, dynargs);
512     }
513     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
514         string[] memory dynargs = new string[](4);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
520     }
521     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](4);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         return oraclize_query(datasource, dynargs, gaslimit);
528     }
529     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](5);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         dynargs[4] = args[4];
536         return oraclize_query(datasource, dynargs);
537     }
538     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
539         string[] memory dynargs = new string[](5);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         dynargs[4] = args[4];
545         return oraclize_query(timestamp, datasource, dynargs);
546     }
547     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](5);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         dynargs[3] = args[3];
553         dynargs[4] = args[4];
554         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
555     }
556     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](5);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         dynargs[3] = args[3];
562         dynargs[4] = args[4];
563         return oraclize_query(datasource, dynargs, gaslimit);
564     }
565     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
566         uint price = oraclize.getPrice(datasource);
567         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
568         bytes memory args = ba2cbor(argN);
569         return oraclize.queryN.value(price)(0, datasource, args);
570     }
571     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
572         uint price = oraclize.getPrice(datasource);
573         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
574         bytes memory args = ba2cbor(argN);
575         return oraclize.queryN.value(price)(timestamp, datasource, args);
576     }
577     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
578         uint price = oraclize.getPrice(datasource, gaslimit);
579         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
580         bytes memory args = ba2cbor(argN);
581         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
582     }
583     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
584         uint price = oraclize.getPrice(datasource, gaslimit);
585         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
586         bytes memory args = ba2cbor(argN);
587         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
588     }
589     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
590         bytes[] memory dynargs = new bytes[](1);
591         dynargs[0] = args[0];
592         return oraclize_query(datasource, dynargs);
593     }
594     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
595         bytes[] memory dynargs = new bytes[](1);
596         dynargs[0] = args[0];
597         return oraclize_query(timestamp, datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
600         bytes[] memory dynargs = new bytes[](1);
601         dynargs[0] = args[0];
602         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
603     }
604     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](1);
606         dynargs[0] = args[0];
607         return oraclize_query(datasource, dynargs, gaslimit);
608     }
609 
610     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](2);
612         dynargs[0] = args[0];
613         dynargs[1] = args[1];
614         return oraclize_query(datasource, dynargs);
615     }
616     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](2);
618         dynargs[0] = args[0];
619         dynargs[1] = args[1];
620         return oraclize_query(timestamp, datasource, dynargs);
621     }
622     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](2);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
627     }
628     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](2);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         return oraclize_query(datasource, dynargs, gaslimit);
633     }
634     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](3);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         dynargs[2] = args[2];
639         return oraclize_query(datasource, dynargs);
640     }
641     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](3);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         dynargs[2] = args[2];
646         return oraclize_query(timestamp, datasource, dynargs);
647     }
648     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
649         bytes[] memory dynargs = new bytes[](3);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         dynargs[2] = args[2];
653         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
654     }
655     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](3);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         return oraclize_query(datasource, dynargs, gaslimit);
661     }
662 
663     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](4);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         return oraclize_query(datasource, dynargs);
670     }
671     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](4);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         return oraclize_query(timestamp, datasource, dynargs);
678     }
679     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
680         bytes[] memory dynargs = new bytes[](4);
681         dynargs[0] = args[0];
682         dynargs[1] = args[1];
683         dynargs[2] = args[2];
684         dynargs[3] = args[3];
685         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
686     }
687     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](4);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         dynargs[3] = args[3];
693         return oraclize_query(datasource, dynargs, gaslimit);
694     }
695     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](5);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         dynargs[3] = args[3];
701         dynargs[4] = args[4];
702         return oraclize_query(datasource, dynargs);
703     }
704     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
705         bytes[] memory dynargs = new bytes[](5);
706         dynargs[0] = args[0];
707         dynargs[1] = args[1];
708         dynargs[2] = args[2];
709         dynargs[3] = args[3];
710         dynargs[4] = args[4];
711         return oraclize_query(timestamp, datasource, dynargs);
712     }
713     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](5);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         dynargs[2] = args[2];
718         dynargs[3] = args[3];
719         dynargs[4] = args[4];
720         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
721     }
722     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
723         bytes[] memory dynargs = new bytes[](5);
724         dynargs[0] = args[0];
725         dynargs[1] = args[1];
726         dynargs[2] = args[2];
727         dynargs[3] = args[3];
728         dynargs[4] = args[4];
729         return oraclize_query(datasource, dynargs, gaslimit);
730     }
731 
732     function oraclize_cbAddress() oraclizeAPI internal returns (address){
733         return oraclize.cbAddress();
734     }
735     function oraclize_setProof(byte proofP) oraclizeAPI internal {
736         return oraclize.setProofType(proofP);
737     }
738     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
739         return oraclize.setCustomGasPrice(gasPrice);
740     }
741 
742     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
743         return oraclize.randomDS_getSessionPubKeyHash();
744     }
745 
746     function getCodeSize(address _addr) constant internal returns(uint _size) {
747         assembly {
748             _size := extcodesize(_addr)
749         }
750     }
751 
752     function parseAddr(string _a) internal pure returns (address){
753         bytes memory tmp = bytes(_a);
754         uint160 iaddr = 0;
755         uint160 b1;
756         uint160 b2;
757         for (uint i=2; i<2+2*20; i+=2){
758             iaddr *= 256;
759             b1 = uint160(tmp[i]);
760             b2 = uint160(tmp[i+1]);
761             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
762             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
763             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
764             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
765             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
766             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
767             iaddr += (b1*16+b2);
768         }
769         return address(iaddr);
770     }
771 
772     function strCompare(string _a, string _b) internal pure returns (int) {
773         bytes memory a = bytes(_a);
774         bytes memory b = bytes(_b);
775         uint minLength = a.length;
776         if (b.length < minLength) minLength = b.length;
777         for (uint i = 0; i < minLength; i ++)
778             if (a[i] < b[i])
779                 return -1;
780             else if (a[i] > b[i])
781                 return 1;
782         if (a.length < b.length)
783             return -1;
784         else if (a.length > b.length)
785             return 1;
786         else
787             return 0;
788     }
789 
790     function indexOf(string _haystack, string _needle) internal pure returns (int) {
791         bytes memory h = bytes(_haystack);
792         bytes memory n = bytes(_needle);
793         if(h.length < 1 || n.length < 1 || (n.length > h.length))
794             return -1;
795         else if(h.length > (2**128 -1))
796             return -1;
797         else
798         {
799             uint subindex = 0;
800             for (uint i = 0; i < h.length; i ++)
801             {
802                 if (h[i] == n[0])
803                 {
804                     subindex = 1;
805                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
806                     {
807                         subindex++;
808                     }
809                     if(subindex == n.length)
810                         return int(i);
811                 }
812             }
813             return -1;
814         }
815     }
816 
817     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
818         bytes memory _ba = bytes(_a);
819         bytes memory _bb = bytes(_b);
820         bytes memory _bc = bytes(_c);
821         bytes memory _bd = bytes(_d);
822         bytes memory _be = bytes(_e);
823         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
824         bytes memory babcde = bytes(abcde);
825         uint k = 0;
826         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
827         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
828         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
829         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
830         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
831         return string(babcde);
832     }
833 
834     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
835         return strConcat(_a, _b, _c, _d, "");
836     }
837 
838     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
839         return strConcat(_a, _b, _c, "", "");
840     }
841 
842     function strConcat(string _a, string _b) internal pure returns (string) {
843         return strConcat(_a, _b, "", "", "");
844     }
845 
846     // parseInt
847     function parseInt(string _a) internal pure returns (uint) {
848         return parseInt(_a, 0);
849     }
850 
851     // parseInt(parseFloat*10^_b)
852     function parseInt(string _a, uint _b) internal pure returns (uint) {
853         bytes memory bresult = bytes(_a);
854         uint mint = 0;
855         bool decimals = false;
856         for (uint i=0; i<bresult.length; i++){
857             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
858                 if (decimals){
859                    if (_b == 0) break;
860                     else _b--;
861                 }
862                 mint *= 10;
863                 mint += uint(bresult[i]) - 48;
864             } else if (bresult[i] == 46) decimals = true;
865         }
866         if (_b > 0) mint *= 10**_b;
867         return mint;
868     }
869 
870     function uint2str(uint i) internal pure returns (string){
871         if (i == 0) return "0";
872         uint j = i;
873         uint len;
874         while (j != 0){
875             len++;
876             j /= 10;
877         }
878         bytes memory bstr = new bytes(len);
879         uint k = len - 1;
880         while (i != 0){
881             bstr[k--] = byte(48 + i % 10);
882             i /= 10;
883         }
884         return string(bstr);
885     }
886 
887     using CBOR for Buffer.buffer;
888     function stra2cbor(string[] arr) internal pure returns (bytes) {
889         safeMemoryCleaner();
890         Buffer.buffer memory buf;
891         Buffer.init(buf, 1024);
892         buf.startArray();
893         for (uint i = 0; i < arr.length; i++) {
894             buf.encodeString(arr[i]);
895         }
896         buf.endSequence();
897         return buf.buf;
898     }
899 
900     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
901         safeMemoryCleaner();
902         Buffer.buffer memory buf;
903         Buffer.init(buf, 1024);
904         buf.startArray();
905         for (uint i = 0; i < arr.length; i++) {
906             buf.encodeBytes(arr[i]);
907         }
908         buf.endSequence();
909         return buf.buf;
910     }
911 
912     string oraclize_network_name;
913     function oraclize_setNetworkName(string _network_name) internal {
914         oraclize_network_name = _network_name;
915     }
916 
917     function oraclize_getNetworkName() internal view returns (string) {
918         return oraclize_network_name;
919     }
920 
921     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
922         require((_nbytes > 0) && (_nbytes <= 32));
923         // Convert from seconds to ledger timer ticks
924         _delay *= 10;
925         bytes memory nbytes = new bytes(1);
926         nbytes[0] = byte(_nbytes);
927         bytes memory unonce = new bytes(32);
928         bytes memory sessionKeyHash = new bytes(32);
929         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
930         assembly {
931             mstore(unonce, 0x20)
932             // the following variables can be relaxed
933             // check relaxed random contract under ethereum-examples repo
934             // for an idea on how to override and replace comit hash vars
935             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
936             mstore(sessionKeyHash, 0x20)
937             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
938         }
939         bytes memory delay = new bytes(32);
940         assembly {
941             mstore(add(delay, 0x20), _delay)
942         }
943 
944         bytes memory delay_bytes8 = new bytes(8);
945         copyBytes(delay, 24, 8, delay_bytes8, 0);
946 
947         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
948         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
949 
950         bytes memory delay_bytes8_left = new bytes(8);
951 
952         assembly {
953             let x := mload(add(delay_bytes8, 0x20))
954             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
955             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
956             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
957             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
958             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
959             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
960             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
961             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
962 
963         }
964 
965         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
966         return queryId;
967     }
968 
969     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
970         oraclize_randomDS_args[queryId] = commitment;
971     }
972 
973     mapping(bytes32=>bytes32) oraclize_randomDS_args;
974     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
975 
976     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
977         bool sigok;
978         address signer;
979 
980         bytes32 sigr;
981         bytes32 sigs;
982 
983         bytes memory sigr_ = new bytes(32);
984         uint offset = 4+(uint(dersig[3]) - 0x20);
985         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
986         bytes memory sigs_ = new bytes(32);
987         offset += 32 + 2;
988         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
989 
990         assembly {
991             sigr := mload(add(sigr_, 32))
992             sigs := mload(add(sigs_, 32))
993         }
994 
995 
996         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
997         if (address(keccak256(pubkey)) == signer) return true;
998         else {
999             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1000             return (address(keccak256(pubkey)) == signer);
1001         }
1002     }
1003 
1004     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1005         bool sigok;
1006 
1007         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1008         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1009         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1010 
1011         bytes memory appkey1_pubkey = new bytes(64);
1012         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1013 
1014         bytes memory tosign2 = new bytes(1+65+32);
1015         tosign2[0] = byte(1); //role
1016         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1017         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1018         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1019         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1020 
1021         if (sigok == false) return false;
1022 
1023 
1024         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1025         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1026 
1027         bytes memory tosign3 = new bytes(1+65);
1028         tosign3[0] = 0xFE;
1029         copyBytes(proof, 3, 65, tosign3, 1);
1030 
1031         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1032         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1033 
1034         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1035 
1036         return sigok;
1037     }
1038 
1039     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1040         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1041         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1042 
1043         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1044         require(proofVerified);
1045 
1046         _;
1047     }
1048 
1049     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1050         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1051         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1052 
1053         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1054         if (proofVerified == false) return 2;
1055 
1056         return 0;
1057     }
1058 
1059     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1060         bool match_ = true;
1061 
1062         require(prefix.length == n_random_bytes);
1063 
1064         for (uint256 i=0; i< n_random_bytes; i++) {
1065             if (content[i] != prefix[i]) match_ = false;
1066         }
1067 
1068         return match_;
1069     }
1070 
1071     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1072 
1073         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1074         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1075         bytes memory keyhash = new bytes(32);
1076         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1077         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1078 
1079         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1080         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1081 
1082         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1083         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1084 
1085         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1086         // This is to verify that the computed args match with the ones specified in the query.
1087         bytes memory commitmentSlice1 = new bytes(8+1+32);
1088         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1089 
1090         bytes memory sessionPubkey = new bytes(64);
1091         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1092         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1093 
1094         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1095         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1096             delete oraclize_randomDS_args[queryId];
1097         } else return false;
1098 
1099 
1100         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1101         bytes memory tosign1 = new bytes(32+8+1+32);
1102         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1103         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1104 
1105         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1106         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1107             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1108         }
1109 
1110         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1111     }
1112 
1113     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1114     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1115         uint minLength = length + toOffset;
1116 
1117         // Buffer too small
1118         require(to.length >= minLength); // Should be a better way?
1119 
1120         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1121         uint i = 32 + fromOffset;
1122         uint j = 32 + toOffset;
1123 
1124         while (i < (32 + fromOffset + length)) {
1125             assembly {
1126                 let tmp := mload(add(from, i))
1127                 mstore(add(to, j), tmp)
1128             }
1129             i += 32;
1130             j += 32;
1131         }
1132 
1133         return to;
1134     }
1135 
1136     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1137     // Duplicate Solidity's ecrecover, but catching the CALL return value
1138     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1139         // We do our own memory management here. Solidity uses memory offset
1140         // 0x40 to store the current end of memory. We write past it (as
1141         // writes are memory extensions), but don't update the offset so
1142         // Solidity will reuse it. The memory used here is only needed for
1143         // this context.
1144 
1145         // FIXME: inline assembly can't access return values
1146         bool ret;
1147         address addr;
1148 
1149         assembly {
1150             let size := mload(0x40)
1151             mstore(size, hash)
1152             mstore(add(size, 32), v)
1153             mstore(add(size, 64), r)
1154             mstore(add(size, 96), s)
1155 
1156             // NOTE: we can reuse the request memory because we deal with
1157             //       the return code
1158             ret := call(3000, 1, 0, size, 128, size, 32)
1159             addr := mload(size)
1160         }
1161 
1162         return (ret, addr);
1163     }
1164 
1165     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1166     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1167         bytes32 r;
1168         bytes32 s;
1169         uint8 v;
1170 
1171         if (sig.length != 65)
1172           return (false, 0);
1173 
1174         // The signature format is a compact form of:
1175         //   {bytes32 r}{bytes32 s}{uint8 v}
1176         // Compact means, uint8 is not padded to 32 bytes.
1177         assembly {
1178             r := mload(add(sig, 32))
1179             s := mload(add(sig, 64))
1180 
1181             // Here we are loading the last 32 bytes. We exploit the fact that
1182             // 'mload' will pad with zeroes if we overread.
1183             // There is no 'mload8' to do this, but that would be nicer.
1184             v := byte(0, mload(add(sig, 96)))
1185 
1186             // Alternative solution:
1187             // 'byte' is not working due to the Solidity parser, so lets
1188             // use the second best option, 'and'
1189             // v := and(mload(add(sig, 65)), 255)
1190         }
1191 
1192         // albeit non-transactional signatures are not specified by the YP, one would expect it
1193         // to match the YP range of [27, 28]
1194         //
1195         // geth uses [0, 1] and some clients have followed. This might change, see:
1196         //  https://github.com/ethereum/go-ethereum/issues/2053
1197         if (v < 27)
1198           v += 27;
1199 
1200         if (v != 27 && v != 28)
1201             return (false, 0);
1202 
1203         return safer_ecrecover(hash, v, r, s);
1204     }
1205 
1206     function safeMemoryCleaner() internal pure {
1207         assembly {
1208             let fmem := mload(0x40)
1209             codecopy(fmem, codesize, sub(msize, fmem))
1210         }
1211     }
1212 
1213 }
1214 contract safeApi{
1215     
1216    modifier safe(){
1217         address _addr = msg.sender;
1218         require (_addr == tx.origin,'Error Action!');
1219         uint256 _codeLength;
1220         assembly {_codeLength := extcodesize(_addr)}
1221         require(_codeLength == 0, "Sender not authorized!");
1222             _;
1223     }
1224 
1225 
1226     
1227  function toBytes(uint256 _num) internal returns (bytes _ret) {
1228    assembly {
1229         _ret := mload(0x10)
1230         mstore(_ret, 0x20)
1231         mstore(add(_ret, 0x20), _num)
1232     }
1233 }
1234 
1235 function subStr(string _s, uint start, uint end) internal pure returns (string){
1236         bytes memory s = bytes(_s);
1237         string memory copy = new string(end - start);
1238 //        string memory copy = new string(5);
1239           uint k = 0;
1240         for (uint i = start; i < end; i++){ 
1241             bytes(copy)[k++] = bytes(_s)[i];
1242         }
1243         return copy;
1244     }
1245      
1246 
1247  function safePercent(uint256 a,uint256 b) 
1248       internal
1249       constant
1250       returns(uint256)
1251       {
1252         assert(a>0 && a <=100);
1253         return  div(mul(b,a),100);
1254       }
1255       
1256   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1257     uint256 c = a * b;
1258     assert(a == 0 || c / a == b);
1259     return c;
1260   }
1261  
1262   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1263     // assert(b > 0); // Solidity automatically throws when dividing by 0∂
1264     uint256 c = a / b;
1265     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1266     return c;
1267   }
1268  
1269   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1270     assert(b <= a);
1271     return a - b;
1272   }
1273  
1274   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1275     uint256 c = a + b;
1276     assert(c >= a);
1277     return c;
1278   }
1279 
1280 }
1281 contract gameDicePk is safeApi,usingOraclize{
1282 mapping(bytes32=>uint256) private validQueryId;
1283     struct player
1284     {
1285         uint256 id;
1286         uint256 balance;//wei
1287         uint256 timeStamp;
1288         address addr;
1289     }
1290 
1291     struct  gameConfig
1292     {
1293         uint256 buyDrawScale;
1294         uint256 minBetWei;
1295         uint256 maxBetWei;
1296         uint256 countdown;
1297         uint256 pushWei;
1298         uint8 cancelFeePct;
1299         uint8 winnerFeePct;
1300     }
1301 
1302     struct  table
1303     {
1304         uint256 betAmount;
1305         uint256 endTime;
1306         uint8  openIndex;
1307         uint8  status;//1 has opened the table, 2 has started, 3 is waiting for the draw, 4 has been completed, 5 canceled
1308         uint8   diceA;
1309         uint8   diceB;
1310         mapping(uint8=>uint256) position;
1311     }
1312    
1313    event Bet(
1314        address indexed _addr,
1315        uint256 _tableId,
1316        uint256 _amount, 
1317        uint8 _position,
1318        uint8 indexed _status,
1319        uint8 _posStatus,
1320        uint256 _endTime
1321      );
1322 
1323   event Cancel( uint256 indexed _tableId);
1324 
1325   event Finish(
1326         uint256 _tableId,
1327         uint256 _amount,
1328         uint256 indexed pos1,
1329         uint256 indexed pos2,
1330         uint256 indexed pos3,
1331         uint8 _position,//Marked position is occupied 1 1-2, 2 2-3, 3 1-3, 4,123
1332         uint8 _diceA,
1333         uint8 _diceB
1334       );
1335 
1336     mapping (uint256 => player) public player_;
1337     mapping (address => uint256) public playAddr_;
1338     mapping (uint256 => uint256) public playAff_;
1339     mapping(uint256 => table) private tables_;
1340      uint256[200] openTable_;//Maximum free table number 200
1341      gameConfig public gameConfig_;
1342      address public admin__;
1343      uint256 private autoPlayId_=123456;
1344      uint256 private autoTableId_=0;
1345      uint32 private  CUSTOM_GASLIMIT =150000;//Cost of payment calculation gas
1346     
1347      constructor() public {
1348             admin__ = msg.sender;
1349             uint256 gasPrice=10100000000;//10.1GWEI
1350             oraclize_setCustomGasPrice(gasPrice);//Sent to the draw absenteeism Gwei
1351             gameConfig_=gameConfig(
1352           3,//Buy a draw bid 1/3
1353           60000000000000000,//0.06 eth Minimum 
1354           12000000000000000000,//12 eth Maximum
1355            300 seconds,//Delayed Draw 5 minutes
1356           gasPrice*CUSTOM_GASLIMIT,//Total cost of Mining to be paid
1357           3//Cancellation fees% - Partially used to pay the Mining fee
1358           ,6//Winner handling Fee% - Partially used to pay the Mining fee
1359          );
1360         getPlayId(admin__);
1361     }
1362  
1363 
1364  function withdraw(uint256 pid) safe() external{
1365         require(playAddr_[msg.sender] == pid,'Error Action');
1366         require(player_[pid].addr == msg.sender,'Error Action');
1367         require(player_[pid].balance >0,'Insufficient balance');
1368         uint256 balance =player_[pid].balance;
1369         player_[pid].balance=0;
1370         return player_[pid].addr.transfer(balance);
1371     }
1372     
1373     //Lottery callback
1374     function __callback(bytes32 myid, string result) public  {
1375             require (validQueryId[myid] > 0,'Error!');
1376             uint256 _tableId=validQueryId[myid];
1377             delete validQueryId[myid];
1378             require(msg.sender == oraclize_cbAddress(),'Error 1');
1379             __lottery(_tableId,result);
1380     }
1381      
1382      
1383      //Lottery program core code   
1384       function __lottery(uint256 _tableId,string strNumber) private safe(){
1385                 table storage _t=tables_[_tableId];
1386                 require(_t.status==2 || _t.status==3,'Error 2');
1387                 require(now > _t.endTime,'Error3');
1388                 uint256  diceA=parseInt(subStr(strNumber,0,1));
1389                 require(diceA >=1 && diceA <=6,'Error4');
1390                 uint256  diceB=parseInt(subStr(strNumber,2,3));
1391                 require(diceB >=1 && diceB <=6,'Error5');
1392                 _t.status=4;
1393                 _t.diceA=uint8(diceA);
1394                 _t.diceB=uint8(diceB);
1395                
1396                 openTable_[_t.openIndex]=0;//Mark the table as free
1397               
1398             winnerTransfer(_tableId,_t);
1399             
1400             emit Finish(
1401             _tableId,_t.betAmount,
1402             tables_[_tableId].position[1],
1403             tables_[_tableId].position[2],
1404             tables_[_tableId].position[3],
1405             getPosStatus(_tableId),_t.diceA,_t.diceB
1406             );
1407       }
1408       
1409       //Transfer eth to the winner
1410       function winnerTransfer(uint256 _tableId,table storage _t) private{
1411           
1412             uint8 winPos=0;
1413               //Verification winner
1414               if(_t.diceA>_t.diceB){
1415                   winPos=1;
1416               }else if(_t.diceB>_t.diceA){
1417                   winPos=2;
1418               }else{
1419                   winPos=3;
1420               }
1421               
1422               //The total prize ETH 
1423               uint256 _balance=0;
1424                 
1425               if(_t.position[1]>0){
1426                   _balance=_t.betAmount;
1427               }
1428               if(_t.position[2]>0){
1429                    _balance=add(_balance,_t.betAmount);
1430               }
1431               if(_t.position[3]>0){
1432                      _balance=add(_balance,div(_t.betAmount,gameConfig_.buyDrawScale));
1433               }
1434               //winner player
1435               uint256 _winPid=_t.position[winPos];
1436               uint256 _systemFee=0;
1437          
1438               //Give the winner ETH
1439               if(_winPid>0){
1440                _systemFee=safePercent(gameConfig_.winnerFeePct,_balance);
1441                player_[_winPid].balance=add(player_[_winPid].balance,sub(_balance,_systemFee));
1442               }else{
1443                 //No winners, return ETH
1444                  uint256 _fee=0;
1445               if(_t.position[1]>0){
1446                  uint256 _pos1Pid=_t.position[1];
1447                 _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1448                  _systemFee=_fee;
1449                  player_[_pos1Pid].balance=add(player_[_pos1Pid].balance,sub(_t.betAmount,_fee));
1450               }
1451               if(_t.position[2]>0){
1452                  uint256 _pos2Pid=_t.position[2];
1453                  _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1454                  _systemFee=add(_systemFee,_fee);
1455                  player_[_pos2Pid].balance=add(player_[_pos2Pid].balance,sub(_t.betAmount,_fee));
1456               }
1457               
1458               if(_t.position[3]>0){
1459                  uint256 _pos3Pid=_t.position[3];
1460                  uint256 _pos3Amount=div(_t.betAmount,gameConfig_.buyDrawScale);
1461                  _fee=safePercent(gameConfig_.cancelFeePct,_pos3Amount);
1462                  _systemFee=add(_systemFee,_fee);
1463                  player_[_pos3Pid].balance=add(player_[_pos3Pid].balance,sub(_pos3Amount,_fee));
1464               }
1465            }
1466               uint256 _adminId=playAddr_[admin__];
1467               _systemFee=sub(_systemFee,gameConfig_.pushWei);//The admin bears the Fees of the mining
1468               player_[_adminId].balance= add(player_[_adminId].balance,_systemFee);
1469       }
1470       
1471       //Marked position is occupied
1472       function getPosStatus(uint256 _tableId) private view returns(uint8){
1473            table storage  _t=tables_[_tableId];
1474             if(_t.status==1)
1475                     return 0;
1476                 uint8 _posStatus=3;
1477                 // 1 1-2, 2 2-3, 3 1-3, 4 123
1478                 if(_t.position[1]>0 && _t.position[2]>0 && _t.position[3]>0){
1479                     _posStatus=4;
1480                 }else if(_t.position[1]>0 && _t.position[2]>0){
1481                       _posStatus=1;
1482                 }else if(_t.position[2]>0 && _t.position[3]>0){
1483                        _posStatus=2;
1484                 }
1485           return _posStatus;
1486       }
1487 
1488     //Considering the failure of the draw HTTP request, there will be a table with no results to manually cancel the return to ETH
1489     function closeTable(uint256 _tableId) safe() external{
1490             require(msg.sender == admin__,'Error 1');
1491              table storage _t=tables_[_tableId];
1492              //Must have passed the draw time
1493              require(now > _t.endTime,'Error 2');
1494              require(_t.status>=1 && _t.status <=3,'Error 3');
1495           
1496                  _t.status=5;//Set to cancel
1497                 openTable_[_t.openIndex]=0;
1498       
1499                 uint256 _fee=0;
1500                 uint256 _systemFee=0;
1501               if(_t.position[1]>0){
1502                  uint256 _pos1Pid=_t.position[1];
1503                 _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1504                  _systemFee=_fee;
1505                  player_[_pos1Pid].balance=add(player_[_pos1Pid].balance,sub(_t.betAmount,_fee));
1506               }
1507            
1508               if(_t.position[2]>0){
1509                  uint256 _pos2Pid=_t.position[2];
1510                  _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1511                  _systemFee=add(_systemFee,_fee);
1512                  player_[_pos2Pid].balance=add(player_[_pos2Pid].balance,sub(_t.betAmount,_fee));
1513               }
1514               
1515               if(_t.position[3]>0){
1516                  uint256 _pos3Pid=_t.position[3];
1517                  uint256 _pos3Amount=div(_t.betAmount,gameConfig_.buyDrawScale);
1518                  _fee=safePercent(gameConfig_.cancelFeePct,_pos3Amount);
1519                  _systemFee=add(_systemFee,_fee);
1520                  player_[_pos3Pid].balance=add(player_[_pos3Pid].balance,sub(_pos3Amount,_fee));
1521               }
1522               require(_systemFee>=gameConfig_.pushWei,'Error 4');
1523               uint256 _adminId=playAddr_[admin__];
1524               _systemFee=sub(_systemFee,gameConfig_.pushWei);//The admin bears the lottery fee
1525               player_[_adminId].balance= add(player_[_adminId].balance,_systemFee);
1526               emit Cancel(_tableId);
1527     }
1528     
1529        function bet(uint256 _tableId,uint8 _position) safe() external payable{
1530         uint256 _value=msg.value;
1531         uint256 _valueTemp=_value;
1532         require(_position >=1 && _position<=3,'Error1');   
1533         uint256 _tid=_tableId;
1534         table storage _t=tables_[_tid];
1535         uint256 _now=now;
1536         
1537         //If the location is already or has already won the prize or the number is full, reopen the table. 
1538         // If there are already 2 people, judge whether the purchase time is exceeded.
1539          uint256 _pid= getPlayId(msg.sender);
1540         if(_tid==0 || _tableId>autoTableId_ ||  _t.position[_position] >0  || _t.status >=3 || (_t.status==2 && _now > _t.endTime)){
1541             //The bid for a draw is 1/3;
1542             _valueTemp= _position==3?mul(_value,gameConfig_.buyDrawScale):_value;
1543             require(_valueTemp >=gameConfig_.minBetWei && 
1544             _valueTemp<=gameConfig_.maxBetWei,'The amount of bet is in the range of 0.06-12 ETH');   
1545             require(_valueTemp%gameConfig_.minBetWei==0,'The amount of bet is in the range of 0.06-12 ETH');
1546             autoTableId_++;
1547             _tid=autoTableId_;
1548             _t=tables_[_tid];
1549            
1550            //The first person to bet determines the ETH of the bet
1551            _t.betAmount=_valueTemp;
1552            uint8 openIndex= getOpenTableIndex();
1553            require(openIndex<200,'Error 8');
1554            openTable_[openIndex]=_tid;
1555            _t.openIndex=openIndex;
1556             
1557        }else{
1558         //Only one bet is allowed per table per person
1559         require(_t.position[1]!=_pid &&  _t.position[2]!=_pid  && _t.position[3]!=_pid,'Error7'); 
1560               //Buy flat bid validation
1561               if(_position==3){
1562                 require (_value == div(_t.betAmount,gameConfig_.buyDrawScale),'Error5');
1563               }else{
1564                 //Buy a winning bid
1565                 require (_value ==_t.betAmount,'Error6');
1566               }
1567        }
1568        _t.status++;
1569         //A 2-person game starts the countdown.
1570       if(_t.status==2){
1571          _t.endTime=add(_now,gameConfig_.countdown);
1572          
1573       //Verify that the balance is sufficient for the draw absenteeism lottery
1574       require(address(this).balance>=gameConfig_.pushWei,'Oraclize query was NOT sent, please add some ETH to cover for the query fee');
1575       //Countdown Draw
1576       bytes32 queryId =
1577         oraclize_query(gameConfig_.countdown, "URL", 
1578         "html(https://www.random.org/dice/?num=2).xpath(concat((//p/img[@alt>0]/@alt)[1],'|',(//p/img[@alt>0]/@alt)[last()]))",
1579         CUSTOM_GASLIMIT);
1580        validQueryId[queryId]=_tid;
1581      }
1582         _t.position[_position]=_pid;//Put the user on the seat
1583         emit Bet(msg.sender,_tid,_value,_position,_t.status,getPosStatus(_tid),_t.endTime);
1584 }
1585     
1586     
1587     function getTableInfo(uint256 _tableId) view external  returns(
1588         uint256,uint256,uint256,uint256,uint8,uint8,uint8,uint256
1589         ){
1590          table storage _t=tables_[_tableId];
1591           return (
1592              _t.betAmount,
1593            _t.position[1],
1594            _t.position[2],
1595            _t.position[3],
1596             _t.status,
1597             _t.diceA,
1598             _t.diceB,
1599            _t.endTime
1600          );
1601     }
1602     
1603 
1604   function getOpenTableIndex() view private returns(uint8){
1605        for(uint8 i=0;i<openTable_.length;i++){
1606            if(openTable_[i]==0)
1607             return i;
1608        }
1609        return 201;
1610    }
1611    
1612    //Get a list of available tables
1613     function getOpenTableList() external view  returns(uint256[200]){
1614        return openTable_;
1615    }
1616      //2020.01.01 Close Game Used to update the game
1617    function closeGame() external safe() {
1618         uint256 closeTime=1577808000;
1619         require(now > closeTime,'Time has not arrived');
1620         require(msg.sender == admin__,'Error');
1621         selfdestruct(admin__);
1622     }
1623    
1624     function getPlayId(address addr) private returns(uint256){
1625         require (address(0)!=addr,'Error Addr');
1626         if(playAddr_[addr] >0){
1627          return playAddr_[addr];
1628         }
1629               autoPlayId_++;
1630               playAddr_[addr]=autoPlayId_;
1631               player memory _p;
1632               _p.id=autoPlayId_;
1633               _p.addr=addr;
1634               _p.timeStamp=now;
1635               player_[autoPlayId_]=_p;
1636               return autoPlayId_;
1637    }
1638 
1639 }