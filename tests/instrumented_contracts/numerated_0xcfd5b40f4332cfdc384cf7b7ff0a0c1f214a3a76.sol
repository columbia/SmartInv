1 /**
2  *  The Consumer Contract Wallet
3  *  Copyright (C) 2018 The Contract Wallet Company Limited
4  *
5  *  This program is free software: you can redistribute it and/or modify
6  *  it under the terms of the GNU General Public License as published by
7  *  the Free Software Foundation, either version 3 of the License, or
8  *  (at your option) any later version.
9  *
10  *  This program is distributed in the hope that it will be useful,
11  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
12  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  *  GNU General Public License for more details.
14  *
15  *  You should have received a copy of the GNU General Public License
16  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
17  */
18 
19 pragma solidity ^0.4.25;
20 
21 /// @title The Controller interface provides access to an external list of controllers.
22 interface IController {
23     function isController(address) external view returns (bool);
24 }
25 
26 /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
27 contract Controller is IController {
28     event AddedController(address _sender, address _controller);
29     event RemovedController(address _sender, address _controller);
30 
31     mapping (address => bool) private _isController;
32     uint private _controllerCount;
33 
34     /// @dev Constructor initializes the list of controllers with the provided address.
35     /// @param _account address to add to the list of controllers.
36     constructor(address _account) public {
37         _addController(_account);
38     }
39 
40     /// @dev Checks if message sender is a controller.
41     modifier onlyController() {
42         require(isController(msg.sender), "sender is not a controller");
43         _;
44     }
45 
46     /// @dev Add a new controller to the list of controllers.
47     /// @param _account address to add to the list of controllers.
48     function addController(address _account) external onlyController {
49         _addController(_account);
50     }
51 
52     /// @dev Remove a controller from the list of controllers.
53     /// @param _account address to remove from the list of controllers.
54     function removeController(address _account) external onlyController {
55         _removeController(_account);
56     }
57 
58     /// @return true if the provided account is a controller.
59     function isController(address _account) public view returns (bool) {
60         return _isController[_account];
61     }
62 
63     /// @return the current number of controllers.
64     function controllerCount() public view returns (uint) {
65         return _controllerCount;
66     }
67 
68     /// @dev Internal-only function that adds a new controller.
69     function _addController(address _account) internal {
70         require(!_isController[_account], "provided account is already a controller");
71         _isController[_account] = true;
72         _controllerCount++;
73         emit AddedController(msg.sender, _account);
74     }
75 
76     /// @dev Internal-only function that removes an existing controller.
77     function _removeController(address _account) internal {
78         require(_isController[_account], "provided account is not a controller");
79         require(_controllerCount > 1, "cannot remove the last controller");
80         _isController[_account] = false;
81         _controllerCount--;
82         emit RemovedController(msg.sender, _account);
83     }
84 }
85 
86 /**
87  * BSD 2-Clause License
88  *
89  * Copyright (c) 2018, True Names Limited
90  * All rights reserved.
91  *
92  * Redistribution and use in source and binary forms, with or without
93  * modification, are permitted provided that the following conditions are met:
94  *
95  * * Redistributions of source code must retain the above copyright notice, this
96  *   list of conditions and the following disclaimer.
97  *
98  * * Redistributions in binary form must reproduce the above copyright notice,
99  *   this list of conditions and the following disclaimer in the documentation
100  *   and/or other materials provided with the distribution.
101  *
102  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
103  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
104  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
105  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
106  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
107  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
108  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
109  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
110  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
111  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
112 */
113 
114 interface ENS {
115 
116     // Logged when the owner of a node assigns a new owner to a subnode.
117     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
118 
119     // Logged when the owner of a node transfers ownership to a new account.
120     event Transfer(bytes32 indexed node, address owner);
121 
122     // Logged when the resolver for a node changes.
123     event NewResolver(bytes32 indexed node, address resolver);
124 
125     // Logged when the TTL of a node changes
126     event NewTTL(bytes32 indexed node, uint64 ttl);
127 
128 
129     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
130     function setResolver(bytes32 node, address resolver) public;
131     function setOwner(bytes32 node, address owner) public;
132     function setTTL(bytes32 node, uint64 ttl) public;
133     function owner(bytes32 node) public view returns (address);
134     function resolver(bytes32 node) public view returns (address);
135     function ttl(bytes32 node) public view returns (uint64);
136 
137 }
138 
139 /// @title Resolver returns the controller contract address.
140 interface IResolver {
141     function addr(bytes32) external view returns (address);
142 }
143 
144 /// @title Controllable implements access control functionality based on a controller set in ENS.
145 contract Controllable {
146     /// @dev _ENS points to the ENS registry smart contract.
147     ENS private _ENS;
148     /// @dev Is the registered ENS name of the controller contract.
149     bytes32 private _node;
150 
151     /// @dev Constructor initializes the controller contract object.
152     /// @param _ens is the address of the ENS.
153     /// @param _controllerName is the ENS name of the Controller.
154     constructor(address _ens, bytes32 _controllerName) internal {
155       _ENS = ENS(_ens);
156       _node = _controllerName;
157     }
158 
159     /// @dev Checks if message sender is the controller.
160     modifier onlyController() {
161         require(_isController(msg.sender), "sender is not a controller");
162         _;
163     }
164 
165     /// @return true if the provided account is the controller.
166     function _isController(address _account) internal view returns (bool) {
167         return IController(IResolver(_ENS.resolver(_node)).addr(_node)).isController(_account);
168     }
169 }
170 
171 /// @title Date provides date parsing functionality.
172 contract Date {
173 
174     bytes32 constant private JANUARY = keccak256("Jan");
175     bytes32 constant private FEBRUARY = keccak256("Feb");
176     bytes32 constant private MARCH = keccak256("Mar");
177     bytes32 constant private APRIL = keccak256("Apr");
178     bytes32 constant private MAY = keccak256("May");
179     bytes32 constant private JUNE = keccak256("Jun");
180     bytes32 constant private JULY = keccak256("Jul");
181     bytes32 constant private AUGUST = keccak256("Aug");
182     bytes32 constant private SEPTEMBER = keccak256("Sep");
183     bytes32 constant private OCTOBER = keccak256("Oct");
184     bytes32 constant private NOVEMBER = keccak256("Nov");
185     bytes32 constant private DECEMBER = keccak256("Dec");
186 
187     /// @return the number of the month based on its name.
188     /// @param _month the first three letters of a month's name e.g. "Jan".
189     function _monthToNumber(string _month) internal pure returns (uint8) {
190         bytes32 month = keccak256(abi.encodePacked(_month));
191         if (month == JANUARY) {
192             return 1;
193         } else if (month == FEBRUARY) {
194             return 2;
195         } else if (month == MARCH) {
196             return 3;
197         } else if (month == APRIL) {
198             return 4;
199         } else if (month == MAY) {
200             return 5;
201         } else if (month == JUNE) {
202             return 6;
203         } else if (month == JULY) {
204             return 7;
205         } else if (month == AUGUST) {
206             return 8;
207         } else if (month == SEPTEMBER) {
208             return 9;
209         } else if (month == OCTOBER) {
210             return 10;
211         } else if (month == NOVEMBER) {
212             return 11;
213         } else if (month == DECEMBER) {
214             return 12;
215         } else {
216             revert("not a valid month");
217         }
218     }
219 }
220 
221 // <ORACLIZE_API>
222 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
223 /*
224 Copyright (c) 2015-2016 Oraclize SRL
225 Copyright (c) 2016 Oraclize LTD
226 
227 
228 
229 Permission is hereby granted, free of charge, to any person obtaining a copy
230 of this software and associated documentation files (the "Software"), to deal
231 in the Software without restriction, including without limitation the rights
232 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
233 copies of the Software, and to permit persons to whom the Software is
234 furnished to do so, subject to the following conditions:
235 
236 
237 
238 The above copyright notice and this permission notice shall be included in
239 all copies or substantial portions of the Software.
240 
241 
242 
243 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
244 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
245 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
246 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
247 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
248 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
249 THE SOFTWARE.
250 */
251 
252 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
253 
254 pragma solidity >=0.4.22;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
255 
256 contract OraclizeI {
257     address public cbAddress;
258     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
259     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
260     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
261     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
262     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
263     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
264     function getPrice(string _datasource) public returns (uint _dsprice);
265     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
266     function setProofType(byte _proofType) external;
267     function setCustomGasPrice(uint _gasPrice) external;
268     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
269 }
270 
271 contract OraclizeAddrResolverI {
272     function getAddress() public returns (address _addr);
273 }
274 
275 /*
276 Begin solidity-cborutils
277 
278 https://github.com/smartcontractkit/solidity-cborutils
279 
280 MIT License
281 
282 Copyright (c) 2018 SmartContract ChainLink, Ltd.
283 
284 Permission is hereby granted, free of charge, to any person obtaining a copy
285 of this software and associated documentation files (the "Software"), to deal
286 in the Software without restriction, including without limitation the rights
287 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
288 copies of the Software, and to permit persons to whom the Software is
289 furnished to do so, subject to the following conditions:
290 
291 The above copyright notice and this permission notice shall be included in all
292 copies or substantial portions of the Software.
293 
294 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
295 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
296 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
297 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
298 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
299 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
300 SOFTWARE.
301  */
302 
303 library Buffer {
304     struct buffer {
305         bytes buf;
306         uint capacity;
307     }
308 
309     function init(buffer memory buf, uint _capacity) internal pure {
310         uint capacity = _capacity;
311         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
312         // Allocate space for the buffer data
313         buf.capacity = capacity;
314         assembly {
315             let ptr := mload(0x40)
316             mstore(buf, ptr)
317             mstore(ptr, 0)
318             mstore(0x40, add(ptr, capacity))
319         }
320     }
321 
322     function resize(buffer memory buf, uint capacity) private pure {
323         bytes memory oldbuf = buf.buf;
324         init(buf, capacity);
325         append(buf, oldbuf);
326     }
327 
328     function max(uint a, uint b) private pure returns(uint) {
329         if(a > b) {
330             return a;
331         }
332         return b;
333     }
334 
335     /**
336      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
337      *      would exceed the capacity of the buffer.
338      * @param buf The buffer to append to.
339      * @param data The data to append.
340      * @return The original buffer.
341      */
342     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
343         if(data.length + buf.buf.length > buf.capacity) {
344             resize(buf, max(buf.capacity, data.length) * 2);
345         }
346 
347         uint dest;
348         uint src;
349         uint len = data.length;
350         assembly {
351             // Memory address of the buffer data
352             let bufptr := mload(buf)
353             // Length of existing buffer data
354             let buflen := mload(bufptr)
355             // Start address = buffer address + buffer length + sizeof(buffer length)
356             dest := add(add(bufptr, buflen), 32)
357             // Update buffer length
358             mstore(bufptr, add(buflen, mload(data)))
359             src := add(data, 32)
360         }
361 
362         // Copy word-length chunks while possible
363         for(; len >= 32; len -= 32) {
364             assembly {
365                 mstore(dest, mload(src))
366             }
367             dest += 32;
368             src += 32;
369         }
370 
371         // Copy remaining bytes
372         uint mask = 256 ** (32 - len) - 1;
373         assembly {
374             let srcpart := and(mload(src), not(mask))
375             let destpart := and(mload(dest), mask)
376             mstore(dest, or(destpart, srcpart))
377         }
378 
379         return buf;
380     }
381 
382     /**
383      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
384      * exceed the capacity of the buffer.
385      * @param buf The buffer to append to.
386      * @param data The data to append.
387      * @return The original buffer.
388      */
389     function append(buffer memory buf, uint8 data) internal pure {
390         if(buf.buf.length + 1 > buf.capacity) {
391             resize(buf, buf.capacity * 2);
392         }
393 
394         assembly {
395             // Memory address of the buffer data
396             let bufptr := mload(buf)
397             // Length of existing buffer data
398             let buflen := mload(bufptr)
399             // Address = buffer address + buffer length + sizeof(buffer length)
400             let dest := add(add(bufptr, buflen), 32)
401             mstore8(dest, data)
402             // Update buffer length
403             mstore(bufptr, add(buflen, 1))
404         }
405     }
406 
407     /**
408      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
409      * exceed the capacity of the buffer.
410      * @param buf The buffer to append to.
411      * @param data The data to append.
412      * @return The original buffer.
413      */
414     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
415         if(len + buf.buf.length > buf.capacity) {
416             resize(buf, max(buf.capacity, len) * 2);
417         }
418 
419         uint mask = 256 ** len - 1;
420         assembly {
421             // Memory address of the buffer data
422             let bufptr := mload(buf)
423             // Length of existing buffer data
424             let buflen := mload(bufptr)
425             // Address = buffer address + buffer length + sizeof(buffer length) + len
426             let dest := add(add(bufptr, buflen), len)
427             mstore(dest, or(and(mload(dest), not(mask)), data))
428             // Update buffer length
429             mstore(bufptr, add(buflen, len))
430         }
431         return buf;
432     }
433 }
434 
435 library CBOR {
436     using Buffer for Buffer.buffer;
437 
438     uint8 private constant MAJOR_TYPE_INT = 0;
439     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
440     uint8 private constant MAJOR_TYPE_BYTES = 2;
441     uint8 private constant MAJOR_TYPE_STRING = 3;
442     uint8 private constant MAJOR_TYPE_ARRAY = 4;
443     uint8 private constant MAJOR_TYPE_MAP = 5;
444     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
445 
446     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
447         if(value <= 23) {
448             buf.append(uint8((major << 5) | value));
449         } else if(value <= 0xFF) {
450             buf.append(uint8((major << 5) | 24));
451             buf.appendInt(value, 1);
452         } else if(value <= 0xFFFF) {
453             buf.append(uint8((major << 5) | 25));
454             buf.appendInt(value, 2);
455         } else if(value <= 0xFFFFFFFF) {
456             buf.append(uint8((major << 5) | 26));
457             buf.appendInt(value, 4);
458         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
459             buf.append(uint8((major << 5) | 27));
460             buf.appendInt(value, 8);
461         }
462     }
463 
464     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
465         buf.append(uint8((major << 5) | 31));
466     }
467 
468     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
469         encodeType(buf, MAJOR_TYPE_INT, value);
470     }
471 
472     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
473         if(value >= 0) {
474             encodeType(buf, MAJOR_TYPE_INT, uint(value));
475         } else {
476             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
477         }
478     }
479 
480     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
481         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
482         buf.append(value);
483     }
484 
485     function encodeString(Buffer.buffer memory buf, string value) internal pure {
486         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
487         buf.append(bytes(value));
488     }
489 
490     function startArray(Buffer.buffer memory buf) internal pure {
491         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
492     }
493 
494     function startMap(Buffer.buffer memory buf) internal pure {
495         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
496     }
497 
498     function endSequence(Buffer.buffer memory buf) internal pure {
499         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
500     }
501 }
502 
503 /*
504 End solidity-cborutils
505  */
506 
507 contract usingOraclize {
508     uint constant day = 60*60*24;
509     uint constant week = 60*60*24*7;
510     uint constant month = 60*60*24*30;
511     byte constant proofType_NONE = 0x00;
512     byte constant proofType_TLSNotary = 0x10;
513     byte constant proofType_Ledger = 0x30;
514     byte constant proofType_Android = 0x40;
515     byte constant proofType_Native = 0xF0;
516     byte constant proofStorage_IPFS = 0x01;
517     uint8 constant networkID_auto = 0;
518     uint8 constant networkID_mainnet = 1;
519     uint8 constant networkID_testnet = 2;
520     uint8 constant networkID_morden = 2;
521     uint8 constant networkID_consensys = 161;
522 
523     OraclizeAddrResolverI OAR;
524 
525     OraclizeI oraclize;
526     modifier oraclizeAPI {
527         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
528             oraclize_setNetwork(networkID_auto);
529 
530         if(address(oraclize) != OAR.getAddress())
531             oraclize = OraclizeI(OAR.getAddress());
532 
533         _;
534     }
535     modifier coupon(string code){
536         oraclize = OraclizeI(OAR.getAddress());
537         _;
538     }
539 
540     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
541       return oraclize_setNetwork();
542       networkID; // silence the warning and remain backwards compatible
543     }
544     function oraclize_setNetwork() internal returns(bool){
545         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
546             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
547             oraclize_setNetworkName("eth_mainnet");
548             return true;
549         }
550         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
551             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
552             oraclize_setNetworkName("eth_ropsten3");
553             return true;
554         }
555         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
556             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
557             oraclize_setNetworkName("eth_kovan");
558             return true;
559         }
560         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
561             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
562             oraclize_setNetworkName("eth_rinkeby");
563             return true;
564         }
565         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
566             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
567             return true;
568         }
569         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
570             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
571             return true;
572         }
573         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
574             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
575             return true;
576         }
577         return false;
578     }
579 
580     function __callback(bytes32 myid, string result) public {
581         __callback(myid, result, new bytes(0));
582     }
583     function __callback(bytes32 myid, string result, bytes proof) public {
584       return;
585       // Following should never be reached with a preceding return, however
586       // this is just a placeholder function, ideally meant to be defined in
587       // child contract when proofs are used
588       myid; result; proof; // Silence compiler warnings
589       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
590     }
591 
592     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
593         return oraclize.getPrice(datasource);
594     }
595 
596     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
597         return oraclize.getPrice(datasource, gaslimit);
598     }
599 
600     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
601         uint price = oraclize.getPrice(datasource);
602         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
603         return oraclize.query.value(price)(0, datasource, arg);
604     }
605     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
606         uint price = oraclize.getPrice(datasource);
607         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
608         return oraclize.query.value(price)(timestamp, datasource, arg);
609     }
610     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
611         uint price = oraclize.getPrice(datasource, gaslimit);
612         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
613         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
614     }
615     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
616         uint price = oraclize.getPrice(datasource, gaslimit);
617         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
618         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
619     }
620     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
621         uint price = oraclize.getPrice(datasource);
622         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
623         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
624     }
625     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
626         uint price = oraclize.getPrice(datasource);
627         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
628         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
629     }
630     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
631         uint price = oraclize.getPrice(datasource, gaslimit);
632         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
633         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
634     }
635     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
636         uint price = oraclize.getPrice(datasource, gaslimit);
637         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
638         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
639     }
640     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
641         uint price = oraclize.getPrice(datasource);
642         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
643         bytes memory args = stra2cbor(argN);
644         return oraclize.queryN.value(price)(0, datasource, args);
645     }
646     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
647         uint price = oraclize.getPrice(datasource);
648         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
649         bytes memory args = stra2cbor(argN);
650         return oraclize.queryN.value(price)(timestamp, datasource, args);
651     }
652     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
653         uint price = oraclize.getPrice(datasource, gaslimit);
654         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
655         bytes memory args = stra2cbor(argN);
656         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
657     }
658     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
659         uint price = oraclize.getPrice(datasource, gaslimit);
660         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
661         bytes memory args = stra2cbor(argN);
662         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
663     }
664     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
665         string[] memory dynargs = new string[](1);
666         dynargs[0] = args[0];
667         return oraclize_query(datasource, dynargs);
668     }
669     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
670         string[] memory dynargs = new string[](1);
671         dynargs[0] = args[0];
672         return oraclize_query(timestamp, datasource, dynargs);
673     }
674     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
675         string[] memory dynargs = new string[](1);
676         dynargs[0] = args[0];
677         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
678     }
679     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
680         string[] memory dynargs = new string[](1);
681         dynargs[0] = args[0];
682         return oraclize_query(datasource, dynargs, gaslimit);
683     }
684 
685     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
686         string[] memory dynargs = new string[](2);
687         dynargs[0] = args[0];
688         dynargs[1] = args[1];
689         return oraclize_query(datasource, dynargs);
690     }
691     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
692         string[] memory dynargs = new string[](2);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         return oraclize_query(timestamp, datasource, dynargs);
696     }
697     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
698         string[] memory dynargs = new string[](2);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
702     }
703     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
704         string[] memory dynargs = new string[](2);
705         dynargs[0] = args[0];
706         dynargs[1] = args[1];
707         return oraclize_query(datasource, dynargs, gaslimit);
708     }
709     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
710         string[] memory dynargs = new string[](3);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         return oraclize_query(datasource, dynargs);
715     }
716     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
717         string[] memory dynargs = new string[](3);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         return oraclize_query(timestamp, datasource, dynargs);
722     }
723     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
724         string[] memory dynargs = new string[](3);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
729     }
730     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
731         string[] memory dynargs = new string[](3);
732         dynargs[0] = args[0];
733         dynargs[1] = args[1];
734         dynargs[2] = args[2];
735         return oraclize_query(datasource, dynargs, gaslimit);
736     }
737 
738     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
739         string[] memory dynargs = new string[](4);
740         dynargs[0] = args[0];
741         dynargs[1] = args[1];
742         dynargs[2] = args[2];
743         dynargs[3] = args[3];
744         return oraclize_query(datasource, dynargs);
745     }
746     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
747         string[] memory dynargs = new string[](4);
748         dynargs[0] = args[0];
749         dynargs[1] = args[1];
750         dynargs[2] = args[2];
751         dynargs[3] = args[3];
752         return oraclize_query(timestamp, datasource, dynargs);
753     }
754     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
755         string[] memory dynargs = new string[](4);
756         dynargs[0] = args[0];
757         dynargs[1] = args[1];
758         dynargs[2] = args[2];
759         dynargs[3] = args[3];
760         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
761     }
762     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
763         string[] memory dynargs = new string[](4);
764         dynargs[0] = args[0];
765         dynargs[1] = args[1];
766         dynargs[2] = args[2];
767         dynargs[3] = args[3];
768         return oraclize_query(datasource, dynargs, gaslimit);
769     }
770     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
771         string[] memory dynargs = new string[](5);
772         dynargs[0] = args[0];
773         dynargs[1] = args[1];
774         dynargs[2] = args[2];
775         dynargs[3] = args[3];
776         dynargs[4] = args[4];
777         return oraclize_query(datasource, dynargs);
778     }
779     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
780         string[] memory dynargs = new string[](5);
781         dynargs[0] = args[0];
782         dynargs[1] = args[1];
783         dynargs[2] = args[2];
784         dynargs[3] = args[3];
785         dynargs[4] = args[4];
786         return oraclize_query(timestamp, datasource, dynargs);
787     }
788     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
789         string[] memory dynargs = new string[](5);
790         dynargs[0] = args[0];
791         dynargs[1] = args[1];
792         dynargs[2] = args[2];
793         dynargs[3] = args[3];
794         dynargs[4] = args[4];
795         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
796     }
797     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
798         string[] memory dynargs = new string[](5);
799         dynargs[0] = args[0];
800         dynargs[1] = args[1];
801         dynargs[2] = args[2];
802         dynargs[3] = args[3];
803         dynargs[4] = args[4];
804         return oraclize_query(datasource, dynargs, gaslimit);
805     }
806     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
807         uint price = oraclize.getPrice(datasource);
808         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
809         bytes memory args = ba2cbor(argN);
810         return oraclize.queryN.value(price)(0, datasource, args);
811     }
812     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
813         uint price = oraclize.getPrice(datasource);
814         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
815         bytes memory args = ba2cbor(argN);
816         return oraclize.queryN.value(price)(timestamp, datasource, args);
817     }
818     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
819         uint price = oraclize.getPrice(datasource, gaslimit);
820         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
821         bytes memory args = ba2cbor(argN);
822         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
823     }
824     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
825         uint price = oraclize.getPrice(datasource, gaslimit);
826         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
827         bytes memory args = ba2cbor(argN);
828         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
829     }
830     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
831         bytes[] memory dynargs = new bytes[](1);
832         dynargs[0] = args[0];
833         return oraclize_query(datasource, dynargs);
834     }
835     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
836         bytes[] memory dynargs = new bytes[](1);
837         dynargs[0] = args[0];
838         return oraclize_query(timestamp, datasource, dynargs);
839     }
840     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
841         bytes[] memory dynargs = new bytes[](1);
842         dynargs[0] = args[0];
843         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
844     }
845     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
846         bytes[] memory dynargs = new bytes[](1);
847         dynargs[0] = args[0];
848         return oraclize_query(datasource, dynargs, gaslimit);
849     }
850 
851     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
852         bytes[] memory dynargs = new bytes[](2);
853         dynargs[0] = args[0];
854         dynargs[1] = args[1];
855         return oraclize_query(datasource, dynargs);
856     }
857     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
858         bytes[] memory dynargs = new bytes[](2);
859         dynargs[0] = args[0];
860         dynargs[1] = args[1];
861         return oraclize_query(timestamp, datasource, dynargs);
862     }
863     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
864         bytes[] memory dynargs = new bytes[](2);
865         dynargs[0] = args[0];
866         dynargs[1] = args[1];
867         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
868     }
869     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
870         bytes[] memory dynargs = new bytes[](2);
871         dynargs[0] = args[0];
872         dynargs[1] = args[1];
873         return oraclize_query(datasource, dynargs, gaslimit);
874     }
875     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
876         bytes[] memory dynargs = new bytes[](3);
877         dynargs[0] = args[0];
878         dynargs[1] = args[1];
879         dynargs[2] = args[2];
880         return oraclize_query(datasource, dynargs);
881     }
882     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
883         bytes[] memory dynargs = new bytes[](3);
884         dynargs[0] = args[0];
885         dynargs[1] = args[1];
886         dynargs[2] = args[2];
887         return oraclize_query(timestamp, datasource, dynargs);
888     }
889     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
890         bytes[] memory dynargs = new bytes[](3);
891         dynargs[0] = args[0];
892         dynargs[1] = args[1];
893         dynargs[2] = args[2];
894         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
895     }
896     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
897         bytes[] memory dynargs = new bytes[](3);
898         dynargs[0] = args[0];
899         dynargs[1] = args[1];
900         dynargs[2] = args[2];
901         return oraclize_query(datasource, dynargs, gaslimit);
902     }
903 
904     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
905         bytes[] memory dynargs = new bytes[](4);
906         dynargs[0] = args[0];
907         dynargs[1] = args[1];
908         dynargs[2] = args[2];
909         dynargs[3] = args[3];
910         return oraclize_query(datasource, dynargs);
911     }
912     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
913         bytes[] memory dynargs = new bytes[](4);
914         dynargs[0] = args[0];
915         dynargs[1] = args[1];
916         dynargs[2] = args[2];
917         dynargs[3] = args[3];
918         return oraclize_query(timestamp, datasource, dynargs);
919     }
920     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
921         bytes[] memory dynargs = new bytes[](4);
922         dynargs[0] = args[0];
923         dynargs[1] = args[1];
924         dynargs[2] = args[2];
925         dynargs[3] = args[3];
926         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
927     }
928     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
929         bytes[] memory dynargs = new bytes[](4);
930         dynargs[0] = args[0];
931         dynargs[1] = args[1];
932         dynargs[2] = args[2];
933         dynargs[3] = args[3];
934         return oraclize_query(datasource, dynargs, gaslimit);
935     }
936     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
937         bytes[] memory dynargs = new bytes[](5);
938         dynargs[0] = args[0];
939         dynargs[1] = args[1];
940         dynargs[2] = args[2];
941         dynargs[3] = args[3];
942         dynargs[4] = args[4];
943         return oraclize_query(datasource, dynargs);
944     }
945     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
946         bytes[] memory dynargs = new bytes[](5);
947         dynargs[0] = args[0];
948         dynargs[1] = args[1];
949         dynargs[2] = args[2];
950         dynargs[3] = args[3];
951         dynargs[4] = args[4];
952         return oraclize_query(timestamp, datasource, dynargs);
953     }
954     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
955         bytes[] memory dynargs = new bytes[](5);
956         dynargs[0] = args[0];
957         dynargs[1] = args[1];
958         dynargs[2] = args[2];
959         dynargs[3] = args[3];
960         dynargs[4] = args[4];
961         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
962     }
963     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
964         bytes[] memory dynargs = new bytes[](5);
965         dynargs[0] = args[0];
966         dynargs[1] = args[1];
967         dynargs[2] = args[2];
968         dynargs[3] = args[3];
969         dynargs[4] = args[4];
970         return oraclize_query(datasource, dynargs, gaslimit);
971     }
972 
973     function oraclize_cbAddress() oraclizeAPI internal returns (address){
974         return oraclize.cbAddress();
975     }
976     function oraclize_setProof(byte proofP) oraclizeAPI internal {
977         return oraclize.setProofType(proofP);
978     }
979     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
980         return oraclize.setCustomGasPrice(gasPrice);
981     }
982 
983     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
984         return oraclize.randomDS_getSessionPubKeyHash();
985     }
986 
987     function getCodeSize(address _addr) view internal returns(uint _size) {
988         assembly {
989             _size := extcodesize(_addr)
990         }
991     }
992 
993     function parseAddr(string _a) internal pure returns (address){
994         bytes memory tmp = bytes(_a);
995         uint160 iaddr = 0;
996         uint160 b1;
997         uint160 b2;
998         for (uint i=2; i<2+2*20; i+=2){
999             iaddr *= 256;
1000             b1 = uint160(tmp[i]);
1001             b2 = uint160(tmp[i+1]);
1002             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1003             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1004             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1005             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1006             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1007             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1008             iaddr += (b1*16+b2);
1009         }
1010         return address(iaddr);
1011     }
1012 
1013     function strCompare(string _a, string _b) internal pure returns (int) {
1014         bytes memory a = bytes(_a);
1015         bytes memory b = bytes(_b);
1016         uint minLength = a.length;
1017         if (b.length < minLength) minLength = b.length;
1018         for (uint i = 0; i < minLength; i ++)
1019             if (a[i] < b[i])
1020                 return -1;
1021             else if (a[i] > b[i])
1022                 return 1;
1023         if (a.length < b.length)
1024             return -1;
1025         else if (a.length > b.length)
1026             return 1;
1027         else
1028             return 0;
1029     }
1030 
1031     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1032         bytes memory h = bytes(_haystack);
1033         bytes memory n = bytes(_needle);
1034         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1035             return -1;
1036         else if(h.length > (2**128 -1))
1037             return -1;
1038         else
1039         {
1040             uint subindex = 0;
1041             for (uint i = 0; i < h.length; i ++)
1042             {
1043                 if (h[i] == n[0])
1044                 {
1045                     subindex = 1;
1046                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1047                     {
1048                         subindex++;
1049                     }
1050                     if(subindex == n.length)
1051                         return int(i);
1052                 }
1053             }
1054             return -1;
1055         }
1056     }
1057 
1058     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1059         bytes memory _ba = bytes(_a);
1060         bytes memory _bb = bytes(_b);
1061         bytes memory _bc = bytes(_c);
1062         bytes memory _bd = bytes(_d);
1063         bytes memory _be = bytes(_e);
1064         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1065         bytes memory babcde = bytes(abcde);
1066         uint k = 0;
1067         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1068         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1069         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1070         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1071         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1072         return string(babcde);
1073     }
1074 
1075     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1076         return strConcat(_a, _b, _c, _d, "");
1077     }
1078 
1079     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1080         return strConcat(_a, _b, _c, "", "");
1081     }
1082 
1083     function strConcat(string _a, string _b) internal pure returns (string) {
1084         return strConcat(_a, _b, "", "", "");
1085     }
1086 
1087     // parseInt
1088     function parseInt(string _a) internal pure returns (uint) {
1089         return parseInt(_a, 0);
1090     }
1091 
1092     // parseInt(parseFloat*10^_b)
1093     function parseInt(string _a, uint _b) internal pure returns (uint) {
1094         bytes memory bresult = bytes(_a);
1095         uint mint = 0;
1096         bool decimals = false;
1097         for (uint i=0; i<bresult.length; i++){
1098             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1099                 if (decimals){
1100                    if (_b == 0) break;
1101                     else _b--;
1102                 }
1103                 mint *= 10;
1104                 mint += uint(bresult[i]) - 48;
1105             } else if (bresult[i] == 46) decimals = true;
1106         }
1107         if (_b > 0) mint *= 10**_b;
1108         return mint;
1109     }
1110 
1111     function uint2str(uint i) internal pure returns (string){
1112         if (i == 0) return "0";
1113         uint j = i;
1114         uint len;
1115         while (j != 0){
1116             len++;
1117             j /= 10;
1118         }
1119         bytes memory bstr = new bytes(len);
1120         uint k = len - 1;
1121         while (i != 0){
1122             bstr[k--] = byte(48 + i % 10);
1123             i /= 10;
1124         }
1125         return string(bstr);
1126     }
1127 
1128     using CBOR for Buffer.buffer;
1129     function stra2cbor(string[] arr) internal pure returns (bytes) {
1130         safeMemoryCleaner();
1131         Buffer.buffer memory buf;
1132         Buffer.init(buf, 1024);
1133         buf.startArray();
1134         for (uint i = 0; i < arr.length; i++) {
1135             buf.encodeString(arr[i]);
1136         }
1137         buf.endSequence();
1138         return buf.buf;
1139     }
1140 
1141     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1142         safeMemoryCleaner();
1143         Buffer.buffer memory buf;
1144         Buffer.init(buf, 1024);
1145         buf.startArray();
1146         for (uint i = 0; i < arr.length; i++) {
1147             buf.encodeBytes(arr[i]);
1148         }
1149         buf.endSequence();
1150         return buf.buf;
1151     }
1152 
1153     string oraclize_network_name;
1154     function oraclize_setNetworkName(string _network_name) internal {
1155         oraclize_network_name = _network_name;
1156     }
1157 
1158     function oraclize_getNetworkName() internal view returns (string) {
1159         return oraclize_network_name;
1160     }
1161 
1162     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1163         require((_nbytes > 0) && (_nbytes <= 32));
1164         // Convert from seconds to ledger timer ticks
1165         _delay *= 10;
1166         bytes memory nbytes = new bytes(1);
1167         nbytes[0] = byte(_nbytes);
1168         bytes memory unonce = new bytes(32);
1169         bytes memory sessionKeyHash = new bytes(32);
1170         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1171         assembly {
1172             mstore(unonce, 0x20)
1173             // the following variables can be relaxed
1174             // check relaxed random contract under ethereum-examples repo
1175             // for an idea on how to override and replace comit hash vars
1176             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1177             mstore(sessionKeyHash, 0x20)
1178             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1179         }
1180         bytes memory delay = new bytes(32);
1181         assembly {
1182             mstore(add(delay, 0x20), _delay)
1183         }
1184 
1185         bytes memory delay_bytes8 = new bytes(8);
1186         copyBytes(delay, 24, 8, delay_bytes8, 0);
1187 
1188         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1189         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1190 
1191         bytes memory delay_bytes8_left = new bytes(8);
1192 
1193         assembly {
1194             let x := mload(add(delay_bytes8, 0x20))
1195             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1196             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1197             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1198             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1199             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1200             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1201             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1202             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1203 
1204         }
1205 
1206         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1207         return queryId;
1208     }
1209 
1210     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1211         oraclize_randomDS_args[queryId] = commitment;
1212     }
1213 
1214     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1215     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1216 
1217     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1218         bool sigok;
1219         address signer;
1220 
1221         bytes32 sigr;
1222         bytes32 sigs;
1223 
1224         bytes memory sigr_ = new bytes(32);
1225         uint offset = 4+(uint(dersig[3]) - 0x20);
1226         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1227         bytes memory sigs_ = new bytes(32);
1228         offset += 32 + 2;
1229         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1230 
1231         assembly {
1232             sigr := mload(add(sigr_, 32))
1233             sigs := mload(add(sigs_, 32))
1234         }
1235 
1236 
1237         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1238         if (address(keccak256(pubkey)) == signer) return true;
1239         else {
1240             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1241             return (address(keccak256(pubkey)) == signer);
1242         }
1243     }
1244 
1245     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1246         bool sigok;
1247 
1248         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1249         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1250         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1251 
1252         bytes memory appkey1_pubkey = new bytes(64);
1253         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1254 
1255         bytes memory tosign2 = new bytes(1+65+32);
1256         tosign2[0] = byte(1); //role
1257         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1258         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1259         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1260         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1261 
1262         if (sigok == false) return false;
1263 
1264 
1265         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1266         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1267 
1268         bytes memory tosign3 = new bytes(1+65);
1269         tosign3[0] = 0xFE;
1270         copyBytes(proof, 3, 65, tosign3, 1);
1271 
1272         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1273         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1274 
1275         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1276 
1277         return sigok;
1278     }
1279 
1280     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1281         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1282         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1283 
1284         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1285         require(proofVerified);
1286 
1287         _;
1288     }
1289 
1290     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1291         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1292         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1293 
1294         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1295         if (proofVerified == false) return 2;
1296 
1297         return 0;
1298     }
1299 
1300     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1301         bool match_ = true;
1302 
1303         require(prefix.length == n_random_bytes);
1304 
1305         for (uint256 i=0; i< n_random_bytes; i++) {
1306             if (content[i] != prefix[i]) match_ = false;
1307         }
1308 
1309         return match_;
1310     }
1311 
1312     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1313 
1314         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1315         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1316         bytes memory keyhash = new bytes(32);
1317         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1318         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1319 
1320         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1321         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1322 
1323         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1324         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1325 
1326         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1327         // This is to verify that the computed args match with the ones specified in the query.
1328         bytes memory commitmentSlice1 = new bytes(8+1+32);
1329         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1330 
1331         bytes memory sessionPubkey = new bytes(64);
1332         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1333         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1334 
1335         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1336         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1337             delete oraclize_randomDS_args[queryId];
1338         } else return false;
1339 
1340 
1341         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1342         bytes memory tosign1 = new bytes(32+8+1+32);
1343         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1344         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1345 
1346         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1347         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1348             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1349         }
1350 
1351         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1352     }
1353 
1354     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1355     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1356         uint minLength = length + toOffset;
1357 
1358         // Buffer too small
1359         require(to.length >= minLength); // Should be a better way?
1360 
1361         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1362         uint i = 32 + fromOffset;
1363         uint j = 32 + toOffset;
1364 
1365         while (i < (32 + fromOffset + length)) {
1366             assembly {
1367                 let tmp := mload(add(from, i))
1368                 mstore(add(to, j), tmp)
1369             }
1370             i += 32;
1371             j += 32;
1372         }
1373 
1374         return to;
1375     }
1376 
1377     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1378     // Duplicate Solidity's ecrecover, but catching the CALL return value
1379     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1380         // We do our own memory management here. Solidity uses memory offset
1381         // 0x40 to store the current end of memory. We write past it (as
1382         // writes are memory extensions), but don't update the offset so
1383         // Solidity will reuse it. The memory used here is only needed for
1384         // this context.
1385 
1386         // FIXME: inline assembly can't access return values
1387         bool ret;
1388         address addr;
1389 
1390         assembly {
1391             let size := mload(0x40)
1392             mstore(size, hash)
1393             mstore(add(size, 32), v)
1394             mstore(add(size, 64), r)
1395             mstore(add(size, 96), s)
1396 
1397             // NOTE: we can reuse the request memory because we deal with
1398             //       the return code
1399             ret := call(3000, 1, 0, size, 128, size, 32)
1400             addr := mload(size)
1401         }
1402 
1403         return (ret, addr);
1404     }
1405 
1406     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1407     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1408         bytes32 r;
1409         bytes32 s;
1410         uint8 v;
1411 
1412         if (sig.length != 65)
1413           return (false, 0);
1414 
1415         // The signature format is a compact form of:
1416         //   {bytes32 r}{bytes32 s}{uint8 v}
1417         // Compact means, uint8 is not padded to 32 bytes.
1418         assembly {
1419             r := mload(add(sig, 32))
1420             s := mload(add(sig, 64))
1421 
1422             // Here we are loading the last 32 bytes. We exploit the fact that
1423             // 'mload' will pad with zeroes if we overread.
1424             // There is no 'mload8' to do this, but that would be nicer.
1425             v := byte(0, mload(add(sig, 96)))
1426 
1427             // Alternative solution:
1428             // 'byte' is not working due to the Solidity parser, so lets
1429             // use the second best option, 'and'
1430             // v := and(mload(add(sig, 65)), 255)
1431         }
1432 
1433         // albeit non-transactional signatures are not specified by the YP, one would expect it
1434         // to match the YP range of [27, 28]
1435         //
1436         // geth uses [0, 1] and some clients have followed. This might change, see:
1437         //  https://github.com/ethereum/go-ethereum/issues/2053
1438         if (v < 27)
1439           v += 27;
1440 
1441         if (v != 27 && v != 28)
1442             return (false, 0);
1443 
1444         return safer_ecrecover(hash, v, r, s);
1445     }
1446 
1447     function safeMemoryCleaner() internal pure {
1448         assembly {
1449             let fmem := mload(0x40)
1450             codecopy(fmem, codesize, sub(msize, fmem))
1451         }
1452     }
1453 
1454 }
1455 // </ORACLIZE_API>
1456 
1457 
1458 /// @title JSON provides JSON parsing functionality.
1459 contract JSON is usingOraclize{
1460     using strings for *;
1461 
1462     bytes32 constant private prefixHash = keccak256("{\"ETH\":");
1463 
1464     /// @dev Extracts JSON rate value from the response object.
1465     /// @param _json body of the JSON response from the CryptoCompare API.
1466     function parseRate(string _json) public pure returns (string) {
1467 
1468         uint json_len = abi.encodePacked(_json).length;
1469         //{"ETH":}.length = 8, assuming a (maximum of) 18 digit prevision
1470         require(json_len > 8 && json_len <= 28, "misformatted input");
1471 
1472         bytes memory jsonPrefix = new bytes(7);
1473         copyBytes(abi.encodePacked(_json), 0, 7, jsonPrefix, 0);
1474         require(keccak256(jsonPrefix) == prefixHash, "prefix mismatch");
1475 
1476         strings.slice memory body = _json.toSlice();
1477         body.split(":".toSlice()); //we are sure that ':' is included in the string, body now contains the rate+'}'
1478         json_len = body._len;
1479         body.until("}".toSlice());
1480         require(body._len == json_len-1,"not json format"); //ensure that the json is properly terminated with a '}'
1481         return body.toString();
1482 
1483     }
1484 }
1485 
1486 /// @title ParseIntScientific provides floating point in scientific notation (e.g. e-5) parsing functionality.
1487 contract ParseIntScientific {
1488 
1489     using SafeMath for uint256;
1490 
1491     byte constant private PLUS_ASCII = byte(43); //decimal value of '+'
1492     byte constant private DASH_ASCII = byte(45); //decimal value of '-'
1493     byte constant private DOT_ASCII = byte(46); //decimal value of '.'
1494     byte constant private ZERO_ASCII = byte(48); //decimal value of '0'
1495     byte constant private NINE_ASCII = byte(57); //decimal value of '9'
1496     byte constant private E_ASCII = byte(69); //decimal value of 'E'
1497     byte constant private e_ASCII = byte(101); //decimal value of 'e'
1498 
1499     /// @dev ParseIntScientific delegates the call to _parseIntScientific(string, uint) with the 2nd argument being 0.
1500     function _parseIntScientific(string _inString) internal pure returns (uint) {
1501         return _parseIntScientific(_inString, 0);
1502     }
1503 
1504     /// @dev ParseIntScientificWei parses a rate expressed in ETH and returns its wei denomination
1505     function _parseIntScientificWei(string _inString) internal pure returns (uint) {
1506         return _parseIntScientific(_inString, 18);
1507     }
1508 
1509     /// @dev ParseIntScientific parses a JSON standard - floating point number.
1510     /// @param _inString is input string.
1511     /// @param _magnitudeMult multiplies the number with 10^_magnitudeMult.
1512     function _parseIntScientific(string _inString, uint _magnitudeMult) internal pure returns (uint) {
1513 
1514         bytes memory inBytes = bytes(_inString);
1515         uint mint = 0; // the final uint returned
1516         uint mintDec = 0; // the uint following the decimal point
1517         uint mintExp = 0; // the exponent
1518         uint decMinted = 0; // how many decimals were 'minted'.
1519         uint expIndex = 0; // the position in the byte array that 'e' was found (if found)
1520         bool integral = false; // indicates the existence of the integral part, it should always exist (even if 0) e.g. 'e+1'  or '.1' is not valid
1521         bool decimals = false; // indicates a decimal number, set to true if '.' is found
1522         bool exp = false; // indicates if the number being parsed has an exponential representation
1523         bool minus = false; // indicated if the exponent is negative
1524         bool plus = false; // indicated if the exponent is positive
1525 
1526         for (uint i = 0; i < inBytes.length; i++) {
1527             if ((inBytes[i] >= ZERO_ASCII) && (inBytes[i] <= NINE_ASCII) && (!exp)) {
1528                 // 'e' not encountered yet, minting integer part or decimals
1529                 if (decimals) {
1530                     // '.' encountered
1531                     //use safeMath in case there is an overflow
1532                     mintDec = mintDec.mul(10);
1533                     mintDec = mintDec.add(uint(inBytes[i]) - uint(ZERO_ASCII));
1534                     decMinted++; //keep track of the #decimals
1535                 } else {
1536                     // integral part (before '.')
1537                     integral = true;
1538                     //use safeMath in case there is an overflow
1539                     mint = mint.mul(10);
1540                     mint = mint.add(uint(inBytes[i]) - uint(ZERO_ASCII));
1541                 }
1542             } else if ((inBytes[i] >= ZERO_ASCII) && (inBytes[i] <= NINE_ASCII) && (exp)) {
1543                 //exponential notation (e-/+) has been detected, mint the exponent
1544                 mintExp = mintExp.mul(10);
1545                 mintExp = mintExp.add(uint(inBytes[i]) - uint(ZERO_ASCII));
1546             } else if (inBytes[i] == DOT_ASCII) {
1547                 //an integral part before should always exist before '.'
1548                 require(integral, "missing integral part");
1549                 // an extra decimal point makes the format invalid
1550                 require(!decimals, "duplicate decimal point");
1551                 //the decimal point should always be before the exponent
1552                 require(!exp, "decimal after exponent");
1553                 decimals = true;
1554             } else if (inBytes[i] == DASH_ASCII) {
1555                 // an extra '-' should be considered an invalid character
1556                 require(!minus, "duplicate -");
1557                 require(!plus, "extra sign");
1558                 require(expIndex + 1 == i, "- sign not immediately after e");
1559                 minus = true;
1560             } else if (inBytes[i] == PLUS_ASCII) {
1561                 // an extra '+' should be considered an invalid character
1562                 require(!plus, "duplicate +");
1563                 require(!minus, "extra sign");
1564                 require(expIndex + 1 == i, "+ sign not immediately after e");
1565                 plus = true;
1566             } else if ((inBytes[i] == E_ASCII) || (inBytes[i] == e_ASCII)) {
1567                 //an integral part before should always exist before 'e'
1568                 require(integral, "missing integral part");
1569                 // an extra 'e' or 'E' should be considered an invalid character
1570                 require(!exp, "duplicate exponent symbol");
1571                 exp = true;
1572                 expIndex = i;
1573             } else {
1574                 revert("invalid digit");
1575             }
1576         }
1577 
1578         if (minus || plus) {
1579             // end of string e[x|-] without specifying the exponent
1580             require(i > expIndex + 2);
1581         } else if (exp) {
1582             // end of string (e) without specifying the exponent
1583             require(i > expIndex + 1);
1584         }
1585 
1586         if (minus) {
1587             // e^(-x)
1588             if (mintExp >= _magnitudeMult) {
1589                 // the (negative) exponent is bigger than the given parameter for "shifting left".
1590                 // use integer division to reduce the precision.
1591                 require(mintExp - _magnitudeMult < 78, "exponent > 77"); //
1592                 mint /= 10 ** (mintExp - _magnitudeMult);
1593                 return mint;
1594 
1595             } else {
1596                 // the (negative) exponent is smaller than the given parameter for "shifting left".
1597                 //no need for underflow check
1598                 _magnitudeMult = _magnitudeMult - mintExp;
1599             }
1600         } else {
1601             // e^(+x), positive exponent or no exponent
1602             // just shift left as many times as indicated by the exponent and the shift parameter
1603             _magnitudeMult = _magnitudeMult.add(mintExp);
1604           }
1605 
1606           if (_magnitudeMult >= decMinted) {
1607               // the decimals are fewer or equal than the shifts: use all of them
1608               // shift number and add the decimals at the end
1609               // include decimals if present in the original input
1610               require(decMinted < 78, "more than 77 decimal digits parsed"); //
1611               mint = mint.mul(10 ** (decMinted));
1612               mint = mint.add(mintDec);
1613               //// add zeros at the end if the decimals were fewer than #_magnitudeMult
1614               require(_magnitudeMult - decMinted < 78, "exponent > 77"); //
1615               mint = mint.mul(10 ** (_magnitudeMult - decMinted));
1616           } else {
1617               // the decimals are more than the #_magnitudeMult shifts
1618               // use only the ones needed, discard the rest
1619               decMinted -= _magnitudeMult;
1620               require(decMinted < 78, "more than 77 decimal digits parsed"); //
1621               mintDec /= 10 ** (decMinted);
1622               // shift number and add the decimals at the end
1623               require(_magnitudeMult < 78, "more than 77 decimal digits parsed"); //
1624               mint = mint.mul(10 ** (_magnitudeMult));
1625               mint = mint.add(mintDec);
1626           }
1627 
1628         return mint;
1629     }
1630 }
1631 
1632 
1633 
1634 /*
1635  * Copyright 2016 Nick Johnson
1636  *
1637  * Licensed under the Apache License, Version 2.0 (the "License");
1638  * you may not use this file except in compliance with the License.
1639  * You may obtain a copy of the License at
1640  *
1641  *     http://www.apache.org/licenses/LICENSE-2.0
1642  *
1643  * Unless required by applicable law or agreed to in writing, software
1644  * distributed under the License is distributed on an "AS IS" BASIS,
1645  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1646  * See the License for the specific language governing permissions and
1647  * limitations under the License.
1648  */
1649 
1650 /*
1651  * @title String & slice utility library for Solidity contracts.
1652  * @author Nick Johnson <arachnid@notdot.net>
1653  *
1654  * @dev Functionality in this library is largely implemented using an
1655  *      abstraction called a 'slice'. A slice represents a part of a string -
1656  *      anything from the entire string to a single character, or even no
1657  *      characters at all (a 0-length slice). Since a slice only has to specify
1658  *      an offset and a length, copying and manipulating slices is a lot less
1659  *      expensive than copying and manipulating the strings they reference.
1660  *
1661  *      To further reduce gas costs, most functions on slice that need to return
1662  *      a slice modify the original one instead of allocating a new one; for
1663  *      instance, `s.split(".")` will return the text up to the first '.',
1664  *      modifying s to only contain the remainder of the string after the '.'.
1665  *      In situations where you do not want to modify the original slice, you
1666  *      can make a copy first with `.copy()`, for example:
1667  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1668  *      Solidity has no memory management, it will result in allocating many
1669  *      short-lived slices that are later discarded.
1670  *
1671  *      Functions that return two slices come in two versions: a non-allocating
1672  *      version that takes the second slice as an argument, modifying it in
1673  *      place, and an allocating version that allocates and returns the second
1674  *      slice; see `nextRune` for example.
1675  *
1676  *      Functions that have to copy string data will return strings rather than
1677  *      slices; these can be cast back to slices for further processing if
1678  *      required.
1679  *
1680  *      For convenience, some functions are provided with non-modifying
1681  *      variants that create a new slice and return both; for instance,
1682  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1683  *      corresponding to the left and right parts of the string.
1684  */
1685 
1686 library strings {
1687     struct slice {
1688         uint _len;
1689         uint _ptr;
1690     }
1691 
1692     function memcpy(uint dest, uint src, uint len) private pure {
1693         // Copy word-length chunks while possible
1694         for(; len >= 32; len -= 32) {
1695             assembly {
1696                 mstore(dest, mload(src))
1697             }
1698             dest += 32;
1699             src += 32;
1700         }
1701 
1702         // Copy remaining bytes
1703         uint mask = 256 ** (32 - len) - 1;
1704         assembly {
1705             let srcpart := and(mload(src), not(mask))
1706             let destpart := and(mload(dest), mask)
1707             mstore(dest, or(destpart, srcpart))
1708         }
1709     }
1710 
1711     /*
1712      * @dev Returns a slice containing the entire string.
1713      * @param self The string to make a slice from.
1714      * @return A newly allocated slice containing the entire string.
1715      */
1716     function toSlice(string memory self) internal pure returns (slice memory) {
1717         uint ptr;
1718         assembly {
1719             ptr := add(self, 0x20)
1720         }
1721         return slice(bytes(self).length, ptr);
1722     }
1723 
1724     /*
1725      * @dev Returns the length of a null-terminated bytes32 string.
1726      * @param self The value to find the length of.
1727      * @return The length of the string, from 0 to 32.
1728      */
1729     function len(bytes32 self) internal pure returns (uint) {
1730         uint ret;
1731         if (self == 0)
1732             return 0;
1733         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1734             ret += 16;
1735             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1736         }
1737         if (self & 0xffffffffffffffff == 0) {
1738             ret += 8;
1739             self = bytes32(uint(self) / 0x10000000000000000);
1740         }
1741         if (self & 0xffffffff == 0) {
1742             ret += 4;
1743             self = bytes32(uint(self) / 0x100000000);
1744         }
1745         if (self & 0xffff == 0) {
1746             ret += 2;
1747             self = bytes32(uint(self) / 0x10000);
1748         }
1749         if (self & 0xff == 0) {
1750             ret += 1;
1751         }
1752         return 32 - ret;
1753     }
1754 
1755     /*
1756      * @dev Returns a slice containing the entire bytes32, interpreted as a
1757      *      null-terminated utf-8 string.
1758      * @param self The bytes32 value to convert to a slice.
1759      * @return A new slice containing the value of the input argument up to the
1760      *         first null.
1761      */
1762     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1763         // Allocate space for `self` in memory, copy it there, and point ret at it
1764         assembly {
1765             let ptr := mload(0x40)
1766             mstore(0x40, add(ptr, 0x20))
1767             mstore(ptr, self)
1768             mstore(add(ret, 0x20), ptr)
1769         }
1770         ret._len = len(self);
1771     }
1772 
1773     /*
1774      * @dev Returns a new slice containing the same data as the current slice.
1775      * @param self The slice to copy.
1776      * @return A new slice containing the same data as `self`.
1777      */
1778     function copy(slice memory self) internal pure returns (slice memory) {
1779         return slice(self._len, self._ptr);
1780     }
1781 
1782     /*
1783      * @dev Copies a slice to a new string.
1784      * @param self The slice to copy.
1785      * @return A newly allocated string containing the slice's text.
1786      */
1787     function toString(slice memory self) internal pure returns (string memory) {
1788         string memory ret = new string(self._len);
1789         uint retptr;
1790         assembly { retptr := add(ret, 32) }
1791 
1792         memcpy(retptr, self._ptr, self._len);
1793         return ret;
1794     }
1795 
1796     /*
1797      * @dev Returns the length in runes of the slice. Note that this operation
1798      *      takes time proportional to the length of the slice; avoid using it
1799      *      in loops, and call `slice.empty()` if you only need to know whether
1800      *      the slice is empty or not.
1801      * @param self The slice to operate on.
1802      * @return The length of the slice in runes.
1803      */
1804     function len(slice memory self) internal pure returns (uint l) {
1805         // Starting at ptr-31 means the LSB will be the byte we care about
1806         uint ptr = self._ptr - 31;
1807         uint end = ptr + self._len;
1808         for (l = 0; ptr < end; l++) {
1809             uint8 b;
1810             assembly { b := and(mload(ptr), 0xFF) }
1811             if (b < 0x80) {
1812                 ptr += 1;
1813             } else if(b < 0xE0) {
1814                 ptr += 2;
1815             } else if(b < 0xF0) {
1816                 ptr += 3;
1817             } else if(b < 0xF8) {
1818                 ptr += 4;
1819             } else if(b < 0xFC) {
1820                 ptr += 5;
1821             } else {
1822                 ptr += 6;
1823             }
1824         }
1825     }
1826 
1827     /*
1828      * @dev Returns true if the slice is empty (has a length of 0).
1829      * @param self The slice to operate on.
1830      * @return True if the slice is empty, False otherwise.
1831      */
1832     function empty(slice memory self) internal pure returns (bool) {
1833         return self._len == 0;
1834     }
1835 
1836     /*
1837      * @dev Returns a positive number if `other` comes lexicographically after
1838      *      `self`, a negative number if it comes before, or zero if the
1839      *      contents of the two slices are equal. Comparison is done per-rune,
1840      *      on unicode codepoints.
1841      * @param self The first slice to compare.
1842      * @param other The second slice to compare.
1843      * @return The result of the comparison.
1844      */
1845     function compare(slice memory self, slice memory other) internal pure returns (int) {
1846         uint shortest = self._len;
1847         if (other._len < self._len)
1848             shortest = other._len;
1849 
1850         uint selfptr = self._ptr;
1851         uint otherptr = other._ptr;
1852         for (uint idx = 0; idx < shortest; idx += 32) {
1853             uint a;
1854             uint b;
1855             assembly {
1856                 a := mload(selfptr)
1857                 b := mload(otherptr)
1858             }
1859             if (a != b) {
1860                 // Mask out irrelevant bytes and check again
1861                 uint256 mask = uint256(-1); // 0xffff...
1862                 if(shortest < 32) {
1863                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1864                 }
1865                 uint256 diff = (a & mask) - (b & mask);
1866                 if (diff != 0)
1867                     return int(diff);
1868             }
1869             selfptr += 32;
1870             otherptr += 32;
1871         }
1872         return int(self._len) - int(other._len);
1873     }
1874 
1875     /*
1876      * @dev Returns true if the two slices contain the same text.
1877      * @param self The first slice to compare.
1878      * @param self The second slice to compare.
1879      * @return True if the slices are equal, false otherwise.
1880      */
1881     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1882         return compare(self, other) == 0;
1883     }
1884 
1885     /*
1886      * @dev Extracts the first rune in the slice into `rune`, advancing the
1887      *      slice to point to the next rune and returning `self`.
1888      * @param self The slice to operate on.
1889      * @param rune The slice that will contain the first rune.
1890      * @return `rune`.
1891      */
1892     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1893         rune._ptr = self._ptr;
1894 
1895         if (self._len == 0) {
1896             rune._len = 0;
1897             return rune;
1898         }
1899 
1900         uint l;
1901         uint b;
1902         // Load the first byte of the rune into the LSBs of b
1903         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1904         if (b < 0x80) {
1905             l = 1;
1906         } else if(b < 0xE0) {
1907             l = 2;
1908         } else if(b < 0xF0) {
1909             l = 3;
1910         } else {
1911             l = 4;
1912         }
1913 
1914         // Check for truncated codepoints
1915         if (l > self._len) {
1916             rune._len = self._len;
1917             self._ptr += self._len;
1918             self._len = 0;
1919             return rune;
1920         }
1921 
1922         self._ptr += l;
1923         self._len -= l;
1924         rune._len = l;
1925         return rune;
1926     }
1927 
1928     /*
1929      * @dev Returns the first rune in the slice, advancing the slice to point
1930      *      to the next rune.
1931      * @param self The slice to operate on.
1932      * @return A slice containing only the first rune from `self`.
1933      */
1934     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1935         nextRune(self, ret);
1936     }
1937 
1938     /*
1939      * @dev Returns the number of the first codepoint in the slice.
1940      * @param self The slice to operate on.
1941      * @return The number of the first codepoint in the slice.
1942      */
1943     function ord(slice memory self) internal pure returns (uint ret) {
1944         if (self._len == 0) {
1945             return 0;
1946         }
1947 
1948         uint word;
1949         uint length;
1950         uint divisor = 2 ** 248;
1951 
1952         // Load the rune into the MSBs of b
1953         assembly { word:= mload(mload(add(self, 32))) }
1954         uint b = word / divisor;
1955         if (b < 0x80) {
1956             ret = b;
1957             length = 1;
1958         } else if(b < 0xE0) {
1959             ret = b & 0x1F;
1960             length = 2;
1961         } else if(b < 0xF0) {
1962             ret = b & 0x0F;
1963             length = 3;
1964         } else {
1965             ret = b & 0x07;
1966             length = 4;
1967         }
1968 
1969         // Check for truncated codepoints
1970         if (length > self._len) {
1971             return 0;
1972         }
1973 
1974         for (uint i = 1; i < length; i++) {
1975             divisor = divisor / 256;
1976             b = (word / divisor) & 0xFF;
1977             if (b & 0xC0 != 0x80) {
1978                 // Invalid UTF-8 sequence
1979                 return 0;
1980             }
1981             ret = (ret * 64) | (b & 0x3F);
1982         }
1983 
1984         return ret;
1985     }
1986 
1987     /*
1988      * @dev Returns the keccak-256 hash of the slice.
1989      * @param self The slice to hash.
1990      * @return The hash of the slice.
1991      */
1992     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1993         assembly {
1994             ret := keccak256(mload(add(self, 32)), mload(self))
1995         }
1996     }
1997 
1998     /*
1999      * @dev Returns true if `self` starts with `needle`.
2000      * @param self The slice to operate on.
2001      * @param needle The slice to search for.
2002      * @return True if the slice starts with the provided text, false otherwise.
2003      */
2004     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2005         if (self._len < needle._len) {
2006             return false;
2007         }
2008 
2009         if (self._ptr == needle._ptr) {
2010             return true;
2011         }
2012 
2013         bool equal;
2014         assembly {
2015             let length := mload(needle)
2016             let selfptr := mload(add(self, 0x20))
2017             let needleptr := mload(add(needle, 0x20))
2018             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2019         }
2020         return equal;
2021     }
2022 
2023     /*
2024      * @dev If `self` starts with `needle`, `needle` is removed from the
2025      *      beginning of `self`. Otherwise, `self` is unmodified.
2026      * @param self The slice to operate on.
2027      * @param needle The slice to search for.
2028      * @return `self`
2029      */
2030     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
2031         if (self._len < needle._len) {
2032             return self;
2033         }
2034 
2035         bool equal = true;
2036         if (self._ptr != needle._ptr) {
2037             assembly {
2038                 let length := mload(needle)
2039                 let selfptr := mload(add(self, 0x20))
2040                 let needleptr := mload(add(needle, 0x20))
2041                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2042             }
2043         }
2044 
2045         if (equal) {
2046             self._len -= needle._len;
2047             self._ptr += needle._len;
2048         }
2049 
2050         return self;
2051     }
2052 
2053     /*
2054      * @dev Returns true if the slice ends with `needle`.
2055      * @param self The slice to operate on.
2056      * @param needle The slice to search for.
2057      * @return True if the slice starts with the provided text, false otherwise.
2058      */
2059     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2060         if (self._len < needle._len) {
2061             return false;
2062         }
2063 
2064         uint selfptr = self._ptr + self._len - needle._len;
2065 
2066         if (selfptr == needle._ptr) {
2067             return true;
2068         }
2069 
2070         bool equal;
2071         assembly {
2072             let length := mload(needle)
2073             let needleptr := mload(add(needle, 0x20))
2074             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2075         }
2076 
2077         return equal;
2078     }
2079 
2080     /*
2081      * @dev If `self` ends with `needle`, `needle` is removed from the
2082      *      end of `self`. Otherwise, `self` is unmodified.
2083      * @param self The slice to operate on.
2084      * @param needle The slice to search for.
2085      * @return `self`
2086      */
2087     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
2088         if (self._len < needle._len) {
2089             return self;
2090         }
2091 
2092         uint selfptr = self._ptr + self._len - needle._len;
2093         bool equal = true;
2094         if (selfptr != needle._ptr) {
2095             assembly {
2096                 let length := mload(needle)
2097                 let needleptr := mload(add(needle, 0x20))
2098                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2099             }
2100         }
2101 
2102         if (equal) {
2103             self._len -= needle._len;
2104         }
2105 
2106         return self;
2107     }
2108 
2109     // Returns the memory address of the first byte of the first occurrence of
2110     // `needle` in `self`, or the first byte after `self` if not found.
2111     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2112         uint ptr = selfptr;
2113         uint idx;
2114 
2115         if (needlelen <= selflen) {
2116             if (needlelen <= 32) {
2117                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2118 
2119                 bytes32 needledata;
2120                 assembly { needledata := and(mload(needleptr), mask) }
2121 
2122                 uint end = selfptr + selflen - needlelen;
2123                 bytes32 ptrdata;
2124                 assembly { ptrdata := and(mload(ptr), mask) }
2125 
2126                 while (ptrdata != needledata) {
2127                     if (ptr >= end)
2128                         return selfptr + selflen;
2129                     ptr++;
2130                     assembly { ptrdata := and(mload(ptr), mask) }
2131                 }
2132                 return ptr;
2133             } else {
2134                 // For long needles, use hashing
2135                 bytes32 hash;
2136                 assembly { hash := keccak256(needleptr, needlelen) }
2137 
2138                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2139                     bytes32 testHash;
2140                     assembly { testHash := keccak256(ptr, needlelen) }
2141                     if (hash == testHash)
2142                         return ptr;
2143                     ptr += 1;
2144                 }
2145             }
2146         }
2147         return selfptr + selflen;
2148     }
2149 
2150     // Returns the memory address of the first byte after the last occurrence of
2151     // `needle` in `self`, or the address of `self` if not found.
2152     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2153         uint ptr;
2154 
2155         if (needlelen <= selflen) {
2156             if (needlelen <= 32) {
2157                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2158 
2159                 bytes32 needledata;
2160                 assembly { needledata := and(mload(needleptr), mask) }
2161 
2162                 ptr = selfptr + selflen - needlelen;
2163                 bytes32 ptrdata;
2164                 assembly { ptrdata := and(mload(ptr), mask) }
2165 
2166                 while (ptrdata != needledata) {
2167                     if (ptr <= selfptr)
2168                         return selfptr;
2169                     ptr--;
2170                     assembly { ptrdata := and(mload(ptr), mask) }
2171                 }
2172                 return ptr + needlelen;
2173             } else {
2174                 // For long needles, use hashing
2175                 bytes32 hash;
2176                 assembly { hash := keccak256(needleptr, needlelen) }
2177                 ptr = selfptr + (selflen - needlelen);
2178                 while (ptr >= selfptr) {
2179                     bytes32 testHash;
2180                     assembly { testHash := keccak256(ptr, needlelen) }
2181                     if (hash == testHash)
2182                         return ptr + needlelen;
2183                     ptr -= 1;
2184                 }
2185             }
2186         }
2187         return selfptr;
2188     }
2189 
2190     /*
2191      * @dev Modifies `self` to contain everything from the first occurrence of
2192      *      `needle` to the end of the slice. `self` is set to the empty slice
2193      *      if `needle` is not found.
2194      * @param self The slice to search and modify.
2195      * @param needle The text to search for.
2196      * @return `self`.
2197      */
2198     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
2199         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2200         self._len -= ptr - self._ptr;
2201         self._ptr = ptr;
2202         return self;
2203     }
2204 
2205     /*
2206      * @dev Modifies `self` to contain the part of the string from the start of
2207      *      `self` to the end of the first occurrence of `needle`. If `needle`
2208      *      is not found, `self` is set to the empty slice.
2209      * @param self The slice to search and modify.
2210      * @param needle The text to search for.
2211      * @return `self`.
2212      */
2213     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
2214         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2215         self._len = ptr - self._ptr;
2216         return self;
2217     }
2218 
2219     /*
2220      * @dev Splits the slice, setting `self` to everything after the first
2221      *      occurrence of `needle`, and `token` to everything before it. If
2222      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2223      *      and `token` is set to the entirety of `self`.
2224      * @param self The slice to split.
2225      * @param needle The text to search for in `self`.
2226      * @param token An output parameter to which the first token is written.
2227      * @return `token`.
2228      */
2229     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2230         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2231         token._ptr = self._ptr;
2232         token._len = ptr - self._ptr;
2233         if (ptr == self._ptr + self._len) {
2234             // Not found
2235             self._len = 0;
2236         } else {
2237             self._len -= token._len + needle._len;
2238             self._ptr = ptr + needle._len;
2239         }
2240         return token;
2241     }
2242 
2243     /*
2244      * @dev Splits the slice, setting `self` to everything after the first
2245      *      occurrence of `needle`, and returning everything before it. If
2246      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2247      *      and the entirety of `self` is returned.
2248      * @param self The slice to split.
2249      * @param needle The text to search for in `self`.
2250      * @return The part of `self` up to the first occurrence of `delim`.
2251      */
2252     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2253         split(self, needle, token);
2254     }
2255 
2256     /*
2257      * @dev Splits the slice, setting `self` to everything before the last
2258      *      occurrence of `needle`, and `token` to everything after it. If
2259      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2260      *      and `token` is set to the entirety of `self`.
2261      * @param self The slice to split.
2262      * @param needle The text to search for in `self`.
2263      * @param token An output parameter to which the first token is written.
2264      * @return `token`.
2265      */
2266     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2267         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2268         token._ptr = ptr;
2269         token._len = self._len - (ptr - self._ptr);
2270         if (ptr == self._ptr) {
2271             // Not found
2272             self._len = 0;
2273         } else {
2274             self._len -= token._len + needle._len;
2275         }
2276         return token;
2277     }
2278 
2279     /*
2280      * @dev Splits the slice, setting `self` to everything before the last
2281      *      occurrence of `needle`, and returning everything after it. If
2282      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2283      *      and the entirety of `self` is returned.
2284      * @param self The slice to split.
2285      * @param needle The text to search for in `self`.
2286      * @return The part of `self` after the last occurrence of `delim`.
2287      */
2288     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2289         rsplit(self, needle, token);
2290     }
2291 
2292     /*
2293      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2294      * @param self The slice to search.
2295      * @param needle The text to search for in `self`.
2296      * @return The number of occurrences of `needle` found in `self`.
2297      */
2298     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
2299         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2300         while (ptr <= self._ptr + self._len) {
2301             cnt++;
2302             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2303         }
2304     }
2305 
2306     /*
2307      * @dev Returns True if `self` contains `needle`.
2308      * @param self The slice to search.
2309      * @param needle The text to search for in `self`.
2310      * @return True if `needle` is found in `self`, false otherwise.
2311      */
2312     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
2313         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2314     }
2315 
2316     /*
2317      * @dev Returns a newly allocated string containing the concatenation of
2318      *      `self` and `other`.
2319      * @param self The first slice to concatenate.
2320      * @param other The second slice to concatenate.
2321      * @return The concatenation of the two strings.
2322      */
2323     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
2324         string memory ret = new string(self._len + other._len);
2325         uint retptr;
2326         assembly { retptr := add(ret, 32) }
2327         memcpy(retptr, self._ptr, self._len);
2328         memcpy(retptr + self._len, other._ptr, other._len);
2329         return ret;
2330     }
2331 
2332     /*
2333      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2334      *      newly allocated string.
2335      * @param self The delimiter to use.
2336      * @param parts A list of slices to join.
2337      * @return A newly allocated string containing all the slices in `parts`,
2338      *         joined with `self`.
2339      */
2340     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
2341         if (parts.length == 0)
2342             return "";
2343 
2344         uint length = self._len * (parts.length - 1);
2345         for(uint i = 0; i < parts.length; i++)
2346             length += parts[i]._len;
2347 
2348         string memory ret = new string(length);
2349         uint retptr;
2350         assembly { retptr := add(ret, 32) }
2351 
2352         for(i = 0; i < parts.length; i++) {
2353             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2354             retptr += parts[i]._len;
2355             if (i < parts.length - 1) {
2356                 memcpy(retptr, self._ptr, self._len);
2357                 retptr += self._len;
2358             }
2359         }
2360 
2361         return ret;
2362     }
2363 }
2364 
2365 /**
2366  * The MIT License (MIT)
2367  * 
2368  * Copyright (c) 2016 Smart Contract Solutions, Inc.
2369  * 
2370  * Permission is hereby granted, free of charge, to any person obtaining
2371  * a copy of this software and associated documentation files (the
2372  * "Software"), to deal in the Software without restriction, including
2373  * without limitation the rights to use, copy, modify, merge, publish,
2374  * distribute, sublicense, and/or sell copies of the Software, and to
2375  * permit persons to whom the Software is furnished to do so, subject to
2376  * the following conditions:
2377  * 
2378  * The above copyright notice and this permission notice shall be included
2379  * in all copies or substantial portions of the Software.
2380  * 
2381  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
2382  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
2383  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
2384  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
2385  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
2386  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
2387  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
2388  */
2389 
2390 /**
2391  * @title SafeMath
2392  * @dev Math operations with safety checks that revert on error
2393  */
2394 library SafeMath {
2395 
2396   /**
2397   * @dev Multiplies two numbers, reverts on overflow.
2398   */
2399   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2400     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2401     // benefit is lost if 'b' is also tested.
2402     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2403     if (a == 0) {
2404       return 0;
2405     }
2406 
2407     uint256 c = a * b;
2408     require(c / a == b);
2409 
2410     return c;
2411   }
2412 
2413   /**
2414   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2415   */
2416   function div(uint256 a, uint256 b) internal pure returns (uint256) {
2417     require(b > 0); // Solidity only automatically asserts when dividing by 0
2418     uint256 c = a / b;
2419     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2420 
2421     return c;
2422   }
2423 
2424   /**
2425   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2426   */
2427   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2428     require(b <= a);
2429     uint256 c = a - b;
2430 
2431     return c;
2432   }
2433 
2434   /**
2435   * @dev Adds two numbers, reverts on overflow.
2436   */
2437   function add(uint256 a, uint256 b) internal pure returns (uint256) {
2438     uint256 c = a + b;
2439     require(c >= a);
2440 
2441     return c;
2442   }
2443 
2444   /**
2445   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2446   * reverts when dividing by zero.
2447   */
2448   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2449     require(b != 0);
2450     return a % b;
2451   }
2452 }
2453 
2454 /**
2455  * This method was modified from the GPLv3 solidity code found in this repository
2456  * https://github.com/vcealicu/melonport-price-feed/blob/master/pricefeed/PriceFeed.sol
2457  */
2458 
2459 /// @title Base64 provides base 64 decoding functionality.
2460 contract Base64 {
2461     bytes constant BASE64_DECODE_CHAR = hex"000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e003e003f3435363738393a3b3c3d00000000000000000102030405060708090a0b0c0d0e0f10111213141516171819000000003f001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f30313233";
2462 
2463     /// @return decoded array of bytes.
2464     /// @param _encoded base 64 encoded array of bytes.
2465     function _base64decode(bytes _encoded) internal pure returns (bytes) {
2466         byte v1;
2467         byte v2;
2468         byte v3;
2469         byte v4;
2470         uint length = _encoded.length;
2471         bytes memory result = new bytes(length);
2472         uint index;
2473 
2474         // base64 encoded strings can't be length 0 and they must be divisble by 4
2475         require(length > 0  && length % 4 == 0, "invalid base64 encoding");
2476 
2477           if (keccak256(abi.encodePacked(_encoded[length - 2])) == keccak256("=")) {
2478               length -= 2;
2479           } else if (keccak256(abi.encodePacked(_encoded[length - 1])) == keccak256("=")) {
2480               length -= 1;
2481           }
2482           uint count = length >> 2 << 2;
2483           for (uint i = 0; i < count;) {
2484               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2485               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2486               v3 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2487               v4 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2488 
2489               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2490               result[index++] = (v2 << 4 | v3 >> 2) & 255;
2491               result[index++] = (v3 << 6 | v4) & 255;
2492           }
2493           if (length - count == 2) {
2494               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2495               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2496               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2497           } else if (length - count == 3) {
2498               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2499               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2500               v3 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2501 
2502               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2503               result[index++] = (v2 << 4 | v3 >> 2) & 255;
2504           }
2505 
2506         // Set to correct length.
2507         assembly {
2508             mstore(result, index)
2509         }
2510 
2511         return result;
2512     }
2513 }
2514 
2515 
2516 /// @title Oracle converts ERC20 token amounts into equivalent ether amounts based on cryptocurrency exchange rates.
2517 interface IOracle {
2518     function convert(address, uint) external view returns (bool, uint);
2519 }
2520 
2521 
2522 /// @title Oracle provides asset exchange rates and conversion functionality.
2523 contract Oracle is usingOraclize, Base64, Date, JSON, Controllable, ParseIntScientific, IOracle {
2524     using strings for *;
2525     using SafeMath for uint256;
2526 
2527 
2528     /*******************/
2529     /*     Events     */
2530     /*****************/
2531 
2532     event AddedToken(address _sender, address _token, string _symbol, uint _magnitude);
2533     event RemovedToken(address _sender, address _token);
2534     event UpdatedTokenRate(address _sender, address _token, uint _rate);
2535 
2536     event SetGasPrice(address _sender, uint _gasPrice);
2537     event Converted(address _sender, address _token, uint _amount, uint _ether);
2538 
2539     event RequestedUpdate(string _symbol);
2540     event FailedUpdateRequest(string _reason);
2541 
2542     event VerifiedProof(bytes _publicKey, string _result);
2543 
2544     event SetCryptoComparePublicKey(address _sender, bytes _publicKey);
2545 
2546     /**********************/
2547     /*     Constants     */
2548     /********************/
2549 
2550     uint constant private PROOF_LEN = 165;
2551     uint constant private ECDSA_SIG_LEN = 65;
2552     uint constant private ENCODING_BYTES = 2;
2553     uint constant private HEADERS_LEN = PROOF_LEN - 2 * ENCODING_BYTES - ECDSA_SIG_LEN; // 2 bytes encoding headers length + 2 for signature.
2554     uint constant private DIGEST_BASE64_LEN = 44; //base64 encoding of the SHA256 hash (32-bytes) of the result: fixed length.
2555     uint constant private DIGEST_OFFSET = HEADERS_LEN - DIGEST_BASE64_LEN; // the starting position of the result hash in the headers string.
2556 
2557     uint constant private MAX_BYTE_SIZE = 256; //for calculating length encoding
2558 
2559     struct Token {
2560         string symbol;    // Token symbol
2561         uint magnitude;   // 10^decimals
2562         uint rate;        // Token exchange rate in wei
2563         uint lastUpdate;  // Time of the last rate update
2564         bool exists;      // Flags if the struct is empty or not
2565     }
2566 
2567     mapping(address => Token) public tokens;
2568     address[] private _tokenAddresses;
2569 
2570     bytes public APIPublicKey;
2571     mapping(bytes32 => address) private _queryToToken;
2572 
2573     /// @dev Construct the oracle with multiple controllers, address resolver and custom gas price.
2574     /// @dev _resolver is the oraclize address resolver contract address.
2575     /// @param _ens is the address of the ENS.
2576     /// @param _controllerName is the ENS name of the Controller.
2577     constructor(address _resolver, address _ens, bytes32 _controllerName) Controllable(_ens, _controllerName) public {
2578         APIPublicKey = hex"a0f4f688350018ad1b9785991c0bde5f704b005dc79972b114dbed4a615a983710bfc647ebe5a320daa28771dce6a2d104f5efa2e4a85ba3760b76d46f8571ca";
2579         OAR = OraclizeAddrResolverI(_resolver);
2580         oraclize_setCustomGasPrice(10000000000);
2581         oraclize_setProof(proofType_Native);
2582     }
2583 
2584     /// @dev Updates the Crypto Compare public API key.
2585     function updateAPIPublicKey(bytes _publicKey) external onlyController {
2586         APIPublicKey = _publicKey;
2587         emit SetCryptoComparePublicKey(msg.sender, _publicKey);
2588     }
2589 
2590     /// @dev Sets the gas price used by oraclize query.
2591     function setCustomGasPrice(uint _gasPrice) external onlyController {
2592         oraclize_setCustomGasPrice(_gasPrice);
2593         emit SetGasPrice(msg.sender, _gasPrice);
2594     }
2595 
2596     /// @dev Convert ERC20 token amount to the corresponding ether amount (used by the wallet contract).
2597     /// @param _token ERC20 token contract address.
2598     /// @param _amount amount of token in base units.
2599     function convert(address _token, uint _amount) external view returns (bool, uint) {
2600         // Store the token in memory to save map entry lookup gas.
2601         Token storage token = tokens[_token];
2602         // If the token exists require that its rate is not zero
2603         if (token.exists) {
2604             require(token.rate != 0, "token rate is 0");
2605             // Safely convert the token amount to ether based on the exchange rate.
2606             // return the value and a 'true' implying that the token is protected
2607             return (true, _amount.mul(token.rate).div(token.magnitude));
2608         }
2609         // this returns a 'false' to imply that a card is not protected 
2610         return (false, 0);
2611         
2612     }
2613 
2614     /// @dev Add ERC20 tokens to the list of supported tokens.
2615     /// @param _tokens ERC20 token contract addresses.
2616     /// @param _symbols ERC20 token names.
2617     /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.
2618     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2619     function addTokens(address[] _tokens, bytes32[] _symbols, uint[] _magnitude, uint _updateDate) external onlyController {
2620         // Require that all parameters have the same length.
2621         require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length, "parameter lengths do not match");
2622         // Add each token to the list of supported tokens.
2623         for (uint i = 0; i < _tokens.length; i++) {
2624             // Require that the token doesn't already exist.
2625             address token = _tokens[i];
2626             require(!tokens[token].exists, "token already exists");
2627             // Store the intermediate values.
2628             string memory symbol = _symbols[i].toSliceB32().toString();
2629             uint magnitude = _magnitude[i];
2630             // Add the token to the token list.
2631             tokens[token] = Token({
2632                 symbol : symbol,
2633                 magnitude : magnitude,
2634                 rate : 0,
2635                 exists : true,
2636                 lastUpdate: _updateDate
2637             });
2638             // Add the token address to the address list.
2639             _tokenAddresses.push(token);
2640             // Emit token addition event.
2641             emit AddedToken(msg.sender, token, symbol, magnitude);
2642         }
2643     }
2644 
2645     /// @dev Remove ERC20 tokens from the list of supported tokens.
2646     /// @param _tokens ERC20 token contract addresses.
2647     function removeTokens(address[] _tokens) external onlyController {
2648         // Delete each token object from the list of supported tokens based on the addresses provided.
2649         for (uint i = 0; i < _tokens.length; i++) {
2650             //token must exist, reverts on duplicates as well
2651             require(tokens[_tokens[i]].exists, "token does not exist");
2652             // Store the token address.
2653             address token = _tokens[i];
2654             // Delete the token object.
2655             delete tokens[token];
2656             // Remove the token address from the address list.
2657             for (uint j = 0; j < _tokenAddresses.length.sub(1); j++) {
2658                 if (_tokenAddresses[j] == token) {
2659                     _tokenAddresses[j] = _tokenAddresses[_tokenAddresses.length.sub(1)];
2660                     break;
2661                 }
2662             }
2663             _tokenAddresses.length--;
2664             // Emit token removal event.
2665             emit RemovedToken(msg.sender, token);
2666         }
2667     }
2668 
2669     /// @dev Update ERC20 token exchange rate manually.
2670     /// @param _token ERC20 token contract address.
2671     /// @param _rate ERC20 token exchange rate in wei.
2672     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2673     function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyController {
2674         // Require that the token exists.
2675         require(tokens[_token].exists, "token does not exist");
2676         // Update the token's rate.
2677         tokens[_token].rate = _rate;
2678         // Update the token's last update timestamp.
2679         tokens[_token].lastUpdate = _updateDate;
2680         // Emit the rate update event.
2681         emit UpdatedTokenRate(msg.sender, _token, _rate);
2682     }
2683 
2684     /// @dev Update ERC20 token exchange rates for all supported tokens.
2685     //// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
2686     function updateTokenRates(uint _gasLimit) external payable onlyController {
2687         _updateTokenRates(_gasLimit);
2688     }
2689 
2690     //// @dev Withdraw ether from the smart contract to the specified account.
2691     function withdraw(address _to, uint _amount) external onlyController {
2692         _to.transfer(_amount);
2693     }
2694 
2695     //// @dev Handle Oraclize query callback and verifiy the provided origin proof.
2696     //// @param _queryID Oraclize query ID.
2697     //// @param _result query result in JSON format.
2698     //// @param _proof origin proof from crypto compare.
2699     // solium-disable-next-line mixedcase
2700     function __callback(bytes32 _queryID, string _result, bytes _proof) public {
2701         // Require that the caller is the Oraclize contract.
2702         require(msg.sender == oraclize_cbAddress(), "sender is not oraclize");
2703         // Use the query ID to find the matching token address.
2704         address _token = _queryToToken[_queryID];
2705         require(_token != address(0), "queryID matches to address 0");
2706         // Get the corresponding token object.
2707         Token storage token = tokens[_token];
2708 
2709         bool valid;
2710         uint timestamp;
2711         (valid, timestamp) = _verifyProof(_result, _proof, APIPublicKey, token.lastUpdate);
2712 
2713         // Require that the proof is valid.
2714         if (valid) {
2715             // Parse the JSON result to get the rate in wei.
2716             token.rate = _parseIntScientificWei(parseRate(_result));
2717             // Set the update time of the token rate.
2718             token.lastUpdate = timestamp;
2719             // Remove query from the list.
2720             delete _queryToToken[_queryID];
2721             // Emit the rate update event.
2722             emit UpdatedTokenRate(msg.sender, _token, token.rate);
2723         }
2724     }
2725 
2726     /// @dev Re-usable helper function that performs the Oraclize Query.
2727     //// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
2728     function _updateTokenRates(uint _gasLimit) private {
2729         // Check if there are any existing tokens.
2730         if (_tokenAddresses.length == 0) {
2731             // Emit a query failure event.
2732             emit FailedUpdateRequest("no tokens");
2733         // Check if the contract has enough Ether to pay for the query.
2734         } else if (oraclize_getPrice("URL") * _tokenAddresses.length > address(this).balance) {
2735             // Emit a query failure event.
2736             emit FailedUpdateRequest("insufficient balance");
2737         } else {
2738             // Set up the cryptocompare API query strings.
2739             strings.slice memory apiPrefix = "https://min-api.cryptocompare.com/data/price?fsym=".toSlice();
2740             strings.slice memory apiSuffix = "&tsyms=ETH&sign=true".toSlice();
2741 
2742             // Create a new oraclize query for each supported token.
2743             for (uint i = 0; i < _tokenAddresses.length; i++) {
2744                 // Store the token symbol used in the query.
2745                 strings.slice memory symbol = tokens[_tokenAddresses[i]].symbol.toSlice();
2746                 // Create a new oraclize query from the component strings.
2747                 bytes32 queryID = oraclize_query("URL", apiPrefix.concat(symbol).toSlice().concat(apiSuffix), _gasLimit);
2748                 // Store the query ID together with the associated token address.
2749                 _queryToToken[queryID] = _tokenAddresses[i];
2750                 // Emit the query success event.
2751                 emit RequestedUpdate(symbol.toString());
2752             }
2753         }
2754     }
2755 
2756     /// @dev Verify the origin proof returned by the cryptocompare API.
2757     /// @param _result query result in JSON format.
2758     /// @param _proof origin proof from cryptocompare.
2759     /// @param _publicKey cryptocompare public key.
2760     /// @param _lastUpdate timestamp of the last time the requested token was updated.
2761     function _verifyProof(string _result, bytes _proof, bytes _publicKey, uint _lastUpdate) private returns (bool, uint) {
2762 
2763         //expecting fixed length proofs
2764         if (_proof.length != PROOF_LEN)
2765           revert("invalid proof length");
2766 
2767         //proof should be 65 bytes long: R (32 bytes) + S (32 bytes) + v (1 byte)
2768         if (uint(_proof[1]) != ECDSA_SIG_LEN)
2769           revert("invalid signature length");
2770 
2771         bytes memory signature = new bytes(ECDSA_SIG_LEN);
2772 
2773         signature = copyBytes(_proof, 2, ECDSA_SIG_LEN, signature, 0);
2774 
2775         // Extract the headers, big endian encoding of headers length
2776         if (uint(_proof[ENCODING_BYTES + ECDSA_SIG_LEN]) * MAX_BYTE_SIZE + uint(_proof[ENCODING_BYTES + ECDSA_SIG_LEN + 1]) != HEADERS_LEN)
2777           revert("invalid headers length");
2778 
2779         bytes memory headers = new bytes(HEADERS_LEN);
2780         headers = copyBytes(_proof, 2*ENCODING_BYTES + ECDSA_SIG_LEN, HEADERS_LEN, headers, 0);
2781 
2782         // Check if the signature is valid and if the signer address is matching.
2783         if (!_verifySignature(headers, signature, _publicKey)) {
2784             revert("invalid signature");
2785         }
2786 
2787         // Check if the date is valid.
2788         bytes memory dateHeader = new bytes(20);
2789         //keep only the relevant string(e.g. "16 Nov 2018 16:22:18")
2790         dateHeader = copyBytes(headers, 11, 20, dateHeader, 0);
2791 
2792         bool dateValid;
2793         uint timestamp;
2794         (dateValid, timestamp) = _verifyDate(string(dateHeader), _lastUpdate);
2795 
2796         // Check whether the date returned is valid or not
2797         if (!dateValid)
2798             revert("invalid date");
2799 
2800         // Check if the signed digest hash matches the result hash.
2801         bytes memory digest = new bytes(DIGEST_BASE64_LEN);
2802         digest = copyBytes(headers, DIGEST_OFFSET, DIGEST_BASE64_LEN, digest, 0);
2803 
2804         if (keccak256(abi.encodePacked(sha256(abi.encodePacked(_result)))) != keccak256(_base64decode(digest)))
2805           revert("result hash not matching");
2806 
2807         emit VerifiedProof(_publicKey, _result);
2808         return (true, timestamp);
2809     }
2810 
2811     /// @dev Verify the HTTP headers and the signature
2812     /// @param _headers HTTP headers provided by the cryptocompare api
2813     /// @param _signature signature provided by the cryptocompare api
2814     /// @param _publicKey cryptocompare public key.
2815     function _verifySignature(bytes _headers, bytes _signature, bytes _publicKey) private returns (bool) {
2816         address signer;
2817         bool signatureOK;
2818 
2819         // Checks if the signature is valid by hashing the headers
2820         (signatureOK, signer) = ecrecovery(sha256(_headers), _signature);
2821         return signatureOK && signer == address(keccak256(_publicKey));
2822     }
2823 
2824     /// @dev Verify the signed HTTP date header.
2825     /// @param _dateHeader extracted date string e.g. Wed, 12 Sep 2018 15:18:14 GMT.
2826     /// @param _lastUpdate timestamp of the last time the requested token was updated.
2827     function _verifyDate(string _dateHeader, uint _lastUpdate) private pure returns (bool, uint) {
2828 
2829         //called by verifyProof(), _dateHeader is always a string of length = 20
2830         assert(abi.encodePacked(_dateHeader).length == 20);
2831 
2832         //Split the date string and get individual date components.
2833         strings.slice memory date = _dateHeader.toSlice();
2834         strings.slice memory timeDelimiter = ":".toSlice();
2835         strings.slice memory dateDelimiter = " ".toSlice();
2836 
2837         uint day = _parseIntScientific(date.split(dateDelimiter).toString());
2838         require(day > 0 && day < 32, "day error");
2839 
2840         uint month = _monthToNumber(date.split(dateDelimiter).toString());
2841         require(month > 0 && month < 13, "month error");
2842 
2843         uint year = _parseIntScientific(date.split(dateDelimiter).toString());
2844         require(year > 2017 && year < 3000, "year error");
2845 
2846         uint hour = _parseIntScientific(date.split(timeDelimiter).toString());
2847         require(hour < 25, "hour error");
2848 
2849         uint minute = _parseIntScientific(date.split(timeDelimiter).toString());
2850         require(minute < 60, "minute error");
2851 
2852         uint second = _parseIntScientific(date.split(timeDelimiter).toString());
2853         require(second < 60, "second error");
2854 
2855         uint timestamp = year * (10 ** 10) + month * (10 ** 8) + day * (10 ** 6) + hour * (10 ** 4) + minute * (10 ** 2) + second;
2856 
2857         return (timestamp > _lastUpdate, timestamp);
2858     }
2859 }