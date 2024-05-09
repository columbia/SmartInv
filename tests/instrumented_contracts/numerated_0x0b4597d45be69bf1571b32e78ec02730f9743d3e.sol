1 pragma solidity ^0.4.16;
2 
3 // Use the dAppBridge service to generate random numbers
4 // Powerful Data Oracle Service with easy to use methods, see: https://dAppBridge.com
5 //
6 interface dAppBridge_I {
7     function getOwner() external returns(address);
8     function getMinReward(string requestType) external returns(uint256);
9     function getMinGas() external returns(uint256);    
10     // Only import the functions we use...
11     function callURL(string callback_method, string external_url, string external_params, string json_extract_element) external payable returns(bytes32);
12 }
13 contract DappBridgeLocator_I {
14     function currentLocation() public returns(address);
15 }
16 
17 contract clientOfdAppBridge {
18     address internal _dAppBridgeLocator_Prod_addr = 0x5b63e582645227F1773bcFaE790Ea603dB948c6A;
19     
20     DappBridgeLocator_I internal dAppBridgeLocator;
21     dAppBridge_I internal dAppBridge; 
22     uint256 internal current_gas = 0;
23     uint256 internal user_callback_gas = 0;
24     
25     function initBridge() internal {
26         //} != _dAppBridgeLocator_addr){
27         if(address(dAppBridgeLocator) != _dAppBridgeLocator_Prod_addr){ 
28             dAppBridgeLocator = DappBridgeLocator_I(_dAppBridgeLocator_Prod_addr);
29         }
30         
31         if(address(dAppBridge) != dAppBridgeLocator.currentLocation()){
32             dAppBridge = dAppBridge_I(dAppBridgeLocator.currentLocation());
33         }
34         if(current_gas == 0) {
35             current_gas = dAppBridge.getMinGas();
36         }
37     }
38 
39     modifier dAppBridgeClient {
40         initBridge();
41 
42         _;
43     }
44     
45 
46     event event_senderAddress(
47         address senderAddress
48     );
49     
50     event evnt_dAdppBridge_location(
51         address theLocation
52     );
53     
54     event only_dAppBridgeCheck(
55         address senderAddress,
56         address checkAddress
57     );
58     
59     modifier only_dAppBridge_ {
60         initBridge();
61         
62         //emit event_senderAddress(msg.sender);
63         //emit evnt_dAdppBridge_location(address(dAppBridge));
64         emit only_dAppBridgeCheck(msg.sender, address(dAppBridge));
65         require(msg.sender == address(dAppBridge));
66         _;
67     }
68 
69     // Ensures that only the dAppBridge system can call the function
70     modifier only_dAppBridge {
71         initBridge();
72         address _dAppBridgeOwner = dAppBridge.getOwner();
73         require(msg.sender == _dAppBridgeOwner);
74 
75         _;
76     }
77     
78 
79     
80     function setGas(uint256 new_gas) internal {
81         require(new_gas > 0);
82         current_gas = new_gas;
83     }
84 
85     function setCallbackGas(uint256 new_callback_gas) internal {
86         require(new_callback_gas > 0);
87         user_callback_gas = new_callback_gas;
88     }
89 
90     
91 
92     function callURL(string callback_method, string external_url, string external_params) internal dAppBridgeClient returns(bytes32) {
93         uint256 _reward = dAppBridge.getMinReward('callURL')+user_callback_gas;
94         return dAppBridge.callURL.value(_reward).gas(current_gas)(callback_method, external_url, external_params, "");
95     }
96     function callURL(string callback_method, string external_url, string external_params, string json_extract_elemen) internal dAppBridgeClient returns(bytes32) {
97         uint256 _reward = dAppBridge.getMinReward('callURL')+user_callback_gas;
98         return dAppBridge.callURL.value(_reward).gas(current_gas)(callback_method, external_url, external_params, json_extract_elemen);
99     }
100 
101 
102     // Helper internal functions
103     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
104         bytes memory tempEmptyStringTest = bytes(source);
105         if (tempEmptyStringTest.length == 0) {
106             return 0x0;
107         }
108 
109         assembly {
110             result := mload(add(source, 32))
111         }
112     }
113 
114     function char(byte b) internal pure returns (byte c) {
115         if (b < 10) return byte(uint8(b) + 0x30);
116         else return byte(uint8(b) + 0x57);
117     }
118     
119     function bytes32string(bytes32 b32) internal pure returns (string out) {
120         bytes memory s = new bytes(64);
121         for (uint8 i = 0; i < 32; i++) {
122             byte b = byte(b32[i]);
123             byte hi = byte(uint8(b) / 16);
124             byte lo = byte(uint8(b) - 16 * uint8(hi));
125             s[i*2] = char(hi);
126             s[i*2+1] = char(lo);            
127         }
128         out = string(s);
129     }
130 
131     function compareStrings (string a, string b) internal pure returns (bool){
132         return keccak256(a) == keccak256(b);
133     }
134     
135     function concatStrings(string _a, string _b) internal pure returns (string){
136         bytes memory bytes_a = bytes(_a);
137         bytes memory bytes_b = bytes(_b);
138         string memory length_ab = new string(bytes_a.length + bytes_b.length);
139         bytes memory bytes_c = bytes(length_ab);
140         uint k = 0;
141         for (uint i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
142         for (i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
143         return string(bytes_c);
144     }
145 }
146 
147 // SafeMath to protect overflows
148 library SafeMath {
149   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150     uint256 c = a * b;
151     assert(a == 0 || c / a == b);
152     return c;
153   }
154  
155   function div(uint256 a, uint256 b) internal pure returns (uint256) {
156     // assert(b > 0); // Solidity automatically throws when dividing by 0
157     uint256 c = a / b;
158     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159     return c;
160   }
161  
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     assert(b <= a);
164     return a - b;
165   }
166  
167   function add(uint256 a, uint256 b) internal pure returns (uint256) {
168     uint256 c = a + b;
169     assert(c >= a);
170     return c;
171   }
172 }
173 
174 //
175 //
176 // Main DiceRoll.app contract
177 //
178 //
179 
180 contract DiceRoll is clientOfdAppBridge {
181     
182     using SafeMath for uint256;
183 
184     
185     string public randomAPI_url;
186     string internal randomAPI_key;
187     string internal randomAPI_extract;
188     
189     struct playerDiceRoll {
190         bytes32     betID;
191         address     playerAddr;
192         uint256     rollUnder;
193         uint256     stake;
194         uint256     profit;
195         uint256     win;
196         bool        paid;
197         uint256     result;
198         uint256     timestamp;
199     }
200     
201 
202     mapping (bytes32 => playerDiceRoll) public playerRolls;
203     mapping (address => uint256) playerPendingWithdrawals;
204 
205     address public owner;
206     uint256 public contractBalance;
207     bool public game_paused;
208     uint256 minRoll;
209     uint256 maxRoll;
210     uint256 minBet;
211     uint256 maxBet;
212     uint256 public minRollUnder;
213     uint256 public houseEdge; // 98 = 2%
214     uint256 public totalUserProfit;
215     uint256 public totalWins; 
216     uint256 public totalLosses;
217     uint256 public totalWinAmount;
218     uint256 public totalLossAmount;
219     uint256 public totalFails;
220     uint256 internal totalProfit;
221     uint256 public maxMultiRolls;
222     uint256 public gameNumber;
223     
224     uint256 public oracleFee;
225     
226     
227     mapping(uint256 => bool) public permittedRolls;
228     
229     uint public maxPendingPayouts; // Max potential payments
230 
231     function private_getGameState() public view returns(uint256 _contractBalance,
232         bool _game_paused,
233         uint256 _minRoll,
234         uint256 _maxRoll,
235         uint256 _minBet,
236         uint256 _maxBet,
237         uint256 _houseEdge,
238         uint256 _totalUserProfit,
239         uint256 _totalWins,
240         uint256 _totalLosses,
241         uint256 _totalWinAmount,
242         uint256 _totalLossAmount,
243         uint256 _liveMaxBet,
244         uint256 _totalFails) {
245         _contractBalance = contractBalance;
246         _game_paused = game_paused;
247         _minRoll = minRoll;
248         _maxRoll = maxRoll;
249         _minBet = minBet;
250         _maxBet = maxBet;
251         _houseEdge = houseEdge;
252         _totalUserProfit = totalUserProfit;
253         _totalWins = totalWins;
254         _totalLosses = totalLosses;
255         _totalWinAmount = totalWinAmount;
256         _totalLossAmount = totalLossAmount;
257         _liveMaxBet = getLiveMaxBet();
258         _totalFails = totalFails;
259     
260     }
261     modifier onlyOwner() {
262         require (msg.sender == owner);
263         _;
264     }
265     modifier gameActive() {
266         require (game_paused == false);
267         _;
268     }
269     modifier validBet(uint256 betSize, uint256 rollUnder) {
270         require(rollUnder > minRoll);
271         require(rollUnder < maxRoll);
272         require(betSize <= maxBet);
273         require(betSize >= minBet);
274         require(permittedRolls[rollUnder] == true);
275         
276         uint256 potential_profit = (msg.value * (houseEdge / rollUnder)) - msg.value;
277         require(maxPendingPayouts.add(potential_profit) <= address(this).balance);
278         
279         _;
280     }
281     
282     modifier validBetMulti(uint256 betSize, uint256 rollUnder, uint256 number_of_rolls) {
283         require(rollUnder > minRoll);
284         require(rollUnder < maxRoll);
285         require(betSize <= maxBet);
286         require(betSize >= minBet);
287         require(number_of_rolls <= maxMultiRolls);
288         require(permittedRolls[rollUnder] == true);
289         
290         uint256 potential_profit = (msg.value * (houseEdge / rollUnder)) - msg.value;
291         require(maxPendingPayouts.add(potential_profit) <= address(this).balance);
292         
293         _;
294     }
295 
296 
297 
298     function getLiveMaxBet() public view returns(uint256) {
299         uint256 currentAvailBankRoll = address(this).balance.sub(maxPendingPayouts);
300         uint256 divisor = houseEdge.div(minRollUnder); // will be 4
301         uint256 liveMaxBet = currentAvailBankRoll.div(divisor); // 0.627852
302         if(liveMaxBet > maxBet)
303             liveMaxBet = maxBet;
304         return liveMaxBet;
305     }
306 
307     function getBet(bytes32 _betID) public view returns(bytes32 betID,
308         address     playerAddr,
309         uint256     rollUnder,
310         uint256     stake,
311         uint256     profit,
312         uint256     win,
313         bool        paid,
314         uint256     result,
315         uint256     timestamp){
316         playerDiceRoll memory _playerDiceRoll = playerRolls[_betID];
317         betID = _betID;
318         playerAddr = _playerDiceRoll.playerAddr;
319         rollUnder = _playerDiceRoll.rollUnder;
320         stake = _playerDiceRoll.stake;
321         profit = _playerDiceRoll.profit;
322         win = _playerDiceRoll.win;
323         paid = _playerDiceRoll.paid;
324         result = _playerDiceRoll.result;
325         timestamp = _playerDiceRoll.timestamp;
326         
327     }
328 
329     function getOwner() external view returns(address){
330         return owner;
331     }
332 
333     function getBalance() external view returns(uint256){
334         address myAddress = this;
335         return myAddress.balance;
336     }
337     
338     constructor() public payable {
339         owner = msg.sender;
340         houseEdge = 96; // 4% commission to us on wins
341         contractBalance = msg.value;
342         totalUserProfit = 0;
343         totalWins = 0;
344         totalLosses = 0;
345         minRoll = 1;
346         maxRoll = 100;
347         minBet = 15000000000000000; //200000000000000;
348         maxBet = 300000000000000000; //200000000000000000;
349         randomAPI_url = "https://api.random.org/json-rpc/1/invoke";
350         randomAPI_key = "7d4ab655-e778-4d9f-815a-98fd518908bd";
351         randomAPI_extract = "result.random.data";
352         //permittedRolls[10] = true;
353         permittedRolls[20] = true;
354         permittedRolls[30] = true;
355         permittedRolls[40] = true;
356         permittedRolls[50] = true;
357         permittedRolls[60] = true;
358         //permittedRolls[70] = true;
359         minRollUnder = 20;
360         totalProfit = 0;
361         totalWinAmount = 0;
362         totalLossAmount = 0;
363         totalFails = 0;
364         maxMultiRolls = 5;
365         gameNumber = 0;
366         oracleFee = 80000000000000; 
367     }
368     
369     event DiceRollResult_failedSend(
370             bytes32 indexed betID,
371             address indexed playerAddress,
372             uint256 rollUnder,
373             uint256 result,
374             uint256 amountToSend
375         );
376         
377 
378     // totalUserProfit : Includes the original stake
379     // totalWinAmount : Is just the win amount (Does not include orig stake)
380     event DiceRollResult(
381             bytes32 indexed betID, 
382             address indexed playerAddress, 
383             uint256 rollUnder, 
384             uint256 result,
385             uint256 stake,
386             uint256 profit,
387             uint256 win,
388             bool paid,
389             uint256 timestamp);
390     
391     // This is called from dAppBridge.com with the random number with secure proof
392     function callback(bytes32 key, string callbackData) external payable only_dAppBridge {
393         require(playerRolls[key].playerAddr != address(0x0));
394         require(playerRolls[key].win == 2); // we've already process it if so!
395 
396         playerRolls[key].result = parseInt(callbackData);
397         
398         uint256 _totalWin = playerRolls[key].stake.add(playerRolls[key].profit); // total we send back to playerRolls
399         
400         
401         if(maxPendingPayouts < playerRolls[key].profit){
402             //force refund as game failed...
403             playerRolls[key].result == 0;
404             
405         } else {
406             maxPendingPayouts = maxPendingPayouts.sub(playerRolls[key].profit); // take it out of the pending payouts now
407         }
408         
409         
410         
411         if(playerRolls[key].result == 0){
412 
413             totalFails = totalFails.add(1);
414 
415 
416             if(!playerRolls[key].playerAddr.send(playerRolls[key].stake)){
417                 //playerRolls[key].paid = false;
418                 
419                 
420                 
421                 emit DiceRollResult(key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result,
422                     playerRolls[key].stake, 0, 0, false, now);
423                 
424                 emit DiceRollResult_failedSend(
425                     key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result, playerRolls[key].stake );
426                     
427                playerPendingWithdrawals[playerRolls[key].playerAddr] = playerPendingWithdrawals[playerRolls[key].playerAddr].add(playerRolls[key].stake);
428                
429                delete playerRolls[key];
430             } else {
431                 
432                 emit DiceRollResult(key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result,
433                     playerRolls[key].stake, 0, 0, true, now);
434                 
435                 delete playerRolls[key];
436             }
437 
438             return;
439             
440         } else {
441         
442             if(playerRolls[key].result < playerRolls[key].rollUnder) {
443 
444                 contractBalance = contractBalance.sub(playerRolls[key].profit.add(oracleFee)); // how much we have won/lost
445                 totalUserProfit = totalUserProfit.add(_totalWin); // game stats
446                 totalWins = totalWins.add(1);
447                 totalWinAmount = totalWinAmount.add(playerRolls[key].profit);
448                 
449 
450         
451                 uint256 _player_profit_1percent = playerRolls[key].profit.div(houseEdge);
452                 uint256 _our_cut = _player_profit_1percent.mul(100-houseEdge); // we get 4%
453                 totalProfit = totalProfit.add(_our_cut); // Only add when its a win!
454 
455                 if(!playerRolls[key].playerAddr.send(_totalWin)){
456                     // failed to send - need to retry so add to playerPendingWithdrawals
457                     
458                     emit DiceRollResult(key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result,
459                         playerRolls[key].stake, playerRolls[key].profit, 1, false, now);
460                     
461                     emit DiceRollResult_failedSend(
462                         key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result, _totalWin );
463     
464                     playerPendingWithdrawals[playerRolls[key].playerAddr] = playerPendingWithdrawals[playerRolls[key].playerAddr].add(_totalWin);
465                     
466                     delete playerRolls[key];
467                     
468                 } else {
469                     
470                     emit DiceRollResult(key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result,
471                         playerRolls[key].stake, playerRolls[key].profit, 1, true, now);
472                         
473                     delete playerRolls[key];
474                         
475                 }
476                 
477                 return;
478                 
479             } else {
480                 //playerRolls[key].win=0;
481                 totalLosses = totalLosses.add(1);
482                 totalLossAmount = totalLossAmount.add(playerRolls[key].stake);
483                 contractBalance = contractBalance.add(playerRolls[key].stake.sub(oracleFee)); // how much we have won
484                 
485                 emit DiceRollResult(key, playerRolls[key].playerAddr, playerRolls[key].rollUnder, playerRolls[key].result,
486                     playerRolls[key].stake, playerRolls[key].profit, 0, true, now);
487                 delete playerRolls[key];
488 
489     
490                 return;
491             }
492         }
493 
494         
495 
496     }
497     
498     
499     function rollDice(uint rollUnder) public payable gameActive validBet(msg.value, rollUnder) returns (bytes32) {
500 
501         // This is the actual call to dAppBridge - using their callURL function to easily access an external API
502         // such as random.org        
503         bytes32 betID = callURL("callback", randomAPI_url, 
504         constructAPIParam(), 
505         randomAPI_extract);
506 
507         gameNumber = gameNumber.add(1);
508 
509         
510         uint256 _fullTotal = (msg.value * getBetDivisor(rollUnder)   ); // 0.0002 * 250 = 0.0005
511         _fullTotal = _fullTotal.div(100);
512         _fullTotal = _fullTotal.sub(msg.value);
513         
514         uint256 _fullTotal_1percent = _fullTotal.div(100); // e.g = 1
515         
516         uint256 _player_profit = _fullTotal_1percent.mul(houseEdge); // player gets 96%
517         
518         
519         playerRolls[betID] = playerDiceRoll(betID, msg.sender, rollUnder, msg.value, _player_profit, 2, false, 0, now);
520 
521         maxPendingPayouts = maxPendingPayouts.add(_player_profit); // don't add it to contractBalance yet until its a loss
522 
523         emit DiceRollResult(betID, msg.sender, rollUnder, 0,
524             msg.value, _player_profit, 2, false, now);
525             
526         return betID;
527     }
528     
529     function rollDice(uint rollUnder, uint number_of_rolls) public payable gameActive validBetMulti(msg.value, rollUnder, number_of_rolls) returns (bytes32) {
530 
531         uint c = 0;
532         for(c; c< number_of_rolls; c++) {
533             rollDice(rollUnder);
534         }
535 
536     }
537     
538     function getBetDivisor(uint256 rollUnder) public pure returns (uint256) {
539         if(rollUnder==5)
540             return 20 * 100;
541         if(rollUnder==10)
542             return 10 * 100;
543         if(rollUnder==20)
544             return 5 * 100;
545         if(rollUnder==30)
546             return 3.3 * 100;
547         if(rollUnder==40)
548             return 2.5 * 100;
549         if(rollUnder==50)
550             return 2 * 100;
551         if(rollUnder==60)
552             return 1.66 * 100;
553         if(rollUnder==70)
554             return 1.42 * 100;
555         if(rollUnder==80)
556             return 1.25 * 100;
557         if(rollUnder==90)
558             return 1.11 * 100;
559         
560         return (100/rollUnder) * 10;
561     }
562     
563     function constructAPIParam() internal view returns(string){
564         return strConcat(
565             strConcat("{\"jsonrpc\":\"2.0\",\"method\":\"generateIntegers\",\"params\":{\"apiKey\":\"",
566         randomAPI_key, "\",\"n\":1,\"min\":", uint2str(minRoll), ",\"max\":", uint2str(maxRoll), ",\"replacement\":true,\"base\":10},\"id\":"),
567         uint2str(gameNumber), "}" 
568         ); // Add in gameNumber to the params to avoid clashes
569     }
570     
571     // need to process any playerPendingWithdrawals
572     
573     // Allow a user to withdraw any pending amount (That may of failed previously)
574     function player_withdrawPendingTransactions() public
575         returns (bool)
576      {
577         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
578         playerPendingWithdrawals[msg.sender] = 0;
579 
580         if (msg.sender.call.value(withdrawAmount)()) {
581             return true;
582         } else {
583             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
584             /* player can try to withdraw again later */
585             playerPendingWithdrawals[msg.sender] = withdrawAmount;
586             return false;
587         }
588     }
589 
590     // shows if a player has any pending withdrawels due (returns the amount)
591     function player_getPendingTxByAddress(address addressToCheck) public constant returns (uint256) {
592         return playerPendingWithdrawals[addressToCheck];
593     }
594 
595     
596     // need to auto calc max bet
597     
598 
599     // private functions
600     function private_addPermittedRoll(uint256 _rollUnder) public onlyOwner {
601         permittedRolls[_rollUnder] = true;
602     }
603     function private_delPermittedRoll(uint256 _rollUnder) public onlyOwner {
604         delete permittedRolls[_rollUnder];
605     }
606     function private_setRandomAPIURL(string newRandomAPI_url) public onlyOwner {
607         randomAPI_url = newRandomAPI_url;
608     }
609     function private_setRandomAPIKey(string newRandomAPI_key) public onlyOwner {
610         randomAPI_key = newRandomAPI_key;
611     }
612     function private_setRandomAPI_extract(string newRandomAPI_extract) public onlyOwner {
613         randomAPI_extract = newRandomAPI_extract;
614     }
615     function private_setminRoll(uint256 newMinRoll) public onlyOwner {
616         require(newMinRoll>0);
617         require(newMinRoll<maxRoll);
618         minRoll = newMinRoll;
619     }
620     function private_setmaxRoll(uint256 newMaxRoll) public onlyOwner {
621         require(newMaxRoll>0);
622         require(newMaxRoll>minRoll);
623         maxRoll = newMaxRoll;
624     }
625     function private_setminBet(uint256 newMinBet) public onlyOwner {
626         require(newMinBet > 0);
627         require(newMinBet < maxBet);
628         minBet = newMinBet;
629     }
630     function private_setmaxBet(uint256 newMaxBet) public onlyOwner {
631         require(newMaxBet > 0);
632         require(newMaxBet > minBet);
633         maxBet = newMaxBet;
634     }
635     function private_setPauseState(bool newState) public onlyOwner {
636         game_paused = newState;
637     }
638     function private_setHouseEdge(uint256 newHouseEdge) public onlyOwner {
639         houseEdge = newHouseEdge;
640     }
641     function private_kill() public onlyOwner {
642         selfdestruct(owner);
643     }
644     function private_withdrawAll(address send_to) external onlyOwner returns(bool) {
645         address myAddress = this;
646         return send_to.send(myAddress.balance);
647     }
648     function private_withdraw(uint256 amount, address send_to) external onlyOwner returns(bool) {
649         address myAddress = this;
650         require(amount <= myAddress.balance);
651         require(amount >0);
652         return send_to.send(amount);
653     }
654     // show how much profit has been made (houseEdge)
655     function private_profits() public view onlyOwner returns(uint256) {
656         return totalProfit;
657     }
658     function private_setMinRollUnder(uint256 _minRollUnder) public onlyOwner {
659         minRollUnder = _minRollUnder;
660     }
661     function private_setMaxMultiRolls(uint256 _maxMultiRolls) public onlyOwner {
662         maxMultiRolls = _maxMultiRolls;
663     }
664     function private_setOracleFee(uint256 _oracleFee) public onlyOwner {
665         oracleFee = _oracleFee;
666     }
667     function deposit() public payable onlyOwner {
668         contractBalance = contractBalance.add(msg.value);
669     }
670     // end private functions
671 
672 
673     // Internal functions
674     function parseInt(string _a) internal pure returns (uint256) {
675         return parseInt(_a, 0);
676     }
677     function parseInt(string _a, uint _b) internal pure returns (uint256) {
678         bytes memory bresult = bytes(_a);
679         uint256 mint = 0;
680         bool decimals = false;
681         for (uint256 i=0; i<bresult.length; i++){
682             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
683                 if (decimals){
684                     if (_b == 0) break;
685                     else _b--;
686                 }
687                 mint *= 10;
688                 mint += uint256(bresult[i]) - 48;
689             } else if (bresult[i] == 46) decimals = true;
690         }
691         if (_b > 0) mint *= 10**_b;
692         return mint;
693     }
694     
695     function strConcat(string _a, string _b, string _c, string _d, string _e, string _f, string _g) internal pure returns (string) {
696         string memory abcdef = strConcat(_a,_b,_c,_d,_e,_f);
697         return strConcat(abcdef, _g);
698     }
699     function strConcat(string _a, string _b, string _c, string _d, string _e, string _f) internal pure returns (string) {
700         bytes memory _ba = bytes(_a);
701         bytes memory _bb = bytes(_b);
702         bytes memory _bc = bytes(_c);
703 
704         string memory abc = new string(_ba.length + _bb.length + _bc.length);
705         bytes memory babc = bytes(abc);
706         uint256 k = 0;
707         for (uint256 i = 0; i < _ba.length; i++) babc[k++] = _ba[i];
708         for (i = 0; i < _bb.length; i++) babc[k++] = _bb[i];
709         for (i = 0; i < _bc.length; i++) babc[k++] = _bc[i];
710 
711         return strConcat(string(babc), strConcat(_d, _e, _f));
712     }
713     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
714         bytes memory _ba = bytes(_a);
715         bytes memory _bb = bytes(_b);
716         bytes memory _bc = bytes(_c);
717         bytes memory _bd = bytes(_d);
718         bytes memory _be = bytes(_e);
719         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
720         bytes memory babcde = bytes(abcde);
721         uint k = 0;
722         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
723         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
724         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
725         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
726         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
727         return string(babcde);
728     }
729     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
730         return strConcat(_a, _b, _c, _d, "");
731     }
732     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
733         return strConcat(_a, _b, _c, "", "");
734     }
735     function strConcat(string _a, string _b) internal pure returns (string) {
736         return strConcat(_a, _b, "", "", "");
737     }
738 
739     function uint2str(uint i) internal pure returns (string){
740         if (i == 0) return "0";
741         uint j = i;
742         uint len;
743         while (j != 0){
744             len++;
745             j /= 10;
746         }
747         bytes memory bstr = new bytes(len);
748         uint k = len - 1;
749         while (i != 0){
750             bstr[k--] = byte(48 + i % 10);
751             i /= 10;
752         }
753         return string(bstr);
754     }
755 
756 }