1 /**
2  *  The Consumer Contract Wallet
3  *  Copyright (C) 2018 The Contract Wallet Company Limited
4  *
5  *  This program is free software: you can redistribute it and/or modify
6  *  it under the terms of the GNU General Public License as published by
7  *  the Free Software Foundation, either version 3 of the License, or
8  *  (at your option) any later version.
9 
10  *  This program is distributed in the hope that it will be useful,
11  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
12  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  *  GNU General Public License for more details.
14 
15  *  You should have received a copy of the GNU General Public License
16  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
17  */
18 
19 pragma solidity ^0.4.25;
20 
21 /**
22  *  Token Exchange Rate Oracle
23  *  Copyright (C) 2018 The Contract Wallet Company Limited
24  *
25  *  This program is free software: you can redistribute it and/or modify
26  *  it under the terms of the GNU General Public License as published by
27  *  the Free Software Foundation, either version 3 of the License, or
28  *  (at your option) any later version.
29  *
30  *  This program is distributed in the hope that it will be useful,
31  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
32  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
33  *  GNU General Public License for more details.
34  *
35  *  You should have received a copy of the GNU General Public License
36  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
37  */
38 
39 
40  /**
41   *  Controller Interface
42   *  Copyright (C) 2018 The Contract Wallet Company Limited
43   *
44   *  This program is free software: you can redistribute it and/or modify
45   *  it under the terms of the GNU General Public License as published by
46   *  the Free Software Foundation, either version 3 of the License, or
47   *  (at your option) any later version.
48 
49   *  This program is distributed in the hope that it will be useful,
50   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
51   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
52   *  GNU General Public License for more details.
53 
54   *  You should have received a copy of the GNU General Public License
55   *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
56   */
57 
58   /**
59    *  Controller
60    *  Copyright (C) 2018 The Contract Wallet Company Limited
61    *
62    *  This program is free software: you can redistribute it and/or modify
63    *  it under the terms of the GNU General Public License as published by
64    *  the Free Software Foundation, either version 3 of the License, or
65    *  (at your option) any later version.
66 
67    *  This program is distributed in the hope that it will be useful,
68    *  but WITHOUT ANY WARRANTY; without even the implied warranty of
69    *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
70    *  GNU General Public License for more details.
71 
72    *  You should have received a copy of the GNU General Public License
73    *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
74    */
75 
76 
77   /// @title The Controller interface provides access to an external list of controllers.
78   interface IController {
79       function isController(address) external view returns (bool);
80   }
81 
82   /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
83   contract Controller is IController {
84       event AddedController(address _sender, address _controller);
85       event RemovedController(address _sender, address _controller);
86 
87       mapping (address => bool) private _isController;
88       uint private _controllerCount;
89 
90       /// @dev Constructor initializes the list of controllers with the provided address.
91       /// @param _account address to add to the list of controllers.
92       constructor(address _account) public {
93           _addController(_account);
94       }
95 
96       /// @dev Checks if message sender is a controller.
97       modifier onlyController() {
98           require(isController(msg.sender), "sender is not a controller");
99           _;
100       }
101 
102       /// @dev Add a new controller to the list of controllers.
103       /// @param _account address to add to the list of controllers.
104       function addController(address _account) external onlyController {
105           _addController(_account);
106       }
107 
108       /// @dev Remove a controller from the list of controllers.
109       /// @param _account address to remove from the list of controllers.
110       function removeController(address _account) external onlyController {
111           _removeController(_account);
112       }
113 
114       /// @return true if the provided account is a controller.
115       function isController(address _account) public view returns (bool) {
116           return _isController[_account];
117       }
118 
119       /// @return the current number of controllers.
120       function controllerCount() public view returns (uint) {
121           return _controllerCount;
122       }
123 
124       /// @dev Internal-only function that adds a new controller.
125       function _addController(address _account) internal {
126           require(!_isController[_account], "provided account is already a controller");
127           _isController[_account] = true;
128           _controllerCount++;
129           emit AddedController(msg.sender, _account);
130       }
131 
132       /// @dev Internal-only function that removes an existing controller.
133       function _removeController(address _account) internal {
134           require(_isController[_account], "provided account is not a controller");
135           require(_controllerCount > 1, "cannot remove the last controller");
136           _isController[_account] = false;
137           _controllerCount--;
138           emit RemovedController(msg.sender, _account);
139       }
140   }
141 
142 
143  /// @title Resolver returns the controller contract address.
144  interface IResolver {
145      function addr(bytes32) external view returns (address);
146  }
147 
148  /// @title Controllable implements access control functionality based on a controller set in ENS.
149  contract Controllable {
150      /// @dev _ENS points to the ENS registry smart contract.
151      ENS private _ENS;
152      /// @dev Is the registered ENS name of the controller contract.
153      bytes32 private _node;
154 
155      /// @dev Constructor initializes the controller contract object.
156      /// @param _ens is the address of the ENS.
157      /// @param _controllerName is the ENS name of the Controller.
158      constructor(address _ens, bytes32 _controllerName) internal {
159        _ENS = ENS(_ens);
160        _node = _controllerName;
161      }
162 
163      /// @dev Checks if message sender is the controller.
164      modifier onlyController() {
165          require(_isController(msg.sender), "sender is not a controller");
166          _;
167      }
168 
169      /// @return true if the provided account is the controller.
170      function _isController(address _account) internal view returns (bool) {
171          return IController(IResolver(_ENS.resolver(_node)).addr(_node)).isController(_account);
172      }
173  }
174 
175 /**
176  *  Month Parser
177  *  Copyright (C) 2018 The Contract Wallet Company Limited
178  *
179  *  This program is free software: you can redistribute it and/or modify
180  *  it under the terms of the GNU General Public License as published by
181  *  the Free Software Foundation, either version 3 of the License, or
182  *  (at your option) any later version.
183 
184  *  This program is distributed in the hope that it will be useful,
185  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
186  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
187  *  GNU General Public License for more details.
188 
189  *  You should have received a copy of the GNU General Public License
190  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
191  */
192 
193 
194 /// @title Date provides date parsing functionality.
195 contract Date {
196 
197     bytes32 constant private JANUARY = keccak256("Jan");
198     bytes32 constant private FEBRUARY = keccak256("Feb");
199     bytes32 constant private MARCH = keccak256("Mar");
200     bytes32 constant private APRIL = keccak256("Apr");
201     bytes32 constant private MAY = keccak256("May");
202     bytes32 constant private JUNE = keccak256("Jun");
203     bytes32 constant private JULY = keccak256("Jul");
204     bytes32 constant private AUGUST = keccak256("Aug");
205     bytes32 constant private SEPTEMBER = keccak256("Sep");
206     bytes32 constant private OCTOBER = keccak256("Oct");
207     bytes32 constant private NOVEMBER = keccak256("Nov");
208     bytes32 constant private DECEMBER = keccak256("Dec");
209 
210     /// @return the number of the month based on its name.
211     /// @param _month the first three letters of a month's name e.g. "Jan".
212     function _monthToNumber(string _month) internal pure returns (uint8) {
213         bytes32 month = keccak256(abi.encodePacked(_month));
214         if (month == JANUARY) {
215             return 1;
216         } else if (month == FEBRUARY) {
217             return 2;
218         } else if (month == MARCH) {
219             return 3;
220         } else if (month == APRIL) {
221             return 4;
222         } else if (month == MAY) {
223             return 5;
224         } else if (month == JUNE) {
225             return 6;
226         } else if (month == JULY) {
227             return 7;
228         } else if (month == AUGUST) {
229             return 8;
230         } else if (month == SEPTEMBER) {
231             return 9;
232         } else if (month == OCTOBER) {
233             return 10;
234         } else if (month == NOVEMBER) {
235             return 11;
236         } else if (month == DECEMBER) {
237             return 12;
238         } else {
239             revert("not a valid month");
240         }
241     }
242 }
243 
244 
245 /**
246  *  JSON Parser
247  *  Copyright (C) 2018 The Contract Wallet Company Limited
248  *
249  *  This program is free software: you can redistribute it and/or modify
250  *  it under the terms of the GNU General Public License as published by
251  *  the Free Software Foundation, either version 3 of the License, or
252  *  (at your option) any later version.
253 
254  *  This program is distributed in the hope that it will be useful,
255  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
256  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
257  *  GNU General Public License for more details.
258 
259  *  You should have received a copy of the GNU General Public License
260  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
261  */
262 
263 
264 // <ORACLIZE_API>
265 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
266 /*
267 Copyright (c) 2015-2016 Oraclize SRL
268 Copyright (c) 2016 Oraclize LTD
269 
270 
271 
272 Permission is hereby granted, free of charge, to any person obtaining a copy
273 of this software and associated documentation files (the "Software"), to deal
274 in the Software without restriction, including without limitation the rights
275 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
276 copies of the Software, and to permit persons to whom the Software is
277 furnished to do so, subject to the following conditions:
278 
279 
280 
281 The above copyright notice and this permission notice shall be included in
282 all copies or substantial portions of the Software.
283 
284 
285 
286 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
287 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
288 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
289 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
290 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
291 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
292 THE SOFTWARE.
293 */
294 
295 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
296 
297 contract OraclizeI {
298     address public cbAddress;
299     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
300     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
301     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
302     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
303     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
304     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
305     function getPrice(string _datasource) public returns (uint _dsprice);
306     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
307     function setProofType(byte _proofType) external;
308     function setCustomGasPrice(uint _gasPrice) external;
309     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
310 }
311 
312 contract OraclizeAddrResolverI {
313     function getAddress() public returns (address _addr);
314 }
315 
316 /*
317 Begin solidity-cborutils
318 
319 https://github.com/smartcontractkit/solidity-cborutils
320 
321 MIT License
322 
323 Copyright (c) 2018 SmartContract ChainLink, Ltd.
324 
325 Permission is hereby granted, free of charge, to any person obtaining a copy
326 of this software and associated documentation files (the "Software"), to deal
327 in the Software without restriction, including without limitation the rights
328 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
329 copies of the Software, and to permit persons to whom the Software is
330 furnished to do so, subject to the following conditions:
331 
332 The above copyright notice and this permission notice shall be included in all
333 copies or substantial portions of the Software.
334 
335 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
336 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
337 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
338 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
339 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
340 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
341 SOFTWARE.
342  */
343 
344 library Buffer {
345     struct buffer {
346         bytes buf;
347         uint capacity;
348     }
349 
350     function init(buffer memory buf, uint _capacity) internal pure {
351         uint capacity = _capacity;
352         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
353         // Allocate space for the buffer data
354         buf.capacity = capacity;
355         assembly {
356             let ptr := mload(0x40)
357             mstore(buf, ptr)
358             mstore(ptr, 0)
359             mstore(0x40, add(ptr, capacity))
360         }
361     }
362 
363     function resize(buffer memory buf, uint capacity) private pure {
364         bytes memory oldbuf = buf.buf;
365         init(buf, capacity);
366         append(buf, oldbuf);
367     }
368 
369     function max(uint a, uint b) private pure returns(uint) {
370         if(a > b) {
371             return a;
372         }
373         return b;
374     }
375 
376     /**
377      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
378      *      would exceed the capacity of the buffer.
379      * @param buf The buffer to append to.
380      * @param data The data to append.
381      * @return The original buffer.
382      */
383     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
384         if(data.length + buf.buf.length > buf.capacity) {
385             resize(buf, max(buf.capacity, data.length) * 2);
386         }
387 
388         uint dest;
389         uint src;
390         uint len = data.length;
391         assembly {
392             // Memory address of the buffer data
393             let bufptr := mload(buf)
394             // Length of existing buffer data
395             let buflen := mload(bufptr)
396             // Start address = buffer address + buffer length + sizeof(buffer length)
397             dest := add(add(bufptr, buflen), 32)
398             // Update buffer length
399             mstore(bufptr, add(buflen, mload(data)))
400             src := add(data, 32)
401         }
402 
403         // Copy word-length chunks while possible
404         for(; len >= 32; len -= 32) {
405             assembly {
406                 mstore(dest, mload(src))
407             }
408             dest += 32;
409             src += 32;
410         }
411 
412         // Copy remaining bytes
413         uint mask = 256 ** (32 - len) - 1;
414         assembly {
415             let srcpart := and(mload(src), not(mask))
416             let destpart := and(mload(dest), mask)
417             mstore(dest, or(destpart, srcpart))
418         }
419 
420         return buf;
421     }
422 
423     /**
424      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
425      * exceed the capacity of the buffer.
426      * @param buf The buffer to append to.
427      * @param data The data to append.
428      * @return The original buffer.
429      */
430     function append(buffer memory buf, uint8 data) internal pure {
431         if(buf.buf.length + 1 > buf.capacity) {
432             resize(buf, buf.capacity * 2);
433         }
434 
435         assembly {
436             // Memory address of the buffer data
437             let bufptr := mload(buf)
438             // Length of existing buffer data
439             let buflen := mload(bufptr)
440             // Address = buffer address + buffer length + sizeof(buffer length)
441             let dest := add(add(bufptr, buflen), 32)
442             mstore8(dest, data)
443             // Update buffer length
444             mstore(bufptr, add(buflen, 1))
445         }
446     }
447 
448     /**
449      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
450      * exceed the capacity of the buffer.
451      * @param buf The buffer to append to.
452      * @param data The data to append.
453      * @return The original buffer.
454      */
455     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
456         if(len + buf.buf.length > buf.capacity) {
457             resize(buf, max(buf.capacity, len) * 2);
458         }
459 
460         uint mask = 256 ** len - 1;
461         assembly {
462             // Memory address of the buffer data
463             let bufptr := mload(buf)
464             // Length of existing buffer data
465             let buflen := mload(bufptr)
466             // Address = buffer address + buffer length + sizeof(buffer length) + len
467             let dest := add(add(bufptr, buflen), len)
468             mstore(dest, or(and(mload(dest), not(mask)), data))
469             // Update buffer length
470             mstore(bufptr, add(buflen, len))
471         }
472         return buf;
473     }
474 }
475 
476 library CBOR {
477     using Buffer for Buffer.buffer;
478 
479     uint8 private constant MAJOR_TYPE_INT = 0;
480     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
481     uint8 private constant MAJOR_TYPE_BYTES = 2;
482     uint8 private constant MAJOR_TYPE_STRING = 3;
483     uint8 private constant MAJOR_TYPE_ARRAY = 4;
484     uint8 private constant MAJOR_TYPE_MAP = 5;
485     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
486 
487     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
488         if(value <= 23) {
489             buf.append(uint8((major << 5) | value));
490         } else if(value <= 0xFF) {
491             buf.append(uint8((major << 5) | 24));
492             buf.appendInt(value, 1);
493         } else if(value <= 0xFFFF) {
494             buf.append(uint8((major << 5) | 25));
495             buf.appendInt(value, 2);
496         } else if(value <= 0xFFFFFFFF) {
497             buf.append(uint8((major << 5) | 26));
498             buf.appendInt(value, 4);
499         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
500             buf.append(uint8((major << 5) | 27));
501             buf.appendInt(value, 8);
502         }
503     }
504 
505     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
506         buf.append(uint8((major << 5) | 31));
507     }
508 
509     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
510         encodeType(buf, MAJOR_TYPE_INT, value);
511     }
512 
513     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
514         if(value >= 0) {
515             encodeType(buf, MAJOR_TYPE_INT, uint(value));
516         } else {
517             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
518         }
519     }
520 
521     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
522         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
523         buf.append(value);
524     }
525 
526     function encodeString(Buffer.buffer memory buf, string value) internal pure {
527         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
528         buf.append(bytes(value));
529     }
530 
531     function startArray(Buffer.buffer memory buf) internal pure {
532         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
533     }
534 
535     function startMap(Buffer.buffer memory buf) internal pure {
536         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
537     }
538 
539     function endSequence(Buffer.buffer memory buf) internal pure {
540         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
541     }
542 }
543 
544 /*
545 End solidity-cborutils
546  */
547 
548 contract usingOraclize {
549     uint constant day = 60*60*24;
550     uint constant week = 60*60*24*7;
551     uint constant month = 60*60*24*30;
552     byte constant proofType_NONE = 0x00;
553     byte constant proofType_TLSNotary = 0x10;
554     byte constant proofType_Ledger = 0x30;
555     byte constant proofType_Android = 0x40;
556     byte constant proofType_Native = 0xF0;
557     byte constant proofStorage_IPFS = 0x01;
558     uint8 constant networkID_auto = 0;
559     uint8 constant networkID_mainnet = 1;
560     uint8 constant networkID_testnet = 2;
561     uint8 constant networkID_morden = 2;
562     uint8 constant networkID_consensys = 161;
563 
564     OraclizeAddrResolverI OAR;
565 
566     OraclizeI oraclize;
567     modifier oraclizeAPI {
568         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
569             oraclize_setNetwork(networkID_auto);
570 
571         if(address(oraclize) != OAR.getAddress())
572             oraclize = OraclizeI(OAR.getAddress());
573 
574         _;
575     }
576     modifier coupon(string code){
577         oraclize = OraclizeI(OAR.getAddress());
578         _;
579     }
580 
581     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
582       return oraclize_setNetwork();
583       networkID; // silence the warning and remain backwards compatible
584     }
585     function oraclize_setNetwork() internal returns(bool){
586         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
587             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
588             oraclize_setNetworkName("eth_mainnet");
589             return true;
590         }
591         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
592             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
593             oraclize_setNetworkName("eth_ropsten3");
594             return true;
595         }
596         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
597             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
598             oraclize_setNetworkName("eth_kovan");
599             return true;
600         }
601         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
602             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
603             oraclize_setNetworkName("eth_rinkeby");
604             return true;
605         }
606         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
607             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
608             return true;
609         }
610         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
611             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
612             return true;
613         }
614         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
615             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
616             return true;
617         }
618         return false;
619     }
620 
621     function __callback(bytes32 myid, string result) public {
622         __callback(myid, result, new bytes(0));
623     }
624     function __callback(bytes32 myid, string result, bytes proof) public {
625       return;
626       // Following should never be reached with a preceding return, however
627       // this is just a placeholder function, ideally meant to be defined in
628       // child contract when proofs are used
629       myid; result; proof; // Silence compiler warnings
630       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
631     }
632 
633     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
634         return oraclize.getPrice(datasource);
635     }
636 
637     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
638         return oraclize.getPrice(datasource, gaslimit);
639     }
640 
641     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
642         uint price = oraclize.getPrice(datasource);
643         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
644         return oraclize.query.value(price)(0, datasource, arg);
645     }
646     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
647         uint price = oraclize.getPrice(datasource);
648         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
649         return oraclize.query.value(price)(timestamp, datasource, arg);
650     }
651     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
652         uint price = oraclize.getPrice(datasource, gaslimit);
653         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
654         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
655     }
656     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
657         uint price = oraclize.getPrice(datasource, gaslimit);
658         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
659         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
660     }
661     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
662         uint price = oraclize.getPrice(datasource);
663         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
664         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
665     }
666     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
667         uint price = oraclize.getPrice(datasource);
668         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
669         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
670     }
671     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
672         uint price = oraclize.getPrice(datasource, gaslimit);
673         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
674         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
675     }
676     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
677         uint price = oraclize.getPrice(datasource, gaslimit);
678         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
679         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
680     }
681     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
682         uint price = oraclize.getPrice(datasource);
683         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
684         bytes memory args = stra2cbor(argN);
685         return oraclize.queryN.value(price)(0, datasource, args);
686     }
687     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
688         uint price = oraclize.getPrice(datasource);
689         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
690         bytes memory args = stra2cbor(argN);
691         return oraclize.queryN.value(price)(timestamp, datasource, args);
692     }
693     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
694         uint price = oraclize.getPrice(datasource, gaslimit);
695         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
696         bytes memory args = stra2cbor(argN);
697         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
698     }
699     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
700         uint price = oraclize.getPrice(datasource, gaslimit);
701         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
702         bytes memory args = stra2cbor(argN);
703         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
704     }
705     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
706         string[] memory dynargs = new string[](1);
707         dynargs[0] = args[0];
708         return oraclize_query(datasource, dynargs);
709     }
710     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
711         string[] memory dynargs = new string[](1);
712         dynargs[0] = args[0];
713         return oraclize_query(timestamp, datasource, dynargs);
714     }
715     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
716         string[] memory dynargs = new string[](1);
717         dynargs[0] = args[0];
718         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
719     }
720     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
721         string[] memory dynargs = new string[](1);
722         dynargs[0] = args[0];
723         return oraclize_query(datasource, dynargs, gaslimit);
724     }
725 
726     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
727         string[] memory dynargs = new string[](2);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         return oraclize_query(datasource, dynargs);
731     }
732     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
733         string[] memory dynargs = new string[](2);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         return oraclize_query(timestamp, datasource, dynargs);
737     }
738     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
739         string[] memory dynargs = new string[](2);
740         dynargs[0] = args[0];
741         dynargs[1] = args[1];
742         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
743     }
744     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         string[] memory dynargs = new string[](2);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         return oraclize_query(datasource, dynargs, gaslimit);
749     }
750     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
751         string[] memory dynargs = new string[](3);
752         dynargs[0] = args[0];
753         dynargs[1] = args[1];
754         dynargs[2] = args[2];
755         return oraclize_query(datasource, dynargs);
756     }
757     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
758         string[] memory dynargs = new string[](3);
759         dynargs[0] = args[0];
760         dynargs[1] = args[1];
761         dynargs[2] = args[2];
762         return oraclize_query(timestamp, datasource, dynargs);
763     }
764     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
765         string[] memory dynargs = new string[](3);
766         dynargs[0] = args[0];
767         dynargs[1] = args[1];
768         dynargs[2] = args[2];
769         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
770     }
771     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
772         string[] memory dynargs = new string[](3);
773         dynargs[0] = args[0];
774         dynargs[1] = args[1];
775         dynargs[2] = args[2];
776         return oraclize_query(datasource, dynargs, gaslimit);
777     }
778 
779     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
780         string[] memory dynargs = new string[](4);
781         dynargs[0] = args[0];
782         dynargs[1] = args[1];
783         dynargs[2] = args[2];
784         dynargs[3] = args[3];
785         return oraclize_query(datasource, dynargs);
786     }
787     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
788         string[] memory dynargs = new string[](4);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         dynargs[2] = args[2];
792         dynargs[3] = args[3];
793         return oraclize_query(timestamp, datasource, dynargs);
794     }
795     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
796         string[] memory dynargs = new string[](4);
797         dynargs[0] = args[0];
798         dynargs[1] = args[1];
799         dynargs[2] = args[2];
800         dynargs[3] = args[3];
801         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
802     }
803     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
804         string[] memory dynargs = new string[](4);
805         dynargs[0] = args[0];
806         dynargs[1] = args[1];
807         dynargs[2] = args[2];
808         dynargs[3] = args[3];
809         return oraclize_query(datasource, dynargs, gaslimit);
810     }
811     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
812         string[] memory dynargs = new string[](5);
813         dynargs[0] = args[0];
814         dynargs[1] = args[1];
815         dynargs[2] = args[2];
816         dynargs[3] = args[3];
817         dynargs[4] = args[4];
818         return oraclize_query(datasource, dynargs);
819     }
820     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
821         string[] memory dynargs = new string[](5);
822         dynargs[0] = args[0];
823         dynargs[1] = args[1];
824         dynargs[2] = args[2];
825         dynargs[3] = args[3];
826         dynargs[4] = args[4];
827         return oraclize_query(timestamp, datasource, dynargs);
828     }
829     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
830         string[] memory dynargs = new string[](5);
831         dynargs[0] = args[0];
832         dynargs[1] = args[1];
833         dynargs[2] = args[2];
834         dynargs[3] = args[3];
835         dynargs[4] = args[4];
836         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
837     }
838     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
839         string[] memory dynargs = new string[](5);
840         dynargs[0] = args[0];
841         dynargs[1] = args[1];
842         dynargs[2] = args[2];
843         dynargs[3] = args[3];
844         dynargs[4] = args[4];
845         return oraclize_query(datasource, dynargs, gaslimit);
846     }
847     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
848         uint price = oraclize.getPrice(datasource);
849         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
850         bytes memory args = ba2cbor(argN);
851         return oraclize.queryN.value(price)(0, datasource, args);
852     }
853     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
854         uint price = oraclize.getPrice(datasource);
855         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
856         bytes memory args = ba2cbor(argN);
857         return oraclize.queryN.value(price)(timestamp, datasource, args);
858     }
859     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
860         uint price = oraclize.getPrice(datasource, gaslimit);
861         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
862         bytes memory args = ba2cbor(argN);
863         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
864     }
865     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
866         uint price = oraclize.getPrice(datasource, gaslimit);
867         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
868         bytes memory args = ba2cbor(argN);
869         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
870     }
871     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
872         bytes[] memory dynargs = new bytes[](1);
873         dynargs[0] = args[0];
874         return oraclize_query(datasource, dynargs);
875     }
876     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
877         bytes[] memory dynargs = new bytes[](1);
878         dynargs[0] = args[0];
879         return oraclize_query(timestamp, datasource, dynargs);
880     }
881     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
882         bytes[] memory dynargs = new bytes[](1);
883         dynargs[0] = args[0];
884         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
885     }
886     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
887         bytes[] memory dynargs = new bytes[](1);
888         dynargs[0] = args[0];
889         return oraclize_query(datasource, dynargs, gaslimit);
890     }
891 
892     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
893         bytes[] memory dynargs = new bytes[](2);
894         dynargs[0] = args[0];
895         dynargs[1] = args[1];
896         return oraclize_query(datasource, dynargs);
897     }
898     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
899         bytes[] memory dynargs = new bytes[](2);
900         dynargs[0] = args[0];
901         dynargs[1] = args[1];
902         return oraclize_query(timestamp, datasource, dynargs);
903     }
904     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
905         bytes[] memory dynargs = new bytes[](2);
906         dynargs[0] = args[0];
907         dynargs[1] = args[1];
908         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
909     }
910     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
911         bytes[] memory dynargs = new bytes[](2);
912         dynargs[0] = args[0];
913         dynargs[1] = args[1];
914         return oraclize_query(datasource, dynargs, gaslimit);
915     }
916     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
917         bytes[] memory dynargs = new bytes[](3);
918         dynargs[0] = args[0];
919         dynargs[1] = args[1];
920         dynargs[2] = args[2];
921         return oraclize_query(datasource, dynargs);
922     }
923     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
924         bytes[] memory dynargs = new bytes[](3);
925         dynargs[0] = args[0];
926         dynargs[1] = args[1];
927         dynargs[2] = args[2];
928         return oraclize_query(timestamp, datasource, dynargs);
929     }
930     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
931         bytes[] memory dynargs = new bytes[](3);
932         dynargs[0] = args[0];
933         dynargs[1] = args[1];
934         dynargs[2] = args[2];
935         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
936     }
937     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
938         bytes[] memory dynargs = new bytes[](3);
939         dynargs[0] = args[0];
940         dynargs[1] = args[1];
941         dynargs[2] = args[2];
942         return oraclize_query(datasource, dynargs, gaslimit);
943     }
944 
945     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
946         bytes[] memory dynargs = new bytes[](4);
947         dynargs[0] = args[0];
948         dynargs[1] = args[1];
949         dynargs[2] = args[2];
950         dynargs[3] = args[3];
951         return oraclize_query(datasource, dynargs);
952     }
953     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
954         bytes[] memory dynargs = new bytes[](4);
955         dynargs[0] = args[0];
956         dynargs[1] = args[1];
957         dynargs[2] = args[2];
958         dynargs[3] = args[3];
959         return oraclize_query(timestamp, datasource, dynargs);
960     }
961     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
962         bytes[] memory dynargs = new bytes[](4);
963         dynargs[0] = args[0];
964         dynargs[1] = args[1];
965         dynargs[2] = args[2];
966         dynargs[3] = args[3];
967         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
968     }
969     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
970         bytes[] memory dynargs = new bytes[](4);
971         dynargs[0] = args[0];
972         dynargs[1] = args[1];
973         dynargs[2] = args[2];
974         dynargs[3] = args[3];
975         return oraclize_query(datasource, dynargs, gaslimit);
976     }
977     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
978         bytes[] memory dynargs = new bytes[](5);
979         dynargs[0] = args[0];
980         dynargs[1] = args[1];
981         dynargs[2] = args[2];
982         dynargs[3] = args[3];
983         dynargs[4] = args[4];
984         return oraclize_query(datasource, dynargs);
985     }
986     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
987         bytes[] memory dynargs = new bytes[](5);
988         dynargs[0] = args[0];
989         dynargs[1] = args[1];
990         dynargs[2] = args[2];
991         dynargs[3] = args[3];
992         dynargs[4] = args[4];
993         return oraclize_query(timestamp, datasource, dynargs);
994     }
995     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
996         bytes[] memory dynargs = new bytes[](5);
997         dynargs[0] = args[0];
998         dynargs[1] = args[1];
999         dynargs[2] = args[2];
1000         dynargs[3] = args[3];
1001         dynargs[4] = args[4];
1002         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1003     }
1004     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1005         bytes[] memory dynargs = new bytes[](5);
1006         dynargs[0] = args[0];
1007         dynargs[1] = args[1];
1008         dynargs[2] = args[2];
1009         dynargs[3] = args[3];
1010         dynargs[4] = args[4];
1011         return oraclize_query(datasource, dynargs, gaslimit);
1012     }
1013 
1014     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1015         return oraclize.cbAddress();
1016     }
1017     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1018         return oraclize.setProofType(proofP);
1019     }
1020     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1021         return oraclize.setCustomGasPrice(gasPrice);
1022     }
1023 
1024     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1025         return oraclize.randomDS_getSessionPubKeyHash();
1026     }
1027 
1028     function getCodeSize(address _addr) view internal returns(uint _size) {
1029         assembly {
1030             _size := extcodesize(_addr)
1031         }
1032     }
1033 
1034     function parseAddr(string _a) internal pure returns (address){
1035         bytes memory tmp = bytes(_a);
1036         uint160 iaddr = 0;
1037         uint160 b1;
1038         uint160 b2;
1039         for (uint i=2; i<2+2*20; i+=2){
1040             iaddr *= 256;
1041             b1 = uint160(tmp[i]);
1042             b2 = uint160(tmp[i+1]);
1043             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1044             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1045             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1046             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1047             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1048             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1049             iaddr += (b1*16+b2);
1050         }
1051         return address(iaddr);
1052     }
1053 
1054     function strCompare(string _a, string _b) internal pure returns (int) {
1055         bytes memory a = bytes(_a);
1056         bytes memory b = bytes(_b);
1057         uint minLength = a.length;
1058         if (b.length < minLength) minLength = b.length;
1059         for (uint i = 0; i < minLength; i ++)
1060             if (a[i] < b[i])
1061                 return -1;
1062             else if (a[i] > b[i])
1063                 return 1;
1064         if (a.length < b.length)
1065             return -1;
1066         else if (a.length > b.length)
1067             return 1;
1068         else
1069             return 0;
1070     }
1071 
1072     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1073         bytes memory h = bytes(_haystack);
1074         bytes memory n = bytes(_needle);
1075         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1076             return -1;
1077         else if(h.length > (2**128 -1))
1078             return -1;
1079         else
1080         {
1081             uint subindex = 0;
1082             for (uint i = 0; i < h.length; i ++)
1083             {
1084                 if (h[i] == n[0])
1085                 {
1086                     subindex = 1;
1087                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1088                     {
1089                         subindex++;
1090                     }
1091                     if(subindex == n.length)
1092                         return int(i);
1093                 }
1094             }
1095             return -1;
1096         }
1097     }
1098 
1099     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1100         bytes memory _ba = bytes(_a);
1101         bytes memory _bb = bytes(_b);
1102         bytes memory _bc = bytes(_c);
1103         bytes memory _bd = bytes(_d);
1104         bytes memory _be = bytes(_e);
1105         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1106         bytes memory babcde = bytes(abcde);
1107         uint k = 0;
1108         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1109         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1110         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1111         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1112         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1113         return string(babcde);
1114     }
1115 
1116     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1117         return strConcat(_a, _b, _c, _d, "");
1118     }
1119 
1120     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1121         return strConcat(_a, _b, _c, "", "");
1122     }
1123 
1124     function strConcat(string _a, string _b) internal pure returns (string) {
1125         return strConcat(_a, _b, "", "", "");
1126     }
1127 
1128     // parseInt
1129     function parseInt(string _a) internal pure returns (uint) {
1130         return parseInt(_a, 0);
1131     }
1132 
1133     // parseInt(parseFloat*10^_b)
1134     function parseInt(string _a, uint _b) internal pure returns (uint) {
1135         bytes memory bresult = bytes(_a);
1136         uint mint = 0;
1137         bool decimals = false;
1138         for (uint i=0; i<bresult.length; i++){
1139             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1140                 if (decimals){
1141                    if (_b == 0) break;
1142                     else _b--;
1143                 }
1144                 mint *= 10;
1145                 mint += uint(bresult[i]) - 48;
1146             } else if (bresult[i] == 46) decimals = true;
1147         }
1148         if (_b > 0) mint *= 10**_b;
1149         return mint;
1150     }
1151 
1152     function uint2str(uint i) internal pure returns (string){
1153         if (i == 0) return "0";
1154         uint j = i;
1155         uint len;
1156         while (j != 0){
1157             len++;
1158             j /= 10;
1159         }
1160         bytes memory bstr = new bytes(len);
1161         uint k = len - 1;
1162         while (i != 0){
1163             bstr[k--] = byte(48 + i % 10);
1164             i /= 10;
1165         }
1166         return string(bstr);
1167     }
1168 
1169     using CBOR for Buffer.buffer;
1170     function stra2cbor(string[] arr) internal pure returns (bytes) {
1171         safeMemoryCleaner();
1172         Buffer.buffer memory buf;
1173         Buffer.init(buf, 1024);
1174         buf.startArray();
1175         for (uint i = 0; i < arr.length; i++) {
1176             buf.encodeString(arr[i]);
1177         }
1178         buf.endSequence();
1179         return buf.buf;
1180     }
1181 
1182     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1183         safeMemoryCleaner();
1184         Buffer.buffer memory buf;
1185         Buffer.init(buf, 1024);
1186         buf.startArray();
1187         for (uint i = 0; i < arr.length; i++) {
1188             buf.encodeBytes(arr[i]);
1189         }
1190         buf.endSequence();
1191         return buf.buf;
1192     }
1193 
1194     string oraclize_network_name;
1195     function oraclize_setNetworkName(string _network_name) internal {
1196         oraclize_network_name = _network_name;
1197     }
1198 
1199     function oraclize_getNetworkName() internal view returns (string) {
1200         return oraclize_network_name;
1201     }
1202 
1203     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1204         require((_nbytes > 0) && (_nbytes <= 32));
1205         // Convert from seconds to ledger timer ticks
1206         _delay *= 10;
1207         bytes memory nbytes = new bytes(1);
1208         nbytes[0] = byte(_nbytes);
1209         bytes memory unonce = new bytes(32);
1210         bytes memory sessionKeyHash = new bytes(32);
1211         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1212         assembly {
1213             mstore(unonce, 0x20)
1214             // the following variables can be relaxed
1215             // check relaxed random contract under ethereum-examples repo
1216             // for an idea on how to override and replace comit hash vars
1217             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1218             mstore(sessionKeyHash, 0x20)
1219             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1220         }
1221         bytes memory delay = new bytes(32);
1222         assembly {
1223             mstore(add(delay, 0x20), _delay)
1224         }
1225 
1226         bytes memory delay_bytes8 = new bytes(8);
1227         copyBytes(delay, 24, 8, delay_bytes8, 0);
1228 
1229         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1230         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1231 
1232         bytes memory delay_bytes8_left = new bytes(8);
1233 
1234         assembly {
1235             let x := mload(add(delay_bytes8, 0x20))
1236             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1237             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1238             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1239             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1240             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1241             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1242             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1243             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1244 
1245         }
1246 
1247         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1248         return queryId;
1249     }
1250 
1251     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1252         oraclize_randomDS_args[queryId] = commitment;
1253     }
1254 
1255     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1256     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1257 
1258     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1259         bool sigok;
1260         address signer;
1261 
1262         bytes32 sigr;
1263         bytes32 sigs;
1264 
1265         bytes memory sigr_ = new bytes(32);
1266         uint offset = 4+(uint(dersig[3]) - 0x20);
1267         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1268         bytes memory sigs_ = new bytes(32);
1269         offset += 32 + 2;
1270         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1271 
1272         assembly {
1273             sigr := mload(add(sigr_, 32))
1274             sigs := mload(add(sigs_, 32))
1275         }
1276 
1277 
1278         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1279         if (address(keccak256(pubkey)) == signer) return true;
1280         else {
1281             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1282             return (address(keccak256(pubkey)) == signer);
1283         }
1284     }
1285 
1286     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1287         bool sigok;
1288 
1289         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1290         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1291         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1292 
1293         bytes memory appkey1_pubkey = new bytes(64);
1294         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1295 
1296         bytes memory tosign2 = new bytes(1+65+32);
1297         tosign2[0] = byte(1); //role
1298         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1299         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1300         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1301         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1302 
1303         if (sigok == false) return false;
1304 
1305 
1306         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1307         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1308 
1309         bytes memory tosign3 = new bytes(1+65);
1310         tosign3[0] = 0xFE;
1311         copyBytes(proof, 3, 65, tosign3, 1);
1312 
1313         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1314         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1315 
1316         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1317 
1318         return sigok;
1319     }
1320 
1321     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1322         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1323         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1324 
1325         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1326         require(proofVerified);
1327 
1328         _;
1329     }
1330 
1331     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1332         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1333         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1334 
1335         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1336         if (proofVerified == false) return 2;
1337 
1338         return 0;
1339     }
1340 
1341     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1342         bool match_ = true;
1343 
1344         require(prefix.length == n_random_bytes);
1345 
1346         for (uint256 i=0; i< n_random_bytes; i++) {
1347             if (content[i] != prefix[i]) match_ = false;
1348         }
1349 
1350         return match_;
1351     }
1352 
1353     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1354 
1355         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1356         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1357         bytes memory keyhash = new bytes(32);
1358         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1359         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1360 
1361         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1362         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1363 
1364         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1365         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1366 
1367         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1368         // This is to verify that the computed args match with the ones specified in the query.
1369         bytes memory commitmentSlice1 = new bytes(8+1+32);
1370         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1371 
1372         bytes memory sessionPubkey = new bytes(64);
1373         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1374         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1375 
1376         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1377         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1378             delete oraclize_randomDS_args[queryId];
1379         } else return false;
1380 
1381 
1382         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1383         bytes memory tosign1 = new bytes(32+8+1+32);
1384         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1385         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1386 
1387         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1388         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1389             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1390         }
1391 
1392         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1393     }
1394 
1395     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1396     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1397         uint minLength = length + toOffset;
1398 
1399         // Buffer too small
1400         require(to.length >= minLength); // Should be a better way?
1401 
1402         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1403         uint i = 32 + fromOffset;
1404         uint j = 32 + toOffset;
1405 
1406         while (i < (32 + fromOffset + length)) {
1407             assembly {
1408                 let tmp := mload(add(from, i))
1409                 mstore(add(to, j), tmp)
1410             }
1411             i += 32;
1412             j += 32;
1413         }
1414 
1415         return to;
1416     }
1417 
1418     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1419     // Duplicate Solidity's ecrecover, but catching the CALL return value
1420     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1421         // We do our own memory management here. Solidity uses memory offset
1422         // 0x40 to store the current end of memory. We write past it (as
1423         // writes are memory extensions), but don't update the offset so
1424         // Solidity will reuse it. The memory used here is only needed for
1425         // this context.
1426 
1427         // FIXME: inline assembly can't access return values
1428         bool ret;
1429         address addr;
1430 
1431         assembly {
1432             let size := mload(0x40)
1433             mstore(size, hash)
1434             mstore(add(size, 32), v)
1435             mstore(add(size, 64), r)
1436             mstore(add(size, 96), s)
1437 
1438             // NOTE: we can reuse the request memory because we deal with
1439             //       the return code
1440             ret := call(3000, 1, 0, size, 128, size, 32)
1441             addr := mload(size)
1442         }
1443 
1444         return (ret, addr);
1445     }
1446 
1447     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1448     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1449         bytes32 r;
1450         bytes32 s;
1451         uint8 v;
1452 
1453         if (sig.length != 65)
1454           return (false, 0);
1455 
1456         // The signature format is a compact form of:
1457         //   {bytes32 r}{bytes32 s}{uint8 v}
1458         // Compact means, uint8 is not padded to 32 bytes.
1459         assembly {
1460             r := mload(add(sig, 32))
1461             s := mload(add(sig, 64))
1462 
1463             // Here we are loading the last 32 bytes. We exploit the fact that
1464             // 'mload' will pad with zeroes if we overread.
1465             // There is no 'mload8' to do this, but that would be nicer.
1466             v := byte(0, mload(add(sig, 96)))
1467 
1468             // Alternative solution:
1469             // 'byte' is not working due to the Solidity parser, so lets
1470             // use the second best option, 'and'
1471             // v := and(mload(add(sig, 65)), 255)
1472         }
1473 
1474         // albeit non-transactional signatures are not specified by the YP, one would expect it
1475         // to match the YP range of [27, 28]
1476         //
1477         // geth uses [0, 1] and some clients have followed. This might change, see:
1478         //  https://github.com/ethereum/go-ethereum/issues/2053
1479         if (v < 27)
1480           v += 27;
1481 
1482         if (v != 27 && v != 28)
1483             return (false, 0);
1484 
1485         return safer_ecrecover(hash, v, r, s);
1486     }
1487 
1488     function safeMemoryCleaner() internal pure {
1489         assembly {
1490             let fmem := mload(0x40)
1491             codecopy(fmem, codesize, sub(msize, fmem))
1492         }
1493     }
1494 
1495 }
1496 // </ORACLIZE_API>
1497 
1498 
1499 /// @title JSON provides JSON parsing functionality.
1500 contract JSON is usingOraclize{
1501     using strings for *;
1502 
1503     bytes32 constant private prefixHash = keccak256("{\"ETH\":");
1504 
1505     /// @dev Extracts JSON rate value from the response object.
1506     /// @param _json body of the JSON response from the CryptoCompare API.
1507     function parseRate(string _json) public pure returns (string) {
1508 
1509         uint json_len = abi.encodePacked(_json).length;
1510         //{"ETH":}.length = 8, assuming a (maximum of) 18 digit prevision
1511         require(json_len > 8 && json_len <= 28, "misformatted input");
1512 
1513         bytes memory jsonPrefix = new bytes(7);
1514         copyBytes(abi.encodePacked(_json), 0, 7, jsonPrefix, 0);
1515         require(keccak256(jsonPrefix) == prefixHash, "prefix mismatch");
1516 
1517         strings.slice memory body = _json.toSlice();
1518         body.split(":".toSlice()); //we are sure that ':' is included in the string, body now contains the rate+'}'
1519         json_len = body._len;
1520         body.until("}".toSlice());
1521         require(body._len == json_len-1,"not json format"); //ensure that the json is properly terminated with a '}'
1522         return body.toString();
1523 
1524     }
1525 }
1526 
1527 
1528 /**
1529  *  ParseIntScientific
1530  *  Copyright (C) 2018 The Contract Wallet Company Limited
1531  *
1532  *  This program is free software: you can redistribute it and/or modify
1533  *  it under the terms of the GNU General Public License as published by
1534  *  the Free Software Foundation, either version 3 of the License, or
1535  *  (at your option) any later version.
1536 
1537  *  This program is distributed in the hope that it will be useful,
1538  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1539  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1540  *  GNU General Public License for more details.
1541 
1542  *  You should have received a copy of the GNU General Public License
1543  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1544 */
1545 
1546 
1547 /// @title ParseIntScientific provides floating point in scientific notation (e.g. e-5) parsing functionality.
1548 contract ParseIntScientific {
1549 
1550     using SafeMath for uint256;
1551 
1552     byte constant private PLUS_ASCII = byte(43); //decimal value of '+'
1553     byte constant private DASH_ASCII = byte(45); //decimal value of '-'
1554     byte constant private DOT_ASCII = byte(46); //decimal value of '.'
1555     byte constant private ZERO_ASCII = byte(48); //decimal value of '0'
1556     byte constant private NINE_ASCII = byte(57); //decimal value of '9'
1557     byte constant private E_ASCII = byte(69); //decimal value of 'E'
1558     byte constant private e_ASCII = byte(101); //decimal value of 'e'
1559 
1560     /// @dev ParseIntScientific delegates the call to _parseIntScientific(string, uint) with the 2nd argument being 0.
1561     function _parseIntScientific(string _inString) internal pure returns (uint) {
1562         return _parseIntScientific(_inString, 0);
1563     }
1564 
1565     /// @dev ParseIntScientificWei parses a rate expressed in ETH and returns its wei denomination
1566     function _parseIntScientificWei(string _inString) internal pure returns (uint) {
1567         return _parseIntScientific(_inString, 18);
1568     }
1569 
1570     /// @dev ParseIntScientific parses a JSON standard - floating point number.
1571     /// @param _inString is input string.
1572     /// @param _magnitudeMult multiplies the number with 10^_magnitudeMult.
1573     function _parseIntScientific(string _inString, uint _magnitudeMult) internal pure returns (uint) {
1574 
1575         bytes memory inBytes = bytes(_inString);
1576         uint mint = 0; // the final uint returned
1577         uint mintDec = 0; // the uint following the decimal point
1578         uint mintExp = 0; // the exponent
1579         uint decMinted = 0; // how many decimals were 'minted'.
1580         uint expIndex = 0; // the position in the byte array that 'e' was found (if found)
1581         bool integral = false; // indicates the existence of the integral part, it should always exist (even if 0) e.g. 'e+1'  or '.1' is not valid
1582         bool decimals = false; // indicates a decimal number, set to true if '.' is found
1583         bool exp = false; // indicates if the number being parsed has an exponential representation
1584         bool minus = false; // indicated if the exponent is negative
1585         bool plus = false; // indicated if the exponent is positive
1586 
1587         for (uint i = 0; i < inBytes.length; i++) {
1588             if ((inBytes[i] >= ZERO_ASCII) && (inBytes[i] <= NINE_ASCII) && (!exp)) {
1589                 // 'e' not encountered yet, minting integer part or decimals
1590                 if (decimals) {
1591                     // '.' encountered
1592                     //use safeMath in case there is an overflow
1593                     mintDec = mintDec.mul(10);
1594                     mintDec = mintDec.add(uint(inBytes[i]) - uint(ZERO_ASCII));
1595                     decMinted++; //keep track of the #decimals
1596                 } else {
1597                     // integral part (before '.')
1598                     integral = true;
1599                     //use safeMath in case there is an overflow
1600                     mint = mint.mul(10);
1601                     mint = mint.add(uint(inBytes[i]) - uint(ZERO_ASCII));
1602                 }
1603             } else if ((inBytes[i] >= ZERO_ASCII) && (inBytes[i] <= NINE_ASCII) && (exp)) {
1604                 //exponential notation (e-/+) has been detected, mint the exponent
1605                 mintExp = mintExp.mul(10);
1606                 mintExp = mintExp.add(uint(inBytes[i]) - uint(ZERO_ASCII));
1607             } else if (inBytes[i] == DOT_ASCII) {
1608                 //an integral part before should always exist before '.'
1609                 require(integral, "missing integral part");
1610                 // an extra decimal point makes the format invalid
1611                 require(!decimals, "duplicate decimal point");
1612                 //the decimal point should always be before the exponent
1613                 require(!exp, "decimal after exponent");
1614                 decimals = true;
1615             } else if (inBytes[i] == DASH_ASCII) {
1616                 // an extra '-' should be considered an invalid character
1617                 require(!minus, "duplicate -");
1618                 require(!plus, "extra sign");
1619                 require(expIndex + 1 == i, "- sign not immediately after e");
1620                 minus = true;
1621             } else if (inBytes[i] == PLUS_ASCII) {
1622                 // an extra '+' should be considered an invalid character
1623                 require(!plus, "duplicate +");
1624                 require(!minus, "extra sign");
1625                 require(expIndex + 1 == i, "+ sign not immediately after e");
1626                 plus = true;
1627             } else if ((inBytes[i] == E_ASCII) || (inBytes[i] == e_ASCII)) {
1628                 //an integral part before should always exist before 'e'
1629                 require(integral, "missing integral part");
1630                 // an extra 'e' or 'E' should be considered an invalid character
1631                 require(!exp, "duplicate exponent symbol");
1632                 exp = true;
1633                 expIndex = i;
1634             } else {
1635                 revert("invalid digit");
1636             }
1637         }
1638 
1639         if (minus || plus) {
1640             // end of string e[x|-] without specifying the exponent
1641             require(i > expIndex + 2);
1642         } else if (exp) {
1643             // end of string (e) without specifying the exponent
1644             require(i > expIndex + 1);
1645         }
1646 
1647         if (minus) {
1648             // e^(-x)
1649             if (mintExp >= _magnitudeMult) {
1650                 // the (negative) exponent is bigger than the given parameter for "shifting left".
1651                 // use integer division to reduce the precision.
1652                 require(mintExp - _magnitudeMult < 78, "exponent > 77"); //
1653                 mint /= 10 ** (mintExp - _magnitudeMult);
1654                 return mint;
1655 
1656             } else {
1657                 // the (negative) exponent is smaller than the given parameter for "shifting left".
1658                 //no need for underflow check
1659                 _magnitudeMult = _magnitudeMult - mintExp;
1660             }
1661         } else {
1662             // e^(+x), positive exponent or no exponent
1663             // just shift left as many times as indicated by the exponent and the shift parameter
1664             _magnitudeMult = _magnitudeMult.add(mintExp);
1665           }
1666 
1667           if (_magnitudeMult >= decMinted) {
1668               // the decimals are fewer or equal than the shifts: use all of them
1669               // shift number and add the decimals at the end
1670               // include decimals if present in the original input
1671               require(decMinted < 78, "more than 77 decimal digits parsed"); //
1672               mint = mint.mul(10 ** (decMinted));
1673               mint = mint.add(mintDec);
1674               //// add zeros at the end if the decimals were fewer than #_magnitudeMult
1675               require(_magnitudeMult - decMinted < 78, "exponent > 77"); //
1676               mint = mint.mul(10 ** (_magnitudeMult - decMinted));
1677           } else {
1678               // the decimals are more than the #_magnitudeMult shifts
1679               // use only the ones needed, discard the rest
1680               decMinted -= _magnitudeMult;
1681               require(decMinted < 78, "more than 77 decimal digits parsed"); //
1682               mintDec /= 10 ** (decMinted);
1683               // shift number and add the decimals at the end
1684               require(_magnitudeMult < 78, "more than 77 decimal digits parsed"); //
1685               mint = mint.mul(10 ** (_magnitudeMult));
1686               mint = mint.add(mintDec);
1687           }
1688 
1689         return mint;
1690     }
1691 }
1692 
1693 
1694 /*
1695  * Copyright 2016 Nick Johnson
1696  *
1697  * Licensed under the Apache License, Version 2.0 (the "License");
1698  * you may not use this file except in compliance with the License.
1699  * You may obtain a copy of the License at
1700  *
1701  *     http://www.apache.org/licenses/LICENSE-2.0
1702  *
1703  * Unless required by applicable law or agreed to in writing, software
1704  * distributed under the License is distributed on an "AS IS" BASIS,
1705  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1706  * See the License for the specific language governing permissions and
1707  * limitations under the License.
1708  */
1709 
1710 /*
1711  * @title String & slice utility library for Solidity contracts.
1712  * @author Nick Johnson <arachnid@notdot.net>
1713  *
1714  * @dev Functionality in this library is largely implemented using an
1715  *      abstraction called a 'slice'. A slice represents a part of a string -
1716  *      anything from the entire string to a single character, or even no
1717  *      characters at all (a 0-length slice). Since a slice only has to specify
1718  *      an offset and a length, copying and manipulating slices is a lot less
1719  *      expensive than copying and manipulating the strings they reference.
1720  *
1721  *      To further reduce gas costs, most functions on slice that need to return
1722  *      a slice modify the original one instead of allocating a new one; for
1723  *      instance, `s.split(".")` will return the text up to the first '.',
1724  *      modifying s to only contain the remainder of the string after the '.'.
1725  *      In situations where you do not want to modify the original slice, you
1726  *      can make a copy first with `.copy()`, for example:
1727  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1728  *      Solidity has no memory management, it will result in allocating many
1729  *      short-lived slices that are later discarded.
1730  *
1731  *      Functions that return two slices come in two versions: a non-allocating
1732  *      version that takes the second slice as an argument, modifying it in
1733  *      place, and an allocating version that allocates and returns the second
1734  *      slice; see `nextRune` for example.
1735  *
1736  *      Functions that have to copy string data will return strings rather than
1737  *      slices; these can be cast back to slices for further processing if
1738  *      required.
1739  *
1740  *      For convenience, some functions are provided with non-modifying
1741  *      variants that create a new slice and return both; for instance,
1742  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1743  *      corresponding to the left and right parts of the string.
1744  */
1745 
1746 library strings {
1747     struct slice {
1748         uint _len;
1749         uint _ptr;
1750     }
1751 
1752     function memcpy(uint dest, uint src, uint len) private pure {
1753         // Copy word-length chunks while possible
1754         for(; len >= 32; len -= 32) {
1755             assembly {
1756                 mstore(dest, mload(src))
1757             }
1758             dest += 32;
1759             src += 32;
1760         }
1761 
1762         // Copy remaining bytes
1763         uint mask = 256 ** (32 - len) - 1;
1764         assembly {
1765             let srcpart := and(mload(src), not(mask))
1766             let destpart := and(mload(dest), mask)
1767             mstore(dest, or(destpart, srcpart))
1768         }
1769     }
1770 
1771     /*
1772      * @dev Returns a slice containing the entire string.
1773      * @param self The string to make a slice from.
1774      * @return A newly allocated slice containing the entire string.
1775      */
1776     function toSlice(string memory self) internal pure returns (slice memory) {
1777         uint ptr;
1778         assembly {
1779             ptr := add(self, 0x20)
1780         }
1781         return slice(bytes(self).length, ptr);
1782     }
1783 
1784     /*
1785      * @dev Returns the length of a null-terminated bytes32 string.
1786      * @param self The value to find the length of.
1787      * @return The length of the string, from 0 to 32.
1788      */
1789     function len(bytes32 self) internal pure returns (uint) {
1790         uint ret;
1791         if (self == 0)
1792             return 0;
1793         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1794             ret += 16;
1795             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1796         }
1797         if (self & 0xffffffffffffffff == 0) {
1798             ret += 8;
1799             self = bytes32(uint(self) / 0x10000000000000000);
1800         }
1801         if (self & 0xffffffff == 0) {
1802             ret += 4;
1803             self = bytes32(uint(self) / 0x100000000);
1804         }
1805         if (self & 0xffff == 0) {
1806             ret += 2;
1807             self = bytes32(uint(self) / 0x10000);
1808         }
1809         if (self & 0xff == 0) {
1810             ret += 1;
1811         }
1812         return 32 - ret;
1813     }
1814 
1815     /*
1816      * @dev Returns a slice containing the entire bytes32, interpreted as a
1817      *      null-terminated utf-8 string.
1818      * @param self The bytes32 value to convert to a slice.
1819      * @return A new slice containing the value of the input argument up to the
1820      *         first null.
1821      */
1822     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1823         // Allocate space for `self` in memory, copy it there, and point ret at it
1824         assembly {
1825             let ptr := mload(0x40)
1826             mstore(0x40, add(ptr, 0x20))
1827             mstore(ptr, self)
1828             mstore(add(ret, 0x20), ptr)
1829         }
1830         ret._len = len(self);
1831     }
1832 
1833     /*
1834      * @dev Returns a new slice containing the same data as the current slice.
1835      * @param self The slice to copy.
1836      * @return A new slice containing the same data as `self`.
1837      */
1838     function copy(slice memory self) internal pure returns (slice memory) {
1839         return slice(self._len, self._ptr);
1840     }
1841 
1842     /*
1843      * @dev Copies a slice to a new string.
1844      * @param self The slice to copy.
1845      * @return A newly allocated string containing the slice's text.
1846      */
1847     function toString(slice memory self) internal pure returns (string memory) {
1848         string memory ret = new string(self._len);
1849         uint retptr;
1850         assembly { retptr := add(ret, 32) }
1851 
1852         memcpy(retptr, self._ptr, self._len);
1853         return ret;
1854     }
1855 
1856     /*
1857      * @dev Returns the length in runes of the slice. Note that this operation
1858      *      takes time proportional to the length of the slice; avoid using it
1859      *      in loops, and call `slice.empty()` if you only need to know whether
1860      *      the slice is empty or not.
1861      * @param self The slice to operate on.
1862      * @return The length of the slice in runes.
1863      */
1864     function len(slice memory self) internal pure returns (uint l) {
1865         // Starting at ptr-31 means the LSB will be the byte we care about
1866         uint ptr = self._ptr - 31;
1867         uint end = ptr + self._len;
1868         for (l = 0; ptr < end; l++) {
1869             uint8 b;
1870             assembly { b := and(mload(ptr), 0xFF) }
1871             if (b < 0x80) {
1872                 ptr += 1;
1873             } else if(b < 0xE0) {
1874                 ptr += 2;
1875             } else if(b < 0xF0) {
1876                 ptr += 3;
1877             } else if(b < 0xF8) {
1878                 ptr += 4;
1879             } else if(b < 0xFC) {
1880                 ptr += 5;
1881             } else {
1882                 ptr += 6;
1883             }
1884         }
1885     }
1886 
1887     /*
1888      * @dev Returns true if the slice is empty (has a length of 0).
1889      * @param self The slice to operate on.
1890      * @return True if the slice is empty, False otherwise.
1891      */
1892     function empty(slice memory self) internal pure returns (bool) {
1893         return self._len == 0;
1894     }
1895 
1896     /*
1897      * @dev Returns a positive number if `other` comes lexicographically after
1898      *      `self`, a negative number if it comes before, or zero if the
1899      *      contents of the two slices are equal. Comparison is done per-rune,
1900      *      on unicode codepoints.
1901      * @param self The first slice to compare.
1902      * @param other The second slice to compare.
1903      * @return The result of the comparison.
1904      */
1905     function compare(slice memory self, slice memory other) internal pure returns (int) {
1906         uint shortest = self._len;
1907         if (other._len < self._len)
1908             shortest = other._len;
1909 
1910         uint selfptr = self._ptr;
1911         uint otherptr = other._ptr;
1912         for (uint idx = 0; idx < shortest; idx += 32) {
1913             uint a;
1914             uint b;
1915             assembly {
1916                 a := mload(selfptr)
1917                 b := mload(otherptr)
1918             }
1919             if (a != b) {
1920                 // Mask out irrelevant bytes and check again
1921                 uint256 mask = uint256(-1); // 0xffff...
1922                 if(shortest < 32) {
1923                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1924                 }
1925                 uint256 diff = (a & mask) - (b & mask);
1926                 if (diff != 0)
1927                     return int(diff);
1928             }
1929             selfptr += 32;
1930             otherptr += 32;
1931         }
1932         return int(self._len) - int(other._len);
1933     }
1934 
1935     /*
1936      * @dev Returns true if the two slices contain the same text.
1937      * @param self The first slice to compare.
1938      * @param self The second slice to compare.
1939      * @return True if the slices are equal, false otherwise.
1940      */
1941     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1942         return compare(self, other) == 0;
1943     }
1944 
1945     /*
1946      * @dev Extracts the first rune in the slice into `rune`, advancing the
1947      *      slice to point to the next rune and returning `self`.
1948      * @param self The slice to operate on.
1949      * @param rune The slice that will contain the first rune.
1950      * @return `rune`.
1951      */
1952     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1953         rune._ptr = self._ptr;
1954 
1955         if (self._len == 0) {
1956             rune._len = 0;
1957             return rune;
1958         }
1959 
1960         uint l;
1961         uint b;
1962         // Load the first byte of the rune into the LSBs of b
1963         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1964         if (b < 0x80) {
1965             l = 1;
1966         } else if(b < 0xE0) {
1967             l = 2;
1968         } else if(b < 0xF0) {
1969             l = 3;
1970         } else {
1971             l = 4;
1972         }
1973 
1974         // Check for truncated codepoints
1975         if (l > self._len) {
1976             rune._len = self._len;
1977             self._ptr += self._len;
1978             self._len = 0;
1979             return rune;
1980         }
1981 
1982         self._ptr += l;
1983         self._len -= l;
1984         rune._len = l;
1985         return rune;
1986     }
1987 
1988     /*
1989      * @dev Returns the first rune in the slice, advancing the slice to point
1990      *      to the next rune.
1991      * @param self The slice to operate on.
1992      * @return A slice containing only the first rune from `self`.
1993      */
1994     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1995         nextRune(self, ret);
1996     }
1997 
1998     /*
1999      * @dev Returns the number of the first codepoint in the slice.
2000      * @param self The slice to operate on.
2001      * @return The number of the first codepoint in the slice.
2002      */
2003     function ord(slice memory self) internal pure returns (uint ret) {
2004         if (self._len == 0) {
2005             return 0;
2006         }
2007 
2008         uint word;
2009         uint length;
2010         uint divisor = 2 ** 248;
2011 
2012         // Load the rune into the MSBs of b
2013         assembly { word:= mload(mload(add(self, 32))) }
2014         uint b = word / divisor;
2015         if (b < 0x80) {
2016             ret = b;
2017             length = 1;
2018         } else if(b < 0xE0) {
2019             ret = b & 0x1F;
2020             length = 2;
2021         } else if(b < 0xF0) {
2022             ret = b & 0x0F;
2023             length = 3;
2024         } else {
2025             ret = b & 0x07;
2026             length = 4;
2027         }
2028 
2029         // Check for truncated codepoints
2030         if (length > self._len) {
2031             return 0;
2032         }
2033 
2034         for (uint i = 1; i < length; i++) {
2035             divisor = divisor / 256;
2036             b = (word / divisor) & 0xFF;
2037             if (b & 0xC0 != 0x80) {
2038                 // Invalid UTF-8 sequence
2039                 return 0;
2040             }
2041             ret = (ret * 64) | (b & 0x3F);
2042         }
2043 
2044         return ret;
2045     }
2046 
2047     /*
2048      * @dev Returns the keccak-256 hash of the slice.
2049      * @param self The slice to hash.
2050      * @return The hash of the slice.
2051      */
2052     function keccak(slice memory self) internal pure returns (bytes32 ret) {
2053         assembly {
2054             ret := keccak256(mload(add(self, 32)), mload(self))
2055         }
2056     }
2057 
2058     /*
2059      * @dev Returns true if `self` starts with `needle`.
2060      * @param self The slice to operate on.
2061      * @param needle The slice to search for.
2062      * @return True if the slice starts with the provided text, false otherwise.
2063      */
2064     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2065         if (self._len < needle._len) {
2066             return false;
2067         }
2068 
2069         if (self._ptr == needle._ptr) {
2070             return true;
2071         }
2072 
2073         bool equal;
2074         assembly {
2075             let length := mload(needle)
2076             let selfptr := mload(add(self, 0x20))
2077             let needleptr := mload(add(needle, 0x20))
2078             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2079         }
2080         return equal;
2081     }
2082 
2083     /*
2084      * @dev If `self` starts with `needle`, `needle` is removed from the
2085      *      beginning of `self`. Otherwise, `self` is unmodified.
2086      * @param self The slice to operate on.
2087      * @param needle The slice to search for.
2088      * @return `self`
2089      */
2090     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
2091         if (self._len < needle._len) {
2092             return self;
2093         }
2094 
2095         bool equal = true;
2096         if (self._ptr != needle._ptr) {
2097             assembly {
2098                 let length := mload(needle)
2099                 let selfptr := mload(add(self, 0x20))
2100                 let needleptr := mload(add(needle, 0x20))
2101                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2102             }
2103         }
2104 
2105         if (equal) {
2106             self._len -= needle._len;
2107             self._ptr += needle._len;
2108         }
2109 
2110         return self;
2111     }
2112 
2113     /*
2114      * @dev Returns true if the slice ends with `needle`.
2115      * @param self The slice to operate on.
2116      * @param needle The slice to search for.
2117      * @return True if the slice starts with the provided text, false otherwise.
2118      */
2119     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2120         if (self._len < needle._len) {
2121             return false;
2122         }
2123 
2124         uint selfptr = self._ptr + self._len - needle._len;
2125 
2126         if (selfptr == needle._ptr) {
2127             return true;
2128         }
2129 
2130         bool equal;
2131         assembly {
2132             let length := mload(needle)
2133             let needleptr := mload(add(needle, 0x20))
2134             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2135         }
2136 
2137         return equal;
2138     }
2139 
2140     /*
2141      * @dev If `self` ends with `needle`, `needle` is removed from the
2142      *      end of `self`. Otherwise, `self` is unmodified.
2143      * @param self The slice to operate on.
2144      * @param needle The slice to search for.
2145      * @return `self`
2146      */
2147     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
2148         if (self._len < needle._len) {
2149             return self;
2150         }
2151 
2152         uint selfptr = self._ptr + self._len - needle._len;
2153         bool equal = true;
2154         if (selfptr != needle._ptr) {
2155             assembly {
2156                 let length := mload(needle)
2157                 let needleptr := mload(add(needle, 0x20))
2158                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2159             }
2160         }
2161 
2162         if (equal) {
2163             self._len -= needle._len;
2164         }
2165 
2166         return self;
2167     }
2168 
2169     // Returns the memory address of the first byte of the first occurrence of
2170     // `needle` in `self`, or the first byte after `self` if not found.
2171     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2172         uint ptr = selfptr;
2173         uint idx;
2174 
2175         if (needlelen <= selflen) {
2176             if (needlelen <= 32) {
2177                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2178 
2179                 bytes32 needledata;
2180                 assembly { needledata := and(mload(needleptr), mask) }
2181 
2182                 uint end = selfptr + selflen - needlelen;
2183                 bytes32 ptrdata;
2184                 assembly { ptrdata := and(mload(ptr), mask) }
2185 
2186                 while (ptrdata != needledata) {
2187                     if (ptr >= end)
2188                         return selfptr + selflen;
2189                     ptr++;
2190                     assembly { ptrdata := and(mload(ptr), mask) }
2191                 }
2192                 return ptr;
2193             } else {
2194                 // For long needles, use hashing
2195                 bytes32 hash;
2196                 assembly { hash := keccak256(needleptr, needlelen) }
2197 
2198                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2199                     bytes32 testHash;
2200                     assembly { testHash := keccak256(ptr, needlelen) }
2201                     if (hash == testHash)
2202                         return ptr;
2203                     ptr += 1;
2204                 }
2205             }
2206         }
2207         return selfptr + selflen;
2208     }
2209 
2210     // Returns the memory address of the first byte after the last occurrence of
2211     // `needle` in `self`, or the address of `self` if not found.
2212     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2213         uint ptr;
2214 
2215         if (needlelen <= selflen) {
2216             if (needlelen <= 32) {
2217                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2218 
2219                 bytes32 needledata;
2220                 assembly { needledata := and(mload(needleptr), mask) }
2221 
2222                 ptr = selfptr + selflen - needlelen;
2223                 bytes32 ptrdata;
2224                 assembly { ptrdata := and(mload(ptr), mask) }
2225 
2226                 while (ptrdata != needledata) {
2227                     if (ptr <= selfptr)
2228                         return selfptr;
2229                     ptr--;
2230                     assembly { ptrdata := and(mload(ptr), mask) }
2231                 }
2232                 return ptr + needlelen;
2233             } else {
2234                 // For long needles, use hashing
2235                 bytes32 hash;
2236                 assembly { hash := keccak256(needleptr, needlelen) }
2237                 ptr = selfptr + (selflen - needlelen);
2238                 while (ptr >= selfptr) {
2239                     bytes32 testHash;
2240                     assembly { testHash := keccak256(ptr, needlelen) }
2241                     if (hash == testHash)
2242                         return ptr + needlelen;
2243                     ptr -= 1;
2244                 }
2245             }
2246         }
2247         return selfptr;
2248     }
2249 
2250     /*
2251      * @dev Modifies `self` to contain everything from the first occurrence of
2252      *      `needle` to the end of the slice. `self` is set to the empty slice
2253      *      if `needle` is not found.
2254      * @param self The slice to search and modify.
2255      * @param needle The text to search for.
2256      * @return `self`.
2257      */
2258     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
2259         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2260         self._len -= ptr - self._ptr;
2261         self._ptr = ptr;
2262         return self;
2263     }
2264 
2265     /*
2266      * @dev Modifies `self` to contain the part of the string from the start of
2267      *      `self` to the end of the first occurrence of `needle`. If `needle`
2268      *      is not found, `self` is set to the empty slice.
2269      * @param self The slice to search and modify.
2270      * @param needle The text to search for.
2271      * @return `self`.
2272      */
2273     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
2274         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2275         self._len = ptr - self._ptr;
2276         return self;
2277     }
2278 
2279     /*
2280      * @dev Splits the slice, setting `self` to everything after the first
2281      *      occurrence of `needle`, and `token` to everything before it. If
2282      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2283      *      and `token` is set to the entirety of `self`.
2284      * @param self The slice to split.
2285      * @param needle The text to search for in `self`.
2286      * @param token An output parameter to which the first token is written.
2287      * @return `token`.
2288      */
2289     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2290         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2291         token._ptr = self._ptr;
2292         token._len = ptr - self._ptr;
2293         if (ptr == self._ptr + self._len) {
2294             // Not found
2295             self._len = 0;
2296         } else {
2297             self._len -= token._len + needle._len;
2298             self._ptr = ptr + needle._len;
2299         }
2300         return token;
2301     }
2302 
2303     /*
2304      * @dev Splits the slice, setting `self` to everything after the first
2305      *      occurrence of `needle`, and returning everything before it. If
2306      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2307      *      and the entirety of `self` is returned.
2308      * @param self The slice to split.
2309      * @param needle The text to search for in `self`.
2310      * @return The part of `self` up to the first occurrence of `delim`.
2311      */
2312     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2313         split(self, needle, token);
2314     }
2315 
2316     /*
2317      * @dev Splits the slice, setting `self` to everything before the last
2318      *      occurrence of `needle`, and `token` to everything after it. If
2319      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2320      *      and `token` is set to the entirety of `self`.
2321      * @param self The slice to split.
2322      * @param needle The text to search for in `self`.
2323      * @param token An output parameter to which the first token is written.
2324      * @return `token`.
2325      */
2326     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2327         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2328         token._ptr = ptr;
2329         token._len = self._len - (ptr - self._ptr);
2330         if (ptr == self._ptr) {
2331             // Not found
2332             self._len = 0;
2333         } else {
2334             self._len -= token._len + needle._len;
2335         }
2336         return token;
2337     }
2338 
2339     /*
2340      * @dev Splits the slice, setting `self` to everything before the last
2341      *      occurrence of `needle`, and returning everything after it. If
2342      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2343      *      and the entirety of `self` is returned.
2344      * @param self The slice to split.
2345      * @param needle The text to search for in `self`.
2346      * @return The part of `self` after the last occurrence of `delim`.
2347      */
2348     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2349         rsplit(self, needle, token);
2350     }
2351 
2352     /*
2353      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2354      * @param self The slice to search.
2355      * @param needle The text to search for in `self`.
2356      * @return The number of occurrences of `needle` found in `self`.
2357      */
2358     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
2359         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2360         while (ptr <= self._ptr + self._len) {
2361             cnt++;
2362             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2363         }
2364     }
2365 
2366     /*
2367      * @dev Returns True if `self` contains `needle`.
2368      * @param self The slice to search.
2369      * @param needle The text to search for in `self`.
2370      * @return True if `needle` is found in `self`, false otherwise.
2371      */
2372     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
2373         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2374     }
2375 
2376     /*
2377      * @dev Returns a newly allocated string containing the concatenation of
2378      *      `self` and `other`.
2379      * @param self The first slice to concatenate.
2380      * @param other The second slice to concatenate.
2381      * @return The concatenation of the two strings.
2382      */
2383     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
2384         string memory ret = new string(self._len + other._len);
2385         uint retptr;
2386         assembly { retptr := add(ret, 32) }
2387         memcpy(retptr, self._ptr, self._len);
2388         memcpy(retptr + self._len, other._ptr, other._len);
2389         return ret;
2390     }
2391 
2392     /*
2393      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2394      *      newly allocated string.
2395      * @param self The delimiter to use.
2396      * @param parts A list of slices to join.
2397      * @return A newly allocated string containing all the slices in `parts`,
2398      *         joined with `self`.
2399      */
2400     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
2401         if (parts.length == 0)
2402             return "";
2403 
2404         uint length = self._len * (parts.length - 1);
2405         for(uint i = 0; i < parts.length; i++)
2406             length += parts[i]._len;
2407 
2408         string memory ret = new string(length);
2409         uint retptr;
2410         assembly { retptr := add(ret, 32) }
2411 
2412         for(i = 0; i < parts.length; i++) {
2413             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2414             retptr += parts[i]._len;
2415             if (i < parts.length - 1) {
2416                 memcpy(retptr, self._ptr, self._len);
2417                 retptr += self._len;
2418             }
2419         }
2420 
2421         return ret;
2422     }
2423 }
2424 
2425 
2426 /**
2427  * The MIT License (MIT)
2428  *
2429  * Copyright (c) 2016 Smart Contract Solutions, Inc.
2430  *
2431  * Permission is hereby granted, free of charge, to any person obtaining
2432  * a copy of this software and associated documentation files (the
2433  * "Software"), to deal in the Software without restriction, including
2434  * without limitation the rights to use, copy, modify, merge, publish,
2435  * distribute, sublicense, and/or sell copies of the Software, and to
2436  * permit persons to whom the Software is furnished to do so, subject to
2437  * the following conditions:
2438  *
2439  * The above copyright notice and this permission notice shall be included
2440  * in all copies or substantial portions of the Software.
2441  *
2442  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
2443  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
2444  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
2445  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
2446  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
2447  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
2448  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
2449  */
2450 
2451 
2452 /**
2453  * @title SafeMath
2454  * @dev Math operations with safety checks that revert on error
2455  */
2456 library SafeMath {
2457 
2458   /**
2459   * @dev Multiplies two numbers, reverts on overflow.
2460   */
2461   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2462     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2463     // benefit is lost if 'b' is also tested.
2464     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2465     if (a == 0) {
2466       return 0;
2467     }
2468 
2469     uint256 c = a * b;
2470     require(c / a == b);
2471 
2472     return c;
2473   }
2474 
2475   /**
2476   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2477   */
2478   function div(uint256 a, uint256 b) internal pure returns (uint256) {
2479     require(b > 0); // Solidity only automatically asserts when dividing by 0
2480     uint256 c = a / b;
2481     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2482 
2483     return c;
2484   }
2485 
2486   /**
2487   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2488   */
2489   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2490     require(b <= a);
2491     uint256 c = a - b;
2492 
2493     return c;
2494   }
2495 
2496   /**
2497   * @dev Adds two numbers, reverts on overflow.
2498   */
2499   function add(uint256 a, uint256 b) internal pure returns (uint256) {
2500     uint256 c = a + b;
2501     require(c >= a);
2502 
2503     return c;
2504   }
2505 
2506   /**
2507   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2508   * reverts when dividing by zero.
2509   */
2510   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2511     require(b != 0);
2512     return a % b;
2513   }
2514 }
2515 
2516 
2517 
2518 /**
2519  * This method was modified from the GPLv3 solidity code found in this repository
2520  * https://github.com/vcealicu/melonport-price-feed/blob/master/pricefeed/PriceFeed.sol
2521  */
2522 
2523 /// @title Base64 provides base 64 decoding functionality.
2524 contract Base64 {
2525     bytes constant BASE64_DECODE_CHAR = hex"000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e003e003f3435363738393a3b3c3d00000000000000000102030405060708090a0b0c0d0e0f10111213141516171819000000003f001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f30313233";
2526 
2527     /// @return decoded array of bytes.
2528     /// @param _encoded base 64 encoded array of bytes.
2529     function _base64decode(bytes _encoded) internal pure returns (bytes) {
2530         byte v1;
2531         byte v2;
2532         byte v3;
2533         byte v4;
2534         uint length = _encoded.length;
2535         bytes memory result = new bytes(length);
2536         uint index;
2537 
2538         // base64 encoded strings can't be length 0 and they must be divisble by 4
2539         require(length > 0  && length % 4 == 0, "invalid base64 encoding");
2540 
2541           if (keccak256(abi.encodePacked(_encoded[length - 2])) == keccak256("=")) {
2542               length -= 2;
2543           } else if (keccak256(abi.encodePacked(_encoded[length - 1])) == keccak256("=")) {
2544               length -= 1;
2545           }
2546           uint count = length >> 2 << 2;
2547           for (uint i = 0; i < count;) {
2548               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2549               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2550               v3 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2551               v4 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2552 
2553               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2554               result[index++] = (v2 << 4 | v3 >> 2) & 255;
2555               result[index++] = (v3 << 6 | v4) & 255;
2556           }
2557           if (length - count == 2) {
2558               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2559               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2560               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2561           } else if (length - count == 3) {
2562               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2563               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2564               v3 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2565 
2566               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2567               result[index++] = (v2 << 4 | v3 >> 2) & 255;
2568           }
2569 
2570         // Set to correct length.
2571         assembly {
2572             mstore(result, index)
2573         }
2574 
2575         return result;
2576     }
2577 }
2578 
2579 
2580 
2581 /// @title Oracle converts ERC20 token amounts into equivalent ether amounts based on cryptocurrency exchange rates.
2582 interface IOracle {
2583     function convert(address, uint) external view returns (bool, uint);
2584 }
2585 
2586 
2587 /// @title Oracle provides asset exchange rates and conversion functionality.
2588 contract Oracle is usingOraclize, Base64, Date, JSON, Controllable, ParseIntScientific, IOracle {
2589     using strings for *;
2590     using SafeMath for uint256;
2591 
2592 
2593     /*******************/
2594     /*     Events     */
2595     /*****************/
2596 
2597     event AddedToken(address _sender, address _token, string _symbol, uint _magnitude);
2598     event RemovedToken(address _sender, address _token);
2599     event UpdatedTokenRate(address _sender, address _token, uint _rate);
2600 
2601     event SetGasPrice(address _sender, uint _gasPrice);
2602     event Converted(address _sender, address _token, uint _amount, uint _ether);
2603 
2604     event RequestedUpdate(string _symbol);
2605     event FailedUpdateRequest(string _reason);
2606 
2607     event VerifiedProof(bytes _publicKey, string _result);
2608 
2609     event SetCryptoComparePublicKey(address _sender, bytes _publicKey);
2610 
2611     /**********************/
2612     /*     Constants     */
2613     /********************/
2614 
2615     uint constant private PROOF_LEN = 165;
2616     uint constant private ECDSA_SIG_LEN = 65;
2617     uint constant private ENCODING_BYTES = 2;
2618     uint constant private HEADERS_LEN = PROOF_LEN - 2 * ENCODING_BYTES - ECDSA_SIG_LEN; // 2 bytes encoding headers length + 2 for signature.
2619     uint constant private DIGEST_BASE64_LEN = 44; //base64 encoding of the SHA256 hash (32-bytes) of the result: fixed length.
2620     uint constant private DIGEST_OFFSET = HEADERS_LEN - DIGEST_BASE64_LEN; // the starting position of the result hash in the headers string.
2621 
2622     uint constant private MAX_BYTE_SIZE = 256; //for calculating length encoding
2623 
2624     struct Token {
2625         string symbol;    // Token symbol
2626         uint magnitude;   // 10^decimals
2627         uint rate;        // Token exchange rate in wei
2628         uint lastUpdate;  // Time of the last rate update
2629         bool exists;      // Flags if the struct is empty or not
2630     }
2631 
2632     mapping(address => Token) public tokens;
2633     address[] private _tokenAddresses;
2634 
2635     bytes public APIPublicKey;
2636     mapping(bytes32 => address) private _queryToToken;
2637 
2638     /// @dev Construct the oracle with multiple controllers, address resolver and custom gas price.
2639     /// @dev _resolver is the oraclize address resolver contract address.
2640     /// @param _ens is the address of the ENS.
2641     /// @param _controllerName is the ENS name of the Controller.
2642     constructor(address _resolver, address _ens, bytes32 _controllerName) Controllable(_ens, _controllerName) public {
2643         APIPublicKey = hex"a0f4f688350018ad1b9785991c0bde5f704b005dc79972b114dbed4a615a983710bfc647ebe5a320daa28771dce6a2d104f5efa2e4a85ba3760b76d46f8571ca";
2644         OAR = OraclizeAddrResolverI(_resolver);
2645         oraclize_setCustomGasPrice(10000000000);
2646         oraclize_setProof(proofType_Native);
2647     }
2648 
2649     /// @dev Updates the Crypto Compare public API key.
2650     function updateAPIPublicKey(bytes _publicKey) external onlyController {
2651         APIPublicKey = _publicKey;
2652         emit SetCryptoComparePublicKey(msg.sender, _publicKey);
2653     }
2654 
2655     /// @dev Sets the gas price used by oraclize query.
2656     function setCustomGasPrice(uint _gasPrice) external onlyController {
2657         oraclize_setCustomGasPrice(_gasPrice);
2658         emit SetGasPrice(msg.sender, _gasPrice);
2659     }
2660 
2661     /// @dev Convert ERC20 token amount to the corresponding ether amount (used by the wallet contract).
2662     /// @param _token ERC20 token contract address.
2663     /// @param _amount amount of token in base units.
2664     function convert(address _token, uint _amount) external view returns (bool, uint) {
2665         // Store the token in memory to save map entry lookup gas.
2666         Token storage token = tokens[_token];
2667         // If the token exists require that its rate is not zero
2668         if (token.exists) {
2669             require(token.rate != 0, "token rate is 0");
2670             // Safely convert the token amount to ether based on the exchange rate.
2671             // return the value and a 'true' implying that the token is protected
2672             return (true, _amount.mul(token.rate).div(token.magnitude));
2673         }
2674         // this returns a 'false' to imply that a card is not protected
2675         return (false, 0);
2676 
2677     }
2678 
2679     /// @dev Add ERC20 tokens to the list of supported tokens.
2680     /// @param _tokens ERC20 token contract addresses.
2681     /// @param _symbols ERC20 token names.
2682     /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.
2683     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2684     function addTokens(address[] _tokens, bytes32[] _symbols, uint[] _magnitude, uint _updateDate) external onlyController {
2685         // Require that all parameters have the same length.
2686         require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length, "parameter lengths do not match");
2687         // Add each token to the list of supported tokens.
2688         for (uint i = 0; i < _tokens.length; i++) {
2689             // Require that the token doesn't already exist.
2690             address token = _tokens[i];
2691             require(!tokens[token].exists, "token already exists");
2692             // Store the intermediate values.
2693             string memory symbol = _symbols[i].toSliceB32().toString();
2694             uint magnitude = _magnitude[i];
2695             // Add the token to the token list.
2696             tokens[token] = Token({
2697                 symbol : symbol,
2698                 magnitude : magnitude,
2699                 rate : 0,
2700                 exists : true,
2701                 lastUpdate: _updateDate
2702             });
2703             // Add the token address to the address list.
2704             _tokenAddresses.push(token);
2705             // Emit token addition event.
2706             emit AddedToken(msg.sender, token, symbol, magnitude);
2707         }
2708     }
2709 
2710     /// @dev Remove ERC20 tokens from the list of supported tokens.
2711     /// @param _tokens ERC20 token contract addresses.
2712     function removeTokens(address[] _tokens) external onlyController {
2713         // Delete each token object from the list of supported tokens based on the addresses provided.
2714         for (uint i = 0; i < _tokens.length; i++) {
2715             //token must exist, reverts on duplicates as well
2716             require(tokens[_tokens[i]].exists, "token does not exist");
2717             // Store the token address.
2718             address token = _tokens[i];
2719             // Delete the token object.
2720             delete tokens[token];
2721             // Remove the token address from the address list.
2722             for (uint j = 0; j < _tokenAddresses.length.sub(1); j++) {
2723                 if (_tokenAddresses[j] == token) {
2724                     _tokenAddresses[j] = _tokenAddresses[_tokenAddresses.length.sub(1)];
2725                     break;
2726                 }
2727             }
2728             _tokenAddresses.length--;
2729             // Emit token removal event.
2730             emit RemovedToken(msg.sender, token);
2731         }
2732     }
2733 
2734     /// @dev Update ERC20 token exchange rate manually.
2735     /// @param _token ERC20 token contract address.
2736     /// @param _rate ERC20 token exchange rate in wei.
2737     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2738     function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyController {
2739         // Require that the token exists.
2740         require(tokens[_token].exists, "token does not exist");
2741         // Update the token's rate.
2742         tokens[_token].rate = _rate;
2743         // Update the token's last update timestamp.
2744         tokens[_token].lastUpdate = _updateDate;
2745         // Emit the rate update event.
2746         emit UpdatedTokenRate(msg.sender, _token, _rate);
2747     }
2748 
2749     /// @dev Update ERC20 token exchange rates for all supported tokens.
2750     //// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
2751     function updateTokenRates(uint _gasLimit) external payable onlyController {
2752         _updateTokenRates(_gasLimit);
2753     }
2754 
2755     //// @dev Withdraw ether from the smart contract to the specified account.
2756     function withdraw(address _to, uint _amount) external onlyController {
2757         _to.transfer(_amount);
2758     }
2759 
2760     //// @dev Handle Oraclize query callback and verifiy the provided origin proof.
2761     //// @param _queryID Oraclize query ID.
2762     //// @param _result query result in JSON format.
2763     //// @param _proof origin proof from crypto compare.
2764     // solium-disable-next-line mixedcase
2765     function __callback(bytes32 _queryID, string _result, bytes _proof) public {
2766         // Require that the caller is the Oraclize contract.
2767         require(msg.sender == oraclize_cbAddress(), "sender is not oraclize");
2768         // Use the query ID to find the matching token address.
2769         address _token = _queryToToken[_queryID];
2770         require(_token != address(0), "queryID matches to address 0");
2771         // Get the corresponding token object.
2772         Token storage token = tokens[_token];
2773 
2774         bool valid;
2775         uint timestamp;
2776         (valid, timestamp) = _verifyProof(_result, _proof, APIPublicKey, token.lastUpdate);
2777 
2778         // Require that the proof is valid.
2779         if (valid) {
2780             // Parse the JSON result to get the rate in wei.
2781             token.rate = _parseIntScientificWei(parseRate(_result));
2782             // Set the update time of the token rate.
2783             token.lastUpdate = timestamp;
2784             // Remove query from the list.
2785             delete _queryToToken[_queryID];
2786             // Emit the rate update event.
2787             emit UpdatedTokenRate(msg.sender, _token, token.rate);
2788         }
2789     }
2790 
2791     /// @dev Re-usable helper function that performs the Oraclize Query.
2792     //// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
2793     function _updateTokenRates(uint _gasLimit) private {
2794         // Check if there are any existing tokens.
2795         if (_tokenAddresses.length == 0) {
2796             // Emit a query failure event.
2797             emit FailedUpdateRequest("no tokens");
2798         // Check if the contract has enough Ether to pay for the query.
2799         } else if (oraclize_getPrice("URL") * _tokenAddresses.length > address(this).balance) {
2800             // Emit a query failure event.
2801             emit FailedUpdateRequest("insufficient balance");
2802         } else {
2803             // Set up the cryptocompare API query strings.
2804             strings.slice memory apiPrefix = "https://min-api.cryptocompare.com/data/price?fsym=".toSlice();
2805             strings.slice memory apiSuffix = "&tsyms=ETH&sign=true".toSlice();
2806 
2807             // Create a new oraclize query for each supported token.
2808             for (uint i = 0; i < _tokenAddresses.length; i++) {
2809                 // Store the token symbol used in the query.
2810                 strings.slice memory symbol = tokens[_tokenAddresses[i]].symbol.toSlice();
2811                 // Create a new oraclize query from the component strings.
2812                 bytes32 queryID = oraclize_query("URL", apiPrefix.concat(symbol).toSlice().concat(apiSuffix), _gasLimit);
2813                 // Store the query ID together with the associated token address.
2814                 _queryToToken[queryID] = _tokenAddresses[i];
2815                 // Emit the query success event.
2816                 emit RequestedUpdate(symbol.toString());
2817             }
2818         }
2819     }
2820 
2821     /// @dev Verify the origin proof returned by the cryptocompare API.
2822     /// @param _result query result in JSON format.
2823     /// @param _proof origin proof from cryptocompare.
2824     /// @param _publicKey cryptocompare public key.
2825     /// @param _lastUpdate timestamp of the last time the requested token was updated.
2826     function _verifyProof(string _result, bytes _proof, bytes _publicKey, uint _lastUpdate) private returns (bool, uint) {
2827 
2828         //expecting fixed length proofs
2829         if (_proof.length != PROOF_LEN)
2830           revert("invalid proof length");
2831 
2832         //proof should be 65 bytes long: R (32 bytes) + S (32 bytes) + v (1 byte)
2833         if (uint(_proof[1]) != ECDSA_SIG_LEN)
2834           revert("invalid signature length");
2835 
2836         bytes memory signature = new bytes(ECDSA_SIG_LEN);
2837 
2838         signature = copyBytes(_proof, 2, ECDSA_SIG_LEN, signature, 0);
2839 
2840         // Extract the headers, big endian encoding of headers length
2841         if (uint(_proof[ENCODING_BYTES + ECDSA_SIG_LEN]) * MAX_BYTE_SIZE + uint(_proof[ENCODING_BYTES + ECDSA_SIG_LEN + 1]) != HEADERS_LEN)
2842           revert("invalid headers length");
2843 
2844         bytes memory headers = new bytes(HEADERS_LEN);
2845         headers = copyBytes(_proof, 2*ENCODING_BYTES + ECDSA_SIG_LEN, HEADERS_LEN, headers, 0);
2846 
2847         // Check if the signature is valid and if the signer address is matching.
2848         if (!_verifySignature(headers, signature, _publicKey)) {
2849             revert("invalid signature");
2850         }
2851 
2852         // Check if the date is valid.
2853         bytes memory dateHeader = new bytes(20);
2854         //keep only the relevant string(e.g. "16 Nov 2018 16:22:18")
2855         dateHeader = copyBytes(headers, 11, 20, dateHeader, 0);
2856 
2857         bool dateValid;
2858         uint timestamp;
2859         (dateValid, timestamp) = _verifyDate(string(dateHeader), _lastUpdate);
2860 
2861         // Check whether the date returned is valid or not
2862         if (!dateValid)
2863             revert("invalid date");
2864 
2865         // Check if the signed digest hash matches the result hash.
2866         bytes memory digest = new bytes(DIGEST_BASE64_LEN);
2867         digest = copyBytes(headers, DIGEST_OFFSET, DIGEST_BASE64_LEN, digest, 0);
2868 
2869         if (keccak256(abi.encodePacked(sha256(abi.encodePacked(_result)))) != keccak256(_base64decode(digest)))
2870           revert("result hash not matching");
2871 
2872         emit VerifiedProof(_publicKey, _result);
2873         return (true, timestamp);
2874     }
2875 
2876     /// @dev Verify the HTTP headers and the signature
2877     /// @param _headers HTTP headers provided by the cryptocompare api
2878     /// @param _signature signature provided by the cryptocompare api
2879     /// @param _publicKey cryptocompare public key.
2880     function _verifySignature(bytes _headers, bytes _signature, bytes _publicKey) private returns (bool) {
2881         address signer;
2882         bool signatureOK;
2883 
2884         // Checks if the signature is valid by hashing the headers
2885         (signatureOK, signer) = ecrecovery(sha256(_headers), _signature);
2886         return signatureOK && signer == address(keccak256(_publicKey));
2887     }
2888 
2889     /// @dev Verify the signed HTTP date header.
2890     /// @param _dateHeader extracted date string e.g. Wed, 12 Sep 2018 15:18:14 GMT.
2891     /// @param _lastUpdate timestamp of the last time the requested token was updated.
2892     function _verifyDate(string _dateHeader, uint _lastUpdate) private pure returns (bool, uint) {
2893 
2894         //called by verifyProof(), _dateHeader is always a string of length = 20
2895         assert(abi.encodePacked(_dateHeader).length == 20);
2896 
2897         //Split the date string and get individual date components.
2898         strings.slice memory date = _dateHeader.toSlice();
2899         strings.slice memory timeDelimiter = ":".toSlice();
2900         strings.slice memory dateDelimiter = " ".toSlice();
2901 
2902         uint day = _parseIntScientific(date.split(dateDelimiter).toString());
2903         require(day > 0 && day < 32, "day error");
2904 
2905         uint month = _monthToNumber(date.split(dateDelimiter).toString());
2906         require(month > 0 && month < 13, "month error");
2907 
2908         uint year = _parseIntScientific(date.split(dateDelimiter).toString());
2909         require(year > 2017 && year < 3000, "year error");
2910 
2911         uint hour = _parseIntScientific(date.split(timeDelimiter).toString());
2912         require(hour < 25, "hour error");
2913 
2914         uint minute = _parseIntScientific(date.split(timeDelimiter).toString());
2915         require(minute < 60, "minute error");
2916 
2917         uint second = _parseIntScientific(date.split(timeDelimiter).toString());
2918         require(second < 60, "second error");
2919 
2920         uint timestamp = year * (10 ** 10) + month * (10 ** 8) + day * (10 ** 6) + hour * (10 ** 4) + minute * (10 ** 2) + second;
2921 
2922         return (timestamp > _lastUpdate, timestamp);
2923     }
2924 }
2925 
2926 
2927 /**
2928  *  Ownable
2929  *  Copyright (C) 2018 The Contract Wallet Company Limited
2930  *
2931  *  This program is free software: you can redistribute it and/or modify
2932  *  it under the terms of the GNU General Public License as published by
2933  *  the Free Software Foundation, either version 3 of the License, or
2934  *  (at your option) any later version.
2935 
2936  *  This program is distributed in the hope that it will be useful,
2937  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
2938  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2939  *  GNU General Public License for more details.
2940 
2941  *  You should have received a copy of the GNU General Public License
2942  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
2943  */
2944 
2945 
2946 /// @title Ownable has an owner address and provides basic authorization control functions.
2947 /// This contract is modified version of the MIT OpenZepplin Ownable contract
2948 /// This contract doesn't allow for multiple changeOwner operations
2949 /// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
2950 contract Ownable {
2951     event TransferredOwnership(address _from, address _to);
2952 
2953     address private _owner;
2954     bool private _isTransferable;
2955 
2956     /// @dev Constructor sets the original owner of the contract and whether or not it is one time transferable.
2957     constructor(address _account, bool _transferable) internal {
2958         _owner = _account;
2959         _isTransferable = _transferable;
2960         emit TransferredOwnership(address(0), _account);
2961     }
2962 
2963     /// @dev Reverts if called by any account other than the owner.
2964     modifier onlyOwner() {
2965         require(_isOwner(), "sender is not an owner");
2966         _;
2967     }
2968 
2969     /// @dev Allows the current owner to transfer control of the contract to a new address.
2970     /// @param _account address to transfer ownership to.
2971     function transferOwnership(address _account) external onlyOwner {
2972         // Require that the ownership is transferable.
2973         require(_isTransferable, "ownership is not transferable");
2974         // Require that the new owner is not the zero address.
2975         require(_account != address(0), "owner cannot be set to zero address");
2976         // Set the transferable flag to false.
2977         _isTransferable = false;
2978         // Emit the ownership transfer event.
2979         emit TransferredOwnership(_owner, _account);
2980         // Set the owner to the provided address.
2981         _owner = _account;
2982     }
2983 
2984     /// @dev Allows the current owner to relinquish control of the contract.
2985     /// @notice Renouncing to ownership will leave the contract without an owner and unusable.
2986     /// It will not be possible to call the functions with the `onlyOwner` modifier anymore.
2987     function renounceOwnership() public onlyOwner {
2988         // Require that the ownership is transferable.
2989         require(_isTransferable, "ownership is not transferable");
2990         emit TransferredOwnership(_owner, address(0));
2991         // note that this could be terminal
2992         _owner = address(0);
2993     }
2994 
2995     /// @return the address of the owner.
2996     function owner() public view returns (address) {
2997         return _owner;
2998     }
2999 
3000     /// @return true if the ownership is transferable.
3001     function isTransferable() public view returns (bool) {
3002         return _isTransferable;
3003     }
3004 
3005     /// @return true if sender is the owner of the contract.
3006     function _isOwner() internal view returns (bool) {
3007         return msg.sender == _owner;
3008     }
3009 }
3010 
3011 
3012 
3013 /**
3014  * BSD 2-Clause License
3015  *
3016  * Copyright (c) 2018, True Names Limited
3017  * All rights reserved.
3018  *
3019  * Redistribution and use in source and binary forms, with or without
3020  * modification, are permitted provided that the following conditions are met:
3021  *
3022  * * Redistributions of source code must retain the above copyright notice, this
3023  *   list of conditions and the following disclaimer.
3024  *
3025  * * Redistributions in binary form must reproduce the above copyright notice,
3026  *   this list of conditions and the following disclaimer in the documentation
3027  *   and/or other materials provided with the distribution.
3028  *
3029  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
3030  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
3031  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
3032  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
3033  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
3034  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
3035  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
3036  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
3037  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
3038  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
3039 */
3040 
3041 interface ENS {
3042 
3043     // Logged when the owner of a node assigns a new owner to a subnode.
3044     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
3045 
3046     // Logged when the owner of a node transfers ownership to a new account.
3047     event Transfer(bytes32 indexed node, address owner);
3048 
3049     // Logged when the resolver for a node changes.
3050     event NewResolver(bytes32 indexed node, address resolver);
3051 
3052     // Logged when the TTL of a node changes
3053     event NewTTL(bytes32 indexed node, uint64 ttl);
3054 
3055 
3056     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
3057     function setResolver(bytes32 node, address resolver) public;
3058     function setOwner(bytes32 node, address owner) public;
3059     function setTTL(bytes32 node, uint64 ttl) public;
3060     function owner(bytes32 node) public view returns (address);
3061     function resolver(bytes32 node) public view returns (address);
3062     function ttl(bytes32 node) public view returns (uint64);
3063 
3064 }
3065 
3066 
3067 /**
3068  * BSD 2-Clause License
3069  *
3070  * Copyright (c) 2018, True Names Limited
3071  * All rights reserved.
3072  *
3073  * Redistribution and use in source and binary forms, with or without
3074  * modification, are permitted provided that the following conditions are met:
3075  *
3076  * * Redistributions of source code must retain the above copyright notice, this
3077  *   list of conditions and the following disclaimer.
3078  *
3079  * * Redistributions in binary form must reproduce the above copyright notice,
3080  *   this list of conditions and the following disclaimer in the documentation
3081  *   and/or other materials provided with the distribution.
3082  *
3083  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
3084  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
3085  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
3086  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
3087  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
3088  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
3089  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
3090  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
3091  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
3092  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
3093 */
3094 
3095 
3096 /**
3097  * A simple resolver anyone can use; only allows the owner of a node to set its
3098  * address.
3099  */
3100 contract PublicResolver {
3101 
3102     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
3103     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
3104     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
3105     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
3106     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
3107     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
3108     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
3109     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
3110 
3111     event AddrChanged(bytes32 indexed node, address a);
3112     event ContentChanged(bytes32 indexed node, bytes32 hash);
3113     event NameChanged(bytes32 indexed node, string name);
3114     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
3115     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
3116     event TextChanged(bytes32 indexed node, string indexedKey, string key);
3117     event MultihashChanged(bytes32 indexed node, bytes hash);
3118 
3119     struct PublicKey {
3120         bytes32 x;
3121         bytes32 y;
3122     }
3123 
3124     struct Record {
3125         address addr;
3126         bytes32 content;
3127         string name;
3128         PublicKey pubkey;
3129         mapping(string=>string) text;
3130         mapping(uint256=>bytes) abis;
3131         bytes multihash;
3132     }
3133 
3134     ENS ens;
3135 
3136     mapping (bytes32 => Record) records;
3137 
3138     modifier only_owner(bytes32 node) {
3139         require(ens.owner(node) == msg.sender);
3140         _;
3141     }
3142 
3143     /**
3144      * Constructor.
3145      * @param ensAddr The ENS registrar contract.
3146      */
3147     constructor(ENS ensAddr) public {
3148         ens = ensAddr;
3149     }
3150 
3151     /**
3152      * Sets the address associated with an ENS node.
3153      * May only be called by the owner of that node in the ENS registry.
3154      * @param node The node to update.
3155      * @param addr The address to set.
3156      */
3157     function setAddr(bytes32 node, address addr) public only_owner(node) {
3158         records[node].addr = addr;
3159         emit AddrChanged(node, addr);
3160     }
3161 
3162     /**
3163      * Sets the content hash associated with an ENS node.
3164      * May only be called by the owner of that node in the ENS registry.
3165      * Note that this resource type is not standardized, and will likely change
3166      * in future to a resource type based on multihash.
3167      * @param node The node to update.
3168      * @param hash The content hash to set
3169      */
3170     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
3171         records[node].content = hash;
3172         emit ContentChanged(node, hash);
3173     }
3174 
3175     /**
3176      * Sets the multihash associated with an ENS node.
3177      * May only be called by the owner of that node in the ENS registry.
3178      * @param node The node to update.
3179      * @param hash The multihash to set
3180      */
3181     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
3182         records[node].multihash = hash;
3183         emit MultihashChanged(node, hash);
3184     }
3185 
3186     /**
3187      * Sets the name associated with an ENS node, for reverse records.
3188      * May only be called by the owner of that node in the ENS registry.
3189      * @param node The node to update.
3190      * @param name The name to set.
3191      */
3192     function setName(bytes32 node, string name) public only_owner(node) {
3193         records[node].name = name;
3194         emit NameChanged(node, name);
3195     }
3196 
3197     /**
3198      * Sets the ABI associated with an ENS node.
3199      * Nodes may have one ABI of each content type. To remove an ABI, set it to
3200      * the empty string.
3201      * @param node The node to update.
3202      * @param contentType The content type of the ABI
3203      * @param data The ABI data.
3204      */
3205     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
3206         // Content types must be powers of 2
3207         require(((contentType - 1) & contentType) == 0);
3208 
3209         records[node].abis[contentType] = data;
3210         emit ABIChanged(node, contentType);
3211     }
3212 
3213     /**
3214      * Sets the SECP256k1 public key associated with an ENS node.
3215      * @param node The ENS node to query
3216      * @param x the X coordinate of the curve point for the public key.
3217      * @param y the Y coordinate of the curve point for the public key.
3218      */
3219     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
3220         records[node].pubkey = PublicKey(x, y);
3221         emit PubkeyChanged(node, x, y);
3222     }
3223 
3224     /**
3225      * Sets the text data associated with an ENS node and key.
3226      * May only be called by the owner of that node in the ENS registry.
3227      * @param node The node to update.
3228      * @param key The key to set.
3229      * @param value The text data value to set.
3230      */
3231     function setText(bytes32 node, string key, string value) public only_owner(node) {
3232         records[node].text[key] = value;
3233         emit TextChanged(node, key, key);
3234     }
3235 
3236     /**
3237      * Returns the text data associated with an ENS node and key.
3238      * @param node The ENS node to query.
3239      * @param key The text data key to query.
3240      * @return The associated text data.
3241      */
3242     function text(bytes32 node, string key) public view returns (string) {
3243         return records[node].text[key];
3244     }
3245 
3246     /**
3247      * Returns the SECP256k1 public key associated with an ENS node.
3248      * Defined in EIP 619.
3249      * @param node The ENS node to query
3250      * @return x, y the X and Y coordinates of the curve point for the public key.
3251      */
3252     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
3253         return (records[node].pubkey.x, records[node].pubkey.y);
3254     }
3255 
3256     /**
3257      * Returns the ABI associated with an ENS node.
3258      * Defined in EIP205.
3259      * @param node The ENS node to query
3260      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
3261      * @return contentType The content type of the return value
3262      * @return data The ABI data
3263      */
3264     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
3265         Record storage record = records[node];
3266         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
3267             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
3268                 data = record.abis[contentType];
3269                 return;
3270             }
3271         }
3272         contentType = 0;
3273     }
3274 
3275     /**
3276      * Returns the name associated with an ENS node, for reverse records.
3277      * Defined in EIP181.
3278      * @param node The ENS node to query.
3279      * @return The associated name.
3280      */
3281     function name(bytes32 node) public view returns (string) {
3282         return records[node].name;
3283     }
3284 
3285     /**
3286      * Returns the content hash associated with an ENS node.
3287      * Note that this resource type is not standardized, and will likely change
3288      * in future to a resource type based on multihash.
3289      * @param node The ENS node to query.
3290      * @return The associated content hash.
3291      */
3292     function content(bytes32 node) public view returns (bytes32) {
3293         return records[node].content;
3294     }
3295 
3296     /**
3297      * Returns the multihash associated with an ENS node.
3298      * @param node The ENS node to query.
3299      * @return The associated multihash.
3300      */
3301     function multihash(bytes32 node) public view returns (bytes) {
3302         return records[node].multihash;
3303     }
3304 
3305     /**
3306      * Returns the address associated with an ENS node.
3307      * @param node The ENS node to query.
3308      * @return The associated address.
3309      */
3310     function addr(bytes32 node) public view returns (address) {
3311         return records[node].addr;
3312     }
3313 
3314     /**
3315      * Returns true if the resolver implements the interface specified by the provided hash.
3316      * @param interfaceID The ID of the interface to check for.
3317      * @return True if the contract implements the requested interface.
3318      */
3319     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
3320         return interfaceID == ADDR_INTERFACE_ID ||
3321         interfaceID == CONTENT_INTERFACE_ID ||
3322         interfaceID == NAME_INTERFACE_ID ||
3323         interfaceID == ABI_INTERFACE_ID ||
3324         interfaceID == PUBKEY_INTERFACE_ID ||
3325         interfaceID == TEXT_INTERFACE_ID ||
3326         interfaceID == MULTIHASH_INTERFACE_ID ||
3327         interfaceID == INTERFACE_META_ID;
3328     }
3329 }
3330 
3331 
3332 /**
3333  * The MIT License (MIT)
3334  *
3335  * Copyright (c) 2016 Smart Contract Solutions, Inc.
3336  *
3337  * Permission is hereby granted, free of charge, to any person obtaining
3338  * a copy of this software and associated documentation files (the
3339  * "Software"), to deal in the Software without restriction, including
3340  * without limitation the rights to use, copy, modify, merge, publish,
3341  * distribute, sublicense, and/or sell copies of the Software, and to
3342  * permit persons to whom the Software is furnished to do so, subject to
3343  * the following conditions:
3344  *
3345  * The above copyright notice and this permission notice shall be included
3346  * in all copies or substantial portions of the Software.
3347  *
3348  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
3349  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
3350  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
3351  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
3352  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
3353  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
3354  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
3355  */
3356 
3357 
3358 /// @title ERC20 interface is a subset of the ERC20 specification.
3359 interface ERC20 {
3360     function transfer(address, uint) external returns (bool);
3361     function balanceOf(address) external view returns (uint);
3362 }
3363 
3364 
3365 /// @title ERC165 interface specifies a standard way of querying if a contract implements an interface.
3366 interface ERC165 {
3367     function supportsInterface(bytes4) external view returns (bool);
3368 }
3369 
3370 
3371 /// @title Whitelist provides payee-whitelist functionality.
3372 contract Whitelist is Controllable, Ownable {
3373     event AddedToWhitelist(address _sender, address[] _addresses);
3374     event SubmittedWhitelistAddition(address[] _addresses, bytes32 _hash);
3375     event CancelledWhitelistAddition(address _sender, bytes32 _hash);
3376 
3377     event RemovedFromWhitelist(address _sender, address[] _addresses);
3378     event SubmittedWhitelistRemoval(address[] _addresses, bytes32 _hash);
3379     event CancelledWhitelistRemoval(address _sender, bytes32 _hash);
3380 
3381     mapping(address => bool) public isWhitelisted;
3382     address[] private _pendingWhitelistAddition;
3383     address[] private _pendingWhitelistRemoval;
3384     bool public submittedWhitelistAddition;
3385     bool public submittedWhitelistRemoval;
3386     bool public initializedWhitelist;
3387 
3388     /// @dev Check if the provided addresses contain the owner or the zero-address address.
3389     modifier hasNoOwnerOrZeroAddress(address[] _addresses) {
3390         for (uint i = 0; i < _addresses.length; i++) {
3391             require(_addresses[i] != owner(), "provided whitelist contains the owner address");
3392             require(_addresses[i] != address(0), "provided whitelist contains the zero address");
3393         }
3394         _;
3395     }
3396 
3397     /// @dev Check that neither addition nor removal operations have already been submitted.
3398     modifier noActiveSubmission() {
3399         require(!submittedWhitelistAddition && !submittedWhitelistRemoval, "whitelist operation has already been submitted");
3400         _;
3401     }
3402 
3403     /// @dev Getter for pending addition array.
3404     function pendingWhitelistAddition() external view returns(address[]) {
3405         return _pendingWhitelistAddition;
3406     }
3407 
3408     /// @dev Getter for pending removal array.
3409     function pendingWhitelistRemoval() external view returns(address[]) {
3410         return _pendingWhitelistRemoval;
3411     }
3412 
3413     /// @dev Getter for pending addition/removal array hash.
3414     function pendingWhitelistHash(address[] _pendingWhitelist) public pure returns(bytes32) {
3415         return keccak256(abi.encodePacked(_pendingWhitelist));
3416     }
3417 
3418     /// @dev Add initial addresses to the whitelist.
3419     /// @param _addresses are the Ethereum addresses to be whitelisted.
3420     function initializeWhitelist(address[] _addresses) external onlyOwner hasNoOwnerOrZeroAddress(_addresses) {
3421         // Require that the whitelist has not been initialized.
3422         require(!initializedWhitelist, "whitelist has already been initialized");
3423         // Add each of the provided addresses to the whitelist.
3424         for (uint i = 0; i < _addresses.length; i++) {
3425             isWhitelisted[_addresses[i]] = true;
3426         }
3427         initializedWhitelist = true;
3428         // Emit the addition event.
3429         emit AddedToWhitelist(msg.sender, _addresses);
3430     }
3431 
3432     /// @dev Add addresses to the whitelist.
3433     /// @param _addresses are the Ethereum addresses to be whitelisted.
3434     function submitWhitelistAddition(address[] _addresses) external onlyOwner noActiveSubmission hasNoOwnerOrZeroAddress(_addresses)  {
3435         // Require that the whitelist has been initialized.
3436         require(initializedWhitelist, "whitelist has not been initialized");
3437         // Require this array of addresses not empty
3438         require(_addresses.length > 0, "pending whitelist addition is empty");
3439         // Set the provided addresses to the pending addition addresses.
3440         _pendingWhitelistAddition = _addresses;
3441         // Flag the operation as submitted.
3442         submittedWhitelistAddition = true;
3443         // Emit the submission event.
3444         emit SubmittedWhitelistAddition(_addresses, pendingWhitelistHash(_pendingWhitelistAddition));
3445     }
3446 
3447     /// @dev Confirm pending whitelist addition.
3448     function confirmWhitelistAddition(bytes32 _hash) external onlyController {
3449         // Require that the whitelist addition has been submitted.
3450         require(submittedWhitelistAddition, "whitelist addition has not been submitted");
3451 
3452         // Require that confirmation hash and the hash of the pending whitelist addition match
3453         require(_hash == pendingWhitelistHash(_pendingWhitelistAddition), "hash of the pending whitelist addition do not match");
3454 
3455         // Whitelist pending addresses.
3456         for (uint i = 0; i < _pendingWhitelistAddition.length; i++) {
3457             isWhitelisted[_pendingWhitelistAddition[i]] = true;
3458         }
3459         // Emit the addition event.
3460         emit AddedToWhitelist(msg.sender, _pendingWhitelistAddition);
3461         // Reset pending addresses.
3462         delete _pendingWhitelistAddition;
3463         // Reset the submission flag.
3464         submittedWhitelistAddition = false;
3465     }
3466 
3467     /// @dev Cancel pending whitelist addition.
3468     function cancelWhitelistAddition(bytes32 _hash) external onlyController {
3469         // Check if operation has been submitted.
3470         require(submittedWhitelistAddition, "whitelist addition has not been submitted");
3471         // Require that confirmation hash and the hash of the pending whitelist addition match
3472         require(_hash == pendingWhitelistHash(_pendingWhitelistAddition), "hash of the pending whitelist addition does not match");
3473         // Reset pending addresses.
3474         delete _pendingWhitelistAddition;
3475         // Reset the submitted operation flag.
3476         submittedWhitelistAddition = false;
3477         // Emit the cancellation event.
3478         emit CancelledWhitelistAddition(msg.sender, _hash);
3479     }
3480 
3481     /// @dev Remove addresses from the whitelist.
3482     /// @param _addresses are the Ethereum addresses to be removed.
3483     function submitWhitelistRemoval(address[] _addresses) external onlyOwner noActiveSubmission {
3484         // Require that the whitelist has been initialized.
3485         require(initializedWhitelist, "whitelist has not been initialized");
3486         // Require that the array of addresses is not empty
3487         require(_addresses.length > 0, "submitted whitelist removal is empty");
3488         // Add the provided addresses to the pending addition list.
3489         _pendingWhitelistRemoval = _addresses;
3490         // Flag the operation as submitted.
3491         submittedWhitelistRemoval = true;
3492         // Emit the submission event.
3493         emit SubmittedWhitelistRemoval(_addresses, pendingWhitelistHash(_pendingWhitelistRemoval));
3494     }
3495 
3496     /// @dev Confirm pending removal of whitelisted addresses.
3497     function confirmWhitelistRemoval(bytes32 _hash) external onlyController {
3498         // Require that the pending whitelist is not empty and the operation has been submitted.
3499         require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
3500         // Require that confirmation hash and the hash of the pending whitelist removal match
3501         require(_hash == pendingWhitelistHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match the confirmed hash");
3502         // Remove pending addresses.
3503         for (uint i = 0; i < _pendingWhitelistRemoval.length; i++) {
3504             isWhitelisted[_pendingWhitelistRemoval[i]] = false;
3505         }
3506         // Emit the removal event.
3507         emit RemovedFromWhitelist(msg.sender, _pendingWhitelistRemoval);
3508         // Reset pending addresses.
3509         delete _pendingWhitelistRemoval;
3510         // Reset the submission flag.
3511         submittedWhitelistRemoval = false;
3512     }
3513 
3514     /// @dev Cancel pending removal of whitelisted addresses.
3515     function cancelWhitelistRemoval(bytes32 _hash) external onlyController {
3516         // Check if operation has been submitted.
3517         require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
3518         // Require that confirmation hash and the hash of the pending whitelist removal match
3519         require(_hash == pendingWhitelistHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match");
3520         // Reset pending addresses.
3521         delete _pendingWhitelistRemoval;
3522         // Reset the submitted operation flag.
3523         submittedWhitelistRemoval = false;
3524         // Emit the cancellation event.
3525         emit CancelledWhitelistRemoval(msg.sender, _hash);
3526     }
3527 }
3528 
3529 
3530 //// @title SpendLimit provides daily spend limit functionality.
3531 contract SpendLimit is Controllable, Ownable {
3532     event SetSpendLimit(address _sender, uint _amount);
3533     event SubmittedSpendLimitChange(uint _amount);
3534     event CancelledSpendLimitChange(address _sender, uint _amount);
3535 
3536     using SafeMath for uint256;
3537 
3538     uint public spendLimit;
3539     uint private _spendLimitDay;
3540     uint private _spendAvailable;
3541 
3542     uint public pendingSpendLimit;
3543     bool public submittedSpendLimit;
3544     bool public initializedSpendLimit;
3545 
3546     /// @dev Constructor initializes the daily spend limit in wei.
3547     constructor(uint _spendLimit) internal {
3548         spendLimit = _spendLimit;
3549         _spendLimitDay = now;
3550         _spendAvailable = spendLimit;
3551     }
3552 
3553     /// @dev Returns the available daily balance - accounts for daily limit reset.
3554     /// @return amount of ether in wei.
3555     function spendAvailable() public view returns (uint) {
3556         if (now > _spendLimitDay + 24 hours) {
3557             return spendLimit;
3558         } else {
3559             return _spendAvailable;
3560         }
3561     }
3562 
3563     /// @dev Initialize a daily spend (aka transfer) limit for non-whitelisted addresses.
3564     /// @param _amount is the daily limit amount in wei.
3565     function initializeSpendLimit(uint _amount) external onlyOwner {
3566         // Require that the spend limit has not been initialized.
3567         require(!initializedSpendLimit, "spend limit has already been initialized");
3568         // Modify spend limit based on the provided value.
3569         _modifySpendLimit(_amount);
3570         // Flag the operation as initialized.
3571         initializedSpendLimit = true;
3572         // Emit the set limit event.
3573         emit SetSpendLimit(msg.sender, _amount);
3574     }
3575 
3576     /// @dev Set a daily transfer limit for non-whitelisted addresses.
3577     /// @param _amount is the daily limit amount in wei.
3578     function submitSpendLimit(uint _amount) external onlyOwner {
3579         // Require that the spend limit has been initialized.
3580         require(initializedSpendLimit, "spend limit has not been initialized");
3581         // Assign the provided amount to pending daily limit change.
3582         pendingSpendLimit = _amount;
3583         // Flag the operation as submitted.
3584         submittedSpendLimit = true;
3585         // Emit the submission event.
3586         emit SubmittedSpendLimitChange(_amount);
3587     }
3588 
3589     /// @dev Confirm pending set daily limit operation.
3590     function confirmSpendLimit(uint _amount) external onlyController {
3591         // Require that the operation has been submitted.
3592         require(submittedSpendLimit, "spend limit has not been submitted");
3593         // Require that pending and confirmed spend limit are the same
3594         require(pendingSpendLimit == _amount, "confirmed and submitted spend limits dont match");
3595         // Modify spend limit based on the pending value.
3596         _modifySpendLimit(pendingSpendLimit);
3597         // Emit the set limit event.
3598         emit SetSpendLimit(msg.sender, pendingSpendLimit);
3599         // Reset the submission flag.
3600         submittedSpendLimit = false;
3601         // Reset pending daily limit.
3602         pendingSpendLimit = 0;
3603     }
3604 
3605     /// @dev Cancel pending set daily limit operation.
3606     function cancelSpendLimit(uint _amount) external onlyController {
3607         // Require a spendlimit has been submitted
3608         require(submittedSpendLimit, "a spendlimit needs to be submitted");
3609         // Require that pending and confirmed spend limit are the same
3610         require(pendingSpendLimit == _amount, "pending and cancelled spend limits dont match");
3611         // Reset pending daily limit.
3612         pendingSpendLimit = 0;
3613         // Reset the submitted operation flag.
3614         submittedSpendLimit = false;
3615         // Emit the cancellation event.
3616         emit CancelledSpendLimitChange(msg.sender, _amount);
3617     }
3618 
3619     // @dev Setter method for the available daily spend limit.
3620     function _setSpendAvailable(uint _amount) internal {
3621         _spendAvailable = _amount;
3622     }
3623 
3624     /// @dev Update available spend limit based on the daily reset.
3625     function _updateSpendAvailable() internal {
3626         if (now > _spendLimitDay.add(24 hours)) {
3627             // Advance the current day by how many days have passed.
3628             uint extraDays = now.sub(_spendLimitDay).div(24 hours);
3629             _spendLimitDay = _spendLimitDay.add(extraDays.mul(24 hours));
3630             // Set the available limit to the current spend limit.
3631             _spendAvailable = spendLimit;
3632         }
3633     }
3634 
3635     /// @dev Modify the spend limit and spend available based on the provided value.
3636     /// @dev _amount is the daily limit amount in wei.
3637     function _modifySpendLimit(uint _amount) private {
3638         // Account for the spend limit daily reset.
3639         _updateSpendAvailable();
3640         // Set the daily limit to the provided amount.
3641         spendLimit = _amount;
3642         // Lower the available limit if it's higher than the new daily limit.
3643         if (_spendAvailable > spendLimit) {
3644             _spendAvailable = spendLimit;
3645         }
3646     }
3647 }
3648 
3649 
3650 //// @title Asset store with extra security features.
3651 contract Vault is Whitelist, SpendLimit, ERC165 {
3652     event Received(address _from, uint _amount);
3653     event Transferred(address _to, address _asset, uint _amount);
3654     event BulkTransferred(address _to, address[] _assets);
3655 
3656     using SafeMath for uint256;
3657 
3658     /// @dev Supported ERC165 interface ID.
3659     bytes4 private constant _ERC165_INTERFACE_ID = 0x01ffc9a7; // solium-disable-line uppercase
3660 
3661     /// @dev ENS points to the ENS registry smart contract.
3662     ENS private _ENS;
3663     /// @dev Is the registered ENS name of the oracle contract.
3664     bytes32 private _node;
3665 
3666     /// @dev Constructor initializes the vault with an owner address and spend limit. It also sets up the oracle and controller contracts.
3667     /// @param _owner is the owner account of the wallet contract.
3668     /// @param _transferable indicates whether the contract ownership can be transferred.
3669     /// @param _ens is the ENS public registry contract address.
3670     /// @param _oracleName is the ENS name of the Oracle.
3671     /// @param _controllerName is the ENS name of the controller.
3672     /// @param _spendLimit is the initial spend limit.
3673     constructor(address _owner, bool _transferable, address _ens, bytes32 _oracleName, bytes32 _controllerName, uint _spendLimit) SpendLimit(_spendLimit) Ownable(_owner, _transferable) Controllable(_ens, _controllerName) public {
3674         _ENS = ENS(_ens);
3675         _node = _oracleName;
3676     }
3677 
3678     /// @dev Checks if the value is not zero.
3679     modifier isNotZero(uint _value) {
3680         require(_value != 0, "provided value cannot be zero");
3681         _;
3682     }
3683 
3684     /// @dev Ether can be deposited from any source, so this contract must be payable by anyone.
3685     function() public payable {
3686         //TODO question: Why is this check here, is it necessary or are we building into a corner?
3687         require(msg.data.length == 0);
3688         emit Received(msg.sender, msg.value);
3689     }
3690 
3691     /// @dev Returns the amount of an asset owned by the contract.
3692     /// @param _asset address of an ERC20 token or 0x0 for ether.
3693     /// @return balance associated with the wallet address in wei.
3694     function balance(address _asset) external view returns (uint) {
3695         if (_asset != address(0)) {
3696             return ERC20(_asset).balanceOf(this);
3697         } else {
3698             return address(this).balance;
3699         }
3700     }
3701 
3702     /// @dev This is a bulk transfer convenience function, used to migrate contracts.
3703     /// If any of the transfers fail, this will revert.
3704     /// @param _to is the recipient's address, can't be the zero (0x0) address: transfer() will revert.
3705     /// @param _assets is an array of addresses of ERC20 tokens or 0x0 for ether.
3706     function bulkTransfer(address _to, address[] _assets) public onlyOwner {
3707         // check to make sure that _assets isn't empty
3708         require(_assets.length != 0, "asset array should be non-empty");
3709         // This loops through all of the transfers to be made
3710         for (uint i = 0; i < _assets.length; i++) {
3711             uint amount;
3712             // Get amount based on whether eth or erc20
3713             if (_assets[i] == address(0)) {
3714                 amount = address(this).balance;
3715             } else {
3716                 amount = ERC20(_assets[i]).balanceOf(address(this));
3717             }
3718             // use our safe, daily limit protected transfer
3719             transfer(_to, _assets[i], amount);
3720         }
3721         emit BulkTransferred(_to, _assets);
3722     }
3723 
3724     /// @dev Transfers the specified asset to the recipient's address.
3725     /// @param _to is the recipient's address.
3726     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
3727     /// @param _amount is the amount of tokens to be transferred in base units.
3728     function transfer(address _to, address _asset, uint _amount) public onlyOwner isNotZero(_amount) {
3729         // Checks if the _to address is not the zero-address
3730         require(_to != address(0), "_to address cannot be set to 0x0");
3731 
3732         // If address is not whitelisted, take daily limit into account.
3733         if (!isWhitelisted[_to]) {
3734             // Update the available spend limit.
3735             _updateSpendAvailable();
3736             // Convert token amount to ether value.
3737             uint etherValue;
3738             bool tokenExists;
3739             if (_asset != address(0)) {
3740                 (tokenExists, etherValue) = IOracle(PublicResolver(_ENS.resolver(_node)).addr(_node)).convert(_asset, _amount);
3741             } else {
3742                 etherValue = _amount;
3743             }
3744 
3745             // If token is supported by our oracle or is ether
3746             // Check against the daily spent limit and update accordingly
3747             if (tokenExists || _asset == address(0)) {
3748                 // Require that the value is under remaining limit.
3749                 require(etherValue <= spendAvailable(), "transfer amount exceeds available spend limit");
3750                 // Update the available limit.
3751                 _setSpendAvailable(spendAvailable().sub(etherValue));
3752             }
3753         }
3754         // Transfer token or ether based on the provided address.
3755         if (_asset != address(0)) {
3756             require(ERC20(_asset).transfer(_to, _amount), "ERC20 token transfer was unsuccessful");
3757         } else {
3758             _to.transfer(_amount);
3759         }
3760         // Emit the transfer event.
3761         emit Transferred(_to, _asset, _amount);
3762     }
3763 
3764     /// @dev Checks for interface support based on ERC165.
3765     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
3766         return interfaceID == _ERC165_INTERFACE_ID;
3767     }
3768 }
3769 
3770 
3771 //// @title Asset wallet with extra security features and gas top up management.
3772 contract Wallet is Vault {
3773     event SetTopUpLimit(address _sender, uint _amount);
3774     event SubmittedTopUpLimitChange(uint _amount);
3775     event CancelledTopUpLimitChange(address _sender, uint _amount);
3776 
3777     event ToppedUpGas(address _sender, address _owner, uint _amount);
3778 
3779     using SafeMath for uint256;
3780 
3781     uint constant private MINIMUM_TOPUP_LIMIT = 1 finney; // solium-disable-line uppercase
3782     uint constant private MAXIMUM_TOPUP_LIMIT = 500 finney; // solium-disable-line uppercase
3783 
3784     uint public topUpLimit;
3785     uint private _topUpLimitDay;
3786     uint private _topUpAvailable;
3787 
3788     uint public pendingTopUpLimit;
3789     bool public submittedTopUpLimit;
3790     bool public initializedTopUpLimit;
3791 
3792     /// @dev Constructor initializes the wallet top up limit and the vault contract.
3793     /// @param _owner is the owner account of the wallet contract.
3794     /// @param _transferable indicates whether the contract ownership can be transferred.
3795     /// @param _ens is the address of the ENS.
3796     /// @param _oracleName is the ENS name of the Oracle.
3797     /// @param _controllerName is the ENS name of the Controller.
3798     /// @param _spendLimit is the initial spend limit.
3799     constructor(address _owner, bool _transferable, address _ens, bytes32 _oracleName, bytes32 _controllerName, uint _spendLimit) Vault(_owner, _transferable, _ens, _oracleName, _controllerName, _spendLimit) public {
3800         _topUpLimitDay = now;
3801         topUpLimit = MAXIMUM_TOPUP_LIMIT;
3802         _topUpAvailable = topUpLimit;
3803     }
3804 
3805     /// @dev Returns the available daily gas top up balance - accounts for daily limit reset.
3806     /// @return amount of gas in wei.
3807     function topUpAvailable() external view returns (uint) {
3808         if (now > _topUpLimitDay + 24 hours) {
3809             return topUpLimit;
3810         } else {
3811             return _topUpAvailable;
3812         }
3813     }
3814 
3815     /// @dev Initialize a daily gas top up limit.
3816     /// @param _amount is the gas top up amount in wei.
3817     function initializeTopUpLimit(uint _amount) external onlyOwner {
3818         // Require that the top up limit has not been initialized.
3819         require(!initializedTopUpLimit, "top up limit has already been initialized");
3820         // Require that the limit amount is within the acceptable range.
3821         require(MINIMUM_TOPUP_LIMIT <= _amount && _amount <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside of the min/max range");
3822         // Modify spend limit based on the provided value.
3823         _modifyTopUpLimit(_amount);
3824         // Flag operation as initialized.
3825         initializedTopUpLimit = true;
3826         // Emit the set limit event.
3827         emit SetTopUpLimit(msg.sender, _amount);
3828     }
3829 
3830     /// @dev Set a daily top up top up limit.
3831     /// @param _amount is the daily top up limit amount in wei.
3832     function submitTopUpLimit(uint _amount) external onlyOwner {
3833         // Require that the top up limit has been initialized.
3834         require(initializedTopUpLimit, "top up limit has not been initialized");
3835         // Require that the limit amount is within the acceptable range.
3836         require(MINIMUM_TOPUP_LIMIT <= _amount && _amount <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside of the min/max range");
3837         // Assign the provided amount to pending daily limit change.
3838         pendingTopUpLimit = _amount;
3839         // Flag the operation as submitted.
3840         submittedTopUpLimit = true;
3841         // Emit the submission event.
3842         emit SubmittedTopUpLimitChange(_amount);
3843     }
3844 
3845     /// @dev Confirm pending set top up limit operation.
3846     function confirmTopUpLimit(uint _amount) external onlyController {
3847         // Require that the operation has been submitted.
3848         require(submittedTopUpLimit, "top up limit has not been submitted");
3849         // Assert that the pending top up limit amount is within the acceptable range.
3850         require(MINIMUM_TOPUP_LIMIT <= pendingTopUpLimit && pendingTopUpLimit <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside the min/max range");
3851         // Assert that confirmed and pending topup limit are the same.
3852         require(_amount == pendingTopUpLimit, "confirmed and pending topup limit are not same");
3853         // Modify top up limit based on the pending value.
3854         _modifyTopUpLimit(pendingTopUpLimit);
3855         // Emit the set limit event.
3856         emit SetTopUpLimit(msg.sender, pendingTopUpLimit);
3857         // Reset pending daily limit.
3858         pendingTopUpLimit = 0;
3859         // Reset the submission flag.
3860         submittedTopUpLimit = false;
3861     }
3862 
3863     /// @dev Cancel pending set top up limit operation.
3864     function cancelTopUpLimit(uint _amount) external onlyController {
3865         // Make sure a topup limit update has been submitted
3866         require(submittedTopUpLimit, "a topup limit has to be submitted");
3867         // Require that pending and confirmed spend limit are the same
3868         require(pendingTopUpLimit == _amount, "pending and cancelled top up limits dont match");
3869         // Reset pending daily limit.
3870         pendingTopUpLimit = 0;
3871         // Reset the submitted operation flag.
3872         submittedTopUpLimit = false;
3873         // Emit the cancellation event.
3874         emit CancelledTopUpLimitChange(msg.sender, _amount);
3875     }
3876 
3877     /// @dev Refill owner's gas balance.
3878     /// @dev Revert if the transaction amount is too large
3879     /// @param _amount is the amount of ether to transfer to the owner account in wei.
3880     function topUpGas(uint _amount) external isNotZero(_amount) {
3881         // Require that the sender is either the owner or a controller.
3882         require(_isOwner() || _isController(msg.sender), "sender is neither an owner nor a controller");
3883         // Account for the top up limit daily reset.
3884         _updateTopUpAvailable();
3885         // Make sure the available top up amount is not zero.
3886         require(_topUpAvailable != 0, "available top up limit cannot be zero");
3887         // Fail if there isn't enough in the daily top up limit to perform topUp
3888         require(_amount <= _topUpAvailable, "available top up limit less than amount passed in");
3889         // Reduce the top up amount from available balance and transfer corresponding
3890         // ether to the owner's account.
3891         _topUpAvailable = _topUpAvailable.sub(_amount);
3892         owner().transfer(_amount);
3893         // Emit the gas top up event.
3894         emit ToppedUpGas(tx.origin, owner(), _amount);
3895     }
3896 
3897     /// @dev Modify the top up limit and top up available based on the provided value.
3898     /// @dev _amount is the daily limit amount in wei.
3899     function _modifyTopUpLimit(uint _amount) private {
3900         // Account for the top up limit daily reset.
3901         _updateTopUpAvailable();
3902         // Set the daily limit to the provided amount.
3903         topUpLimit = _amount;
3904         // Lower the available limit if it's higher than the new daily limit.
3905         if (_topUpAvailable > topUpLimit) {
3906             _topUpAvailable = topUpLimit;
3907         }
3908     }
3909 
3910     /// @dev Update available top up limit based on the daily reset.
3911     function _updateTopUpAvailable() private {
3912         if (now > _topUpLimitDay.add(24 hours)) {
3913             // Advance the current day by how many days have passed.
3914             uint extraDays = now.sub(_topUpLimitDay).div(24 hours);
3915             _topUpLimitDay = _topUpLimitDay.add(extraDays.mul(24 hours));
3916             // Set the available limit to the current top up limit.
3917             _topUpAvailable = topUpLimit;
3918         }
3919     }
3920 }