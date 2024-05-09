1 pragma solidity ^0.4.6;
2 
3 // --------------------------
4 //  R Split Contract
5 // --------------------------
6 contract RSPLT_E {
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
29         uint public evenDistThresh;                          // distribute evenly until this amount (total)
30         uint public withdrawGas = 35000;                     // gas for withdrawals
31         uint constant TENHUNDWEI = 1000;                     // need gt. 1000 wei to do payout
32 
33         SettingStateValue public settingsState = SettingStateValue.debug; 
34 
35 
36         // --------------------
37         // contract constructor
38         // --------------------
39         function RSPLT_E() {
40                 owner = msg.sender;
41         }
42 
43 
44         // -----------------------------------
45         // lock
46         // lock the contract. after calling this you will not be able to modify accounts:
47         // -----------------------------------
48         function lock() {
49                 if (msg.sender != owner) {
50                         StatEvent("err: not owner");
51                         return;
52                 }
53                 if (settingsState == SettingStateValue.locked) {
54                         StatEvent("err: locked");
55                         return;
56                 }
57                 settingsState == SettingStateValue.locked;
58                 StatEvent("ok: contract locked");
59         }
60 
61 
62         // -----------------------------------
63         // reset
64         // reset all accounts
65         // -----------------------------------
66         function reset() {
67                 if (msg.sender != owner) {
68                         StatEvent("err: not owner");
69                         return;
70                 }
71                 if (settingsState == SettingStateValue.locked) {
72                         StatEvent("err: locked");
73                         return;
74                 }
75                 numAccounts = 0;
76                 holdoverBalance = 0;
77                 totalFundsReceived = 0;
78                 totalFundsDistributed = 0;
79                 StatEvent("ok: all accts reset");
80         }
81 
82 
83         // -----------------------------------
84         // set even distribution threshold
85         // -----------------------------------
86         function setEvenDistThresh(uint256 _thresh) {
87                 if (msg.sender != owner) {
88                         StatEvent("err: not owner");
89                         return;
90                 }
91                 if (settingsState == SettingStateValue.locked) {
92                         StatEvent("err: locked");
93                         return;
94                 }
95                 evenDistThresh = (_thresh / TENHUNDWEI) * TENHUNDWEI;
96                 StatEventI("ok: threshold set", evenDistThresh);
97         }
98 
99 
100         // -----------------------------------
101         // set even distribution threshold
102         // -----------------------------------
103         function setWitdrawGas(uint256 _withdrawGas) {
104                 if (msg.sender != owner) {
105                         StatEvent("err: not owner");
106                         return;
107                 }
108                 withdrawGas = _withdrawGas;
109                 StatEventI("ok: withdraw gas set", withdrawGas);
110         }
111 
112 
113         // ---------------------------------------------------
114         // add a new account
115         // ---------------------------------------------------
116         function addAccount(address _addr, uint256 _pctx10, bool _evenStart) {
117                 if (msg.sender != owner) {
118                         StatEvent("err: not owner");
119                         return;
120                 }
121                 if (settingsState == SettingStateValue.locked) {
122                         StatEvent("err: locked");
123                         return;
124                 }
125                 partnerAccounts[numAccounts].addr = _addr;
126                 partnerAccounts[numAccounts].pctx10 = _pctx10;
127                 partnerAccounts[numAccounts].evenStart = _evenStart;
128                 partnerAccounts[numAccounts].credited = 0;
129                 partnerAccounts[numAccounts].balance = 0;
130                 ++numAccounts;
131                 StatEvent("ok: acct added");
132         }
133 
134 
135         // ----------------------------
136         // get acct info
137         // ----------------------------
138         function getAccountInfo(address _addr) constant returns(uint _idx, uint _pctx10, bool _evenStart, uint _credited, uint _balance) {
139                 for (uint i = 0; i < numAccounts; i++ ) {
140                         address addr = partnerAccounts[i].addr;
141                         if (addr == _addr) {
142                                 _idx = i;
143                                 _pctx10 = partnerAccounts[i].pctx10;
144                                 _evenStart = partnerAccounts[i].evenStart;
145                                 _credited = partnerAccounts[i].credited;
146                                 _balance = partnerAccounts[i].balance;
147                                 StatEvent("ok: found acct");
148                                 return;
149                         }
150                 }
151                 StatEvent("err: acct not found");
152         }
153 
154 
155         // ----------------------------
156         // get total percentages x2
157         // ----------------------------
158         function getTotalPctx10() constant returns(uint _totalPctx10) {
159                 _totalPctx10 = 0;
160                 for (uint i = 0; i < numAccounts; i++ ) {
161                         _totalPctx10 += partnerAccounts[i].pctx10;
162                 }
163                 StatEventI("ok: total pctx10", _totalPctx10);
164         }
165 
166 
167         // -------------------------------------------
168         // default payable function.
169         // call us with plenty of gas, or catastrophe will ensue
170         // note: you can call this fcn with amount of zero to force distribution
171         // -------------------------------------------
172         function () payable {
173                 totalFundsReceived += msg.value;
174                 holdoverBalance += msg.value;
175         }
176 
177 
178         // ----------------------------
179         // distribute funds to all partners
180         // ----------------------------
181         function distribute() {
182                 //only payout if we have more than 1000 wei
183                 if (holdoverBalance < TENHUNDWEI) {
184                         return;
185                 }
186                 //first pay accounts that are not constrained by even distribution
187                 //each account gets their prescribed percentage of this holdover.
188                 uint i;
189                 uint pctx10;
190                 uint acctDist;
191                 uint maxAcctDist;
192                 uint numEvenSplits = 0;
193                 for (i = 0; i < numAccounts; i++ ) {
194                         if (partnerAccounts[i].evenStart) {
195                                 ++numEvenSplits;
196                         } else {
197                                 pctx10 = partnerAccounts[i].pctx10;
198                                 acctDist = holdoverBalance * pctx10 / TENHUNDWEI;
199                                 //we also double check to ensure that the amount awarded cannot exceed the
200                                 //total amount due to this acct. note: this check is necessary, cuz here we
201                                 //might not distribute the full holdover amount during each pass.
202                                 maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
203                                 if (partnerAccounts[i].credited >= maxAcctDist) {
204                                         acctDist = 0;
205                                 } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
206                                         acctDist = maxAcctDist - partnerAccounts[i].credited;
207                                 }
208                                 partnerAccounts[i].credited += acctDist;
209                                 partnerAccounts[i].balance += acctDist;
210                                 totalFundsDistributed += acctDist;
211                                 holdoverBalance -= acctDist;
212                         }
213                 }
214                 //now pay accounts that are constrained by even distribution. we split whatever is
215                 //left of the holdover evenly.
216                 uint distAmount = holdoverBalance;
217                 if (totalFundsDistributed < evenDistThresh) {
218                         for (i = 0; i < numAccounts; i++ ) {
219                                 if (partnerAccounts[i].evenStart) {
220                                         acctDist = distAmount / numEvenSplits;
221                                         //we also double check to ensure that the amount awarded cannot exceed the
222                                         //total amount due to this acct. note: this check is necessary, cuz here we
223                                         //might not distribute the full holdover amount during each pass.
224                                         uint fundLimit = totalFundsReceived;
225                                         if (fundLimit > evenDistThresh)
226                                                 fundLimit = evenDistThresh;
227                                         maxAcctDist = fundLimit / numEvenSplits;
228                                         if (partnerAccounts[i].credited >= maxAcctDist) {
229                                                 acctDist = 0;
230                                         } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
231                                                 acctDist = maxAcctDist - partnerAccounts[i].credited;
232                                         }
233                                         partnerAccounts[i].credited += acctDist;
234                                         partnerAccounts[i].balance += acctDist;
235                                         totalFundsDistributed += acctDist;
236                                         holdoverBalance -= acctDist;
237                                 }
238                         }
239                 }
240                 //now, if there are any funds left (because of a remainder in the even split), then distribute them
241                 //according to percentages. note that this must be done here, even if we haven't passed the even distribution
242                 //threshold, to ensure that we don't get stuck with a remainder amount that cannot be distributed.
243                 distAmount = holdoverBalance;
244                 if (distAmount > 0) {
245                         for (i = 0; i < numAccounts; i++ ) {
246                                 if (partnerAccounts[i].evenStart) {
247                                         pctx10 = partnerAccounts[i].pctx10;
248                                         acctDist = distAmount * pctx10 / TENHUNDWEI;
249                                         //we also double check to ensure that the amount awarded cannot exceed the
250                                         //total amount due to this acct. note: this check is necessary, cuz here we
251                                         //might not distribute the full holdover amount during each pass.
252                                         maxAcctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
253                                         if (partnerAccounts[i].credited >= maxAcctDist) {
254                                                 acctDist = 0;
255                                         } else if (partnerAccounts[i].credited + acctDist > maxAcctDist) {
256                                                 acctDist = maxAcctDist - partnerAccounts[i].credited;
257                                         }
258                                         partnerAccounts[i].credited += acctDist;
259                                         partnerAccounts[i].balance += acctDist;
260                                         totalFundsDistributed += acctDist;
261                                         holdoverBalance -= acctDist;
262                                 }
263                         }
264                 }
265                 StatEvent("ok: distributed funds");
266         }
267 
268 
269         // ----------------------------
270         // withdraw account balance
271         // ----------------------------
272         function withdraw() {
273                 for (uint i = 0; i < numAccounts; i++ ) {
274                         address addr = partnerAccounts[i].addr;
275                         if (addr == msg.sender) {
276                                 uint amount = partnerAccounts[i].balance;
277                                 if (amount == 0) { 
278                                         StatEvent("err: balance is zero");
279                                 } else {
280                                         partnerAccounts[i].balance = 0;
281                                         if (!msg.sender.call.gas(withdrawGas).value(amount)())
282                                                 throw;
283                                         StatEventI("ok: rewards paid", amount);
284                                 }
285                         }
286                 }
287         }
288 
289 
290         // ----------------------------
291         // suicide
292         // ----------------------------
293         function hariKari() {
294                 if (msg.sender != owner) {
295                         StatEvent("err: not owner");
296                         return;
297                 }
298                 if (settingsState == SettingStateValue.locked) {
299                         StatEvent("err: locked");
300                         return;
301                 }
302                 suicide(owner);
303         }
304 
305 }