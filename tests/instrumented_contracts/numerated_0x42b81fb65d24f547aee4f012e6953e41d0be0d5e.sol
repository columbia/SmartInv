1 pragma solidity 0.4.18;
2 
3 // File: contracts/KnowsConstants.sol
4 
5 contract KnowsConstants {
6     // 2/4/18 @ 6:30 PM EST, the deadline for bets
7     uint public constant GAME_START_TIME = 1517787000;
8 }
9 
10 // File: contracts/KnowsSquares.sol
11 
12 // knows what a valid box is
13 contract KnowsSquares {
14     modifier isValidSquare(uint home, uint away) {
15         require(home >= 0 && home < 10);
16         require(away >= 0 && away < 10);
17         _;
18     }
19 }
20 
21 // File: contracts/interfaces/IKnowsTime.sol
22 
23 interface IKnowsTime {
24     function currentTime() public view returns (uint);
25 }
26 
27 // File: contracts/KnowsTime.sol
28 
29 // knows what time it is
30 contract KnowsTime is IKnowsTime {
31     function currentTime() public view returns (uint) {
32         return now;
33     }
34 }
35 
36 // File: contracts/interfaces/IScoreOracle.sol
37 
38 interface IScoreOracle {
39     function getSquareWins(uint home, uint away) public view returns (uint numSquareWins, uint totalWins);
40     function isFinalized() public view returns (bool);
41 }
42 
43 // File: zeppelin-solidity/contracts/math/SafeMath.sol
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86   address public owner;
87 
88 
89   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   function Ownable() public {
97     owner = msg.sender;
98   }
99 
100 
101   /**
102    * @dev Throws if called by any account other than the owner.
103    */
104   modifier onlyOwner() {
105     require(msg.sender == owner);
106     _;
107   }
108 
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address newOwner) public onlyOwner {
115     require(newOwner != address(0));
116     OwnershipTransferred(owner, newOwner);
117     owner = newOwner;
118   }
119 
120 }
121 
122 // File: contracts/OwnedScoreOracle.sol
123 
124 contract OwnedScoreOracle is KnowsConstants, KnowsSquares, KnowsTime, Ownable, IScoreOracle {
125     using SafeMath for uint;
126 
127     // score can be reported 1 day after the game
128     uint public constant SCORE_REPORT_START_TIME = GAME_START_TIME + 1 days;
129 
130     // the number of quarters is the total number of wins
131     uint public constant TOTAL_WINS = 4;
132 
133     // number of wins that have been reported
134     uint public winsReported = 0;
135 
136     // the grid of how much each box won
137     uint[10][10] public squareWins;
138 
139     // whether the score is finalized
140     bool public finalized;
141 
142     event LogSquareWinsUpdated(uint home, uint away, uint wins);
143 
144     function setSquareWins(uint home, uint away, uint wins) public onlyOwner isValidSquare(home, away) {
145         require(currentTime() >= SCORE_REPORT_START_TIME);
146         require(wins <= TOTAL_WINS);
147         require(!finalized);
148 
149         uint currentSquareWins = squareWins[home][away];
150 
151         // account the number of quarters reported
152         if (currentSquareWins > wins) {
153             winsReported = winsReported.sub(currentSquareWins.sub(wins));
154         } else if (currentSquareWins < wins) {
155             winsReported = winsReported.add(wins.sub(currentSquareWins));
156         }
157 
158         // mark the number of wins in that square
159         squareWins[home][away] = wins;
160 
161         LogSquareWinsUpdated(home, away, wins);
162     }
163 
164     event LogFinalized(uint time);
165 
166     // finalize the score after it's been reported
167     function finalize() public onlyOwner {
168         require(winsReported == TOTAL_WINS);
169         require(!finalized);
170 
171         finalized = true;
172 
173         LogFinalized(currentTime());
174     }
175 
176     function getSquareWins(uint home, uint away) public view returns (uint numSquareWins, uint totalWins) {
177         return (squareWins[home][away], TOTAL_WINS);
178     }
179 
180     function isFinalized() public view returns (bool) {
181         return finalized;
182     }
183 }
184 
185 // File: contracts/interfaces/IKnowsVoterStakes.sol
186 
187 interface IKnowsVoterStakes {
188     function getVoterStakes(address voter, uint asOfBlock) public view returns (uint);
189 }
190 
191 // File: contracts/AcceptedScoreOracle.sol
192 
193 contract AcceptedScoreOracle is OwnedScoreOracle {
194     using SafeMath for uint;
195 
196     // how long voters are given to affirm the score
197     uint public constant VOTING_PERIOD_DURATION = 1 weeks;
198 
199     // when the voting period started
200     uint public votingPeriodStartTime;
201     // the block number when the voting period started
202     uint public votingPeriodBlockNumber;
203 
204     // whether the voters have accepted the score as true
205     bool public accepted;
206 
207     uint public affirmations;
208     uint public totalVotes;
209 
210     struct Vote {
211         bool affirmed;
212         bool counted;
213     }
214 
215     // for the voting period blcok number, these are the votes counted from each address
216     mapping(uint => mapping(address => Vote)) votes;
217 
218     IKnowsVoterStakes public voterStakes;
219 
220     // only once, the voter stakes can be set by the owner, to allow us to deploy a circular dependency
221     function setVoterStakesContract(IKnowsVoterStakes _voterStakes) public onlyOwner {
222         require(address(voterStakes) == address(0));
223         voterStakes = _voterStakes;
224     }
225 
226     // start the acceptance period
227     function finalize() public onlyOwner {
228         super.finalize();
229 
230         // start the voting period immediately
231         affirmations = 0;
232         totalVotes = 0;
233         votingPeriodStartTime = currentTime();
234         votingPeriodBlockNumber = block.number;
235     }
236 
237     event LogAccepted(uint time);
238 
239     // anyone can call this if the score is finalized and not accepted
240     function accept() public {
241         // score is finalized
242         require(finalized);
243 
244         // voting period is over
245         require(currentTime() >= votingPeriodStartTime + VOTING_PERIOD_DURATION);
246 
247         // score is not already accepted as truth
248         require(!accepted);
249 
250         // require 66.666% majority of voters affirmed the score
251         require(affirmations.mul(100000).div(totalVotes) >= 66666);
252 
253         // score is accepted as truth
254         accepted = true;
255 
256         LogAccepted(currentTime());
257     }
258 
259     event LogUnfinalized(uint time);
260 
261     // called when the voting period ends with a minority
262     function unfinalize() public {
263         // score is finalized
264         require(finalized);
265 
266         // however it's not accepted
267         require(!accepted);
268 
269         // and the voting period for the score has ended
270         require(currentTime() >= votingPeriodStartTime + VOTING_PERIOD_DURATION);
271 
272         // require people to have
273         require(affirmations.mul(10000).div(totalVotes) < 6666);
274 
275         // score is no longer finalized
276         finalized = false;
277 
278         LogUnfinalized(currentTime());
279     }
280 
281     event LogVote(address indexed voter, bool indexed affirm, uint stake);
282 
283     // vote to affirm or unaffirm the score called by a user that has some stake
284     function vote(bool affirm) public {
285         // the voting period has started
286         require(votingPeriodStartTime != 0);
287 
288         // the score is finalized
289         require(finalized);
290 
291         // the score is not accepted
292         require(!accepted);
293 
294         uint stake = voterStakes.getVoterStakes(msg.sender, votingPeriodBlockNumber);
295 
296         // user has some stake
297         require(stake > 0);
298 
299         Vote storage userVote = votes[votingPeriodBlockNumber][msg.sender];
300 
301         // vote has not been counted, so
302         if (!userVote.counted) {
303             userVote.counted = true;
304             userVote.affirmed = affirm;
305 
306             totalVotes = totalVotes.add(stake);
307             if (affirm) {
308                 affirmations = affirmations.add(stake);
309             }
310         } else {
311             // changing their vote to an affirmation
312             if (affirm && !userVote.affirmed) {
313                 affirmations = affirmations.add(stake);
314             } else if (!affirm && userVote.affirmed) {
315                 // changing their vote to a disaffirmation
316                 affirmations = affirmations.sub(stake);
317             }
318             userVote.affirmed = affirm;
319         }
320 
321         LogVote(msg.sender, affirm, stake);
322     }
323 
324     function isFinalized() public view returns (bool) {
325         return super.isFinalized() && accepted;
326     }
327 }