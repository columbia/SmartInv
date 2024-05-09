1 pragma solidity ^0.4.25;
2 
3 // File: contracts/MoonRaffleContractInterface.sol
4 
5 contract MoonRaffleContractInterface {
6 
7     function sendContractSeed() public payable;
8 
9     function sendContractDeposit() public payable;
10 
11     function hasEntry() public view returns (bool);
12 
13     function isValidReferrer(address) public view returns (bool);
14 
15     function play(address) external payable;
16 
17     function claimPrize() external;
18 
19     function claimReferralBonus() external;
20 
21     function claimRefund() external;
22 
23     function calculateNonce() external;
24 
25     function calculateFinalRandomNumber(string, uint)  internal;
26 
27     function calculateWinners() internal;
28 
29     function calculatePrizes() internal;
30 
31     function finishMoonRaffle(string, string, string, string) external;
32 
33     function claimFeeAndDeposit() external;
34 
35     function claimRollover() external;
36 
37     function recoverUnclaimedBalance() external;
38 
39     function retractContract() external;
40 
41     function burnDeposit() internal;
42 
43     function getRandomNumber() external view returns (bytes32);
44 
45     function getTime() external view returns (uint256);
46 
47     function getSeedAmount() external view returns (uint256);
48 
49     function getDepositAmount() external view returns (uint256);
50 
51     function getCurrentPrizeAmounts() external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256);
52 
53     function getWinners() external view returns (address, address, address);
54 
55     function getFirstPrizeAddress() external view returns (address);
56 
57     function getSecondPrizeAddress() external view returns (address);
58 
59     function getThirdPrizeAddress() external view returns (address);
60 
61     function getMyStatus() external view returns (uint256, bool, uint256, uint256);
62 
63     function getCurrentPhase() external view returns (uint256, string);
64 
65     function getAddresses() external view returns (address, address);
66 
67     function getMoonRaffleEntryParameters() external view returns (uint256, uint256);
68 
69     function getMoonRaffleTimes() external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
70 
71     function getMoonRaffleStatus() external view returns (uint256, uint256, uint256);
72 
73     function getCurrentDefaultReferrer() external view returns (address);
74 
75     function getStarReferrerDetails() external view returns (address, uint256);
76 
77     function getBinaryNonce() external view returns (bool[256]);
78 
79     function getMoonRaffleParamenters() external view returns (
80       uint256,
81       uint256,
82       uint256,
83       uint256,
84       uint256,
85       uint256,
86       uint256,
87       uint256,
88       uint256
89       );
90 
91     function hasPlayerClaimedPrize() external view returns (bool);
92 
93     function hasPlayerClaimedReferralBonus() external view returns (bool);
94 
95     function getContractBalance() external view returns (uint256);
96 
97     function isRetractable() external view returns (bool);
98 
99 }
100 
101 // File: contracts/MoonRaffleContractFactoryInterface.sol
102 
103 contract MoonRaffleContractFactoryInterface {
104 
105     function createMoonRaffleContract(
106         address _addressOne,
107         bytes32 _initialSecretHash1,
108         bytes32 _initialSecretHash2,
109         bytes32 _initialSecretHash3,
110         bytes32 _initialSecretHash4,
111         uint256[14] _moonRaffleParameters
112         )
113         public
114         payable
115         returns (address);
116 
117 }
118 
119 // File: contracts/MoonRaffleMain.sol
120 
121 contract MoonRaffleMain {
122 
123     address addressOne;
124     address moonRaffleFactoryAddress;
125 
126     uint256 moonRaffleCounter = 0;    //Keeps track of how many raffles have been completed
127     string publicMessage = "when moon? buy your ticket now!";
128 
129     // ECONOMIC SETTINGS
130     uint256 pricePerTicket = 1 finney;
131     uint256 maxTicketsPerTransaction = 300;
132     uint256 prizePoolPercentage = 75;
133     uint256 firstPrizePercentage = 55;
134     uint256 secondPrizePercentage = 15;
135     uint256 thirdPrizePercentage = 5;
136     uint256 contractFeePercentage = 5;
137     uint256 rolloverPercentage = 10;
138     uint256 referralPercentage = 10;
139     uint256 referralHurdle = 10;
140     uint256 referralFloorTimePercentage = 75;
141 
142     // TIME SETTINGS
143     uint256 moonRaffleLiveSecs = 518400; // 6 DAYS default
144     uint256 winnerCalcSecs = 345600; // 4 DAYS default
145     uint256 claimSecs = 15552000; // 180 DAYS default
146 
147     uint256 latestMoonRaffleCompleteTime = 0;
148     bool latestMoonRaffleSeeded = true;
149 
150     // CURRENT LIVE ITERATION ADDRESS
151     address[] oldMoonRaffleAddresses;
152     address currentMoonRaffleAddress = 0;
153 
154     mapping(address => address[]) winners;
155 
156     // EVENTS
157     event logNewMoonRaffleFactorySet(address _moonRaffleFactory);
158     event logDonation(address _sender, uint256 _amount);
159     event logNewMoonRaffle(address _newMoonRaffle);
160     event logUpdatedPricePerTicket(uint256 _newPricePerTicket);
161     event logUpdatedMaxTicketsPerTransaction(uint256 _newMaxTicketsPerTransaction);
162     event logUpdatedPayoutEconomics(uint256 _newPrizePoolPercentage, uint256 _newFirstPrizePercentage, uint256 _newSecondPrizePercentage, uint256 _newThirdPrizePercentage, uint256 _newContractFeePercentage, uint256 _newRolloverPercentage, uint256 _newReferralPercentage, uint256 _newReferralHurdle);
163     event logUpdatedTimeParams(uint256 _newMoonRaffleLiveSecs, uint256 _newWinnerCalcSecs, uint256 _newClaimSecs, uint256 _referralFloorTimePercentage);
164     event logChangedAddressOne(address _newAddressOne);
165     event logAddedToCurrentMoonRaffle(uint256 _addedAmount);
166     event logChangedPublicMessage(string _newPublicMessage);
167 
168     modifier onlyAddressOne() {
169         require(msg.sender == addressOne);
170         _;
171     }
172 
173     modifier isNoLottoLive() {
174         require(now > latestMoonRaffleCompleteTime);
175         _;
176     }
177 
178     // FALLBACK
179     function() public payable {
180         emit logDonation(msg.sender, msg.value);
181     }
182 
183     constructor() public payable {
184         addressOne = msg.sender;
185     }
186 
187     function newMoonRaffle(
188         bytes32 _initialSecretHash1,
189         bytes32 _initialSecretHash2,
190         bytes32 _initialSecretHash3,
191         bytes32 _initialSecretHash4
192     )
193     onlyAddressOne
194     isNoLottoLive
195     external
196     {
197         require(latestMoonRaffleCompleteTime == 0);
198 
199        currentMoonRaffleAddress = MoonRaffleContractFactoryInterface(moonRaffleFactoryAddress).createMoonRaffleContract(
200             addressOne,
201             _initialSecretHash1,
202             _initialSecretHash2,
203             _initialSecretHash3,
204             _initialSecretHash4,
205             [
206                 pricePerTicket,
207                 maxTicketsPerTransaction,
208                 prizePoolPercentage,
209                 firstPrizePercentage,
210                 secondPrizePercentage,
211                 thirdPrizePercentage,
212                 contractFeePercentage,
213                 rolloverPercentage,
214                 referralPercentage,
215                 referralHurdle,
216                 referralFloorTimePercentage,
217                 moonRaffleLiveSecs,
218                 winnerCalcSecs,
219                 claimSecs
220             ]
221         );
222 
223         latestMoonRaffleCompleteTime = now + moonRaffleLiveSecs;
224         latestMoonRaffleSeeded = false;
225         moonRaffleCounter += 1;
226         emit logNewMoonRaffle(currentMoonRaffleAddress);
227     }
228 
229     function seedMoonRaffle(uint256 _seedAmount) onlyAddressOne external {
230         require(latestMoonRaffleCompleteTime != 0);
231         require(latestMoonRaffleSeeded == false);
232         require(_seedAmount <= address(this).balance);
233         latestMoonRaffleSeeded = true;
234         MoonRaffleContractInterface(currentMoonRaffleAddress).sendContractSeed.value(_seedAmount)();
235     }
236 
237     function retractMoonRaffle() onlyAddressOne external {
238         require(latestMoonRaffleCompleteTime != 0);
239         require(MoonRaffleContractInterface(currentMoonRaffleAddress).isRetractable() == true);
240         if (address(currentMoonRaffleAddress).balance > 0) { MoonRaffleContractInterface(currentMoonRaffleAddress).retractContract();}
241         latestMoonRaffleCompleteTime = 0;
242         moonRaffleCounter -= 1;
243         latestMoonRaffleSeeded = true;
244         if (oldMoonRaffleAddresses.length > 0) {
245             currentMoonRaffleAddress = oldMoonRaffleAddresses[(oldMoonRaffleAddresses.length - 1)];
246         } else {
247             currentMoonRaffleAddress = 0;
248         }
249     }
250 
251     function logFinishedInstance() onlyAddressOne public {
252         assert(now >= latestMoonRaffleCompleteTime);
253         assert(latestMoonRaffleCompleteTime > 0);
254         latestMoonRaffleCompleteTime = 0;
255         oldMoonRaffleAddresses.push(currentMoonRaffleAddress);
256         MoonRaffleContractInterface tempMoonRaffle = MoonRaffleContractInterface(currentMoonRaffleAddress);
257         winners[tempMoonRaffle.getFirstPrizeAddress()].push(currentMoonRaffleAddress);
258         winners[tempMoonRaffle.getSecondPrizeAddress()].push(currentMoonRaffleAddress);
259         winners[tempMoonRaffle.getThirdPrizeAddress()].push(currentMoonRaffleAddress);
260     }
261 
262     function updatePricePerTicket(uint256 _newPricePerTicket) onlyAddressOne public {
263         require(_newPricePerTicket >= 1 finney);
264         require(_newPricePerTicket <= 1 ether);
265         pricePerTicket = _newPricePerTicket;
266         emit logUpdatedPricePerTicket(_newPricePerTicket);
267     }
268 
269     function updateMaxTicketsPerTransaction(uint256 _newMaxTickets) onlyAddressOne public {
270         require(_newMaxTickets >= 10);
271         maxTicketsPerTransaction = _newMaxTickets;
272         emit logUpdatedMaxTicketsPerTransaction(_newMaxTickets);
273     }
274 
275 
276     function updatePayoutEconomics(
277         uint256 _newPrizePoolPercentage,
278         uint256 _newFirstPrizePercentage,
279         uint256 _newSecondPrizePercentage,
280         uint256 _newThirdPrizePercentage,
281         uint256 _newContractFeePercentage,
282         uint256 _newRolloverPercentage,
283         uint256 _newReferralPercentage,
284         uint256 _newReferralHurdle
285     )
286     onlyAddressOne
287     public
288     {
289         require(_newPrizePoolPercentage + _newContractFeePercentage + _newRolloverPercentage + _newReferralPercentage == 100);
290         require(_newPrizePoolPercentage == _newFirstPrizePercentage + _newSecondPrizePercentage + _newThirdPrizePercentage);
291         require(_newContractFeePercentage <= 10);
292         require(_newRolloverPercentage <= 20);
293         require(_newReferralPercentage <= 20);
294         require(_newReferralHurdle <= maxTicketsPerTransaction);
295 
296         prizePoolPercentage = _newPrizePoolPercentage;
297         firstPrizePercentage = _newFirstPrizePercentage;
298         secondPrizePercentage = _newSecondPrizePercentage;
299         thirdPrizePercentage = _newThirdPrizePercentage;
300         contractFeePercentage = _newContractFeePercentage;
301         rolloverPercentage = _newRolloverPercentage;
302         referralPercentage = _newReferralPercentage;
303         referralHurdle = _newReferralHurdle;
304 
305         emit logUpdatedPayoutEconomics(_newPrizePoolPercentage, _newFirstPrizePercentage, _newSecondPrizePercentage, _newThirdPrizePercentage, _newContractFeePercentage, _newRolloverPercentage, _newReferralPercentage, _newReferralHurdle);
306     }
307 
308     function updateTimeParams(
309         uint256 _moonRaffleLiveSecs,
310         uint256 _winnerCalcSecs,
311         uint256 _claimSecs,
312         uint256 _referralFloorTimePercentage
313     )
314     onlyAddressOne
315     public
316     {
317         require(_moonRaffleLiveSecs >= 86400);
318         // Min 1 day
319         require(_moonRaffleLiveSecs <= 15552000);
320         // Max 180 days
321         require(_winnerCalcSecs >= 43200);
322         // Min 12 hour
323         require(_winnerCalcSecs <= 345600);
324         // Max 96 hours
325         require(_claimSecs >= 2592000);
326         // Min 30 days
327         require(_claimSecs <= 31536000);
328         // Max 365 days
329         require(_referralFloorTimePercentage >= 25);
330         // Min 25%
331         require(_referralFloorTimePercentage <= 90);
332         // Max 90%
333         moonRaffleLiveSecs = _moonRaffleLiveSecs;
334         winnerCalcSecs = _winnerCalcSecs;
335         claimSecs = _claimSecs;
336         referralFloorTimePercentage = _referralFloorTimePercentage;
337 
338         emit logUpdatedTimeParams(_moonRaffleLiveSecs, _winnerCalcSecs, _claimSecs, _referralFloorTimePercentage);
339     }
340 
341     function updatePublicMessage(string _newPublicMessage) onlyAddressOne public {
342         publicMessage = _newPublicMessage;
343         emit logChangedPublicMessage(_newPublicMessage);
344     }
345 
346     // CHANGE ADMIN ADDRESSES
347     function updateAddressOne(address _newAddressOne) onlyAddressOne public {
348         addressOne = _newAddressOne;
349         emit logChangedAddressOne(_newAddressOne);
350     }
351 
352     function addToCurrentMoonRaffle(uint256 _amountAdded) onlyAddressOne external {
353         require(now < latestMoonRaffleCompleteTime);
354         require(address(this).balance >= _amountAdded);
355         emit logAddedToCurrentMoonRaffle(_amountAdded);
356         currentMoonRaffleAddress.transfer(_amountAdded);
357     }
358 
359     function updateMoonRaffleFactoryAddress(address _newMoonRaffleFactoryAddress) onlyAddressOne external {
360         moonRaffleFactoryAddress = _newMoonRaffleFactoryAddress;
361         emit logNewMoonRaffleFactorySet(_newMoonRaffleFactoryAddress);
362     }
363 
364     function donate() external payable {
365         require(msg.value > 0);
366         emit logDonation(msg.sender, msg.value);
367     }
368 
369     function getNextMoonRaffleParameters() external view returns (
370         uint256,
371         uint256,
372         uint256,
373         uint256,
374         uint256,
375         uint256,
376         uint256,
377         uint256,
378         uint256,
379         uint256,
380         uint256,
381         uint256,
382         uint256,
383         uint256
384     ) {
385         return (
386             pricePerTicket,
387             maxTicketsPerTransaction,
388             prizePoolPercentage,
389             firstPrizePercentage,
390             secondPrizePercentage,
391             thirdPrizePercentage,
392             contractFeePercentage,
393             rolloverPercentage,
394             referralPercentage,
395             referralHurdle,
396             referralFloorTimePercentage,
397             moonRaffleLiveSecs,
398             winnerCalcSecs,
399             claimSecs
400         );
401     }
402 
403     function getCurrentMoonRaffleAddress() external view returns (address) {
404         return currentMoonRaffleAddress;
405     }
406 
407     function getMoonRaffleCounter() external view returns (uint256) {
408         return moonRaffleCounter;
409     }
410 
411     function getLastMoonRaffleAddress() external view returns (address) {
412         return oldMoonRaffleAddresses[(oldMoonRaffleAddresses.length - 1)];
413     }
414 
415     function getAllPreviousMoonRaffleAddresses() external view returns (address[]) {
416         return oldMoonRaffleAddresses;
417     }
418 
419     function getMainAddresses() external view returns (address, address) {
420         return (addressOne, moonRaffleFactoryAddress);
421     }
422 
423     function getLatestMoonRaffleCompleteTime() external view returns (uint256) {
424         return latestMoonRaffleCompleteTime;
425     }
426 
427     function getPublicMessage() external view returns (string) {
428         return publicMessage;
429     }
430 
431     function checkAddressForWins() external view returns (address[]) {
432         return winners[msg.sender];
433     }
434 
435     function getContractBalance() external view returns (uint256) {
436         return address(this).balance;
437     }
438 
439     function getMainStatus() external view returns (string) {
440         if (latestMoonRaffleCompleteTime == 0) {return "ready for new moonraffle";}
441         if (now < latestMoonRaffleCompleteTime) {return "current moonraffle still in progress";}
442         return "current moonraffle past complete time. check if it is complete and loggable";
443     }
444 
445 }