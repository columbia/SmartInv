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
49 // Contract written by MaximeHg
50 // https://github.com/MaximeHg/sb52-contracts
51 // Special thanks to moodysalem and its ethersquares contracts for the inspiration!
52 // https://github.com/ethersquares/ethersquares-contracts
53 
54 contract BallotSB52 {
55   using SafeMath for uint;
56   uint public phiWon;
57   uint public neWon;
58   Superbowl52 bettingContract;
59   mapping (address => bool) voted;
60   mapping (address => uint) votes;
61   uint public constant votingPeriod = 7 days;
62   uint public votingStart;
63   uint public votingEnd;
64   uint public validResult;
65   bool public closed;
66   uint public totalVoters;
67   // XX.XXX%
68   uint public threshold;
69   uint public votingReward;
70   mapping (address => uint) stake;
71   uint public majorityReward;
72   bool public tie;
73   mapping (address => bool) claimed;
74 
75   function BallotSB52(uint th) public payable {
76     validResult = 0;
77     closed = false;
78     votingStart = now;
79     votingEnd = now + 7 days;
80     bettingContract = Superbowl52(msg.sender);
81     totalVoters = 0;
82     threshold = th;
83     tie = false;
84     votingReward = 0;
85   }
86 
87   // you can only vote once
88   function voteResult(uint team) public payable {
89     require(votingStart <= now && votingEnd >= now);
90     require(voted[msg.sender] == false);
91     require(msg.value == 50 finney);
92     require(!closed);
93     if(team == 1) {
94       phiWon += 1;
95     }
96     else if (team == 2) {
97       neWon += 1;
98     } else revert();
99     voted[msg.sender] = true;
100     votes[msg.sender] = team;
101     totalVoters += 1;
102     stake[msg.sender] = msg.value;
103   }
104 
105   function closeBallot() public returns (uint) {
106     require(!closed);
107     require(now > votingEnd);
108     if((phiWon.mul(100000).div(totalVoters) == neWon.mul(100000).div(totalVoters)) && (threshold == 50000)) {
109       validResult = 9;
110       closed = true;
111       tie = true;
112       return validResult;
113     } else if(phiWon.mul(100000).div(totalVoters) >= threshold) {
114       validResult = 1;
115       votingReward = bettingContract.getLosersOnePercent(2);
116       majorityReward = (neWon * 50 finney).add(votingReward).div(phiWon);
117     } else if (neWon.mul(100000).div(totalVoters) >= threshold) {
118       validResult = 2;
119       votingReward = bettingContract.getLosersOnePercent(3);
120       majorityReward = (phiWon * 50 finney).add(votingReward).div(neWon);
121     } else {
122       if (neWon.mul(100000).div(totalVoters) > 50000) majorityReward = (phiWon * 50 finney).div(neWon);
123       else if (phiWon.mul(100000).div(totalVoters) > 50000) majorityReward = (neWon * 50 finney).div(phiWon);
124       else {
125         tie = true;
126         majorityReward = 0;
127       }
128       validResult = 0;
129     }
130     closed = true;
131     return validResult;
132   }
133 
134   // anyone can claim reward for a voter
135   function getReward(address voter) public {
136     require(closed);
137     require(voted[voter]);
138     require(claimed[voter] == false);
139     if(tie) {
140       voter.transfer(stake[voter]);
141     }
142     // majority gets rewarded
143     if(votes[voter] == validResult) {
144       voter.transfer(stake[voter] + majorityReward);
145     } // minority loses all
146     claimed[voter] = true;
147   }
148 
149   function hasClaimed(address voter) public constant returns (bool) {
150     return claimed[voter];
151   }
152 
153   function () public payable {}
154 }
155 
156 // Contract written by MaximeHg
157 // https://github.com/MaximeHg/sb52-contracts
158 // Special thanks to moodysalem and its ethersquares contracts for the inspiration!
159 // https://github.com/ethersquares/ethersquares-contracts
160 
161 contract Superbowl52 {
162   using SafeMath for uint;
163   uint public constant GAME_START_TIME = 1517787000;
164   bool public resultConfirmed = false;
165   address public owner;
166 
167   mapping(address => betting) public bets;
168   uint public totalBets;
169   uint public philadelphiaBets;
170   uint public newEnglandBets;
171   uint public result;
172   uint public betters;
173   bool public votingOpen;
174   bool public withdrawalOpen;
175   uint public threshold;
176   uint public winningPot;
177   mapping(address => uint) public wins;
178 
179   BallotSB52 public ballot;
180 
181   struct betting {
182     uint philadelphiaBets;
183     uint newEnglandBets;
184     bool claimed;
185   }
186 
187   function Superbowl52() public {
188     require(now<GAME_START_TIME);
189     owner = msg.sender;
190     result = 0;
191     votingOpen = false;
192     withdrawalOpen = false;
193     // 90%
194     threshold = 90000;
195     winningPot = 0;
196   }
197 
198   // team 1 is Philadelphia
199   // team 2 is New England
200   // a bet is final and you cannot change it
201   function bet(uint team) public payable {
202     require(team == 1 || team == 2);
203     require(now <= GAME_START_TIME);
204     require(msg.value > 0);
205     if(!hasBet(msg.sender)) betters += 1;
206     if(team == 1) {
207       bets[msg.sender].philadelphiaBets += msg.value;
208       philadelphiaBets += msg.value;
209     } else if (team == 2) {
210       bets[msg.sender].newEnglandBets += msg.value;
211       newEnglandBets += msg.value;
212     }
213     totalBets += msg.value;
214   }
215 
216   function () public payable {
217     revert();
218   }
219 
220   function getPhiladelphiaBets(address better) public constant returns (uint) {
221     return bets[better].philadelphiaBets;
222   }
223 
224   function getNewEnglandBets(address better) public constant returns (uint) {
225     return bets[better].newEnglandBets;
226   }
227 
228   function hasClaimed(address better) public constant returns (bool) {
229     return bets[better].claimed;
230   }
231 
232   function startVoting() public {
233     require(votingOpen == false);
234     require(withdrawalOpen == false);
235     require(now >= GAME_START_TIME + 8 hours);
236     votingOpen = true;
237     ballot = new BallotSB52(threshold);
238   }
239 
240   function hasBet(address better) public constant returns (bool) {
241     return (bets[better].philadelphiaBets + bets[better].newEnglandBets) > 0;
242   }
243 
244   function endVoting() public {
245     require(votingOpen);
246     result = ballot.closeBallot();
247     // ballot ends with success
248     if (result == 1 || result == 2) {
249       withdrawalOpen = true;
250       votingOpen = false;
251     } else if (result == 9) {
252       votingOpen = false;
253       withdrawalOpen = false;
254     } else {
255       threshold = threshold - 5000;
256       ballot = new BallotSB52(threshold);
257     }
258     if(result == 1) winningPot = totalBets.sub(newEnglandBets.div(100));
259     if(result == 2) winningPot = totalBets.sub(philadelphiaBets.div(100));
260   }
261 
262   function getLosersOnePercent(uint loser) public returns (uint) {
263     require(votingOpen);
264     require(msg.sender == address(ballot));
265     if(loser==1) {
266       ballot.transfer(philadelphiaBets.div(100));
267       return philadelphiaBets.div(100);
268     }
269     else if (loser==2) {
270       ballot.transfer(newEnglandBets.div(100));
271       return newEnglandBets.div(100);
272     }
273     else {
274       return 0;
275     }
276   }
277 
278   // triggered only if tie in the final ballot
279   function breakTie(uint team) {
280     require(result == 9);
281     require(msg.sender == owner);
282     result = team;
283     withdrawalOpen = true;
284   }
285 
286   function getWinnings(uint donation) public {
287     require(donation<=100);
288     require(withdrawalOpen);
289     require(bets[msg.sender].claimed == false);
290     uint winnings = 0;
291     if (result == 1) winnings = (getPhiladelphiaBets(msg.sender).mul(winningPot)).div(philadelphiaBets);
292     else if (result == 2) winnings = (getNewEnglandBets(msg.sender).mul(winningPot)).div(newEnglandBets);
293     else revert();
294     wins[msg.sender] = winnings;
295     uint donated = winnings.mul(donation).div(100);
296     bets[msg.sender].claimed = true;
297     owner.transfer(donated);
298     msg.sender.transfer(winnings-donated);
299   }
300 
301 }