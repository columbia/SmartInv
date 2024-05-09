1 pragma solidity 0.4.25;
2 
3 // EthBet betting games
4 
5 
6 contract EthBet {
7 
8   constructor() public {
9     owner = msg.sender;
10     balances[address(this)] = 0;
11     lockedFunds = 0;
12   }
13 
14   function() public payable {
15     require(msg.data.length == 0, "Not in use");
16   }
17 
18   address public owner;
19   // The address corresponding to a private key used to sign placeBet commits.
20   address public secretSigner = 0x87cF6EdB672Fe969d8B65e9D501e246B91DDF8e1;
21   bool public isActive = true;
22   uint public totalPlayableFunds;
23   uint public lockedFunds;
24 
25   uint HOUSE_EDGE_PERCENT = 2;
26   uint REFERRER_BONUS_PERCENT = 1;
27   uint REFEREE_FIRST_TIME_BONUS = 0.01 ether;
28   uint HOUSE_EDGE_MIN_AMOUNT = 0.0003 ether;
29 
30   uint MINBET = 0.01 ether;
31   uint MAXBET = 1 ether;
32   uint constant MAX_MODULO = 100;
33   uint constant MAX_BET_MASK = 99;
34   uint constant BET_EXPIRATION_BLOCKS = 250;
35 
36   mapping(address => uint) balances;
37   mapping(address => address) referrers;
38   address[] playerAddresses; 
39 
40   modifier ownerOnly {
41     require(msg.sender == owner, "Ownly Owner");
42     _;
43   }
44 
45 
46   modifier runWhenActiveOnly {
47     require(isActive,"Only Active");
48     _;
49   }
50 
51   modifier runWhenNotActiveOnly {
52     require(!isActive,"Only Inactive");
53     _;
54   }
55 
56   modifier validBetAmountOnly(uint amount) {
57     require(amount >= MINBET && amount < MAXBET && amount < totalPlayableFunds,"Invalid betAmount");
58     _;
59   }
60 
61   event Withdrawal(address benificiary, uint amount);
62   event ReceivedFund(address benificiary, uint amount);
63 
64   event RefererSet(address player, address referrer);
65   event WinBet(address better, uint betAmount, uint winAmount, uint currentBalance);
66   event LoseBet(address better, uint betAmount, uint loseAmount, uint currentBalance);
67 
68   event Active();
69   event Deactive();
70 
71   event Destroyed();
72   event NewPlayer(address[] players);
73   event ReferralFailedPayout(address receiver, uint amount);
74   event DestroyFailedPayout(address receiver, uint amount);
75 
76   /**
77    * Ownable
78    */
79 
80   function transferOwnership(address _newOwner) public ownerOnly {
81     _transferOwnership(_newOwner);
82   }
83 
84   function _transferOwnership(address _newOwner) internal {
85     require(_newOwner != address(0), "Invalid Address");
86     owner = _newOwner;
87   }
88 
89   // See comment for "secretSigner" variable.
90   function setSecretSigner(address newSecretSigner) external ownerOnly {
91     secretSigner = newSecretSigner;
92   }
93 
94 
95   /**
96    * Pausable
97    */
98   function toggleActive() public ownerOnly {
99     isActive = !isActive;
100     if (isActive)
101       emit Active();
102     else
103       emit Deactive();
104   }
105 
106   /**
107    * Destructible
108    */
109   function destroy() public ownerOnly {
110     emit Destroyed();
111     payOutAllBalanceBeforeDestroy();
112     selfdestruct(owner);
113   }
114 
115   function destroyAndSend(address _recipient) public ownerOnly {
116     emit Destroyed();
117     payOutAllBalanceBeforeDestroy();
118     selfdestruct(_recipient);
119   }
120 
121   /**
122    * Readable
123    */
124 
125   event LoggingData(uint contractBalance, uint totalHouseEdge, uint totalPlayableFunds);
126 
127   function logData() external {
128     emit LoggingData(
129       address(this).balance,
130       balances[address(this)],
131       totalPlayableFunds
132     );
133   } 
134 
135   /**
136    * Editable
137    */
138   
139   function editBetData(
140     uint _houseEdgePercent, 
141     uint _houseEdgeMin,
142     uint _refererBonusPercent,
143     uint _referreeFirstTimeBonus,
144     uint _minBet,
145     uint _maxBet) external ownerOnly {
146 
147     HOUSE_EDGE_PERCENT = _houseEdgePercent;
148     HOUSE_EDGE_MIN_AMOUNT = _houseEdgeMin;
149     REFERRER_BONUS_PERCENT = _refererBonusPercent;
150     REFEREE_FIRST_TIME_BONUS = _referreeFirstTimeBonus;
151 
152     MINBET = _minBet;
153     MAXBET = _maxBet;
154   }
155 
156   /**
157    * Contract external functions
158    */
159 
160   function playBalance(
161     uint betValue, 
162     uint betMask, 
163     uint modulo, 
164     uint commitLastBlock, 
165     bytes32 commit, 
166     bytes32 r, 
167     bytes32 s, 
168     uint8 v) external runWhenActiveOnly validBetAmountOnly(betValue) {
169 
170     validateCommit(commitLastBlock, commit, r, s, v);
171     
172     uint _possibleWinAmount;
173     uint _referrerBonus;
174     uint _houseEdge;
175     bool _isWin;
176     
177     (_possibleWinAmount, _referrerBonus, _houseEdge, _isWin) = play(msg.sender, betValue, betMask, modulo, commit);
178     settleBet(msg.sender, betValue, _possibleWinAmount, _referrerBonus, _houseEdge, _isWin, true);
179   }
180 
181   function playTopUp(
182     uint betMask, 
183     uint modulo, 
184     uint commitLastBlock, 
185     bytes32 commit, 
186     bytes32 r, 
187     bytes32 s, 
188     uint8 v) external payable  runWhenActiveOnly validBetAmountOnly(msg.value) {
189 
190     validateCommit(commitLastBlock, commit, r, s, v);
191 
192     uint _possibleWinAmount;
193     uint _referrerBonus;
194     uint _houseEdge;
195     bool _isWin;
196 
197     (_possibleWinAmount, _referrerBonus, _houseEdge, _isWin) = play(msg.sender, msg.value, betMask, modulo, commit);
198     settleBet(msg.sender, msg.value, _possibleWinAmount, _referrerBonus, _houseEdge, _isWin, false);
199   }
200 
201   function playFirstTime(
202     address referrer, 
203     uint betMask, 
204     uint modulo, 
205     uint commitLastBlock, 
206     bytes32 commit, 
207     bytes32 r, 
208     bytes32 s, 
209     uint8 v) external payable runWhenActiveOnly validBetAmountOnly(msg.value) {
210 
211     validateCommit(commitLastBlock, commit, r, s, v);
212     setupFirstTimePlayer(msg.sender);
213 
214     uint _betAmount = msg.value;
215     if(referrer != address(0) && referrer != msg.sender && referrers[msg.sender] == address(0)) {
216       _betAmount += REFEREE_FIRST_TIME_BONUS; 
217       setReferrer(msg.sender, referrer);
218     }
219     else
220       setReferrer(msg.sender, address(this));
221 
222     uint _possibleWinAmount;
223     uint _referrerBonus;
224     uint _houseEdge;
225     bool _isWin;
226 
227     (_possibleWinAmount, _referrerBonus, _houseEdge, _isWin) = play(msg.sender, _betAmount, betMask, modulo, commit);
228     settleBet(msg.sender, _betAmount, _possibleWinAmount, _referrerBonus, _houseEdge, _isWin, false);
229   }
230 
231   function playSitAndGo(
232     uint betMask, 
233     uint modulo, 
234     uint commitLastBlock, 
235     bytes32 commit, 
236     bytes32 r, 
237     bytes32 s, 
238     uint8 v) external payable  runWhenActiveOnly validBetAmountOnly(msg.value) {
239 
240     validateCommit(commitLastBlock, commit, r, s, v);
241 
242     uint _possibleWinAmount;
243     uint _referrerBonus;
244     uint _houseEdge;
245     bool _isWin;
246 
247     (_possibleWinAmount, _referrerBonus, _houseEdge, _isWin) = play(msg.sender, msg.value, betMask, modulo, commit);
248     settleBetAutoWithdraw(msg.sender, msg.value, _possibleWinAmount, _referrerBonus, _houseEdge, _isWin);
249   }
250 
251   function withdrawFunds() external {
252     require(balances[msg.sender] > 0, "Not enough balance");
253     uint _amount = balances[msg.sender];
254     balances[msg.sender] = 0;
255     msg.sender.transfer(_amount);
256     emit Withdrawal(msg.sender, _amount);
257   }
258 
259   function withdrawForOperationalCosts(uint amount) external ownerOnly {
260     require(amount < totalPlayableFunds, "Amount needs to be smaller than total fund");
261     totalPlayableFunds -= amount;
262     msg.sender.transfer(amount);
263   }
264 
265   function donateFunds() external payable {
266     require(msg.value > 0, "Please be more generous!!");
267     uint _oldtotalPlayableFunds = totalPlayableFunds;
268     totalPlayableFunds += msg.value;
269 
270     assert(totalPlayableFunds >= _oldtotalPlayableFunds);
271   }
272 
273   function topUp() external payable {
274     require(msg.value > 0,"Topup valu needs to be greater than 0");
275     balances[msg.sender] += msg.value;
276   }
277 
278   function getBalance() external view returns(uint) {
279     return balances[msg.sender];
280   }
281 
282   /**
283    * Conract interal functions
284    */
285 
286 
287   function validateCommit(uint commitLastBlock, bytes32 commit, bytes32 r, bytes32 s, uint8 v) internal view {
288     require(block.number <= commitLastBlock, "Commit has expired.");
289     bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
290     require(secretSigner == ecrecover(signatureHash, v, r, s), "ECDSA signature is not valid.");
291   }
292 
293   function settleBet(
294     address beneficiary, 
295     uint betAmount,
296     uint possibleWinAmount,
297     uint referrerBonus,
298     uint houseEdge,
299     bool isWin, 
300     bool playedFromBalance) internal {
301 
302     lockFunds(possibleWinAmount);
303 
304     settleReferrerBonus(referrers[beneficiary], referrerBonus);
305     settleHouseEdge(houseEdge);
306 
307     if(isWin) {
308       if(playedFromBalance) 
309         balances[beneficiary] += possibleWinAmount - betAmount;
310       else
311         balances[beneficiary] += possibleWinAmount;
312       totalPlayableFunds -= possibleWinAmount - betAmount;
313       emit WinBet(beneficiary, betAmount, possibleWinAmount, balances[beneficiary]);
314     } else {
315       if(playedFromBalance) 
316         balances[beneficiary] -= betAmount;
317 
318       totalPlayableFunds += betAmount;
319       emit LoseBet(beneficiary, betAmount, betAmount, balances[beneficiary]);
320     }
321 
322     unlockFunds(possibleWinAmount);
323   }
324 
325   function settleBetAutoWithdraw(
326     address beneficiary, 
327     uint betAmount,
328     uint possibleWinAmount,
329     uint referrerBonus,
330     uint houseEdge,
331     bool isWin) internal {
332 
333     lockFunds(possibleWinAmount);
334 
335     settleReferrerBonus(referrers[beneficiary], referrerBonus);
336     settleHouseEdge(houseEdge);
337 
338     if(isWin) {
339       totalPlayableFunds -= possibleWinAmount - betAmount;
340       beneficiary.transfer(possibleWinAmount);
341       emit WinBet(beneficiary, betAmount, possibleWinAmount, balances[beneficiary]);
342     } else {
343       totalPlayableFunds += betAmount;
344       emit LoseBet(beneficiary, betAmount, betAmount, balances[beneficiary]);
345     }
346 
347     unlockFunds(possibleWinAmount);
348   }
349 
350   function setReferrer(address referee, address referrer) internal {
351     if(referrers[referee] == address(0)) {
352       referrers[referee] = referrer;
353       emit RefererSet(referee, referrer);
354     }
355   }
356 
357   function settleReferrerBonus(address referrer, uint referrerBonus) internal {
358     if(referrerBonus > 0) {
359       totalPlayableFunds -= referrerBonus;
360       if(referrer != address(this)) {
361         if(!referrer.send(referrerBonus)) 
362           balances[address(this)] += referrerBonus;
363       } else {
364         balances[address(this)] += referrerBonus;
365       }
366     }
367   }
368 
369   function settleHouseEdge(uint houseEdge) internal {
370     totalPlayableFunds -= houseEdge;
371     balances[address(this)] += houseEdge;
372   }
373 
374   function setupFirstTimePlayer(address newPlayer) internal {
375     if(referrers[newPlayer] == address(0)) 
376       playerAddresses.push(newPlayer);
377   }
378 
379   function payOutAllBalanceBeforeDestroy() internal ownerOnly {
380     uint _numberOfPlayers = playerAddresses.length;
381     for(uint i = 0;i < _numberOfPlayers;i++) {
382       address _player = playerAddresses[i];
383       uint _playerBalance = balances[_player];
384       if(_playerBalance > 0) {
385         if(!_player.send(_playerBalance))
386           emit DestroyFailedPayout(_player, _playerBalance);
387       } 
388     }
389   }
390 
391   function play(
392     address player, 
393     uint betValue,
394     uint betMask, 
395     uint modulo, 
396     bytes32 commit) internal view returns(uint, uint, uint, bool) {
397 
398     uint _possibleWinAmount;
399     uint _referrerBonus;
400     uint _houseEdge;
401 
402     bool _isWin = roll(betMask, modulo, commit);
403     (_possibleWinAmount, _referrerBonus, _houseEdge) = calculatePayouts(player, betValue, modulo, betMask, _isWin);
404     return (_possibleWinAmount, _referrerBonus, _houseEdge, _isWin);
405   }
406 
407   function calculatePayouts(
408     address player, 
409     uint betAmount, 
410     uint modulo, 
411     uint rollUnder,
412     bool isWin) internal view returns(uint, uint, uint) {
413     require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
414 
415     uint _referrerBonus = 0;
416     uint _multiplier = modulo / rollUnder; 
417     uint _houseEdge = betAmount * HOUSE_EDGE_PERCENT / 100;
418     if(referrers[player] != address(0)) {
419       _referrerBonus = _houseEdge * REFERRER_BONUS_PERCENT / HOUSE_EDGE_PERCENT; 
420     }
421     if(isWin)
422       _houseEdge = _houseEdge * (_multiplier - 1);
423     if (_houseEdge < HOUSE_EDGE_MIN_AMOUNT)
424       _houseEdge = HOUSE_EDGE_MIN_AMOUNT;
425 
426     uint _possibleWinAmount = (betAmount * _multiplier) - _houseEdge;
427     _houseEdge = _houseEdge - _referrerBonus;
428 
429     return (_possibleWinAmount, _referrerBonus, _houseEdge);
430   }
431 
432   function roll(
433     uint betMask, 
434     uint modulo, 
435     bytes32 commit) internal view returns(bool) {
436 
437     // Validate input data ranges.
438     require(modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
439     require(0 < betMask && betMask < MAX_BET_MASK, "Mask should be within range.");
440 
441     // Check whether contract has enough funds to process this bet.
442     //require(lockedFunds <= totalPlayableFunds, "Cannot afford to lose this bet.");
443 
444     // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
445     // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
446     // preimage is intractable), and house is unable to alter the "reveal" after
447     // placeBet have been mined (as Keccak256 collision finding is also intractable).
448     bytes32 entropy = keccak256(abi.encodePacked(commit, blockhash(block.number)));    
449 
450     // Do a roll by taking a modulo of entropy. Compute winning amount.
451     uint dice = uint(entropy) % modulo;
452 
453     // calculating dice win
454     uint diceWin = 0;
455 
456     if (dice < betMask) {
457       diceWin = 1;
458     }
459     return diceWin > 0;
460   }
461 
462   function lockFunds(uint lockAmount) internal 
463   {
464     lockedFunds += lockAmount;
465     assert(lockedFunds <= totalPlayableFunds);
466   }
467 
468   function unlockFunds(uint unlockAmount) internal
469   {
470     lockedFunds -= unlockAmount;
471   }
472 
473 }