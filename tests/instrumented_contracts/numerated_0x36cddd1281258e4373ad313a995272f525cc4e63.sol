1 pragma solidity ^0.4.15;
2 
3 contract IToken { 
4     function issue(address _recipient, uint256 _value) returns (bool);
5     function totalSupply() constant returns (uint256);
6     function unlock() returns (bool);
7 }
8 
9 contract CoinoorCrowdsale {
10 
11     // Crowdsale details
12     address public beneficiary; // Company address multisig (100% eth + 4.9 mln tokens)
13     address public creator; // Creator (.25 mln tokens)
14     address public marketing; // Marketing team (2.5 mln tokens)
15     address public bounty; // Bounty (100k tokens)
16     address public confirmedBy; // Address that confirmed beneficiary
17     uint256 public maxSupply = 65000000 * 10**8; // 65 mln tokens
18     uint256 public minAcceptedAmount = 40 finney; // 1/25 ether
19 
20     // Eth to CNR rate
21     uint256 public ratePreICO = 450; // 50% bonus
22     uint256 public rateWaiting = 0;
23     uint256 public rateAngelDay = 420; // 40% bonus
24     uint256 public rateFirstWeek = 390; // 30% bonus
25     uint256 public rateSecondWeek = 375; // 25% bonus
26     uint256 public rateThirdWeek = 360; // 20% bonus
27     uint256 public rateLastWeek = 330; // 10% bonus
28 
29     uint256 public ratePreICOEnd = 10 days;
30     uint256 public rateWaitingEnd = 20 days;
31     uint256 public rateAngelDayEnd = 21 days;
32     uint256 public rateFirstWeekEnd = 28 days;
33     uint256 public rateSecondWeekEnd = 35 days;
34     uint256 public rateThirdWeekEnd = 42 days;
35     uint256 public rateLastWeekEnd = 49 days;
36 
37     enum Stages {
38         Deploying,
39         InProgress,
40         Ended
41     }
42 
43     Stages public stage = Stages.Deploying;
44 
45     // Crowdsale state
46     uint256 public start;
47     uint256 public end;
48     uint256 public raised;
49 
50     // Token
51     IToken public token;
52 
53 
54     /**
55      * Throw if at stage other than current stage
56      * 
57      * @param _stage expected stage to test for
58      */
59     modifier atStage(Stages _stage) {
60         require(stage == _stage);
61 
62         _;
63     }
64     
65 
66     /**
67      * Throw if sender is not beneficiary
68      */
69     modifier onlyBeneficiary() {
70         require(beneficiary == msg.sender);
71 
72         _;
73     }
74 
75 
76     /**
77      * Construct
78      *
79      * @param _tokenAddress The address of the token contact
80      * @param _beneficiary The address of the beneficiary
81      * @param _creator The address of the tech team
82      * @param _marketing The address of the marketing team
83      * @param _bounty The address of the bounty wallet
84      * @param _start The timestamp of the start date
85      */
86     function CoinoorCrowdsale(address _tokenAddress, address _beneficiary, address _creator, address _marketing, address _bounty, uint256 _start) {
87         token = IToken(_tokenAddress);
88         beneficiary = _beneficiary;
89         creator = _creator;
90         marketing = _marketing;
91         bounty = _bounty;
92         start = _start;
93         end = start + rateLastWeekEnd;
94     }
95 
96 
97     /**
98      * Deploy and start the crowdsale
99      */
100     function init() atStage(Stages.Deploying) {
101         stage = Stages.InProgress;
102 
103         // Create tokens
104         if (!token.issue(beneficiary, 4900000 * 10**8)) {
105             stage = Stages.Deploying;
106             revert();
107         }
108 
109         if (!token.issue(creator, 2500000 * 10**8)) {
110             stage = Stages.Deploying;
111             revert();
112         }
113 
114         if (!token.issue(marketing, 2500000 * 10**8)) {
115             stage = Stages.Deploying;
116             revert();
117         }
118 
119         if (!token.issue(bounty, 100000 * 10**8)) {
120             stage = Stages.Deploying;
121             revert();
122         }
123     }
124 
125 
126     /**
127      * For testing purposes
128      *
129      * @return The beneficiary address
130      */
131     function confirmBeneficiary() onlyBeneficiary {
132         confirmedBy = msg.sender;
133     }
134 
135 
136     /**
137      * Convert `_wei` to an amount in tokens using 
138      * the current rate
139      *
140      * @param _wei amount of wei to convert
141      * @return The amount in tokens
142      */
143     function toTokens(uint256 _wei) returns (uint256 amount) {
144         uint256 rate = 0;
145         if (stage != Stages.Ended && now >= start && now <= end) {
146 
147             // Check for preico
148             if (now <= start + ratePreICOEnd) {
149                 rate = ratePreICO;
150             }
151 
152             // Check for waiting period
153             else if (now <= start + rateWaitingEnd) {
154                 rate = rateWaiting;
155             }
156 
157             // Check for angelday
158             else if (now <= start + rateAngelDayEnd) {
159                 rate = rateAngelDay;
160             }
161 
162             // Check first week
163             else if (now <= start + rateFirstWeekEnd) {
164                 rate = rateFirstWeek;
165             }
166 
167             // Check second week
168             else if (now <= start + rateSecondWeekEnd) {
169                 rate = rateSecondWeek;
170             }
171 
172             // Check third week
173             else if (now <= start + rateThirdWeekEnd) {
174                 rate = rateThirdWeek;
175             }
176 
177             // Check last week
178             else if (now <= start + rateLastWeekEnd) {
179                 rate = rateLastWeek;
180             }
181         }
182 
183         return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals
184     }
185 
186 
187     /**
188      * Function to end the crowdsale by setting 
189      * the stage to Ended
190      */
191     function endCrowdsale() atStage(Stages.InProgress) {
192         require(now > end);
193 
194         stage = Stages.Ended;
195         if (!token.unlock()) {
196             stage = Stages.InProgress;
197         }
198     }
199 
200 
201     /**
202      * Transfer appropriate percentage of raised amount 
203      * to the company address
204      */
205     function withdraw() onlyBeneficiary atStage(Stages.Ended) {
206         beneficiary.transfer(this.balance);
207     }
208 
209     
210     /**
211      * Receives Eth and issue tokens to the sender
212      */
213     function () payable atStage(Stages.InProgress) {
214 
215         // Crowdsale not started yet
216         require(now >= start);
217 
218         // Crowdsale expired
219         require(now <= end);
220 
221         // Enforce min amount
222         require(msg.value >= minAcceptedAmount);
223  
224         address sender = msg.sender;
225         uint256 received = msg.value;
226         uint256 valueInTokens = toTokens(received);
227 
228         // Period between pre-ico and ico
229         require(valueInTokens > 0);
230 
231         // Track
232         raised += received;
233 
234         // Check max supply
235         if (token.totalSupply() + valueInTokens >= maxSupply) {
236             stage = Stages.Ended;
237         }
238 
239         // Create tokens
240         if (!token.issue(sender, valueInTokens)) {
241             revert();
242         }
243 
244         // 100% eth
245         if (!beneficiary.send(received)) {
246             revert();
247         }
248     }
249 }