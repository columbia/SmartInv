1 pragma solidity ^0.4.6;
2 
3 // --------------------------
4 //  R Split Contract
5 // --------------------------
6 contract RSPLT_F {
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
40         function RSPLT_F() {
41                 owner = msg.sender;
42         }
43 
44 
45         // -----------------------------------
46         // lock
47         // lock the contract. after calling this you will not be able to modify accounts:
48         // -----------------------------------
49         function lock() {
50                 if (msg.sender != owner) {
51                         StatEvent("err: not owner");
52                         return;
53                 }
54                 if (settingsState == SettingStateValue.locked) {
55                         StatEvent("err: locked");
56                         return;
57                 }
58                 settingsState = SettingStateValue.locked;
59                 StatEvent("ok: contract locked");
60         }
61 
62 
63         // -----------------------------------
64         // reset
65         // reset all accounts
66         // -----------------------------------
67         function reset() {
68                 if (msg.sender != owner) {
69                         StatEvent("err: not owner");
70                         return;
71                 }
72                 if (settingsState == SettingStateValue.locked) {
73                         StatEvent("err: locked");
74                         return;
75                 }
76                 numAccounts = 0;
77                 holdoverBalance = 0;
78                 totalFundsReceived = 0;
79                 totalFundsDistributed = 0;
80                 totalFundsWithdrawn = 0;
81                 StatEvent("ok: all accts reset");
82         }
83 
84 
85         // -----------------------------------
86         // set even distribution threshold
87         // -----------------------------------
88         function setEvenDistThresh(uint256 _thresh) {
89                 if (msg.sender != owner) {
90                         StatEvent("err: not owner");
91                         return;
92                 }
93                 if (settingsState == SettingStateValue.locked) {
94                         StatEvent("err: locked");
95                         return;
96                 }
97                 evenDistThresh = (_thresh / TENHUNDWEI) * TENHUNDWEI;
98                 StatEventI("ok: threshold set", evenDistThresh);
99         }
100 
101 
102         // -----------------------------------
103         // set even distribution threshold
104         // -----------------------------------
105         function setWitdrawGas(uint256 _withdrawGas) {
106                 if (msg.sender != owner) {
107                         StatEvent("err: not owner");
108                         return;
109                 }
110                 withdrawGas = _withdrawGas;
111                 StatEventI("ok: withdraw gas set", withdrawGas);
112         }
113 
114 
115         // ---------------------------------------------------
116         // add a new account
117         // ---------------------------------------------------
118         function addAccount(address _addr, uint256 _pctx10, bool _evenStart) {
119                 if (msg.sender != owner) {
120                         StatEvent("err: not owner");
121                         return;
122                 }
123                 if (settingsState == SettingStateValue.locked) {
124                         StatEvent("err: locked");
125                         return;
126                 }
127                 if (numAccounts >= MAX_ACCOUNTS) {
128                         StatEvent("err: max accounts");
129                         return;
130                 }
131                 partnerAccounts[numAccounts].addr = _addr;
132                 partnerAccounts[numAccounts].pctx10 = _pctx10;
133                 partnerAccounts[numAccounts].evenStart = _evenStart;
134                 partnerAccounts[numAccounts].credited = 0;
135                 partnerAccounts[numAccounts].balance = 0;
136                 ++numAccounts;
137                 StatEvent("ok: acct added");
138         }
139 
140 
141         // ----------------------------
142         // get acct info
143         // ----------------------------
144         function getAccountInfo(address _addr) constant returns(uint _idx, uint _pctx10, bool _evenStart, uint _credited, uint _balance) {
145                 for (uint i = 0; i < numAccounts; i++ ) {
146                         address addr = partnerAccounts[i].addr;
147                         if (addr == _addr) {
148                                 _idx = i;
149                                 _pctx10 = partnerAccounts[i].pctx10;
150                                 _evenStart = partnerAccounts[i].evenStart;
151                                 _credited = partnerAccounts[i].credited;
152                                 _balance = partnerAccounts[i].balance;
153                                 StatEvent("ok: found acct");
154                                 return;
155                         }
156                 }
157                 StatEvent("err: acct not found");
158         }
159 
160 
161         // ----------------------------
162         // get total percentages x10
163         // ----------------------------
164         function getTotalPctx10() constant returns(uint _totalPctx10) {
165                 _totalPctx10 = 0;
166                 for (uint i = 0; i < numAccounts; i++ ) {
167                         _totalPctx10 += partnerAccounts[i].pctx10;
168                 }
169                 StatEventI("ok: total pctx10", _totalPctx10);
170         }
171 
172 
173         // ----------------------------
174         // get no. accts that are set for even split
175         // ----------------------------
176         function getNumEvenSplits() constant returns(uint _numEvenSplits) {
177                 _numEvenSplits = 0;
178                 for (uint i = 0; i < numAccounts; i++ ) {
179                         if (partnerAccounts[i].evenStart) {
180                                 ++_numEvenSplits;
181                         }
182                 }
183                 StatEventI("ok: even splits", _numEvenSplits);
184         }
185 
186 
187         // -------------------------------------------
188         // default payable function.
189         // call us with plenty of gas, or catastrophe will ensue
190         // note: you can call this fcn with amount of zero to force distribution
191         // -------------------------------------------
192         function () payable {
193                 totalFundsReceived += msg.value;
194                 holdoverBalance += msg.value;
195                 StatEventI("ok: incoming", msg.value);
196         }
197 
198 
199         // ----------------------------
200         // distribute funds to all partners
201         // ----------------------------
202         function distribute() {
203                 //only payout if we have more than 1000 wei
204                 if (holdoverBalance < TENHUNDWEI) {
205                         return;
206                 }
207                 //first pay accounts that are not constrained by even distribution
208                 //each account gets their prescribed percentage of this holdover.
209                 uint i;
210                 uint pctx10;
211                 uint acctDist;
212                 uint maxAcctDist;
213                 uint numEvenSplits = 0;
214                 for (i = 0; i < numAccounts; i++ ) {
215                         if (partnerAccounts[i].evenStart) {
216                                 ++numEvenSplits;
217                         } else {
218                                 pctx10 = partnerAccounts[i].pctx10;
219                                 acctDist = holdoverBalance * pctx10 / TENHUNDWEI;
220                                 //we also double check to ensure that the amount awarded cannot exceed the
221                                 //total amount due to this acct. note: this check is necessary, cuz here we
222                                 //might not distribute the full holdover amount during each pass.
223                                 maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
224                                 if (partnerAccounts[i].credited >= maxAcctDist) {
225                                         acctDist = 0;
226                                 } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
227                                         acctDist = maxAcctDist - partnerAccounts[i].credited;
228                                 }
229                                 partnerAccounts[i].credited += acctDist;
230                                 partnerAccounts[i].balance += acctDist;
231                                 totalFundsDistributed += acctDist;
232                                 holdoverBalance -= acctDist;
233                         }
234                 }
235                 //now pay accounts that are constrained by even distribution. we split whatever is
236                 //left of the holdover evenly.
237                 uint distAmount = holdoverBalance;
238                 if (totalFundsDistributed < evenDistThresh) {
239                         for (i = 0; i < numAccounts; i++ ) {
240                                 if (partnerAccounts[i].evenStart) {
241                                         acctDist = distAmount / numEvenSplits;
242                                         //we also double check to ensure that the amount awarded cannot exceed the
243                                         //total amount due to this acct. note: this check is necessary, cuz here we
244                                         //might not distribute the full holdover amount during each pass.
245                                         uint fundLimit = totalFundsReceived;
246                                         if (fundLimit > evenDistThresh)
247                                                 fundLimit = evenDistThresh;
248                                         maxAcctDist = fundLimit / numEvenSplits;
249                                         if (partnerAccounts[i].credited >= maxAcctDist) {
250                                                 acctDist = 0;
251                                         } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
252                                                 acctDist = maxAcctDist - partnerAccounts[i].credited;
253                                         }
254                                         partnerAccounts[i].credited += acctDist;
255                                         partnerAccounts[i].balance += acctDist;
256                                         totalFundsDistributed += acctDist;
257                                         holdoverBalance -= acctDist;
258                                 }
259                         }
260                 }
261                 //now, if there are any funds left (because of a remainder in the even split), then distribute them
262                 //according to percentages. note that this must be done here, even if we haven't passed the even distribution
263                 //threshold, to ensure that we don't get stuck with a remainder amount that cannot be distributed.
264                 distAmount = holdoverBalance;
265                 if (distAmount > 0) {
266                         for (i = 0; i < numAccounts; i++ ) {
267                                 if (partnerAccounts[i].evenStart) {
268                                         pctx10 = partnerAccounts[i].pctx10;
269                                         acctDist = distAmount * pctx10 / TENHUNDWEI;
270                                         //we also double check to ensure that the amount awarded cannot exceed the
271                                         //total amount due to this acct. note: this check is necessary, cuz here we
272                                         //might not distribute the full holdover amount during each pass.
273                                         maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
274                                         if (partnerAccounts[i].credited >= maxAcctDist) {
275                                                 acctDist = 0;
276                                         } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
277                                                 acctDist = maxAcctDist - partnerAccounts[i].credited;
278                                         }
279                                         partnerAccounts[i].credited += acctDist;
280                                         partnerAccounts[i].balance += acctDist;
281                                         totalFundsDistributed += acctDist;
282                                         holdoverBalance -= acctDist;
283                                 }
284                         }
285                 }
286                 StatEvent("ok: distributed funds");
287         }
288 
289 
290         // ----------------------------
291         // withdraw account balance
292         // ----------------------------
293         function withdraw() {
294                 for (uint i = 0; i < numAccounts; i++ ) {
295                         address addr = partnerAccounts[i].addr;
296                         if (addr == msg.sender) {
297                                 uint amount = partnerAccounts[i].balance;
298                                 if (amount == 0) { 
299                                         StatEvent("err: balance is zero");
300                                 } else {
301                                         partnerAccounts[i].balance = 0;
302                                         totalFundsWithdrawn += amount;
303                                         if (!msg.sender.call.gas(withdrawGas).value(amount)())
304                                                 throw;
305                                         StatEventI("ok: rewards paid", amount);
306                                 }
307                         }
308                 }
309         }
310 
311 
312         // ----------------------------
313         // suicide
314         // ----------------------------
315         function hariKari() {
316                 if (msg.sender != owner) {
317                         StatEvent("err: not owner");
318                         return;
319                 }
320                 if (settingsState == SettingStateValue.locked) {
321                         StatEvent("err: locked");
322                         return;
323                 }
324                 suicide(owner);
325         }
326 
327 }