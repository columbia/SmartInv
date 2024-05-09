1 /*
2     cEthereumlotteryNet
3     Coded by: iFA
4     http://c.ethereumlottery.net
5 */
6 
7 contract cEthereumlotteryNet {
8         address owner;
9         address drawerAddress;
10         bool contractEnabled = true;
11         uint public constant ticketPrice = 10 finney;
12         uint constant defaultJackpot = 100 ether;
13         uint constant feep = 23;
14         uint constant hit3p = 35;
15         uint constant hit4p = 25;
16         uint constant hit5p = 40;
17         uint8 constant maxNumber = 30;
18         uint constant drawCheckStep = 80;
19         uint feeValue;
20 
21         struct hits_s {
22                 uint prize;
23                 uint count;
24         }
25 
26         enum drawStatus_ {
27                 Wait,
28                 InProcess,
29                 Done,
30                 Failed
31         }
32 
33         struct tickets_s {
34                 uint hits;
35                 bytes5 numbers;
36         }
37 
38         struct games_s {
39                 uint start;
40                 uint end;
41                 uint jackpot;
42                 bytes32 secret_Key_Hash;
43                 string secret_Key;
44                 uint8[5] winningNumbers;
45                 mapping(uint => hits_s) hits;
46                 uint prizePot;
47                 drawStatus_ drawStatus;
48                 bytes32 winHash;
49                 mapping(uint => tickets_s) tickets;
50                 uint ticketsCount;
51                 uint checkedTickets;
52                 bytes32 nextHashOfSecretKey;
53         }
54 
55         mapping(uint => games_s) games;
56 
57         uint public CurrentGameId = 0;
58 
59         struct player_s {
60                 bool paid;
61                 uint[] tickets;
62         }
63 
64         mapping(address => mapping(uint => player_s)) players;
65         uint playersSize;
66 
67         function ContractStatus() constant returns(bool Enabled) {
68                 Enabled = contractEnabled;
69         }
70 
71         function GameDetails(uint GameId) constant returns(
72                 uint Jackpot, uint TicketsCount, uint StartBlock, uint EndBlock) {
73                 Jackpot = games[GameId].jackpot;
74                 TicketsCount = games[GameId].ticketsCount;
75                 StartBlock = games[GameId].start;
76                 EndBlock = games[GameId].end;
77         }
78 
79         function DrawDetails(uint GameId) constant returns(
80                 bytes32 SecretKeyHash, string SecretKey, string DrawStatus, bytes32 WinHash,
81                 uint8[5] WinningNumbers, uint Hit3Count, uint Hit4Count, uint Hit5Count,
82                 uint Hit3Prize, uint Hit4Prize, uint Hit5Prize) {
83                 DrawStatus = WritedrawStatus(games[GameId].drawStatus);
84                 SecretKeyHash = games[GameId].secret_Key_Hash;
85                 if (games[GameId].drawStatus != drawStatus_.Wait) {
86                         SecretKey = games[GameId].secret_Key;
87                         WinningNumbers = games[GameId].winningNumbers;
88                         Hit3Count = games[GameId].hits[3].count;
89                         Hit4Count = games[GameId].hits[4].count;
90                         Hit5Count = games[GameId].hits[5].count;
91                         Hit3Prize = games[GameId].hits[3].prize;
92                         Hit4Prize = games[GameId].hits[4].prize;
93                         Hit5Prize = games[GameId].hits[5].prize;
94                         WinHash = games[GameId].winHash;
95                 } else {
96                         SecretKey = "";
97                         WinningNumbers = [0, 0, 0, 0, 0];
98                         Hit3Count = 0;
99                         Hit4Count = 0;
100                         Hit5Count = 0;
101                         Hit3Prize = 0;
102                         Hit4Prize = 0;
103                         Hit5Prize = 0;
104                         WinHash = 0;
105                 }
106         }
107 
108         function CheckTickets(address Address, uint GameId, uint TicketNumber) constant returns(uint8[5] Numbers, uint Hits, bool Paid) {
109                 if (players[Address][GameId].tickets[TicketNumber] > 0) {
110                         Numbers[0] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) / 256 / 256 / 256 / 256);
111                         Numbers[1] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) / 256 / 256 / 256);
112                         Numbers[2] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) / 256 / 256);
113                         Numbers[3] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) / 256);
114                         Numbers[4] = uint8(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers);
115                         Numbers = sortWinningNumbers(Numbers);
116                         Hits = games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].hits;
117                         Paid = players[Address][GameId].paid;
118                 }
119         }
120         string constant public Information = "http://c.ethereumlottery.net";
121 
122         function UserCheckBalance(address addr) constant returns(uint Balance) {
123                 for (uint a = 0; a < CurrentGameId; a++) {
124                         if (players[addr][a].paid == false) {
125                                 if (games[a].drawStatus == drawStatus_.Done) {
126                                         for (uint b = 0; b < players[addr][a].tickets.length; b++) {
127                                                 if (games[a].tickets[players[addr][a].tickets[b]].hits == 3) {
128                                                         Balance += games[a].hits[3].prize;
129                                                 } else if (games[a].tickets[players[addr][a].tickets[b]].hits == 4) {
130                                                         Balance += games[a].hits[4].prize;
131                                                 } else if (games[a].tickets[players[addr][a].tickets[b]].hits == 5) {
132                                                         Balance += games[a].hits[5].prize;
133                                                 }
134                                         }
135                                 } else if (games[a].drawStatus == drawStatus_.Failed) {
136                                         Balance += ticketPrice * players[addr][a].tickets.length;
137                                 }
138                         }
139                 }
140         }
141 
142         function cEthereumlotteryNet(bytes32 SecretKeyHash) {
143                 owner = msg.sender;
144                 CreateNewDraw(defaultJackpot, SecretKeyHash);
145                 drawerAddress = owner;
146         }
147 
148         function UserGetPrize() external {
149                 uint Balance;
150                 uint GameBalance;
151                 for (uint a = 0; a < CurrentGameId; a++) {
152                         if (players[msg.sender][a].paid == false) {
153                                 if (games[a].drawStatus == drawStatus_.Done) {
154                                         for (uint b = 0; b < players[msg.sender][a].tickets.length; b++) {
155                                                 if (games[a].tickets[players[msg.sender][a].tickets[b]].hits == 3) {
156                                                         GameBalance += games[a].hits[3].prize;
157                                                 } else if (games[a].tickets[players[msg.sender][a].tickets[b]].hits == 4) {
158                                                         GameBalance += games[a].hits[4].prize;
159                                                 } else if (games[a].tickets[players[msg.sender][a].tickets[b]].hits == 5) {
160                                                         GameBalance += games[a].hits[5].prize;
161                                                 }
162                                         }
163                                 } else if (games[a].drawStatus == drawStatus_.Failed) {
164                                         GameBalance += ticketPrice * players[msg.sender][a].tickets.length;
165                                 }
166                                 players[msg.sender][a].paid = true;
167                                 games[a].prizePot -= GameBalance;
168                                 Balance += GameBalance;
169                                 GameBalance = 0;
170                         }
171                 }
172                 if (Balance > 0) {
173                         if (msg.sender.send(Balance) == false) {
174                                 throw;
175                         }
176                 } else {
177                         throw;
178                 }
179         }
180 
181         function UserAddTicket(bytes5[] tickets) OnlyEnabled OnlyDrawWait external {
182                 uint ticketsCount = tickets.length;
183                 if (ticketsCount > 70) {
184                         throw;
185                 }
186                 if (msg.value < ticketsCount * ticketPrice) {
187                         throw;
188                 }
189                 if (msg.value > (ticketsCount * ticketPrice)) {
190                         if (msg.sender.send(msg.value - (ticketsCount * ticketPrice)) == false) {
191                                 throw;
192                         }
193                 }
194                 for (uint a = 0; a < ticketsCount; a++) {
195                         if (!CheckNumbers(ConvertNumbers(tickets[a]))) {
196                                 throw;
197                         }
198                         games[CurrentGameId].ticketsCount += 1;
199                         games[CurrentGameId].tickets[games[CurrentGameId].ticketsCount].numbers = tickets[a];
200                         players[msg.sender][CurrentGameId].tickets.length += 1;
201                         players[msg.sender][CurrentGameId].tickets[players[msg.sender][CurrentGameId].tickets.length - 1] = games[CurrentGameId].ticketsCount;
202                 }
203         }
204 
205         function() {
206                 throw;
207         }
208 
209         function AdminDrawProcess() OnlyDrawer OnlyDrawProcess {
210                 uint StepCount = drawCheckStep;
211                 if (games[CurrentGameId].checkedTickets < games[CurrentGameId].ticketsCount) {
212                         for (uint a = games[CurrentGameId].checkedTickets; a <= games[CurrentGameId].ticketsCount; a++) {
213                                 if (StepCount == 0) {
214                                         break;
215                                 }
216                                 for (uint b = 0; b < 5; b++) {
217                                         for (uint c = 0; c < 5; c++) {
218                                                 if (uint8(uint40(games[CurrentGameId].tickets[a].numbers) / (256 ** b)) == games[CurrentGameId].winningNumbers[c]) {
219                                                         games[CurrentGameId].tickets[a].hits += 1;
220                                                 }
221                                         }
222                                 }
223                                 games[CurrentGameId].checkedTickets += 1;
224                                 StepCount -= 1;
225                         }
226                 }
227                 if (games[CurrentGameId].checkedTickets >= games[CurrentGameId].ticketsCount) {
228                         //kesz
229                         for (a = 0; a < games[CurrentGameId].ticketsCount; a++) {
230                                 if (games[CurrentGameId].tickets[a].hits == 3) {
231                                         games[CurrentGameId].hits[3].count += 1;
232                                 } else if (games[CurrentGameId].tickets[a].hits == 4) {
233                                         games[CurrentGameId].hits[4].count += 1;
234                                 } else if (games[CurrentGameId].tickets[a].hits == 5) {
235                                         games[CurrentGameId].hits[5].count += 1;
236                                 }
237                         }
238                         if (games[CurrentGameId].hits[3].count > 0) {
239                                 games[CurrentGameId].hits[3].prize = games[CurrentGameId].prizePot * hit3p / 100 / games[CurrentGameId].hits[3].count;
240                         }
241                         if (games[CurrentGameId].hits[4].count > 0) {
242                                 games[CurrentGameId].hits[4].prize = games[CurrentGameId].prizePot * hit4p / 100 / games[CurrentGameId].hits[4].count;
243                         }
244                         if (games[CurrentGameId].hits[5].count > 0) {
245                                 games[CurrentGameId].hits[5].prize = games[CurrentGameId].jackpot / games[CurrentGameId].hits[5].count;
246                         }
247                         uint NextJackpot;
248                         if (games[CurrentGameId].hits[5].count == 0) {
249                                 NextJackpot = games[CurrentGameId].prizePot * hit5p / 100 + games[CurrentGameId].jackpot;
250                         } else {
251                                 NextJackpot = defaultJackpot;
252                         }
253                         games[CurrentGameId].drawStatus = drawStatus_.Done;
254                         CreateNewDraw(NextJackpot, games[CurrentGameId].nextHashOfSecretKey);
255                 }
256         }
257 
258         function AdminDrawError() external OnlyDrawer OnlyDrawProcess {
259                 games[CurrentGameId].prizePot = games[CurrentGameId].ticketsCount * ticketPrice;
260                 games[CurrentGameId].drawStatus = drawStatus_.Failed;
261                 CreateNewDraw(games[CurrentGameId].jackpot, games[CurrentGameId].nextHashOfSecretKey);
262         }
263 
264         function AdminStartDraw(string secret_Key, bytes32 New_secret_Key_Hash) external OnlyDrawer OnlyDrawWait returns(uint ret) {
265                 games[CurrentGameId].end = block.number;
266                 if (sha3(secret_Key) != games[CurrentGameId].secret_Key_Hash) {
267                         games[CurrentGameId].prizePot = games[CurrentGameId].ticketsCount * ticketPrice;
268                         games[CurrentGameId].drawStatus = drawStatus_.Failed;
269                         games[CurrentGameId].secret_Key = secret_Key;
270                         CreateNewDraw(games[CurrentGameId].jackpot, New_secret_Key_Hash);
271                         return;
272                 }
273                 games[CurrentGameId].drawStatus = drawStatus_.InProcess;
274                 games[CurrentGameId].nextHashOfSecretKey = New_secret_Key_Hash;
275                 games[CurrentGameId].secret_Key = secret_Key;
276                 games[CurrentGameId].winHash = sha3(games[CurrentGameId].secret_Key, games[CurrentGameId].secret_Key_Hash, games[CurrentGameId].ticketsCount, now);
277                 games[CurrentGameId].winningNumbers = sortWinningNumbers(GetNumbersFromHash(games[CurrentGameId].winHash));
278                 if (games[CurrentGameId].ticketsCount > 1) {
279                         feeValue += ticketPrice * games[CurrentGameId].ticketsCount * feep / 100;
280                         games[CurrentGameId].prizePot = ticketPrice * games[CurrentGameId].ticketsCount - feeValue;
281                         AdminDrawProcess();
282                 } else {
283                         games[CurrentGameId].drawStatus = drawStatus_.Done;
284                 }
285         }
286 
287         function AdminSetDrawer(address NewDrawer) external OnlyOwner {
288                 drawerAddress = NewDrawer;
289         }
290 
291         function AdminCloseContract() OnlyOwner external {
292                 if (!contractEnabled) {
293                         if (games[CurrentGameId].ticketsCount == 0) {
294                                 uint contractbalance = this.balance;
295                                 for (uint a = 0; a < CurrentGameId; a++) {
296                                         contractbalance -= games[a].prizePot;
297                                 }
298                                 contractbalance += games[a].jackpot - defaultJackpot;
299                                 if (owner.send(contractbalance) == false) {
300                                         throw;
301                                 }
302                                 feeValue = 0;
303                         } else {
304                                 throw;
305                         }
306                 } else {
307                         contractEnabled = false;
308                 }
309         }
310 
311         function AdminAddFunds() OnlyOwner {
312                 return;
313         }
314 
315         function AdminGetFee() OnlyOwner {
316                 if (owner.send(feeValue) == false) {
317                         throw;
318                 }
319                 feeValue = 0;
320         }
321 
322         modifier OnlyDrawer() {
323                 if ((drawerAddress != msg.sender) && (owner != msg.sender)) {
324                         throw;
325                 }
326                 _
327         }
328 
329         modifier OnlyOwner() {
330                 if (owner != msg.sender) {
331                         throw;
332                 }
333                 _
334         }
335 
336         modifier OnlyEnabled() {
337                 if (!contractEnabled) {
338                         throw;
339                 }
340                 _
341         }
342 
343         modifier OnlyDrawWait() {
344                 if (games[CurrentGameId].drawStatus != drawStatus_.Wait) {
345                         throw;
346                 }
347                 _
348         }
349 
350         modifier OnlyDrawProcess() {
351                 if (games[CurrentGameId].drawStatus != drawStatus_.InProcess) {
352                         throw;
353                 }
354                 _
355         }
356 
357         function CreateNewDraw(uint Jackpot, bytes32 SecretKeyHash) internal {
358                 CurrentGameId += 1;
359                 games[CurrentGameId].start = block.number;
360                 games[CurrentGameId].jackpot = Jackpot;
361                 games[CurrentGameId].secret_Key_Hash = SecretKeyHash;
362                 games[CurrentGameId].drawStatus = drawStatus_.Wait;
363         }
364 
365         function ConvertNumbers(bytes5 input) internal returns(uint8[5] output) {
366                 output[0] = uint8(uint40(input) / 256 / 256 / 256 / 256);
367                 output[1] = uint8(uint40(input) / 256 / 256 / 256);
368                 output[2] = uint8(uint40(input) / 256 / 256);
369                 output[3] = uint8(uint40(input) / 256);
370                 output[4] = uint8(input);
371         }
372 
373         function CheckNumbers(uint8[5] tickets) internal returns(bool ok) {
374                 for (uint8 a = 0; a < 5; a++) {
375                         if ((tickets[a] < 1) || (tickets[a] > maxNumber)) {
376                                 return false;
377                         }
378                         for (uint8 b = 0; b < 5; b++) {
379                                 if ((tickets[a] == tickets[b]) && (a != b)) {
380                                         return false;
381                                 }
382                         }
383                 }
384                 return true;
385         }
386 
387         function GetNumbersFromHash(bytes32 hash) internal returns(uint8[5] tickets) {
388                 bool ok = true;
389                 uint8 num = 0;
390                 uint hashpos = 0;
391                 uint8 a;
392                 for (a = 0; a < 5; a++) {
393                         while (true) {
394                                 ok = true;
395                                 if (hashpos == 32) {
396                                         hashpos = 0;
397                                         hash = sha3(hash);
398                                 }
399                                 num = GetPart(hash, hashpos);
400                                 num = num % maxNumber + 1;
401                                 hashpos += 1;
402                                 for (uint8 b = 0; b < 5; b++) {
403                                         if (tickets[b] == num) {
404                                                 ok = false;
405                                                 break;
406                                         }
407                                 }
408                                 if (ok == true) {
409                                         tickets[a] = num;
410                                         break;
411                                 }
412                         }
413                 }
414         }
415 
416         function GetPart(bytes32 a, uint i) internal returns(uint8) {
417                 return uint8(byte(bytes32(uint(a) * 2 ** (8 * i))));
418         }
419 
420         function WritedrawStatus(drawStatus_ input) internal returns(string drawStatus) {
421                 if (input == drawStatus_.Wait) {
422                         drawStatus = "Wait";
423                 } else if (input == drawStatus_.InProcess) {
424                         drawStatus = "In Process";
425                 } else if (input == drawStatus_.Done) {
426                         drawStatus = "Done";
427                 } else if (input == drawStatus_.Failed) {
428                         drawStatus = "Failed";
429                 }
430         }
431 
432         function sortWinningNumbers(uint8[5] numbers) internal returns(uint8[5] sortednumbers) {
433                 sortednumbers = numbers;
434                 for (uint8 i = 0; i < 5; i++) {
435                         for (uint8 j = i + 1; j < 5; j++) {
436                                 if (sortednumbers[i] > sortednumbers[j]) {
437                                         uint8 t = sortednumbers[i];
438                                         sortednumbers[i] = sortednumbers[j];
439                                         sortednumbers[j] = t;
440                                 }
441                         }
442                 }
443         }
444 }