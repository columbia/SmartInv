1 pragma solidity ^0.4.17;
2 
3 /**
4     This contract represents a sort of time-limited challenge,
5     where users can vote for some candidates.
6     After the deadline comes the contract will define a winner and vote holders can get their reward.
7 **/
8 contract VotingChallenge {
9     uint public challengeDuration;
10     uint public challengePrize;
11     uint public creatorPrize;
12     uint public cryptoVersusPrize;
13     uint public challengeStarted;
14     uint public candidatesNumber;
15     address public creator;
16     uint16 public creatorFee;       // measured in in tenths of a percent
17     address public cryptoVersusWallet;
18     uint16 public cryptoVersusFee;  // measured in in tenths of a percent
19     uint public winner;
20     bool public isVotingPeriod;
21     bool public beforeVoting;
22     uint[] public votes;
23     mapping( address => mapping (uint => uint)) public userVotesDistribution;
24     uint private lastPayment;
25 
26     // Modifiers
27     modifier inVotingPeriod() {
28         require(isVotingPeriod);
29         _;
30     }
31 
32     modifier afterVotingPeriod() {
33         require(!isVotingPeriod);
34         _;
35     }
36 
37     modifier onlyCreator() {
38         require(msg.sender == creator);
39         _;
40     }
41 
42     // Events
43     event ChallengeBegins(address _creator, uint16 _creatorFee, uint _candidatesNumber, uint _challengeDuration);
44     event NewVotesFor(address _participant, uint _candidate, uint _votes);
45     event TransferVotes(address _from, address _to, uint _candidateIndex, uint _votes);
46     event EndOfChallenge(uint _winner, uint _winnerVotes, uint _challengePrize);
47     event RewardWasPaid(address _participant, uint _amount);
48     event CreatorRewardWasPaid(address _creator, uint _amount);
49     event CryptoVersusRewardWasPaid(address _cryptoVersusWallet, uint _amount);
50 
51     // Constructor
52     constructor(uint _challengeDuration, uint _candidatesNumber, uint16 _creatorFee) public {
53         challengeDuration = _challengeDuration;
54         candidatesNumber = _candidatesNumber;
55         votes.length = candidatesNumber + 1; // we will never use the first elements of array (with zero index)
56         creator = msg.sender;
57         cryptoVersusWallet = 0xa0bedE75cfeEF0266f8A31b47074F5f9fBE1df80;
58         creatorFee = _creatorFee;
59         cryptoVersusFee = 25;
60         beforeVoting = true;
61 
62         // Check that creatorFee and cryptoVersusFee are less than 1000
63         if(creatorFee > 1000) {
64             creatorFee = 1000;
65             cryptoVersusFee = 0;
66             return;
67         }
68         if(cryptoVersusFee > 1000) {
69             cryptoVersusFee = 1000;
70             creatorFee = 0;
71             return;
72         }
73         if(creatorFee + cryptoVersusFee > 1000) {
74             cryptoVersusFee = 1000 - creatorFee;
75         }
76     }
77 
78     // Last block timestamp getter
79     function getTime() public view returns (uint) {
80         return now;
81     }
82 
83     function getAllVotes() public view returns (uint[]) {
84         return votes;
85     }
86 
87     // Start challenge
88     function startChallenge() public onlyCreator {
89         require(beforeVoting);
90         isVotingPeriod = true;
91         beforeVoting = false;
92         challengeStarted = now;
93 
94         emit ChallengeBegins(creator, creatorFee, candidatesNumber, challengeDuration);
95     }
96 
97     // Change creator address
98     function changeCreator(address newCreator) public onlyCreator {
99         creator = newCreator;
100     }
101 
102     // Change Crypto Versus wallet address
103     function changeWallet(address newWallet) public {
104         require(msg.sender == cryptoVersusWallet);
105         cryptoVersusWallet = newWallet;
106     }
107 
108     // Vote for candidate
109     function voteForCandidate(uint candidate) public payable inVotingPeriod {
110         require(candidate <= candidatesNumber);
111         require(candidate > 0);
112         require(msg.value > 0);
113 
114         lastPayment = msg.value;
115         if(checkEndOfChallenge()) {
116             msg.sender.transfer(lastPayment);
117             return;
118         }
119         lastPayment = 0;
120 
121         // Add new votes for community
122         votes[candidate] += msg.value;
123 
124         // Change the votes distribution
125         userVotesDistribution[msg.sender][candidate] += msg.value;
126 
127         // Fire the event
128         emit NewVotesFor(msg.sender, candidate, msg.value);
129     }
130 
131     // Vote for candidate
132     function voteForCandidate_(uint candidate, address sender) public payable inVotingPeriod {
133         require(candidate <= candidatesNumber);
134         require(candidate > 0);
135         require(msg.value > 0);
136 
137         lastPayment = msg.value;
138         if(checkEndOfChallenge()) {
139             sender.transfer(lastPayment);
140             return;
141         }
142         lastPayment = 0;
143 
144         // Add new votes for community
145         votes[candidate] += msg.value;
146 
147         // Change the votes distribution
148         userVotesDistribution[sender][candidate] += msg.value;
149 
150         // Fire the event
151         emit NewVotesFor(sender, candidate, msg.value);
152     }
153 
154     // Transfer votes to anybody
155     function transferVotes (address to, uint candidate) public inVotingPeriod {
156         require(userVotesDistribution[msg.sender][candidate] > 0);
157         uint votesToTransfer = userVotesDistribution[msg.sender][candidate];
158         userVotesDistribution[msg.sender][candidate] = 0;
159         userVotesDistribution[to][candidate] += votesToTransfer;
160 
161         // Fire the event
162         emit TransferVotes(msg.sender, to, candidate, votesToTransfer);
163     }
164 
165     // Check the deadline
166     // If success then define a winner and close the challenge
167     function checkEndOfChallenge() public inVotingPeriod returns (bool) {
168         if (challengeStarted + challengeDuration > now)
169             return false;
170         uint theWinner;
171         uint winnerVotes;
172         uint actualBalance = address(this).balance - lastPayment;
173 
174         for (uint i = 1; i <= candidatesNumber; i++) {
175             if (votes[i] > winnerVotes) {
176                 winnerVotes = votes[i];
177                 theWinner = i;
178             }
179         }
180         winner = theWinner;
181         creatorPrize = (actualBalance * creatorFee) / 1000;
182         cryptoVersusPrize = (actualBalance * cryptoVersusFee) / 1000;
183         challengePrize = actualBalance - creatorPrize - cryptoVersusPrize;
184         isVotingPeriod = false;
185 
186         // Fire the event
187         emit EndOfChallenge(winner, winnerVotes, challengePrize);
188         return true;
189     }
190 
191     // Send a reward if user voted for a winner
192     function getReward() public afterVotingPeriod {
193         if (userVotesDistribution[msg.sender][winner] > 0) {
194             // Compute a vote ratio and send the reward
195             uint userVotesForWinner = userVotesDistribution[msg.sender][winner];
196             userVotesDistribution[msg.sender][winner] = 0;
197             uint reward = (challengePrize * userVotesForWinner) / votes[winner];
198             msg.sender.transfer(reward);
199 
200             // Fire the event
201             emit RewardWasPaid(msg.sender, reward);
202         }
203     }
204 
205     // Send a reward if user voted for a winner
206     function sendReward(address to) public afterVotingPeriod {
207         if (userVotesDistribution[to][winner] > 0) {
208             // Compute a vote ratio and send the reward
209             uint userVotesForWinner = userVotesDistribution[to][winner];
210             userVotesDistribution[to][winner] = 0;
211             uint reward = (challengePrize * userVotesForWinner) / votes[winner];
212             to.transfer(reward);
213 
214             // Fire the event
215             emit RewardWasPaid(to, reward);
216         }
217     }
218 
219     // Send a reward to challenge creator
220     function sendCreatorReward() public afterVotingPeriod {
221         if (creatorPrize > 0) {
222             uint creatorReward = creatorPrize;
223             creatorPrize = 0;
224             creator.transfer(creatorReward);
225 
226             // Fire the event
227             emit CreatorRewardWasPaid(creator, creatorReward);
228         }
229     }
230 
231     // Send a reward to cryptoVersusWallet
232     function sendCryptoVersusReward() public afterVotingPeriod {
233         if (cryptoVersusPrize > 0) {
234             uint cryptoVersusReward = cryptoVersusPrize;
235             cryptoVersusPrize = 0;
236             cryptoVersusWallet.transfer(cryptoVersusReward);
237 
238             // Fire the event
239             emit CryptoVersusRewardWasPaid(cryptoVersusWallet, cryptoVersusReward);
240         }
241     }
242 }
243 
244 contract VotingChallengeProxy {
245     VotingChallenge challenge;
246     uint candidate;
247 
248     constructor(address _mainAddress, uint _candidate) public {
249         challenge = VotingChallenge(_mainAddress);
250         candidate = _candidate;
251     }
252 
253     function() public payable {
254         challenge.voteForCandidate_.value(msg.value)(candidate, msg.sender);
255     }
256 }