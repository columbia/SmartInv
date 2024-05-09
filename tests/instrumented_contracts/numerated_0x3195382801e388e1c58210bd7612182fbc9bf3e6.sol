1 pragma solidity ^0.4.19;
2 
3 contract Questions {
4     struct Question {
5         address creator;
6         uint paymentForAnswer;
7         uint8 maxAnswers;
8         uint8 answerCount;
9         int minVoteWeight;
10     }
11     
12     struct Answer {
13         bool placed;
14         int rating;
15         uint8 votes;
16     }
17     
18     address public owner;
19     uint private ownerBalance;
20     
21     uint public minPaymentForAnswer = 1 finney;
22     uint public votesForAnswer = 5;
23     int public maxAbsKindness = 25;
24     uint public resetVoteKindnessEvery = 5000;
25     uint public minVoteWeightK = 1 finney;
26     
27     mapping (uint => Question) public questions;
28     uint public currentQuestionId = 0;
29     
30     // questionId => creator => rating
31     mapping (uint => mapping (address => Answer)) public answers;
32     
33     // questionId => creator => voter => true
34     mapping (uint => mapping (address => mapping (address => bool))) public votes;
35     
36     // voter => kindness
37     mapping (address => int8) public voteKindness;
38     
39     // user => vote kindness reset
40     mapping (address => uint) public voteKindnessReset;
41     
42     // user => vote weight
43     mapping (address => int) public voteWeight;
44     
45     event FundTransfer(address backer, uint amount, bool isContribution);
46     event PlaceQuestion(
47         uint indexed questionId,
48         address indexed creator,
49         uint paymentForAnswer,
50         uint8 maxAnswers,
51         uint minVoteWeight,
52         string text
53     );
54     event PlaceAnswer(
55         uint indexed questionId,
56         address indexed creator,
57         string text
58     );
59     event Vote(uint indexed questionId, address indexed creator, int ratingDelta);
60     event VoteWeightChange(address indexed user, int weight);
61 
62     modifier onlyOwner {
63         if (msg.sender != owner) revert();
64         _;
65     }
66     
67     function transferOwnership(address newOwner) external onlyOwner {
68         owner = newOwner;
69     }
70     
71     function setMinPaymentForAnswer(uint value) external onlyOwner {
72         require(value < minPaymentForAnswer);
73         minPaymentForAnswer = value;
74     }
75     
76     function setMaxAbsKindness(int value) external onlyOwner {
77         require(value > 0);
78         maxAbsKindness = value;
79     }
80     
81     function setResetVoteKindnessEvery(uint value) external onlyOwner {
82         resetVoteKindnessEvery = value;
83     }
84     
85     function setMinVoteWeightK(uint value) external onlyOwner {
86         minVoteWeightK = value;
87     }
88     
89     function Questions() public {
90         owner = msg.sender;
91     }
92     
93     function safeAdd(uint a, uint b) private pure returns (uint) {
94         uint c = a + b;
95         assert(c >= a);
96         return c;
97     }
98     
99     function safeSub(uint a, uint b) private pure returns (uint) {
100         assert(b <= a);
101         return a - b;
102     }
103     
104     function safeMul(uint a, uint b) private pure returns (uint) {
105         if (a == 0) {
106           return 0;
107         }
108         
109         uint c = a * b;
110         assert(c / a == b);
111         return c;
112     }
113     
114     function changeVoteWeight(address user, int delta) internal {
115         voteWeight[user] += delta;
116         VoteWeightChange(user, voteWeight[user]);
117     }
118     
119     function placeQuestion(uint paymentForAnswer, uint8 maxAnswers, uint minVoteWeight, string text) external payable {
120         require(maxAnswers > 0 && maxAnswers <= 32);
121         require(msg.value == safeMul(paymentForAnswer, safeAdd(maxAnswers, 1)));
122         require(paymentForAnswer >= safeAdd(minPaymentForAnswer, safeMul(minVoteWeight, minVoteWeightK)));
123         uint len = bytes(text).length;
124         require(len > 0 && len <= 1024);
125         
126         uint realPaymentForAnswer = paymentForAnswer / 2;
127         uint realPaymentForVote = realPaymentForAnswer / votesForAnswer;
128         
129         int minVoteWeightI = int(minVoteWeight);
130         require(minVoteWeightI >= 0);
131         
132         questions[currentQuestionId] = Question({
133             creator: msg.sender,
134             paymentForAnswer: realPaymentForAnswer,
135             maxAnswers: maxAnswers,
136             answerCount: 0,
137             minVoteWeight: minVoteWeightI
138         });
139         PlaceQuestion(currentQuestionId, msg.sender, realPaymentForAnswer, maxAnswers, minVoteWeight, text);
140         currentQuestionId++;
141         
142         changeVoteWeight(msg.sender, 1);
143         
144         ownerBalance += msg.value - (realPaymentForAnswer + realPaymentForVote * votesForAnswer) * maxAnswers;
145         
146         FundTransfer(msg.sender, msg.value, true);
147     }
148     
149     function placeAnswer(uint questionId, string text) external {
150         require(questions[questionId].creator != 0x0);
151         require(questions[questionId].creator != msg.sender);
152         require(!answers[questionId][msg.sender].placed);
153         uint len = bytes(text).length;
154         require(len > 0 && len <= 1024);
155         require(questions[questionId].answerCount < questions[questionId].maxAnswers);
156         require(voteWeight[msg.sender] >= questions[questionId].minVoteWeight);
157         
158         questions[questionId].answerCount++;
159         answers[questionId][msg.sender] = Answer({
160             placed: true,
161             rating: 0,
162             votes: 0
163         });
164         PlaceAnswer(questionId, msg.sender, text);
165     }
166     
167     function voteForAnswer(uint questionId, address creator, bool isSpam) external {
168         require(questions[questionId].creator != msg.sender);
169         require(creator != msg.sender);
170         require(answers[questionId][creator].placed);
171         require(answers[questionId][creator].votes < votesForAnswer);
172         require(!votes[questionId][creator][msg.sender]);
173         require(voteWeight[msg.sender] > 0);
174         require(voteWeight[msg.sender] >= questions[questionId].minVoteWeight);
175         
176         if (voteKindnessReset[msg.sender] + resetVoteKindnessEvery <= block.number) {
177             voteKindness[msg.sender] = 0;
178             voteKindnessReset[msg.sender] = block.number;
179         }
180         
181         if (isSpam) {
182             require(voteKindness[msg.sender] > -maxAbsKindness);
183             voteKindness[msg.sender]--;
184         } else {
185             require(voteKindness[msg.sender] < maxAbsKindness);
186             voteKindness[msg.sender]++;
187         }
188         
189         int ratingDelta = isSpam ? -voteWeight[msg.sender] : voteWeight[msg.sender];
190         votes[questionId][creator][msg.sender] = true;
191         answers[questionId][creator].votes++;
192         answers[questionId][creator].rating += ratingDelta;
193         Vote(questionId, creator, ratingDelta);
194         
195         uint payment = questions[questionId].paymentForAnswer / votesForAnswer;
196         msg.sender.transfer(payment);
197         FundTransfer(msg.sender, payment, false);
198         
199         if (answers[questionId][creator].votes == votesForAnswer) {
200             if (answers[questionId][creator].rating > 0) {
201                 creator.transfer(questions[questionId].paymentForAnswer);
202                 FundTransfer(creator, questions[questionId].paymentForAnswer, false);
203                 
204                 changeVoteWeight(creator, 5);
205             } else {
206                 questions[questionId].creator.transfer(questions[questionId].paymentForAnswer);
207                 FundTransfer(questions[questionId].creator, questions[questionId].paymentForAnswer, false);
208                 
209                 changeVoteWeight(creator, -5);
210             }
211         }
212     }
213     
214     function withdrawEther() external onlyOwner {
215         owner.transfer(ownerBalance);
216         ownerBalance = 0;
217     }
218 }