1 pragma solidity ^0.4.20;
2 
3 pragma solidity ^0.4.21;
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 interface P3DTakeout {
31     function buyTokens() external payable;
32 }
33 
34 contract Race {
35     using SafeMath for uint256; //using safemath
36 
37     address public owner; //owner address
38     address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;
39     P3DTakeout P3DContract_;
40 
41     uint public winnerPoolTotal;
42     string public constant version = "0.2.3";
43 
44     struct chronus_info {
45         bool  betting_open; // boolean: check if betting is open
46         bool  race_start; //boolean: check if race has started
47         bool  race_end; //boolean: check if race has ended
48         bool  voided_bet; //boolean: check if race has been voided
49         uint32  starting_time; // timestamp of when the race starts
50         uint32  betting_duration;
51         uint32  race_duration; // duration of the race
52         uint32 voided_timestamp;
53     }
54 
55     struct horses_info{
56         int64  BTC_delta; //horses.BTC delta value
57         int64  ETH_delta; //horses.ETH delta value
58         int64  LTC_delta; //horses.LTC delta value
59         bytes32 BTC; //32-bytes equivalent of horses.BTC
60         bytes32 ETH; //32-bytes equivalent of horses.ETH
61         bytes32 LTC;  //32-bytes equivalent of horses.LTC
62     }
63 
64     struct bet_info{
65         bytes32 horse; // coin on which amount is bet on
66         uint amount; // amount bet by Bettor
67     }
68     struct coin_info{
69         uint256 pre; // locking price
70         uint256 post; // ending price
71         uint160 total; // total coin pool
72         uint32 count; // number of bets
73         bool price_check;
74     }
75     struct voter_info {
76         uint160 total_bet; //total amount of bet placed
77         bool rewarded; // boolean: check for double spending
78         mapping(bytes32=>uint) bets; //array of bets
79     }
80 
81     mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information
82     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
83 
84     uint public total_reward; // total reward to be awarded
85     uint32 total_bettors;
86     mapping (bytes32 => bool) public winner_horse;
87 
88 
89     // tracking events
90     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
91     event Withdraw(address _to, uint256 _value);
92     event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);
93     event RefundEnabled(string reason);
94 
95     // constructor
96     constructor() public payable {
97         
98         owner = msg.sender;
99         
100         horses.BTC = bytes32("BTC");
101         horses.ETH = bytes32("ETH");
102         horses.LTC = bytes32("LTC");
103         
104         P3DContract_ = P3DTakeout(0x72b2670e55139934D6445348DC6EaB4089B12576);
105     }
106 
107     // data access structures
108     horses_info public horses;
109     chronus_info public chronus;
110 
111     // modifiers for restricting access to methods
112     modifier onlyOwner {
113         require(owner == msg.sender);
114         _;
115     }
116 
117     modifier duringBetting {
118         require(chronus.betting_open);
119         require(now < chronus.starting_time + chronus.betting_duration);
120         _;
121     }
122 
123     modifier beforeBetting {
124         require(!chronus.betting_open && !chronus.race_start);
125         _;
126     }
127 
128     modifier afterRace {
129         require(chronus.race_end);
130         _;
131     }
132 
133     //function to change owner
134     function changeOwnership(address _newOwner) onlyOwner external {
135         owner = _newOwner;
136     }
137 
138     function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {
139         require (!chronus.race_end);
140         emit PriceCallback(coin_pointer, result, isPrePrice);
141         chronus.race_start = true;
142         chronus.betting_open = false;
143         if (isPrePrice) {
144             if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
145                 emit RefundEnabled("Late start price");
146                 forceVoidRace();
147             } else {
148                 coinIndex[coin_pointer].pre = result;
149             }
150         } else if (!isPrePrice){
151             if (coinIndex[coin_pointer].pre > 0 ){
152                 if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
153                     emit RefundEnabled("Late end price");
154                     forceVoidRace();
155                 } else {
156                     coinIndex[coin_pointer].post = result;
157                     coinIndex[coin_pointer].price_check = true;
158 
159                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
160                         reward();
161                     }
162                 }
163             } else {
164                 emit RefundEnabled("End price came before start price");
165                 forceVoidRace();
166             }
167         }
168     }
169 
170     // place a bet on a coin(horse) lockBetting
171     function placeBet(bytes32 horse) external duringBetting payable  {
172         require(msg.value >= 0.01 ether);
173         if (voterIndex[msg.sender].total_bet==0) {
174             total_bettors+=1;
175         }
176         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
177         voterIndex[msg.sender].bets[horse] = _newAmount;
178         voterIndex[msg.sender].total_bet += uint160(msg.value);
179         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);
180         uint32 _newCount = coinIndex[horse].count + 1;
181         coinIndex[horse].total = _newTotal;
182         coinIndex[horse].count = _newCount;
183         emit Deposit(msg.sender, msg.value, horse, now);
184     }
185 
186     // fallback method for accepting payments
187     function () private payable {}
188 
189     // method to place the oraclize queries
190     function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {
191             chronus.starting_time = uint32(block.timestamp);
192             chronus.betting_open = true;
193             chronus.betting_duration = _bettingDuration;
194             chronus.race_duration = _raceDuration;
195     }
196 
197     // method to calculate reward (called internally by callback)
198     function reward() internal {
199         /*
200         calculating the difference in price with a precision of 5 digits
201         not using safemath since signed integers are handled
202         */
203         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
204         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
205         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
206 
207         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
208         if (total_bettors <= 1) {
209             emit RefundEnabled("Not enough participants");
210             forceVoidRace();
211         } else {
212             // house takeout
213             uint house_fee = total_reward.mul(5).div(100);
214             require(house_fee < address(this).balance);
215             total_reward = total_reward.sub(house_fee);
216             house_takeout.transfer(house_fee);
217             
218             // p3d takeout
219             uint p3d_fee = house_fee/2;
220             require(p3d_fee < address(this).balance);
221             total_reward = total_reward.sub(p3d_fee);
222             P3DContract_.buyTokens.value(p3d_fee)();
223         }
224 
225         if (horses.BTC_delta > horses.ETH_delta) {
226             if (horses.BTC_delta > horses.LTC_delta) {
227                 winner_horse[horses.BTC] = true;
228                 winnerPoolTotal = coinIndex[horses.BTC].total;
229             }
230             else if(horses.LTC_delta > horses.BTC_delta) {
231                 winner_horse[horses.LTC] = true;
232                 winnerPoolTotal = coinIndex[horses.LTC].total;
233             } else {
234                 winner_horse[horses.BTC] = true;
235                 winner_horse[horses.LTC] = true;
236                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
237             }
238         } else if(horses.ETH_delta > horses.BTC_delta) {
239             if (horses.ETH_delta > horses.LTC_delta) {
240                 winner_horse[horses.ETH] = true;
241                 winnerPoolTotal = coinIndex[horses.ETH].total;
242             }
243             else if (horses.LTC_delta > horses.ETH_delta) {
244                 winner_horse[horses.LTC] = true;
245                 winnerPoolTotal = coinIndex[horses.LTC].total;
246             } else {
247                 winner_horse[horses.ETH] = true;
248                 winner_horse[horses.LTC] = true;
249                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
250             }
251         } else {
252             if (horses.LTC_delta > horses.ETH_delta) {
253                 winner_horse[horses.LTC] = true;
254                 winnerPoolTotal = coinIndex[horses.LTC].total;
255             } else if(horses.LTC_delta < horses.ETH_delta){
256                 winner_horse[horses.ETH] = true;
257                 winner_horse[horses.BTC] = true;
258                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
259             } else {
260                 winner_horse[horses.LTC] = true;
261                 winner_horse[horses.ETH] = true;
262                 winner_horse[horses.BTC] = true;
263                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
264             }
265         }
266         chronus.race_end = true;
267     }
268 
269     // method to calculate an invidual's reward
270     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
271         voter_info storage bettor = voterIndex[candidate];
272         if(chronus.voided_bet) {
273             winner_reward = bettor.total_bet;
274         } else {
275             uint winning_bet_total;
276             if(winner_horse[horses.BTC]) {
277                 winning_bet_total += bettor.bets[horses.BTC];
278             } if(winner_horse[horses.ETH]) {
279                 winning_bet_total += bettor.bets[horses.ETH];
280             } if(winner_horse[horses.LTC]) {
281                 winning_bet_total += bettor.bets[horses.LTC];
282             }
283             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
284         }
285     }
286 
287     // method to just check the reward amount
288     function checkReward() afterRace external constant returns (uint) {
289         require(!voterIndex[msg.sender].rewarded);
290         return calculateReward(msg.sender);
291     }
292 
293     // method to claim the reward amount
294     function claim_reward() afterRace external {
295         require(!voterIndex[msg.sender].rewarded);
296         uint transfer_amount = calculateReward(msg.sender);
297         require(address(this).balance >= transfer_amount);
298         voterIndex[msg.sender].rewarded = true;
299         msg.sender.transfer(transfer_amount);
300         emit Withdraw(msg.sender, transfer_amount);
301     }
302 
303     function forceVoidRace() internal {
304         chronus.voided_bet=true;
305         chronus.race_end = true;
306         chronus.voided_timestamp=uint32(now);
307     }
308 
309     // exposing the coin pool details for DApp
310     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
311         uint256 coinPrePrice;
312         uint256 coinPostPrice;
313         if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {
314             coinPrePrice = coinIndex[index].pre;
315         } 
316         if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {
317             coinPostPrice = coinIndex[index].post;
318         }
319         return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
320     }
321 
322     // exposing the total reward amount for DApp
323     function reward_total() external constant returns (uint) {
324         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
325     }
326 
327     // in case of any errors in race, enable full refund for the Bettors to claim
328     function refund() external onlyOwner {
329         require(now > chronus.starting_time + chronus.race_duration);
330         require((chronus.betting_open && !chronus.race_start)
331             || (chronus.race_start && !chronus.race_end));
332         chronus.voided_bet = true;
333         chronus.race_end = true;
334         chronus.voided_timestamp=uint32(now);
335     }
336 
337     // method to claim unclaimed winnings after 30 day notice period
338     function recovery() external onlyOwner{
339         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
340             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
341         house_takeout.transfer(address(this).balance);
342     }
343 }
344 
345 
346 contract OraclizeI {
347     address public cbAddress;
348     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
349     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
350     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
351     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
352     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
353     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
354     function getPrice(string _datasource) public returns (uint _dsprice);
355     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
356     function setProofType(byte _proofType) external;
357     function setCustomGasPrice(uint _gasPrice) external;
358     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
359 }
360 
361 contract OraclizeAddrResolverI {
362     function getAddress() public returns (address _addr);
363 }
364 
365 /*
366 Begin solidity-cborutils
367 
368 https://github.com/smartcontractkit/solidity-cborutils
369 
370 MIT License
371 
372 Copyright (c) 2018 SmartContract ChainLink, Ltd.
373 
374 Permission is hereby granted, free of charge, to any person obtaining a copy
375 of this software and associated documentation files (the "Software"), to deal
376 in the Software without restriction, including without limitation the rights
377 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
378 copies of the Software, and to permit persons to whom the Software is
379 furnished to do so, subject to the following conditions:
380 
381 The above copyright notice and this permission notice shall be included in all
382 copies or substantial portions of the Software.
383 
384 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
385 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
386 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
387 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
388 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
389 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
390 SOFTWARE.
391  */
392 
393 library Buffer {
394     struct buffer {
395         bytes buf;
396         uint capacity;
397     }
398 
399     function init(buffer memory buf, uint _capacity) internal pure {
400         uint capacity = _capacity;
401         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
402         // Allocate space for the buffer data
403         buf.capacity = capacity;
404         assembly {
405             let ptr := mload(0x40)
406             mstore(buf, ptr)
407             mstore(ptr, 0)
408             mstore(0x40, add(ptr, capacity))
409         }
410     }
411 
412     function resize(buffer memory buf, uint capacity) private pure {
413         bytes memory oldbuf = buf.buf;
414         init(buf, capacity);
415         append(buf, oldbuf);
416     }
417 
418     function max(uint a, uint b) private pure returns(uint) {
419         if(a > b) {
420             return a;
421         }
422         return b;
423     }
424 
425     /**
426      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
427      *      would exceed the capacity of the buffer.
428      * @param buf The buffer to append to.
429      * @param data The data to append.
430      * @return The original buffer.
431      */
432     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
433         if(data.length + buf.buf.length > buf.capacity) {
434             resize(buf, max(buf.capacity, data.length) * 2);
435         }
436 
437         uint dest;
438         uint src;
439         uint len = data.length;
440         assembly {
441             // Memory address of the buffer data
442             let bufptr := mload(buf)
443             // Length of existing buffer data
444             let buflen := mload(bufptr)
445             // Start address = buffer address + buffer length + sizeof(buffer length)
446             dest := add(add(bufptr, buflen), 32)
447             // Update buffer length
448             mstore(bufptr, add(buflen, mload(data)))
449             src := add(data, 32)
450         }
451 
452         // Copy word-length chunks while possible
453         for(; len >= 32; len -= 32) {
454             assembly {
455                 mstore(dest, mload(src))
456             }
457             dest += 32;
458             src += 32;
459         }
460 
461         // Copy remaining bytes
462         uint mask = 256 ** (32 - len) - 1;
463         assembly {
464             let srcpart := and(mload(src), not(mask))
465             let destpart := and(mload(dest), mask)
466             mstore(dest, or(destpart, srcpart))
467         }
468 
469         return buf;
470     }
471 
472     /**
473      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
474      * exceed the capacity of the buffer.
475      * @param buf The buffer to append to.
476      * @param data The data to append.
477      * @return The original buffer.
478      */
479     function append(buffer memory buf, uint8 data) internal pure {
480         if(buf.buf.length + 1 > buf.capacity) {
481             resize(buf, buf.capacity * 2);
482         }
483 
484         assembly {
485             // Memory address of the buffer data
486             let bufptr := mload(buf)
487             // Length of existing buffer data
488             let buflen := mload(bufptr)
489             // Address = buffer address + buffer length + sizeof(buffer length)
490             let dest := add(add(bufptr, buflen), 32)
491             mstore8(dest, data)
492             // Update buffer length
493             mstore(bufptr, add(buflen, 1))
494         }
495     }
496 
497     /**
498      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
499      * exceed the capacity of the buffer.
500      * @param buf The buffer to append to.
501      * @param data The data to append.
502      * @return The original buffer.
503      */
504     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
505         if(len + buf.buf.length > buf.capacity) {
506             resize(buf, max(buf.capacity, len) * 2);
507         }
508 
509         uint mask = 256 ** len - 1;
510         assembly {
511             // Memory address of the buffer data
512             let bufptr := mload(buf)
513             // Length of existing buffer data
514             let buflen := mload(bufptr)
515             // Address = buffer address + buffer length + sizeof(buffer length) + len
516             let dest := add(add(bufptr, buflen), len)
517             mstore(dest, or(and(mload(dest), not(mask)), data))
518             // Update buffer length
519             mstore(bufptr, add(buflen, len))
520         }
521         return buf;
522     }
523 }
524 
525 library CBOR {
526     using Buffer for Buffer.buffer;
527 
528     uint8 private constant MAJOR_TYPE_INT = 0;
529     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
530     uint8 private constant MAJOR_TYPE_BYTES = 2;
531     uint8 private constant MAJOR_TYPE_STRING = 3;
532     uint8 private constant MAJOR_TYPE_ARRAY = 4;
533     uint8 private constant MAJOR_TYPE_MAP = 5;
534     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
535 
536     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
537         if(value <= 23) {
538             buf.append(uint8((major << 5) | value));
539         } else if(value <= 0xFF) {
540             buf.append(uint8((major << 5) | 24));
541             buf.appendInt(value, 1);
542         } else if(value <= 0xFFFF) {
543             buf.append(uint8((major << 5) | 25));
544             buf.appendInt(value, 2);
545         } else if(value <= 0xFFFFFFFF) {
546             buf.append(uint8((major << 5) | 26));
547             buf.appendInt(value, 4);
548         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
549             buf.append(uint8((major << 5) | 27));
550             buf.appendInt(value, 8);
551         }
552     }
553 
554     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
555         buf.append(uint8((major << 5) | 31));
556     }
557 
558     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
559         encodeType(buf, MAJOR_TYPE_INT, value);
560     }
561 
562     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
563         if(value >= 0) {
564             encodeType(buf, MAJOR_TYPE_INT, uint(value));
565         } else {
566             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
567         }
568     }
569 
570     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
571         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
572         buf.append(value);
573     }
574 
575     function encodeString(Buffer.buffer memory buf, string value) internal pure {
576         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
577         buf.append(bytes(value));
578     }
579 
580     function startArray(Buffer.buffer memory buf) internal pure {
581         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
582     }
583 
584     function startMap(Buffer.buffer memory buf) internal pure {
585         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
586     }
587 
588     function endSequence(Buffer.buffer memory buf) internal pure {
589         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
590     }
591 }
592 
593 /*
594 End solidity-cborutils
595  */
596 
597 contract usingOraclize {
598     uint constant day = 60*60*24;
599     uint constant week = 60*60*24*7;
600     uint constant month = 60*60*24*30;
601     byte constant proofType_NONE = 0x00;
602     byte constant proofType_TLSNotary = 0x10;
603     byte constant proofType_Ledger = 0x30;
604     byte constant proofType_Android = 0x40;
605     byte constant proofType_Native = 0xF0;
606     byte constant proofStorage_IPFS = 0x01;
607     uint8 constant networkID_auto = 0;
608     uint8 constant networkID_mainnet = 1;
609     uint8 constant networkID_testnet = 2;
610     uint8 constant networkID_morden = 2;
611     uint8 constant networkID_consensys = 161;
612 
613     OraclizeAddrResolverI OAR;
614 
615     OraclizeI oraclize;
616     modifier oraclizeAPI {
617         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
618             oraclize_setNetwork(networkID_auto);
619 
620         if(address(oraclize) != OAR.getAddress())
621             oraclize = OraclizeI(OAR.getAddress());
622 
623         _;
624     }
625     modifier coupon(string code){
626         oraclize = OraclizeI(OAR.getAddress());
627         _;
628     }
629 
630     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
631       return oraclize_setNetwork();
632       networkID; // silence the warning and remain backwards compatible
633     }
634     function oraclize_setNetwork() internal returns(bool){
635         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
636             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
637             oraclize_setNetworkName("eth_mainnet");
638             return true;
639         }
640         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
641             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
642             oraclize_setNetworkName("eth_ropsten3");
643             return true;
644         }
645         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
646             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
647             oraclize_setNetworkName("eth_kovan");
648             return true;
649         }
650         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
651             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
652             oraclize_setNetworkName("eth_rinkeby");
653             return true;
654         }
655         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
656             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
657             return true;
658         }
659         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
660             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
661             return true;
662         }
663         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
664             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
665             return true;
666         }
667         return false;
668     }
669 
670     function __callback(bytes32 myid, string result) public {
671         __callback(myid, result, new bytes(0));
672     }
673     function __callback(bytes32 myid, string result, bytes proof) public {
674       return;
675       myid; result; proof; // Silence compiler warnings
676     }
677 
678     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
679         return oraclize.getPrice(datasource);
680     }
681 
682     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
683         return oraclize.getPrice(datasource, gaslimit);
684     }
685 
686     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
687         uint price = oraclize.getPrice(datasource);
688         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
689         return oraclize.query.value(price)(0, datasource, arg);
690     }
691     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
692         uint price = oraclize.getPrice(datasource);
693         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
694         return oraclize.query.value(price)(timestamp, datasource, arg);
695     }
696     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
697         uint price = oraclize.getPrice(datasource, gaslimit);
698         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
699         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
700     }
701     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
702         uint price = oraclize.getPrice(datasource, gaslimit);
703         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
704         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
705     }
706     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
707         uint price = oraclize.getPrice(datasource);
708         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
709         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
710     }
711     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
712         uint price = oraclize.getPrice(datasource);
713         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
714         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
715     }
716     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
717         uint price = oraclize.getPrice(datasource, gaslimit);
718         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
719         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
720     }
721     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
722         uint price = oraclize.getPrice(datasource, gaslimit);
723         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
724         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
725     }
726     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
727         uint price = oraclize.getPrice(datasource);
728         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
729         bytes memory args = stra2cbor(argN);
730         return oraclize.queryN.value(price)(0, datasource, args);
731     }
732     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
733         uint price = oraclize.getPrice(datasource);
734         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
735         bytes memory args = stra2cbor(argN);
736         return oraclize.queryN.value(price)(timestamp, datasource, args);
737     }
738     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
739         uint price = oraclize.getPrice(datasource, gaslimit);
740         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
741         bytes memory args = stra2cbor(argN);
742         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
743     }
744     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
745         uint price = oraclize.getPrice(datasource, gaslimit);
746         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
747         bytes memory args = stra2cbor(argN);
748         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
749     }
750     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
751         string[] memory dynargs = new string[](1);
752         dynargs[0] = args[0];
753         return oraclize_query(datasource, dynargs);
754     }
755     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
756         string[] memory dynargs = new string[](1);
757         dynargs[0] = args[0];
758         return oraclize_query(timestamp, datasource, dynargs);
759     }
760     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
761         string[] memory dynargs = new string[](1);
762         dynargs[0] = args[0];
763         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
764     }
765     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
766         string[] memory dynargs = new string[](1);
767         dynargs[0] = args[0];
768         return oraclize_query(datasource, dynargs, gaslimit);
769     }
770 
771     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
772         string[] memory dynargs = new string[](2);
773         dynargs[0] = args[0];
774         dynargs[1] = args[1];
775         return oraclize_query(datasource, dynargs);
776     }
777     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
778         string[] memory dynargs = new string[](2);
779         dynargs[0] = args[0];
780         dynargs[1] = args[1];
781         return oraclize_query(timestamp, datasource, dynargs);
782     }
783     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
784         string[] memory dynargs = new string[](2);
785         dynargs[0] = args[0];
786         dynargs[1] = args[1];
787         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
788     }
789     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
790         string[] memory dynargs = new string[](2);
791         dynargs[0] = args[0];
792         dynargs[1] = args[1];
793         return oraclize_query(datasource, dynargs, gaslimit);
794     }
795     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
796         string[] memory dynargs = new string[](3);
797         dynargs[0] = args[0];
798         dynargs[1] = args[1];
799         dynargs[2] = args[2];
800         return oraclize_query(datasource, dynargs);
801     }
802     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
803         string[] memory dynargs = new string[](3);
804         dynargs[0] = args[0];
805         dynargs[1] = args[1];
806         dynargs[2] = args[2];
807         return oraclize_query(timestamp, datasource, dynargs);
808     }
809     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
810         string[] memory dynargs = new string[](3);
811         dynargs[0] = args[0];
812         dynargs[1] = args[1];
813         dynargs[2] = args[2];
814         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
815     }
816     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
817         string[] memory dynargs = new string[](3);
818         dynargs[0] = args[0];
819         dynargs[1] = args[1];
820         dynargs[2] = args[2];
821         return oraclize_query(datasource, dynargs, gaslimit);
822     }
823 
824     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
825         string[] memory dynargs = new string[](4);
826         dynargs[0] = args[0];
827         dynargs[1] = args[1];
828         dynargs[2] = args[2];
829         dynargs[3] = args[3];
830         return oraclize_query(datasource, dynargs);
831     }
832     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
833         string[] memory dynargs = new string[](4);
834         dynargs[0] = args[0];
835         dynargs[1] = args[1];
836         dynargs[2] = args[2];
837         dynargs[3] = args[3];
838         return oraclize_query(timestamp, datasource, dynargs);
839     }
840     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
841         string[] memory dynargs = new string[](4);
842         dynargs[0] = args[0];
843         dynargs[1] = args[1];
844         dynargs[2] = args[2];
845         dynargs[3] = args[3];
846         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
847     }
848     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
849         string[] memory dynargs = new string[](4);
850         dynargs[0] = args[0];
851         dynargs[1] = args[1];
852         dynargs[2] = args[2];
853         dynargs[3] = args[3];
854         return oraclize_query(datasource, dynargs, gaslimit);
855     }
856     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
857         string[] memory dynargs = new string[](5);
858         dynargs[0] = args[0];
859         dynargs[1] = args[1];
860         dynargs[2] = args[2];
861         dynargs[3] = args[3];
862         dynargs[4] = args[4];
863         return oraclize_query(datasource, dynargs);
864     }
865     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
866         string[] memory dynargs = new string[](5);
867         dynargs[0] = args[0];
868         dynargs[1] = args[1];
869         dynargs[2] = args[2];
870         dynargs[3] = args[3];
871         dynargs[4] = args[4];
872         return oraclize_query(timestamp, datasource, dynargs);
873     }
874     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
875         string[] memory dynargs = new string[](5);
876         dynargs[0] = args[0];
877         dynargs[1] = args[1];
878         dynargs[2] = args[2];
879         dynargs[3] = args[3];
880         dynargs[4] = args[4];
881         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
882     }
883     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
884         string[] memory dynargs = new string[](5);
885         dynargs[0] = args[0];
886         dynargs[1] = args[1];
887         dynargs[2] = args[2];
888         dynargs[3] = args[3];
889         dynargs[4] = args[4];
890         return oraclize_query(datasource, dynargs, gaslimit);
891     }
892     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
893         uint price = oraclize.getPrice(datasource);
894         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
895         bytes memory args = ba2cbor(argN);
896         return oraclize.queryN.value(price)(0, datasource, args);
897     }
898     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
899         uint price = oraclize.getPrice(datasource);
900         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
901         bytes memory args = ba2cbor(argN);
902         return oraclize.queryN.value(price)(timestamp, datasource, args);
903     }
904     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
905         uint price = oraclize.getPrice(datasource, gaslimit);
906         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
907         bytes memory args = ba2cbor(argN);
908         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
909     }
910     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
911         uint price = oraclize.getPrice(datasource, gaslimit);
912         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
913         bytes memory args = ba2cbor(argN);
914         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
915     }
916     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
917         bytes[] memory dynargs = new bytes[](1);
918         dynargs[0] = args[0];
919         return oraclize_query(datasource, dynargs);
920     }
921     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
922         bytes[] memory dynargs = new bytes[](1);
923         dynargs[0] = args[0];
924         return oraclize_query(timestamp, datasource, dynargs);
925     }
926     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
927         bytes[] memory dynargs = new bytes[](1);
928         dynargs[0] = args[0];
929         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
930     }
931     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
932         bytes[] memory dynargs = new bytes[](1);
933         dynargs[0] = args[0];
934         return oraclize_query(datasource, dynargs, gaslimit);
935     }
936 
937     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
938         bytes[] memory dynargs = new bytes[](2);
939         dynargs[0] = args[0];
940         dynargs[1] = args[1];
941         return oraclize_query(datasource, dynargs);
942     }
943     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
944         bytes[] memory dynargs = new bytes[](2);
945         dynargs[0] = args[0];
946         dynargs[1] = args[1];
947         return oraclize_query(timestamp, datasource, dynargs);
948     }
949     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
950         bytes[] memory dynargs = new bytes[](2);
951         dynargs[0] = args[0];
952         dynargs[1] = args[1];
953         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
954     }
955     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
956         bytes[] memory dynargs = new bytes[](2);
957         dynargs[0] = args[0];
958         dynargs[1] = args[1];
959         return oraclize_query(datasource, dynargs, gaslimit);
960     }
961     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
962         bytes[] memory dynargs = new bytes[](3);
963         dynargs[0] = args[0];
964         dynargs[1] = args[1];
965         dynargs[2] = args[2];
966         return oraclize_query(datasource, dynargs);
967     }
968     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
969         bytes[] memory dynargs = new bytes[](3);
970         dynargs[0] = args[0];
971         dynargs[1] = args[1];
972         dynargs[2] = args[2];
973         return oraclize_query(timestamp, datasource, dynargs);
974     }
975     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
976         bytes[] memory dynargs = new bytes[](3);
977         dynargs[0] = args[0];
978         dynargs[1] = args[1];
979         dynargs[2] = args[2];
980         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
981     }
982     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
983         bytes[] memory dynargs = new bytes[](3);
984         dynargs[0] = args[0];
985         dynargs[1] = args[1];
986         dynargs[2] = args[2];
987         return oraclize_query(datasource, dynargs, gaslimit);
988     }
989 
990     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
991         bytes[] memory dynargs = new bytes[](4);
992         dynargs[0] = args[0];
993         dynargs[1] = args[1];
994         dynargs[2] = args[2];
995         dynargs[3] = args[3];
996         return oraclize_query(datasource, dynargs);
997     }
998     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
999         bytes[] memory dynargs = new bytes[](4);
1000         dynargs[0] = args[0];
1001         dynargs[1] = args[1];
1002         dynargs[2] = args[2];
1003         dynargs[3] = args[3];
1004         return oraclize_query(timestamp, datasource, dynargs);
1005     }
1006     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1007         bytes[] memory dynargs = new bytes[](4);
1008         dynargs[0] = args[0];
1009         dynargs[1] = args[1];
1010         dynargs[2] = args[2];
1011         dynargs[3] = args[3];
1012         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1013     }
1014     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1015         bytes[] memory dynargs = new bytes[](4);
1016         dynargs[0] = args[0];
1017         dynargs[1] = args[1];
1018         dynargs[2] = args[2];
1019         dynargs[3] = args[3];
1020         return oraclize_query(datasource, dynargs, gaslimit);
1021     }
1022     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1023         bytes[] memory dynargs = new bytes[](5);
1024         dynargs[0] = args[0];
1025         dynargs[1] = args[1];
1026         dynargs[2] = args[2];
1027         dynargs[3] = args[3];
1028         dynargs[4] = args[4];
1029         return oraclize_query(datasource, dynargs);
1030     }
1031     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1032         bytes[] memory dynargs = new bytes[](5);
1033         dynargs[0] = args[0];
1034         dynargs[1] = args[1];
1035         dynargs[2] = args[2];
1036         dynargs[3] = args[3];
1037         dynargs[4] = args[4];
1038         return oraclize_query(timestamp, datasource, dynargs);
1039     }
1040     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1041         bytes[] memory dynargs = new bytes[](5);
1042         dynargs[0] = args[0];
1043         dynargs[1] = args[1];
1044         dynargs[2] = args[2];
1045         dynargs[3] = args[3];
1046         dynargs[4] = args[4];
1047         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1048     }
1049     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1050         bytes[] memory dynargs = new bytes[](5);
1051         dynargs[0] = args[0];
1052         dynargs[1] = args[1];
1053         dynargs[2] = args[2];
1054         dynargs[3] = args[3];
1055         dynargs[4] = args[4];
1056         return oraclize_query(datasource, dynargs, gaslimit);
1057     }
1058 
1059     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1060         return oraclize.cbAddress();
1061     }
1062     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1063         return oraclize.setProofType(proofP);
1064     }
1065     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1066         return oraclize.setCustomGasPrice(gasPrice);
1067     }
1068 
1069     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1070         return oraclize.randomDS_getSessionPubKeyHash();
1071     }
1072 
1073     function getCodeSize(address _addr) constant internal returns(uint _size) {
1074         assembly {
1075             _size := extcodesize(_addr)
1076         }
1077     }
1078 
1079     function parseAddr(string _a) internal pure returns (address){
1080         bytes memory tmp = bytes(_a);
1081         uint160 iaddr = 0;
1082         uint160 b1;
1083         uint160 b2;
1084         for (uint i=2; i<2+2*20; i+=2){
1085             iaddr *= 256;
1086             b1 = uint160(tmp[i]);
1087             b2 = uint160(tmp[i+1]);
1088             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1089             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1090             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1091             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1092             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1093             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1094             iaddr += (b1*16+b2);
1095         }
1096         return address(iaddr);
1097     }
1098 
1099     function strCompare(string _a, string _b) internal pure returns (int) {
1100         bytes memory a = bytes(_a);
1101         bytes memory b = bytes(_b);
1102         uint minLength = a.length;
1103         if (b.length < minLength) minLength = b.length;
1104         for (uint i = 0; i < minLength; i ++)
1105             if (a[i] < b[i])
1106                 return -1;
1107             else if (a[i] > b[i])
1108                 return 1;
1109         if (a.length < b.length)
1110             return -1;
1111         else if (a.length > b.length)
1112             return 1;
1113         else
1114             return 0;
1115     }
1116 
1117     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1118         bytes memory h = bytes(_haystack);
1119         bytes memory n = bytes(_needle);
1120         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1121             return -1;
1122         else if(h.length > (2**128 -1))
1123             return -1;
1124         else
1125         {
1126             uint subindex = 0;
1127             for (uint i = 0; i < h.length; i ++)
1128             {
1129                 if (h[i] == n[0])
1130                 {
1131                     subindex = 1;
1132                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1133                     {
1134                         subindex++;
1135                     }
1136                     if(subindex == n.length)
1137                         return int(i);
1138                 }
1139             }
1140             return -1;
1141         }
1142     }
1143 
1144     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1145         bytes memory _ba = bytes(_a);
1146         bytes memory _bb = bytes(_b);
1147         bytes memory _bc = bytes(_c);
1148         bytes memory _bd = bytes(_d);
1149         bytes memory _be = bytes(_e);
1150         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1151         bytes memory babcde = bytes(abcde);
1152         uint k = 0;
1153         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1154         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1155         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1156         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1157         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1158         return string(babcde);
1159     }
1160 
1161     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1162         return strConcat(_a, _b, _c, _d, "");
1163     }
1164 
1165     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1166         return strConcat(_a, _b, _c, "", "");
1167     }
1168 
1169     function strConcat(string _a, string _b) internal pure returns (string) {
1170         return strConcat(_a, _b, "", "", "");
1171     }
1172 
1173     // parseInt
1174     function parseInt(string _a) internal pure returns (uint) {
1175         return parseInt(_a, 0);
1176     }
1177 
1178     // parseInt(parseFloat*10^_b)
1179     function parseInt(string _a, uint _b) internal pure returns (uint) {
1180         bytes memory bresult = bytes(_a);
1181         uint mint = 0;
1182         bool decimals = false;
1183         for (uint i=0; i<bresult.length; i++){
1184             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1185                 if (decimals){
1186                    if (_b == 0) break;
1187                     else _b--;
1188                 }
1189                 mint *= 10;
1190                 mint += uint(bresult[i]) - 48;
1191             } else if (bresult[i] == 46) decimals = true;
1192         }
1193         if (_b > 0) mint *= 10**_b;
1194         return mint;
1195     }
1196 
1197     function uint2str(uint i) internal pure returns (string){
1198         if (i == 0) return "0";
1199         uint j = i;
1200         uint len;
1201         while (j != 0){
1202             len++;
1203             j /= 10;
1204         }
1205         bytes memory bstr = new bytes(len);
1206         uint k = len - 1;
1207         while (i != 0){
1208             bstr[k--] = byte(48 + i % 10);
1209             i /= 10;
1210         }
1211         return string(bstr);
1212     }
1213 
1214     using CBOR for Buffer.buffer;
1215     function stra2cbor(string[] arr) internal pure returns (bytes) {
1216         safeMemoryCleaner();
1217         Buffer.buffer memory buf;
1218         Buffer.init(buf, 1024);
1219         buf.startArray();
1220         for (uint i = 0; i < arr.length; i++) {
1221             buf.encodeString(arr[i]);
1222         }
1223         buf.endSequence();
1224         return buf.buf;
1225     }
1226 
1227     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1228         safeMemoryCleaner();
1229         Buffer.buffer memory buf;
1230         Buffer.init(buf, 1024);
1231         buf.startArray();
1232         for (uint i = 0; i < arr.length; i++) {
1233             buf.encodeBytes(arr[i]);
1234         }
1235         buf.endSequence();
1236         return buf.buf;
1237     }
1238 
1239     string oraclize_network_name;
1240     function oraclize_setNetworkName(string _network_name) internal {
1241         oraclize_network_name = _network_name;
1242     }
1243 
1244     function oraclize_getNetworkName() internal view returns (string) {
1245         return oraclize_network_name;
1246     }
1247 
1248     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1249         require((_nbytes > 0) && (_nbytes <= 32));
1250         // Convert from seconds to ledger timer ticks
1251         _delay *= 10;
1252         bytes memory nbytes = new bytes(1);
1253         nbytes[0] = byte(_nbytes);
1254         bytes memory unonce = new bytes(32);
1255         bytes memory sessionKeyHash = new bytes(32);
1256         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1257         assembly {
1258             mstore(unonce, 0x20)
1259             // the following variables can be relaxed
1260             // check relaxed random contract under ethereum-examples repo
1261             // for an idea on how to override and replace comit hash vars
1262             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1263             mstore(sessionKeyHash, 0x20)
1264             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1265         }
1266         bytes memory delay = new bytes(32);
1267         assembly {
1268             mstore(add(delay, 0x20), _delay)
1269         }
1270 
1271         bytes memory delay_bytes8 = new bytes(8);
1272         copyBytes(delay, 24, 8, delay_bytes8, 0);
1273 
1274         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1275         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1276 
1277         bytes memory delay_bytes8_left = new bytes(8);
1278 
1279         assembly {
1280             let x := mload(add(delay_bytes8, 0x20))
1281             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1282             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1283             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1284             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1285             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1286             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1287             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1288             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1289 
1290         }
1291 
1292         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1293         return queryId;
1294     }
1295 
1296     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1297         oraclize_randomDS_args[queryId] = commitment;
1298     }
1299 
1300     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1301     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1302 
1303     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1304         bool sigok;
1305         address signer;
1306 
1307         bytes32 sigr;
1308         bytes32 sigs;
1309 
1310         bytes memory sigr_ = new bytes(32);
1311         uint offset = 4+(uint(dersig[3]) - 0x20);
1312         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1313         bytes memory sigs_ = new bytes(32);
1314         offset += 32 + 2;
1315         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1316 
1317         assembly {
1318             sigr := mload(add(sigr_, 32))
1319             sigs := mload(add(sigs_, 32))
1320         }
1321 
1322 
1323         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1324         if (address(keccak256(pubkey)) == signer) return true;
1325         else {
1326             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1327             return (address(keccak256(pubkey)) == signer);
1328         }
1329     }
1330 
1331     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1332         bool sigok;
1333 
1334         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1335         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1336         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1337 
1338         bytes memory appkey1_pubkey = new bytes(64);
1339         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1340 
1341         bytes memory tosign2 = new bytes(1+65+32);
1342         tosign2[0] = byte(1); //role
1343         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1344         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1345         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1346         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1347 
1348         if (sigok == false) return false;
1349 
1350 
1351         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1352         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1353 
1354         bytes memory tosign3 = new bytes(1+65);
1355         tosign3[0] = 0xFE;
1356         copyBytes(proof, 3, 65, tosign3, 1);
1357 
1358         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1359         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1360 
1361         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1362 
1363         return sigok;
1364     }
1365 
1366     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1367         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1368         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1369 
1370         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1371         require(proofVerified);
1372 
1373         _;
1374     }
1375 
1376     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1377         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1378         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1379 
1380         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1381         if (proofVerified == false) return 2;
1382 
1383         return 0;
1384     }
1385 
1386     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1387         bool match_ = true;
1388 
1389         require(prefix.length == n_random_bytes);
1390 
1391         for (uint256 i=0; i< n_random_bytes; i++) {
1392             if (content[i] != prefix[i]) match_ = false;
1393         }
1394 
1395         return match_;
1396     }
1397 
1398     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1399 
1400         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1401         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1402         bytes memory keyhash = new bytes(32);
1403         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1404         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1405 
1406         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1407         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1408 
1409         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1410         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1411 
1412         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1413         // This is to verify that the computed args match with the ones specified in the query.
1414         bytes memory commitmentSlice1 = new bytes(8+1+32);
1415         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1416 
1417         bytes memory sessionPubkey = new bytes(64);
1418         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1419         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1420 
1421         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1422         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1423             delete oraclize_randomDS_args[queryId];
1424         } else return false;
1425 
1426 
1427         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1428         bytes memory tosign1 = new bytes(32+8+1+32);
1429         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1430         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1431 
1432         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1433         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1434             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1435         }
1436 
1437         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1438     }
1439 
1440     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1441     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1442         uint minLength = length + toOffset;
1443 
1444         // Buffer too small
1445         require(to.length >= minLength); // Should be a better way?
1446 
1447         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1448         uint i = 32 + fromOffset;
1449         uint j = 32 + toOffset;
1450 
1451         while (i < (32 + fromOffset + length)) {
1452             assembly {
1453                 let tmp := mload(add(from, i))
1454                 mstore(add(to, j), tmp)
1455             }
1456             i += 32;
1457             j += 32;
1458         }
1459 
1460         return to;
1461     }
1462 
1463     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1464     // Duplicate Solidity's ecrecover, but catching the CALL return value
1465     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1466         // We do our own memory management here. Solidity uses memory offset
1467         // 0x40 to store the current end of memory. We write past it (as
1468         // writes are memory extensions), but don't update the offset so
1469         // Solidity will reuse it. The memory used here is only needed for
1470         // this context.
1471 
1472         // FIXME: inline assembly can't access return values
1473         bool ret;
1474         address addr;
1475 
1476         assembly {
1477             let size := mload(0x40)
1478             mstore(size, hash)
1479             mstore(add(size, 32), v)
1480             mstore(add(size, 64), r)
1481             mstore(add(size, 96), s)
1482 
1483             // NOTE: we can reuse the request memory because we deal with
1484             //       the return code
1485             ret := call(3000, 1, 0, size, 128, size, 32)
1486             addr := mload(size)
1487         }
1488 
1489         return (ret, addr);
1490     }
1491 
1492     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1493     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1494         bytes32 r;
1495         bytes32 s;
1496         uint8 v;
1497 
1498         if (sig.length != 65)
1499           return (false, 0);
1500 
1501         // The signature format is a compact form of:
1502         //   {bytes32 r}{bytes32 s}{uint8 v}
1503         // Compact means, uint8 is not padded to 32 bytes.
1504         assembly {
1505             r := mload(add(sig, 32))
1506             s := mload(add(sig, 64))
1507 
1508             // Here we are loading the last 32 bytes. We exploit the fact that
1509             // 'mload' will pad with zeroes if we overread.
1510             // There is no 'mload8' to do this, but that would be nicer.
1511             v := byte(0, mload(add(sig, 96)))
1512 
1513             // Alternative solution:
1514             // 'byte' is not working due to the Solidity parser, so lets
1515             // use the second best option, 'and'
1516             // v := and(mload(add(sig, 65)), 255)
1517         }
1518 
1519         // albeit non-transactional signatures are not specified by the YP, one would expect it
1520         // to match the YP range of [27, 28]
1521         //
1522         // geth uses [0, 1] and some clients have followed. This might change, see:
1523         //  https://github.com/ethereum/go-ethereum/issues/2053
1524         if (v < 27)
1525           v += 27;
1526 
1527         if (v != 27 && v != 28)
1528             return (false, 0);
1529 
1530         return safer_ecrecover(hash, v, r, s);
1531     }
1532 
1533     function safeMemoryCleaner() internal pure {
1534         assembly {
1535             let fmem := mload(0x40)
1536             codecopy(fmem, codesize, sub(msize, fmem))
1537         }
1538     }
1539 
1540 }
1541 // </ORACLIZE_API>
1542 
1543 contract oraclizeController is usingOraclize {
1544     address owner;
1545     
1546     event newOraclizeQuery();
1547     event RemoteBettingCloseInfo(address _race);
1548     
1549     struct horsesInfo {
1550         bytes32 BTC;
1551         bytes32 ETH;
1552         bytes32 LTC;
1553         uint256 customPreGasLimit;
1554         uint256 customPostGasLimit;
1555     }
1556     
1557     struct coinInfo {
1558         uint256 pre;
1559         uint256 post;
1560         bytes32 preOraclizeId;
1561         bytes32 postOraclizeId;
1562     }
1563     
1564     mapping (address => mapping (bytes32 => coinInfo)) public coinIndex; 
1565     mapping (address => mapping (bytes32 => bytes32)) oraclizeIndex; // mapping oraclize IDs with coins
1566     mapping (bytes32 => address) oraclizeInverseIndex; // mapping oraclize IDs with coins
1567     
1568     horsesInfo horses;
1569     constructor() public {
1570         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1571         // oraclize_setCustomGasPrice(10000000000 wei);
1572         oraclize_setCustomGasPrice(30000000000 wei);
1573         horses.BTC = bytes32("BTC");
1574         horses.ETH = bytes32("ETH");
1575         horses.LTC = bytes32("LTC");
1576         owner = msg.sender;
1577         horses.customPreGasLimit = 120000;
1578         horses.customPostGasLimit = 230000;
1579     }
1580     
1581     modifier onlyOwner {
1582         require(owner == msg.sender);
1583         _;
1584     }
1585     
1586     // safemath addition
1587     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1588         uint256 c = a + b;
1589         assert(c >= a);
1590         return c;
1591     }
1592     
1593     // utility function to convert string to integer with precision consideration
1594     function stringToUintNormalize(string s) internal pure returns (uint result) {
1595         uint p =2;
1596         bool precision=false;
1597         bytes memory b = bytes(s);
1598         uint i;
1599         result = 0;
1600         for (i = 0; i < b.length; i++) {
1601             if (precision) {p = p-1;}
1602             if (uint(b[i]) == 46){precision = true;}
1603             uint c = uint(b[i]);
1604             if (c >= 48 && c <= 57) {result = result * 10 + (c - 48);}
1605             if (precision && p == 0){return result;}
1606         }
1607         while (p!=0) {
1608             result = result*10;
1609             p=p-1;
1610         }
1611     }
1612     
1613     function changeOraclizeGasPrice(uint _newGasPrice) external onlyOwner {
1614         oraclize_setCustomGasPrice(_newGasPrice);
1615     }
1616     
1617     // method to place the oraclize queries
1618     function setupRace(uint delay, uint locking_duration, address raceAddress) public payable onlyOwner {
1619         if (oraclize_getPrice("URL" , horses.customPreGasLimit)*3 + oraclize_getPrice("URL", horses.customPostGasLimit)*3  > address(this).balance) {
1620         } else {
1621             bytes32 temp_ID; // temp variable to store oraclize IDs
1622             emit newOraclizeQuery();
1623             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027/).data.quotes.USD.price",horses.customPreGasLimit);
1624             oraclizeIndex[raceAddress][temp_ID] = horses.ETH;
1625             oraclizeInverseIndex[temp_ID] = raceAddress;
1626             coinIndex[raceAddress][horses.ETH].preOraclizeId = temp_ID;
1627 
1628             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/2/).data.quotes.USD.price",horses.customPreGasLimit);
1629             oraclizeIndex[raceAddress][temp_ID] = horses.LTC;
1630             oraclizeInverseIndex[temp_ID] = raceAddress;
1631             coinIndex[raceAddress][horses.LTC].preOraclizeId = temp_ID;
1632 
1633             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1/).data.quotes.USD.price",horses.customPreGasLimit);
1634             oraclizeIndex[raceAddress][temp_ID] = horses.BTC;
1635             oraclizeInverseIndex[temp_ID] = raceAddress;
1636             coinIndex[raceAddress][horses.BTC].preOraclizeId = temp_ID;
1637 
1638             //bets closing price query
1639             delay = add(delay,locking_duration);
1640 
1641             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027/).data.quotes.USD.price",horses.customPostGasLimit);
1642             oraclizeIndex[raceAddress][temp_ID] = horses.ETH;
1643             oraclizeInverseIndex[temp_ID] = raceAddress;
1644             coinIndex[raceAddress][horses.ETH].postOraclizeId = temp_ID;
1645 
1646             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/2/).data.quotes.USD.price",horses.customPostGasLimit);
1647             oraclizeIndex[raceAddress][temp_ID] = horses.LTC;
1648             oraclizeInverseIndex[temp_ID] = raceAddress;
1649             coinIndex[raceAddress][horses.LTC].postOraclizeId = temp_ID;
1650 
1651             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1/).data.quotes.USD.price",horses.customPostGasLimit);
1652             oraclizeIndex[raceAddress][temp_ID] = horses.BTC;
1653             oraclizeInverseIndex[temp_ID] = raceAddress;
1654             coinIndex[raceAddress][horses.BTC].postOraclizeId = temp_ID;
1655         }
1656     }
1657     
1658     //oraclize callback method
1659     function __callback(bytes32 myid, string result, bytes proof) public {
1660         require (msg.sender == oraclize_cbAddress());
1661         require (stringToUintNormalize(result) > 0);
1662         bytes32 coin_pointer; // variable to differentiate different callbacks
1663         address raceAddress = oraclizeInverseIndex[myid];
1664         Race race = Race(raceAddress);
1665         coin_pointer = oraclizeIndex[raceAddress][myid];
1666         emit RemoteBettingCloseInfo(raceAddress);
1667         
1668         if (myid == coinIndex[raceAddress][coin_pointer].preOraclizeId) {
1669             if (coinIndex[raceAddress][coin_pointer].pre > 0) {
1670             } else {
1671                 coinIndex[raceAddress][coin_pointer].pre = stringToUintNormalize(result);
1672                 race.priceCallback(coin_pointer,coinIndex[raceAddress][coin_pointer].pre,true);
1673             }
1674         } else if (myid == coinIndex[raceAddress][coin_pointer].postOraclizeId){
1675             if (coinIndex[raceAddress][coin_pointer].post > 0) {
1676             } else {
1677                 coinIndex[raceAddress][coin_pointer].post = stringToUintNormalize(result);
1678                 race.priceCallback(coin_pointer,coinIndex[raceAddress][coin_pointer].post,false);
1679             }
1680         }
1681     }
1682     
1683     function ethorseOracle(address raceAddress, bytes32 coin_pointer, string result, bool isPrePrice) external onlyOwner {
1684         emit RemoteBettingCloseInfo(raceAddress);
1685         Race race = Race(raceAddress);
1686         if (isPrePrice) {
1687             coinIndex[raceAddress][coin_pointer].pre = stringToUintNormalize(result);
1688         } else {
1689             coinIndex[raceAddress][coin_pointer].post = stringToUintNormalize(result);
1690         }
1691         race.priceCallback(coin_pointer, stringToUintNormalize(result), isPrePrice);
1692     }
1693 }
1694 
1695 contract BettingController is oraclizeController {
1696     address owner;
1697     Race race;
1698 
1699     mapping (address => bool) public isOraclizeEnabled;
1700     event RaceDeployed(address _address, address _owner, uint256 _bettingDuration, uint256 _raceDuration, uint256 _time);
1701     event AddFund(uint256 _value);
1702 
1703     modifier onlyOwner {
1704         require(msg.sender == owner);
1705         _;
1706     }
1707 
1708     constructor() public payable {
1709         owner = msg.sender;
1710     }
1711 
1712     function addFunds() external onlyOwner payable {
1713         emit AddFund(msg.value);
1714     }
1715 
1716     function spawnRaceManual(uint256 _bettingDuration, uint256 _raceDuration, bool _isOraclizeUsed) external onlyOwner {
1717         race = (new Race)();
1718         emit RaceDeployed(address(race), race.owner(), _bettingDuration, _raceDuration, now);
1719         if (_isOraclizeUsed) {
1720             isOraclizeEnabled[address(race)] = true;
1721             setupRace(_bettingDuration, _raceDuration, address(race));
1722         }
1723         uint32 bettingDuration = uint32(_bettingDuration);
1724         uint32 raceDuration = uint32(_raceDuration);
1725         raceDuration = uint32(add(bettingDuration,raceDuration));
1726         bettingDuration = uint32(bettingDuration);
1727         race.setupRace(bettingDuration,raceDuration);
1728     }
1729 
1730     function enableRefund(address _race) external onlyOwner {
1731         Race raceInstance = Race(_race);
1732         emit RemoteBettingCloseInfo(_race);
1733         raceInstance.refund();
1734     }
1735 
1736     function manualRecovery(address _race) external onlyOwner {
1737         Race raceInstance = Race(_race);
1738         raceInstance.recovery();
1739     }
1740 
1741     function changeRaceOwnership(address _race, address _newOwner) external onlyOwner {
1742         Race raceInstance = Race(_race);
1743         raceInstance.changeOwnership(_newOwner);
1744     }
1745 
1746     function extractFund(uint256 _amount) external onlyOwner {
1747         if (_amount == 0) {
1748             owner.transfer(address(this).balance);
1749         } else {
1750             require(_amount <= address(this).balance);
1751             owner.transfer(_amount);
1752         }
1753     }
1754 }