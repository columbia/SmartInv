1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16 
17     /**
18      * @dev Throws if called by any account other than the owner.
19      */
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25 
26     /**
27      * @dev Allows the current owner to transfer control of the contract to a newOwner.
28      * @param newOwner The address to transfer ownership to.
29      */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 
39 library SafeMath {
40 
41     /**
42     * @dev Multiplies two numbers, throws on overflow.
43     */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         assert(c / a == b);
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers, truncating the quotient.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     /**
64     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     /**
72     * @dev Adds two numbers, throws on overflow.
73     */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78     }
79 }
80 
81 /// @title Contract to bet Ether for on a match of two teams
82 contract MatchBetting {
83     using SafeMath for uint256;
84 
85     //Represents a team, along with betting information
86     struct Team {
87         string name;
88         mapping(address => uint) bettingContribution;
89         mapping(address => uint) ledgerBettingContribution;
90         uint totalAmount;
91         uint totalParticipants;
92     }
93     //Represents two teams
94     Team[2] public teams;
95     // Flag to show if the match is completed
96     bool public matchCompleted = false;
97     // Flag to show if the contract will stop taking bets.
98     bool public stopMatchBetting = false;
99     // The minimum amount of ether to bet for the match
100     uint public minimumBetAmount;
101     // WinIndex represents the state of the match. 4 shows match not started.
102     // 4 - Match has not started
103     // 0 - team[0] has won
104     // 1 - team[1] has won
105     // 2 - match is draw
106     uint public winIndex = 4;
107     // A helper variable to track match easily on the backend web server
108     uint matchNumber;
109     // Owner of the contract
110     address public owner;
111     // The jackpot address, to which some of the proceeds goto from the match
112     address public jackpotAddress;
113 
114     address[] public betters;
115 
116     // Only the owner will be allowed to excute the function.
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121     //@notice Contructor that is used configure team names, the minimum bet amount, owner, jackpot address
122     // and match Number
123     function MatchBetting(string teamA, string teamB, uint _minimumBetAmount, address sender, address _jackpotAddress, uint _matchNumber) public {
124         Team memory newTeamA = Team({
125             totalAmount : 0,
126             name : teamA,
127             totalParticipants : 0
128             });
129 
130         Team memory newTeamB = Team({
131             totalAmount : 0,
132             name : teamB,
133             totalParticipants : 0
134             });
135 
136         teams[0] = newTeamA;
137         teams[1] = newTeamB;
138         minimumBetAmount = _minimumBetAmount;
139         owner = sender;
140         jackpotAddress = _jackpotAddress;
141         matchNumber = _matchNumber;
142     }
143 
144     //@notice Allows a user to place Bet on the match
145     function placeBet(uint index) public payable {
146         require(msg.value >= minimumBetAmount);
147         require(!stopMatchBetting);
148         require(!matchCompleted);
149 
150         if(teams[0].bettingContribution[msg.sender] == 0 && teams[1].bettingContribution[msg.sender] == 0) {
151             betters.push(msg.sender);
152         }
153 
154         if (teams[index].bettingContribution[msg.sender] == 0) {
155             teams[index].totalParticipants = teams[index].totalParticipants.add(1);
156         }
157         teams[index].bettingContribution[msg.sender] = teams[index].bettingContribution[msg.sender].add(msg.value);
158         teams[index].ledgerBettingContribution[msg.sender] = teams[index].ledgerBettingContribution[msg.sender].add(msg.value);
159         teams[index].totalAmount = teams[index].totalAmount.add(msg.value);
160     }
161 
162     //@notice Set the outcome of the match
163     function setMatchOutcome(uint winnerIndex, string teamName) public onlyOwner {
164         if (winnerIndex == 0 || winnerIndex == 1) {
165             //Match is not draw, double check on name and index so that no mistake is made
166             require(compareStrings(teams[winnerIndex].name, teamName));
167             uint loosingIndex = (winnerIndex == 0) ? 1 : 0;
168             // Send Share to jackpot only when Ether are placed on both the teams
169             if (teams[winnerIndex].totalAmount != 0 && teams[loosingIndex].totalAmount != 0) {
170                 uint jackpotShare = (teams[loosingIndex].totalAmount).div(5);
171                 jackpotAddress.transfer(jackpotShare);
172             }
173         }
174         winIndex = winnerIndex;
175         matchCompleted = true;
176     }
177 
178     //@notice Sets the flag stopMatchBetting to true
179     function setStopMatchBetting() public onlyOwner{
180         stopMatchBetting = true;
181     }
182 
183     //@notice Allows the user to get ether he placed on his team, if his team won or draw.
184     function getEther() public {
185         require(matchCompleted);
186 
187         if (winIndex == 2) {
188             uint betOnTeamA = teams[0].bettingContribution[msg.sender];
189             uint betOnTeamB = teams[1].bettingContribution[msg.sender];
190 
191             teams[0].bettingContribution[msg.sender] = 0;
192             teams[1].bettingContribution[msg.sender] = 0;
193 
194             uint totalBetContribution = betOnTeamA.add(betOnTeamB);
195             require(totalBetContribution != 0);
196 
197             msg.sender.transfer(totalBetContribution);
198         } else {
199             uint loosingIndex = (winIndex == 0) ? 1 : 0;
200             // If No Ether were placed on winning Team - Allow claim Ether placed on loosing side.
201 
202             uint betValue;
203             if (teams[winIndex].totalAmount == 0) {
204                 betValue = teams[loosingIndex].bettingContribution[msg.sender];
205                 require(betValue != 0);
206 
207                 teams[loosingIndex].bettingContribution[msg.sender] = 0;
208                 msg.sender.transfer(betValue);
209             } else {
210                 betValue = teams[winIndex].bettingContribution[msg.sender];
211                 require(betValue != 0);
212 
213                 teams[winIndex].bettingContribution[msg.sender] = 0;
214 
215                 uint winTotalAmount = teams[winIndex].totalAmount;
216                 uint loosingTotalAmount = teams[loosingIndex].totalAmount;
217 
218                 if (loosingTotalAmount == 0) {
219                     msg.sender.transfer(betValue);
220                 } else {
221                     //original Bet + (original bet * 80 % of bet on losing side)/bet on winning side
222                     uint userTotalShare = betValue;
223                     uint bettingShare = betValue.mul(80).div(100).mul(loosingTotalAmount).div(winTotalAmount);
224                     userTotalShare = userTotalShare.add(bettingShare);
225 
226                     msg.sender.transfer(userTotalShare);
227                 }
228             }
229         }
230     }
231 
232     function getBetters() public view returns (address[]) {
233         return betters;
234     }
235 
236     //@notice get various information about the match and its current state.
237     function getMatchInfo() public view returns (string, uint, uint, string, uint, uint, uint, bool, uint, uint, bool) {
238         return (teams[0].name, teams[0].totalAmount, teams[0].totalParticipants, teams[1].name,
239         teams[1].totalAmount, teams[1].totalParticipants, winIndex, matchCompleted, minimumBetAmount, matchNumber, stopMatchBetting);
240     }
241 
242     //@notice Returns users current amount of bet on the match
243     function userBetContribution(address userAddress) public view returns (uint, uint) {
244         return (teams[0].bettingContribution[userAddress], teams[1].bettingContribution[userAddress]);
245     }
246 
247     //@notice Returns how much a user has bet on the match.
248     function ledgerUserBetContribution(address userAddress) public view returns (uint, uint) {
249         return (teams[0].ledgerBettingContribution[userAddress], teams[1].ledgerBettingContribution[userAddress]);
250     }
251 
252     //@notice Private function the helps in comparing strings.
253     function compareStrings(string a, string b) private pure returns (bool){
254         return keccak256(a) == keccak256(b);
255     }
256 }
257 
258 contract MatchBettingFactory is Ownable {
259     // Array of all the matches deployed
260     address[] deployedMatches;
261     // The address to which some ether is to be transferred
262     address public jackpotAddress;
263 
264     //@notice Constructor thats sets up the jackpot address
265     function MatchBettingFactory(address _jackpotAddress) public{
266         jackpotAddress = _jackpotAddress;
267     }
268 
269     //@notice Creates a match with given team names, minimum bet amount and a match number
270     function createMatch(string teamA, string teamB, uint _minimumBetAmount, uint _matchNumber) public onlyOwner{
271         address matchBetting = new MatchBetting(teamA, teamB, _minimumBetAmount, msg.sender, jackpotAddress, _matchNumber);
272         deployedMatches.push(matchBetting);
273     }
274 
275     //@notice get a address of all deployed matches
276     function getDeployedMatches() public view returns (address[]) {
277         return deployedMatches;
278     }
279 }