1 pragma solidity ^0.5.2;
2 
3 pragma solidity ^0.5.2;
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
30 contract Race{
31     using SafeMath for uint256; //using safemath
32 
33     address public owner; //owner address
34     address payable house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;
35     address payable mle_takeout = 0xAcBC1971AF62f42EE1eD89bc79308828e6b044f1;
36 
37     uint public winnerPoolTotal;
38     string public constant version = "0.2.5";
39 
40     struct chronus_info {
41         bool  betting_open; // boolean: check if betting is open
42         bool  race_start; //boolean: check if race has started
43         bool  race_end; //boolean: check if race has ended
44         bool  voided_bet; //boolean: check if race has been voided
45         uint32  starting_time; // timestamp of when the race starts
46         uint32  betting_duration;
47         uint32  race_duration; // duration of the race
48         uint32 voided_timestamp;
49     }
50 
51     struct horses_info{
52         int64  BTC_delta; //horses.BTC delta value
53         int64  ETH_delta; //horses.ETH delta value
54         int64  LTC_delta; //horses.LTC delta value
55         bytes32 BTC; //32-bytes equivalent of horses.BTC
56         bytes32 ETH; //32-bytes equivalent of horses.ETH
57         bytes32 LTC;  //32-bytes equivalent of horses.LTC
58     }
59 
60     struct bet_info{
61         bytes32 horse; // coin on which amount is bet on
62         uint amount; // amount bet by Bettor
63     }
64     struct coin_info{
65         uint256 pre; // locking price
66         uint256 post; // ending price
67         uint160 total; // total coin pool
68         uint32 count; // number of bets
69         bool price_check;
70     }
71     struct voter_info {
72         uint160 total_bet; //total amount of bet placed
73         bool rewarded; // boolean: check for double spending
74         mapping(bytes32=>uint) bets; //array of bets
75     }
76 
77     mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information
78     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
79 
80     uint public total_reward; // total reward to be awarded
81     uint32 total_bettors;
82     mapping (bytes32 => bool) public winner_horse;
83 
84 
85     // tracking events
86     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
87     event Withdraw(address _to, uint256 _value);
88     event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);
89     event RefundEnabled(string reason);
90 
91     // constructor
92     constructor() public payable {
93         
94         owner = msg.sender;
95         
96         horses.BTC = bytes32("BTC");
97         horses.ETH = bytes32("ETH");
98         horses.LTC = bytes32("LTC");
99         
100     }
101 
102     // data access structures
103     horses_info public horses;
104     chronus_info public chronus;
105 
106     // modifiers for restricting access to methods
107     modifier onlyOwner {
108         require(owner == msg.sender);
109         _;
110     }
111 
112     modifier duringBetting {
113         require(chronus.betting_open);
114         require(now < chronus.starting_time + chronus.betting_duration);
115         _;
116     }
117 
118     modifier beforeBetting {
119         require(!chronus.betting_open && !chronus.race_start);
120         _;
121     }
122 
123     modifier afterRace {
124         require(chronus.race_end);
125         _;
126     }
127 
128     //function to change owner
129     function changeOwnership(address _newOwner) onlyOwner external {
130         require(now > chronus.starting_time + chronus.race_duration + 60 minutes);
131         owner = _newOwner;
132     }
133 
134     function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {
135         require (!chronus.race_end);
136         emit PriceCallback(coin_pointer, result, isPrePrice);
137         chronus.race_start = true;
138         chronus.betting_open = false;
139         if (isPrePrice) {
140             if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
141                 emit RefundEnabled("Late start price");
142                 forceVoidRace();
143             } else {
144                 coinIndex[coin_pointer].pre = result;
145             }
146         } else if (!isPrePrice){
147             if (coinIndex[coin_pointer].pre > 0 ){
148                 if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
149                     emit RefundEnabled("Late end price");
150                     forceVoidRace();
151                 } else {
152                     coinIndex[coin_pointer].post = result;
153                     coinIndex[coin_pointer].price_check = true;
154 
155                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
156                         reward();
157                     }
158                 }
159             } else {
160                 emit RefundEnabled("End price came before start price");
161                 forceVoidRace();
162             }
163         }
164     }
165 
166     // place a bet on a coin(horse) lockBetting
167     function placeBet(bytes32 horse) external duringBetting payable  {
168         require(msg.value >= 0.01 ether);
169         if (voterIndex[msg.sender].total_bet==0) {
170             total_bettors+=1;
171         }
172         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
173         voterIndex[msg.sender].bets[horse] = _newAmount;
174         voterIndex[msg.sender].total_bet += uint160(msg.value);
175         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);
176         uint32 _newCount = coinIndex[horse].count + 1;
177         coinIndex[horse].total = _newTotal;
178         coinIndex[horse].count = _newCount;
179         emit Deposit(msg.sender, msg.value, horse, now);
180     }
181 
182     // method to place the oraclize queries
183     function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {
184             chronus.starting_time = uint32(block.timestamp);
185             chronus.betting_open = true;
186             chronus.betting_duration = _bettingDuration;
187             chronus.race_duration = _raceDuration;
188     }
189 
190     // method to calculate reward (called internally by callback)
191     function reward() internal {
192         /*
193         calculating the difference in price with a precision of 5 digits
194         not using safemath since signed integers are handled
195         */
196         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
197         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
198         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
199 
200         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
201         if (total_bettors <= 1) {
202             emit RefundEnabled("Not enough participants");
203             forceVoidRace();
204         } else {
205             // house takeout
206             uint house_fee = total_reward.mul(5).div(100);
207             require(house_fee < address(this).balance);
208             total_reward = total_reward.sub(house_fee);
209             house_takeout.transfer(house_fee);
210             
211             // p3d takeout
212             uint mle_fee = house_fee/2;
213             require(mle_fee < address(this).balance);
214             total_reward = total_reward.sub(mle_fee);
215             mle_takeout.transfer(mle_fee);
216         }
217 
218         if (horses.BTC_delta > horses.ETH_delta) {
219             if (horses.BTC_delta > horses.LTC_delta) {
220                 winner_horse[horses.BTC] = true;
221                 winnerPoolTotal = coinIndex[horses.BTC].total;
222             }
223             else if(horses.LTC_delta > horses.BTC_delta) {
224                 winner_horse[horses.LTC] = true;
225                 winnerPoolTotal = coinIndex[horses.LTC].total;
226             } else {
227                 winner_horse[horses.BTC] = true;
228                 winner_horse[horses.LTC] = true;
229                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
230             }
231         } else if(horses.ETH_delta > horses.BTC_delta) {
232             if (horses.ETH_delta > horses.LTC_delta) {
233                 winner_horse[horses.ETH] = true;
234                 winnerPoolTotal = coinIndex[horses.ETH].total;
235             }
236             else if (horses.LTC_delta > horses.ETH_delta) {
237                 winner_horse[horses.LTC] = true;
238                 winnerPoolTotal = coinIndex[horses.LTC].total;
239             } else {
240                 winner_horse[horses.ETH] = true;
241                 winner_horse[horses.LTC] = true;
242                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
243             }
244         } else {
245             if (horses.LTC_delta > horses.ETH_delta) {
246                 winner_horse[horses.LTC] = true;
247                 winnerPoolTotal = coinIndex[horses.LTC].total;
248             } else if(horses.LTC_delta < horses.ETH_delta){
249                 winner_horse[horses.ETH] = true;
250                 winner_horse[horses.BTC] = true;
251                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
252             } else {
253                 winner_horse[horses.LTC] = true;
254                 winner_horse[horses.ETH] = true;
255                 winner_horse[horses.BTC] = true;
256                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
257             }
258         }
259         chronus.race_end = true;
260     }
261 
262     // method to calculate an invidual's reward
263     function calculateReward(address candidate) internal afterRace view returns(uint winner_reward) {
264         voter_info storage bettor = voterIndex[candidate];
265         if(chronus.voided_bet) {
266             winner_reward = bettor.total_bet;
267         } else {
268             uint winning_bet_total;
269             if(winner_horse[horses.BTC]) {
270                 winning_bet_total += bettor.bets[horses.BTC];
271             } if(winner_horse[horses.ETH]) {
272                 winning_bet_total += bettor.bets[horses.ETH];
273             } if(winner_horse[horses.LTC]) {
274                 winning_bet_total += bettor.bets[horses.LTC];
275             }
276             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
277         }
278     }
279 
280     // method to just check the reward amount
281     function checkReward() afterRace external view returns (uint) {
282         require(!voterIndex[msg.sender].rewarded);
283         return calculateReward(msg.sender);
284     }
285 
286     // method to claim the reward amount
287     function claim_reward() afterRace external {
288         require(!voterIndex[msg.sender].rewarded);
289         uint transfer_amount = calculateReward(msg.sender);
290         require(address(this).balance >= transfer_amount);
291         voterIndex[msg.sender].rewarded = true;
292         msg.sender.transfer(transfer_amount);
293         emit Withdraw(msg.sender, transfer_amount);
294     }
295 
296     function forceVoidRace() internal {
297         require(!chronus.voided_bet);
298         chronus.voided_bet=true;
299         chronus.race_end = true;
300         chronus.voided_timestamp=uint32(now);
301     }
302     
303     //this methohd can only be called by controller contract in case of timestamp errors
304     function forceVoidExternal() external onlyOwner {
305         forceVoidRace();
306         emit RefundEnabled("Inaccurate price timestamp");
307     }
308 
309     // exposing the coin pool details for DApp
310     function getCoinIndex(bytes32 index, address candidate) external view returns (uint, uint, uint, bool, uint) {
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
323     function reward_total() external view returns (uint) {
324         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
325     }
326     
327     function getChronus() external view returns (uint32[] memory) {
328         uint32[] memory chronusData = new uint32[](3);
329         chronusData[0] = chronus.starting_time;
330         chronusData[1] = chronus.betting_duration;
331         chronusData[2] = chronus.race_duration;
332         return (chronusData);
333         // return (chronus.starting_time, chronus.betting_duration ,chronus.race_duration);
334     }
335 
336     // in case of any errors in race, enable full refund for the Bettors to claim
337     function refund() external onlyOwner {
338         require(now > chronus.starting_time + chronus.race_duration + 60 minutes);
339         require((chronus.betting_open && !chronus.race_start)
340             || (chronus.race_start && !chronus.race_end));
341         chronus.voided_bet = true;
342         chronus.race_end = true;
343         chronus.voided_timestamp=uint32(now);
344     }
345 
346     // method to claim unclaimed winnings after 30 day notice period
347     function recovery() external onlyOwner{
348         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
349             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
350         house_takeout.transfer(address(this).balance);
351     }
352 }
353 
354 
355 /*
356 
357 ORACLIZE_API
358 
359 Copyright (c) 2015-2016 Oraclize SRL
360 Copyright (c) 2016 Oraclize LTD
361 
362 Permission is hereby granted, free of charge, to any person obtaining a copy
363 of this software and associated documentation files (the "Software"), to deal
364 in the Software without restriction, including without limitation the rights
365 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
366 copies of the Software, and to permit persons to whom the Software is
367 furnished to do so, subject to the following conditions:
368 
369 The above copyright notice and this permission notice shall be included in
370 all copies or substantial portions of the Software.
371 
372 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
373 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
374 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
375 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
376 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
377 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
378 THE SOFTWARE.
379 
380 */
381 pragma solidity >= 0.5.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
382 
383 // Dummy contract only used to emit to end-user they are using wrong solc
384 contract solcChecker {
385 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
386 }
387 
388 contract OraclizeI {
389 
390     address public cbAddress;
391 
392     function setProofType(byte _proofType) external;
393     function setCustomGasPrice(uint _gasPrice) external;
394     function getPrice(string memory _datasource) public returns (uint _dsprice);
395     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
396     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
397     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
398     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
399     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
400     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
401     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
402     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
403 }
404 
405 contract OraclizeAddrResolverI {
406     function getAddress() public returns (address _address);
407 }
408 /*
409 
410 Begin solidity-cborutils
411 
412 https://github.com/smartcontractkit/solidity-cborutils
413 
414 MIT License
415 
416 Copyright (c) 2018 SmartContract ChainLink, Ltd.
417 
418 Permission is hereby granted, free of charge, to any person obtaining a copy
419 of this software and associated documentation files (the "Software"), to deal
420 in the Software without restriction, including without limitation the rights
421 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
422 copies of the Software, and to permit persons to whom the Software is
423 furnished to do so, subject to the following conditions:
424 
425 The above copyright notice and this permission notice shall be included in all
426 copies or substantial portions of the Software.
427 
428 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
429 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
430 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
431 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
432 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
433 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
434 SOFTWARE.
435 
436 */
437 library Buffer {
438 
439     struct buffer {
440         bytes buf;
441         uint capacity;
442     }
443 
444     function init(buffer memory _buf, uint _capacity) internal pure {
445         uint capacity = _capacity;
446         if (capacity % 32 != 0) {
447             capacity += 32 - (capacity % 32);
448         }
449         _buf.capacity = capacity; // Allocate space for the buffer data
450         assembly {
451             let ptr := mload(0x40)
452             mstore(_buf, ptr)
453             mstore(ptr, 0)
454             mstore(0x40, add(ptr, capacity))
455         }
456     }
457 
458     function resize(buffer memory _buf, uint _capacity) private pure {
459         bytes memory oldbuf = _buf.buf;
460         init(_buf, _capacity);
461         append(_buf, oldbuf);
462     }
463 
464     function max(uint _a, uint _b) private pure returns (uint _max) {
465         if (_a > _b) {
466             return _a;
467         }
468         return _b;
469     }
470     /**
471       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
472       *      would exceed the capacity of the buffer.
473       * @param _buf The buffer to append to.
474       * @param _data The data to append.
475       * @return The original buffer.
476       *
477       */
478     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
479         if (_data.length + _buf.buf.length > _buf.capacity) {
480             resize(_buf, max(_buf.capacity, _data.length) * 2);
481         }
482         uint dest;
483         uint src;
484         uint len = _data.length;
485         assembly {
486             let bufptr := mload(_buf) // Memory address of the buffer data
487             let buflen := mload(bufptr) // Length of existing buffer data
488             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
489             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
490             src := add(_data, 32)
491         }
492         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
493             assembly {
494                 mstore(dest, mload(src))
495             }
496             dest += 32;
497             src += 32;
498         }
499         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
500         assembly {
501             let srcpart := and(mload(src), not(mask))
502             let destpart := and(mload(dest), mask)
503             mstore(dest, or(destpart, srcpart))
504         }
505         return _buf;
506     }
507     /**
508       *
509       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
510       * exceed the capacity of the buffer.
511       * @param _buf The buffer to append to.
512       * @param _data The data to append.
513       * @return The original buffer.
514       *
515       */
516     function append(buffer memory _buf, uint8 _data) internal pure {
517         if (_buf.buf.length + 1 > _buf.capacity) {
518             resize(_buf, _buf.capacity * 2);
519         }
520         assembly {
521             let bufptr := mload(_buf) // Memory address of the buffer data
522             let buflen := mload(bufptr) // Length of existing buffer data
523             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
524             mstore8(dest, _data)
525             mstore(bufptr, add(buflen, 1)) // Update buffer length
526         }
527     }
528     /**
529       *
530       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
531       * exceed the capacity of the buffer.
532       * @param _buf The buffer to append to.
533       * @param _data The data to append.
534       * @return The original buffer.
535       *
536       */
537     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
538         if (_len + _buf.buf.length > _buf.capacity) {
539             resize(_buf, max(_buf.capacity, _len) * 2);
540         }
541         uint mask = 256 ** _len - 1;
542         assembly {
543             let bufptr := mload(_buf) // Memory address of the buffer data
544             let buflen := mload(bufptr) // Length of existing buffer data
545             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
546             mstore(dest, or(and(mload(dest), not(mask)), _data))
547             mstore(bufptr, add(buflen, _len)) // Update buffer length
548         }
549         return _buf;
550     }
551 }
552 
553 library CBOR {
554 
555     using Buffer for Buffer.buffer;
556 
557     uint8 private constant MAJOR_TYPE_INT = 0;
558     uint8 private constant MAJOR_TYPE_MAP = 5;
559     uint8 private constant MAJOR_TYPE_BYTES = 2;
560     uint8 private constant MAJOR_TYPE_ARRAY = 4;
561     uint8 private constant MAJOR_TYPE_STRING = 3;
562     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
563     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
564 
565     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
566         if (_value <= 23) {
567             _buf.append(uint8((_major << 5) | _value));
568         } else if (_value <= 0xFF) {
569             _buf.append(uint8((_major << 5) | 24));
570             _buf.appendInt(_value, 1);
571         } else if (_value <= 0xFFFF) {
572             _buf.append(uint8((_major << 5) | 25));
573             _buf.appendInt(_value, 2);
574         } else if (_value <= 0xFFFFFFFF) {
575             _buf.append(uint8((_major << 5) | 26));
576             _buf.appendInt(_value, 4);
577         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
578             _buf.append(uint8((_major << 5) | 27));
579             _buf.appendInt(_value, 8);
580         }
581     }
582 
583     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
584         _buf.append(uint8((_major << 5) | 31));
585     }
586 
587     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
588         encodeType(_buf, MAJOR_TYPE_INT, _value);
589     }
590 
591     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
592         if (_value >= 0) {
593             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
594         } else {
595             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
596         }
597     }
598 
599     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
600         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
601         _buf.append(_value);
602     }
603 
604     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
605         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
606         _buf.append(bytes(_value));
607     }
608 
609     function startArray(Buffer.buffer memory _buf) internal pure {
610         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
611     }
612 
613     function startMap(Buffer.buffer memory _buf) internal pure {
614         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
615     }
616 
617     function endSequence(Buffer.buffer memory _buf) internal pure {
618         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
619     }
620 }
621 /*
622 
623 End solidity-cborutils
624 
625 */
626 contract usingOraclize {
627 
628     using CBOR for Buffer.buffer;
629 
630     OraclizeI oraclize;
631     OraclizeAddrResolverI OAR;
632 
633     uint constant day = 60 * 60 * 24;
634     uint constant week = 60 * 60 * 24 * 7;
635     uint constant month = 60 * 60 * 24 * 30;
636 
637     byte constant proofType_NONE = 0x00;
638     byte constant proofType_Ledger = 0x30;
639     byte constant proofType_Native = 0xF0;
640     byte constant proofStorage_IPFS = 0x01;
641     byte constant proofType_Android = 0x40;
642     byte constant proofType_TLSNotary = 0x10;
643 
644     string oraclize_network_name;
645     uint8 constant networkID_auto = 0;
646     uint8 constant networkID_morden = 2;
647     uint8 constant networkID_mainnet = 1;
648     uint8 constant networkID_testnet = 2;
649     uint8 constant networkID_consensys = 161;
650 
651     mapping(bytes32 => bytes32) oraclize_randomDS_args;
652     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
653 
654     modifier oraclizeAPI {
655         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
656             oraclize_setNetwork(networkID_auto);
657         }
658         if (address(oraclize) != OAR.getAddress()) {
659             oraclize = OraclizeI(OAR.getAddress());
660         }
661         _;
662     }
663 
664     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
665         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
666         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
667         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
668         require(proofVerified);
669         _;
670     }
671 
672     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
673       return oraclize_setNetwork();
674       _networkID; // silence the warning and remain backwards compatible
675     }
676 
677     function oraclize_setNetworkName(string memory _network_name) internal {
678         oraclize_network_name = _network_name;
679     }
680 
681     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
682         return oraclize_network_name;
683     }
684 
685     function oraclize_setNetwork() internal returns (bool _networkSet) {
686         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
687             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
688             oraclize_setNetworkName("eth_mainnet");
689             return true;
690         }
691         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
692             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
693             oraclize_setNetworkName("eth_ropsten3");
694             return true;
695         }
696         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
697             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
698             oraclize_setNetworkName("eth_kovan");
699             return true;
700         }
701         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
702             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
703             oraclize_setNetworkName("eth_rinkeby");
704             return true;
705         }
706         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
707             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
708             return true;
709         }
710         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
711             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
712             return true;
713         }
714         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
715             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
716             return true;
717         }
718         return false;
719     }
720 
721     function __callback(bytes32 _myid, string memory _result) public {
722         __callback(_myid, _result, new bytes(0));
723     }
724 
725     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
726       return;
727       _myid; _result; _proof; // Silence compiler warnings
728     }
729 
730     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
731         return oraclize.getPrice(_datasource);
732     }
733 
734     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
735         return oraclize.getPrice(_datasource, _gasLimit);
736     }
737 
738     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
739         uint price = oraclize.getPrice(_datasource);
740         if (price > 1 ether + tx.gasprice * 200000) {
741             return 0; // Unexpectedly high price
742         }
743         return oraclize.query.value(price)(0, _datasource, _arg);
744     }
745 
746     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
747         uint price = oraclize.getPrice(_datasource);
748         if (price > 1 ether + tx.gasprice * 200000) {
749             return 0; // Unexpectedly high price
750         }
751         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
752     }
753 
754     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
755         uint price = oraclize.getPrice(_datasource,_gasLimit);
756         if (price > 1 ether + tx.gasprice * _gasLimit) {
757             return 0; // Unexpectedly high price
758         }
759         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
760     }
761 
762     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
763         uint price = oraclize.getPrice(_datasource, _gasLimit);
764         if (price > 1 ether + tx.gasprice * _gasLimit) {
765            return 0; // Unexpectedly high price
766         }
767         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
768     }
769 
770     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
771         uint price = oraclize.getPrice(_datasource);
772         if (price > 1 ether + tx.gasprice * 200000) {
773             return 0; // Unexpectedly high price
774         }
775         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
776     }
777 
778     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
779         uint price = oraclize.getPrice(_datasource);
780         if (price > 1 ether + tx.gasprice * 200000) {
781             return 0; // Unexpectedly high price
782         }
783         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
784     }
785 
786     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
787         uint price = oraclize.getPrice(_datasource, _gasLimit);
788         if (price > 1 ether + tx.gasprice * _gasLimit) {
789             return 0; // Unexpectedly high price
790         }
791         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
792     }
793 
794     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
795         uint price = oraclize.getPrice(_datasource, _gasLimit);
796         if (price > 1 ether + tx.gasprice * _gasLimit) {
797             return 0; // Unexpectedly high price
798         }
799         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
800     }
801 
802     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
803         uint price = oraclize.getPrice(_datasource);
804         if (price > 1 ether + tx.gasprice * 200000) {
805             return 0; // Unexpectedly high price
806         }
807         bytes memory args = stra2cbor(_argN);
808         return oraclize.queryN.value(price)(0, _datasource, args);
809     }
810 
811     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
812         uint price = oraclize.getPrice(_datasource);
813         if (price > 1 ether + tx.gasprice * 200000) {
814             return 0; // Unexpectedly high price
815         }
816         bytes memory args = stra2cbor(_argN);
817         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
818     }
819 
820     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
821         uint price = oraclize.getPrice(_datasource, _gasLimit);
822         if (price > 1 ether + tx.gasprice * _gasLimit) {
823             return 0; // Unexpectedly high price
824         }
825         bytes memory args = stra2cbor(_argN);
826         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
827     }
828 
829     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
830         uint price = oraclize.getPrice(_datasource, _gasLimit);
831         if (price > 1 ether + tx.gasprice * _gasLimit) {
832             return 0; // Unexpectedly high price
833         }
834         bytes memory args = stra2cbor(_argN);
835         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
836     }
837 
838     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
839         string[] memory dynargs = new string[](1);
840         dynargs[0] = _args[0];
841         return oraclize_query(_datasource, dynargs);
842     }
843 
844     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
845         string[] memory dynargs = new string[](1);
846         dynargs[0] = _args[0];
847         return oraclize_query(_timestamp, _datasource, dynargs);
848     }
849 
850     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
851         string[] memory dynargs = new string[](1);
852         dynargs[0] = _args[0];
853         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
854     }
855 
856     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
857         string[] memory dynargs = new string[](1);
858         dynargs[0] = _args[0];
859         return oraclize_query(_datasource, dynargs, _gasLimit);
860     }
861 
862     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
863         string[] memory dynargs = new string[](2);
864         dynargs[0] = _args[0];
865         dynargs[1] = _args[1];
866         return oraclize_query(_datasource, dynargs);
867     }
868 
869     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
870         string[] memory dynargs = new string[](2);
871         dynargs[0] = _args[0];
872         dynargs[1] = _args[1];
873         return oraclize_query(_timestamp, _datasource, dynargs);
874     }
875 
876     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
877         string[] memory dynargs = new string[](2);
878         dynargs[0] = _args[0];
879         dynargs[1] = _args[1];
880         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
881     }
882 
883     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
884         string[] memory dynargs = new string[](2);
885         dynargs[0] = _args[0];
886         dynargs[1] = _args[1];
887         return oraclize_query(_datasource, dynargs, _gasLimit);
888     }
889 
890     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
891         string[] memory dynargs = new string[](3);
892         dynargs[0] = _args[0];
893         dynargs[1] = _args[1];
894         dynargs[2] = _args[2];
895         return oraclize_query(_datasource, dynargs);
896     }
897 
898     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
899         string[] memory dynargs = new string[](3);
900         dynargs[0] = _args[0];
901         dynargs[1] = _args[1];
902         dynargs[2] = _args[2];
903         return oraclize_query(_timestamp, _datasource, dynargs);
904     }
905 
906     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
907         string[] memory dynargs = new string[](3);
908         dynargs[0] = _args[0];
909         dynargs[1] = _args[1];
910         dynargs[2] = _args[2];
911         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
912     }
913 
914     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
915         string[] memory dynargs = new string[](3);
916         dynargs[0] = _args[0];
917         dynargs[1] = _args[1];
918         dynargs[2] = _args[2];
919         return oraclize_query(_datasource, dynargs, _gasLimit);
920     }
921 
922     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
923         string[] memory dynargs = new string[](4);
924         dynargs[0] = _args[0];
925         dynargs[1] = _args[1];
926         dynargs[2] = _args[2];
927         dynargs[3] = _args[3];
928         return oraclize_query(_datasource, dynargs);
929     }
930 
931     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
932         string[] memory dynargs = new string[](4);
933         dynargs[0] = _args[0];
934         dynargs[1] = _args[1];
935         dynargs[2] = _args[2];
936         dynargs[3] = _args[3];
937         return oraclize_query(_timestamp, _datasource, dynargs);
938     }
939 
940     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
941         string[] memory dynargs = new string[](4);
942         dynargs[0] = _args[0];
943         dynargs[1] = _args[1];
944         dynargs[2] = _args[2];
945         dynargs[3] = _args[3];
946         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
947     }
948 
949     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
950         string[] memory dynargs = new string[](4);
951         dynargs[0] = _args[0];
952         dynargs[1] = _args[1];
953         dynargs[2] = _args[2];
954         dynargs[3] = _args[3];
955         return oraclize_query(_datasource, dynargs, _gasLimit);
956     }
957 
958     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
959         string[] memory dynargs = new string[](5);
960         dynargs[0] = _args[0];
961         dynargs[1] = _args[1];
962         dynargs[2] = _args[2];
963         dynargs[3] = _args[3];
964         dynargs[4] = _args[4];
965         return oraclize_query(_datasource, dynargs);
966     }
967 
968     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
969         string[] memory dynargs = new string[](5);
970         dynargs[0] = _args[0];
971         dynargs[1] = _args[1];
972         dynargs[2] = _args[2];
973         dynargs[3] = _args[3];
974         dynargs[4] = _args[4];
975         return oraclize_query(_timestamp, _datasource, dynargs);
976     }
977 
978     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
979         string[] memory dynargs = new string[](5);
980         dynargs[0] = _args[0];
981         dynargs[1] = _args[1];
982         dynargs[2] = _args[2];
983         dynargs[3] = _args[3];
984         dynargs[4] = _args[4];
985         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
986     }
987 
988     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
989         string[] memory dynargs = new string[](5);
990         dynargs[0] = _args[0];
991         dynargs[1] = _args[1];
992         dynargs[2] = _args[2];
993         dynargs[3] = _args[3];
994         dynargs[4] = _args[4];
995         return oraclize_query(_datasource, dynargs, _gasLimit);
996     }
997 
998     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
999         uint price = oraclize.getPrice(_datasource);
1000         if (price > 1 ether + tx.gasprice * 200000) {
1001             return 0; // Unexpectedly high price
1002         }
1003         bytes memory args = ba2cbor(_argN);
1004         return oraclize.queryN.value(price)(0, _datasource, args);
1005     }
1006 
1007     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1008         uint price = oraclize.getPrice(_datasource);
1009         if (price > 1 ether + tx.gasprice * 200000) {
1010             return 0; // Unexpectedly high price
1011         }
1012         bytes memory args = ba2cbor(_argN);
1013         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1014     }
1015 
1016     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1017         uint price = oraclize.getPrice(_datasource, _gasLimit);
1018         if (price > 1 ether + tx.gasprice * _gasLimit) {
1019             return 0; // Unexpectedly high price
1020         }
1021         bytes memory args = ba2cbor(_argN);
1022         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1023     }
1024 
1025     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1026         uint price = oraclize.getPrice(_datasource, _gasLimit);
1027         if (price > 1 ether + tx.gasprice * _gasLimit) {
1028             return 0; // Unexpectedly high price
1029         }
1030         bytes memory args = ba2cbor(_argN);
1031         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1032     }
1033 
1034     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1035         bytes[] memory dynargs = new bytes[](1);
1036         dynargs[0] = _args[0];
1037         return oraclize_query(_datasource, dynargs);
1038     }
1039 
1040     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1041         bytes[] memory dynargs = new bytes[](1);
1042         dynargs[0] = _args[0];
1043         return oraclize_query(_timestamp, _datasource, dynargs);
1044     }
1045 
1046     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1047         bytes[] memory dynargs = new bytes[](1);
1048         dynargs[0] = _args[0];
1049         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1050     }
1051 
1052     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1053         bytes[] memory dynargs = new bytes[](1);
1054         dynargs[0] = _args[0];
1055         return oraclize_query(_datasource, dynargs, _gasLimit);
1056     }
1057 
1058     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1059         bytes[] memory dynargs = new bytes[](2);
1060         dynargs[0] = _args[0];
1061         dynargs[1] = _args[1];
1062         return oraclize_query(_datasource, dynargs);
1063     }
1064 
1065     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1066         bytes[] memory dynargs = new bytes[](2);
1067         dynargs[0] = _args[0];
1068         dynargs[1] = _args[1];
1069         return oraclize_query(_timestamp, _datasource, dynargs);
1070     }
1071 
1072     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1073         bytes[] memory dynargs = new bytes[](2);
1074         dynargs[0] = _args[0];
1075         dynargs[1] = _args[1];
1076         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1077     }
1078 
1079     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1080         bytes[] memory dynargs = new bytes[](2);
1081         dynargs[0] = _args[0];
1082         dynargs[1] = _args[1];
1083         return oraclize_query(_datasource, dynargs, _gasLimit);
1084     }
1085 
1086     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1087         bytes[] memory dynargs = new bytes[](3);
1088         dynargs[0] = _args[0];
1089         dynargs[1] = _args[1];
1090         dynargs[2] = _args[2];
1091         return oraclize_query(_datasource, dynargs);
1092     }
1093 
1094     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1095         bytes[] memory dynargs = new bytes[](3);
1096         dynargs[0] = _args[0];
1097         dynargs[1] = _args[1];
1098         dynargs[2] = _args[2];
1099         return oraclize_query(_timestamp, _datasource, dynargs);
1100     }
1101 
1102     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1103         bytes[] memory dynargs = new bytes[](3);
1104         dynargs[0] = _args[0];
1105         dynargs[1] = _args[1];
1106         dynargs[2] = _args[2];
1107         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1108     }
1109 
1110     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1111         bytes[] memory dynargs = new bytes[](3);
1112         dynargs[0] = _args[0];
1113         dynargs[1] = _args[1];
1114         dynargs[2] = _args[2];
1115         return oraclize_query(_datasource, dynargs, _gasLimit);
1116     }
1117 
1118     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1119         bytes[] memory dynargs = new bytes[](4);
1120         dynargs[0] = _args[0];
1121         dynargs[1] = _args[1];
1122         dynargs[2] = _args[2];
1123         dynargs[3] = _args[3];
1124         return oraclize_query(_datasource, dynargs);
1125     }
1126 
1127     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1128         bytes[] memory dynargs = new bytes[](4);
1129         dynargs[0] = _args[0];
1130         dynargs[1] = _args[1];
1131         dynargs[2] = _args[2];
1132         dynargs[3] = _args[3];
1133         return oraclize_query(_timestamp, _datasource, dynargs);
1134     }
1135 
1136     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1137         bytes[] memory dynargs = new bytes[](4);
1138         dynargs[0] = _args[0];
1139         dynargs[1] = _args[1];
1140         dynargs[2] = _args[2];
1141         dynargs[3] = _args[3];
1142         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1143     }
1144 
1145     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1146         bytes[] memory dynargs = new bytes[](4);
1147         dynargs[0] = _args[0];
1148         dynargs[1] = _args[1];
1149         dynargs[2] = _args[2];
1150         dynargs[3] = _args[3];
1151         return oraclize_query(_datasource, dynargs, _gasLimit);
1152     }
1153 
1154     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1155         bytes[] memory dynargs = new bytes[](5);
1156         dynargs[0] = _args[0];
1157         dynargs[1] = _args[1];
1158         dynargs[2] = _args[2];
1159         dynargs[3] = _args[3];
1160         dynargs[4] = _args[4];
1161         return oraclize_query(_datasource, dynargs);
1162     }
1163 
1164     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1165         bytes[] memory dynargs = new bytes[](5);
1166         dynargs[0] = _args[0];
1167         dynargs[1] = _args[1];
1168         dynargs[2] = _args[2];
1169         dynargs[3] = _args[3];
1170         dynargs[4] = _args[4];
1171         return oraclize_query(_timestamp, _datasource, dynargs);
1172     }
1173 
1174     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1175         bytes[] memory dynargs = new bytes[](5);
1176         dynargs[0] = _args[0];
1177         dynargs[1] = _args[1];
1178         dynargs[2] = _args[2];
1179         dynargs[3] = _args[3];
1180         dynargs[4] = _args[4];
1181         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1182     }
1183 
1184     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1185         bytes[] memory dynargs = new bytes[](5);
1186         dynargs[0] = _args[0];
1187         dynargs[1] = _args[1];
1188         dynargs[2] = _args[2];
1189         dynargs[3] = _args[3];
1190         dynargs[4] = _args[4];
1191         return oraclize_query(_datasource, dynargs, _gasLimit);
1192     }
1193 
1194     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
1195         return oraclize.setProofType(_proofP);
1196     }
1197 
1198 
1199     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
1200         return oraclize.cbAddress();
1201     }
1202 
1203     function getCodeSize(address _addr) view internal returns (uint _size) {
1204         assembly {
1205             _size := extcodesize(_addr)
1206         }
1207     }
1208 
1209     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
1210         return oraclize.setCustomGasPrice(_gasPrice);
1211     }
1212 
1213     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
1214         return oraclize.randomDS_getSessionPubKeyHash();
1215     }
1216 
1217     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
1218         bytes memory tmp = bytes(_a);
1219         uint160 iaddr = 0;
1220         uint160 b1;
1221         uint160 b2;
1222         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
1223             iaddr *= 256;
1224             b1 = uint160(uint8(tmp[i]));
1225             b2 = uint160(uint8(tmp[i + 1]));
1226             if ((b1 >= 97) && (b1 <= 102)) {
1227                 b1 -= 87;
1228             } else if ((b1 >= 65) && (b1 <= 70)) {
1229                 b1 -= 55;
1230             } else if ((b1 >= 48) && (b1 <= 57)) {
1231                 b1 -= 48;
1232             }
1233             if ((b2 >= 97) && (b2 <= 102)) {
1234                 b2 -= 87;
1235             } else if ((b2 >= 65) && (b2 <= 70)) {
1236                 b2 -= 55;
1237             } else if ((b2 >= 48) && (b2 <= 57)) {
1238                 b2 -= 48;
1239             }
1240             iaddr += (b1 * 16 + b2);
1241         }
1242         return address(iaddr);
1243     }
1244 
1245     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1246         bytes memory a = bytes(_a);
1247         bytes memory b = bytes(_b);
1248         uint minLength = a.length;
1249         if (b.length < minLength) {
1250             minLength = b.length;
1251         }
1252         for (uint i = 0; i < minLength; i ++) {
1253             if (a[i] < b[i]) {
1254                 return -1;
1255             } else if (a[i] > b[i]) {
1256                 return 1;
1257             }
1258         }
1259         if (a.length < b.length) {
1260             return -1;
1261         } else if (a.length > b.length) {
1262             return 1;
1263         } else {
1264             return 0;
1265         }
1266     }
1267 
1268     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1269         bytes memory h = bytes(_haystack);
1270         bytes memory n = bytes(_needle);
1271         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1272             return -1;
1273         } else if (h.length > (2 ** 128 - 1)) {
1274             return -1;
1275         } else {
1276             uint subindex = 0;
1277             for (uint i = 0; i < h.length; i++) {
1278                 if (h[i] == n[0]) {
1279                     subindex = 1;
1280                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1281                         subindex++;
1282                     }
1283                     if (subindex == n.length) {
1284                         return int(i);
1285                     }
1286                 }
1287             }
1288             return -1;
1289         }
1290     }
1291 
1292     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1293         return strConcat(_a, _b, "", "", "");
1294     }
1295 
1296     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1297         return strConcat(_a, _b, _c, "", "");
1298     }
1299 
1300     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1301         return strConcat(_a, _b, _c, _d, "");
1302     }
1303 
1304     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1305         bytes memory _ba = bytes(_a);
1306         bytes memory _bb = bytes(_b);
1307         bytes memory _bc = bytes(_c);
1308         bytes memory _bd = bytes(_d);
1309         bytes memory _be = bytes(_e);
1310         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1311         bytes memory babcde = bytes(abcde);
1312         uint k = 0;
1313         uint i = 0;
1314         for (i = 0; i < _ba.length; i++) {
1315             babcde[k++] = _ba[i];
1316         }
1317         for (i = 0; i < _bb.length; i++) {
1318             babcde[k++] = _bb[i];
1319         }
1320         for (i = 0; i < _bc.length; i++) {
1321             babcde[k++] = _bc[i];
1322         }
1323         for (i = 0; i < _bd.length; i++) {
1324             babcde[k++] = _bd[i];
1325         }
1326         for (i = 0; i < _be.length; i++) {
1327             babcde[k++] = _be[i];
1328         }
1329         return string(babcde);
1330     }
1331 
1332     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1333         return safeParseInt(_a, 0);
1334     }
1335 
1336     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1337         bytes memory bresult = bytes(_a);
1338         uint mint = 0;
1339         bool decimals = false;
1340         for (uint i = 0; i < bresult.length; i++) {
1341             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1342                 if (decimals) {
1343                    if (_b == 0) break;
1344                     else _b--;
1345                 }
1346                 mint *= 10;
1347                 mint += uint(uint8(bresult[i])) - 48;
1348             } else if (uint(uint8(bresult[i])) == 46) {
1349                 require(!decimals, 'More than one decimal encountered in string!');
1350                 decimals = true;
1351             } else {
1352                 revert("Non-numeral character encountered in string!");
1353             }
1354         }
1355         if (_b > 0) {
1356             mint *= 10 ** _b;
1357         }
1358         return mint;
1359     }
1360 
1361     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1362         return parseInt(_a, 0);
1363     }
1364 
1365     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1366         bytes memory bresult = bytes(_a);
1367         uint mint = 0;
1368         bool decimals = false;
1369         for (uint i = 0; i < bresult.length; i++) {
1370             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1371                 if (decimals) {
1372                    if (_b == 0) {
1373                        break;
1374                    } else {
1375                        _b--;
1376                    }
1377                 }
1378                 mint *= 10;
1379                 mint += uint(uint8(bresult[i])) - 48;
1380             } else if (uint(uint8(bresult[i])) == 46) {
1381                 decimals = true;
1382             }
1383         }
1384         if (_b > 0) {
1385             mint *= 10 ** _b;
1386         }
1387         return mint;
1388     }
1389 
1390     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1391         if (_i == 0) {
1392             return "0";
1393         }
1394         uint j = _i;
1395         uint len;
1396         while (j != 0) {
1397             len++;
1398             j /= 10;
1399         }
1400         bytes memory bstr = new bytes(len);
1401         uint k = len - 1;
1402         while (_i != 0) {
1403             bstr[k--] = byte(uint8(48 + _i % 10));
1404             _i /= 10;
1405         }
1406         return string(bstr);
1407     }
1408 
1409     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1410         safeMemoryCleaner();
1411         Buffer.buffer memory buf;
1412         Buffer.init(buf, 1024);
1413         buf.startArray();
1414         for (uint i = 0; i < _arr.length; i++) {
1415             buf.encodeString(_arr[i]);
1416         }
1417         buf.endSequence();
1418         return buf.buf;
1419     }
1420 
1421     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1422         safeMemoryCleaner();
1423         Buffer.buffer memory buf;
1424         Buffer.init(buf, 1024);
1425         buf.startArray();
1426         for (uint i = 0; i < _arr.length; i++) {
1427             buf.encodeBytes(_arr[i]);
1428         }
1429         buf.endSequence();
1430         return buf.buf;
1431     }
1432 
1433     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1434         require((_nbytes > 0) && (_nbytes <= 32));
1435         _delay *= 10; // Convert from seconds to ledger timer ticks
1436         bytes memory nbytes = new bytes(1);
1437         nbytes[0] = byte(uint8(_nbytes));
1438         bytes memory unonce = new bytes(32);
1439         bytes memory sessionKeyHash = new bytes(32);
1440         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1441         assembly {
1442             mstore(unonce, 0x20)
1443             /*
1444              The following variables can be relaxed.
1445              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1446              for an idea on how to override and replace commit hash variables.
1447             */
1448             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1449             mstore(sessionKeyHash, 0x20)
1450             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1451         }
1452         bytes memory delay = new bytes(32);
1453         assembly {
1454             mstore(add(delay, 0x20), _delay)
1455         }
1456         bytes memory delay_bytes8 = new bytes(8);
1457         copyBytes(delay, 24, 8, delay_bytes8, 0);
1458         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1459         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1460         bytes memory delay_bytes8_left = new bytes(8);
1461         assembly {
1462             let x := mload(add(delay_bytes8, 0x20))
1463             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1464             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1465             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1466             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1467             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1468             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1469             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1470             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1471         }
1472         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1473         return queryId;
1474     }
1475 
1476     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1477         oraclize_randomDS_args[_queryId] = _commitment;
1478     }
1479 
1480     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1481         bool sigok;
1482         address signer;
1483         bytes32 sigr;
1484         bytes32 sigs;
1485         bytes memory sigr_ = new bytes(32);
1486         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1487         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1488         bytes memory sigs_ = new bytes(32);
1489         offset += 32 + 2;
1490         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1491         assembly {
1492             sigr := mload(add(sigr_, 32))
1493             sigs := mload(add(sigs_, 32))
1494         }
1495         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1496         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1497             return true;
1498         } else {
1499             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1500             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1501         }
1502     }
1503 
1504     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1505         bool sigok;
1506         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1507         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1508         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1509         bytes memory appkey1_pubkey = new bytes(64);
1510         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1511         bytes memory tosign2 = new bytes(1 + 65 + 32);
1512         tosign2[0] = byte(uint8(1)); //role
1513         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1514         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1515         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1516         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1517         if (!sigok) {
1518             return false;
1519         }
1520         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1521         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1522         bytes memory tosign3 = new bytes(1 + 65);
1523         tosign3[0] = 0xFE;
1524         copyBytes(_proof, 3, 65, tosign3, 1);
1525         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1526         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1527         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1528         return sigok;
1529     }
1530 
1531     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1532         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1533         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1534             return 1;
1535         }
1536         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1537         if (!proofVerified) {
1538             return 2;
1539         }
1540         return 0;
1541     }
1542 
1543     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1544         bool match_ = true;
1545         require(_prefix.length == _nRandomBytes);
1546         for (uint256 i = 0; i< _nRandomBytes; i++) {
1547             if (_content[i] != _prefix[i]) {
1548                 match_ = false;
1549             }
1550         }
1551         return match_;
1552     }
1553 
1554     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1555         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1556         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1557         bytes memory keyhash = new bytes(32);
1558         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1559         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1560             return false;
1561         }
1562         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1563         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1564         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1565         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1566             return false;
1567         }
1568         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1569         // This is to verify that the computed args match with the ones specified in the query.
1570         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1571         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1572         bytes memory sessionPubkey = new bytes(64);
1573         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1574         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1575         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1576         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1577             delete oraclize_randomDS_args[_queryId];
1578         } else return false;
1579         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1580         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1581         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1582         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1583             return false;
1584         }
1585         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1586         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1587             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1588         }
1589         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1590     }
1591     /*
1592      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1593     */
1594     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1595         uint minLength = _length + _toOffset;
1596         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1597         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1598         uint j = 32 + _toOffset;
1599         while (i < (32 + _fromOffset + _length)) {
1600             assembly {
1601                 let tmp := mload(add(_from, i))
1602                 mstore(add(_to, j), tmp)
1603             }
1604             i += 32;
1605             j += 32;
1606         }
1607         return _to;
1608     }
1609     /*
1610      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1611      Duplicate Solidity's ecrecover, but catching the CALL return value
1612     */
1613     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1614         /*
1615          We do our own memory management here. Solidity uses memory offset
1616          0x40 to store the current end of memory. We write past it (as
1617          writes are memory extensions), but don't update the offset so
1618          Solidity will reuse it. The memory used here is only needed for
1619          this context.
1620          FIXME: inline assembly can't access return values
1621         */
1622         bool ret;
1623         address addr;
1624         assembly {
1625             let size := mload(0x40)
1626             mstore(size, _hash)
1627             mstore(add(size, 32), _v)
1628             mstore(add(size, 64), _r)
1629             mstore(add(size, 96), _s)
1630             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1631             addr := mload(size)
1632         }
1633         return (ret, addr);
1634     }
1635     /*
1636      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1637     */
1638     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1639         bytes32 r;
1640         bytes32 s;
1641         uint8 v;
1642         if (_sig.length != 65) {
1643             return (false, address(0));
1644         }
1645         /*
1646          The signature format is a compact form of:
1647            {bytes32 r}{bytes32 s}{uint8 v}
1648          Compact means, uint8 is not padded to 32 bytes.
1649         */
1650         assembly {
1651             r := mload(add(_sig, 32))
1652             s := mload(add(_sig, 64))
1653             /*
1654              Here we are loading the last 32 bytes. We exploit the fact that
1655              'mload' will pad with zeroes if we overread.
1656              There is no 'mload8' to do this, but that would be nicer.
1657             */
1658             v := byte(0, mload(add(_sig, 96)))
1659             /*
1660               Alternative solution:
1661               'byte' is not working due to the Solidity parser, so lets
1662               use the second best option, 'and'
1663               v := and(mload(add(_sig, 65)), 255)
1664             */
1665         }
1666         /*
1667          albeit non-transactional signatures are not specified by the YP, one would expect it
1668          to match the YP range of [27, 28]
1669          geth uses [0, 1] and some clients have followed. This might change, see:
1670          https://github.com/ethereum/go-ethereum/issues/2053
1671         */
1672         if (v < 27) {
1673             v += 27;
1674         }
1675         if (v != 27 && v != 28) {
1676             return (false, address(0));
1677         }
1678         return safer_ecrecover(_hash, v, r, s);
1679     }
1680 
1681     function safeMemoryCleaner() internal pure {
1682         assembly {
1683             let fmem := mload(0x40)
1684             codecopy(fmem, codesize, sub(msize, fmem))
1685         }
1686     }
1687 }
1688 /*
1689 
1690 END ORACLIZE_API
1691 
1692 */
1693 
1694 contract oraclizeController is usingOraclize {
1695     address owner;
1696     
1697     event newOraclizeQuery();
1698     event RemoteBettingCloseInfo(address _race);
1699     
1700     struct horsesInfo {
1701         bytes32 BTC;
1702         bytes32 ETH;
1703         bytes32 LTC;
1704         uint256 customPreGasLimit;
1705         uint256 customPostGasLimit;
1706     }
1707     
1708     struct coinInfo {
1709         uint256 pre;
1710         uint256 post;
1711         bytes32 preOraclizeId;
1712         bytes32 postOraclizeId;
1713     }
1714     
1715     mapping (address => mapping (bytes32 => coinInfo)) public coinIndex; 
1716     mapping (address => mapping (bytes32 => bytes32)) oraclizeIndex; // mapping oraclize IDs with coins
1717     mapping (bytes32 => address) oraclizeInverseIndex; // mapping oraclize IDs with coins
1718     
1719     horsesInfo horses;
1720     constructor() public {
1721         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1722         // oraclize_setCustomGasPrice(10000000000 wei);
1723         oraclize_setCustomGasPrice(30000000000 wei);
1724         horses.BTC = bytes32("BTC");
1725         horses.ETH = bytes32("ETH");
1726         horses.LTC = bytes32("LTC");
1727         owner = msg.sender;
1728         horses.customPreGasLimit = 120000;
1729         horses.customPostGasLimit = 230000;
1730     }
1731     
1732     modifier onlyOwner {
1733         require(owner == msg.sender);
1734         _;
1735     }
1736     
1737     // safemath addition
1738     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1739         uint256 c = a + b;
1740         assert(c >= a);
1741         return c;
1742     }
1743     
1744     // utility function to convert string to integer with precision consideration
1745     function stringToUintNormalize(string memory s) internal pure returns (uint result) {
1746         uint p =2;
1747         bool precision=false;
1748         bytes memory b = bytes(s);
1749         uint i;
1750         result = 0;
1751         for (i = 0; i < b.length; i++) {
1752             if (precision) {p = p-1;}
1753             // if (uint(b[i]) == uint(46)){precision = true;}
1754             if (uint8(b[i]) == uint8(46)){precision = true;}
1755             uint8 c = uint8(b[i]);
1756             if (c >= 48 && c <= 57) {result = result * 10 + (c - 48);}
1757             if (precision && p == 0){return result;}
1758         }
1759         while (p!=0) {
1760             result = result*10;
1761             p=p-1;
1762         }
1763     }
1764     
1765     function changeOraclizeGasPrice(uint _newGasPrice) external onlyOwner {
1766         oraclize_setCustomGasPrice(_newGasPrice);
1767     }
1768     
1769     // method to place the oraclize queries
1770     function setupRace(uint delay, uint locking_duration, address raceAddress) public payable onlyOwner {
1771         if (oraclize_getPrice("URL" , horses.customPreGasLimit)*3 + oraclize_getPrice("URL", horses.customPostGasLimit)*3  > address(this).balance) {
1772         } else {
1773             bytes32 temp_ID; // temp variable to store oraclize IDs
1774             emit newOraclizeQuery();
1775             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027/).data.quotes.USD.price",horses.customPreGasLimit);
1776             oraclizeIndex[raceAddress][temp_ID] = horses.ETH;
1777             oraclizeInverseIndex[temp_ID] = raceAddress;
1778             coinIndex[raceAddress][horses.ETH].preOraclizeId = temp_ID;
1779 
1780             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/2/).data.quotes.USD.price",horses.customPreGasLimit);
1781             oraclizeIndex[raceAddress][temp_ID] = horses.LTC;
1782             oraclizeInverseIndex[temp_ID] = raceAddress;
1783             coinIndex[raceAddress][horses.LTC].preOraclizeId = temp_ID;
1784 
1785             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1/).data.quotes.USD.price",horses.customPreGasLimit);
1786             oraclizeIndex[raceAddress][temp_ID] = horses.BTC;
1787             oraclizeInverseIndex[temp_ID] = raceAddress;
1788             coinIndex[raceAddress][horses.BTC].preOraclizeId = temp_ID;
1789 
1790             //bets closing price query
1791             delay = add(delay,locking_duration);
1792 
1793             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1027/).data.quotes.USD.price",horses.customPostGasLimit);
1794             oraclizeIndex[raceAddress][temp_ID] = horses.ETH;
1795             oraclizeInverseIndex[temp_ID] = raceAddress;
1796             coinIndex[raceAddress][horses.ETH].postOraclizeId = temp_ID;
1797 
1798             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/2/).data.quotes.USD.price",horses.customPostGasLimit);
1799             oraclizeIndex[raceAddress][temp_ID] = horses.LTC;
1800             oraclizeInverseIndex[temp_ID] = raceAddress;
1801             coinIndex[raceAddress][horses.LTC].postOraclizeId = temp_ID;
1802 
1803             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v2/ticker/1/).data.quotes.USD.price",horses.customPostGasLimit);
1804             oraclizeIndex[raceAddress][temp_ID] = horses.BTC;
1805             oraclizeInverseIndex[temp_ID] = raceAddress;
1806             coinIndex[raceAddress][horses.BTC].postOraclizeId = temp_ID;
1807         }
1808     }
1809     
1810     //oraclize callback method
1811     function __callback(bytes32 myid, string memory result, bytes memory proof) public {
1812         require (msg.sender == oraclize_cbAddress());
1813         require (stringToUintNormalize(result) > 0);
1814         bytes32 coin_pointer; // variable to differentiate different callbacks
1815         address raceAddress = oraclizeInverseIndex[myid];
1816         Race race = Race(raceAddress);
1817         coin_pointer = oraclizeIndex[raceAddress][myid];
1818         emit RemoteBettingCloseInfo(raceAddress);
1819         
1820         if (myid == coinIndex[raceAddress][coin_pointer].preOraclizeId) {
1821             if (coinIndex[raceAddress][coin_pointer].pre > 0) {
1822             } else {
1823                 coinIndex[raceAddress][coin_pointer].pre = stringToUintNormalize(result);
1824                 race.priceCallback(coin_pointer,coinIndex[raceAddress][coin_pointer].pre,true);
1825             }
1826         } else if (myid == coinIndex[raceAddress][coin_pointer].postOraclizeId){
1827             if (coinIndex[raceAddress][coin_pointer].post > 0) {
1828             } else {
1829                 coinIndex[raceAddress][coin_pointer].post = stringToUintNormalize(result);
1830                 race.priceCallback(coin_pointer,coinIndex[raceAddress][coin_pointer].post,false);
1831             }
1832         }
1833     }
1834     
1835     function ethorseOracle(address raceAddress, bytes32 coin_pointer, string calldata result, bool isPrePrice, uint32 lastUpdated ) external onlyOwner {
1836         emit RemoteBettingCloseInfo(raceAddress);
1837         Race race = Race(raceAddress);
1838         uint32 starting_time;
1839         uint32 betting_duration;
1840         uint32 race_duration;
1841         if (isPrePrice) {
1842             starting_time = race.getChronus()[0];
1843             betting_duration = race.getChronus()[1];
1844             if (lastUpdated < starting_time + betting_duration + 800 &&
1845                 lastUpdated > starting_time + betting_duration - 800) {
1846                     coinIndex[raceAddress][coin_pointer].pre = stringToUintNormalize(result);
1847                     race.priceCallback(coin_pointer, stringToUintNormalize(result), isPrePrice);
1848             } else {
1849                 race.forceVoidExternal();
1850             }
1851         } else {
1852             starting_time = race.getChronus()[0];
1853             race_duration = race.getChronus()[2];
1854             if (lastUpdated < starting_time + race_duration + 800 &&
1855                 lastUpdated > starting_time + race_duration - 800) {
1856                     coinIndex[raceAddress][coin_pointer].post = stringToUintNormalize(result);
1857                     race.priceCallback(coin_pointer, stringToUintNormalize(result), isPrePrice);
1858             }
1859         }
1860     }
1861 }
1862 
1863 contract BettingController is oraclizeController {
1864     address payable owner;
1865     Race race;
1866 
1867     mapping (address => bool) public isOraclizeEnabled;
1868     event RaceDeployed(address _address, address _owner, uint256 _bettingDuration, uint256 _raceDuration, uint256 _time);
1869     event AddFund(uint256 _value);
1870 
1871     modifier onlyOwner {
1872         require(msg.sender == owner);
1873         _;
1874     }
1875 
1876     constructor() public payable {
1877         owner = msg.sender;
1878     }
1879 
1880     function addFunds() external onlyOwner payable {
1881         emit AddFund(msg.value);
1882     }
1883 
1884     function spawnRaceManual(uint256 _bettingDuration, uint256 _raceDuration, bool _isOraclizeUsed) external onlyOwner {
1885         race = (new Race)();
1886         emit RaceDeployed(address(race), race.owner(), _bettingDuration, _raceDuration, now);
1887         if (_isOraclizeUsed) {
1888             isOraclizeEnabled[address(race)] = true;
1889             setupRace(_bettingDuration, _raceDuration, address(race));
1890         }
1891         uint32 bettingDuration = uint32(_bettingDuration);
1892         uint32 raceDuration = uint32(_raceDuration);
1893         raceDuration = uint32(add(bettingDuration,raceDuration));
1894         bettingDuration = uint32(bettingDuration);
1895         race.setupRace(bettingDuration,raceDuration);
1896     }
1897 
1898     function enableRefund(address _race) external onlyOwner {
1899         Race raceInstance = Race(_race);
1900         emit RemoteBettingCloseInfo(_race);
1901         raceInstance.refund();
1902     }
1903 
1904     function manualRecovery(address _race) external onlyOwner {
1905         Race raceInstance = Race(_race);
1906         raceInstance.recovery();
1907     }
1908 
1909     function changeRaceOwnership(address _race, address _newOwner) external onlyOwner {
1910         Race raceInstance = Race(_race);
1911         raceInstance.changeOwnership(_newOwner);
1912     }
1913 
1914     function extractFund(uint256 _amount) external onlyOwner {
1915         if (_amount == 0) {
1916             owner.transfer(address(this).balance);
1917         } else {
1918             require(_amount <= address(this).balance);
1919             owner.transfer(_amount);
1920         }
1921     }
1922 }