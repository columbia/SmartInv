1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract BallotSB52 {
51   using SafeMath for uint;
52   uint public phiWon;
53   uint public neWon;
54   Superbowl52 bettingContract;
55   mapping (address => bool) voted;
56   mapping (address => uint) votes;
57   uint public constant votingPeriod = 7 days;
58   uint public votingStart;
59   uint public votingEnd;
60   uint public validResult;
61   bool public closed;
62   uint public totalVoters;
63   // XX.XXX%
64   uint public threshold;
65   uint public votingReward;
66   mapping (address => uint) stake;
67   uint public majorityReward;
68   bool public tie;
69   mapping (address => bool) claimed;
70 
71   function BallotSB52(uint th) public payable {
72     validResult = 0;
73     closed = false;
74     votingStart = now;
75     votingEnd = now + 7 days;
76     bettingContract = Superbowl52(msg.sender);
77     totalVoters = 0;
78     threshold = th;
79     tie = false;
80     votingReward = 0;
81   }
82 
83   // you can only vote once
84   function voteResult(uint team) public payable {
85     require(votingStart <= now && votingEnd >= now);
86     require(voted[msg.sender] == false);
87     require(msg.value == 50 finney);
88     require(!closed);
89     if(team == 1) {
90       phiWon += 1;
91     }
92     else if (team == 2) {
93       neWon += 1;
94     } else revert();
95     voted[msg.sender] = true;
96     votes[msg.sender] = team;
97     totalVoters += 1;
98     stake[msg.sender] = msg.value;
99   }
100 
101   function closeBallot() public returns (uint) {
102     require(!closed);
103     require(now > votingEnd);
104     if(phiWon.mul(100000).div(totalVoters) >= threshold) {
105       validResult = 1;
106       votingReward = bettingContract.getLosersOnePercent(2);
107       majorityReward = (neWon * 50 finney).add(votingReward).div(phiWon);
108     } else if (neWon.mul(100000).div(totalVoters) >= threshold) {
109       validResult = 2;
110       votingReward = bettingContract.getLosersOnePercent(3);
111       majorityReward = (phiWon * 50 finney).add(votingReward).div(neWon);
112     } else {
113       if (neWon.mul(100000).div(totalVoters) > 50000) majorityReward = (phiWon * 50 finney).div(neWon);
114       else if (phiWon.mul(100000).div(totalVoters) > 50000) majorityReward = (neWon * 50 finney).div(phiWon);
115       else {
116         tie = true;
117         majorityReward = 0;
118       }
119       validResult = 0;
120     }
121     closed = true;
122     return validResult;
123   }
124 
125   // anyone can claim reward for a voter
126   function getReward(address voter) public {
127     require(closed);
128     require(voted[voter]);
129     require(claimed[voter] == false);
130     if(tie) {
131       voter.transfer(stake[voter]);
132     }
133     // majority gets rewarded
134     if(votes[voter] == validResult) {
135       voter.transfer(stake[voter] + majorityReward);
136     } // minority loses all
137     claimed[voter] = true;
138   }
139 
140   function hasClaimed(address voter) public constant returns (bool) {
141     return claimed[voter];
142   }
143 
144   function () public payable {}
145 }
146 
147 contract Superbowl52 {
148   using SafeMath for uint;
149   uint public constant GAME_START_TIME = 1517787000;
150   bool public resultConfirmed = false;
151   address public owner;
152 
153   mapping(address => betting) public bets;
154   uint public totalBets;
155   uint public philadelphiaBets;
156   uint public newEnglandBets;
157   uint public result;
158   uint public betters;
159   bool public votingOpen;
160   bool public withdrawalOpen;
161   uint public threshold;
162   uint public winningPot;
163   mapping(address => uint) public wins;
164 
165   BallotSB52 public ballot;
166 
167   struct betting {
168     uint philadelphiaBets;
169     uint newEnglandBets;
170     bool claimed;
171   }
172 
173   function Superbowl52() public {
174     require(now<GAME_START_TIME);
175     owner = msg.sender;
176     result = 0;
177     votingOpen = false;
178     withdrawalOpen = false;
179     // 90%
180     threshold = 90000;
181     winningPot = 0;
182   }
183 
184   // team 1 is Philadelphia
185   // team 2 is New England
186   // a bet is final and you cannot change it
187   function bet(uint team) public payable {
188     require(team == 1 || team == 2);
189     require(now <= GAME_START_TIME);
190     require(msg.value > 0);
191     if(!hasBet(msg.sender)) betters += 1;
192     if(team == 1) {
193       bets[msg.sender].philadelphiaBets += msg.value;
194       philadelphiaBets += msg.value;
195     } else if (team == 2) {
196       bets[msg.sender].newEnglandBets += msg.value;
197       newEnglandBets += msg.value;
198     }
199     totalBets += msg.value;
200   }
201 
202   function () public payable {
203     revert();
204   }
205 
206   function getPhiladelphiaBets(address better) public constant returns (uint) {
207     return bets[better].philadelphiaBets;
208   }
209 
210   function getNewEnglandBets(address better) public constant returns (uint) {
211     return bets[better].newEnglandBets;
212   }
213 
214   function hasClaimed(address better) public constant returns (bool) {
215     return bets[better].claimed;
216   }
217 
218   function startVoting() public {
219     require(msg.sender == owner);
220     require(votingOpen == false);
221     require(withdrawalOpen == false);
222     require(now >= GAME_START_TIME + 8 hours);
223     votingOpen = true;
224     ballot = new BallotSB52(threshold);
225   }
226 
227   function hasBet(address better) public constant returns (bool) {
228     return (bets[better].philadelphiaBets + bets[better].newEnglandBets) > 0;
229   }
230 
231   function endVoting() public {
232     require(votingOpen);
233     result = ballot.closeBallot();
234     // ballot ends with success
235     if (result == 1 || result == 2) {
236         withdrawalOpen = true;
237         votingOpen = false;
238     } else {
239       threshold = threshold - 5000;
240       ballot = new BallotSB52(threshold);
241     }
242     if(result == 1) winningPot = totalBets.sub(newEnglandBets.div(100));
243     if(result == 2) winningPot = totalBets.sub(philadelphiaBets.div(100));
244   }
245 
246   function getLosersOnePercent(uint loser) public returns (uint) {
247     require(votingOpen);
248     require(msg.sender == address(ballot));
249     if(loser==1) {
250       ballot.transfer(philadelphiaBets.div(100));
251       return philadelphiaBets.div(100);
252     }
253     else if (loser==2) {
254       ballot.transfer(newEnglandBets.div(100));
255       return newEnglandBets.div(100);
256     }
257     else {
258       return 0;
259     }
260   }
261 
262   function getWinnings(address winner, uint donation) public {
263     require(donation<=100);
264     require(withdrawalOpen);
265     require(bets[winner].claimed == false);
266     uint winnings = 0;
267     if (result == 1) winnings = (getPhiladelphiaBets(winner).mul(winningPot)).div(philadelphiaBets);
268     else if (result == 2) winnings = (getNewEnglandBets(winner).mul(winningPot)).div(newEnglandBets);
269     else revert();
270     wins[winner] = winnings;
271     uint donated = winnings.mul(donation).div(100);
272     bets[winner].claimed = true;
273     winner.transfer(winnings-donated);
274   }
275 
276 }