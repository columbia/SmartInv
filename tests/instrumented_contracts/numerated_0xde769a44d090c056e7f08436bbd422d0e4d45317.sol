1 pragma solidity ^0.4.6;                                                                                                                                                                                            
2                                                                                                                                                                                                                    
3 // --------------------------                                                                                                                                                                                      
4 //  D Split Contract                                                                                                                                                                                               
5 // --------------------------                                                                                                                                                                                      
6 contract DSPLT_A {                                                                                                                                                                                                 
7         event StatEvent(string msg);                                                                                                                                                                               
8         event StatEventI(string msg, uint val);                                                                                                                                                                    
9                                                                                                                                                                                                                    
10         enum SettingStateValue  {debug, locked}                                                                                                                                                                    
11                                                                                                                                                                                                                    
12         struct partnerAccount {                                                                                                                                                                                    
13                 uint credited;  // total funds credited to this account                                                                                                                                            
14                 uint balance;   // current balance = credited - amount withdrawn                                                                                                                                   
15                 uint pctx10;     // percent allocation times ten                                                                                                                                                   
16                 address addr;   // payout addr of this acct                                                                                                                                                        
17                 bool evenStart; // even split up to evenDistThresh                                                                                                                                                 
18         }                                                                                                                                                                                                          
19                                                                                                                                                                                                                    
20 // -----------------------------                                                                                                                                                                                   
21 //  data storage                                                                                                                                                                                                   
22 // ----------------------------------------                                                                                                                                                                        
23         address public owner;                                // deployer executor                                                                                                                                  
24         mapping (uint => partnerAccount) partnerAccounts;    // accounts by index                                                                                                                                  
25         uint public numAccounts;                             // how many accounts exist                                                                                                                            
26         uint public holdoverBalance;                         // amount yet to be distributed                                                                                                                       
27         uint public totalFundsReceived;                      // amount received since begin of time                                                                                                                
28         uint public totalFundsDistributed;                   // amount distributed since begin of time                                                                                                             
29         uint public totalFundsWithdrawn;                     // amount withdrawn since begin of time                                                                                                               
30         uint public evenDistThresh;                          // distribute evenly until this amount (total)                                                                                                        
31         uint public withdrawGas = 35000;                     // gas for withdrawals                                                                                                                                
32         uint constant TENHUNDWEI = 1000;                     // need gt. 1000 wei to do payout
33         uint constant MAX_ACCOUNTS = 5;                      // max accounts this contract can handle
34         SettingStateValue public settingsState = SettingStateValue.debug; 
35 
36 
37         // --------------------
38         // contract constructor
39         // --------------------
40         function DSPLT_A() {
41                 owner = msg.sender;
42         }
43 
44 
45         // -----------------------------------
46         // lock
47         // lock the contract. after calling this you will not be able to modify accounts.
48         // make sure everyhting is right!
49         // -----------------------------------
50         function lock() {
51                 if (msg.sender != owner) {
52                         StatEvent("err: not owner");
53                         return;
54                 }
55                 if (settingsState == SettingStateValue.locked) {
56                         StatEvent("err: locked");
57                         return;
58                 }
59                 settingsState = SettingStateValue.locked;
60                 StatEvent("ok: contract locked");
61         }
62 
63 
64         // -----------------------------------
65         // reset
66         // reset all accounts
67         // in case we have any funds that have not been withdrawn, they become
68         // newly received and undistributed.
69         // -----------------------------------
70         function reset() {
71                 if (msg.sender != owner) {
72                         StatEvent("err: not owner");
73                         return;
74                 }
75                 if (settingsState == SettingStateValue.locked) {
76                         StatEvent("err: locked");
77                         return;
78                 }
79                 for (uint i = 0; i < numAccounts; i++ ) {
80                         holdoverBalance += partnerAccounts[i].balance;
81                 }
82                 totalFundsReceived = holdoverBalance;
83                 totalFundsDistributed = 0;
84                 totalFundsWithdrawn = 0;
85                 numAccounts = 0;
86                 StatEvent("ok: all accts reset");
87         }
88 
89 
90         // -----------------------------------
91         // set even distribution threshold
92         // -----------------------------------
93         function setEvenDistThresh(uint256 _thresh) {
94                 if (msg.sender != owner) {
95                         StatEvent("err: not owner");
96                         return;
97                 }
98                 if (settingsState == SettingStateValue.locked) {
99                         StatEvent("err: locked");
100                         return;
101                 }
102                 evenDistThresh = (_thresh / TENHUNDWEI) * TENHUNDWEI;
103                 StatEventI("ok: threshold set", evenDistThresh);
104         }
105 
106 
107         // -----------------------------------
108         // set even distribution threshold
109         // -----------------------------------
110         function setWitdrawGas(uint256 _withdrawGas) {
111                 if (msg.sender != owner) {
112                         StatEvent("err: not owner");
113                         return;
114                 }
115                 withdrawGas = _withdrawGas;
116                 StatEventI("ok: withdraw gas set", withdrawGas);
117         }
118 
119 
120         // ---------------------------------------------------
121         // add a new account
122         // ---------------------------------------------------
123         function addAccount(address _addr, uint256 _pctx10, bool _evenStart) {
124                 if (msg.sender != owner) {
125                         StatEvent("err: not owner");
126                         return;
127                 }
128                 if (settingsState == SettingStateValue.locked) {
129                         StatEvent("err: locked");
130                         return;
131                 }
132                 if (numAccounts >= MAX_ACCOUNTS) {
133                         StatEvent("err: max accounts");
134                         return;
135                 }
136                 partnerAccounts[numAccounts].addr = _addr;
137                 partnerAccounts[numAccounts].pctx10 = _pctx10;
138                 partnerAccounts[numAccounts].evenStart = _evenStart;
139                 partnerAccounts[numAccounts].credited = 0;
140                 partnerAccounts[numAccounts].balance = 0;
141                 ++numAccounts;
142                 StatEvent("ok: acct added");
143         }
144 
145 
146         // ----------------------------
147         // get acct info
148         // ----------------------------
149         function getAccountInfo(address _addr) constant returns(uint _idx, uint _pctx10, bool _evenStart, uint _credited, uint _balance) {
150                 for (uint i = 0; i < numAccounts; i++ ) {
151                         address addr = partnerAccounts[i].addr;
152                         if (addr == _addr) {
153                                 _idx = i;
154                                 _pctx10 = partnerAccounts[i].pctx10;
155                                 _evenStart = partnerAccounts[i].evenStart;
156                                 _credited = partnerAccounts[i].credited;
157                                 _balance = partnerAccounts[i].balance;
158                                 StatEvent("ok: found acct");
159                                 return;
160                         }
161                 }
162                 StatEvent("err: acct not found");
163         }
164 
165 
166         // ----------------------------
167         // get total percentages x10
168         // ----------------------------
169         function getTotalPctx10() constant returns(uint _totalPctx10) {
170                 _totalPctx10 = 0;
171                 for (uint i = 0; i < numAccounts; i++ ) {
172                         _totalPctx10 += partnerAccounts[i].pctx10;
173                 }
174                 StatEventI("ok: total pctx10", _totalPctx10);
175         }
176 
177 
178         // ----------------------------
179         // get no. accts that are set for even split
180         // ----------------------------
181         function getNumEvenSplits() constant returns(uint _numEvenSplits) {
182                 _numEvenSplits = 0;
183                 for (uint i = 0; i < numAccounts; i++ ) {
184                         if (partnerAccounts[i].evenStart) {
185                                 ++_numEvenSplits;
186                         }
187                 }
188                 StatEventI("ok: even splits", _numEvenSplits);
189         }
190 
191 
192         // -------------------------------------------
193         // default payable function.
194         // call us with plenty of gas, or catastrophe will ensue
195         // note: you can call this fcn with amount of zero to force distribution
196         // -------------------------------------------
197         function () payable {
198                 totalFundsReceived += msg.value;
199                 holdoverBalance += msg.value;
200                 StatEventI("ok: incoming", msg.value);
201         }
202 
203 
204         // ----------------------------
205         // distribute funds to all partners
206         // ----------------------------
207         function distribute() {
208                 //only payout if we have more than 1000 wei
209                 if (holdoverBalance < TENHUNDWEI) {
210                         return;
211                 }
212                 //first pay accounts that are not constrained by even distribution
213                 //each account gets their prescribed percentage of this holdover.
214                 uint i;
215                 uint pctx10;
216                 uint acctDist;
217                 uint maxAcctDist;
218                 uint numEvenSplits = 0;
219                 for (i = 0; i < numAccounts; i++ ) {
220                         if (partnerAccounts[i].evenStart) {
221                                 ++numEvenSplits;
222                         } else {
223                                 pctx10 = partnerAccounts[i].pctx10;
224                                 acctDist = holdoverBalance * pctx10 / TENHUNDWEI;
225                                 //we also double check to ensure that the amount awarded cannot exceed the
226                                 //total amount due to this acct. note: this check is necessary, cuz here we
227                                 //might not distribute the full holdover amount during each pass.
228                                 maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
229                                 if (partnerAccounts[i].credited >= maxAcctDist) {
230                                         acctDist = 0;
231                                 } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
232                                         acctDist = maxAcctDist - partnerAccounts[i].credited;
233                                 }
234                                 partnerAccounts[i].credited += acctDist;
235                                 partnerAccounts[i].balance += acctDist;
236                                 totalFundsDistributed += acctDist;
237                                 holdoverBalance -= acctDist;
238                         }
239                 }
240                 //now pay accounts that are constrained by even distribution. we split whatever is
241                 //left of the holdover evenly.
242                 uint distAmount = holdoverBalance;
243                 if (totalFundsDistributed < evenDistThresh) {
244                         for (i = 0; i < numAccounts; i++ ) {
245                                 if (partnerAccounts[i].evenStart) {
246                                         acctDist = distAmount / numEvenSplits;
247                                         //we also double check to ensure that the amount awarded cannot exceed the
248                                         //total amount due to this acct. note: this check is necessary, cuz here we
249                                         //might not distribute the full holdover amount during each pass.
250                                         uint fundLimit = totalFundsReceived;
251                                         if (fundLimit > evenDistThresh)
252                                                 fundLimit = evenDistThresh;
253                                         maxAcctDist = fundLimit / numEvenSplits;
254                                         if (partnerAccounts[i].credited >= maxAcctDist) {
255                                                 acctDist = 0;
256                                         } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
257                                                 acctDist = maxAcctDist - partnerAccounts[i].credited;
258                                         }
259                                         partnerAccounts[i].credited += acctDist;
260                                         partnerAccounts[i].balance += acctDist;
261                                         totalFundsDistributed += acctDist;
262                                         holdoverBalance -= acctDist;
263                                 }
264                         }
265                 }
266                 //now, if there are any funds left then it means that we have either exceeded the even distribution threshold,
267                 //or there is a remainder in the even split. in that case distribute all the remmaing funds to partners who have
268                 //not yet exceeded their allotment, according to their "effective" percentages. note that this must be done here,
269                 //even if we haven't passed the even distribution threshold, to ensure that we don't get stuck with a remainder
270                 //amount that cannot be distributed.
271                 distAmount = holdoverBalance;
272                 if (distAmount > 0) {
273                         uint totalDistPctx10 = 0;
274                         for (i = 0; i < numAccounts; i++ ) {
275                                 pctx10 = partnerAccounts[i].pctx10;
276                                 maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
277                                 if (partnerAccounts[i].credited < maxAcctDist) {
278                                         totalDistPctx10 += pctx10;
279                                 }
280                         }
281                         for (i = 0; i < numAccounts; i++ ) {
282                                 pctx10 = partnerAccounts[i].pctx10;
283                                 acctDist = distAmount * pctx10 / totalDistPctx10;
284                                 //we also double check to ensure that the amount awarded cannot exceed the
285                                 //total amount due to this acct. note: this check is necessary, cuz here we
286                                 //might not distribute the full holdover amount during each pass.
287                                 maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
288                                 if (partnerAccounts[i].credited >= maxAcctDist) {
289                                         acctDist = 0;
290                                 } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
291                                         acctDist = maxAcctDist - partnerAccounts[i].credited;
292                                 }
293                                 partnerAccounts[i].credited += acctDist;
294                                 partnerAccounts[i].balance += acctDist;
295                                 totalFundsDistributed += acctDist;
296                                 holdoverBalance -= acctDist;
297                         }
298                 }
299                 StatEvent("ok: distributed funds");
300         }
301 
302 
303         // ----------------------------
304         // withdraw account balance
305         // ----------------------------
306         function withdraw() {
307                 for (uint i = 0; i < numAccounts; i++ ) {
308                         address addr = partnerAccounts[i].addr;
309                         if (addr == msg.sender) {
310                                 uint amount = partnerAccounts[i].balance;
311                                 if (amount == 0) { 
312                                         StatEvent("err: balance is zero");
313                                 } else {
314                                         partnerAccounts[i].balance = 0;
315                                         totalFundsWithdrawn += amount;
316                                         if (!msg.sender.call.gas(withdrawGas).value(amount)())
317                                                 throw;
318                                         StatEventI("ok: rewards paid", amount);
319                                 }
320                         }
321                 }
322         }
323 
324 
325         // ----------------------------
326         // suicide
327         // ----------------------------
328         function hariKari() {
329                 if (msg.sender != owner) {
330                         StatEvent("err: not owner");
331                         return;
332                 }
333                 if (settingsState == SettingStateValue.locked) {
334                         StatEvent("err: locked");
335                         return;
336                 }
337                 suicide(owner);
338         }
339 
340 }