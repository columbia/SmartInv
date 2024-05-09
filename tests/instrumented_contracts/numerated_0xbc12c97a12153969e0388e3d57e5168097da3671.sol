1 pragma solidity ^0.5.1;
2 
3 contract VotingChallenge {
4     struct Team {
5         uint fullVotes;
6         uint weightedVotes;
7     }
8 
9     struct Voter {
10         uint[2] fullVotes;
11         uint[2] weightedVotes;
12         address payable[2] referrers;
13     }
14 
15     VotingChallengeForwarder forwarder;
16 
17     uint public challengeDuration;
18     uint public challengeStarted;
19     address payable public creator;
20     uint16 public creatorFee = 17;       // measured in in tenths of a percent
21     address payable public cryptoVersusWallet = 0xa0bedE75cfeEF0266f8A31b47074F5f9fBE1df80;
22     uint16 public cryptoVersusFee = 53;  // measured in in tenths of a percent
23     uint public cryptoVersusPrize;
24     uint public challengePrize;
25     uint public winner;
26     bool public isVotingPeriod = false;
27     bool public beforeVoting = true;
28     Team[2] public teams;
29     mapping( address => Voter ) private voters;
30 
31     modifier inVotingPeriod() {
32         require(isVotingPeriod);
33         _;
34     }
35 
36     modifier afterVotingPeriod() {
37         require(!isVotingPeriod);
38         _;
39     }
40 
41     modifier onlyCreator() {
42         require(msg.sender == creator);
43         _;
44     }
45 
46     event ChallengeBegins(address _creator, uint _challengeDuration);
47     event NewVotesFor(address _participant, uint _candidate, uint _votes, uint _coefficient);
48     event TransferVotes(address _from, address _to, uint _candidateIndex, uint _votes);
49     event EndOfChallenge(uint _winner, uint _winnerVotes, uint _challengePrize);
50     event RewardWasPaid(address _participant, uint _amount);
51     event ReferrerRewardWasPaid(address _via, address _to, uint amount);
52     event CreatorRewardWasPaid(address _creator, uint _amount);
53     event CryptoVersusRewardWasPaid(address _cryptoVersusWallet, uint _amount);
54 
55     constructor(uint _challengeDuration, address _forwarder) public {
56         forwarder = VotingChallengeForwarder(_forwarder);
57         challengeDuration = _challengeDuration;
58         creator = msg.sender;
59     }
60 
61     function getAllVotes() public view returns (uint[2] memory) {
62         return [ teams[0].fullVotes, teams[1].fullVotes ];
63     }
64 
65     function currentCoefficient() public view returns (uint) {  // in 1/1000000
66         return 1000000 - 900000 * (now - challengeStarted) / challengeDuration;
67     }
68 
69     function timeOver() public view returns (bool) {
70         return challengeStarted + challengeDuration <= now;
71     }
72 
73     function startChallenge() public onlyCreator {
74         require(beforeVoting);
75         isVotingPeriod = true;
76         beforeVoting = false;
77         challengeStarted = now;
78 
79         emit ChallengeBegins(creator, challengeDuration);
80     }
81 
82     function voteForCandidate(uint candidate) public payable inVotingPeriod {
83         require(0 <= candidate && candidate < 2);
84         require(msg.value > 0);
85         require(!timeOver());
86 
87         uint coefficient = currentCoefficient();
88         uint weightedVotes = msg.value * coefficient / 1000000;
89         teams[candidate].fullVotes += msg.value;
90         teams[candidate].weightedVotes += weightedVotes;
91         voters[msg.sender].fullVotes[candidate] += msg.value;
92         voters[msg.sender].weightedVotes[candidate] += weightedVotes;
93 
94         emit NewVotesFor(msg.sender, candidate, msg.value, coefficient);
95     }
96 
97     function voteForCandidate(uint candidate, address payable referrer1) public payable inVotingPeriod {
98         voters[msg.sender].referrers[0] = referrer1;
99         voteForCandidate(candidate);
100     }
101 
102     function voteForCandidate(uint candidate, address payable referrer1, address payable referrer2) public payable inVotingPeriod {
103         voters[msg.sender].referrers[1] = referrer2;
104         voteForCandidate(candidate, referrer1);
105     }
106 
107     function checkEndOfChallenge() public inVotingPeriod returns (bool) {
108         if (!timeOver())
109             return false;
110 
111         if (teams[0].fullVotes > teams[1].fullVotes)
112             winner = 0;
113         else
114             winner = 1;
115 
116         uint loser = 1 - winner;
117         creator.transfer((teams[loser].fullVotes * creatorFee) / 1000);
118         cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000;
119         challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000;
120         isVotingPeriod = false;
121 
122         emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize);
123         return true;
124     }
125 
126     function sendReward(address payable to) public afterVotingPeriod {
127         uint winnerVotes = voters[to].weightedVotes[winner];
128         uint loserVotes = voters[to].fullVotes[1-winner];
129         address payable referrer1 = voters[to].referrers[0];
130         address payable referrer2 = voters[to].referrers[1];
131         uint sum;
132 
133         if (winnerVotes > 0) {
134             uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes;
135             to.transfer(reward + voters[to].fullVotes[winner]);
136             if (referrer1 != address(0)) {
137                 sum = reward / 100 * 2;  // 2%
138                 forwarder.forward.value(sum)(referrer1, to);
139                 cryptoVersusPrize -= sum;
140                 emit ReferrerRewardWasPaid(to, referrer1, sum);
141             }
142             if (referrer2 != address(0)) {
143                 sum = reward / 1000 * 2;  // 0.2%
144                 forwarder.forward.value(sum)(referrer2, to);
145                 cryptoVersusPrize -= sum;
146                 emit ReferrerRewardWasPaid(to, referrer2, sum);
147             }
148             voters[to].fullVotes[winner] = 0;
149             voters[to].weightedVotes[winner] = 0;
150             emit RewardWasPaid(to, reward);
151         }
152         if (loserVotes > 0) {
153             if (referrer1 != address(0)) {
154                 sum = loserVotes / 100 * 1;  // 1%
155                 forwarder.forward.value(sum)(referrer1, to);
156                 cryptoVersusPrize -= sum;
157                 emit ReferrerRewardWasPaid(to, referrer1, sum);
158             }
159             if (referrer2 != address(0)) {
160                 sum = loserVotes / 1000 * 1;  // 0.1%
161                 forwarder.forward.value(sum)(referrer2, to);
162                 cryptoVersusPrize -= sum;
163                 emit ReferrerRewardWasPaid(to, referrer2, sum);
164             }
165         }
166     }
167 
168     function sendCryptoVersusReward() public afterVotingPeriod {
169         if (cryptoVersusPrize > 0) {
170             uint cryptoVersusReward = cryptoVersusPrize;
171             cryptoVersusPrize = 0;
172             cryptoVersusWallet.transfer(cryptoVersusReward);
173 
174             emit CryptoVersusRewardWasPaid(cryptoVersusWallet, cryptoVersusReward);
175         }
176     }
177 }
178 
179 contract VotingChallengeForwarder {
180     mapping ( address => address[] ) public sendersHash;
181     mapping ( address => uint[] ) public sumsHash;
182 
183     function forward(address payable to, address sender) public payable {
184         to.transfer(msg.value);
185         sendersHash[to].push(sender);
186         sumsHash[to].push(msg.value);
187     }
188 
189     function getSendersHash(address user) public view returns (address[] memory) {
190         return sendersHash[user];
191     }
192 
193     function getSumsHash(address user) public view returns (uint[] memory) {
194         return sumsHash[user];
195     }
196 }