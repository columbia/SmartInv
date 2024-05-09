1 /* ==================================================================== */
2 /* Copyright (c) 2018 The TokenTycoon Project.  All rights reserved.
3 /* 
4 /* https://tokentycoon.io
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.23;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     constructor() public {
19         addrAdmin = msg.sender;
20     }  
21 
22 
23     modifier onlyAdmin() {
24         require(msg.sender == addrAdmin);
25         _;
26     }
27 
28     modifier whenNotPaused() {
29         require(!isPaused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(isPaused);
35         _;
36     }
37 
38     function setAdmin(address _newAdmin) external onlyAdmin {
39         require(_newAdmin != address(0));
40         emit AdminTransferred(addrAdmin, _newAdmin);
41         addrAdmin = _newAdmin;
42     }
43 
44     function doPause() external onlyAdmin whenNotPaused {
45         isPaused = true;
46     }
47 
48     function doUnpause() external onlyAdmin whenPaused {
49         isPaused = false;
50     }
51 }
52 
53 contract AccessService is AccessAdmin {
54     address public addrService;
55     address public addrFinance;
56 
57     modifier onlyService() {
58         require(msg.sender == addrService);
59         _;
60     }
61 
62     modifier onlyFinance() {
63         require(msg.sender == addrFinance);
64         _;
65     }
66 
67     function setService(address _newService) external {
68         require(msg.sender == addrService || msg.sender == addrAdmin);
69         require(_newService != address(0));
70         addrService = _newService;
71     }
72 
73     function setFinance(address _newFinance) external {
74         require(msg.sender == addrFinance || msg.sender == addrAdmin);
75         require(_newFinance != address(0));
76         addrFinance = _newFinance;
77     }
78 
79     function withdraw(address _target, uint256 _amount) 
80         external 
81     {
82         require(msg.sender == addrFinance || msg.sender == addrAdmin);
83         require(_amount > 0);
84         address receiver = _target == address(0) ? addrFinance : _target;
85         uint256 balance = address(this).balance;
86         if (_amount < balance) {
87             receiver.transfer(_amount);
88         } else {
89             receiver.transfer(address(this).balance);
90         }      
91     }
92 }
93 
94 interface WonderTokenInterface {
95     function transferFrom(address _from, address _to, uint256 _tokenId) external;
96     function safeGiveByContract(uint256 _tokenId, address _to) external;
97     function getProtoIdByTokenId(uint256 _tokenId) external view returns(uint256); 
98 }
99 
100 interface ManagerTokenInterface {
101     function transferFrom(address _from, address _to, uint256 _tokenId) external;
102     function safeGiveByContract(uint256 _tokenId, address _to) external;
103     function getProtoIdByTokenId(uint256 _tokenId) external view returns(uint256);
104 }
105 
106 interface TalentCardInterface {
107     function safeSendCard(uint256 _amount, address _to) external;
108 }
109 
110 interface ERC20BaseInterface {
111     function balanceOf(address _from) external view returns(uint256);
112     function transfer(address _to, uint256 _value) external;
113     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
114     function approve(address _spender, uint256 _value) external; 
115 }
116 
117 contract TTCInterface is ERC20BaseInterface {
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
119 }
120 
121 /// This Random is inspired by https://github.com/axiomzen/eth-random
122 contract Random {
123     uint256 _seed;
124 
125     function _rand() internal returns (uint256) {
126         _seed = uint256(keccak256(abi.encodePacked(_seed, blockhash(block.number - 1), block.coinbase, block.difficulty)));
127         return _seed;
128     }
129 
130     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
131         return uint256(keccak256(abi.encodePacked(_outSeed, blockhash(block.number - 1), block.coinbase, block.difficulty)));
132     }
133 }
134 
135 
136 contract TTLottery is AccessService, Random {
137     TTCInterface ttcToken;
138     ManagerTokenInterface ttmToken;
139     WonderTokenInterface ttwToken;
140     TalentCardInterface tttcToken;
141 
142     event ManagerSold(
143         address indexed buyer,
144         address indexed buyTo,
145         uint256 mgrId,
146         uint256 nextTokenId
147     );
148 
149     event WonderSold(
150         address indexed buyer,
151         address indexed buyTo,
152         uint256 wonderId,
153         uint256 nextTokenId
154     );
155 
156     event LotteryResult(
157         address indexed buyer,
158         address indexed buyTo,
159         uint256 lotteryCount,
160         uint256 lotteryRet
161     );
162 
163     constructor() public {
164         addrAdmin = msg.sender;
165         addrFinance = msg.sender;
166         addrService = msg.sender;
167 
168         ttcToken = TTCInterface(0xfB673F08FC82807b4D0E139e794e3b328d63551f);
169     }
170 
171     function setTTMTokenAddress(address _addr) external onlyAdmin {
172         require(_addr != address(0));
173         ttmToken = ManagerTokenInterface(_addr);
174     }
175 
176     function setTTWTokenAddress(address _addr) external onlyAdmin {
177         require(_addr != address(0));
178         ttwToken = WonderTokenInterface(_addr);
179     }
180 
181     function setTTCTokenAddress(address _addr) external onlyAdmin {
182         require(_addr != address(0));
183         ttcToken = TTCInterface(_addr);
184     }
185 
186     function setTalentCardAddress(address _addr) external onlyAdmin {
187         require(_addr != address(0));
188         tttcToken = TalentCardInterface(_addr);
189     }
190     
191     mapping (address => uint64) public lotteryHistory; 
192 
193     uint64 public nextLotteryTTMTokenId4 = 211;         // ManagerId: 4, tokenId: 211~285, lotteryRet:4 
194     uint64 public nextLotteryTTMTokenId5 = 286;         // ManagerId: 5, tokenId: 286~360, lotteryRet:5
195     uint64 public nextLotteryTTMTokenId9 = 511;         // ManagerId: 9, tokenId: 511~560, lotteryRet:6
196     uint64 public nextLotteryTTMTokenId10 = 561;        // ManagerId:10, tokenId: 561~610, lotteryRet:7
197 
198     uint64 public nextLotteryTTWTokenId3 = 91;          // WonderId:  3, tokenId:  91~150, lotteryRet:8
199     uint64 public nextLotteryTTWTokenId4 = 151;         // WonderId:  4, tokenId: 151~180, lotteryRet:9
200 
201     function setNextLotteryTTMTokenId4(uint64 _val) external onlyAdmin {
202         require(nextLotteryTTMTokenId4 >= 211 && nextLotteryTTMTokenId4 <= 286);
203         nextLotteryTTMTokenId4 = _val;
204     }
205 
206     function setNextLotteryTTMTokenId5(uint64 _val) external onlyAdmin {
207         require(nextLotteryTTMTokenId5 >= 286 && nextLotteryTTMTokenId5 <= 361);
208         nextLotteryTTMTokenId5 = _val;
209     }
210 
211     function setNextLotteryTTMTokenId9(uint64 _val) external onlyAdmin {
212         require(nextLotteryTTMTokenId9 >= 511 && nextLotteryTTMTokenId9 <= 561);
213         nextLotteryTTMTokenId9 = _val;
214     }
215 
216     function setNextLotteryTTMTokenId10(uint64 _val) external onlyAdmin {
217         require(nextLotteryTTMTokenId10 >= 561 && nextLotteryTTMTokenId10 <= 611);
218         nextLotteryTTMTokenId10 = _val;
219     }
220 
221     function setNextLotteryTTWTokenId3(uint64 _val) external onlyAdmin {
222         require(nextLotteryTTWTokenId3 >= 91 && nextLotteryTTWTokenId3 <= 151);
223         nextLotteryTTWTokenId3 = _val;
224     }
225 
226     function setNextLotteryTTWTokenId4(uint64 _val) external onlyAdmin {
227         require(nextLotteryTTWTokenId4 >= 151 && nextLotteryTTWTokenId4 <= 181);
228         nextLotteryTTWTokenId4 = _val;
229     }
230 
231     function _getExtraParam(bytes _extraData) 
232         private 
233         pure
234         returns(address addr, uint256 lotteryCount) 
235     {
236         assembly { addr := mload(add(_extraData, 20)) } 
237         lotteryCount = uint256(_extraData[20]);
238     }
239 
240     function receiveApproval(address _sender, uint256 _value, address _token, bytes _extraData) 
241         external
242         whenNotPaused 
243     {
244         require(msg.sender == address(ttcToken));
245         require(_extraData.length == 21);
246         (address toAddr, uint256 lotteryCount) = _getExtraParam(_extraData);
247         require(ttcToken.transferFrom(_sender, address(this), _value));
248         if (lotteryCount == 1) {
249             _lottery(_value, toAddr, _sender);
250         } else if(lotteryCount == 5) {
251             _lottery5(_value, toAddr, _sender);
252         } else {
253             require(false, "Invalid lottery count");
254         }
255     }
256 
257     function lotteryByETH(address _gameWalletAddr) 
258         external 
259         payable
260         whenNotPaused 
261     {
262         _lottery(msg.value, _gameWalletAddr, msg.sender);
263     }
264 
265     function lotteryByETH5(address _gameWalletAddr) 
266         external 
267         payable
268         whenNotPaused 
269     {
270         _lottery5(msg.value, _gameWalletAddr, msg.sender);
271     }
272 
273     function _lotteryCard(uint256 _seed, address _gameWalletAddr) 
274         private 
275         returns(uint256 lotteryRet)
276     {
277         uint256 rdm = _seed % 10000;
278         if (rdm < 6081) {
279             tttcToken.safeSendCard(1, _gameWalletAddr);
280             lotteryRet = 1;
281         } else if (rdm < 8108) {
282             tttcToken.safeSendCard(3, _gameWalletAddr);
283             lotteryRet = 2;
284         } else if (rdm < 9324) {
285             tttcToken.safeSendCard(5, _gameWalletAddr);
286             lotteryRet = 3;
287         } else {
288             tttcToken.safeSendCard(10, _gameWalletAddr);
289             lotteryRet = 4;
290         }
291     }
292 
293     function _lotteryCardNoSend(uint256 _seed)
294         private
295         pure 
296         returns(uint256 lotteryRet, uint256 cardCnt) 
297     {
298         uint256 rdm = _seed % 10000;
299         if (rdm < 6081) {
300             cardCnt = 1;
301             lotteryRet = 1;
302         } else if (rdm < 8108) {
303             cardCnt = 3;
304             lotteryRet = 2;
305         } else if (rdm < 9324) {
306             cardCnt = 5;
307             lotteryRet = 3;
308         } else {
309             cardCnt = 10;
310             lotteryRet = 4;
311         }
312     }
313 
314     function _lotteryToken(uint256 _seed, address _gameWalletAddr, address _buyer) 
315         private 
316         returns(uint256 lotteryRet) 
317     {
318         uint256[6] memory weightArray;
319         uint256 totalWeight = 0;
320         if (nextLotteryTTMTokenId4 <= 285) {
321             totalWeight += 2020;
322             weightArray[0] = totalWeight;
323         }
324         if (nextLotteryTTMTokenId5 <= 360) {
325             totalWeight += 2020;
326             weightArray[1] = totalWeight;
327         }
328         if (nextLotteryTTMTokenId9 <= 560) {
329             totalWeight += 1340;
330             weightArray[2] = totalWeight;
331         }
332         if (nextLotteryTTMTokenId10 <= 610) {
333             totalWeight += 1340;
334             weightArray[3] = totalWeight;
335         }
336         if (nextLotteryTTWTokenId3 <= 150) {
337             totalWeight += 2220;
338             weightArray[4] = totalWeight;
339         }
340         if (nextLotteryTTWTokenId4 <= 180) {
341             totalWeight += 1000;
342             weightArray[5] = totalWeight;
343         }
344 
345         if (totalWeight > 0) {
346             uint256 rdm = _seed % totalWeight;
347             for (uint32 i = 0; i < 6; ++i) {
348                 if (weightArray[i] == 0 || rdm >= weightArray[i]) {
349                     continue;
350                 }
351                 if (i == 0) {
352                     nextLotteryTTMTokenId4 += 1;
353                     ttmToken.safeGiveByContract(nextLotteryTTMTokenId4 - 1, _gameWalletAddr);
354                     emit ManagerSold(_buyer, _gameWalletAddr, 4, nextLotteryTTMTokenId4);
355                 } else if (i == 1) {
356                     nextLotteryTTMTokenId5 += 1;
357                     ttmToken.safeGiveByContract(nextLotteryTTMTokenId5 - 1, _gameWalletAddr);
358                     emit ManagerSold(_buyer, _gameWalletAddr, 5, nextLotteryTTMTokenId5);
359                 } else if (i == 2) {
360                     nextLotteryTTMTokenId9 += 1;
361                     ttmToken.safeGiveByContract(nextLotteryTTMTokenId9 - 1, _gameWalletAddr);
362                     emit ManagerSold(_buyer, _gameWalletAddr, 9, nextLotteryTTMTokenId9);
363                 } else if (i == 3) {
364                     nextLotteryTTMTokenId10 += 1;
365                     ttmToken.safeGiveByContract(nextLotteryTTMTokenId10 - 1, _gameWalletAddr);
366                     emit ManagerSold(_buyer, _gameWalletAddr, 10, nextLotteryTTMTokenId10);
367                 } else if (i == 4) {
368                     nextLotteryTTWTokenId3 += 1;
369                     ttwToken.safeGiveByContract(nextLotteryTTWTokenId3 - 1, _gameWalletAddr);
370                     emit WonderSold(_buyer, _gameWalletAddr, 3, nextLotteryTTWTokenId3);
371                 } else {
372                     nextLotteryTTWTokenId4 += 1;
373                     ttwToken.safeGiveByContract(nextLotteryTTWTokenId4 - 1, _gameWalletAddr);
374                     emit WonderSold(_buyer, _gameWalletAddr, 4, nextLotteryTTWTokenId4);
375                 }
376                 lotteryRet = i + 5;
377                 break;
378             } 
379         }
380     }
381 
382     function _lottery(uint256 _value, address _gameWalletAddr, address _buyer) 
383         private 
384     {
385         require(_value == 0.039 ether);
386         require(_gameWalletAddr != address(0));
387 
388         uint256 lotteryRet;
389         uint256 seed = _rand();
390         uint256 rdm = seed % 10000;
391         seed /= 10000;
392         if (rdm < 400) {
393             lotteryRet = _lotteryToken(seed, _gameWalletAddr, _buyer);
394             if (lotteryRet == 0) {
395                 lotteryRet = _lotteryCard(seed, _gameWalletAddr);
396             }
397         } else {
398             lotteryRet = _lotteryCard(seed, _gameWalletAddr);
399         }
400         lotteryHistory[_gameWalletAddr] = uint64(lotteryRet);
401         emit LotteryResult(_buyer, _gameWalletAddr, 1, lotteryRet);
402     }
403 
404     function _lottery5(uint256 _value, address _gameWalletAddr, address _buyer) 
405         private 
406     {
407         require(_value == 0.1755 ether);
408         require(_gameWalletAddr != address(0));
409 
410         uint256 seed = _rand();
411         uint256 lotteryRet = 0;
412         uint256 lRet;
413         uint256 cardCountTotal = 0;
414         uint256 cardCount;
415         for (uint256 i = 0; i < 5; ++i) {
416             if (i > 0) {
417                 seed = _randBySeed(seed);
418             }
419             uint256 rdm = seed % 10000;
420             seed /= 10000;
421             if (rdm < 400) {
422                 lRet = _lotteryToken(seed, _gameWalletAddr, _buyer);
423                 if (lRet == 0) {
424                     (lRet, cardCount) = _lotteryCardNoSend(seed);
425                     cardCountTotal += cardCount;
426                 }
427                 lotteryRet += (lRet * (100 ** i));
428             } else {
429                 (lRet, cardCount) = _lotteryCardNoSend(seed);
430                 cardCountTotal += cardCount;
431                 lotteryRet += (lRet * (100 ** i));
432             }
433         }
434 
435         require(cardCountTotal <= 50);
436 
437         if (cardCountTotal > 0) {
438             tttcToken.safeSendCard(cardCountTotal, _gameWalletAddr);
439         }
440         lotteryHistory[_gameWalletAddr] = uint64(lotteryRet);
441 
442         emit LotteryResult(_buyer, _gameWalletAddr, 5, lotteryRet);
443     }
444 
445     function withdrawERC20(address _erc20, address _target, uint256 _amount)
446         external
447     {
448         require(msg.sender == addrFinance || msg.sender == addrAdmin);
449         require(_amount > 0);
450         address receiver = _target == address(0) ? addrFinance : _target;
451         ERC20BaseInterface erc20Contract = ERC20BaseInterface(_erc20);
452         uint256 balance = erc20Contract.balanceOf(address(this));
453         require(balance > 0);
454         if (_amount < balance) {
455             erc20Contract.transfer(receiver, _amount);
456         } else {
457             erc20Contract.transfer(receiver, balance);
458         }   
459     }
460 
461     function getLotteryInfo(address _walletAddr)
462         external
463         view 
464         returns(
465            uint64 ttmCnt4,
466            uint64 ttmCnt5,
467            uint64 ttmCnt9,
468            uint64 ttmCnt10,
469            uint64 ttWCnt3,
470            uint64 ttwCnt4, 
471            uint64 lastLottery
472         )
473     {
474         ttmCnt4 = 286 - nextLotteryTTMTokenId4;
475         ttmCnt5 = 361 - nextLotteryTTMTokenId5;
476         ttmCnt9 = 561 - nextLotteryTTMTokenId9;
477         ttmCnt10 = 611 - nextLotteryTTMTokenId10;
478         ttWCnt3 = 151 - nextLotteryTTWTokenId3;
479         ttwCnt4 = 181 - nextLotteryTTWTokenId4;
480         lastLottery = lotteryHistory[_walletAddr];
481     }
482 }