1 contract Token { 
2     function issue(address _recipient, uint256 _value) returns (bool success) {} 
3     function balanceOf(address _owner) constant returns (uint256 balance) {}
4     function unlock() returns (bool success) {}
5     function startIncentiveDistribution() returns (bool success) {}
6     function transferOwnership(address _newOwner) {}
7     function owner() returns (address _owner) {}
8 }
9 
10 contract DRPCrowdsale {
11 
12     // Crowdsale details
13     address public beneficiary; // Company address multisig (49% funding)
14     address public confirmedBy; // Address that confirmed beneficiary
15     uint256 public minAmount = 4137 ether; // ≈ 724.000 euro
16     uint256 public maxAmount = 54285 ether; // ≈ 9.5 mln euro
17     uint256 public minAcceptedAmount = 40 finney; // 1/25 ether
18 
19     /**
20      * 51% of the raised amount remains in the crowdsale contract 
21      * to be released to DCORP on launch with aproval of tokenholders.
22      *
23      * See whitepaper for more information
24      */
25     uint256 public percentageOfRaisedAmountThatRemainsInContract = 51; // 0.51 * 10^2
26 
27     // Eth to DRP rate
28     uint256 public rateAngelDay = 650;
29     uint256 public rateFirstWeek = 550;
30     uint256 public rateSecondWeek = 475;
31     uint256 public rateThirdWeek = 425;
32     uint256 public rateLastWeek = 400;
33 
34     uint256 public rateAngelDayEnd = 1 days;
35     uint256 public rateFirstWeekEnd = 8 days;
36     uint256 public rateSecondWeekEnd = 15 days;
37     uint256 public rateThirdWeekEnd = 22 days;
38     uint256 public rateLastWeekEnd = 29 days;
39 
40     enum Stages {
41         InProgress,
42         Ended,
43         Withdrawn,
44         Proposed,
45         Accepted
46     }
47 
48     Stages public stage = Stages.InProgress;
49 
50     // Crowdsale state
51     uint256 public start;
52     uint256 public end;
53     uint256 public raised;
54 
55     // DRP token
56     Token public drpToken;
57 
58     // Invested balances
59     mapping (address => uint256) balances;
60 
61     struct Proposal {
62         address dcorpAddress;
63         uint256 deadline;
64         uint256 approvedWeight;
65         uint256 disapprovedWeight;
66         mapping (address => uint256) voted;
67     }
68 
69     // Ownership transfer proposal
70     Proposal public transferProposal;
71 
72     // Time to vote
73     uint256 public transferProposalEnd = 7 days;
74 
75     // Time between proposals
76     uint256 public transferProposalCooldown = 1 days;
77 
78 
79     /**
80      * Throw if at stage other than current stage
81      * 
82      * @param _stage expected stage to test for
83      */
84     modifier atStage(Stages _stage) {
85         if (stage != _stage) {
86             throw;
87         }
88         _;
89     }
90     
91 
92     /**
93      * Throw if at stage other than current stage
94      * 
95      * @param _stage1 expected stage to test for
96      * @param _stage2 expected stage to test for
97      */
98     modifier atStages(Stages _stage1, Stages _stage2) {
99         if (stage != _stage1 && stage != _stage2) {
100             throw;
101         }
102         _;
103     }
104 
105 
106     /**
107      * Throw if sender is not beneficiary
108      */
109     modifier onlyBeneficiary() {
110         if (beneficiary != msg.sender) {
111             throw;
112         }
113         _;
114     }
115 
116 
117     /**
118      * Throw if sender has a DCP balance of zero
119      */
120     modifier onlyShareholders() {
121         if (drpToken.balanceOf(msg.sender) == 0) {
122             throw;
123         }
124         _;
125     }
126 
127 
128     /**
129      * Throw if the current transfer proposal's deadline
130      * is in the past
131      */
132     modifier beforeDeadline() {
133         if (now > transferProposal.deadline) {
134             throw;
135         }
136         _;
137     }
138 
139 
140     /**
141      * Throw if the current transfer proposal's deadline 
142      * is in the future
143      */
144     modifier afterDeadline() {
145         if (now < transferProposal.deadline) {
146             throw;
147         }
148         _;
149     }
150 
151 
152     /** 
153      * Get balance of `_investor` 
154      * 
155      * @param _investor The address from which the balance will be retrieved
156      * @return The balance
157      */
158     function balanceOf(address _investor) constant returns (uint256 balance) {
159         return balances[_investor];
160     }
161 
162 
163     /**
164      * Most params are hardcoded for clarity
165      *
166      * @param _tokenAddress The address of the DRP token contact
167      */
168     function DRPCrowdsale(address _tokenAddress, address _beneficiary, uint256 _start) {
169         drpToken = Token(_tokenAddress);
170         beneficiary = _beneficiary;
171         start = _start;
172         end = start + 29 days;
173     }
174 
175 
176     /**
177      * For testing purposes
178      *
179      * @return The beneficiary address
180      */
181     function confirmBeneficiary() onlyBeneficiary {
182         confirmedBy = msg.sender;
183     }
184 
185 
186     /**
187      * Convert `_wei` to an amount in DRP using 
188      * the current rate
189      *
190      * @param _wei amount of wei to convert
191      * @return The amount in DRP
192      */
193     function toDRP(uint256 _wei) returns (uint256 amount) {
194         uint256 rate = 0;
195         if (stage != Stages.Ended && now >= start && now <= end) {
196 
197             // Check for angelday
198             if (now <= start + rateAngelDayEnd) {
199                 rate = rateAngelDay;
200             }
201 
202             // Check first week
203             else if (now <= start + rateFirstWeekEnd) {
204                 rate = rateFirstWeek;
205             }
206 
207             // Check second week
208             else if (now <= start + rateSecondWeekEnd) {
209                 rate = rateSecondWeek;
210             }
211 
212             // Check third week
213             else if (now <= start + rateThirdWeekEnd) {
214                 rate = rateThirdWeek;
215             }
216 
217             // Check last week
218             else if (now <= start + rateLastWeekEnd) {
219                 rate = rateLastWeek;
220             }
221         }
222 
223         return _wei * rate * 10**2 / 1 ether; // 10**2 for 2 decimals
224     }
225 
226 
227     /**
228      * Function to end the crowdsale by setting 
229      * the stage to Ended
230      */
231     function endCrowdsale() atStage(Stages.InProgress) {
232 
233         // Crowdsale not ended yet
234         if (now < end) {
235             throw;
236         }
237 
238         stage = Stages.Ended;
239     }
240 
241 
242     /**
243      * Transfer appropriate percentage of raised amount 
244      * to the company address
245      */
246     function withdraw() onlyBeneficiary atStage(Stages.Ended) {
247 
248         // Confirm that minAmount is raised
249         if (raised < minAmount) {
250             throw;
251         }
252 
253         uint256 amountToSend = raised * (100 - percentageOfRaisedAmountThatRemainsInContract) / 10**2;
254         if (!beneficiary.send(amountToSend)) {
255             throw;
256         }
257 
258         stage = Stages.Withdrawn;
259     }
260 
261 
262     /**
263      * Refund in the case of an unsuccessful crowdsale. The 
264      * crowdsale is considered unsuccessful if minAmount was 
265      * not raised before end
266      */
267     function refund() atStage(Stages.Ended) {
268 
269         // Only allow refunds if minAmount is not raised
270         if (raised >= minAmount) {
271             throw;
272         }
273 
274         uint256 receivedAmount = balances[msg.sender];
275         balances[msg.sender] = 0;
276 
277         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
278             balances[msg.sender] = receivedAmount;
279         }
280     }
281 
282 
283     /**
284      * Propose the transfer of the token contract ownership
285      * to `_dcorpAddress` 
286      *
287      * @param _dcorpAddress the address of the proposed token owner 
288      */
289     function proposeTransfer(address _dcorpAddress) onlyBeneficiary atStages(Stages.Withdrawn, Stages.Proposed) {
290         
291         // Check for a pending proposal
292         if (stage == Stages.Proposed && now < transferProposal.deadline + transferProposalCooldown) {
293             throw;
294         }
295 
296         transferProposal = Proposal({
297             dcorpAddress: _dcorpAddress,
298             deadline: now + transferProposalEnd,
299             approvedWeight: 0,
300             disapprovedWeight: 0
301         });
302 
303         stage = Stages.Proposed;
304     }
305 
306 
307     /**
308      * Allows DRP holders to vote on the poposed transfer of 
309      * ownership. Weight is calculated directly, this is no problem 
310      * because tokens cannot be transferred yet
311      *
312      * @param _approve indicates if the sender supports the proposal
313      */
314     function vote(bool _approve) onlyShareholders beforeDeadline atStage(Stages.Proposed) {
315 
316         // One vote per proposal
317         if (transferProposal.voted[msg.sender] >= transferProposal.deadline - transferProposalEnd) {
318             throw;
319         }
320 
321         transferProposal.voted[msg.sender] = now;
322         uint256 weight = drpToken.balanceOf(msg.sender);
323 
324         if (_approve) {
325             transferProposal.approvedWeight += weight;
326         } else {
327             transferProposal.disapprovedWeight += weight;
328         }
329     }
330 
331 
332     /**
333      * Calculates the votes and if the majority weigt approved 
334      * the proposal the transfer of ownership is executed.
335      
336      * The Crowdsale contact transferres the ownership of the 
337      * token contract to DCorp and starts the insentive 
338      * distribution recorded in the token contract.
339      */
340     function executeTransfer() afterDeadline atStage(Stages.Proposed) {
341 
342         // Check approved
343         if (transferProposal.approvedWeight <= transferProposal.disapprovedWeight) {
344             throw;
345         }
346 
347         if (!drpToken.unlock()) {
348             throw;
349         }
350         
351         if (!drpToken.startIncentiveDistribution()) {
352             throw;
353         }
354 
355         drpToken.transferOwnership(transferProposal.dcorpAddress);
356         if (drpToken.owner() != transferProposal.dcorpAddress) {
357             throw;
358         }
359 
360         if (!transferProposal.dcorpAddress.send(this.balance)) {
361             throw;
362         }
363 
364         stage = Stages.Accepted;
365     }
366 
367     
368     /**
369      * Receives Eth and issue DRP tokens to the sender
370      */
371     function () payable atStage(Stages.InProgress) {
372 
373         // Crowdsale not started yet
374         if (now < start) {
375             throw;
376         }
377 
378         // Crowdsale expired
379         if (now > end) {
380             throw;
381         }
382 
383         // Enforce min amount
384         if (msg.value < minAcceptedAmount) {
385             throw;
386         }
387  
388         uint256 received = msg.value;
389         uint256 valueInDRP = toDRP(msg.value);
390         if (!drpToken.issue(msg.sender, valueInDRP)) {
391             throw;
392         }
393 
394         balances[msg.sender] += received;
395         raised += received;
396 
397         // Check maxAmount raised
398         if (raised >= maxAmount) {
399             stage = Stages.Ended;
400         }
401     }
402 }