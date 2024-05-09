1 pragma solidity ^0.4.15;
2 
3 contract DecenterHackathon {
4 
5     struct Team {
6         string name;
7         string memberNames;
8         uint score;
9         uint reward;
10         bool rewardEligible;
11         bool submittedByAdmin;
12         bool disqualified;
13         mapping(address => bool) votedForByJuryMember;
14     }
15 
16     struct JuryMember {
17         string name;
18         bool hasVoted;
19     }
20 
21     struct Sponsor {
22         string name;
23         string siteUrl;
24         string logoUrl;
25         address ethAddress;
26         uint contribution;
27     }
28 
29     enum Period { Registration, Competition, Voting, Verification, End }
30 
31     uint public totalContribution;
32     Period public currentPeriod;
33 
34     mapping(address => Team) teams;
35     mapping(address => JuryMember) juryMembers;
36 
37     address administrator;
38     address[] teamAddresses;
39     address[] juryMemberAddresses;
40     Sponsor[] sponsors;
41 
42     event PeriodChanged(Period newPeriod);
43     event TeamRegistered(string teamName, address teamAddress, string memberNames, bool rewardEligible);
44     event JuryMemberAdded(string juryMemberName, address juryMemberAddress);
45     event SponsorshipReceived(string sponsorName, string sponsorSite, string sponsorLogoUrl, uint amount);
46     event VoteReceived(string juryMemberName, address indexed teamAddress, uint points);
47     event PrizePaid(string teamName, uint amount);
48     event TeamDisqualified(address teamAddress);
49 
50     modifier onlyOwner {
51         require(msg.sender == administrator);
52         _;
53     }
54 
55     modifier onlyJury {
56         require(bytes(juryMembers[msg.sender].name).length > 0);
57         _;
58     }
59 
60    function DecenterHackathon() {
61         administrator = msg.sender;
62         currentPeriod = Period.Registration;
63     }
64 
65     // Administrator is able to switch between periods at any time
66     function switchToNextPeriod() onlyOwner {
67         if(currentPeriod == Period.Verification || currentPeriod == Period.End) {
68             return;
69         }
70 
71         currentPeriod = Period(uint(currentPeriod) + 1);
72 
73         PeriodChanged(currentPeriod);
74     }
75 
76     // Administrator can add new teams during registration period, with an option to make a team non-eligible for the prize
77     function registerTeam(string _name, address _teamAddress, string _memberNames, bool _rewardEligible) onlyOwner {
78         require(currentPeriod == Period.Registration);
79         require(bytes(teams[_teamAddress].name).length == 0);
80 
81         teams[_teamAddress] = Team({
82             name: _name,
83             memberNames: _memberNames,
84             score: 0,
85             reward: 0,
86             rewardEligible: _rewardEligible,
87             submittedByAdmin: false,
88             disqualified: false
89         });
90 
91         teamAddresses.push(_teamAddress);
92         TeamRegistered(_name, _teamAddress, _memberNames, _rewardEligible);
93     }
94 
95     // Administrator can add new jury members during registration period
96     function registerJuryMember(string _name, address _ethAddress) onlyOwner {
97         require(currentPeriod == Period.Registration);
98 
99         juryMemberAddresses.push(_ethAddress);
100         juryMembers[_ethAddress] = JuryMember({
101             name: _name,
102             hasVoted: false
103         });
104 
105         JuryMemberAdded(_name, _ethAddress);
106     }
107 
108     // Anyone can contribute to the prize pool (i.e. either sponsor himself or administrator on behalf of the sponsor) during registration period
109     function contributeToPrizePool(string _name, string _siteUrl, string _logoUrl) payable {
110         require(currentPeriod != Period.End);
111         require(msg.value >= 0.1 ether);
112 
113         sponsors.push(Sponsor({
114             name: _name,
115             siteUrl: _siteUrl,
116             logoUrl: _logoUrl,
117             ethAddress: msg.sender,
118             contribution: msg.value
119         }));
120 
121         totalContribution += msg.value;
122         SponsorshipReceived(_name, _siteUrl, _logoUrl, msg.value);
123     }
124 
125     // Jury members can vote during voting period
126     // The _votes parameter should be an array of team addresses, sorted by score from highest to lowest based on jury member's preferences
127     function vote(address[] _votes) onlyJury {
128         require(currentPeriod == Period.Voting);
129         require(_votes.length == teamAddresses.length);
130         require(juryMembers[msg.sender].hasVoted == false);
131 
132         uint _points = _votes.length;
133 
134         for(uint i = 0; i < _votes.length; i++) {
135             address teamAddress = _votes[i];
136 
137             // All submitted teams must be registered
138             require(bytes(teams[teamAddress].name).length > 0);
139 
140             // Judge should not be able to vote for the same team more than once
141             require(teams[teamAddress].votedForByJuryMember[msg.sender] == false);
142 
143             teams[teamAddress].score += _points;
144             teams[teamAddress].votedForByJuryMember[msg.sender] = true;
145 
146             VoteReceived(juryMembers[msg.sender].name, teamAddress, _points);
147             _points--;
148         }
149 
150         // This will prevent jury members from voting more than once
151         juryMembers[msg.sender].hasVoted = true;
152     }
153 
154     // Administrator can initiate prize payout during final period
155     // The _sortedTeams parameter should be an array of correctly sorted teams by score, from highest to lowest
156     function payoutPrizes(address[] _sortedTeams) onlyOwner {
157         require(currentPeriod == Period.Verification);
158         require(_sortedTeams.length == teamAddresses.length);
159 
160         for(uint i = 0; i < _sortedTeams.length; i++) {
161             // All submitted teams must be registered
162             require(bytes(teams[_sortedTeams[i]].name).length > 0);
163 
164             // Teams must be sorted correctly
165             require(i == _sortedTeams.length - 1 || teams[_sortedTeams[i + 1]].score <= teams[_sortedTeams[i]].score);
166 
167             teams[_sortedTeams[i]].submittedByAdmin = true;
168         }
169 
170         // Prizes are paid based on logarithmic scale, where first teams receives 1/2 of the prize pool, second 1/4 and so on
171         uint prizePoolDivider = 2;
172 
173         for(i = 0; i < _sortedTeams.length; i++) {
174             // Make sure all teams are included in _sortedTeams array
175             // (i.e. the array should contain unique elements)
176             require(teams[_sortedTeams[i]].submittedByAdmin);
177 
178             uint _prizeAmount = totalContribution / prizePoolDivider;
179 
180             if(teams[_sortedTeams[i]].rewardEligible && !teams[_sortedTeams[i]].disqualified) {
181                 _sortedTeams[i].transfer(_prizeAmount);
182                 teams[_sortedTeams[i]].reward = _prizeAmount;
183                 prizePoolDivider *= 2;
184                 PrizePaid(teams[_sortedTeams[i]].name, _prizeAmount);
185             }
186         }
187 
188         // Some small amount of ETH might remain in the contract after payout, becuase rewards are determened logarithmically
189         // This amount is returned to contract owner to cover deployment and transaction costs
190         // In case this amount turns out to be significantly larger than these costs, the administrator will distribute it to all teams equally
191         administrator.transfer(this.balance);
192 
193         currentPeriod = Period.End;
194         PeriodChanged(currentPeriod);
195     }
196 
197     // Administrator can disqualify team
198     function disqualifyTeam(address _teamAddress) onlyOwner {
199         require(bytes(teams[_teamAddress].name).length > 0);
200 
201         teams[_teamAddress].disqualified = true;
202         TeamDisqualified(_teamAddress);
203     }
204 
205     // In case something goes wrong and contract needs to be redeployed, this is a way to return all contributions to the sponsors
206     function returnContributionsToTheSponsors() onlyOwner {
207         for(uint i = i; i < sponsors.length; i++) {
208             sponsors[i].ethAddress.transfer(sponsors[i].contribution);
209         }
210     }
211 
212     // Public function that returns user type for the given address
213     function getUserType(address _address) constant returns (string) {
214         if(_address == administrator) {
215             return "administrator";
216         } else if(bytes(juryMembers[_address].name).length > 0) {
217             return "jury";
218         } else {
219             return "other";
220         }
221     }
222 
223     // Check if jury member voted
224     function checkJuryVoted(address _juryAddress) constant returns (bool){
225         require(bytes(juryMembers[_juryAddress].name).length != 0);
226 
227         return juryMembers[_juryAddress].hasVoted;
228     }
229 
230     // Returns total prize pool size
231     function getPrizePoolSize() constant returns (uint) {
232         return totalContribution;
233     }
234 
235     function restartPeriod() onlyOwner {
236         currentPeriod = Period.Registration;
237     }
238 }