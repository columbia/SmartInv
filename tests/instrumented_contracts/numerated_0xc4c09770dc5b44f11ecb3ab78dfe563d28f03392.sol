1 pragma solidity 0.4.18;
2 
3 
4 contract EngravedToken {
5     uint256 public totalSupply;
6     function issue(address, uint256) public returns (bool) {}
7     function balanceOf(address) public constant returns (uint256) {}
8     function unlock() public returns (bool) {}
9     function startIncentiveDistribution() public returns (bool) {}
10     function transferOwnership(address) public {}
11     function owner() public returns (address) {}
12 }
13 
14 
15 contract EGRCrowdsale {
16     // Crowdsale details
17     address public beneficiary;
18     address public confirmedBy; // Address that confirmed beneficiary
19 
20     // Maximum tokens supply
21     uint256 public maxSupply = 1000000000; // 1 billion
22 
23     // Minum amount of ether to be exchanged for EGR
24     uint256 public minAcceptedAmount = 10 finney; // 0.01 ETH
25 
26     //Amount of free tokens per user in airdrop period
27     uint256 public rateAirDrop = 1000;
28 
29     // Number of airdrop participants
30     uint256 public airdropParticipants;
31 
32     //Maximum number of airdrop participants
33     uint256 public maxAirdropParticipants = 500;
34 
35     // Check if this is the first participation in the airdrop
36     mapping (address => bool) public participatedInAirdrop;
37 
38     // ETH to EGR rate
39     uint256 public rateAngelsDay = 100000;
40     uint256 public rateFirstWeek = 80000;
41     uint256 public rateSecondWeek = 70000;
42     uint256 public rateThirdWeek = 60000;
43     uint256 public rateLastWeek = 50000;
44 
45     uint256 public airdropEnd = 3 days;
46     uint256 public airdropCooldownEnd = 7 days;
47     uint256 public rateAngelsDayEnd = 8 days;
48     uint256 public angelsDayCooldownEnd = 14 days;
49     uint256 public rateFirstWeekEnd = 21 days;
50     uint256 public rateSecondWeekEnd = 28 days;
51     uint256 public rateThirdWeekEnd = 35 days;
52     uint256 public rateLastWeekEnd = 42 days;
53 
54     enum Stages {
55         Airdrop,
56         InProgress,
57         Ended,
58         Withdrawn,
59         Proposed,
60         Accepted
61     }
62 
63     Stages public stage = Stages.Airdrop;
64 
65     // Crowdsale state
66     uint256 public start;
67     uint256 public end;
68     uint256 public raised;
69 
70     // EGR EngravedToken
71     EngravedToken public engravedToken;
72 
73     // Invested balances
74     mapping (address => uint256) internal balances;
75 
76     struct Proposal {
77         address engravedAddress;
78         uint256 deadline;
79         uint256 approvedWeight;
80         uint256 disapprovedWeight;
81         mapping (address => uint256) voted;
82     }
83 
84     // Ownership transfer proposal
85     Proposal public transferProposal;
86 
87     // Time to vote
88     uint256 public transferProposalEnd = 7 days;
89 
90     // Time between proposals
91     uint256 public transferProposalCooldown = 1 days;
92 
93     /**
94      * Throw if at stage other than current stage
95      *
96      * @param _stage expected stage to test for
97      */
98     modifier atStage(Stages _stage) {
99         require(stage == _stage);
100         _;
101     }
102 
103     /**
104      * Throw if at stage other than current stage
105      *
106      * @param _stage1 expected stage to test for
107      * @param _stage2 expected stage to test for
108      */
109     modifier atStages(Stages _stage1, Stages _stage2) {
110         require(stage == _stage1 || stage == _stage2);
111         _;
112     }
113 
114     /**
115      * Throw if sender is not beneficiary
116      */
117     modifier onlyBeneficiary() {
118         require(beneficiary == msg.sender);
119         _;
120     }
121 
122     /**
123      * Throw if sender has a EGR balance of zero
124      */
125     modifier onlyTokenholders() {
126         require(engravedToken.balanceOf(msg.sender) > 0);
127         _;
128     }
129 
130     /**
131      * Throw if the current transfer proposal's deadline
132      * is in the past
133      */
134     modifier beforeDeadline() {
135         require(now < transferProposal.deadline);
136         _;
137     }
138 
139     /**
140      * Throw if the current transfer proposal's deadline
141      * is in the future
142      */
143     modifier afterDeadline() {
144         require(now > transferProposal.deadline);
145         _;
146     }
147 
148     /**
149      * Most params are hardcoded for clarity
150      *
151      * @param _engravedTokenAddress The address of the EGR EngravedToken contact
152      * @param _beneficiary Company address
153      * @param _start airdrop start date
154      */
155     function EGRCrowdsale(address _engravedTokenAddress, address _beneficiary, uint256 _start) public {
156         engravedToken = EngravedToken(_engravedTokenAddress);
157         beneficiary = _beneficiary;
158         start = _start;
159         end = start + 42 days;
160     }
161 
162     /**
163      * Receives ETH and issue EGR EngravedTokens to the sender
164      */
165     function() public payable atStage(Stages.InProgress) {
166         // Crowdsale not started and not ended yet
167         // Enforce min amount
168         require(now > start && now < end && msg.value >= minAcceptedAmount);
169 
170         uint256 valueInEGR = toEGR(msg.value);
171 
172         require((engravedToken.totalSupply() + valueInEGR) <= (maxSupply * 10**3));
173         require(engravedToken.issue(msg.sender, valueInEGR));
174 
175         uint256 received = msg.value;
176         balances[msg.sender] += received;
177         raised += received;
178     }
179 
180     /**
181      * Get balance of `_investor`
182      *
183      * @param _investor The address from which the balance will be retrieved
184      * @return The balance
185      */
186     function balanceOf(address _investor) public view returns (uint256 balance) {
187         return balances[_investor];
188     }
189 
190     /**
191      * For testing purposes
192      *
193      * @return The beneficiary address
194      */
195     function confirmBeneficiary() public onlyBeneficiary {
196         confirmedBy = msg.sender;
197     }
198 
199     /**
200      * Convert `_wei` to an amount in EGR using
201      * the current rate
202      *
203      * @param _wei amount of wei to convert
204      * @return The amount in EGR
205      */
206     function toEGR(uint256 _wei) public view returns (uint256 amount) {
207         uint256 rate = 0;
208         if (stage != Stages.Ended && now >= start && now <= end) {
209             // Check for cool down after airdrop
210             if (now <= start + airdropCooldownEnd) {
211                 rate = 0;
212             // Check for AngelsDay
213             } else if (now <= start + rateAngelsDayEnd) {
214                 rate = rateAngelsDay;
215             // Check for cool down after the angels day
216             } else if (now <= start + angelsDayCooldownEnd) {
217                 rate = 0;
218             // Check first week
219             } else if (now <= start + rateFirstWeekEnd) {
220                 rate = rateFirstWeek;
221             // Check second week
222             } else if (now <= start + rateSecondWeekEnd) {
223                 rate = rateSecondWeek;
224             // Check third week
225             } else if (now <= start + rateThirdWeekEnd) {
226                 rate = rateThirdWeek;
227             // Check last week
228             } else if (now <= start + rateLastWeekEnd) {
229                 rate = rateLastWeek;
230             }
231         }
232         require(rate != 0); // Check for cool down periods
233         return _wei * rate * 10**3 / 1 ether; // 10**3 for 3 decimals
234     }
235 
236     /**
237     * Function to participate in the airdrop
238     */
239     function claim() public atStage(Stages.Airdrop) {
240         // Crowdsal not started yet nor Airdrop expired
241         // Only once per address
242         require(airdropParticipants < maxAirdropParticipants
243             && now > start && now < start + airdropEnd
244             && participatedInAirdrop[msg.sender] == false);
245 
246         require(engravedToken.issue(msg.sender, rateAirDrop * 10**3));
247 
248         participatedInAirdrop[msg.sender] = true;
249         airdropParticipants += 1;
250     }
251 
252     /**
253      * Function to end the airdrop and start crowdsale
254      */
255     function endAirdrop() public atStage(Stages.Airdrop) {
256         require(now > start + airdropEnd);
257         stage = Stages.InProgress;
258     }
259 
260     /**
261      * Function to end the crowdsale by setting
262      * the stage to Ended
263      */
264     function endCrowdsale() public atStage(Stages.InProgress) {
265         // Crowdsale not ended yet
266         require(now > end);
267         stage = Stages.Ended;
268     }
269 
270     /**
271      * Transfer raised amount to the company address
272      */
273     function withdraw() public onlyBeneficiary atStage(Stages.Ended) {
274         require(beneficiary.send(raised));
275         stage = Stages.Withdrawn;
276     }
277 
278     /**
279      * Transfer custom amount to a custom address
280      */
281     function withdrawCustom(uint256 amount, address addressee) public onlyBeneficiary atStage(Stages.Ended) {
282         require(addressee.send(amount));
283         raised = raised - amount;
284         if (raised == 0) {
285             stage = Stages.Withdrawn;
286         }
287     }
288 
289     /**
290      * Emergency stage change to Withdrawn
291      */
292     function moveStageWithdrawn() public onlyBeneficiary atStage(Stages.Ended) {
293         stage = Stages.Withdrawn;
294     }
295 
296     /**
297      * Propose the transfer of the EngravedToken contract ownership
298      * to `_engravedAddress`
299      *
300      * @param _engravedAddress the address of the proposed EngravedToken owner
301      */
302     function proposeTransfer(address _engravedAddress) public onlyBeneficiary
303     atStages(Stages.Withdrawn, Stages.Proposed) {
304         // Check for a pending proposal
305         require(stage != Stages.Proposed || now > transferProposal.deadline + transferProposalCooldown);
306 
307         transferProposal = Proposal({
308             engravedAddress: _engravedAddress,
309             deadline: now + transferProposalEnd,
310             approvedWeight: 0,
311             disapprovedWeight: 0
312         });
313 
314         stage = Stages.Proposed;
315     }
316 
317     /**
318      * Allows EGR holders to vote on the poposed transfer of
319      * ownership. Weight is calculated directly, this is no problem
320      * because EngravedTokens cannot be transferred yet
321      *
322      * @param _approve indicates if the sender supports the proposal
323      */
324     function vote(bool _approve) public onlyTokenholders beforeDeadline atStage(Stages.Proposed) {
325         // One vote per proposal
326         require(transferProposal.voted[msg.sender] < transferProposal.deadline - transferProposalEnd);
327 
328         transferProposal.voted[msg.sender] = now;
329         uint256 weight = engravedToken.balanceOf(msg.sender);
330 
331         if (_approve) {
332             transferProposal.approvedWeight += weight;
333         } else {
334             transferProposal.disapprovedWeight += weight;
335         }
336     }
337 
338     /**
339      * Calculates the votes and if the majority weigt approved
340      * the proposal the transfer of ownership is executed.
341 
342      * The Crowdsale contact transferres the ownership of the
343      * EngravedToken contract to Engraved
344      */
345     function executeTransfer() public afterDeadline atStage(Stages.Proposed) {
346         // Check approved
347         require(transferProposal.approvedWeight > transferProposal.disapprovedWeight);
348         require(engravedToken.unlock());
349         require(engravedToken.startIncentiveDistribution());
350 
351         engravedToken.transferOwnership(transferProposal.engravedAddress);
352 
353         require(engravedToken.owner() == transferProposal.engravedAddress);
354 
355         stage = Stages.Accepted;
356     }
357 
358 }