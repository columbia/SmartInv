1 pragma solidity ^0.4.15;
2 
3 // ERC20 Interface
4 contract ERC20 {
5     function transfer(address _to, uint _value) returns (bool success);
6     function balanceOf(address _owner) constant returns (uint balance);
7 }
8 
9 contract PresalePool {
10     enum State { Open, Failed, Closed, Paid }
11     State public state;
12 
13     address[] public admins;
14 
15     uint public minContribution;
16     uint public maxContribution;
17     uint public maxPoolTotal;
18 
19     address[] public participants;
20 
21     bool public whitelistAll;
22 
23     struct ParticipantState {
24         uint contribution;
25         uint remaining;
26         bool whitelisted;
27         bool exists;
28     }
29     mapping (address => ParticipantState) public balances;
30     uint public poolTotal;
31 
32     address presaleAddress;
33     bool refundable;
34     uint gasFundTotal;
35 
36     ERC20 public token;
37 
38     event Deposit(
39         address indexed _from,
40         uint _value
41     );
42     event Payout(
43         address indexed _to,
44         uint _value
45     );
46     event Withdrawl(
47         address indexed _to,
48         uint _value
49     );
50 
51     modifier onlyAdmins() {
52         require(isAdmin(msg.sender));
53         _;
54     }
55 
56     modifier onState(State s) {
57         require(state == s);
58         _;
59     }
60 
61     modifier stateAllowsConfiguration() {
62         require(state == State.Open || state == State.Closed);
63         _;
64     }
65 
66     bool locked;
67     modifier noReentrancy() {
68         require(!locked);
69         locked = true;
70         _;
71         locked = false;
72     }
73 
74     function PresalePool(uint _minContribution, uint _maxContribution, uint _maxPoolTotal, address[] _admins) payable {
75         state = State.Open;
76         admins.push(msg.sender);
77 
78         setContributionSettings(_minContribution, _maxContribution, _maxPoolTotal);
79 
80         whitelistAll = true;
81 
82         for (uint i = 0; i < _admins.length; i++) {
83             var admin = _admins[i];
84             if (!isAdmin(admin)) {
85                 admins.push(admin);
86             }
87         }
88 
89         deposit();
90     }
91 
92     function () payable {
93         deposit();
94     }
95 
96     function close() public onlyAdmins onState(State.Open) {
97         state = State.Closed;
98     }
99 
100     function open() public onlyAdmins onState(State.Closed) {
101         state = State.Open;
102     }
103 
104     function fail() public onlyAdmins stateAllowsConfiguration {
105         state = State.Failed;
106     }
107 
108     function payToPresale(address _presaleAddress) public onlyAdmins onState(State.Closed) {
109         state = State.Paid;
110         presaleAddress = _presaleAddress;
111         refundable = true;
112         presaleAddress.transfer(poolTotal);
113     }
114 
115     function refundPresale() payable public onState(State.Paid) {
116         require(refundable && msg.value >= poolTotal);
117         require(msg.sender == presaleAddress || isAdmin(msg.sender));
118         gasFundTotal = msg.value - poolTotal;
119         state = State.Failed;
120     }
121 
122     function setToken(address tokenAddress) public onlyAdmins {
123         token = ERC20(tokenAddress);
124     }
125 
126     function withdrawAll() public {
127         uint total = balances[msg.sender].remaining;
128         balances[msg.sender].remaining = 0;
129 
130         if (state == State.Open || state == State.Failed) {
131             total += balances[msg.sender].contribution;
132             if (gasFundTotal > 0) {
133                 uint gasRefund = (balances[msg.sender].contribution * gasFundTotal) / (poolTotal);
134                 gasFundTotal -= gasRefund;
135                 total += gasRefund;
136             }
137             poolTotal -= balances[msg.sender].contribution;
138             balances[msg.sender].contribution = 0;
139         } else {
140             require(state == State.Paid);
141         }
142 
143         msg.sender.transfer(total);
144         Withdrawl(msg.sender, total);
145     }
146 
147     function withdraw(uint amount) public onState(State.Open) {
148         uint total = balances[msg.sender].remaining + balances[msg.sender].contribution;
149         require(total >= amount);
150         uint debit = min(balances[msg.sender].remaining, amount);
151         balances[msg.sender].remaining -= debit;
152         debit = amount - debit;
153         balances[msg.sender].contribution -= debit;
154         poolTotal -= debit;
155 
156         (balances[msg.sender].contribution, balances[msg.sender].remaining) = getContribution(msg.sender, 0);
157         // must respect the minContribution limit
158         require(balances[msg.sender].remaining == 0 || balances[msg.sender].contribution > 0);
159         msg.sender.transfer(amount);
160         Withdrawl(msg.sender, amount);
161     }
162 
163     function transferMyTokens() public onState(State.Paid) noReentrancy {
164         uint tokenBalance = token.balanceOf(address(this));
165         require(tokenBalance > 0);
166 
167         uint participantContribution = balances[msg.sender].contribution;
168         uint participantShare = participantContribution * tokenBalance / poolTotal;
169 
170         poolTotal -= participantContribution;
171         balances[msg.sender].contribution = 0;
172         refundable = false;
173         require(token.transfer(msg.sender, participantShare));
174 
175         Payout(msg.sender, participantShare);
176     }
177 
178     address[] public failures;
179     function transferAllTokens() public onlyAdmins onState(State.Paid) noReentrancy returns (address[]) {
180         uint tokenBalance = token.balanceOf(address(this));
181         require(tokenBalance > 0);
182         delete failures;
183 
184         for (uint i = 0; i < participants.length; i++) {
185             address participant = participants[i];
186             uint participantContribution = balances[participant].contribution;
187 
188             if (participantContribution > 0) {
189                 uint participantShare = participantContribution * tokenBalance / poolTotal;
190 
191                 poolTotal -= participantContribution;
192                 balances[participant].contribution = 0;
193 
194                 if (token.transfer(participant, participantShare)) {
195                     refundable = false;
196                     Payout(participant, participantShare);
197                     tokenBalance -= participantShare;
198                     if (tokenBalance == 0) {
199                         break;
200                     }
201                 } else {
202                     balances[participant].contribution = participantContribution;
203                     poolTotal += participantContribution;
204                     failures.push(participant);
205                 }
206             }
207         }
208 
209         return failures;
210     }
211 
212     function modifyWhitelist(address[] toInclude, address[] toExclude) public onlyAdmins stateAllowsConfiguration {
213         bool previous = whitelistAll;
214         uint i;
215         if (previous) {
216             require(toExclude.length == 0);
217             for (i = 0; i < participants.length; i++) {
218                 balances[participants[i]].whitelisted = false;
219             }
220             whitelistAll = false;
221         }
222 
223         for (i = 0; i < toInclude.length; i++) {
224             balances[toInclude[i]].whitelisted = true;
225         }
226 
227         address excludedParticipant;
228         uint contribution;
229         if (previous) {
230             for (i = 0; i < participants.length; i++) {
231                 excludedParticipant = participants[i];
232                 if (!balances[excludedParticipant].whitelisted) {
233                     contribution = balances[excludedParticipant].contribution;
234                     balances[excludedParticipant].contribution = 0;
235                     balances[excludedParticipant].remaining += contribution;
236                     poolTotal -= contribution;
237                 }
238             }
239         } else {
240             for (i = 0; i < toExclude.length; i++) {
241                 excludedParticipant = toExclude[i];
242                 balances[excludedParticipant].whitelisted = false;
243                 contribution = balances[excludedParticipant].contribution;
244                 balances[excludedParticipant].contribution = 0;
245                 balances[excludedParticipant].remaining += contribution;
246                 poolTotal -= contribution;
247             }
248         }
249     }
250 
251     function removeWhitelist() public onlyAdmins stateAllowsConfiguration {
252         if (!whitelistAll) {
253             whitelistAll = true;
254             for (uint i = 0; i < participants.length; i++) {
255                 balances[participants[i]].whitelisted = true;
256             }
257         }
258     }
259 
260     function setContributionSettings(uint _minContribution, uint _maxContribution, uint _maxPoolTotal) public onlyAdmins stateAllowsConfiguration {
261         // we raised the minContribution threshold
262         bool recompute = (minContribution < _minContribution);
263         // we lowered the maxContribution threshold
264         recompute = recompute || (maxContribution > _maxContribution);
265         // we did not have a maxContribution threshold and now we do
266         recompute = recompute || (maxContribution == 0 && _maxContribution > 0);
267         // we want to make maxPoolTotal lower than the current pool total
268         recompute = recompute || (poolTotal > _maxPoolTotal);
269 
270         minContribution = _minContribution;
271         maxContribution = _maxContribution;
272         maxPoolTotal = _maxPoolTotal;
273 
274         if (maxContribution > 0) {
275             require(maxContribution >= minContribution);
276         }
277         if (maxPoolTotal > 0) {
278             require(maxPoolTotal >= minContribution);
279             require(maxPoolTotal >= maxContribution);
280         }
281 
282         if (recompute) {
283             poolTotal = 0;
284             for (uint i = 0; i < participants.length; i++) {
285                 address participant = participants[i];
286                 var balance = balances[participant];
287                 (balance.contribution, balance.remaining) = getContribution(participant, 0);
288                 poolTotal += balance.contribution;
289             }
290         }
291     }
292 
293     function getParticipantBalances() public returns(address[], uint[], uint[], bool[], bool[]) {
294         uint[] memory contribution = new uint[](participants.length);
295         uint[] memory remaining = new uint[](participants.length);
296         bool[] memory whitelisted = new bool[](participants.length);
297         bool[] memory exists = new bool[](participants.length);
298 
299         for (uint i = 0; i < participants.length; i++) {
300             var balance = balances[participants[i]];
301             contribution[i] = balance.contribution;
302             remaining[i] = balance.remaining;
303             whitelisted[i] = balance.whitelisted;
304             exists[i] = balance.exists;
305         }
306 
307         return (participants, contribution, remaining, whitelisted, exists);
308     }
309 
310     function deposit() internal onState(State.Open) {
311         if (msg.value > 0) {
312             require(included(msg.sender));
313             (balances[msg.sender].contribution, balances[msg.sender].remaining) = getContribution(msg.sender, msg.value);
314             // must respect the maxContribution and maxPoolTotal limits
315             require(balances[msg.sender].remaining == 0);
316             balances[msg.sender].whitelisted = true;
317             poolTotal += msg.value;
318             if (!balances[msg.sender].exists) {
319                 balances[msg.sender].exists = true;
320                 participants.push(msg.sender);
321             }
322             Deposit(msg.sender, msg.value);
323         }
324     }
325 
326     function isAdmin(address addr) internal constant returns (bool) {
327         for (uint i = 0; i < admins.length; i++) {
328             if (admins[i] == addr) {
329                 return true;
330             }
331         }
332         return false;
333     }
334 
335     function included(address participant) internal constant returns (bool) {
336         return whitelistAll || balances[participant].whitelisted || isAdmin(participant);
337     }
338 
339     function getContribution(address participant, uint amount) internal constant returns (uint, uint) {
340         var balance = balances[participant];
341         uint total = balance.remaining + balance.contribution + amount;
342         uint contribution = total;
343         if (!included(participant)) {
344             return (0, total);
345         }
346         if (maxContribution > 0) {
347             contribution = min(maxContribution, contribution);
348         }
349         if (maxPoolTotal > 0) {
350             contribution = min(maxPoolTotal - poolTotal, contribution);
351         }
352         if (contribution < minContribution) {
353             return (0, total);
354         }
355         return (contribution, total - contribution);
356     }
357 
358     function min(uint a, uint b) internal pure returns (uint _min) {
359         if (a < b) {
360             return a;
361         }
362         return b;
363     }
364 }