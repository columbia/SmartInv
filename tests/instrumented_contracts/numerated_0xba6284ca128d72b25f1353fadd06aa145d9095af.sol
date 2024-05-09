1 contract Ethstick {
2     
3 //COPYRIGHT 2016 KATATSUKI ALL RIGHTS RESERVED
4 //No part of this source code may be reproduced, distributed,
5 //modified or transmitted in any form or by any means without
6 //the prior written permission of the creator.
7     
8     address private pig;
9     
10     //Stored variables
11     uint private balance = 0;
12     uint private maxDeposit = 5;
13     uint private fee = 0;
14     uint private multiplier = 120;
15     uint private payoutOrder = 0;
16     uint private donkeysInvested = 0;
17     uint private investmentRecord = 0;
18     uint private carrots = 0;
19     uint private eligibleForFees = 5;
20     address private donkeyKing = 0x0;
21     
22     mapping (address => Donkey) private donkeys;
23     Entry[] private entries;
24     
25     Donkey[] private ranking;
26     
27     event NewKing(address ass);
28     
29     //Set owner on contract creation
30     function Ethstick() {
31         pig = msg.sender;
32         ranking.length = 10;
33     }
34 
35     modifier onlypig { if (msg.sender == pig) _ }
36     
37     struct Donkey {
38         address addr;
39         string nickname;
40         uint invested;
41     }
42     
43     struct Entry {
44         address entryAddress;
45         uint deposit;
46         uint payout;
47         bool paid;
48     }
49 
50     //Fallback function
51     function() {
52         init();
53     }
54     
55     function init() private{
56         //Only deposits >0.1ETH are allowed to join
57         if (msg.value < 100 finney) {
58             msg.sender.send(msg.value);
59             return;
60         }
61         
62         chase();
63     }
64     
65     //Chase the carrot
66     function chase() private {
67         
68         //Limit deposits to XETH
69         uint dValue = 100 finney;
70         if (msg.value > maxDeposit * 1 ether) {
71             
72         	msg.sender.send(msg.value - maxDeposit * 1 ether);	
73         	dValue = maxDeposit * 1 ether;
74         }
75         else { dValue = msg.value; }
76 
77         //Add new users to the users array if he's a new player
78         addNewDonkey(msg.sender);
79         
80         //Add new entry to the entries array 
81         entries.push(Entry(msg.sender, dValue, (dValue * (multiplier) / 100), false));
82            
83         //Update contract stats
84         balance += (dValue * (100 - fee)) / 100;
85         donkeysInvested += dValue;
86         donkeys[msg.sender].invested += dValue;
87         
88         
89         //Ranking logic: mindfuck edition
90         uint index = ranking.length - 1;
91         uint newEntry = donkeys[msg.sender].invested;
92         bool done = false;
93         bool samePosition = false;
94         uint existingAt = ranking.length - 1;
95 
96         while (ranking[index].invested < newEntry && !done)
97         {
98             if (index > 0)
99             {
100                 done = donkeys[ranking[index - 1].addr].invested > newEntry;
101                 
102                 if (ranking[index].addr == msg.sender)
103                     existingAt = index;
104                 
105                 if (done)
106                 {
107                     if (ranking[index].addr == msg.sender)
108                     { 
109                         ranking[index] = donkeys[msg.sender];
110                         samePosition = true;
111                     }
112                 }
113               
114                 if (!done) index--;
115             }
116             else
117             {
118                 done = true;
119                 index = 0;
120                 if (ranking[index].addr == msg.sender || ranking[index].addr == address(0x0))
121                 {
122                     ranking[index] = donkeys[msg.sender];
123                     samePosition = true;
124                 }
125             }
126             
127         }
128         
129         if (!samePosition)
130         {
131             rankDown(index, existingAt);
132             ranking[index] = donkeys[msg.sender];
133         }
134         
135         
136         //Pay pending entries if the new balance allows for it
137         while (balance > entries[payoutOrder].payout) {
138             
139             uint payout = entries[payoutOrder].payout;
140             
141             entries[payoutOrder].entryAddress.send(payout);
142             entries[payoutOrder].paid = true;
143 
144             balance -= payout;
145             
146             carrots++;
147             payoutOrder++;
148         }
149         
150         //Collect money from fees and possible leftovers from errors (actual balance untouched)
151         uint fees = this.balance - balance;
152         if (fees > 0)
153         {
154             if (entries.length >= 50 && entries.length % 5 == 0)
155             {
156                 fees = dValue * fee / 100;
157                 uint luckyDonkey = rand(eligibleForFees) - 1;
158                 
159                 if (ranking[luckyDonkey].addr != address(0x0))
160                     ranking[luckyDonkey].addr.send(fees);
161                 else
162                     donkeyKing.send(fees);
163             }
164             else
165                 pig.send(fees);
166         }        
167         
168         //Check for new Donkey King
169         if (donkeys[msg.sender].invested > investmentRecord)
170         {
171             donkeyKing = msg.sender;
172             NewKing(msg.sender);
173             investmentRecord = donkeys[msg.sender].invested;
174             
175         }
176         
177         if (ranking[0].addr != donkeys[donkeyKing].addr && ranking[0].addr != address(0x0))
178         {
179             ranking[1] = donkeys[ranking[0].addr];
180             ranking[0] = donkeys[donkeyKing];
181         }
182         
183     }
184     
185     function rankDown(uint index, uint offset) private
186     {
187         for (uint i = offset; i > index; i--)
188         {
189             ranking[i] = donkeys[ranking[i-1].addr];
190         }
191     }
192     
193     function addNewDonkey(address Address) private
194     {
195         if (donkeys[Address].addr == address(0))
196         {
197             donkeys[Address].addr = Address;
198             donkeys[Address].nickname = 'GullibleDonkey';
199             donkeys[Address].invested = 0;
200         }
201     }
202     
203     //Generate random number between 1 & max
204     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
205     function rand(uint max) constant private returns (uint256 result){
206         uint256 factor = FACTOR * 100 / max;
207         uint256 lastBlockNumber = block.number - 1;
208         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
209     
210         return uint256((uint256(hashVal) / factor)) % max + 1;
211     }
212     
213 
214     //Contract management
215     function changePig(address newPig) onlypig {
216         pig = newPig;
217     }
218     
219     
220     function changeMultiplier(uint multi) onlypig {
221         if (multi < 110 || multi > 130) 
222             throw;
223         
224         multiplier = multi;
225     }
226     
227     function changeFee(uint newFee) onlypig {
228         if (newFee > 5) 
229             throw;
230         
231         fee = newFee;
232     }
233     
234     function changeMaxDeposit(uint max) onlypig {
235         if (max < 1 || max > 10)
236             throw;
237             
238         maxDeposit = max;
239     }
240     
241     function changeRankingSize(uint size) onlypig {
242         if (size < 5 || size > 100)
243             throw;
244             
245         ranking.length = size;
246     }
247     
248     function changeEligibleDonkeys(uint number) onlypig {
249         if (number < 5 || number > 15)
250             throw;
251             
252         eligibleForFees = number;
253     }
254     
255     
256     //JSON functions
257     function setNickname(string name) {
258         addNewDonkey(msg.sender);
259         
260         if (bytes(name).length >= 2 && bytes(name).length <= 16)
261             donkeys[msg.sender].nickname = name;
262     }
263     
264     function carrotsCaught() constant returns (uint amount, string info) {
265         amount = carrots;
266         info = 'The number of payouts sent to participants.';
267     }
268     
269     function currentBalance() constant returns (uint theBalance, string info) {
270         theBalance = balance / 1 finney;
271         info = 'The balance of the contract in Finneys.';
272     }
273     
274     function theDonkeyKing() constant returns (address king, string nickname, uint totalInvested, string info) {
275         king = donkeyKing;  
276         nickname = donkeys[donkeyKing].nickname;
277         totalInvested = donkeys[donkeyKing].invested / 1 ether;
278         info = 'The greediest of all donkeys. You go, ass!';
279     }
280     
281     function donkeyName(address Address) constant returns (string nickname) {
282         nickname = donkeys[Address].nickname;
283     }
284     
285     function currentMultiplier() constant returns (uint theMultiplier, string info) {
286         theMultiplier = multiplier;
287         info = 'The multiplier applied to all deposits (x100). It determines the amount of money you will get when you catch the carrot.';
288     }
289     
290     function generousFee() constant returns (uint feePercentage, string info) {
291         feePercentage = fee;
292         info = 'The generously modest fee percentage applied to all deposits. It can change to lure more donkeys (max 5%).';
293     }
294     
295     function nextPayoutGoal() constant returns (uint finneys, string info) {
296         finneys = (entries[payoutOrder].payout - balance) / 1 finney;
297         info = 'The amount of Finneys (Ethers * 1000) that need to be deposited for the next donkey to catch his carrot.';
298     }
299     
300     function totalEntries() constant returns (uint count, string info) {
301         count = entries.length;
302         info = 'The number of times the carrot was chased by gullible donkeys.';
303     }
304     
305     function entryDetails(uint index) constant returns (address donkey, string nickName, uint deposit, uint payout, bool paid, string info)
306     {
307         if (index < entries.length || index == 0 && entries.length > 0) {
308             donkey = entries[index].entryAddress;
309             nickName = donkeys[entries[index].entryAddress].nickname;
310             deposit = entries[index].deposit / 1 finney;
311             payout = entries[index].payout / 1 finney;
312             paid = entries[index].paid;
313             info = 'Entry info: donkey address, name, deposit, expected payout in Finneys, payout status.';
314         }
315     }
316     
317     function donkeyRanking(uint index) constant returns(address donkey, string nickname, uint totalInvested, string info)
318     {
319         if (index < ranking.length)
320         {
321             donkey = ranking[index].addr;
322             nickname = donkeys[ranking[index].addr].nickname;
323             totalInvested = donkeys[ranking[index].addr].invested / 1 ether;
324             info = 'Top donkey stats: address, name, ethers deposited. Lower index number means higher rank.';
325         }
326     }
327     
328     function donkeyInvested(address donkey) constant returns(uint invested, string info) {
329         invested = donkeys[donkey].addr != address(0x0) ? donkeys[donkey].invested / 1 ether : 0;
330         info = 'The amount of Ethers the donkey has chased carrots with.';
331     }
332     
333     function totalInvested() constant returns(uint invested, string info) {
334         invested = donkeysInvested / 1 ether;
335         info = 'The combined investments of all donkeys in Ethers.';
336     }
337     
338     function currentDepositLimit() constant returns(uint ethers, string info) {
339         ethers = maxDeposit;
340         info = 'The current maximum number of Ethers you may deposit at once.';
341     }
342     
343     function donkeysEligibleForFees() constant returns(uint top, string info) {
344         top = eligibleForFees;
345         info = 'The number of donkeys in the ranking that are eligible to receive fees.';
346     }
347     
348 }