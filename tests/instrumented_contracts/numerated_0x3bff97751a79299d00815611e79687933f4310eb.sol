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
131     // Transfer votes to anybody
132     function transferVotes (address to, uint candidate) public inVotingPeriod {
133         require(userVotesDistribution[msg.sender][candidate] > 0);
134         uint votesToTransfer = userVotesDistribution[msg.sender][candidate];
135         userVotesDistribution[msg.sender][candidate] = 0;
136         userVotesDistribution[to][candidate] += votesToTransfer;
137 
138         // Fire the event
139         emit TransferVotes(msg.sender, to, candidate, votesToTransfer);
140     }
141 
142     // Check the deadline
143     // If success then define a winner and close the challenge
144     function checkEndOfChallenge() public inVotingPeriod returns (bool) {
145         if (challengeStarted + challengeDuration > now)
146             return false;
147         uint theWinner;
148         uint winnerVotes;
149         uint actualBalance = address(this).balance - lastPayment;
150 
151         for (uint i = 1; i <= candidatesNumber; i++) {
152             if (votes[i] > winnerVotes) {
153                 winnerVotes = votes[i];
154                 theWinner = i;
155             }
156         }
157         winner = theWinner;
158         creatorPrize = (actualBalance * creatorFee) / 1000;
159         cryptoVersusPrize = (actualBalance * cryptoVersusFee) / 1000;
160         challengePrize = actualBalance - creatorPrize - cryptoVersusPrize;
161         isVotingPeriod = false;
162 
163         // Fire the event
164         emit EndOfChallenge(winner, winnerVotes, challengePrize);
165         return true;
166     }
167 
168     // Send a reward if user voted for a winner
169     function getReward() public afterVotingPeriod {
170         require(userVotesDistribution[msg.sender][winner] > 0);
171 
172         // Compute a vote ratio and send the reward
173         uint userVotesForWinner = userVotesDistribution[msg.sender][winner];
174         userVotesDistribution[msg.sender][winner] = 0;
175         uint reward = (challengePrize * userVotesForWinner) / votes[winner];
176         msg.sender.transfer(reward);
177 
178         // Fire the event
179         emit RewardWasPaid(msg.sender, reward);
180     }
181 
182     // Send a reward if user voted for a winner
183     function sendReward(address to) public afterVotingPeriod {
184         require(userVotesDistribution[to][winner] > 0);
185 
186         // Compute a vote ratio and send the reward
187         uint userVotesForWinner = userVotesDistribution[to][winner];
188         userVotesDistribution[to][winner] = 0;
189         uint reward = (challengePrize * userVotesForWinner) / votes[winner];
190         to.transfer(reward);
191 
192         // Fire the event
193         emit RewardWasPaid(to, reward);
194     }
195 
196     // Send a reward to challenge creator
197     function sendCreatorReward() public afterVotingPeriod {
198         require(creatorPrize > 0);
199         uint creatorReward = creatorPrize;
200         creatorPrize = 0;
201         creator.transfer(creatorReward);
202 
203         // Fire the event
204         emit CreatorRewardWasPaid(creator, creatorReward);
205     }
206 
207     // Send a reward to cryptoVersusWallet
208     function sendCryptoVersusReward() public afterVotingPeriod {
209         require(cryptoVersusPrize > 0);
210         uint cryptoVersusReward = cryptoVersusPrize;
211         cryptoVersusPrize = 0;
212         cryptoVersusWallet.transfer(cryptoVersusReward);
213 
214         // Fire the event
215         emit CryptoVersusRewardWasPaid(cryptoVersusWallet, cryptoVersusReward);
216     }
217 }