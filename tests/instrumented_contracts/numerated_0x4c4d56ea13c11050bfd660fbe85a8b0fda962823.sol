1 pragma solidity ^0.5.0;
2 
3 contract HalfRouletteEvents {
4     event Commit(uint commit); // 배팅
5     event Payment(address indexed gambler, uint amount, uint8 betMask, uint8 l, uint8 r, uint betAmount); // 결과 처리
6     event Refund(address indexed gambler, uint amount); // 결과 처리
7     event JackpotPayment(address indexed gambler, uint amount); // 잭팟
8     event VIPBenefit(address indexed gambler, uint amount); // VIP 보상
9     event InviterBenefit(address indexed inviter, address gambler, uint betAmount, uint amount); // 초대자 보상
10     event LuckyCoinBenefit(address indexed gambler, uint amount, uint32 result); // 럭키코인 보상
11     event TodaysRankingPayment(address indexed gambler, uint amount); // 랭킹 보상
12 }
13 
14 contract HalfRouletteOwner {
15     address payable owner; // 게시자
16     address payable nextOwner;
17     address secretSigner = 0xcb91F80fC3dcC6D51b10b1a6E6D77C28DAf7ffE2; // 서명 관리자
18     mapping(address => bool) public croupierMap; // 하우스 운영
19 
20     modifier onlyOwner {
21         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
22         _;
23     }
24 
25     modifier onlyCroupier {
26         bool isCroupier = croupierMap[msg.sender];
27         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
28         _;
29     }
30 
31     constructor() public {
32         owner = msg.sender;
33         croupierMap[msg.sender] = true;
34     }
35 
36     function approveNextOwner(address payable _nextOwner) external onlyOwner {
37         require(_nextOwner != owner, "Cannot approve current owner.");
38         nextOwner = _nextOwner;
39     }
40 
41     function acceptNextOwner() external {
42         require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
43         owner = nextOwner;
44     }
45 
46     function setSecretSigner(address newSecretSigner) external onlyOwner {
47         secretSigner = newSecretSigner;
48     }
49 
50     function addCroupier(address newCroupier) external onlyOwner {
51         bool isCroupier = croupierMap[newCroupier];
52         if (isCroupier == false) {
53             croupierMap[newCroupier] = true;
54         }
55     }
56 
57     function deleteCroupier(address newCroupier) external onlyOwner {
58         bool isCroupier = croupierMap[newCroupier];
59         if (isCroupier == true) {
60             croupierMap[newCroupier] = false;
61         }
62     }
63 
64 }
65 
66 contract HalfRouletteStruct {
67     struct Bet {
68         uint amount; // 배팅 금액
69         uint8 betMask; // 배팅 정보
70         uint40 placeBlockNumber; // Block number of placeBet tx.
71         address payable gambler; // Address of a gambler, used to pay out winning bets.
72     }
73 
74     struct LuckyCoin {
75         bool coin; // 럭키 코인 활성화
76         uint16 result; // 마지막 결과
77         uint64 amount; // MAX 18.446744073709551615 ether < RECEIVE_LUCKY_COIN_BET(0.05 ether)
78         uint64 timestamp; // 마지막 업데이트 시간 00:00 시
79     }
80 
81     struct DailyRankingPrize {
82         uint128 prizeSize; // 지불 급액
83         uint64 timestamp; // 마지막 업데이트 시간 00:00 시
84         uint8 cnt; // 받은 횟수
85     }
86 }
87 
88 contract HalfRouletteConstant {
89     //    constant
90     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
91     // past. Given that settleBet uses block hash of placeBet as one of
92     // complementary entropy sources, we cannot process bets older than this
93     // threshold. On rare occasions AceDice croupier may fail to invoke
94     // settleBet in this timespan due to technical issues or extreme Ethereum
95     // congestion; such bets can be refunded via invoking refundBet.
96     uint constant BET_EXPIRATION_BLOCKS = 250;
97 
98     uint constant JACKPOT_FEE_PERCENT = 1; // amount * 0.001
99     uint constant HOUSE_EDGE_PERCENT = 1; // amount * 0.01
100     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether; // 최소 houseEdge
101 
102     uint constant RANK_FUNDS_PERCENT = 12; // houseEdge * 0.12
103     uint constant INVITER_BENEFIT_PERCENT = 9; // houseEdge * 0.09
104 
105     uint constant MAX_LUCKY_COIN_BENEFIT = 1.65 ether; // 최대 ether
106     uint constant MIN_BET = 0.01 ether; // 최소 배팅 금액
107     uint constant MAX_BET = 300000 ether; // 최대 배팅 금액
108     uint constant MIN_JACKPOT_BET = 0.1 ether;
109     uint constant RECEIVE_LUCKY_COIN_BET = 0.05 ether;
110 
111     uint constant BASE_WIN_RATE = 100000;
112 
113     uint constant TODAY_RANKING_PRIZE_MODULUS = 10000;
114     // not support constant
115     uint16[10] TODAY_RANKING_PRIZE_RATE = [5000, 2500, 1200, 600, 300, 200, 100, 50, 35, 15];
116 }
117 
118 contract HalfRoulettePure is HalfRouletteConstant {
119 
120     function verifyBetMask(uint betMask) public pure {
121         bool verify;
122         assembly {
123             switch betMask
124             case 1 /* ODD */{verify := 1}
125             case 2 /* EVEN */{verify := 1}
126             case 4 /* LEFT */{verify := 1}
127             case 8 /* RIGHT */{verify := 1}
128             case 5 /* ODD | LEFT */{verify := 1}
129             case 9 /* ODD | RIGHT */{verify := 1}
130             case 6 /* EVEN | LEFT */{verify := 1}
131             case 10 /* EVEN | RIGHT */{verify := 1}
132             case 16 /* EQUAL */{verify := 1}
133         }
134         require(verify, "invalid betMask");
135     }
136 
137     function getRecoverSigner(uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
138         bytes32 messageHash = keccak256(abi.encodePacked(commitLastBlock, commit));
139         return ecrecover(messageHash, v, r, s);
140     }
141 
142     function getWinRate(uint betMask) public pure returns (uint rate) {
143         // assembly 안에서는 constant 사용 불가
144         uint ODD_EVEN_RATE = 50000;
145         uint LEFT_RIGHT_RATE = 45833;
146         uint MIX_RATE = 22916;
147         uint EQUAL_RATE = 8333;
148         assembly {
149             switch betMask
150             case 1 /* ODD */{rate := ODD_EVEN_RATE}
151             case 2 /* EVEN */{rate := ODD_EVEN_RATE}
152             case 4 /* LEFT */{rate := LEFT_RIGHT_RATE}
153             case 8 /* RIGHT */{rate := LEFT_RIGHT_RATE}
154             case 5 /* ODD | LEFT */{rate := MIX_RATE}
155             case 9 /* ODD | RIGHT */{rate := MIX_RATE}
156             case 6 /* EVEN | LEFT */{rate := MIX_RATE}
157             case 10 /* EVEN | RIGHT */{rate := MIX_RATE}
158             case 16 /* EQUAL */{rate := EQUAL_RATE}
159         }
160     }
161 
162     function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
163         // 0.02
164         houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
165         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
166             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
167         }
168     }
169 
170     function calcJackpotFee(uint amount) public pure returns (uint jackpotFee) {
171         // 0.001
172         jackpotFee = amount * JACKPOT_FEE_PERCENT / 1000;
173     }
174 
175     function calcRankFundsFee(uint houseEdge) public pure returns (uint rankFundsFee) {
176         // 0.12
177         rankFundsFee = houseEdge * RANK_FUNDS_PERCENT / 100;
178     }
179 
180     function calcInviterBenefit(uint houseEdge) public pure returns (uint invitationFee) {
181         // 0.09
182         invitationFee = houseEdge * INVITER_BENEFIT_PERCENT / 100;
183     }
184 
185     function calcVIPBenefit(uint amount, uint totalAmount) public pure returns (uint vipBenefit) {
186         /*
187             0   0.00 %  없음
188             1   0.01 %  골드
189             2   0.02 %  토파즈
190             3   0.03 %  크리스탈
191             4   0.04 %  에메랄드
192             5   0.05 %  사파이어
193             6   0.07 %  오팔
194             7   0.09 %  다이아몬드
195             8   0.11 %  옐로_다이아몬드
196             9   0.13 %  블루_다이아몬드
197             10  0.15 %  레드_다이아몬드
198         */
199         uint rate;
200         if (totalAmount < 25 ether) {
201             return rate;
202         } else if (totalAmount < 125 ether) {
203             rate = 1;
204         } else if (totalAmount < 250 ether) {
205             rate = 2;
206         } else if (totalAmount < 1250 ether) {
207             rate = 3;
208         } else if (totalAmount < 2500 ether) {
209             rate = 4;
210         } else if (totalAmount < 12500 ether) {
211             rate = 5;
212         } else if (totalAmount < 25000 ether) {
213             rate = 7;
214         } else if (totalAmount < 125000 ether) {
215             rate = 9;
216         } else if (totalAmount < 250000 ether) {
217             rate = 11;
218         } else if (totalAmount < 1250000 ether) {
219             rate = 13;
220         } else {
221             rate = 15;
222         }
223         vipBenefit = amount * rate / 10000;
224     }
225 
226     function calcLuckyCoinBenefit(uint num) public pure returns (uint luckCoinBenefit) {
227         /*
228             1    - 9885 0.000015 ETH
229             9886 - 9985 0.00015 ETH
230             9986 - 9993 0.0015 ETH
231             9994 - 9997 0.015 ETH
232             9998 - 9999 0.15 ETH
233             10000       1.65 ETH
234         */
235         if (num < 9886) {
236             return 0.000015 ether;
237         } else if (num < 9986) {
238             return 0.00015 ether;
239         } else if (num < 9994) {
240             return 0.0015 ether;
241         } else if (num < 9998) {
242             return 0.015 ether;
243         } else if (num < 10000) {
244             return 0.15 ether;
245         } else {
246             return 1.65 ether;
247         }
248     }
249 
250     function getWinAmount(uint betMask, uint amount) public pure returns (uint) {
251         uint houseEdge = calcHouseEdge(amount);
252         uint jackpotFee = calcJackpotFee(amount);
253         uint betAmount = amount - houseEdge - jackpotFee;
254         uint rate = getWinRate(betMask);
255         return betAmount * BASE_WIN_RATE / rate;
256     }
257 
258     function calcBetResult(uint betMask, bytes32 entropy) public pure returns (bool isWin, uint l, uint r)  {
259         uint v = uint(entropy);
260         l = (v % 12) + 1;
261         r = ((v >> 4) % 12) + 1;
262         uint mask = getResultMask(l, r);
263         isWin = (betMask & mask) == betMask;
264     }
265 
266     function getResultMask(uint l, uint r) public pure returns (uint mask) {
267         uint v1 = (l + r) % 2;
268         uint v2 = l - r;
269         if (v1 == 0) {
270             mask = mask | 2;
271         } else {
272             mask = mask | 1;
273         }
274 
275         if (v2 == 0) {
276             mask = mask | 16;
277         } else if (v2 > 0) {
278             mask = mask | 4;
279         } else {
280             mask = mask | 8;
281         }
282         return mask;
283     }
284 
285     function isJackpot(bytes32 entropy, uint amount) public pure returns (bool jackpot) {
286         return amount >= MIN_JACKPOT_BET && (uint(entropy) % 1000) == 0;
287     }
288 
289     function verifyCommit(address signer, uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) internal pure {
290         address recoverSigner = getRecoverSigner(commitLastBlock, commit, v, r, s);
291         require(recoverSigner == signer, "failed different signer");
292     }
293 
294     function startOfDay(uint timestamp) internal pure returns (uint64) {
295         return uint64(timestamp - (timestamp % 1 days));
296     }
297 
298 }
299 
300 contract HalfRoulette is HalfRouletteEvents, HalfRouletteOwner, HalfRouletteStruct, HalfRouletteConstant, HalfRoulettePure {
301     uint128 public lockedInBets;
302     uint128 public jackpotSize; // 잭팟 크기
303     uint128 public rankFunds; // 랭킹 보상
304     DailyRankingPrize dailyRankingPrize;
305 
306     // Adjustable max bet profit. Used to cap bets against dynamic odds.
307     uint public maxProfit = 10 ether;
308 
309     // global variable
310     mapping(uint => Bet) public bets;
311     mapping(address => LuckyCoin) public luckyCoins;
312     mapping(address => address payable) public inviterMap;
313     mapping(address => uint) public accuBetAmount;
314 
315     function() external payable {}
316 
317     function kill() external onlyOwner {
318         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
319         selfdestruct(address(owner));
320     }
321 
322     function setMaxProfit(uint _maxProfit) external onlyOwner {
323         require(_maxProfit < MAX_BET, "maxProfit should be a sane number.");
324         maxProfit = _maxProfit;
325     }
326 
327     function placeBet(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public payable {
328         Bet storage bet = bets[commit];
329         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
330 
331         // amount checked
332         uint amount = msg.value;
333         require(amount >= MIN_BET, 'failed amount >= MIN_BET');
334         require(amount <= MAX_BET, "failed amount <= MAX_BET");
335         // allow bet check
336         verifyBetMask(betMask);
337         // rand seed check
338         verifyCommit(secretSigner, uint40(commitLastBlock), commit, v, r, s);
339 
340         // house balance check
341         uint winAmount = getWinAmount(betMask, amount);
342         require(winAmount <= amount + maxProfit, "maxProfit limit violation.");
343         lockedInBets += uint128(winAmount);
344         require(lockedInBets + jackpotSize + rankFunds + dailyRankingPrize.prizeSize <= address(this).balance, "Cannot afford to lose this bet.");
345 
346         // save
347         emit Commit(commit);
348         bet.gambler = msg.sender;
349         bet.amount = amount;
350         bet.betMask = betMask;
351         bet.placeBlockNumber = uint40(block.number);
352 
353         // lucky coin 은 block.timestamp 에 의존하여 사전에 처리
354         incLuckyCoin(msg.sender, amount);
355     }
356 
357     function placeBetWithInviter(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
358         require(inviter != address(0), "inviter != address (0)");
359         address preInviter = inviterMap[msg.sender];
360         if (preInviter == address(0)) {
361             inviterMap[msg.sender] = inviter;
362         }
363         placeBet(betMask, commitLastBlock, commit, v, r, s);
364     }
365 
366     // block.timestamp 에 의존 합니다
367     function incLuckyCoin(address gambler, uint amount) internal {
368         LuckyCoin storage luckyCoin = luckyCoins[gambler];
369 
370         uint64 today = startOfDay(block.timestamp);
371         uint beforeAmount;
372 
373         if (today == luckyCoin.timestamp) {
374             beforeAmount = uint(luckyCoin.amount);
375         } else {
376             luckyCoin.timestamp = today;
377             if (luckyCoin.coin) luckyCoin.coin = false;
378         }
379 
380         if (beforeAmount == RECEIVE_LUCKY_COIN_BET) return;
381 
382         uint totalAmount = beforeAmount + amount;
383 
384         if (totalAmount >= RECEIVE_LUCKY_COIN_BET) {
385             luckyCoin.amount = uint64(RECEIVE_LUCKY_COIN_BET);
386             if (!luckyCoin.coin) {
387                 luckyCoin.coin = true;
388             }
389         } else {
390             luckyCoin.amount = uint64(totalAmount);
391         }
392     }
393 
394     function revertLuckyCoin(address gambler) private {
395         LuckyCoin storage luckyCoin = luckyCoins[gambler];
396         if (!luckyCoin.coin) return;
397         if (startOfDay(block.timestamp) == luckyCoin.timestamp) {
398             luckyCoin.coin = false;
399         }
400     }
401 
402     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
403         uint commit = uint(keccak256(abi.encodePacked(reveal)));
404 
405         Bet storage bet = bets[commit];
406         uint placeBlockNumber = bet.placeBlockNumber;
407 
408         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
409         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
410         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
411         require(blockhash(placeBlockNumber) == blockHash);
412 
413         // Settle bet using reveal and blockHash as entropy sources.
414         settleBetCommon(bet, reveal, blockHash);
415     }
416 
417     // This method is used to settle a bet that was mined into an uncle block. At this
418     // point the player was shown some bet outcome, but the blockhash at placeBet height
419     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
420     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
421     // indeed was present on-chain at some point.
422     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
423         // "commit" for bet settlement can only be obtained by hashing a "reveal".
424         uint commit = uint(keccak256(abi.encodePacked(reveal)));
425 
426         Bet storage bet = bets[commit];
427 
428         // Check that canonical block hash can still be verified.
429         require(block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
430 
431         // Verify placeBet receipt.
432         requireCorrectReceipt(4 + 32 + 32 + 4);
433 
434         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
435         bytes32 canonicalHash;
436         bytes32 uncleHash;
437         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
438         require(blockhash(canonicalBlockNumber) == canonicalHash);
439 
440         // Settle bet using reveal and uncleHash as entropy sources.
441         settleBetCommon(bet, reveal, uncleHash);
442     }
443 
444     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
445     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
446     function requireCorrectReceipt(uint offset) view private {
447         uint leafHeaderByte;
448         assembly {leafHeaderByte := byte(0, calldataload(offset))}
449 
450         require(leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
451         offset += leafHeaderByte - 0xf6;
452 
453         uint pathHeaderByte;
454         assembly {pathHeaderByte := byte(0, calldataload(offset))}
455 
456         if (pathHeaderByte <= 0x7f) {
457             offset += 1;
458 
459         } else {
460             require(pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
461             offset += pathHeaderByte - 0x7f;
462         }
463 
464         uint receiptStringHeaderByte;
465         assembly {receiptStringHeaderByte := byte(0, calldataload(offset))}
466         require(receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
467         offset += 3;
468 
469         uint receiptHeaderByte;
470         assembly {receiptHeaderByte := byte(0, calldataload(offset))}
471         require(receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
472         offset += 3;
473 
474         uint statusByte;
475         assembly {statusByte := byte(0, calldataload(offset))}
476         require(statusByte == 0x1, "Status should be success.");
477         offset += 1;
478 
479         uint cumGasHeaderByte;
480         assembly {cumGasHeaderByte := byte(0, calldataload(offset))}
481         if (cumGasHeaderByte <= 0x7f) {
482             offset += 1;
483 
484         } else {
485             require(cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
486             offset += cumGasHeaderByte - 0x7f;
487         }
488 
489         uint bloomHeaderByte;
490         assembly {bloomHeaderByte := byte(0, calldataload(offset))}
491         require(bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
492         offset += 256 + 3;
493 
494         uint logsListHeaderByte;
495         assembly {logsListHeaderByte := byte(0, calldataload(offset))}
496         require(logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
497         offset += 2;
498 
499         uint logEntryHeaderByte;
500         assembly {logEntryHeaderByte := byte(0, calldataload(offset))}
501         require(logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
502         offset += 2;
503 
504         uint addressHeaderByte;
505         assembly {addressHeaderByte := byte(0, calldataload(offset))}
506         require(addressHeaderByte == 0x94, "Address is 20 bytes long.");
507 
508         uint logAddress;
509         assembly {logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff)}
510         require(logAddress == uint(address(this)));
511     }
512     /*
513       *** Merkle 증명.
514 
515       이 도우미는 삼촌 블록에 placeBet 포함을 증명하는 암호를 확인하는 데 사용됩니다.
516 
517       스마트 계약의 보안을 손상시키지 않으면 서 Ethereum reorg에서 베팅 결과가 변경되는 것을 방지하기 위해 사용됩니다.
518       증명 자료는 간단한 접두사 길이 형식으로 입력 데이터에 추가되며 ABI를 따르지 않습니다.
519 
520       불변량 검사 :
521       - 영수증 트라이 엔트리는 페이로드로 커밋을 포함하는이 스마트 계약 (3)에 대한 (1) 성공적인 트랜잭션 (2)을 포함합니다.
522       - 영수증 트 리 항목은 블록 헤더의 유효한 merkle 증명의 일부입니다
523       - 블록 헤더는 정식 체인에있는 블록의 삼촌 목록의 일부입니다. 구현은 가스 비용에 최적화되어 있으며 Ethereum 내부 데이터 구조의 특성에 의존합니다.
524 
525       자세한 내용은 백서를 참조하십시오.
526 
527       일부 seedHash (보통 커밋)에서 시작하여 완전한 merkle 증명을 확인하는 도우미.
528       "offset"은 calldata에서 시작되는 증명의 위치입니다.
529     */
530     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
531         // (Safe) assumption - nobody will write into RAM during this method invocation.
532         uint scratchBuf1;
533         assembly {scratchBuf1 := mload(0x40)}
534 
535         uint uncleHeaderLength;
536         uint blobLength;
537         uint shift;
538         uint hashSlot;
539 
540         // Verify merkle proofs up to uncle block header. Calldata layout is:
541         // - 2 byte big-endian slice length
542         // - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
543         // - followed by the current slice verbatim
544         for (;; offset += blobLength) {
545             assembly {blobLength := and(calldataload(sub(offset, 30)), 0xffff)}
546             if (blobLength == 0) {
547                 // Zero slice length marks the end of uncle proof.
548                 break;
549             }
550 
551             assembly {shift := and(calldataload(sub(offset, 28)), 0xffff)}
552             require(shift + 32 <= blobLength, "Shift bounds check.");
553 
554             offset += 4;
555             assembly {hashSlot := calldataload(add(offset, shift))}
556             require(hashSlot == 0, "Non-empty hash slot.");
557 
558             assembly {
559                 calldatacopy(scratchBuf1, offset, blobLength)
560                 mstore(add(scratchBuf1, shift), seedHash)
561                 seedHash := keccak256(scratchBuf1, blobLength)
562                 uncleHeaderLength := blobLength
563             }
564         }
565 
566         // At this moment the uncle hash is known.
567         uncleHash = bytes32(seedHash);
568 
569         // Construct the uncle list of a canonical block.
570         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
571         uint unclesLength;
572         assembly {unclesLength := and(calldataload(sub(offset, 28)), 0xffff)}
573         uint unclesShift;
574         assembly {unclesShift := and(calldataload(sub(offset, 26)), 0xffff)}
575         require(unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
576 
577         offset += 6;
578         assembly {calldatacopy(scratchBuf2, offset, unclesLength)}
579         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
580 
581         assembly {seedHash := keccak256(scratchBuf2, unclesLength)}
582 
583         offset += unclesLength;
584 
585         // Verify the canonical block header using the computed sha3Uncles.
586         assembly {
587             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
588             shift := and(calldataload(sub(offset, 28)), 0xffff)
589         }
590         require(shift + 32 <= blobLength, "Shift bounds check.");
591 
592         offset += 4;
593         assembly {hashSlot := calldataload(add(offset, shift))}
594         require(hashSlot == 0, "Non-empty hash slot.");
595 
596         assembly {
597             calldatacopy(scratchBuf1, offset, blobLength)
598             mstore(add(scratchBuf1, shift), seedHash)
599 
600         // At this moment the canonical block hash is known.
601             blockHash := keccak256(scratchBuf1, blobLength)
602         }
603     }
604     // Memory copy.
605     function memcpy(uint dest, uint src, uint len) pure private {
606         // Full 32 byte words
607         for (; len >= 32; len -= 32) {
608             assembly {mstore(dest, mload(src))}
609             dest += 32;
610             src += 32;
611         }
612 
613         // Remaining bytes
614         uint mask = 256 ** (32 - len) - 1;
615         assembly {
616             let srcpart := and(mload(src), not(mask))
617             let destpart := and(mload(dest), mask)
618             mstore(dest, or(destpart, srcpart))
619         }
620     }
621 
622     function processVIPBenefit(address gambler, uint amount) internal returns (uint benefitAmount) {
623         uint totalAmount = accuBetAmount[gambler];
624         accuBetAmount[gambler] += amount;
625         benefitAmount = calcVIPBenefit(amount, totalAmount);
626     }
627 
628     function processJackpot(address gambler, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
629         if (isJackpot(entropy, amount)) {
630             benefitAmount = jackpotSize;
631             jackpotSize -= jackpotSize;
632             emit JackpotPayment(gambler, benefitAmount);
633         }
634     }
635 
636     function processRoulette(address gambler, uint betMask, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
637         uint houseEdge = calcHouseEdge(amount);
638         uint jackpotFee = calcJackpotFee(amount);
639         uint rankFundFee = calcRankFundsFee(houseEdge);
640         uint rate = getWinRate(betMask);
641         uint winAmount = (amount - houseEdge - jackpotFee) * BASE_WIN_RATE / rate;
642 
643         lockedInBets -= uint128(winAmount);
644         rankFunds += uint128(rankFundFee);
645         jackpotSize += uint128(jackpotFee);
646 
647         (bool isWin, uint l, uint r) = calcBetResult(betMask, entropy);
648         benefitAmount = isWin ? winAmount : 0;
649 
650         emit Payment(gambler, benefitAmount, uint8(betMask), uint8(l), uint8(r), amount);
651     }
652 
653     function processInviterBenefit(address gambler, uint amount) internal {
654         address payable inviter = inviterMap[gambler];
655         if (inviter != address(0)) {
656             uint houseEdge = calcHouseEdge(amount);
657             uint inviterBenefit = calcInviterBenefit(houseEdge);
658             inviter.transfer(inviterBenefit);
659             emit InviterBenefit(inviter, gambler, inviterBenefit, amount);
660         }
661     }
662 
663     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) internal {
664         uint amount = bet.amount;
665 
666         // Check that bet is in 'active' state.
667         require(amount != 0, "Bet should be in an 'active' state");
668         bet.amount = 0;
669 
670         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
671         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
672         // preimage is intractable), and house is unable to alter the "reveal" after
673         // placeBet have been mined (as Keccak256 collision finding is also intractable).
674         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
675 
676         uint payout = 0;
677         payout += processVIPBenefit(bet.gambler, amount);
678         payout += processJackpot(bet.gambler, entropy, amount);
679         payout += processRoulette(bet.gambler, bet.betMask, entropy, amount);
680 
681         processInviterBenefit(bet.gambler, amount);
682 
683         bet.gambler.transfer(payout);
684     }
685 
686     // Refund transaction - return the bet amount of a roll that was not processed in a due timeframe.
687     // Processing such blocks is not possible due to EVM limitations (see BET_EXPIRATION_BLOCKS comment above for details).
688     // In case you ever find yourself in a situation like this, just contact the {} support, however nothing precludes you from invoking this method yourself.
689     function refundBet(uint commit) external {
690         // Check that bet is in 'active' state.
691         Bet storage bet = bets[commit];
692         uint amount = bet.amount;
693 
694         require(amount != 0, "Bet should be in an 'active' state");
695 
696         // Check that bet has already expired.
697         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
698 
699         // Move bet into 'processed' state, release funds.
700         bet.amount = 0;
701 
702         uint winAmount = getWinAmount(bet.betMask, amount);
703         lockedInBets -= uint128(winAmount);
704 
705         revertLuckyCoin(bet.gambler);
706 
707         // Send the refund.
708         bet.gambler.transfer(amount);
709 
710         emit Refund(bet.gambler, amount);
711     }
712 
713     function useLuckyCoin(address payable gambler, uint reveal) external onlyCroupier {
714         LuckyCoin storage luckyCoin = luckyCoins[gambler];
715         require(luckyCoin.coin == true, "luckyCoin.coin == true");
716 
717         uint64 today = startOfDay(block.timestamp);
718         require(luckyCoin.timestamp == today, "luckyCoin.timestamp == today");
719         luckyCoin.coin = false;
720 
721         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(block.number)));
722 
723         luckyCoin.result = uint16((uint(entropy) % 10000) + 1);
724         uint benefit = calcLuckyCoinBenefit(luckyCoin.result);
725 
726         if (gambler.send(benefit)) {
727             emit LuckyCoinBenefit(gambler, benefit, luckyCoin.result);
728         }
729     }
730 
731     function payTodayReward(address payable gambler) external onlyCroupier {
732         uint64 today = startOfDay(block.timestamp);
733         if (dailyRankingPrize.timestamp != today) {
734             dailyRankingPrize.timestamp = today;
735             dailyRankingPrize.prizeSize = rankFunds;
736             dailyRankingPrize.cnt = 0;
737             rankFunds = 0;
738         }
739 
740         require(dailyRankingPrize.cnt < TODAY_RANKING_PRIZE_RATE.length, "cnt < length");
741 
742         uint prize = dailyRankingPrize.prizeSize * TODAY_RANKING_PRIZE_RATE[dailyRankingPrize.cnt] / TODAY_RANKING_PRIZE_MODULUS;
743 
744         dailyRankingPrize.cnt += 1;
745 
746         if (gambler.send(prize)) {
747             emit TodaysRankingPayment(gambler, prize);
748         }
749     }
750 
751     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
752     function increaseJackpot(uint increaseAmount) external onlyOwner {
753         require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
754         require(jackpotSize + lockedInBets + increaseAmount + dailyRankingPrize.prizeSize <= address(this).balance, "Not enough funds.");
755         jackpotSize += uint128(increaseAmount);
756     }
757 
758     // Funds withdrawal to cover costs of HalfRoulette operation.
759     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
760         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
761         require(jackpotSize + lockedInBets + withdrawAmount + rankFunds + dailyRankingPrize.prizeSize <= address(this).balance, "Not enough funds.");
762         beneficiary.transfer(withdrawAmount);
763     }
764 
765 }