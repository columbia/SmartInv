1 // File: contracts/lib/interface/ICelerWallet.sol
2 
3 pragma solidity ^0.5.1;
4 
5 /**
6  * @title CelerWallet interface
7  */
8 interface ICelerWallet {
9     function create(address[] calldata _owners, address _operator, bytes32 _nonce) external returns(bytes32);
10 
11     function depositETH(bytes32 _walletId) external payable;
12 
13     function depositERC20(bytes32 _walletId, address _tokenAddress, uint _amount) external;
14     
15     function withdraw(bytes32 _walletId, address _tokenAddress, address _receiver, uint _amount) external;
16 
17     function transferToWallet(bytes32 _fromWalletId, bytes32 _toWalletId, address _tokenAddress, address _receiver, uint _amount) external;
18 
19     function transferOperatorship(bytes32 _walletId, address _newOperator) external;
20 
21     function proposeNewOperator(bytes32 _walletId, address _newOperator) external;
22 
23     function drainToken(address _tokenAddress, address _receiver, uint _amount) external;
24 
25     function getWalletOwners(bytes32 _walletId) external view returns(address[] memory);
26 
27     function getOperator(bytes32 _walletId) external view returns(address);
28 
29     function getBalance(bytes32 _walletId, address _tokenAddress) external view returns(uint);
30 
31     function getProposedNewOperator(bytes32 _walletId) external view returns(address);
32 
33     function getProposalVote(bytes32 _walletId, address _owner) external view returns(bool);
34 
35     event CreateWallet(bytes32 indexed walletId, address[] indexed owners, address indexed operator);
36 
37     event DepositToWallet(bytes32 indexed walletId, address indexed tokenAddress, uint amount);
38 
39     event WithdrawFromWallet(bytes32 indexed walletId, address indexed tokenAddress, address indexed receiver, uint amount);
40 
41     event TransferToWallet(bytes32 indexed fromWalletId, bytes32 indexed toWalletId, address indexed tokenAddress, address receiver, uint amount);
42 
43     event ChangeOperator(bytes32 indexed walletId, address indexed oldOperator, address indexed newOperator);
44 
45     event ProposeNewOperator(bytes32 indexed walletId, address indexed newOperator, address indexed proposer);
46 
47     event DrainToken(address indexed tokenAddress, address indexed receiver, uint amount);
48 }
49 
50 // File: contracts/lib/interface/IEthPool.sol
51 
52 pragma solidity ^0.5.1;
53 
54 /**
55  * @title EthPool interface
56  */
57 interface IEthPool {
58     function deposit(address _receiver) external payable;
59 
60     function withdraw(uint _value) external;
61 
62     function approve(address _spender, uint _value) external returns (bool);
63 
64     function transferFrom(address _from, address payable _to, uint _value) external returns (bool);
65 
66     function transferToCelerWallet(address _from, address _walletAddr, bytes32 _walletId, uint _value) external returns (bool);
67 
68     function increaseAllowance(address _spender, uint _addedValue) external returns (bool);
69 
70     function decreaseAllowance(address _spender, uint _subtractedValue) external returns (bool);
71 
72     function balanceOf(address _owner) external view returns (uint);
73 
74     function allowance(address _owner, address _spender) external view returns (uint);
75 
76     event Deposit(address indexed receiver, uint value);
77     
78     // transfer from "from" account inside EthPool to real "to" address outside EthPool
79     event Transfer(address indexed from, address indexed to, uint value);
80     
81     event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 
84 // File: contracts/lib/interface/IPayRegistry.sol
85 
86 pragma solidity ^0.5.1;
87 
88 /**
89  * @title PayRegistry interface
90  */
91 interface IPayRegistry {
92     function calculatePayId(bytes32 _payHash, address _setter) external pure returns(bytes32);
93 
94     function setPayAmount(bytes32 _payHash, uint _amt) external;
95 
96     function setPayDeadline(bytes32 _payHash, uint _deadline) external;
97 
98     function setPayInfo(bytes32 _payHash, uint _amt, uint _deadline) external;
99 
100     function setPayAmounts(bytes32[] calldata _payHashes, uint[] calldata _amts) external;
101 
102     function setPayDeadlines(bytes32[] calldata _payHashes, uint[] calldata _deadlines) external;
103 
104     function setPayInfos(bytes32[] calldata _payHashes, uint[] calldata _amts, uint[] calldata _deadlines) external;
105 
106     function getPayAmounts(
107         bytes32[] calldata _payIds,
108         uint _lastPayResolveDeadline
109     ) external view returns(uint[] memory);
110 
111     function getPayInfo(bytes32 _payId) external view returns(uint, uint);
112 
113     event PayInfoUpdate(bytes32 indexed payId, uint amount, uint resolveDeadline);
114 }
115 
116 // File: contracts/lib/data/Pb.sol
117 
118 pragma solidity ^0.5.0;
119 
120 // runtime proto sol library
121 library Pb {
122     enum WireType { Varint, Fixed64, LengthDelim, StartGroup, EndGroup, Fixed32 }
123 
124     struct Buffer {
125         uint idx;  // the start index of next read. when idx=b.length, we're done
126         bytes b;   // hold serialized proto msg, readonly
127     }
128 
129     // create a new in-memory Buffer object from raw msg bytes
130     function fromBytes(bytes memory raw) internal pure returns (Buffer memory buf) {
131         buf.b = raw;
132         buf.idx = 0;
133     }
134 
135     // whether there are unread bytes
136     function hasMore(Buffer memory buf) internal pure returns (bool) {
137         return buf.idx < buf.b.length;
138     }
139 
140     // decode current field number and wiretype
141     function decKey(Buffer memory buf) internal pure returns (uint tag, WireType wiretype) {
142         uint v = decVarint(buf);
143         tag = v / 8;
144         wiretype = WireType(v & 7);
145     }
146 
147     // count tag occurrences, return an array due to no memory map support
148 	// have to create array for (maxtag+1) size. cnts[tag] = occurrences
149 	// should keep buf.idx unchanged because this is only a count function
150     function cntTags(Buffer memory buf, uint maxtag) internal pure returns (uint[] memory cnts) {
151         uint originalIdx = buf.idx;
152         cnts = new uint[](maxtag+1);  // protobuf's tags are from 1 rather than 0
153         uint tag;
154         WireType wire;
155         while (hasMore(buf)) {
156             (tag, wire) = decKey(buf);
157             cnts[tag] += 1;
158             skipValue(buf, wire);
159         }
160         buf.idx = originalIdx;
161     }
162 
163     // read varint from current buf idx, move buf.idx to next read, return the int value
164     function decVarint(Buffer memory buf) internal pure returns (uint v) {
165         bytes10 tmp;  // proto int is at most 10 bytes (7 bits can be used per byte)
166         bytes memory bb = buf.b;  // get buf.b mem addr to use in assembly
167         v = buf.idx;  // use v to save one additional uint variable
168         assembly {
169             tmp := mload(add(add(bb, 32), v)) // load 10 bytes from buf.b[buf.idx] to tmp
170         }
171         uint b; // store current byte content
172         v = 0; // reset to 0 for return value
173         for (uint i=0; i<10; i++) {
174             assembly {
175                 b := byte(i, tmp)  // don't use tmp[i] because it does bound check and costs extra
176             }
177             v |= (b & 0x7F) << (i * 7);
178             if (b & 0x80 == 0) {
179                 buf.idx += i + 1;
180                 return v;
181             }
182         }
183         revert(); // i=10, invalid varint stream
184     }
185 
186     // read length delimited field and return bytes
187     function decBytes(Buffer memory buf) internal pure returns (bytes memory b) {
188         uint len = decVarint(buf);
189         uint end = buf.idx + len;
190         require(end <= buf.b.length);  // avoid overflow
191         b = new bytes(len);
192         bytes memory bufB = buf.b;  // get buf.b mem addr to use in assembly
193         uint bStart;
194         uint bufBStart = buf.idx;
195         assembly {
196             bStart := add(b, 32)
197             bufBStart := add(add(bufB, 32), bufBStart)
198         }
199         for (uint i=0; i<len; i+=32) {
200             assembly{
201                 mstore(add(bStart, i), mload(add(bufBStart, i)))
202             }
203         }
204         buf.idx = end;
205     }
206 
207     // return packed ints
208     function decPacked(Buffer memory buf) internal pure returns (uint[] memory t) {
209         uint len = decVarint(buf);
210         uint end = buf.idx + len;
211         require(end <= buf.b.length);  // avoid overflow
212         // array in memory must be init w/ known length
213         // so we have to create a tmp array w/ max possible len first
214         uint[] memory tmp = new uint[](len);
215         uint i = 0; // count how many ints are there
216         while (buf.idx < end) {
217             tmp[i] = decVarint(buf);
218             i++;
219         }
220         t = new uint[](i); // init t with correct length
221         for (uint j=0; j<i; j++) {
222             t[j] = tmp[j];
223         }
224         return t;
225     }
226 
227     // move idx pass current value field, to beginning of next tag or msg end
228     function skipValue(Buffer memory buf, WireType wire) internal pure {
229         if (wire == WireType.Varint) { decVarint(buf); }
230         else if (wire == WireType.LengthDelim) {
231             uint len = decVarint(buf);
232             buf.idx += len; // skip len bytes value data
233             require(buf.idx <= buf.b.length);  // avoid overflow
234         } else { revert(); }  // unsupported wiretype
235     }
236 
237     // type conversion help utils
238     function _bool(uint x) internal pure returns (bool v) {
239         return x != 0;
240     }
241 
242     function _uint256(bytes memory b) internal pure returns (uint256 v) {
243         require(b.length <= 32);  // b's length must be smaller than or equal to 32
244         assembly { v := mload(add(b, 32)) }  // load all 32bytes to v
245         v = v >> (8 * (32 - b.length));  // only first b.length is valid
246     }
247 
248     function _address(bytes memory b) internal pure returns (address v) {
249         v = _addressPayable(b);
250     }
251 
252     function _addressPayable(bytes memory b) internal pure returns (address payable v) {
253         require(b.length == 20);
254         //load 32bytes then shift right 12 bytes
255         assembly { v := div(mload(add(b, 32)), 0x1000000000000000000000000) }
256     }
257 
258     function _bytes32(bytes memory b) internal pure returns (bytes32 v) {
259         require(b.length == 32);
260         assembly { v := mload(add(b, 32)) }
261     }
262 
263     // uint[] to uint8[]
264     function uint8s(uint[] memory arr) internal pure returns (uint8[] memory t) {
265         t = new uint8[](arr.length);
266         for (uint i = 0; i < t.length; i++) { t[i] = uint8(arr[i]); }
267     }
268 
269     function uint32s(uint[] memory arr) internal pure returns (uint32[] memory t) {
270         t = new uint32[](arr.length);
271         for (uint i = 0; i < t.length; i++) { t[i] = uint32(arr[i]); }
272     }
273 
274     function uint64s(uint[] memory arr) internal pure returns (uint64[] memory t) {
275         t = new uint64[](arr.length);
276         for (uint i = 0; i < t.length; i++) { t[i] = uint64(arr[i]); }
277     }
278 
279     function bools(uint[] memory arr) internal pure returns (bool[] memory t) {
280         t = new bool[](arr.length);
281         for (uint i = 0; i < t.length; i++) { t[i] = arr[i]!=0; }
282     }
283 }
284 
285 // File: contracts/lib/data/PbEntity.sol
286 
287 // Code generated by protoc-gen-sol. DO NOT EDIT.
288 // source: entity.proto
289 pragma solidity ^0.5.0;
290 
291 
292 library PbEntity {
293     using Pb for Pb.Buffer;  // so we can call Pb funcs on Buffer obj
294 
295     enum TokenType { INVALID, ETH, ERC20 }
296 
297     // TokenType[] decode function
298     function TokenTypes(uint[] memory arr) internal pure returns (TokenType[] memory t) {
299         t = new TokenType[](arr.length);
300         for (uint i = 0; i < t.length; i++) { t[i] = TokenType(arr[i]); }
301     }
302 
303     enum TransferFunctionType { BOOLEAN_AND, BOOLEAN_OR, BOOLEAN_CIRCUIT, NUMERIC_ADD, NUMERIC_MAX, NUMERIC_MIN }
304 
305     // TransferFunctionType[] decode function
306     function TransferFunctionTypes(uint[] memory arr) internal pure returns (TransferFunctionType[] memory t) {
307         t = new TransferFunctionType[](arr.length);
308         for (uint i = 0; i < t.length; i++) { t[i] = TransferFunctionType(arr[i]); }
309     }
310 
311     enum ConditionType { HASH_LOCK, DEPLOYED_CONTRACT, VIRTUAL_CONTRACT }
312 
313     // ConditionType[] decode function
314     function ConditionTypes(uint[] memory arr) internal pure returns (ConditionType[] memory t) {
315         t = new ConditionType[](arr.length);
316         for (uint i = 0; i < t.length; i++) { t[i] = ConditionType(arr[i]); }
317     }
318 
319     struct AccountAmtPair {
320         address account;   // tag: 1
321         uint256 amt;   // tag: 2
322     } // end struct AccountAmtPair
323 
324     function decAccountAmtPair(bytes memory raw) internal pure returns (AccountAmtPair memory m) {
325         Pb.Buffer memory buf = Pb.fromBytes(raw);
326 
327         uint tag;
328         Pb.WireType wire;
329         while (buf.hasMore()) {
330             (tag, wire) = buf.decKey();
331             if (false) {} // solidity has no switch/case
332             else if (tag == 1) {
333                 m.account = Pb._address(buf.decBytes());
334             }
335             else if (tag == 2) {
336                 m.amt = Pb._uint256(buf.decBytes());
337             }
338             else { buf.skipValue(wire); } // skip value of unknown tag
339         }
340     } // end decoder AccountAmtPair
341 
342     struct TokenInfo {
343         TokenType tokenType;   // tag: 1
344         address tokenAddress;   // tag: 2
345     } // end struct TokenInfo
346 
347     function decTokenInfo(bytes memory raw) internal pure returns (TokenInfo memory m) {
348         Pb.Buffer memory buf = Pb.fromBytes(raw);
349 
350         uint tag;
351         Pb.WireType wire;
352         while (buf.hasMore()) {
353             (tag, wire) = buf.decKey();
354             if (false) {} // solidity has no switch/case
355             else if (tag == 1) {
356                 m.tokenType = TokenType(buf.decVarint());
357             }
358             else if (tag == 2) {
359                 m.tokenAddress = Pb._address(buf.decBytes());
360             }
361             else { buf.skipValue(wire); } // skip value of unknown tag
362         }
363     } // end decoder TokenInfo
364 
365     struct TokenDistribution {
366         TokenInfo token;   // tag: 1
367         AccountAmtPair[] distribution;   // tag: 2
368     } // end struct TokenDistribution
369 
370     function decTokenDistribution(bytes memory raw) internal pure returns (TokenDistribution memory m) {
371         Pb.Buffer memory buf = Pb.fromBytes(raw);
372 
373         uint[] memory cnts = buf.cntTags(2);
374         m.distribution = new AccountAmtPair[](cnts[2]);
375         cnts[2] = 0;  // reset counter for later use
376         
377         uint tag;
378         Pb.WireType wire;
379         while (buf.hasMore()) {
380             (tag, wire) = buf.decKey();
381             if (false) {} // solidity has no switch/case
382             else if (tag == 1) {
383                 m.token = decTokenInfo(buf.decBytes());
384             }
385             else if (tag == 2) {
386                 m.distribution[cnts[2]] = decAccountAmtPair(buf.decBytes());
387                 cnts[2]++;
388             }
389             else { buf.skipValue(wire); } // skip value of unknown tag
390         }
391     } // end decoder TokenDistribution
392 
393     struct TokenTransfer {
394         TokenInfo token;   // tag: 1
395         AccountAmtPair receiver;   // tag: 2
396     } // end struct TokenTransfer
397 
398     function decTokenTransfer(bytes memory raw) internal pure returns (TokenTransfer memory m) {
399         Pb.Buffer memory buf = Pb.fromBytes(raw);
400 
401         uint tag;
402         Pb.WireType wire;
403         while (buf.hasMore()) {
404             (tag, wire) = buf.decKey();
405             if (false) {} // solidity has no switch/case
406             else if (tag == 1) {
407                 m.token = decTokenInfo(buf.decBytes());
408             }
409             else if (tag == 2) {
410                 m.receiver = decAccountAmtPair(buf.decBytes());
411             }
412             else { buf.skipValue(wire); } // skip value of unknown tag
413         }
414     } // end decoder TokenTransfer
415 
416     struct SimplexPaymentChannel {
417         bytes32 channelId;   // tag: 1
418         address peerFrom;   // tag: 2
419         uint seqNum;   // tag: 3
420         TokenTransfer transferToPeer;   // tag: 4
421         PayIdList pendingPayIds;   // tag: 5
422         uint lastPayResolveDeadline;   // tag: 6
423         uint256 totalPendingAmount;   // tag: 7
424     } // end struct SimplexPaymentChannel
425 
426     function decSimplexPaymentChannel(bytes memory raw) internal pure returns (SimplexPaymentChannel memory m) {
427         Pb.Buffer memory buf = Pb.fromBytes(raw);
428 
429         uint tag;
430         Pb.WireType wire;
431         while (buf.hasMore()) {
432             (tag, wire) = buf.decKey();
433             if (false) {} // solidity has no switch/case
434             else if (tag == 1) {
435                 m.channelId = Pb._bytes32(buf.decBytes());
436             }
437             else if (tag == 2) {
438                 m.peerFrom = Pb._address(buf.decBytes());
439             }
440             else if (tag == 3) {
441                 m.seqNum = uint(buf.decVarint());
442             }
443             else if (tag == 4) {
444                 m.transferToPeer = decTokenTransfer(buf.decBytes());
445             }
446             else if (tag == 5) {
447                 m.pendingPayIds = decPayIdList(buf.decBytes());
448             }
449             else if (tag == 6) {
450                 m.lastPayResolveDeadline = uint(buf.decVarint());
451             }
452             else if (tag == 7) {
453                 m.totalPendingAmount = Pb._uint256(buf.decBytes());
454             }
455             else { buf.skipValue(wire); } // skip value of unknown tag
456         }
457     } // end decoder SimplexPaymentChannel
458 
459     struct PayIdList {
460         bytes32[] payIds;   // tag: 1
461         bytes32 nextListHash;   // tag: 2
462     } // end struct PayIdList
463 
464     function decPayIdList(bytes memory raw) internal pure returns (PayIdList memory m) {
465         Pb.Buffer memory buf = Pb.fromBytes(raw);
466 
467         uint[] memory cnts = buf.cntTags(2);
468         m.payIds = new bytes32[](cnts[1]);
469         cnts[1] = 0;  // reset counter for later use
470         
471         uint tag;
472         Pb.WireType wire;
473         while (buf.hasMore()) {
474             (tag, wire) = buf.decKey();
475             if (false) {} // solidity has no switch/case
476             else if (tag == 1) {
477                 m.payIds[cnts[1]] = Pb._bytes32(buf.decBytes());
478                 cnts[1]++;
479             }
480             else if (tag == 2) {
481                 m.nextListHash = Pb._bytes32(buf.decBytes());
482             }
483             else { buf.skipValue(wire); } // skip value of unknown tag
484         }
485     } // end decoder PayIdList
486 
487     struct TransferFunction {
488         TransferFunctionType logicType;   // tag: 1
489         TokenTransfer maxTransfer;   // tag: 2
490     } // end struct TransferFunction
491 
492     function decTransferFunction(bytes memory raw) internal pure returns (TransferFunction memory m) {
493         Pb.Buffer memory buf = Pb.fromBytes(raw);
494 
495         uint tag;
496         Pb.WireType wire;
497         while (buf.hasMore()) {
498             (tag, wire) = buf.decKey();
499             if (false) {} // solidity has no switch/case
500             else if (tag == 1) {
501                 m.logicType = TransferFunctionType(buf.decVarint());
502             }
503             else if (tag == 2) {
504                 m.maxTransfer = decTokenTransfer(buf.decBytes());
505             }
506             else { buf.skipValue(wire); } // skip value of unknown tag
507         }
508     } // end decoder TransferFunction
509 
510     struct ConditionalPay {
511         uint payTimestamp;   // tag: 1
512         address src;   // tag: 2
513         address dest;   // tag: 3
514         Condition[] conditions;   // tag: 4
515         TransferFunction transferFunc;   // tag: 5
516         uint resolveDeadline;   // tag: 6
517         uint resolveTimeout;   // tag: 7
518         address payResolver;   // tag: 8
519     } // end struct ConditionalPay
520 
521     function decConditionalPay(bytes memory raw) internal pure returns (ConditionalPay memory m) {
522         Pb.Buffer memory buf = Pb.fromBytes(raw);
523 
524         uint[] memory cnts = buf.cntTags(8);
525         m.conditions = new Condition[](cnts[4]);
526         cnts[4] = 0;  // reset counter for later use
527         
528         uint tag;
529         Pb.WireType wire;
530         while (buf.hasMore()) {
531             (tag, wire) = buf.decKey();
532             if (false) {} // solidity has no switch/case
533             else if (tag == 1) {
534                 m.payTimestamp = uint(buf.decVarint());
535             }
536             else if (tag == 2) {
537                 m.src = Pb._address(buf.decBytes());
538             }
539             else if (tag == 3) {
540                 m.dest = Pb._address(buf.decBytes());
541             }
542             else if (tag == 4) {
543                 m.conditions[cnts[4]] = decCondition(buf.decBytes());
544                 cnts[4]++;
545             }
546             else if (tag == 5) {
547                 m.transferFunc = decTransferFunction(buf.decBytes());
548             }
549             else if (tag == 6) {
550                 m.resolveDeadline = uint(buf.decVarint());
551             }
552             else if (tag == 7) {
553                 m.resolveTimeout = uint(buf.decVarint());
554             }
555             else if (tag == 8) {
556                 m.payResolver = Pb._address(buf.decBytes());
557             }
558             else { buf.skipValue(wire); } // skip value of unknown tag
559         }
560     } // end decoder ConditionalPay
561 
562     struct CondPayResult {
563         bytes condPay;   // tag: 1
564         uint256 amount;   // tag: 2
565     } // end struct CondPayResult
566 
567     function decCondPayResult(bytes memory raw) internal pure returns (CondPayResult memory m) {
568         Pb.Buffer memory buf = Pb.fromBytes(raw);
569 
570         uint tag;
571         Pb.WireType wire;
572         while (buf.hasMore()) {
573             (tag, wire) = buf.decKey();
574             if (false) {} // solidity has no switch/case
575             else if (tag == 1) {
576                 m.condPay = bytes(buf.decBytes());
577             }
578             else if (tag == 2) {
579                 m.amount = Pb._uint256(buf.decBytes());
580             }
581             else { buf.skipValue(wire); } // skip value of unknown tag
582         }
583     } // end decoder CondPayResult
584 
585     struct VouchedCondPayResult {
586         bytes condPayResult;   // tag: 1
587         bytes sigOfSrc;   // tag: 2
588         bytes sigOfDest;   // tag: 3
589     } // end struct VouchedCondPayResult
590 
591     function decVouchedCondPayResult(bytes memory raw) internal pure returns (VouchedCondPayResult memory m) {
592         Pb.Buffer memory buf = Pb.fromBytes(raw);
593 
594         uint tag;
595         Pb.WireType wire;
596         while (buf.hasMore()) {
597             (tag, wire) = buf.decKey();
598             if (false) {} // solidity has no switch/case
599             else if (tag == 1) {
600                 m.condPayResult = bytes(buf.decBytes());
601             }
602             else if (tag == 2) {
603                 m.sigOfSrc = bytes(buf.decBytes());
604             }
605             else if (tag == 3) {
606                 m.sigOfDest = bytes(buf.decBytes());
607             }
608             else { buf.skipValue(wire); } // skip value of unknown tag
609         }
610     } // end decoder VouchedCondPayResult
611 
612     struct Condition {
613         ConditionType conditionType;   // tag: 1
614         bytes32 hashLock;   // tag: 2
615         address deployedContractAddress;   // tag: 3
616         bytes32 virtualContractAddress;   // tag: 4
617         bytes argsQueryFinalization;   // tag: 5
618         bytes argsQueryOutcome;   // tag: 6
619     } // end struct Condition
620 
621     function decCondition(bytes memory raw) internal pure returns (Condition memory m) {
622         Pb.Buffer memory buf = Pb.fromBytes(raw);
623 
624         uint tag;
625         Pb.WireType wire;
626         while (buf.hasMore()) {
627             (tag, wire) = buf.decKey();
628             if (false) {} // solidity has no switch/case
629             else if (tag == 1) {
630                 m.conditionType = ConditionType(buf.decVarint());
631             }
632             else if (tag == 2) {
633                 m.hashLock = Pb._bytes32(buf.decBytes());
634             }
635             else if (tag == 3) {
636                 m.deployedContractAddress = Pb._address(buf.decBytes());
637             }
638             else if (tag == 4) {
639                 m.virtualContractAddress = Pb._bytes32(buf.decBytes());
640             }
641             else if (tag == 5) {
642                 m.argsQueryFinalization = bytes(buf.decBytes());
643             }
644             else if (tag == 6) {
645                 m.argsQueryOutcome = bytes(buf.decBytes());
646             }
647             else { buf.skipValue(wire); } // skip value of unknown tag
648         }
649     } // end decoder Condition
650 
651     struct CooperativeWithdrawInfo {
652         bytes32 channelId;   // tag: 1
653         uint seqNum;   // tag: 2
654         AccountAmtPair withdraw;   // tag: 3
655         uint withdrawDeadline;   // tag: 4
656         bytes32 recipientChannelId;   // tag: 5
657     } // end struct CooperativeWithdrawInfo
658 
659     function decCooperativeWithdrawInfo(bytes memory raw) internal pure returns (CooperativeWithdrawInfo memory m) {
660         Pb.Buffer memory buf = Pb.fromBytes(raw);
661 
662         uint tag;
663         Pb.WireType wire;
664         while (buf.hasMore()) {
665             (tag, wire) = buf.decKey();
666             if (false) {} // solidity has no switch/case
667             else if (tag == 1) {
668                 m.channelId = Pb._bytes32(buf.decBytes());
669             }
670             else if (tag == 2) {
671                 m.seqNum = uint(buf.decVarint());
672             }
673             else if (tag == 3) {
674                 m.withdraw = decAccountAmtPair(buf.decBytes());
675             }
676             else if (tag == 4) {
677                 m.withdrawDeadline = uint(buf.decVarint());
678             }
679             else if (tag == 5) {
680                 m.recipientChannelId = Pb._bytes32(buf.decBytes());
681             }
682             else { buf.skipValue(wire); } // skip value of unknown tag
683         }
684     } // end decoder CooperativeWithdrawInfo
685 
686     struct PaymentChannelInitializer {
687         TokenDistribution initDistribution;   // tag: 1
688         uint openDeadline;   // tag: 2
689         uint disputeTimeout;   // tag: 3
690         uint msgValueReceiver;   // tag: 4
691     } // end struct PaymentChannelInitializer
692 
693     function decPaymentChannelInitializer(bytes memory raw) internal pure returns (PaymentChannelInitializer memory m) {
694         Pb.Buffer memory buf = Pb.fromBytes(raw);
695 
696         uint tag;
697         Pb.WireType wire;
698         while (buf.hasMore()) {
699             (tag, wire) = buf.decKey();
700             if (false) {} // solidity has no switch/case
701             else if (tag == 1) {
702                 m.initDistribution = decTokenDistribution(buf.decBytes());
703             }
704             else if (tag == 2) {
705                 m.openDeadline = uint(buf.decVarint());
706             }
707             else if (tag == 3) {
708                 m.disputeTimeout = uint(buf.decVarint());
709             }
710             else if (tag == 4) {
711                 m.msgValueReceiver = uint(buf.decVarint());
712             }
713             else { buf.skipValue(wire); } // skip value of unknown tag
714         }
715     } // end decoder PaymentChannelInitializer
716 
717     struct CooperativeSettleInfo {
718         bytes32 channelId;   // tag: 1
719         uint seqNum;   // tag: 2
720         AccountAmtPair[] settleBalance;   // tag: 3
721         uint settleDeadline;   // tag: 4
722     } // end struct CooperativeSettleInfo
723 
724     function decCooperativeSettleInfo(bytes memory raw) internal pure returns (CooperativeSettleInfo memory m) {
725         Pb.Buffer memory buf = Pb.fromBytes(raw);
726 
727         uint[] memory cnts = buf.cntTags(4);
728         m.settleBalance = new AccountAmtPair[](cnts[3]);
729         cnts[3] = 0;  // reset counter for later use
730         
731         uint tag;
732         Pb.WireType wire;
733         while (buf.hasMore()) {
734             (tag, wire) = buf.decKey();
735             if (false) {} // solidity has no switch/case
736             else if (tag == 1) {
737                 m.channelId = Pb._bytes32(buf.decBytes());
738             }
739             else if (tag == 2) {
740                 m.seqNum = uint(buf.decVarint());
741             }
742             else if (tag == 3) {
743                 m.settleBalance[cnts[3]] = decAccountAmtPair(buf.decBytes());
744                 cnts[3]++;
745             }
746             else if (tag == 4) {
747                 m.settleDeadline = uint(buf.decVarint());
748             }
749             else { buf.skipValue(wire); } // skip value of unknown tag
750         }
751     } // end decoder CooperativeSettleInfo
752 
753     struct ChannelMigrationInfo {
754         bytes32 channelId;   // tag: 1
755         address fromLedgerAddress;   // tag: 2
756         address toLedgerAddress;   // tag: 3
757         uint migrationDeadline;   // tag: 4
758     } // end struct ChannelMigrationInfo
759 
760     function decChannelMigrationInfo(bytes memory raw) internal pure returns (ChannelMigrationInfo memory m) {
761         Pb.Buffer memory buf = Pb.fromBytes(raw);
762 
763         uint tag;
764         Pb.WireType wire;
765         while (buf.hasMore()) {
766             (tag, wire) = buf.decKey();
767             if (false) {} // solidity has no switch/case
768             else if (tag == 1) {
769                 m.channelId = Pb._bytes32(buf.decBytes());
770             }
771             else if (tag == 2) {
772                 m.fromLedgerAddress = Pb._address(buf.decBytes());
773             }
774             else if (tag == 3) {
775                 m.toLedgerAddress = Pb._address(buf.decBytes());
776             }
777             else if (tag == 4) {
778                 m.migrationDeadline = uint(buf.decVarint());
779             }
780             else { buf.skipValue(wire); } // skip value of unknown tag
781         }
782     } // end decoder ChannelMigrationInfo
783 
784 }
785 
786 // File: contracts/lib/ledgerlib/LedgerStruct.sol
787 
788 pragma solidity ^0.5.1;
789 
790 
791 
792 
793 
794 /**
795  * @title Ledger Struct Library
796  * @notice CelerLedger library defining all used structs
797  */
798 library LedgerStruct {
799     enum ChannelStatus { Uninitialized, Operable, Settling, Closed, Migrated }
800 
801     struct PeerState {
802         uint seqNum;
803         // balance sent out to the other peer of the channel, no need to record amtIn
804         uint transferOut;
805         bytes32 nextPayIdListHash;
806         uint lastPayResolveDeadline;
807         uint pendingPayOut;
808     }
809 
810     struct PeerProfile {
811         address peerAddr;
812         // the (monotone increasing) amount that this peer deposit into this channel
813         uint deposit;
814         // the (monotone increasing) amount that this peer withdraw from this channel
815         uint withdrawal;
816         PeerState state;
817     }
818 
819     struct WithdrawIntent {
820         address receiver;
821         uint amount;
822         uint requestTime;
823         bytes32 recipientChannelId;
824     }
825 
826     // Channel is a representation of the state channel between peers which puts the funds
827     // in CelerWallet and is hosted by a CelerLedger. The status of a state channel can
828     // be migrated from one CelerLedger instance to another CelerLedger instance with probably
829     // different operation logic.
830     struct Channel {
831         // the time after which peers can confirmSettle and before which peers can intendSettle
832         uint settleFinalizedTime;
833         uint disputeTimeout;
834         PbEntity.TokenInfo token;
835         ChannelStatus status;
836         // record the new CelerLedger address after channel migration
837         address migratedTo;
838         // only support 2-peer channel for now
839         PeerProfile[2] peerProfiles;
840         uint cooperativeWithdrawSeqNum;
841         WithdrawIntent withdrawIntent;
842     }
843 
844     // Ledger is a host to record and operate the activities of many state
845     // channels with specific operation logic.
846     struct Ledger {
847         // ChannelStatus => number of channels
848         mapping(uint => uint) channelStatusNums;
849         IEthPool ethPool;
850         IPayRegistry payRegistry;
851         ICelerWallet celerWallet;
852         // per channel deposit limits for different tokens
853         mapping(address => uint) balanceLimits;
854         // whether deposit limits of all tokens have been enabled
855         bool balanceLimitsEnabled;
856         mapping(bytes32 => Channel) channelMap;
857     }
858 }
859 
860 // File: contracts/lib/interface/ICelerLedger.sol
861 
862 pragma solidity ^0.5.1;
863 
864 
865 
866 /**
867  * @title CelerLedger interface
868  * @dev any changes in this interface must be synchronized to corresponding libraries
869  * @dev events in this interface must be exactly same in corresponding used libraries
870  */
871 interface ICelerLedger {
872     /********** LedgerOperation related functions and events **********/
873     function openChannel(bytes calldata _openChannelRequest) external payable;
874 
875     function deposit(bytes32 _channelId, address _receiver, uint _transferFromAmount) external payable;
876 
877     function depositInBatch(
878         bytes32[] calldata _channelIds,
879         address[] calldata _receivers,
880         uint[] calldata _transferFromAmounts
881     ) external;
882 
883     function snapshotStates(bytes calldata _signedSimplexStateArray) external;
884 
885     function intendWithdraw(bytes32 _channelId, uint _amount, bytes32 _recipientChannelId) external;
886     
887     function confirmWithdraw(bytes32 _channelId) external;
888 
889     function vetoWithdraw(bytes32 _channelId) external;
890     
891     function cooperativeWithdraw(bytes calldata _cooperativeWithdrawRequest) external;
892     
893     function intendSettle(bytes calldata _signedSimplexStateArray) external;
894     
895     function clearPays(bytes32 _channelId, address _peerFrom, bytes calldata _payIdList) external;
896     
897     function confirmSettle(bytes32 _channelId) external;
898     
899     function cooperativeSettle(bytes calldata _settleRequest) external;
900     
901     function getChannelStatusNum(uint _channelStatus) external view returns(uint);
902 
903     function getEthPool() external view returns(address);
904 
905     function getPayRegistry() external view returns(address);
906 
907     function getCelerWallet() external view returns(address);
908 
909     event OpenChannel(
910         bytes32 indexed channelId,
911         uint tokenType,
912         address indexed tokenAddress,
913         // TODO: there is an issue of setting address[2] as indexed. Need to fix and make this indexed
914         address[2] peerAddrs,
915         uint[2] initialDeposits
916     );
917 
918     // TODO: there is an issue of setting address[2] as indexed. Need to fix and make this indexed
919     event Deposit(bytes32 indexed channelId, address[2] peerAddrs, uint[2] deposits, uint[2] withdrawals);
920 
921     event SnapshotStates(bytes32 indexed channelId, uint[2] seqNums);
922 
923     event IntendSettle(bytes32 indexed channelId, uint[2] seqNums);
924 
925     event ClearOnePay(bytes32 indexed channelId, bytes32 indexed payId, address indexed peerFrom, uint amount);
926 
927     event ConfirmSettle(bytes32 indexed channelId, uint[2] settleBalance);
928 
929     event ConfirmSettleFail(bytes32 indexed channelId);
930 
931     event IntendWithdraw(bytes32 indexed channelId, address indexed receiver, uint amount);
932 
933     event ConfirmWithdraw(
934         bytes32 indexed channelId,
935         uint withdrawnAmount,
936         address indexed receiver,
937         bytes32 indexed recipientChannelId,
938         uint[2] deposits,
939         uint[2] withdrawals
940     );
941 
942     event VetoWithdraw(bytes32 indexed channelId);
943 
944     event CooperativeWithdraw(
945         bytes32 indexed channelId,
946         uint withdrawnAmount,
947         address indexed receiver,
948         bytes32 indexed recipientChannelId,
949         uint[2] deposits,
950         uint[2] withdrawals,
951         uint seqNum
952     );
953 
954     event CooperativeSettle(bytes32 indexed channelId, uint[2] settleBalance);
955     /********** End of LedgerOperation related functions and events **********/
956 
957 
958     /********** LedgerChannel related functions and events **********/
959     function getSettleFinalizedTime(bytes32 _channelId) external view returns(uint);
960 
961     function getTokenContract(bytes32 _channelId) external view returns(address);
962 
963     function getTokenType(bytes32 _channelId) external view returns(PbEntity.TokenType);
964 
965     function getChannelStatus(bytes32 _channelId) external view returns(LedgerStruct.ChannelStatus);
966 
967     function getCooperativeWithdrawSeqNum(bytes32 _channelId) external view returns(uint);
968 
969     function getTotalBalance(bytes32 _channelId) external view returns(uint);
970 
971     function getBalanceMap(bytes32 _channelId) external view returns(address[2] memory, uint[2] memory, uint[2] memory);
972 
973     function getChannelMigrationArgs(bytes32 _channelId) external view returns(uint, uint, address, uint);
974 
975     function getPeersMigrationInfo(bytes32 _channelId) external view returns(
976         address[2] memory,
977         uint[2] memory,
978         uint[2] memory,
979         uint[2] memory,
980         uint[2] memory,
981         uint[2] memory
982     );
983 
984     function getDisputeTimeout(bytes32 _channelId) external view returns(uint);
985 
986     function getMigratedTo(bytes32 _channelId) external view returns(address);
987 
988     function getStateSeqNumMap(bytes32 _channelId) external view returns(address[2] memory, uint[2] memory);
989 
990     function getTransferOutMap(bytes32 _channelId) external view returns(
991         address[2] memory,
992         uint[2] memory
993     );
994 
995     function getNextPayIdListHashMap(bytes32 _channelId) external view returns(
996         address[2] memory,
997         bytes32[2] memory
998     );
999 
1000     function getLastPayResolveDeadlineMap(bytes32 _channelId) external view returns(
1001         address[2] memory,
1002         uint[2] memory
1003     );
1004 
1005     function getPendingPayOutMap(bytes32 _channelId) external view returns(
1006         address[2] memory,
1007         uint[2] memory
1008     );
1009 
1010     function getWithdrawIntent(bytes32 _channelId) external view returns(address, uint, uint, bytes32);
1011     /********** End of LedgerChannel related functions and events **********/
1012 
1013 
1014     /********** LedgerBalanceLimit related functions and events **********/
1015     function setBalanceLimits(address[] calldata _tokenAddrs, uint[] calldata _limits) external;
1016 
1017     function disableBalanceLimits() external;
1018 
1019     function enableBalanceLimits() external;
1020 
1021     function getBalanceLimit(address _tokenAddr) external view returns(uint);
1022 
1023     function getBalanceLimitsEnabled() external view returns(bool);
1024     /********** End of LedgerBalanceLimit related functions and events **********/
1025 
1026 
1027     /********** LedgerMigrate related functions and events **********/
1028     function migrateChannelTo(bytes calldata _migrationRequest) external returns(bytes32);
1029 
1030     function migrateChannelFrom(address _fromLedgerAddr, bytes calldata _migrationRequest) external;
1031 
1032     event MigrateChannelTo(bytes32 indexed channelId, address indexed newLedgerAddr);
1033 
1034     event MigrateChannelFrom(bytes32 indexed channelId, address indexed oldLedgerAddr);
1035     /********** End of LedgerMigrate related functions and events **********/
1036 }
1037 
1038 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1039 
1040 pragma solidity ^0.5.0;
1041 
1042 /**
1043  * @title SafeMath
1044  * @dev Unsigned math operations with safety checks that revert on error
1045  */
1046 library SafeMath {
1047     /**
1048     * @dev Multiplies two unsigned integers, reverts on overflow.
1049     */
1050     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1051         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1052         // benefit is lost if 'b' is also tested.
1053         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1054         if (a == 0) {
1055             return 0;
1056         }
1057 
1058         uint256 c = a * b;
1059         require(c / a == b);
1060 
1061         return c;
1062     }
1063 
1064     /**
1065     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1066     */
1067     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1068         // Solidity only automatically asserts when dividing by 0
1069         require(b > 0);
1070         uint256 c = a / b;
1071         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1072 
1073         return c;
1074     }
1075 
1076     /**
1077     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1078     */
1079     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1080         require(b <= a);
1081         uint256 c = a - b;
1082 
1083         return c;
1084     }
1085 
1086     /**
1087     * @dev Adds two unsigned integers, reverts on overflow.
1088     */
1089     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1090         uint256 c = a + b;
1091         require(c >= a);
1092 
1093         return c;
1094     }
1095 
1096     /**
1097     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1098     * reverts when dividing by zero.
1099     */
1100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1101         require(b != 0);
1102         return a % b;
1103     }
1104 }
1105 
1106 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
1107 
1108 pragma solidity ^0.5.0;
1109 
1110 /**
1111  * @title Elliptic curve signature operations
1112  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
1113  * TODO Remove this library once solidity supports passing a signature to ecrecover.
1114  * See https://github.com/ethereum/solidity/issues/864
1115  */
1116 
1117 library ECDSA {
1118     /**
1119      * @dev Recover signer address from a message by using their signature
1120      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
1121      * @param signature bytes signature, the signature is generated using web3.eth.sign()
1122      */
1123     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1124         bytes32 r;
1125         bytes32 s;
1126         uint8 v;
1127 
1128         // Check the signature length
1129         if (signature.length != 65) {
1130             return (address(0));
1131         }
1132 
1133         // Divide the signature in r, s and v variables
1134         // ecrecover takes the signature parameters, and the only way to get them
1135         // currently is to use assembly.
1136         // solhint-disable-next-line no-inline-assembly
1137         assembly {
1138             r := mload(add(signature, 0x20))
1139             s := mload(add(signature, 0x40))
1140             v := byte(0, mload(add(signature, 0x60)))
1141         }
1142 
1143         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1144         if (v < 27) {
1145             v += 27;
1146         }
1147 
1148         // If the version is correct return the signer address
1149         if (v != 27 && v != 28) {
1150             return (address(0));
1151         } else {
1152             return ecrecover(hash, v, r, s);
1153         }
1154     }
1155 
1156     /**
1157      * toEthSignedMessageHash
1158      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
1159      * and hash the result
1160      */
1161     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1162         // 32 is the length in bytes of hash,
1163         // enforced by the type signature above
1164         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1165     }
1166 }
1167 
1168 // File: contracts/lib/ledgerlib/LedgerChannel.sol
1169 
1170 pragma solidity ^0.5.1;
1171 
1172 
1173 
1174 
1175 
1176 
1177 /**
1178  * @title Ledger Channel Library
1179  * @notice CelerLedger library about Channel struct
1180  * @dev this can be included in LedgerOperation to save some gas,
1181  *   however, keep this for now for clearness.
1182  */
1183 library LedgerChannel {
1184     using SafeMath for uint;
1185     using ECDSA for bytes32;
1186 
1187     /**
1188      * @notice Get channel confirm settle open time
1189      * @param _c the channel being used
1190      * @return channel confirm settle open time
1191      */
1192     function getSettleFinalizedTime(LedgerStruct.Channel storage _c) public view returns(uint) {
1193         return _c.settleFinalizedTime;
1194     }
1195 
1196     /**
1197      * @notice Get channel token contract address
1198      * @param _c the channel being used
1199      * @return channel token contract address
1200      */
1201     function getTokenContract(LedgerStruct.Channel storage _c) public view returns(address) {
1202         return _c.token.tokenAddress;
1203     }
1204 
1205     /**
1206      * @notice Get channel token type
1207      * @param _c the channel being used
1208      * @return channel token type
1209      */
1210     function getTokenType(LedgerStruct.Channel storage _c) public view returns(PbEntity.TokenType) {
1211         return _c.token.tokenType;
1212     }
1213 
1214     /**
1215      * @notice Get channel status
1216      * @param _c the channel being used
1217      * @return channel status
1218      */
1219     function getChannelStatus(
1220         LedgerStruct.Channel storage _c
1221     )
1222         public
1223         view
1224         returns(LedgerStruct.ChannelStatus)
1225     {
1226         return _c.status;
1227     }
1228 
1229     /**
1230      * @notice Get cooperative withdraw seqNum
1231      * @param _c the channel being used
1232      * @return cooperative withdraw seqNum
1233      */
1234     function getCooperativeWithdrawSeqNum(LedgerStruct.Channel storage _c) public view returns(uint) {
1235         return _c.cooperativeWithdrawSeqNum;
1236     }
1237 
1238     /**
1239      * @notice Return one channel's total balance amount
1240      * @param _c the channel
1241      * @return channel's balance amount
1242      */
1243     function getTotalBalance(LedgerStruct.Channel storage _c) public view returns(uint) {
1244         uint balance = _c.peerProfiles[0].deposit
1245             .add(_c.peerProfiles[1].deposit)
1246             .sub(_c.peerProfiles[0].withdrawal)
1247             .sub(_c.peerProfiles[1].withdrawal);
1248         return balance;
1249     }
1250 
1251     /**
1252      * @notice Return one channel's balance info (depositMap and withdrawalMap)
1253      * @dev Solidity can't directly return an array of struct for now
1254      * @param _c the channel
1255      * @return addresses of peers in the channel
1256      * @return corresponding deposits of the peers (with matched index)
1257      * @return corresponding withdrawals of the peers (with matched index)
1258      */
1259     function getBalanceMap(LedgerStruct.Channel storage _c) public view
1260         returns(address[2] memory, uint[2] memory, uint[2] memory)
1261     {
1262         address[2] memory peerAddrs = [_c.peerProfiles[0].peerAddr, _c.peerProfiles[1].peerAddr];
1263         uint[2] memory deposits = [_c.peerProfiles[0].deposit, _c.peerProfiles[1].deposit];
1264         uint[2] memory withdrawals = [_c.peerProfiles[0].withdrawal, _c.peerProfiles[1].withdrawal];
1265         return (peerAddrs, deposits, withdrawals);
1266     }
1267 
1268     /**
1269      * @notice Return channel-level migration arguments
1270      * @param _c the channel to be viewed
1271      * @return channel dispute timeout
1272      * @return channel tokey type converted to uint
1273      * @return channel token address
1274      * @return sequence number of cooperative withdraw
1275      * @dev related to Ledger Migration
1276      */
1277     function getChannelMigrationArgs(
1278         LedgerStruct.Channel storage _c
1279     )
1280         external
1281         view
1282         returns(uint, uint, address, uint)
1283     {
1284         return (
1285             _c.disputeTimeout,
1286             uint(_c.token.tokenType),
1287             _c.token.tokenAddress,
1288             _c.cooperativeWithdrawSeqNum
1289         );
1290     }
1291 
1292     /**
1293      * @notice Return migration info of the peers in the channel
1294      * @param _c the channel to be viewed
1295      * @return peers' addresses
1296      * @return peers' deposits
1297      * @return peers' withdrawals
1298      * @return peers' state sequence numbers
1299      * @return peers' transferOut map
1300      * @return peers' pendingPayOut map
1301      * @dev related to Ledger Migration
1302      */
1303     function getPeersMigrationInfo(
1304         LedgerStruct.Channel storage _c
1305     )
1306         external
1307         view
1308         returns(
1309         address[2] memory,
1310         uint[2] memory,
1311         uint[2] memory,
1312         uint[2] memory,
1313         uint[2] memory,
1314         uint[2] memory
1315     )
1316     {
1317         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1318         return (
1319             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
1320             [peerProfiles[0].deposit, peerProfiles[1].deposit],
1321             [peerProfiles[0].withdrawal, peerProfiles[1].withdrawal],
1322             [peerProfiles[0].state.seqNum, peerProfiles[1].state.seqNum],
1323             [peerProfiles[0].state.transferOut, peerProfiles[1].state.transferOut],
1324             [peerProfiles[0].state.pendingPayOut, peerProfiles[1].state.pendingPayOut]
1325         );
1326     }
1327 
1328     /**
1329      * @notice Return channel's dispute timeout
1330      * @param _c the channel to be viewed
1331      * @return channel's dispute timeout
1332      */
1333     function getDisputeTimeout(LedgerStruct.Channel storage _c) external view returns(uint) {
1334         return _c.disputeTimeout;
1335     }
1336 
1337     /**
1338      * @notice Return channel's migratedTo address
1339      * @param _c the channel to be viewed
1340      * @return channel's migratedTo address
1341      */
1342     function getMigratedTo(LedgerStruct.Channel storage _c) external view returns(address) {
1343         return _c.migratedTo;
1344     }
1345 
1346     /**
1347      * @notice Return state seqNum map of a duplex channel
1348      * @param _c the channel to be viewed
1349      * @return peers' addresses
1350      * @return two simplex state sequence numbers
1351      */
1352     function getStateSeqNumMap(
1353         LedgerStruct.Channel storage _c
1354     )
1355         external
1356         view
1357         returns(address[2] memory, uint[2] memory)
1358     {
1359         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1360         return (
1361             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
1362             [peerProfiles[0].state.seqNum, peerProfiles[1].state.seqNum]
1363         );
1364     }
1365 
1366     /**
1367      * @notice Return transferOut map of a duplex channel
1368      * @param _c the channel to be viewed
1369      * @return peers' addresses
1370      * @return transferOuts of two simplex channels
1371      */
1372     function getTransferOutMap(
1373         LedgerStruct.Channel storage _c
1374     )
1375         external
1376         view
1377         returns(address[2] memory, uint[2] memory)
1378     {
1379         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1380         return (
1381             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
1382             [peerProfiles[0].state.transferOut, peerProfiles[1].state.transferOut]
1383         );
1384     }
1385 
1386     /**
1387      * @notice Return nextPayIdListHash map of a duplex channel
1388      * @param _c the channel to be viewed
1389      * @return peers' addresses
1390      * @return nextPayIdListHashes of two simplex channels
1391      */
1392     function getNextPayIdListHashMap(
1393         LedgerStruct.Channel storage _c
1394     )
1395         external
1396         view
1397         returns(address[2] memory, bytes32[2] memory)
1398     {
1399         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1400         return (
1401             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
1402             [peerProfiles[0].state.nextPayIdListHash, peerProfiles[1].state.nextPayIdListHash]
1403         );
1404     }
1405 
1406     /**
1407      * @notice Return lastPayResolveDeadline map of a duplex channel
1408      * @param _c the channel to be viewed
1409      * @return peers' addresses
1410      * @return lastPayResolveDeadlines of two simplex channels
1411      */
1412     function getLastPayResolveDeadlineMap(
1413         LedgerStruct.Channel storage _c
1414     )
1415         external
1416         view
1417         returns(address[2] memory, uint[2] memory)
1418     {
1419         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1420         return (
1421             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
1422             [peerProfiles[0].state.lastPayResolveDeadline, peerProfiles[1].state.lastPayResolveDeadline]
1423         );
1424     }
1425 
1426     /**
1427      * @notice Return pendingPayOut map of a duplex channel
1428      * @param _c the channel to be viewed
1429      * @return peers' addresses
1430      * @return pendingPayOuts of two simplex channels
1431      */
1432     function getPendingPayOutMap(
1433         LedgerStruct.Channel storage _c
1434     )
1435         external
1436         view
1437         returns(address[2] memory, uint[2] memory)
1438     {
1439         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1440         return (
1441             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
1442             [peerProfiles[0].state.pendingPayOut, peerProfiles[1].state.pendingPayOut]
1443         );
1444     }
1445 
1446     /**
1447      * @notice Return the withdraw intent info of the channel
1448      * @param _c the channel to be viewed
1449      * @return receiver of the withdraw intent
1450      * @return amount of the withdraw intent
1451      * @return requestTime of the withdraw intent
1452      * @return recipientChannelId of the withdraw intent
1453      */
1454     function getWithdrawIntent(
1455         LedgerStruct.Channel storage _c
1456     )
1457         external
1458         view
1459         returns(address, uint, uint, bytes32)
1460     {
1461         LedgerStruct.WithdrawIntent memory withdrawIntent = _c.withdrawIntent;
1462         return (
1463             withdrawIntent.receiver,
1464             withdrawIntent.amount,
1465             withdrawIntent.requestTime,
1466             withdrawIntent.recipientChannelId
1467         );
1468     }
1469 
1470     /**
1471      * @notice Import channel migration arguments from old CelerLedger contract
1472      * @param _c the channel to be viewed
1473      * @param _fromLedgerAddr old ledger address to import channel config from
1474      * @param _channelId ID of the channel to be viewed
1475      * @dev related to Ledger Migration
1476      */
1477     function _importChannelMigrationArgs(
1478         LedgerStruct.Channel storage _c,
1479         address payable _fromLedgerAddr,
1480         bytes32 _channelId
1481     )
1482         internal
1483     {
1484         uint tokenType;
1485         (
1486             _c.disputeTimeout,
1487             tokenType,
1488             _c.token.tokenAddress,
1489             _c.cooperativeWithdrawSeqNum
1490         ) = ICelerLedger(_fromLedgerAddr).getChannelMigrationArgs(_channelId);
1491         _c.token.tokenType = PbEntity.TokenType(tokenType);
1492     }
1493 
1494     /**
1495      * @notice import channel peers' migration info from old CelerLedger contract
1496      * @param _c the channel to be viewed
1497      * @param _fromLedgerAddr old ledger address to import channel config from
1498      * @param _channelId ID of the channel to be viewed
1499      * @dev related to Ledger Migration
1500      */
1501     function _importPeersMigrationInfo(
1502         LedgerStruct.Channel storage _c,
1503         address payable _fromLedgerAddr,
1504         bytes32 _channelId
1505     )
1506         internal
1507     {
1508         (
1509             address[2] memory peersAddrs,
1510             uint[2] memory deposits,
1511             uint[2] memory withdrawals,
1512             uint[2] memory seqNums,
1513             uint[2] memory transferOuts,
1514             uint[2] memory pendingPayOuts
1515         ) = ICelerLedger(_fromLedgerAddr).getPeersMigrationInfo(_channelId);
1516 
1517         for (uint i = 0; i < 2; i++) {
1518             LedgerStruct.PeerProfile storage peerProfile = _c.peerProfiles[i];
1519             peerProfile.peerAddr = peersAddrs[i];
1520             peerProfile.deposit = deposits[i];
1521             peerProfile.withdrawal = withdrawals[i];
1522             peerProfile.state.seqNum = seqNums[i];
1523             peerProfile.state.transferOut = transferOuts[i];
1524             peerProfile.state.pendingPayOut = pendingPayOuts[i];
1525         }
1526     }
1527 
1528     /**
1529      * @notice Get the seqNums of two simplex channel states
1530      * @param _c the channel
1531      */
1532     function _getStateSeqNums(LedgerStruct.Channel storage _c) internal view returns(uint[2] memory) {
1533         return [_c.peerProfiles[0].state.seqNum, _c.peerProfiles[1].state.seqNum];
1534     }
1535 
1536     /**
1537      * @notice Check if _addr is one of the peers in channel _c
1538      * @param _c the channel
1539      * @param _addr the address to check
1540      * @return is peer or not
1541      */
1542     function _isPeer(LedgerStruct.Channel storage _c, address _addr) internal view returns(bool) {
1543         return _addr == _c.peerProfiles[0].peerAddr || _addr == _c.peerProfiles[1].peerAddr;
1544     }
1545 
1546     /**
1547      * @notice Get peer's ID
1548      * @param _c the channel
1549      * @param _peer address of peer
1550      * @return peer's ID
1551      */
1552      function _getPeerId(LedgerStruct.Channel storage _c, address _peer) internal view returns(uint) {
1553         if (_peer == _c.peerProfiles[0].peerAddr) {
1554             return 0;
1555         } else if (_peer == _c.peerProfiles[1].peerAddr) {
1556             return 1;
1557         } else {
1558             revert("Nonexist peer");
1559         }
1560     }
1561 
1562     /**
1563      * @notice Check the correctness of one peer's signature
1564      * @param _c the channel
1565      * @param _h the hash of the message signed by the peer
1566      * @param _sig signature of the peer
1567      * @return message is signed by one of the peers or not
1568      */
1569     function _checkSingleSignature(
1570         LedgerStruct.Channel storage _c,
1571         bytes32 _h,
1572         bytes memory _sig
1573     )
1574         internal
1575         view
1576         returns(bool)
1577     {
1578         address addr = _h.toEthSignedMessageHash().recover(_sig);
1579         return _isPeer(_c, addr);
1580     }
1581 
1582     /**
1583      * @notice Check the correctness of the co-signatures
1584      * @param _c the channel
1585      * @param _h the hash of the message signed by the peers
1586      * @param _sigs signatures of the peers
1587      * @return message are signed by both peers or not
1588      */
1589     function _checkCoSignatures(
1590         LedgerStruct.Channel storage _c,
1591         bytes32 _h,
1592         bytes[] memory _sigs
1593     )
1594         internal
1595         view
1596         returns(bool)
1597     {
1598         if (_sigs.length != 2) {
1599             return false;
1600         }
1601 
1602         // check signature
1603         bytes32 hash = _h.toEthSignedMessageHash();
1604         address addr;
1605         for (uint i = 0; i < 2; i++) {
1606             addr = hash.recover(_sigs[i]);
1607             // enforce the order of sigs consistent with ascending addresses
1608             if (addr != _c.peerProfiles[i].peerAddr) {
1609                 return false;
1610             }
1611         }
1612 
1613         return true;
1614     }
1615 
1616     /**
1617      * @notice Validate channel final balance
1618      * @dev settleBalance = deposit - withdrawal + transferIn - transferOut
1619      * @param _c the channel
1620      * @return (balance is valid, settle balance)
1621      */
1622     function _validateSettleBalance(LedgerStruct.Channel storage _c)
1623         internal
1624         view
1625         returns(bool, uint[2] memory)
1626     {
1627         LedgerStruct.PeerProfile[2] memory peerProfiles = _c.peerProfiles;
1628         uint[2] memory settleBalance = [
1629             peerProfiles[0].deposit.add(peerProfiles[1].state.transferOut),
1630             peerProfiles[1].deposit.add(peerProfiles[0].state.transferOut)
1631         ];
1632         for (uint i = 0; i < 2; i++) {
1633             uint subAmt = peerProfiles[i].state.transferOut.add(peerProfiles[i].withdrawal);
1634             if (settleBalance[i] < subAmt) {
1635                 return (false, [uint(0), uint(0)]);
1636             }
1637 
1638             settleBalance[i] = settleBalance[i].sub(subAmt);
1639         }
1640 
1641         return (true, settleBalance);
1642     }
1643 
1644     /**
1645      * @notice Update record of one peer's withdrawal amount
1646      * @param _c the channel
1647      * @param _receiver receiver of this new withdrawal
1648      * @param _amount amount of this new withdrawal
1649      * @param _checkBalance check the balance if this is true
1650      */
1651     function _addWithdrawal(
1652         LedgerStruct.Channel storage _c,
1653         address _receiver,
1654         uint _amount,
1655         bool _checkBalance
1656     )
1657         internal
1658     {
1659         // this implicitly require receiver be a peer
1660         uint rid = _getPeerId(_c, _receiver);
1661         _c.peerProfiles[rid].withdrawal = _c.peerProfiles[rid].withdrawal.add(_amount);
1662         if (_checkBalance) {
1663             require(getTotalBalance(_c) >= 0);
1664         }
1665     }
1666 }
1667 
1668 // File: contracts/lib/data/PbChain.sol
1669 
1670 // Code generated by protoc-gen-sol. DO NOT EDIT.
1671 // source: chain.proto
1672 pragma solidity ^0.5.0;
1673 
1674 
1675 library PbChain {
1676     using Pb for Pb.Buffer;  // so we can call Pb funcs on Buffer obj
1677 
1678     struct OpenChannelRequest {
1679         bytes channelInitializer;   // tag: 1
1680         bytes[] sigs;   // tag: 2
1681     } // end struct OpenChannelRequest
1682 
1683     function decOpenChannelRequest(bytes memory raw) internal pure returns (OpenChannelRequest memory m) {
1684         Pb.Buffer memory buf = Pb.fromBytes(raw);
1685 
1686         uint[] memory cnts = buf.cntTags(2);
1687         m.sigs = new bytes[](cnts[2]);
1688         cnts[2] = 0;  // reset counter for later use
1689         
1690         uint tag;
1691         Pb.WireType wire;
1692         while (buf.hasMore()) {
1693             (tag, wire) = buf.decKey();
1694             if (false) {} // solidity has no switch/case
1695             else if (tag == 1) {
1696                 m.channelInitializer = bytes(buf.decBytes());
1697             }
1698             else if (tag == 2) {
1699                 m.sigs[cnts[2]] = bytes(buf.decBytes());
1700                 cnts[2]++;
1701             }
1702             else { buf.skipValue(wire); } // skip value of unknown tag
1703         }
1704     } // end decoder OpenChannelRequest
1705 
1706     struct CooperativeWithdrawRequest {
1707         bytes withdrawInfo;   // tag: 1
1708         bytes[] sigs;   // tag: 2
1709     } // end struct CooperativeWithdrawRequest
1710 
1711     function decCooperativeWithdrawRequest(bytes memory raw) internal pure returns (CooperativeWithdrawRequest memory m) {
1712         Pb.Buffer memory buf = Pb.fromBytes(raw);
1713 
1714         uint[] memory cnts = buf.cntTags(2);
1715         m.sigs = new bytes[](cnts[2]);
1716         cnts[2] = 0;  // reset counter for later use
1717         
1718         uint tag;
1719         Pb.WireType wire;
1720         while (buf.hasMore()) {
1721             (tag, wire) = buf.decKey();
1722             if (false) {} // solidity has no switch/case
1723             else if (tag == 1) {
1724                 m.withdrawInfo = bytes(buf.decBytes());
1725             }
1726             else if (tag == 2) {
1727                 m.sigs[cnts[2]] = bytes(buf.decBytes());
1728                 cnts[2]++;
1729             }
1730             else { buf.skipValue(wire); } // skip value of unknown tag
1731         }
1732     } // end decoder CooperativeWithdrawRequest
1733 
1734     struct CooperativeSettleRequest {
1735         bytes settleInfo;   // tag: 1
1736         bytes[] sigs;   // tag: 2
1737     } // end struct CooperativeSettleRequest
1738 
1739     function decCooperativeSettleRequest(bytes memory raw) internal pure returns (CooperativeSettleRequest memory m) {
1740         Pb.Buffer memory buf = Pb.fromBytes(raw);
1741 
1742         uint[] memory cnts = buf.cntTags(2);
1743         m.sigs = new bytes[](cnts[2]);
1744         cnts[2] = 0;  // reset counter for later use
1745         
1746         uint tag;
1747         Pb.WireType wire;
1748         while (buf.hasMore()) {
1749             (tag, wire) = buf.decKey();
1750             if (false) {} // solidity has no switch/case
1751             else if (tag == 1) {
1752                 m.settleInfo = bytes(buf.decBytes());
1753             }
1754             else if (tag == 2) {
1755                 m.sigs[cnts[2]] = bytes(buf.decBytes());
1756                 cnts[2]++;
1757             }
1758             else { buf.skipValue(wire); } // skip value of unknown tag
1759         }
1760     } // end decoder CooperativeSettleRequest
1761 
1762     struct ResolvePayByConditionsRequest {
1763         bytes condPay;   // tag: 1
1764         bytes[] hashPreimages;   // tag: 2
1765     } // end struct ResolvePayByConditionsRequest
1766 
1767     function decResolvePayByConditionsRequest(bytes memory raw) internal pure returns (ResolvePayByConditionsRequest memory m) {
1768         Pb.Buffer memory buf = Pb.fromBytes(raw);
1769 
1770         uint[] memory cnts = buf.cntTags(2);
1771         m.hashPreimages = new bytes[](cnts[2]);
1772         cnts[2] = 0;  // reset counter for later use
1773         
1774         uint tag;
1775         Pb.WireType wire;
1776         while (buf.hasMore()) {
1777             (tag, wire) = buf.decKey();
1778             if (false) {} // solidity has no switch/case
1779             else if (tag == 1) {
1780                 m.condPay = bytes(buf.decBytes());
1781             }
1782             else if (tag == 2) {
1783                 m.hashPreimages[cnts[2]] = bytes(buf.decBytes());
1784                 cnts[2]++;
1785             }
1786             else { buf.skipValue(wire); } // skip value of unknown tag
1787         }
1788     } // end decoder ResolvePayByConditionsRequest
1789 
1790     struct SignedSimplexState {
1791         bytes simplexState;   // tag: 1
1792         bytes[] sigs;   // tag: 2
1793     } // end struct SignedSimplexState
1794 
1795     function decSignedSimplexState(bytes memory raw) internal pure returns (SignedSimplexState memory m) {
1796         Pb.Buffer memory buf = Pb.fromBytes(raw);
1797 
1798         uint[] memory cnts = buf.cntTags(2);
1799         m.sigs = new bytes[](cnts[2]);
1800         cnts[2] = 0;  // reset counter for later use
1801         
1802         uint tag;
1803         Pb.WireType wire;
1804         while (buf.hasMore()) {
1805             (tag, wire) = buf.decKey();
1806             if (false) {} // solidity has no switch/case
1807             else if (tag == 1) {
1808                 m.simplexState = bytes(buf.decBytes());
1809             }
1810             else if (tag == 2) {
1811                 m.sigs[cnts[2]] = bytes(buf.decBytes());
1812                 cnts[2]++;
1813             }
1814             else { buf.skipValue(wire); } // skip value of unknown tag
1815         }
1816     } // end decoder SignedSimplexState
1817 
1818     struct SignedSimplexStateArray {
1819         SignedSimplexState[] signedSimplexStates;   // tag: 1
1820     } // end struct SignedSimplexStateArray
1821 
1822     function decSignedSimplexStateArray(bytes memory raw) internal pure returns (SignedSimplexStateArray memory m) {
1823         Pb.Buffer memory buf = Pb.fromBytes(raw);
1824 
1825         uint[] memory cnts = buf.cntTags(1);
1826         m.signedSimplexStates = new SignedSimplexState[](cnts[1]);
1827         cnts[1] = 0;  // reset counter for later use
1828         
1829         uint tag;
1830         Pb.WireType wire;
1831         while (buf.hasMore()) {
1832             (tag, wire) = buf.decKey();
1833             if (false) {} // solidity has no switch/case
1834             else if (tag == 1) {
1835                 m.signedSimplexStates[cnts[1]] = decSignedSimplexState(buf.decBytes());
1836                 cnts[1]++;
1837             }
1838             else { buf.skipValue(wire); } // skip value of unknown tag
1839         }
1840     } // end decoder SignedSimplexStateArray
1841 
1842     struct ChannelMigrationRequest {
1843         bytes channelMigrationInfo;   // tag: 1
1844         bytes[] sigs;   // tag: 2
1845     } // end struct ChannelMigrationRequest
1846 
1847     function decChannelMigrationRequest(bytes memory raw) internal pure returns (ChannelMigrationRequest memory m) {
1848         Pb.Buffer memory buf = Pb.fromBytes(raw);
1849 
1850         uint[] memory cnts = buf.cntTags(2);
1851         m.sigs = new bytes[](cnts[2]);
1852         cnts[2] = 0;  // reset counter for later use
1853         
1854         uint tag;
1855         Pb.WireType wire;
1856         while (buf.hasMore()) {
1857             (tag, wire) = buf.decKey();
1858             if (false) {} // solidity has no switch/case
1859             else if (tag == 1) {
1860                 m.channelMigrationInfo = bytes(buf.decBytes());
1861             }
1862             else if (tag == 2) {
1863                 m.sigs[cnts[2]] = bytes(buf.decBytes());
1864                 cnts[2]++;
1865             }
1866             else { buf.skipValue(wire); } // skip value of unknown tag
1867         }
1868     } // end decoder ChannelMigrationRequest
1869 
1870 }
1871 
1872 // File: openzeppelin-solidity/contracts/utils/Address.sol
1873 
1874 pragma solidity ^0.5.0;
1875 
1876 /**
1877  * Utility library of inline functions on addresses
1878  */
1879 library Address {
1880     /**
1881      * Returns whether the target address is a contract
1882      * @dev This function will return false if invoked during the constructor of a contract,
1883      * as the code is not actually created until after the constructor finishes.
1884      * @param account address of the account to check
1885      * @return whether the target address is a contract
1886      */
1887     function isContract(address account) internal view returns (bool) {
1888         uint256 size;
1889         // XXX Currently there is no better way to check if there is a contract in an address
1890         // than to check the size of the code at that address.
1891         // See https://ethereum.stackexchange.com/a/14016/36603
1892         // for more details about how this works.
1893         // TODO Check this again before the Serenity release, because all addresses will be
1894         // contracts then.
1895         // solhint-disable-next-line no-inline-assembly
1896         assembly { size := extcodesize(account) }
1897         return size > 0;
1898     }
1899 }
1900 
1901 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
1902 
1903 pragma solidity ^0.5.0;
1904 
1905 /**
1906  * @title ERC20 interface
1907  * @dev see https://github.com/ethereum/EIPs/issues/20
1908  */
1909 interface IERC20 {
1910     function transfer(address to, uint256 value) external returns (bool);
1911 
1912     function approve(address spender, uint256 value) external returns (bool);
1913 
1914     function transferFrom(address from, address to, uint256 value) external returns (bool);
1915 
1916     function totalSupply() external view returns (uint256);
1917 
1918     function balanceOf(address who) external view returns (uint256);
1919 
1920     function allowance(address owner, address spender) external view returns (uint256);
1921 
1922     event Transfer(address indexed from, address indexed to, uint256 value);
1923 
1924     event Approval(address indexed owner, address indexed spender, uint256 value);
1925 }
1926 
1927 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1928 
1929 pragma solidity ^0.5.0;
1930 
1931 
1932 
1933 /**
1934  * @title SafeERC20
1935  * @dev Wrappers around ERC20 operations that throw on failure.
1936  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1937  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1938  */
1939 library SafeERC20 {
1940     using SafeMath for uint256;
1941 
1942     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1943         require(token.transfer(to, value));
1944     }
1945 
1946     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1947         require(token.transferFrom(from, to, value));
1948     }
1949 
1950     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1951         // safeApprove should only be called when setting an initial allowance,
1952         // or when resetting it to zero. To increase and decrease it, use
1953         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1954         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
1955         require(token.approve(spender, value));
1956     }
1957 
1958     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1959         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1960         require(token.approve(spender, newAllowance));
1961     }
1962 
1963     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1964         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
1965         require(token.approve(spender, newAllowance));
1966     }
1967 }
1968 
1969 // File: contracts/lib/ledgerlib/LedgerOperation.sol
1970 
1971 pragma solidity ^0.5.1;
1972 
1973 
1974 
1975 
1976 
1977 
1978 
1979 
1980 
1981 
1982 /**
1983  * @title Ledger Operation Library
1984  * @notice CelerLedger library of basic ledger operations
1985  * @dev This library doesn't need "withdraw pattern" because both peers must be
1986  *   External Owned Accounts(EOA) since their signatures are required in openChannel.
1987  */
1988 library LedgerOperation {
1989     using SafeMath for uint;
1990     using Address for address;
1991     using SafeERC20 for IERC20;
1992     using LedgerChannel for LedgerStruct.Channel;
1993 
1994     /**
1995      * @notice Open a state channel through auth withdraw message
1996      * @dev library function can't be payable but can read msg.value in caller's context
1997      * @param _self storage data of CelerLedger contract
1998      * @param _openRequest bytes of open channel request message
1999      */
2000     function openChannel(
2001         LedgerStruct.Ledger storage _self,
2002         bytes calldata _openRequest
2003     )
2004         external
2005     {
2006         PbChain.OpenChannelRequest memory openRequest =
2007             PbChain.decOpenChannelRequest(_openRequest);
2008         PbEntity.PaymentChannelInitializer memory channelInitializer =
2009             PbEntity.decPaymentChannelInitializer(openRequest.channelInitializer);
2010         require(channelInitializer.initDistribution.distribution.length == 2, "Wrong length");
2011         require(block.number <= channelInitializer.openDeadline, "Open deadline passed");
2012         
2013         PbEntity.TokenInfo memory token = channelInitializer.initDistribution.token;
2014         uint[2] memory amounts = [
2015             channelInitializer.initDistribution.distribution[0].amt,
2016             channelInitializer.initDistribution.distribution[1].amt
2017         ];
2018         address[2] memory peerAddrs = [
2019             channelInitializer.initDistribution.distribution[0].account,
2020             channelInitializer.initDistribution.distribution[1].account
2021         ];
2022         // enforce ascending order of peers' addresses to simplify contract code
2023         require(peerAddrs[0] < peerAddrs[1], "Peer addrs are not ascending");
2024 
2025         ICelerWallet celerWallet = _self.celerWallet;
2026         bytes32 h = keccak256(openRequest.channelInitializer);
2027         (
2028             bytes32 channelId,
2029             LedgerStruct.Channel storage c
2030         ) = _createWallet(_self, celerWallet, peerAddrs, h);
2031 
2032         c.disputeTimeout = channelInitializer.disputeTimeout;
2033         _updateChannelStatus(_self, c, LedgerStruct.ChannelStatus.Operable);
2034         c.token = _validateTokenInfo(token);
2035         c.peerProfiles[0].peerAddr = peerAddrs[0];
2036         c.peerProfiles[0].deposit = amounts[0];
2037         c.peerProfiles[1].peerAddr = peerAddrs[1];
2038         c.peerProfiles[1].deposit = amounts[1];
2039 
2040         require(c._checkCoSignatures(h, openRequest.sigs), "Check co-sigs failed");
2041 
2042         emit OpenChannel(channelId, uint(token.tokenType), token.tokenAddress, peerAddrs, amounts);
2043 
2044         uint amtSum = amounts[0].add(amounts[1]);
2045         // if total deposit is 0
2046         if (amtSum == 0) {
2047             require(msg.value == 0, "msg.value is not 0");
2048             return;
2049         }
2050 
2051         // if total deposit is larger than 0
2052         if (_self.balanceLimitsEnabled) {
2053             require(amtSum <= _self.balanceLimits[token.tokenAddress], "Balance exceeds limit");
2054         }
2055 
2056         if (token.tokenType == PbEntity.TokenType.ETH) {
2057             uint msgValueReceiver = channelInitializer.msgValueReceiver;
2058             require(msg.value == amounts[msgValueReceiver], "msg.value mismatch");
2059             if (amounts[msgValueReceiver] > 0) {
2060                 celerWallet.depositETH.value(amounts[msgValueReceiver])(channelId);
2061             }
2062 
2063             // peer ID of non-msgValueReceiver
2064             uint pid = uint(1).sub(msgValueReceiver);
2065             if (amounts[pid] > 0) {
2066                 _self.ethPool.transferToCelerWallet(
2067                     peerAddrs[pid],
2068                     address(celerWallet),
2069                     channelId,
2070                     amounts[pid]
2071                 );
2072             }
2073         } else if (token.tokenType == PbEntity.TokenType.ERC20) {
2074             require(msg.value == 0, "msg.value is not 0");
2075 
2076             IERC20 erc20Token = IERC20(token.tokenAddress);
2077             for (uint i = 0; i < 2; i++) {
2078                 if (amounts[i] == 0) { continue; }
2079 
2080                 erc20Token.safeTransferFrom(peerAddrs[i], address(this), amounts[i]);
2081             }
2082             erc20Token.safeApprove(address(celerWallet), amtSum);
2083             celerWallet.depositERC20(channelId, address(erc20Token), amtSum);
2084         } else {
2085             assert(false);
2086         }
2087     }
2088 
2089     /**
2090      * @notice Deposit ETH or ERC20 tokens into the channel
2091      * @dev total deposit amount = msg.value(must be 0 for ERC20) + _transferFromAmount.
2092      *   library function can't be payable but can read msg.value in caller's context.
2093      * @param _self storage data of CelerLedger contract
2094      * @param _channelId ID of the channel
2095      * @param _receiver address of the receiver
2096      * @param _transferFromAmount amount of funds to be transfered from EthPool for ETH
2097      *   or ERC20 contract for ERC20 tokens
2098      */
2099     function deposit(
2100         LedgerStruct.Ledger storage _self,
2101         bytes32 _channelId,
2102         address _receiver,
2103         uint _transferFromAmount
2104     )
2105         external
2106     {
2107         uint msgValue = msg.value;
2108         // this implicitly require _receiver be a peer
2109         _addDeposit(_self, _channelId, _receiver, _transferFromAmount.add(msgValue));
2110         
2111         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2112         if (c.token.tokenType == PbEntity.TokenType.ETH) {
2113             if (msgValue > 0) {
2114                 _self.celerWallet.depositETH.value(msgValue)(_channelId);
2115             }
2116             if (_transferFromAmount > 0) {
2117                 _self.ethPool.transferToCelerWallet(
2118                     msg.sender,
2119                     address(_self.celerWallet),
2120                     _channelId,
2121                     _transferFromAmount
2122                 );
2123             }
2124         } else if (c.token.tokenType == PbEntity.TokenType.ERC20) {
2125             require(msgValue == 0, "msg.value is not 0");
2126 
2127             IERC20 erc20Token = IERC20(c.token.tokenAddress);
2128             erc20Token.safeTransferFrom(msg.sender, address(this), _transferFromAmount);
2129             erc20Token.safeApprove(address(_self.celerWallet), _transferFromAmount);
2130             _self.celerWallet.depositERC20(_channelId, address(erc20Token), _transferFromAmount);
2131         } else {
2132             assert(false);
2133         }
2134     }
2135 
2136     /**
2137      * @notice Store signed simplex states on-chain as checkpoints
2138      * @dev simplex states in this array are not necessarily in the same channel,
2139      *   which means snapshotStates natively supports multi-channel batch processing.
2140      *   This function only updates seqNum, transferOut, pendingPayOut of each on-chain
2141      *   simplex state. It can't ensure that the pending pays will be cleared during
2142      *   settling the channel, which requires users call intendSettle with the same state.
2143      *   TODO: wait for Solidity's support to replace SignedSimplexStateArray with bytes[].
2144      * @param _self storage data of CelerLedger contract
2145      * @param _signedSimplexStateArray bytes of SignedSimplexStateArray message
2146      */
2147     function snapshotStates(
2148         LedgerStruct.Ledger storage _self,
2149         bytes calldata _signedSimplexStateArray
2150     )
2151         external
2152     {
2153         PbChain.SignedSimplexStateArray memory signedSimplexStateArray =
2154             PbChain.decSignedSimplexStateArray(_signedSimplexStateArray);
2155         uint simplexStatesNum = signedSimplexStateArray.signedSimplexStates.length;
2156 
2157         // snapshot each state
2158         PbEntity.SimplexPaymentChannel memory simplexState =
2159             PbEntity.decSimplexPaymentChannel(signedSimplexStateArray.signedSimplexStates[0].simplexState);
2160         for (uint i = 0; i < simplexStatesNum; i++) {
2161             bytes32 currentChannelId = simplexState.channelId;
2162             LedgerStruct.Channel storage c = _self.channelMap[currentChannelId];
2163 
2164             require(c.status == LedgerStruct.ChannelStatus.Operable, "Channel status error");
2165 
2166             bytes32 stateHash = keccak256(signedSimplexStateArray.signedSimplexStates[i].simplexState);
2167             bytes[] memory sigs = signedSimplexStateArray.signedSimplexStates[i].sigs;
2168             require(c._checkCoSignatures(stateHash, sigs), "Check co-sigs failed");
2169             uint peerFromId = c._getPeerId(simplexState.peerFrom);
2170             LedgerStruct.PeerState storage state = c.peerProfiles[peerFromId].state;
2171             require(simplexState.seqNum > state.seqNum, "seqNum error");
2172 
2173             // no need to update nextPayIdListHash and lastPayResolveDeadline for snapshot purpose
2174             state.seqNum = simplexState.seqNum;
2175             state.transferOut = simplexState.transferToPeer.receiver.amt;
2176             state.pendingPayOut = simplexState.totalPendingAmount;
2177 
2178             if (i == simplexStatesNum.sub(1)) {
2179                 emit SnapshotStates(currentChannelId, c._getStateSeqNums());
2180             } else if (i < simplexStatesNum.sub(1)) {
2181                 simplexState = PbEntity.decSimplexPaymentChannel(
2182                     signedSimplexStateArray.signedSimplexStates[i+1].simplexState
2183                 );
2184                 // enforce channelIds of simplex states are ascending
2185                 require(currentChannelId <= simplexState.channelId, "Non-ascending channelIds");
2186                 if (currentChannelId < simplexState.channelId) {
2187                     emit SnapshotStates(currentChannelId, c._getStateSeqNums());
2188                 }
2189             } else {
2190                 assert(false);
2191             }
2192         }
2193     }
2194 
2195     /**
2196      * @notice Intend to withdraw funds from channel
2197      * @dev only peers can call intendWithdraw
2198      * @param _self storage data of CelerLedger contract
2199      * @param _channelId ID of the channel
2200      * @param _amount amount of funds to withdraw
2201      * @param _recipientChannelId withdraw to receiver address if 0,
2202      *   otherwise deposit to receiver address in the recipient channel
2203      */
2204     function intendWithdraw(
2205         LedgerStruct.Ledger storage _self,
2206         bytes32 _channelId,
2207         uint _amount,
2208         bytes32 _recipientChannelId
2209     )
2210         external
2211     {
2212         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2213         LedgerStruct.PeerProfile[2] storage peerProfiles = c.peerProfiles;
2214         LedgerStruct.WithdrawIntent storage withdrawIntent = c.withdrawIntent;
2215         address receiver = msg.sender;
2216         require(c.status == LedgerStruct.ChannelStatus.Operable, "Channel status error");
2217         // withdrawIntent.receiver is address(0) if and only if there is no pending WithdrawIntent,
2218         // because withdrawIntent.receiver may only be set as msg.sender which can't be address(0).
2219         require(withdrawIntent.receiver == address(0), "Pending withdraw intent exists");
2220 
2221         // check withdraw limit
2222         // this implicitly requires receiver be a peer
2223         uint rid = c._getPeerId(receiver);
2224         uint pid = uint(1).sub(rid);
2225         uint withdrawLimit = peerProfiles[rid].deposit
2226             .add(peerProfiles[pid].state.transferOut)
2227             .sub(peerProfiles[rid].withdrawal)
2228             .sub(peerProfiles[rid].state.transferOut)
2229             .sub(peerProfiles[rid].state.pendingPayOut);
2230         require(_amount <= withdrawLimit, "Exceed withdraw limit");
2231 
2232         withdrawIntent.receiver = receiver;
2233         withdrawIntent.amount = _amount;
2234         withdrawIntent.requestTime = block.number;
2235         withdrawIntent.recipientChannelId = _recipientChannelId;
2236 
2237         emit IntendWithdraw(_channelId, receiver, _amount);
2238     }
2239 
2240     /**
2241      * @notice Confirm channel withdrawal
2242      * @dev anyone can confirm a withdrawal intent
2243      * @param _self storage data of CelerLedger contract
2244      * @param _channelId ID of the channel
2245      */
2246     function confirmWithdraw(
2247         LedgerStruct.Ledger storage _self,
2248         bytes32 _channelId
2249     )
2250         external
2251     {
2252         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2253         require(c.status == LedgerStruct.ChannelStatus.Operable, "Channel status error");
2254         require(c.withdrawIntent.receiver != address(0), "No pending withdraw intent");
2255         require(
2256             block.number >= c.withdrawIntent.requestTime.add(c.disputeTimeout),
2257             "Dispute not timeout"
2258         );
2259 
2260         address receiver = c.withdrawIntent.receiver;
2261         uint amount = c.withdrawIntent.amount;
2262         bytes32 recipientChannelId = c.withdrawIntent.recipientChannelId;
2263         delete c.withdrawIntent;
2264 
2265         // don't need to check balance because intendWithdraw() has already checked withdraw limit
2266         // this implicitly require receiver be a peer
2267         c._addWithdrawal(receiver, amount, false);
2268         
2269         (, uint[2] memory deposits, uint[2] memory withdrawals) = c.getBalanceMap();
2270         emit ConfirmWithdraw(_channelId, amount, receiver, recipientChannelId, deposits, withdrawals);
2271 
2272         _withdrawFunds(_self, _channelId, receiver, amount, recipientChannelId);
2273     }
2274 
2275     /**
2276      * @notice Veto current withdrawal intent
2277      * @dev only peers can veto a withdrawal intent;
2278      *   peers can veto a withdrawal intent even after (requestTime + disputeTimeout)
2279      * @param _self storage data of CelerLedger contract
2280      * @param _channelId ID of the channel
2281      */
2282     function vetoWithdraw(LedgerStruct.Ledger storage _self, bytes32 _channelId) external {
2283         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2284         require(c.status == LedgerStruct.ChannelStatus.Operable, "Channel status error");
2285         require(c.withdrawIntent.receiver != address(0), "No pending withdraw intent");
2286         require(c._isPeer(msg.sender), "msg.sender is not peer");
2287 
2288         delete c.withdrawIntent;
2289 
2290         emit VetoWithdraw(_channelId);
2291     }
2292 
2293     /**
2294      * @notice Cooperatively withdraw specific amount of deposit
2295      * @param _self storage data of CelerLedger contract
2296      * @param _cooperativeWithdrawRequest bytes of cooperative withdraw request message
2297      */
2298     function cooperativeWithdraw(
2299         LedgerStruct.Ledger storage _self,
2300         bytes calldata _cooperativeWithdrawRequest
2301     )
2302         external
2303     {
2304         PbChain.CooperativeWithdrawRequest memory cooperativeWithdrawRequest =
2305             PbChain.decCooperativeWithdrawRequest(_cooperativeWithdrawRequest);
2306         PbEntity.CooperativeWithdrawInfo memory withdrawInfo =
2307             PbEntity.decCooperativeWithdrawInfo(cooperativeWithdrawRequest.withdrawInfo);
2308         bytes32 channelId = withdrawInfo.channelId;
2309         bytes32 recipientChannelId = withdrawInfo.recipientChannelId;
2310         LedgerStruct.Channel storage c = _self.channelMap[channelId];
2311 
2312         require(c.status == LedgerStruct.ChannelStatus.Operable, "Channel status error");
2313         bytes32 h = keccak256(cooperativeWithdrawRequest.withdrawInfo);
2314         require(
2315             c._checkCoSignatures(h, cooperativeWithdrawRequest.sigs),
2316             "Check co-sigs failed"
2317         );
2318         // require an increment of exactly 1 for seqNum of each cooperative withdraw request
2319         require(
2320             withdrawInfo.seqNum.sub(c.cooperativeWithdrawSeqNum) == 1,
2321             "seqNum error"
2322         );
2323         require(block.number <= withdrawInfo.withdrawDeadline, "Withdraw deadline passed");
2324 
2325         address receiver = withdrawInfo.withdraw.account;
2326         c.cooperativeWithdrawSeqNum = withdrawInfo.seqNum;
2327         uint amount = withdrawInfo.withdraw.amt;
2328 
2329         // this implicitly require receiver be a peer
2330         c._addWithdrawal(receiver, amount, true);
2331 
2332         (, uint[2] memory deposits, uint[2] memory withdrawals) = c.getBalanceMap();
2333         emit CooperativeWithdraw(
2334             channelId,
2335             amount,
2336             receiver,
2337             recipientChannelId,
2338             deposits,
2339             withdrawals,
2340             withdrawInfo.seqNum
2341         );
2342 
2343         _withdrawFunds(_self, channelId, receiver, amount, recipientChannelId);
2344     }
2345 
2346     /**
2347      * @notice Intend to settle channel(s) with an array of signed simplex states
2348      * @dev simplex states in this array are not necessarily in the same channel,
2349      *   which means intendSettle natively supports multi-channel batch processing.
2350      *   A simplex state with non-zero seqNum (non-null state) must be co-signed by both peers,
2351      *   while a simplex state with seqNum=0 (null state) only needs to be signed by one peer.
2352      *   TODO: wait for Solidity's support to replace SignedSimplexStateArray with bytes[].
2353      * @param _self storage data of CelerLedger contract
2354      * @param _signedSimplexStateArray bytes of SignedSimplexStateArray message
2355      */
2356     function intendSettle(
2357         LedgerStruct.Ledger storage _self,
2358         bytes calldata _signedSimplexStateArray
2359     )
2360         external
2361     {
2362         PbChain.SignedSimplexStateArray memory signedSimplexStateArray =
2363             PbChain.decSignedSimplexStateArray(_signedSimplexStateArray);
2364         uint simplexStatesNum = signedSimplexStateArray.signedSimplexStates.length;
2365 
2366         PbEntity.SimplexPaymentChannel memory simplexState =
2367             PbEntity.decSimplexPaymentChannel(signedSimplexStateArray.signedSimplexStates[0].simplexState);
2368         for (uint i = 0; i < simplexStatesNum; i++) {
2369             bytes32 currentChannelId = simplexState.channelId;
2370             LedgerStruct.Channel storage c = _self.channelMap[currentChannelId];
2371             require(
2372                 c.status == LedgerStruct.ChannelStatus.Operable ||
2373                 c.status == LedgerStruct.ChannelStatus.Settling,
2374                 "Channel status error"
2375             );
2376             require(
2377                 c.settleFinalizedTime == 0 || block.number < c.settleFinalizedTime,
2378                 "Settle has already finalized"
2379             );
2380             
2381             bytes32 stateHash = keccak256(signedSimplexStateArray.signedSimplexStates[i].simplexState);
2382             bytes[] memory sigs = signedSimplexStateArray.signedSimplexStates[i].sigs;
2383 
2384             if (simplexState.seqNum > 0) {  // non-null state
2385                 require(c._checkCoSignatures(stateHash, sigs), "Check co-sigs failed");
2386                 uint peerFromId = c._getPeerId(simplexState.peerFrom);
2387                 LedgerStruct.PeerState storage state = c.peerProfiles[peerFromId].state;
2388                 // ensure each state can be intendSettle at most once
2389                 if (c.status == LedgerStruct.ChannelStatus.Operable) {
2390                     // "==" is the case of cooperative on-chain checkpoint
2391                     require(simplexState.seqNum >= state.seqNum, "seqNum error");
2392                 } else if (c.status == LedgerStruct.ChannelStatus.Settling) {
2393                     require(simplexState.seqNum > state.seqNum, "seqNum error");
2394                 } else {
2395                     assert(false);
2396                 }
2397 
2398                 // update simplexState-dependent fields
2399                 // no need to update pendingPayOut since channel settle process doesn't use it
2400                 state.seqNum = simplexState.seqNum;
2401                 state.transferOut = simplexState.transferToPeer.receiver.amt;
2402                 state.nextPayIdListHash = simplexState.pendingPayIds.nextListHash;
2403                 state.lastPayResolveDeadline = simplexState.lastPayResolveDeadline;
2404                 _clearPays(_self, currentChannelId, peerFromId, simplexState.pendingPayIds.payIds);
2405             } else if (simplexState.seqNum == 0) {  // null state
2406                 // this implies both stored seqNums are 0
2407                 require(c.settleFinalizedTime == 0, "intendSettle before");
2408                 require(
2409                     sigs.length == 1 && c._checkSingleSignature(stateHash, sigs[0]),
2410                     "Check sig failed"
2411                 );
2412             } else {
2413                 assert(false);
2414             }
2415 
2416             if (i == simplexStatesNum.sub(1)) {
2417                 _updateOverallStatesByIntendState(_self, currentChannelId);
2418             } else if (i < simplexStatesNum.sub(1)) {
2419                 simplexState = PbEntity.decSimplexPaymentChannel(
2420                     signedSimplexStateArray.signedSimplexStates[i+1].simplexState
2421                 );
2422                 // enforce channelIds of simplex states are ascending
2423                 require(currentChannelId <= simplexState.channelId, "Non-ascending channelIds");
2424                 if (currentChannelId < simplexState.channelId) {
2425                     _updateOverallStatesByIntendState(_self, currentChannelId);
2426                 }
2427             } else {
2428                 assert(false);
2429             }
2430         }
2431     }
2432 
2433     /**
2434      * @notice Read payment results and add results to corresponding simplex payment channel
2435      * @param _self storage data of CelerLedger contract
2436      * @param _channelId ID of the channel
2437      * @param _peerFrom address of the peer who send out funds
2438      * @param _payIdList bytes of a pay id list
2439      */
2440     function clearPays(
2441         LedgerStruct.Ledger storage _self,
2442         bytes32 _channelId,
2443         address _peerFrom,
2444         bytes calldata _payIdList
2445     )
2446         external
2447     {
2448         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2449         require(c.status == LedgerStruct.ChannelStatus.Settling, "Channel status error");
2450         uint peerFromId = c._getPeerId(_peerFrom);
2451 
2452         bytes32 listHash = keccak256(_payIdList);
2453         LedgerStruct.PeerState storage state = c.peerProfiles[peerFromId].state;
2454         require(state.nextPayIdListHash == listHash, "List hash mismatch");
2455 
2456         PbEntity.PayIdList memory payIdList = PbEntity.decPayIdList(_payIdList);
2457         state.nextPayIdListHash = payIdList.nextListHash;
2458         _clearPays(_self, _channelId, peerFromId, payIdList.payIds);
2459     }
2460 
2461     /**
2462      * @notice Confirm channel settlement
2463      * @dev This must be alled after settleFinalizedTime
2464      * @param _self storage data of CelerLedger contract
2465      * @param _channelId ID of the channel
2466      */
2467     function confirmSettle(
2468         LedgerStruct.Ledger storage _self,
2469         bytes32 _channelId
2470     )
2471         external
2472     {
2473         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2474         LedgerStruct.PeerProfile[2] storage peerProfiles = c.peerProfiles;
2475         uint blockNumber = block.number;
2476         require(c.status == LedgerStruct.ChannelStatus.Settling, "Channel status error");
2477         // require no new intendSettle can be called
2478         require(blockNumber >= c.settleFinalizedTime, "Settle is not finalized");
2479 
2480         // require channel status of current intendSettle has been finalized,
2481         // namely all payments have already been either cleared or expired
2482         // TODO: here we should use (lastPayResolveDeadline + clear safe margin)
2483         //   instead of lastPayResolveDeadline to avoid race condition between clearPays
2484         //   and confirmSettle, which may lead to different settle balance. Add this safe
2485         //   margin to the value of lastPayResolveDeadline for now as a temporary solution.
2486         require(
2487             (peerProfiles[0].state.nextPayIdListHash == bytes32(0) ||
2488                 blockNumber > peerProfiles[0].state.lastPayResolveDeadline) &&
2489             (peerProfiles[1].state.nextPayIdListHash == bytes32(0) ||
2490                 blockNumber > peerProfiles[1].state.lastPayResolveDeadline),
2491             "Payments are not finalized"
2492         );
2493 
2494         (bool validBalance, uint[2] memory settleBalance) = c._validateSettleBalance();
2495         if (!validBalance) {
2496             _resetDuplexState(_self, c);
2497             emit ConfirmSettleFail(_channelId);
2498             return;
2499         }
2500 
2501         _updateChannelStatus(_self, c, LedgerStruct.ChannelStatus.Closed);
2502 
2503         emit ConfirmSettle(_channelId, settleBalance);
2504 
2505         // Withdrawal from Contracts pattern is needless here,
2506         // because peers need to sign messages which implies that they can't be contracts
2507         _batchTransferOut(
2508             _self,
2509             _channelId,
2510             c.token.tokenAddress,
2511             [peerProfiles[0].peerAddr, peerProfiles[1].peerAddr],
2512             settleBalance
2513         );
2514     }
2515 
2516     /**
2517      * @notice Cooperatively settle the channel
2518      * @param _self storage data of CelerLedger contract
2519      * @param _settleRequest bytes of cooperative settle request message
2520      */
2521     function cooperativeSettle(
2522         LedgerStruct.Ledger storage _self,
2523         bytes calldata _settleRequest
2524     )
2525         external
2526     {
2527         PbChain.CooperativeSettleRequest memory settleRequest =
2528             PbChain.decCooperativeSettleRequest(_settleRequest);
2529         PbEntity.CooperativeSettleInfo memory settleInfo =
2530             PbEntity.decCooperativeSettleInfo(settleRequest.settleInfo);
2531         bytes32 channelId = settleInfo.channelId;
2532         LedgerStruct.Channel storage c = _self.channelMap[channelId];
2533         require(
2534             c.status == LedgerStruct.ChannelStatus.Operable ||
2535             c.status == LedgerStruct.ChannelStatus.Settling,
2536             "Channel status error"
2537         );
2538 
2539         bytes32 h = keccak256(settleRequest.settleInfo);
2540         require(c._checkCoSignatures(h, settleRequest.sigs), "Check co-sigs failed");
2541 
2542         address[2] memory peerAddrs = [c.peerProfiles[0].peerAddr, c.peerProfiles[1].peerAddr];
2543         require(
2544             settleInfo.seqNum > c.peerProfiles[0].state.seqNum &&
2545                 settleInfo.seqNum > c.peerProfiles[1].state.seqNum,
2546             "seqNum error"
2547         );
2548         require(settleInfo.settleDeadline >= block.number, "Settle deadline passed");
2549         // require distribution is consistent with the order of peerAddrs in channel
2550         require(
2551             settleInfo.settleBalance[0].account == peerAddrs[0] &&
2552                 settleInfo.settleBalance[1].account == peerAddrs[1],
2553             "Settle accounts mismatch"
2554         );
2555 
2556         uint[2] memory settleBalance = [
2557             settleInfo.settleBalance[0].amt,
2558             settleInfo.settleBalance[1].amt
2559         ];
2560         require(settleBalance[0].add(settleBalance[1]) == c.getTotalBalance(), "Balance sum mismatch");
2561 
2562         _updateChannelStatus(_self, c, LedgerStruct.ChannelStatus.Closed);
2563 
2564         emit CooperativeSettle(channelId, settleBalance);
2565 
2566         _batchTransferOut(_self, channelId, c.token.tokenAddress, peerAddrs, settleBalance);
2567     }
2568 
2569     /**
2570      * @notice Return channel number of given status in this contract
2571      * @param _self storage data of CelerLedger contract
2572      * @param _channelStatus query channel status converted to uint
2573      * @return channel number of the status
2574      */
2575     function getChannelStatusNum(
2576         LedgerStruct.Ledger storage _self,
2577         uint _channelStatus
2578     )
2579         external
2580         view
2581         returns(uint)
2582     {
2583         return _self.channelStatusNums[_channelStatus];
2584     }
2585 
2586     /**
2587      * @notice Return EthPool used by this CelerLedger contract
2588      * @param _self storage data of CelerLedger contract
2589      * @return EthPool address
2590      */
2591     function getEthPool(LedgerStruct.Ledger storage _self) external view returns(address) {
2592         return address(_self.ethPool);
2593     }
2594 
2595     /**
2596      * @notice Return PayRegistry used by this CelerLedger contract
2597      * @param _self storage data of CelerLedger contract
2598      * @return PayRegistry address
2599      */
2600     function getPayRegistry(LedgerStruct.Ledger storage _self) external view returns(address) {
2601         return address(_self.payRegistry);
2602     }
2603 
2604     /**
2605      * @notice Return CelerWallet used by this CelerLedger contract
2606      * @param _self storage data of CelerLedger contract
2607      * @return CelerWallet address
2608      */
2609     function getCelerWallet(LedgerStruct.Ledger storage _self) external view returns(address) {
2610         return address(_self.celerWallet);
2611     }
2612 
2613     /**
2614      * @notice create a wallet for a new channel
2615      * @param _self storage data of CelerLedger contract
2616      * @param _w celer wallet
2617      * @param _peers peers of the new channel
2618      * @param _nonce nonce for creating the wallet
2619      * @return channel id, which is same as the created wallet id
2620      * @return storage pointer of the channel
2621      */
2622     function _createWallet(
2623         LedgerStruct.Ledger storage _self,
2624         ICelerWallet _w,
2625         address[2] memory _peers,
2626         bytes32 _nonce
2627     )
2628         internal
2629         returns(bytes32, LedgerStruct.Channel storage)
2630     {
2631         address[] memory owners = new address[](2);
2632         owners[0] = _peers[0];
2633         owners[1] = _peers[1];
2634         // it is safe to use abi.encodePacked() with only one dynamic variable
2635         // use walletId as channelId
2636         bytes32 channelId = _w.create(owners, address(this), _nonce);
2637         // 0 is reserved for non-channel indication
2638         require(channelId != bytes32(0), "channelId gets 0");
2639         LedgerStruct.Channel storage c = _self.channelMap[channelId];
2640         // No harm in having this check in case of keccak256 being broken 
2641         require(c.status == LedgerStruct.ChannelStatus.Uninitialized, "Occupied channelId");
2642 
2643         return (channelId, c);
2644     }
2645 
2646     /**
2647      * @notice Internal function to add deposit of a channel
2648      * @param _self storage data of CelerLedger contract
2649      * @param _channelId ID of the channel
2650      * @param _receiver address of the receiver
2651      * @param _amount the amount to be deposited
2652      */
2653     function _addDeposit(
2654         LedgerStruct.Ledger storage _self,
2655         bytes32 _channelId,
2656         address _receiver,
2657         uint _amount
2658     )
2659         internal
2660     {
2661         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2662         require(c.status == LedgerStruct.ChannelStatus.Operable, "Channel status error");
2663 
2664         // this implicitly require _receiver be a peer
2665         uint rid = c._getPeerId(_receiver);
2666         if (_self.balanceLimitsEnabled) {
2667             require(
2668                 _amount.add(c.getTotalBalance()) <= _self.balanceLimits[c.token.tokenAddress],
2669                 "Balance exceeds limit"
2670             );
2671         }
2672 
2673         c.peerProfiles[rid].deposit = c.peerProfiles[rid].deposit.add(_amount);
2674 
2675         (
2676             address[2] memory peerAddrs,
2677             uint[2] memory deposits,
2678             uint[2] memory withdrawals
2679         ) = c.getBalanceMap();
2680         emit Deposit(_channelId, peerAddrs, deposits, withdrawals);
2681     }
2682 
2683     /**
2684      * @notice Internal function to transfer funds out in batch
2685      * @param _self storage data of CelerLedger contract
2686      * @param _channelId ID of the channel
2687      * @param _tokenAddr address of tokens to be transferred out
2688      * @param _receivers the addresses of token receivers
2689      * @param _amounts the amounts to be transferred
2690      */
2691     function _batchTransferOut(
2692         LedgerStruct.Ledger storage _self,
2693         bytes32 _channelId,
2694         address _tokenAddr,
2695         address[2] memory _receivers,
2696         uint[2] memory _amounts
2697     )
2698         internal
2699     {
2700         for (uint i = 0; i < 2; i++) {
2701             if (_amounts[i] == 0) { continue; }
2702 
2703             _self.celerWallet.withdraw(_channelId, _tokenAddr, _receivers[i], _amounts[i]);
2704         }
2705     }
2706 
2707     /**
2708      * @notice Internal function to withdraw funds out of the channel
2709      * @param _self storage data of CelerLedger contract
2710      * @param _channelId ID of the channel
2711      * @param _receiver address of the receiver of the withdrawn funds
2712      * @param _amount the amount of the withdrawn funds
2713      * @param _recipientChannelId ID of the recipient channel
2714      */
2715     function _withdrawFunds(
2716         LedgerStruct.Ledger storage _self,
2717         bytes32 _channelId,
2718         address _receiver,
2719         uint _amount,
2720         bytes32 _recipientChannelId
2721     )
2722         internal
2723     {
2724         if (_amount == 0) { return; }
2725 
2726         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2727         if (_recipientChannelId == bytes32(0)) {
2728             _self.celerWallet.withdraw(_channelId, c.token.tokenAddress, _receiver, _amount);
2729         } else {
2730             LedgerStruct.Channel storage recipientChannel = _self.channelMap[_recipientChannelId];
2731             require(
2732                 c.token.tokenType == recipientChannel.token.tokenType &&
2733                     c.token.tokenAddress == recipientChannel.token.tokenAddress,
2734                 "Token mismatch of recipient channel"
2735             );
2736             _addDeposit(_self, _recipientChannelId, _receiver, _amount);
2737 
2738             // move funds from one channel's wallet to another channel's wallet
2739             _self.celerWallet.transferToWallet(
2740                 _channelId,
2741                 _recipientChannelId,
2742                 c.token.tokenAddress,
2743                 _receiver,
2744                 _amount
2745             );
2746         }
2747     }
2748 
2749     /**
2750      * @notice Reset the state of the channel
2751      * @param _self storage data of CelerLedger contract
2752      * @param _c the channel
2753      */
2754     function _resetDuplexState(
2755         LedgerStruct.Ledger storage _self,
2756         LedgerStruct.Channel storage _c
2757     )
2758         internal
2759     {
2760         delete _c.settleFinalizedTime;
2761         _updateChannelStatus(_self, _c, LedgerStruct.ChannelStatus.Operable);
2762         delete _c.peerProfiles[0].state;
2763         delete _c.peerProfiles[1].state;
2764         // reset possibly remaining WithdrawIntent freezed by previous intendSettle()
2765         delete _c.withdrawIntent;
2766     }
2767 
2768     /**
2769      * @notice Clear payments by their hash array
2770      * @param _self storage data of CelerLedger contract
2771      * @param _channelId the channel ID
2772      * @param _peerId ID of the peer who sends out funds
2773      * @param _payIds array of pay ids to clear
2774      */
2775     function _clearPays(
2776         LedgerStruct.Ledger storage _self,
2777         bytes32 _channelId,
2778         uint _peerId,
2779         bytes32[] memory _payIds
2780     )
2781         internal
2782     {
2783         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2784         uint[] memory outAmts = _self.payRegistry.getPayAmounts(
2785             _payIds,
2786             c.peerProfiles[_peerId].state.lastPayResolveDeadline
2787         );
2788 
2789         uint totalAmtOut = 0;
2790         for (uint i = 0; i < outAmts.length; i++) {
2791             totalAmtOut = totalAmtOut.add(outAmts[i]);
2792             emit ClearOnePay(_channelId, _payIds[i], c.peerProfiles[_peerId].peerAddr, outAmts[i]);
2793         }
2794         c.peerProfiles[_peerId].state.transferOut =
2795             c.peerProfiles[_peerId].state.transferOut.add(totalAmtOut);
2796     }
2797 
2798     /**
2799      * @notice Update overall states of a duplex channel
2800      * @param _self storage data of CelerLedger contract
2801      * @param _channelId the channel ID
2802      */
2803     function _updateOverallStatesByIntendState(
2804         LedgerStruct.Ledger storage _self,
2805         bytes32 _channelId
2806     )
2807         internal
2808     {
2809         LedgerStruct.Channel storage c = _self.channelMap[_channelId];
2810         c.settleFinalizedTime = block.number.add(c.disputeTimeout);
2811         _updateChannelStatus(_self, c, LedgerStruct.ChannelStatus.Settling);
2812 
2813         emit IntendSettle(_channelId, c._getStateSeqNums());
2814     }
2815 
2816     /**
2817      * @notice Update status of a channel
2818      * @param _self storage data of CelerLedger contract
2819      * @param _c the channel
2820      * @param _newStatus new channel status
2821      */
2822     function _updateChannelStatus(
2823         LedgerStruct.Ledger storage _self,
2824         LedgerStruct.Channel storage _c,
2825         LedgerStruct.ChannelStatus _newStatus
2826     )
2827         internal
2828     {
2829         if (_c.status == _newStatus) {
2830             return;
2831         }
2832 
2833         // update counter of old status
2834         if (_c.status != LedgerStruct.ChannelStatus.Uninitialized) {
2835             _self.channelStatusNums[uint(_c.status)] = _self.channelStatusNums[uint(_c.status)].sub(1);
2836         }
2837 
2838         // update counter of new status
2839         _self.channelStatusNums[uint(_newStatus)] = _self.channelStatusNums[uint(_newStatus)].add(1);
2840 
2841         _c.status = _newStatus;
2842     }
2843 
2844     /**
2845      * @notice Validate token info
2846      * @param _token token info to be validated
2847      * @return validated token info
2848      */
2849     function _validateTokenInfo(PbEntity.TokenInfo memory _token)
2850         internal
2851         view
2852         returns(PbEntity.TokenInfo memory)
2853     {
2854         if (_token.tokenType == PbEntity.TokenType.ETH) {
2855             require(_token.tokenAddress == address(0));
2856         } else if (_token.tokenType == PbEntity.TokenType.ERC20) {
2857             require(_token.tokenAddress != address(0));
2858             require(_token.tokenAddress.isContract());
2859         } else {
2860             assert(false);
2861         }
2862 
2863         return _token;
2864     }
2865 
2866     event OpenChannel(
2867         bytes32 indexed channelId,
2868         uint tokenType,
2869         address indexed tokenAddress,
2870         // TODO: there is an issue of setting address[2] as indexed. Need to fix and make this indexed
2871         address[2] peerAddrs,
2872         uint[2] initialDeposits
2873     );
2874 
2875     // TODO: there is an issue of setting address[2] as indexed. Need to fix and make this indexed
2876     event Deposit(bytes32 indexed channelId, address[2] peerAddrs, uint[2] deposits, uint[2] withdrawals);
2877 
2878     event SnapshotStates(bytes32 indexed channelId, uint[2] seqNums);
2879 
2880     event IntendSettle(bytes32 indexed channelId, uint[2] seqNums);
2881 
2882     event ClearOnePay(bytes32 indexed channelId, bytes32 indexed payId, address indexed peerFrom, uint amount);
2883 
2884     event ConfirmSettle(bytes32 indexed channelId, uint[2] settleBalance);
2885 
2886     event ConfirmSettleFail(bytes32 indexed channelId);
2887 
2888     event IntendWithdraw(bytes32 indexed channelId, address indexed receiver, uint amount);
2889 
2890     event ConfirmWithdraw(
2891         bytes32 indexed channelId,
2892         uint withdrawnAmount,
2893         address indexed receiver,
2894         bytes32 indexed recipientChannelId,
2895         uint[2] deposits,
2896         uint[2] withdrawals
2897     );
2898 
2899     event VetoWithdraw(bytes32 indexed channelId);
2900 
2901     event CooperativeWithdraw(
2902         bytes32 indexed channelId,
2903         uint withdrawnAmount,
2904         address indexed receiver,
2905         bytes32 indexed recipientChannelId,
2906         uint[2] deposits,
2907         uint[2] withdrawals,
2908         uint seqNum
2909     );
2910 
2911     event CooperativeSettle(bytes32 indexed channelId, uint[2] settleBalance);
2912 }
2913 
2914 // File: contracts/lib/ledgerlib/LedgerBalanceLimit.sol
2915 
2916 pragma solidity ^0.5.1;
2917 
2918 
2919 /**
2920  * @title Ledger Balance Limit Library
2921  * @notice CelerLedger library about balance limits
2922  */
2923 library LedgerBalanceLimit {
2924     /**
2925      * @notice Set the balance limits of given tokens
2926      * @param _self storage data of CelerLedger contract
2927      * @param _tokenAddrs addresses of the tokens (address(0) is for ETH)
2928      * @param _limits balance limits of the tokens
2929      */
2930     function setBalanceLimits(
2931         LedgerStruct.Ledger storage _self,
2932         address[] calldata _tokenAddrs,
2933         uint[] calldata _limits
2934     )
2935         external
2936     {
2937         require(_tokenAddrs.length == _limits.length, "Lengths do not match");
2938         for (uint i = 0; i < _tokenAddrs.length; i++) {
2939             _self.balanceLimits[_tokenAddrs[i]] = _limits[i];
2940         }
2941     }
2942 
2943     /**
2944      * @notice Disable balance limits of all tokens
2945      * @param _self storage data of CelerLedger contract
2946      */
2947     function disableBalanceLimits(LedgerStruct.Ledger storage _self) external {
2948         _self.balanceLimitsEnabled = false;
2949     }
2950 
2951     /**
2952      * @notice Enable balance limits of all tokens
2953      * @param _self storage data of CelerLedger contract
2954      */
2955     function enableBalanceLimits(LedgerStruct.Ledger storage _self) external {
2956         _self.balanceLimitsEnabled = true;
2957     }
2958 
2959     /**
2960      * @notice Return balance limit of given token
2961      * @param _self storage data of CelerLedger contract
2962      * @param _tokenAddr query token address
2963      * @return token balance limit
2964      */
2965     function getBalanceLimit(
2966         LedgerStruct.Ledger storage _self,
2967         address _tokenAddr
2968     )
2969         external
2970         view
2971         returns(uint)
2972     {
2973         return _self.balanceLimits[_tokenAddr];
2974     }
2975 
2976     /**
2977      * @notice Return balanceLimitsEnabled
2978      * @param _self storage data of CelerLedger contract
2979      * @return balanceLimitsEnabled
2980      */
2981     function getBalanceLimitsEnabled(LedgerStruct.Ledger storage _self) external view returns(bool) {
2982         return _self.balanceLimitsEnabled;
2983     }
2984 }
2985 
2986 // File: contracts/lib/ledgerlib/LedgerMigrate.sol
2987 
2988 pragma solidity ^0.5.1;
2989 
2990 
2991 
2992 
2993 
2994 
2995 
2996 /**
2997  * @title Ledger Migrate Library
2998  * @notice CelerLedger library about channel migration
2999  */
3000 library LedgerMigrate {
3001     using LedgerChannel for LedgerStruct.Channel;
3002     using LedgerOperation for LedgerStruct.Ledger;
3003 
3004     /**
3005      * @notice Migrate a channel from this CelerLedger to a new CelerLedger
3006      * @param _self storage data of CelerLedger contract
3007      * @param _migrationRequest bytes of migration request message
3008      * @return migrated channel id
3009      */
3010     function migrateChannelTo(
3011         LedgerStruct.Ledger storage _self,
3012         bytes calldata _migrationRequest
3013     )
3014         external returns(bytes32) 
3015     {
3016         PbChain.ChannelMigrationRequest memory migrationRequest = 
3017             PbChain.decChannelMigrationRequest(_migrationRequest);
3018         PbEntity.ChannelMigrationInfo memory migrationInfo = 
3019             PbEntity.decChannelMigrationInfo(migrationRequest.channelMigrationInfo);
3020         bytes32 channelId = migrationInfo.channelId;
3021         LedgerStruct.Channel storage c = _self.channelMap[channelId];
3022         address toLedgerAddr = migrationInfo.toLedgerAddress;
3023 
3024         require(
3025             c.status == LedgerStruct.ChannelStatus.Operable ||
3026             c.status == LedgerStruct.ChannelStatus.Settling
3027         );
3028         bytes32 h = keccak256(migrationRequest.channelMigrationInfo);
3029         // use Channel Library instead
3030         require(c._checkCoSignatures(h, migrationRequest.sigs), "Check co-sigs failed");
3031         require(migrationInfo.fromLedgerAddress == address(this), "From ledger address is not this");
3032         require(toLedgerAddr == msg.sender, "To ledger address is not msg.sender");
3033         require(block.number <= migrationInfo.migrationDeadline, "Passed migration deadline");
3034 
3035         _self._updateChannelStatus(c, LedgerStruct.ChannelStatus.Migrated);
3036         c.migratedTo = toLedgerAddr;
3037         emit MigrateChannelTo(channelId, toLedgerAddr);
3038 
3039         _self.celerWallet.transferOperatorship(channelId, toLedgerAddr);
3040 
3041         return channelId;
3042     }
3043 
3044     /**
3045      * @notice Migrate a channel from an old CelerLedger to this CelerLedger
3046      * @param _self storage data of CelerLedger contract
3047      * @param _fromLedgerAddr the old ledger address to migrate from
3048      * @param _migrationRequest bytes of migration request message
3049      */
3050     // TODO: think about future multi versions upgrade (if-else branch for addr and import libs as mini-v1, mini-v2, mini-v3,
3051     //       otherwise, only one interface can be used because all interfaces share the same name.)
3052     function migrateChannelFrom(
3053         LedgerStruct.Ledger storage _self,
3054         address _fromLedgerAddr,
3055         bytes calldata _migrationRequest
3056     )
3057         external
3058     {
3059         // TODO: latest version of openzeppelin Address.sol provide this api toPayable()
3060         address payable fromLedgerAddrPayable = address(uint160(_fromLedgerAddr));
3061         bytes32 channelId = ICelerLedger(fromLedgerAddrPayable).migrateChannelTo(_migrationRequest);
3062         LedgerStruct.Channel storage c = _self.channelMap[channelId];
3063         require(c.status == LedgerStruct.ChannelStatus.Uninitialized, "Immigrated channel already exists");
3064         require(
3065             _self.celerWallet.getOperator(channelId) == address(this),
3066             "Operatorship not transferred"
3067         );
3068 
3069         _self._updateChannelStatus(c, LedgerStruct.ChannelStatus.Operable);
3070         c._importChannelMigrationArgs(fromLedgerAddrPayable, channelId);
3071         c._importPeersMigrationInfo(fromLedgerAddrPayable, channelId);
3072 
3073         emit MigrateChannelFrom(channelId, _fromLedgerAddr);
3074     }
3075     
3076     event MigrateChannelTo(bytes32 indexed channelId, address indexed newLedgerAddr);
3077     
3078     event MigrateChannelFrom(bytes32 indexed channelId, address indexed oldLedgerAddr);
3079 }
3080 
3081 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
3082 
3083 pragma solidity ^0.5.0;
3084 
3085 /**
3086  * @title Ownable
3087  * @dev The Ownable contract has an owner address, and provides basic authorization control
3088  * functions, this simplifies the implementation of "user permissions".
3089  */
3090 contract Ownable {
3091     address private _owner;
3092 
3093     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3094 
3095     /**
3096      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
3097      * account.
3098      */
3099     constructor () internal {
3100         _owner = msg.sender;
3101         emit OwnershipTransferred(address(0), _owner);
3102     }
3103 
3104     /**
3105      * @return the address of the owner.
3106      */
3107     function owner() public view returns (address) {
3108         return _owner;
3109     }
3110 
3111     /**
3112      * @dev Throws if called by any account other than the owner.
3113      */
3114     modifier onlyOwner() {
3115         require(isOwner());
3116         _;
3117     }
3118 
3119     /**
3120      * @return true if `msg.sender` is the owner of the contract.
3121      */
3122     function isOwner() public view returns (bool) {
3123         return msg.sender == _owner;
3124     }
3125 
3126     /**
3127      * @dev Allows the current owner to relinquish control of the contract.
3128      * @notice Renouncing to ownership will leave the contract without an owner.
3129      * It will not be possible to call the functions with the `onlyOwner`
3130      * modifier anymore.
3131      */
3132     function renounceOwnership() public onlyOwner {
3133         emit OwnershipTransferred(_owner, address(0));
3134         _owner = address(0);
3135     }
3136 
3137     /**
3138      * @dev Allows the current owner to transfer control of the contract to a newOwner.
3139      * @param newOwner The address to transfer ownership to.
3140      */
3141     function transferOwnership(address newOwner) public onlyOwner {
3142         _transferOwnership(newOwner);
3143     }
3144 
3145     /**
3146      * @dev Transfers control of the contract to a newOwner.
3147      * @param newOwner The address to transfer ownership to.
3148      */
3149     function _transferOwnership(address newOwner) internal {
3150         require(newOwner != address(0));
3151         emit OwnershipTransferred(_owner, newOwner);
3152         _owner = newOwner;
3153     }
3154 }
3155 
3156 // File: contracts/CelerLedger.sol
3157 
3158 pragma solidity ^0.5.1;
3159 
3160 
3161 
3162 
3163 
3164 
3165 
3166 
3167 
3168 
3169 /**
3170  * @title CelerLedger wrapper contract
3171  * @notice A wrapper contract using libraries to provide CelerLedger's APIs.
3172  */
3173 contract CelerLedger is ICelerLedger, Ownable {
3174     using LedgerOperation for LedgerStruct.Ledger;
3175     using LedgerBalanceLimit for LedgerStruct.Ledger;
3176     using LedgerMigrate for LedgerStruct.Ledger;
3177     using LedgerChannel for LedgerStruct.Channel;
3178 
3179     LedgerStruct.Ledger private ledger;
3180 
3181     /**
3182      * @notice CelerChannel constructor
3183      * @param _ethPool address of ETH pool
3184      * @param _payRegistry address of PayRegistry
3185      */
3186     constructor(address _ethPool, address _payRegistry, address _celerWallet) public {
3187         ledger.ethPool = IEthPool(_ethPool);
3188         ledger.payRegistry = IPayRegistry(_payRegistry);
3189         ledger.celerWallet = ICelerWallet(_celerWallet);
3190         // enable deposit limits in default
3191         ledger.balanceLimitsEnabled = true;
3192     }
3193 
3194     /**
3195      * @notice Set the deposit limits of given tokens
3196      * @param _tokenAddrs addresses of the tokens (address(0) is for ETH)
3197      * @param _limits deposit limits of the tokens
3198      */
3199     function setBalanceLimits(
3200         address[] calldata _tokenAddrs,
3201         uint[] calldata _limits
3202     )
3203         external
3204         onlyOwner
3205     {
3206         ledger.setBalanceLimits(_tokenAddrs, _limits);
3207     }
3208 
3209     /**
3210      * @notice Disable deposit limits of all tokens
3211      */
3212     function disableBalanceLimits() external onlyOwner {
3213         ledger.disableBalanceLimits();
3214     }
3215 
3216     /**
3217      * @notice Enable deposit limits of all tokens
3218      */
3219     function enableBalanceLimits() external onlyOwner {
3220         ledger.enableBalanceLimits();
3221     }
3222 
3223     /**
3224      * @notice Open a state channel through auth withdraw message
3225      * @param _openRequest bytes of open channel request message
3226      */
3227     function openChannel(bytes calldata _openRequest) external payable {
3228         ledger.openChannel(_openRequest);
3229     }
3230 
3231     /**
3232      * @notice Deposit ETH or ERC20 tokens into the channel
3233      * @dev total deposit amount = msg.value(must be 0 for ERC20) + _transferFromAmount
3234      * @param _channelId ID of the channel
3235      * @param _receiver address of the receiver
3236      * @param _transferFromAmount amount of funds to be transfered from EthPool for ETH
3237      *   or ERC20 contract for ERC20 tokens
3238      */
3239     function deposit(
3240         bytes32 _channelId,
3241         address _receiver,
3242         uint _transferFromAmount
3243     )
3244         external payable
3245     {
3246         ledger.deposit(_channelId, _receiver, _transferFromAmount);
3247     }
3248 
3249     /**
3250      * @notice Deposit ETH via EthPool or ERC20 tokens into the channel
3251      * @dev do not support sending ETH in msg.value for function simplicity.
3252      *   Index in three arrays should match.
3253      * @param _channelIds IDs of the channels
3254      * @param _receivers addresses of the receivers
3255      * @param _transferFromAmounts amounts of funds to be transfered from EthPool for ETH
3256      *   or ERC20 contract for ERC20 tokens
3257      */
3258     function depositInBatch(
3259         bytes32[] calldata _channelIds,
3260         address[] calldata _receivers,
3261         uint[] calldata _transferFromAmounts
3262     )
3263         external
3264     {
3265         require(
3266             _channelIds.length == _receivers.length && _receivers.length == _transferFromAmounts.length,
3267             "Lengths do not match"
3268         );
3269         for (uint i = 0; i < _channelIds.length; i++) {
3270             ledger.deposit(_channelIds[i], _receivers[i], _transferFromAmounts[i]);
3271         }
3272     }
3273 
3274     /**
3275      * @notice Store signed simplex states on-chain as checkpoints
3276      * @dev simplex states in this array are not necessarily in the same channel,
3277      *   which means snapshotStates natively supports multi-channel batch processing.
3278      *   This function only updates seqNum, transferOut, pendingPayOut of each on-chain
3279      *   simplex state. It can't ensure that the pending pays will be cleared during
3280      *   settling the channel, which requires users call intendSettle with the same state.
3281      *   TODO: wait for Solidity's support to replace SignedSimplexStateArray with bytes[].
3282      * @param _signedSimplexStateArray bytes of SignedSimplexStateArray message
3283      */
3284     function snapshotStates(bytes calldata _signedSimplexStateArray) external {
3285         ledger.snapshotStates(_signedSimplexStateArray);
3286     }
3287 
3288     /**
3289      * @notice Intend to withdraw funds from channel
3290      * @dev only peers can call intendWithdraw
3291      * @param _channelId ID of the channel
3292      * @param _amount amount of funds to withdraw
3293      * @param _recipientChannelId withdraw to receiver address if 0,
3294      *   otherwise deposit to receiver address in the recipient channel
3295      */
3296     function intendWithdraw(bytes32 _channelId, uint _amount, bytes32 _recipientChannelId) external {
3297         ledger.intendWithdraw(_channelId, _amount, _recipientChannelId);
3298     }
3299 
3300     /**
3301      * @notice Confirm channel withdrawal
3302      * @dev anyone can confirm a withdrawal intent
3303      * @param _channelId ID of the channel
3304      */
3305     function confirmWithdraw(bytes32 _channelId) external {
3306         ledger.confirmWithdraw(_channelId);
3307     }
3308 
3309     /**
3310      * @notice Veto current withdrawal intent
3311      * @dev only peers can veto a withdrawal intent;
3312      *   peers can veto a withdrawal intent even after (requestTime + disputeTimeout)
3313      * @param _channelId ID of the channel
3314      */
3315     function vetoWithdraw(bytes32 _channelId) external {
3316         ledger.vetoWithdraw(_channelId);
3317     }
3318 
3319     /**
3320      * @notice Cooperatively withdraw specific amount of deposit
3321      * @param _cooperativeWithdrawRequest bytes of cooperative withdraw request message
3322      */
3323     function cooperativeWithdraw(bytes calldata _cooperativeWithdrawRequest) external {
3324         ledger.cooperativeWithdraw(_cooperativeWithdrawRequest);
3325     }
3326 
3327     /**
3328      * @notice Intend to settle channel(s) with an array of signed simplex states
3329      * @dev simplex states in this array are not necessarily in the same channel,
3330      *   which means intendSettle natively supports multi-channel batch processing.
3331      *   A simplex state with non-zero seqNum (non-null state) must be co-signed by both peers,
3332      *   while a simplex state with seqNum=0 (null state) only needs to be signed by one peer.
3333      *   TODO: wait for Solidity's support to replace SignedSimplexStateArray with bytes[].
3334      * @param _signedSimplexStateArray bytes of SignedSimplexStateArray message
3335      */
3336     function intendSettle(bytes calldata _signedSimplexStateArray) external {
3337         ledger.intendSettle(_signedSimplexStateArray);
3338     }
3339 
3340     /**
3341      * @notice Read payment results and add results to corresponding simplex payment channel
3342      * @param _channelId ID of the channel
3343      * @param _peerFrom address of the peer who send out funds
3344      * @param _payIdList bytes of a pay hash list
3345      */
3346     function clearPays(
3347         bytes32 _channelId,
3348         address _peerFrom,
3349         bytes calldata _payIdList
3350     )
3351         external
3352     {
3353         ledger.clearPays(_channelId, _peerFrom, _payIdList);
3354     }
3355 
3356     /**
3357      * @notice Confirm channel settlement
3358      * @dev This must be alled after settleFinalizedTime
3359      * @param _channelId ID of the channel
3360      */
3361     function confirmSettle(bytes32 _channelId) external {
3362         ledger.confirmSettle(_channelId);
3363     }
3364 
3365     /**
3366      * @notice Cooperatively settle the channel
3367      * @param _settleRequest bytes of cooperative settle request message
3368      */
3369     function cooperativeSettle(bytes calldata _settleRequest) external {
3370         ledger.cooperativeSettle(_settleRequest);
3371     }
3372 
3373     /**
3374      * @notice Migrate a channel from this CelerLedger to a new CelerLedger
3375      * @param _migrationRequest bytes of migration request message
3376      * @return migrated channel id
3377      */
3378     function migrateChannelTo(bytes calldata _migrationRequest) external returns(bytes32) {
3379         return ledger.migrateChannelTo(_migrationRequest);
3380     }
3381 
3382     /**
3383      * @notice Migrate a channel from an old CelerLedger to this CelerLedger
3384      * @param _fromLedgerAddr the old ledger address to migrate from
3385      * @param _migrationRequest bytes of migration request message
3386      */
3387     function migrateChannelFrom(address _fromLedgerAddr, bytes calldata _migrationRequest) external {
3388         ledger.migrateChannelFrom(_fromLedgerAddr, _migrationRequest);
3389     }
3390 
3391     /**
3392      * @notice Get channel confirm settle open time
3393      * @param _channelId ID of the channel to be viewed
3394      * @return channel confirm settle open time
3395      */
3396     function getSettleFinalizedTime(bytes32 _channelId) public view returns(uint) {
3397         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3398         return c.getSettleFinalizedTime();
3399     }
3400 
3401     /**
3402      * @notice Get channel token contract address
3403      * @param _channelId ID of the channel to be viewed
3404      * @return channel token contract address
3405      */
3406     function getTokenContract(bytes32 _channelId) public view returns(address) {
3407         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3408         return c.getTokenContract();
3409 
3410     }
3411 
3412     /**
3413      * @notice Get channel token type
3414      * @param _channelId ID of the channel to be viewed
3415      * @return channel token type
3416      */
3417     function getTokenType(bytes32 _channelId) public view returns(PbEntity.TokenType) {
3418         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3419         return c.getTokenType();
3420     }
3421 
3422     /**
3423      * @notice Get channel status
3424      * @param _channelId ID of the channel to be viewed
3425      * @return channel status
3426      */
3427     function getChannelStatus(bytes32 _channelId) public view returns(LedgerStruct.ChannelStatus) {
3428         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3429         return c.getChannelStatus();
3430     }
3431 
3432     /**
3433      * @notice Get cooperative withdraw seqNum
3434      * @param _channelId ID of the channel to be viewed
3435      * @return cooperative withdraw seqNum
3436      */
3437     function getCooperativeWithdrawSeqNum(bytes32 _channelId) public view returns(uint) {
3438         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3439         return c.getCooperativeWithdrawSeqNum();
3440     }
3441 
3442     /**
3443      * @notice Return one channel's total balance amount
3444      * @param _channelId ID of the channel to be viewed
3445      * @return channel's balance amount
3446      */
3447     function getTotalBalance(bytes32 _channelId) public view returns(uint) {
3448         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3449         return c.getTotalBalance();
3450     }
3451 
3452     /**
3453      * @notice Return one channel's balance info (depositMap and withdrawalMap)
3454      * @dev Solidity can't directly return an array of struct for now
3455      * @param _channelId ID of the channel to be viewed
3456      * @return addresses of peers in the channel
3457      * @return corresponding deposits of the peers (with matched index)
3458      * @return corresponding withdrawals of the peers (with matched index)
3459      */
3460     function getBalanceMap(bytes32 _channelId) public view
3461         returns(address[2] memory, uint[2] memory, uint[2] memory)
3462     {
3463         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3464         return c.getBalanceMap();
3465     }
3466 
3467     /**
3468      * @notice Return channel-level migration arguments
3469      * @param _channelId ID of the channel to be viewed
3470      * @return channel dispute timeout
3471      * @return channel tokey type converted to uint
3472      * @return channel token address
3473      * @return sequence number of cooperative withdraw
3474      */
3475     function getChannelMigrationArgs(bytes32 _channelId) external view returns(uint, uint, address, uint) {
3476         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3477         return c.getChannelMigrationArgs();
3478     }
3479 
3480     /**
3481      * @notice Return migration info of the peers in the channel
3482      * @param _channelId ID of the channel to be viewed
3483      * @return peers' addresses
3484      * @return peers' deposits
3485      * @return peers' owedDeposits
3486      * @return peers' state sequence numbers
3487      * @return peers' transferOut map
3488      * @return peers' pendingPayOut map
3489      */
3490     function getPeersMigrationInfo(bytes32 _channelId) external view returns(
3491         address[2] memory,
3492         uint[2] memory,
3493         uint[2] memory,
3494         uint[2] memory,
3495         uint[2] memory,
3496         uint[2] memory
3497     ) {
3498         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3499         return c.getPeersMigrationInfo();
3500     }
3501 
3502     /**
3503      * @notice Return channel's dispute timeout
3504      * @param _channelId ID of the channel to be viewed
3505      * @return channel's dispute timeout
3506      */
3507     function getDisputeTimeout(bytes32 _channelId) external view returns(uint) {
3508         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3509         return c.getDisputeTimeout();
3510     }
3511 
3512     /**
3513      * @notice Return channel's migratedTo address
3514      * @param _channelId ID of the channel to be viewed
3515      * @return channel's migratedTo address
3516      */
3517     function getMigratedTo(bytes32 _channelId) external view returns(address) {
3518         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3519         return c.getMigratedTo();
3520     }
3521 
3522     /**
3523      * @notice Return state seqNum map of a duplex channel
3524      * @param _channelId ID of the channel to be viewed
3525      * @return peers' addresses
3526      * @return two simplex state sequence numbers
3527      */
3528     function getStateSeqNumMap(bytes32 _channelId) external view returns(
3529         address[2] memory,
3530         uint[2] memory
3531     ) {
3532         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3533         return c.getStateSeqNumMap();
3534     }
3535 
3536     /**
3537      * @notice Return transferOut map of a duplex channel
3538      * @param _channelId ID of the channel to be viewed
3539      * @return peers' addresses
3540      * @return transferOuts of two simplex channels
3541      */
3542     function getTransferOutMap(bytes32 _channelId) external view returns(
3543         address[2] memory,
3544         uint[2] memory
3545     ) {
3546         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3547         return c.getTransferOutMap();
3548     }
3549 
3550     /**
3551      * @notice Return nextPayIdListHash map of a duplex channel
3552      * @param _channelId ID of the channel to be viewed
3553      * @return peers' addresses
3554      * @return nextPayIdListHashes of two simplex channels
3555      */
3556     function getNextPayIdListHashMap(bytes32 _channelId) external view returns(
3557         address[2] memory,
3558         bytes32[2] memory
3559     ) {
3560         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3561         return c.getNextPayIdListHashMap();
3562     }
3563 
3564     /**
3565      * @notice Return lastPayResolveDeadline map of a duplex channel
3566      * @param _channelId ID of the channel to be viewed
3567      * @return peers' addresses
3568      * @return lastPayResolveDeadlines of two simplex channels
3569      */
3570     function getLastPayResolveDeadlineMap(bytes32 _channelId) external view returns(
3571         address[2] memory,
3572         uint[2] memory
3573     ) {
3574         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3575         return c.getLastPayResolveDeadlineMap();
3576     }
3577 
3578     /**
3579      * @notice Return pendingPayOut map of a duplex channel
3580      * @param _channelId ID of the channel to be viewed
3581      * @return peers' addresses
3582      * @return pendingPayOuts of two simplex channels
3583      */
3584     function getPendingPayOutMap(bytes32 _channelId) external view returns(
3585         address[2] memory,
3586         uint[2] memory
3587     ) {
3588         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3589         return c.getPendingPayOutMap();
3590     }
3591 
3592     /**
3593      * @notice Return the withdraw intent info of the channel
3594      * @param _channelId ID of the channel to be viewed
3595      * @return receiver of the withdraw intent
3596      * @return amount of the withdraw intent
3597      * @return requestTime of the withdraw intent
3598      * @return recipientChannelId of the withdraw intent
3599      */
3600     function getWithdrawIntent(bytes32 _channelId) external view returns(address, uint, uint, bytes32) {
3601         LedgerStruct.Channel storage c = ledger.channelMap[_channelId];
3602         return c.getWithdrawIntent();
3603     }
3604 
3605     /**
3606      * @notice Return channel number of given status in this contract
3607      * @param _channelStatus query channel status converted to uint
3608      * @return channel number of the status
3609      */
3610     function getChannelStatusNum(uint _channelStatus) external view returns(uint) {
3611         return ledger.getChannelStatusNum(_channelStatus);
3612     }
3613 
3614     /**
3615      * @notice Return EthPool used by this CelerLedger contract
3616      * @return EthPool address
3617      */
3618     function getEthPool() external view returns(address) {
3619         return ledger.getEthPool();
3620     }
3621 
3622     /**
3623      * @notice Return PayRegistry used by this CelerLedger contract
3624      * @return PayRegistry address
3625      */
3626     function getPayRegistry() external view returns(address) {
3627         return ledger.getPayRegistry();
3628     }
3629 
3630     /**
3631      * @notice Return CelerWallet used by this CelerLedger contract
3632      * @return CelerWallet address
3633      */
3634     function getCelerWallet() external view returns(address) {
3635         return ledger.getCelerWallet();
3636     }
3637 
3638     /**
3639      * @notice Return deposit limit of given token
3640      * @param _tokenAddr query token address
3641      * @return token deposit limit
3642      */
3643     function getBalanceLimit(address _tokenAddr) external view returns(uint) {
3644         return ledger.getBalanceLimit(_tokenAddr);
3645     }
3646 
3647     /**
3648      * @notice Return balanceLimitsEnabled
3649      * @return balanceLimitsEnabled
3650      */
3651     function getBalanceLimitsEnabled() external view returns(bool) {
3652         return ledger.getBalanceLimitsEnabled();
3653     }
3654 }