1 pragma solidity ^0.4.15;
2 
3 contract EngravedToken {
4     uint256 public totalSupply;
5     function issue(address, uint256) returns (bool) {}
6     function balanceOf(address) constant returns (uint256) {}
7     function unlock() returns (bool) {}
8     function startIncentiveDistribution() returns (bool) {}
9     function transferOwnership(address) {}
10     function owner() returns (address) {}
11 }
12 
13 contract EGRCrowdsale {
14     // Crowdsale details
15     address public beneficiary;
16     address public confirmedBy; // Address that confirmed beneficiary
17 
18     // Maximum tokens supply
19     uint256 public maxSupply = 1000000000; // 1 billion
20 
21     // Minum amount of ether to be exchanged for EGR
22     uint256 public minAcceptedAmount = 10 finney; // 0.01 ETH
23 
24     //Amount of free tokens per user in airdrop period
25     uint256 public rateAirDrop = 1000;
26 
27     // Number of airdrop participants
28     uint256 public airdropParticipants;
29 
30     //Maximum number of airdrop participants
31     uint256 public maxAirdropParticipants = 500;
32 
33     // Check if this is the first participation in the airdrop
34     mapping (address => bool) participatedInAirdrop;
35 
36     // ETH to EGR rate
37     uint256 public rateAngelsDay = 100000;
38     uint256 public rateFirstWeek = 80000;
39     uint256 public rateSecondWeek = 70000;
40     uint256 public rateThirdWeek = 60000;
41     uint256 public rateLastWeek = 50000;
42 
43     uint256 public airdropEnd = 3 days;
44     uint256 public airdropCooldownEnd = 7 days;
45     uint256 public rateAngelsDayEnd = 8 days;
46     uint256 public angelsDayCooldownEnd = 14 days;
47     uint256 public rateFirstWeekEnd = 21 days;
48     uint256 public rateSecondWeekEnd = 28 days;
49     uint256 public rateThirdWeekEnd = 35 days;
50     uint256 public rateLastWeekEnd = 42 days;
51 
52     enum Stages {
53         Airdrop,
54         InProgress,
55         Ended,
56         Withdrawn,
57         Proposed,
58         Accepted
59     }
60 
61     Stages public stage = Stages.Airdrop;
62 
63     // Crowdsale state
64     uint256 public start;
65     uint256 public end;
66     uint256 public raised;
67 
68     // EGR EngravedToken
69     EngravedToken public EGREngravedToken;
70 
71     // Invested balances
72     mapping (address => uint256) balances;
73 
74     struct Proposal {
75         address engravedAddress;
76         uint256 deadline;
77         uint256 approvedWeight;
78         uint256 disapprovedWeight;
79         mapping (address => uint256) voted;
80     }
81 
82     // Ownership transfer proposal
83     Proposal public transferProposal;
84 
85     // Time to vote
86     uint256 public transferProposalEnd = 7 days;
87 
88     // Time between proposals
89     uint256 public transferProposalCooldown = 1 days;
90 
91 
92     /**
93      * Throw if at stage other than current stage
94      *
95      * @param _stage expected stage to test for
96      */
97     modifier atStage(Stages _stage) {
98 		    require(stage == _stage);
99         _;
100     }
101 
102 
103     /**
104      * Throw if at stage other than current stage
105      *
106      * @param _stage1 expected stage to test for
107      * @param _stage2 expected stage to test for
108      */
109     modifier atStages(Stages _stage1, Stages _stage2) {
110 		    require(stage == _stage1 || stage == _stage2);
111         _;
112     }
113 
114 
115     /**
116      * Throw if sender is not beneficiary
117      */
118     modifier onlyBeneficiary() {
119 		    require(beneficiary == msg.sender);
120         _;
121     }
122 
123 
124     /**
125      * Throw if sender has a EGR balance of zero
126      */
127     modifier onlyTokenholders() {
128 		    require(EGREngravedToken.balanceOf(msg.sender) > 0);
129         _;
130     }
131 
132 
133     /**
134      * Throw if the current transfer proposal's deadline
135      * is in the past
136      */
137     modifier beforeDeadline() {
138 		    require(now < transferProposal.deadline);
139         _;
140     }
141 
142 
143     /**
144      * Throw if the current transfer proposal's deadline
145      * is in the future
146      */
147     modifier afterDeadline() {
148 		    require(now > transferProposal.deadline);
149         _;
150     }
151 
152 
153     /**
154      * Get balance of `_investor`
155      *
156      * @param _investor The address from which the balance will be retrieved
157      * @return The balance
158      */
159     function balanceOf(address _investor) constant returns (uint256 balance) {
160         return balances[_investor];
161     }
162 
163 
164     /**
165      * Most params are hardcoded for clarity
166      *
167      * @param _EngravedTokenAddress The address of the EGR EngravedToken contact
168      * @param _beneficiary Company address
169      * @param _start airdrop start date
170      */
171     function EGRCrowdsale(address _EngravedTokenAddress, address _beneficiary, uint256 _start) {
172         EGREngravedToken = EngravedToken(_EngravedTokenAddress);
173         beneficiary = _beneficiary;
174         start = _start;
175         end = start + 42 days;
176     }
177 
178 
179     /**
180      * For testing purposes
181      *
182      * @return The beneficiary address
183      */
184     function confirmBeneficiary() onlyBeneficiary {
185         confirmedBy = msg.sender;
186     }
187 
188 
189     /**
190      * Convert `_wei` to an amount in EGR using
191      * the current rate
192      *
193      * @param _wei amount of wei to convert
194      * @return The amount in EGR
195      */
196     function toEGR(uint256 _wei) returns (uint256 amount) {
197         uint256 rate = 0;
198         if (stage != Stages.Ended && now >= start && now <= end) {
199 
200             // Check for cool down after airdrop
201             if (now <= start + airdropCooldownEnd) {
202                 rate = 0;
203             }
204 
205             // Check for AngelsDay
206             else if (now <= start + rateAngelsDayEnd) {
207                 rate = rateAngelsDay;
208             }
209 
210             // Check for cool down after the angels day
211             else if (now <= start + angelsDayCooldownEnd) {
212       			    rate = 0;
213             }
214 
215             // Check first week
216             else if (now <= start + rateFirstWeekEnd) {
217                 rate = rateFirstWeek;
218             }
219 
220             // Check second week
221             else if (now <= start + rateSecondWeekEnd) {
222                 rate = rateSecondWeek;
223             }
224 
225             // Check third week
226             else if (now <= start + rateThirdWeekEnd) {
227                 rate = rateThirdWeek;
228             }
229 
230             // Check last week
231             else if (now <= start + rateLastWeekEnd) {
232                 rate = rateLastWeek;
233             }
234         }
235 	      require(rate != 0); // Check for cool down periods
236         return _wei * rate * 10**3 / 1 ether; // 10**3 for 3 decimals
237     }
238 
239     /**
240     * Function to participate in the airdrop
241     */
242     function claim() atStage(Stages.Airdrop) {
243         require(airdropParticipants < maxAirdropParticipants);
244 
245         // Crowdsal not started yet
246         require(now > start);
247 
248         // Airdrop expired
249         require(now < start + airdropEnd);
250 
251         require(participatedInAirdrop[msg.sender] == false); // Only once per address
252 
253         require(EGREngravedToken.issue(msg.sender, rateAirDrop * 10**3));
254 
255         participatedInAirdrop[msg.sender] = true;
256         airdropParticipants += 1;
257     }
258 
259     /**
260      * Function to end the airdrop and start crowdsale
261      */
262     function endAirdrop() atStage(Stages.Airdrop) {
263 	      require(now > start + airdropEnd);
264 
265         stage = Stages.InProgress;
266     }
267 
268     /**
269      * Function to end the crowdsale by setting
270      * the stage to Ended
271      */
272     function endCrowdsale() atStage(Stages.InProgress) {
273 
274         // Crowdsale not ended yet
275 	      require(now > end);
276 
277         stage = Stages.Ended;
278     }
279 
280 
281     /**
282      * Transfer raised amount to the company address
283      */
284     function withdraw() onlyBeneficiary atStage(Stages.Ended) {
285         require(beneficiary.send(raised));
286 
287         stage = Stages.Withdrawn;
288     }
289 
290     /**
291      * Propose the transfer of the EngravedToken contract ownership
292      * to `_engravedAddress`
293      *
294      * @param _engravedAddress the address of the proposed EngravedToken owner
295      */
296     function proposeTransfer(address _engravedAddress) onlyBeneficiary atStages(Stages.Withdrawn, Stages.Proposed) {
297 
298         // Check for a pending proposal
299 	      require(stage != Stages.Proposed || now > transferProposal.deadline + transferProposalCooldown);
300 
301         transferProposal = Proposal({
302             engravedAddress: _engravedAddress,
303             deadline: now + transferProposalEnd,
304             approvedWeight: 0,
305             disapprovedWeight: 0
306         });
307 
308         stage = Stages.Proposed;
309     }
310 
311 
312     /**
313      * Allows EGR holders to vote on the poposed transfer of
314      * ownership. Weight is calculated directly, this is no problem
315      * because EngravedTokens cannot be transferred yet
316      *
317      * @param _approve indicates if the sender supports the proposal
318      */
319     function vote(bool _approve) onlyTokenholders beforeDeadline atStage(Stages.Proposed) {
320 
321         // One vote per proposal
322 	      require(transferProposal.voted[msg.sender] < transferProposal.deadline - transferProposalEnd);
323 
324         transferProposal.voted[msg.sender] = now;
325         uint256 weight = EGREngravedToken.balanceOf(msg.sender);
326 
327         if (_approve) {
328             transferProposal.approvedWeight += weight;
329         } else {
330             transferProposal.disapprovedWeight += weight;
331         }
332     }
333 
334 
335     /**
336      * Calculates the votes and if the majority weigt approved
337      * the proposal the transfer of ownership is executed.
338 
339      * The Crowdsale contact transferres the ownership of the
340      * EngravedToken contract to Engraved
341      */
342     function executeTransfer() afterDeadline atStage(Stages.Proposed) {
343 
344         // Check approved
345 	      require(transferProposal.approvedWeight > transferProposal.disapprovedWeight);
346 
347 	      require(EGREngravedToken.unlock());
348 
349         require(EGREngravedToken.startIncentiveDistribution());
350 
351         EGREngravedToken.transferOwnership(transferProposal.engravedAddress);
352 	      require(EGREngravedToken.owner() == transferProposal.engravedAddress);
353 
354         require(transferProposal.engravedAddress.send(this.balance));
355 
356         stage = Stages.Accepted;
357     }
358 
359 
360     /**
361      * Receives ETH and issue EGR EngravedTokens to the sender
362      */
363     function () payable atStage(Stages.InProgress) {
364 
365         // Crowdsale not started yet
366         require(now > start);
367 
368         // Crowdsale expired
369         require(now < end);
370 
371         // Enforce min amount
372 	      require(msg.value >= minAcceptedAmount);
373 
374         uint256 received = msg.value;
375         uint256 valueInEGR = toEGR(msg.value);
376 
377         require((EGREngravedToken.totalSupply() + valueInEGR) <= (maxSupply * 10**3));
378 
379         require(EGREngravedToken.issue(msg.sender, valueInEGR));
380 
381         balances[msg.sender] += received;
382         raised += received;
383     }
384 }