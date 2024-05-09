1 contract Token {
2     
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address owner) constant returns (uint256 balance);
5     function transfer(address to, uint256 value) returns (bool success);
6     function transferFrom(address from, address to, uint256 value) returns (bool success);
7     function approve(address spender, uint256 value) returns (bool success);
8     function allowance(address owner, address spender) constant returns (uint256 remaining);
9 
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 
15 
16 contract SingularDTVToken is Token {
17     function issueTokens(address _for, uint tokenCount) returns (bool);
18 }
19 contract SingularDTVFund {
20     function workshop() returns (address);
21     function softWithdrawRevenueFor(address forAddress) returns (uint);
22 }
23 
24 
25 
26 
27 contract SingularDTVCrowdfunding {
28 
29     /*
30      *  External contracts
31      */
32     SingularDTVToken public singularDTVToken;
33     SingularDTVFund public singularDTVFund;
34 
35     /*
36      *  Constants
37      */
38     uint constant public CAP = 1000000000; 
39     uint constant public CROWDFUNDING_PERIOD = 4 weeks; 
40     uint constant public TOKEN_LOCKING_PERIOD = 2 years; 
41     uint constant public TOKEN_TARGET = 534000000; 
42 
43     /*
44      *  Enums
45      */
46     enum Stages {
47         CrowdfundingGoingAndGoalNotReached,
48         CrowdfundingEndedAndGoalNotReached,
49         CrowdfundingGoingAndGoalReached,
50         CrowdfundingEndedAndGoalReached
51     }
52 
53     /*
54      *  Storage
55      */
56     address public owner;
57     uint public startDate;
58     uint public fundBalance;
59     uint public baseValue = 1250 szabo; 
60     uint public valuePerShare = baseValue; 
61 
62     
63     mapping (address => uint) public investments;
64 
65     
66     Stages public stage = Stages.CrowdfundingGoingAndGoalNotReached;
67 
68     /*
69      *  Modifiers
70      */
71     modifier noEther() {
72         if (msg.value > 0) {
73             throw;
74         }
75         _
76     }
77 
78     modifier onlyOwner() {
79         
80         if (msg.sender != owner) {
81             throw;
82         }
83         _
84     }
85 
86     modifier minInvestment() {
87         
88         if (msg.value < valuePerShare) {
89             throw;
90         }
91         _
92     }
93 
94     modifier atStage(Stages _stage) {
95         if (stage != _stage) {
96             throw;
97         }
98         _
99     }
100 
101     modifier atStageOR(Stages _stage1, Stages _stage2) {
102         if (stage != _stage1 && stage != _stage2) {
103             throw;
104         }
105         _
106     }
107 
108     modifier timedTransitions() {
109         uint crowdfundDuration = now - startDate;
110         if (crowdfundDuration >= 22 days) {
111             valuePerShare = baseValue * 1500 / 1000;
112         }
113         else if (crowdfundDuration >= 18 days) {
114             valuePerShare = baseValue * 1375 / 1000;
115         }
116         else if (crowdfundDuration >= 14 days) {
117             valuePerShare = baseValue * 1250 / 1000;
118         }
119         else if (crowdfundDuration >= 10 days) {
120             valuePerShare = baseValue * 1125 / 1000;
121         }
122         else {
123             valuePerShare = baseValue;
124         }
125         if (crowdfundDuration >= CROWDFUNDING_PERIOD) {
126             if (stage == Stages.CrowdfundingGoingAndGoalNotReached) {
127                 stage = Stages.CrowdfundingEndedAndGoalNotReached;
128             }
129             else if (stage == Stages.CrowdfundingGoingAndGoalReached) {
130                 stage = Stages.CrowdfundingEndedAndGoalReached;
131             }
132         }
133         _
134     }
135 
136     /*
137      *  Contract functions
138      */
139     
140     function checkInvariants() constant internal {
141         if (fundBalance > this.balance) {
142             throw;
143         }
144     }
145 
146     
147     function emergencyCall()
148         external
149         noEther
150         returns (bool)
151     {
152         if (fundBalance > this.balance) {
153             if (this.balance > 0 && !singularDTVFund.workshop().send(this.balance)) {
154                 throw;
155             }
156             return true;
157         }
158         return false;
159     }
160 
161     
162     function fund()
163         external
164         timedTransitions
165         atStageOR(Stages.CrowdfundingGoingAndGoalNotReached, Stages.CrowdfundingGoingAndGoalReached)
166         minInvestment
167         returns (uint)
168     {
169         uint tokenCount = msg.value / valuePerShare; 
170         if (singularDTVToken.totalSupply() + tokenCount > CAP) {
171             
172             tokenCount = CAP - singularDTVToken.totalSupply();
173         }
174         uint investment = tokenCount * valuePerShare; 
175         
176         if (msg.value > investment && !msg.sender.send(msg.value - investment)) {
177             throw;
178         }
179         
180         fundBalance += investment;
181         investments[msg.sender] += investment;
182         if (!singularDTVToken.issueTokens(msg.sender, tokenCount)) {
183             
184             throw;
185         }
186         
187         if (stage == Stages.CrowdfundingGoingAndGoalNotReached) {
188             if (singularDTVToken.totalSupply() >= TOKEN_TARGET) {
189                 stage = Stages.CrowdfundingGoingAndGoalReached;
190             }
191         }
192         
193         if (stage == Stages.CrowdfundingGoingAndGoalReached) {
194             if (singularDTVToken.totalSupply() == CAP) {
195                 stage = Stages.CrowdfundingEndedAndGoalReached;
196             }
197         }
198         checkInvariants();
199         return tokenCount;
200     }
201 
202     
203     function withdrawFunding()
204         external
205         noEther
206         timedTransitions
207         atStage(Stages.CrowdfundingEndedAndGoalNotReached)
208         returns (bool)
209     {
210         
211         uint investment = investments[msg.sender];
212         investments[msg.sender] = 0;
213         fundBalance -= investment;
214         
215         if (investment > 0  && !msg.sender.send(investment)) {
216             throw;
217         }
218         checkInvariants();
219         return true;
220     }
221 
222     
223     function withdrawForWorkshop()
224         external
225         noEther
226         timedTransitions
227         atStage(Stages.CrowdfundingEndedAndGoalReached)
228         returns (bool)
229     {
230         uint value = fundBalance;
231         fundBalance = 0;
232         if (value > 0  && !singularDTVFund.workshop().send(value)) {
233             throw;
234         }
235         checkInvariants();
236         return true;
237     }
238 
239     
240     
241     function changeBaseValue(uint valueInWei)
242         external
243         noEther
244         onlyOwner
245         returns (bool)
246     {
247         baseValue = valueInWei;
248         return true;
249     }
250 
251     
252     function twoYearsPassed()
253         constant
254         external
255         noEther
256         returns (bool)
257     {
258         return now - startDate >= TOKEN_LOCKING_PERIOD;
259     }
260 
261     
262     function campaignEndedSuccessfully()
263         constant
264         external
265         noEther
266         returns (bool)
267     {
268         if (stage == Stages.CrowdfundingEndedAndGoalReached) {
269             return true;
270         }
271         return false;
272     }
273 
274     
275     
276     
277     function updateStage()
278         external
279         timedTransitions
280         noEther
281         returns (Stages)
282     {
283         return stage;
284     }
285 
286     
287     
288     
289     function setup(address singularDTVFundAddress, address singularDTVTokenAddress)
290         external
291         onlyOwner
292         noEther
293         returns (bool)
294     {
295         if (address(singularDTVFund) == 0 && address(singularDTVToken) == 0) {
296             singularDTVFund = SingularDTVFund(singularDTVFundAddress);
297             singularDTVToken = SingularDTVToken(singularDTVTokenAddress);
298             return true;
299         }
300         return false;
301     }
302 
303     
304     function SingularDTVCrowdfunding() noEther {
305         
306         owner = msg.sender;
307         
308         startDate = now;
309     }
310 
311     
312     function () {
313         throw;
314     }
315 }