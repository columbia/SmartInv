1 pragma experimental "v0.5.0";
2 
3 //Micro Etheroll contract
4 //version 0.8.0
5 
6 //// minimal Etheroll "interface"
7 
8 contract Etheroll {
9     function playerRollDice(uint rollUnder) public payable;
10     function playerWithdrawPendingTransactions() public returns (bool);
11 }
12 
13 //// Proxy contract for Micro Etheroll - providing a cheap and empty payable fallback function
14 
15 contract Proxy {
16     address etheroll;
17     address micro;
18     address owner;
19     uint roundID = 0;
20 
21     event GotFunds(uint indexed roundID, address indexed sender, uint indexed amount);
22     event SentFunds(uint indexed roundID, uint indexed amount, uint indexed rollUnder);
23     event WithdrawPendingTransactionsResult(bool indexed result);
24 
25     constructor(address etherollAddress, address ownerAddress) public {
26         etheroll = etherollAddress;
27         owner = ownerAddress;
28         micro = msg.sender;
29         roundID = 0;
30     }
31 
32 //// Getters
33 
34     function getBalance() view external returns (uint) {
35         return address(this).balance;
36     }
37 
38     function getRoundID() view external returns (uint) {
39         return roundID;
40     }
41 
42     function getEtherollAddress() view external returns (address) {
43         return etheroll;
44     }
45 
46 
47 //// Secutity modifier
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     modifier onlyMicro {
55         require(msg.sender == micro);
56         _;
57     }
58 
59 //// Insecure public payable fallback function
60 
61     function () external payable {
62         emit GotFunds(roundID, msg.sender, msg.value);
63     }
64 
65 //// Sending bets and withdrawing winnings
66 
67     function sendToEtheroll(uint rollUnder, uint newRoundID) external payable
68             onlyMicro
69     {
70         roundID = newRoundID;
71         Etheroll e = Etheroll(etheroll);
72         e.playerRollDice.value(msg.value)(rollUnder);
73         emit SentFunds(roundID, msg.value, rollUnder);
74     }
75 
76     function withdrawWinnings() external
77             onlyMicro
78     {
79         Micro m = Micro(micro);
80         m.withdrawWinnings.value(address(this).balance)();
81     }
82 
83 //// Owner security & maintenance functions
84 
85     function withdrawRefund() external
86             onlyMicro
87     {
88         Micro m = Micro(micro);
89         m.withdrawRefund.value(address(this).balance)();
90     }
91     
92     function withdrawPendingTransactions() external
93             onlyOwner
94     {
95         Etheroll e = Etheroll(etheroll);
96         emit WithdrawPendingTransactionsResult(e.playerWithdrawPendingTransactions());
97     }
98     
99     function ownerWithdraw() external
100             onlyOwner
101     {
102         owner.transfer(address(this).balance);
103     }
104     
105     function setEtherollAddress(address etherollAddress) external
106             onlyOwner
107     {
108         etheroll = etherollAddress;
109     }
110     
111 }
112 
113 //// Main Micro Etheroll Contract
114 
115 contract Micro {
116     address[110] bets;
117     address proxy;
118     address owner;
119 
120     uint roundID;
121 
122     bool betsState = true;
123     bool rolled = false;
124     bool emergencyBlock = false;
125     bool betsBlock = false;
126 
127     uint rollUnder = 90;
128     uint participants = 10; // Number of effective participants (without extraBets)
129     uint extraBets = 1;
130     uint oneBet = 0.01 ether;
131     uint8 numberOfBets = 0;
132 
133     uint houseEdgeDivisor = 1000;
134     uint houseEdge = 990;
135 
136     uint expectedReturn;
137 
138     event GotBet(uint indexed roundID, address indexed sender, uint8 indexed numberOfBets);
139     event BetResult(uint indexed roundID, uint8 indexed result, uint indexed amount);
140     event ReadyToRoll(uint indexed roundID, uint indexed participants, uint indexed oneBet);
141     event SendError(uint indexed roundID, address addr, uint amount);
142     event Emergency(uint indexed roundID);
143 
144     constructor(address etherollAddress) public {
145         owner = msg.sender;
146         proxy = new Proxy(etherollAddress, owner);
147         setExpectedReturn((((((oneBet*participants) * (100-(rollUnder-1))) / (rollUnder-1)+(oneBet*participants)))*houseEdge/houseEdgeDivisor) / 0.01 ether);
148         roundID = 0;
149     }
150 
151 //// Getters and Setter
152 
153 
154 
155     function setExpectedReturn(uint rounded) internal {
156         expectedReturn = rounded * 0.01 ether;
157     }
158 
159     function getBetsState() external view returns (bool) {
160         return betsState;
161     }
162     
163     function getRolled() external view returns (bool) {
164         return rolled;
165     }
166 
167     function getExpectedReturn() external view returns (uint) {
168         return expectedReturn;
169     }
170 
171     function getNumberOfBets() external view returns (uint) {
172         return numberOfBets;
173     }
174 
175     function getRollUnder() external view returns (uint) {
176         return rollUnder;
177     }
178 
179     function getOneBet() external view returns (uint) {
180         return oneBet;
181     }
182 
183     function getParticipants() external view returns (uint) {
184         return participants;
185     }
186     
187     function getExtraBets() external view returns (uint) {
188         return extraBets;
189     }
190 
191     function getBetsBlock() external view returns (bool) {
192         return betsBlock;
193     }
194 
195     function getRoundID() view external returns (uint) {
196         return roundID;
197     }
198 
199     function getWaitingState() external view returns (uint) {
200         if (!betsState && !rolled) return 1; //waiting for roll()
201         if (!betsState && rolled && (address(proxy).balance > 0)) return 2; //waiting for wakeUpProxy(), but needs a check if funds on proxy are winnings
202         if (emergencyBlock) return 9; //is in emergency block
203         if (betsBlock) return 8; //bets block active
204         if (betsState && !rolled) return 0; //not waiting, accepting bids
205         return 5; // unknown state, probably waiting for etheroll 
206     }
207     
208     // Combined "one-request" getState for web-requests optimisation
209     function getState() external view returns (bool, bool, uint, uint, uint, uint, uint, uint, bool, uint, uint) {
210         return (this.getBetsState(),
211                 this.getRolled(),
212                 this.getExpectedReturn(),
213                 this.getNumberOfBets(),
214                 this.getRollUnder(),
215                 this.getOneBet(),
216                 this.getParticipants(),
217                 this.getExtraBets(),
218                 this.getBetsBlock(),
219                 this.getRoundID(),
220                 this.getWaitingState());
221     }
222 
223 //// Security function modifiers
224 
225     modifier onlyOwner {
226         require(msg.sender == owner);
227         _;
228     }
229 
230     modifier onlyProxy {
231         require(msg.sender == proxy);
232         _;
233     }
234 
235     modifier betsOver {
236         require (!betsState);
237         _;
238     }
239 
240     modifier betsActive {
241         require (betsState);
242         _;
243     }
244 
245     modifier noBets {
246         require (numberOfBets == 0);
247         _;
248     }
249 
250     modifier hasRolled {
251         require(rolled);
252         _;
253     }
254 
255     modifier hasntRolled {
256         require(!rolled);
257         _;
258     }
259 
260     modifier hasMoney {
261         require(address(proxy).balance > 0);
262         _;
263     }
264 
265     modifier noEmergencyBlock {
266         require(!emergencyBlock);
267         _;
268     }
269 
270 //// Secure payable fallback function - receives bets
271 
272     function () external payable {
273         require((msg.value == oneBet) || (msg.sender == owner));
274         if (msg.sender != owner) {
275             require(betsState && !emergencyBlock);
276             require(!betsBlock);
277             if (numberOfBets < participants+(extraBets-1)) {
278                 bets[numberOfBets] = msg.sender;
279                 numberOfBets++;
280                 emit GotBet(roundID, msg.sender, numberOfBets);
281             } else {
282                 bets[numberOfBets] = msg.sender;
283                 numberOfBets++;
284                 emit GotBet(roundID, msg.sender, numberOfBets);
285                 betsState = false;
286                 emit ReadyToRoll(roundID, participants+extraBets, oneBet);
287             }
288         }
289     }
290 
291 
292 //// Main contract callable functions
293 
294     function roll() external
295             betsOver
296             hasntRolled
297             noEmergencyBlock
298     {
299         require(numberOfBets == (participants + extraBets));
300         rolled = true;
301         Proxy p = Proxy(proxy);
302         p.sendToEtheroll.value((participants) * oneBet)(rollUnder, roundID);
303 	  }
304 
305     function wakeUpProxy() external
306             onlyOwner
307             betsOver
308             hasRolled
309             hasMoney
310             noEmergencyBlock
311     {
312         rolled = false;
313         Proxy p = Proxy(proxy);
314         p.withdrawWinnings();
315     }
316 
317 //// Withdraw and distribute winnings
318 
319     function withdrawWinnings() external payable
320             onlyProxy
321     {
322         if ((msg.value > expectedReturn) && !emergencyBlock) {
323             emit BetResult(roundID, 1, msg.value); // We won! Set 1
324             distributeWinnings(msg.value);
325         } else {
326             emit BetResult(roundID, 0, msg.value); // We lost :( Set 0
327         }
328         
329         numberOfBets = 0;
330         betsState = true;
331         roundID++;
332     }
333 
334     function proxyGetRefund() external
335             onlyOwner
336             betsOver
337             hasRolled
338             hasMoney
339     {
340         rolled = false;
341         Proxy p = Proxy(proxy);
342         p.withdrawRefund();
343     }
344 
345     function withdrawRefund() external payable
346             onlyProxy
347     {
348         emit BetResult(roundID, 2, msg.value); // Set 2 for Refund
349         distributeWinnings(msg.value+(oneBet*extraBets)); // Distribute the refund and return extraBets
350         
351         numberOfBets = 0;
352         betsState = true;
353         roundID++;
354     }
355 
356     function distributeWinnings(uint value) internal
357             betsOver
358     {
359         require(numberOfBets == (participants + extraBets)); // Check if count of participants+extraBets matches numberOfBets
360 
361         uint share = value / (numberOfBets); // Calculate the share out of value received div by number of bets
362         for (uint i = 0; i<(numberOfBets); i++) {
363             if (!(bets[i].send(share))) emit SendError(roundID, bets[i], share); // Send an SendError event if something goes wrong
364         }
365     }
366 
367 //// Owner security & maintenance functions
368 
369     function resetState() external
370         onlyOwner
371     {
372         numberOfBets = 0;
373         betsState = true;
374         rolled = false;
375         roundID++;
376     }
377 
378     function returnBets() external
379             onlyOwner
380     {
381         require(emergencyBlock || betsBlock);
382         require(numberOfBets>0);
383         for (uint i = 0; i<(numberOfBets); i++) {
384             if (!(bets[i].send(oneBet))) emit SendError(roundID, bets[i], oneBet); // Send an SendError event if something goes wrong
385         }
386         numberOfBets = 0;
387         betsState = true;
388         rolled = false;
389         roundID++;        
390     }
391         
392 
393     function changeParticipants(uint newParticipants) external
394             onlyOwner
395             betsActive
396     {
397         require((newParticipants <= 100) && (newParticipants > numberOfBets)); //Check that newParticipants don't exceed bets array length and exceed current round existing bets
398         participants = newParticipants;
399         setExpectedReturn((((((oneBet*participants) * (100-(rollUnder-1))) / (rollUnder-1)+(oneBet*participants)))*houseEdge/houseEdgeDivisor) / 0.01 ether);
400     }
401 
402     function changeExtraBets(uint newExtraBets) external
403             onlyOwner
404             betsActive
405     {
406         require(participants+newExtraBets < bets.length);
407         require(participants+newExtraBets > numberOfBets);
408         extraBets = newExtraBets;
409     }
410 
411     function changeOneBet(uint newOneBet) external
412             onlyOwner
413             betsActive
414             noBets
415     {
416         require(newOneBet > 0);
417         oneBet = newOneBet;
418         setExpectedReturn((((((oneBet*participants) * (100-(rollUnder-1))) / (rollUnder-1)+(oneBet*participants)))*houseEdge/houseEdgeDivisor) / 0.01 ether);
419     }
420 
421     function changeRollUnder(uint newRollUnder) external
422             onlyOwner
423             betsActive
424     {
425         require((newRollUnder > 1) && (newRollUnder < 100));
426         rollUnder = newRollUnder;
427         setExpectedReturn((((((oneBet*participants) * (100-(rollUnder-1))) / (rollUnder-1)+(oneBet*participants)))*houseEdge/houseEdgeDivisor) / 0.01 ether);
428     }
429 
430     function enableEmergencyBlock() external
431             onlyOwner
432     {
433         emergencyBlock = true;
434         emit Emergency(roundID);
435     }
436 
437     function disableEmergencyBlock() external
438             onlyOwner
439     {
440         emergencyBlock = false;
441     }
442 
443     function enableBets() external
444             onlyOwner
445     {
446         betsBlock = false;
447     }
448 
449     function disableBets() external
450             onlyOwner
451     {
452         betsBlock = true;
453     }
454 
455     function ownerWithdraw() external
456             onlyOwner
457     {
458         owner.transfer(address(this).balance);
459     }
460 
461     function ownerkill() external
462 		    onlyOwner
463 	  {
464 		selfdestruct(owner);
465 	  }
466 }