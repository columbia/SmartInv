1 pragma solidity ^0.4.18;
2 
3 
4 contract BlockFoodPreSale {
5 
6     enum ApplicationState {Unset, Pending, Rejected, Accepted, Refunded}
7 
8     struct Application {
9         uint contribution;
10         string id;
11         ApplicationState state;
12     }
13 
14     struct Applicant {
15         address applicant;
16         string id;
17     }
18 
19     /*
20         Set by constructor
21     */
22     address public owner;
23     address public target;
24     uint public endDate;
25     uint public minContribution;
26     uint public minCap;
27     uint public maxCap;
28 
29     /*
30         Set by functions
31     */
32     mapping(address => Application) public applications;
33     Applicant[] public applicants;
34     uint public contributionPending;
35     uint public contributionRejected;
36     uint public contributionAccepted;
37     uint public withdrawn;
38 
39     /*
40         Events
41     */
42     event PendingApplication(address applicant, uint contribution, string id);
43     event RejectedApplication(address applicant, uint contribution, string id);
44     event AcceptedApplication(address applicant, uint contribution, string id);
45     event Withdrawn(address target, uint amount);
46     event Refund(address target, uint amount);
47     event ContractUpdate(address owner, address target, uint minContribution, uint minCap, uint maxCap);
48 
49     /*
50         Modifiers
51     */
52     modifier onlyBeforeEnd() {
53         require(now <= endDate);
54         _;
55     }
56 
57     modifier onlyMoreThanMinContribution() {
58         require(msg.value >= minContribution);
59         _;
60     }
61 
62     modifier onlyMaxCapNotReached() {
63         require((contributionAccepted + msg.value) <= maxCap);
64         _;
65     }
66 
67     modifier onlyOwner () {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     modifier onlyNewApplicant () {
73         require(applications[msg.sender].state == ApplicationState.Unset);
74         _;
75     }
76 
77     modifier onlyPendingApplication(address applicant) {
78         require(applications[applicant].contribution > 0);
79         require(applications[applicant].state == ApplicationState.Pending);
80         _;
81     }
82 
83     modifier onlyMinCapReached() {
84         require(contributionAccepted >= minCap);
85         _;
86     }
87 
88     modifier onlyNotWithdrawn(uint amount) {
89         require(withdrawn + amount <= contributionAccepted);
90         _;
91     }
92 
93     modifier onlyFailedPreSale() {
94         require(now >= endDate);
95         require(contributionAccepted + contributionPending < minCap);
96         _;
97     }
98 
99     modifier onlyAcceptedApplication(address applicant) {
100         require(applications[applicant].state == ApplicationState.Accepted);
101         _;
102     }
103 
104     modifier onlyAfterTwoMonthsAfterTheEnd() {
105         require(now > (endDate + 60 days));
106         _;
107     }
108 
109     modifier sendContractUpdateEvent() {
110         _;
111         ContractUpdate(owner, target, minContribution, minCap, maxCap);
112     }
113 
114     /*
115         Constructor
116     */
117     function BlockFoodPreSale(
118         address target_,
119         uint endDate_,
120         uint minContribution_,
121         uint minCap_,
122         uint maxCap_
123     )
124     public
125     {
126         owner = msg.sender;
127 
128         target = target_;
129         endDate = endDate_;
130         minContribution = minContribution_;
131         minCap = minCap_;
132         maxCap = maxCap_;
133     }
134 
135     /*
136        Public functions
137     */
138 
139     function apply(string id)
140     payable
141     public
142     onlyBeforeEnd
143     onlyMoreThanMinContribution
144     onlyMaxCapNotReached
145     onlyNewApplicant
146     {
147         applications[msg.sender] = Application(msg.value, id, ApplicationState.Pending);
148         applicants.push(Applicant(msg.sender, id));
149         contributionPending += msg.value;
150         PendingApplication(msg.sender, msg.value, id);
151     }
152 
153     function refund()
154     public
155     onlyFailedPreSale
156     onlyAcceptedApplication(msg.sender)
157     {
158         applications[msg.sender].state = ApplicationState.Refunded;
159         msg.sender.transfer(applications[msg.sender].contribution);
160         Refund(msg.sender, applications[msg.sender].contribution);
161     }
162 
163     /*
164         Restricted functions (owner only)
165     */
166 
167     function reject(address applicant)
168     public
169     onlyOwner
170     onlyPendingApplication(applicant)
171     {
172         applications[applicant].state = ApplicationState.Rejected;
173 
174         // protection against function reentry on an overriden transfer() function
175         uint contribution = applications[applicant].contribution;
176         applications[applicant].contribution = 0;
177         applicant.transfer(contribution);
178 
179         contributionPending -= contribution;
180         contributionRejected += contribution;
181 
182         RejectedApplication(applicant, contribution, applications[applicant].id);
183     }
184 
185     function accept(address applicant)
186     public
187     onlyOwner
188     onlyPendingApplication(applicant)
189     {
190         applications[applicant].state = ApplicationState.Accepted;
191 
192         contributionPending -= applications[applicant].contribution;
193         contributionAccepted += applications[applicant].contribution;
194 
195         AcceptedApplication(applicant, applications[applicant].contribution, applications[applicant].id);
196     }
197 
198     function withdraw(uint amount)
199     public
200     onlyOwner
201     onlyMinCapReached
202     onlyNotWithdrawn(amount)
203     {
204         withdrawn += amount;
205         target.transfer(amount);
206         Withdrawn(target, amount);
207     }
208 
209     /*
210         Views
211     */
212 
213     function getApplicantsLength()
214     view
215     public
216     returns (uint)
217     {
218         return applicants.length;
219     }
220 
221     function getMaximumContributionPossible()
222     view
223     public
224     returns (uint)
225     {
226         return maxCap - contributionAccepted;
227     }
228 
229     /*
230         Maintenance functions
231     */
232 
233     function failsafe()
234     public
235     onlyOwner
236     onlyAfterTwoMonthsAfterTheEnd
237     {
238         target.transfer(this.balance);
239     }
240 
241     function changeOwner(address owner_)
242     public
243     onlyOwner
244     sendContractUpdateEvent
245     {
246         owner = owner_;
247     }
248 
249     function changeTarget(address target_)
250     public
251     onlyOwner
252     sendContractUpdateEvent
253     {
254         target = target_;
255     }
256 
257     function changeMinCap(uint minCap_)
258     public
259     onlyOwner
260     sendContractUpdateEvent
261     {
262         minCap = minCap_;
263     }
264 
265     function changeMaxCap(uint maxCap_)
266     public
267     onlyOwner
268     sendContractUpdateEvent
269     {
270         maxCap = maxCap_;
271     }
272 
273     function changeMinContribution(uint minContribution_)
274     public
275     onlyOwner
276     sendContractUpdateEvent
277     {
278         minContribution = minContribution_;
279     }
280 
281 }