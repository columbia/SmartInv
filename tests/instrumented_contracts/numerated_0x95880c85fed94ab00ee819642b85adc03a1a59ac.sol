1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract Bet {
50     address public ceoAddress;
51     address public cooAddress;
52 
53     enum RoundStatus { UNKNOWN, RUNNING, FINISHED, CANCELLED }
54 
55     event RoundCreated(uint16 roundId);
56     event BetPlaced(uint betId, uint16 roundId, uint amount);
57     event RoundStatusUpdated(uint16 roundId, RoundStatus oldStatus, RoundStatus newStatus);
58     event FinalScoreUpdated(uint16 roundId, bytes32 winner);
59     event Debug(uint16 roundId, uint expire, uint time, bool condition);
60 
61     struct Round {
62         string name;
63         bytes32[] statusPossibility;
64         uint16 nbBets;
65         uint prizePool;
66         RoundStatus status;
67         bytes32 resultStatus;
68         uint runningAt;
69         uint finishedAt;
70         uint expireAt;
71     }
72 
73     struct Bet {
74         uint16 roundId;
75         address owner;
76         uint amount;
77         bytes32 status;
78         bool claimed;
79     }
80 
81     //mapping(uint => address) public betToOwner;
82     mapping(uint16 => uint[]) public roundBets; // roundId => betId[]
83     //mapping(address => uint) public ownerBetCount;
84     Bet[] public bets;
85     Round[] public rounds;
86     uint16 public roundsCount;
87     uint public fees;
88     uint public MINIMUM_BET_VALUE = 0.01 ether;
89 
90     constructor() public {
91         ceoAddress = msg.sender;
92         cooAddress = msg.sender;
93     }
94 
95     function setMinimumBetValue(uint _minimumBetValue) onlyCLevel {
96         MINIMUM_BET_VALUE = _minimumBetValue;
97     }
98 
99     function setCEOAddress(address _address) public onlyOwner {
100         ceoAddress = _address;
101     }
102 
103     function setCOOAddress(address _address) public onlyOwner {
104         cooAddress = _address;
105     }
106 
107     function createRound(string _name, bytes32[] _statusPossibility, uint _expireAt) public onlyCLevel {
108         uint16 id = uint16(rounds.push(Round(_name, _statusPossibility, 0, 0, RoundStatus.RUNNING, 0, now, 0, _expireAt)) - 1);
109         roundsCount = uint16(SafeMath.add(roundsCount, 1));
110 
111         emit RoundCreated(id);
112     }
113 
114     function getRoundStatuses(uint16 _roundId) public view returns(bytes32[] statuses) {
115         return rounds[_roundId].statusPossibility;
116     }
117 
118     function extendRound(uint16 _roundId, uint _time) public onlyCLevel {
119         rounds[_roundId].expireAt = _time;
120     }
121 
122     function getRoundBets(uint16 _roundId) public view returns(uint[] values) {
123         return roundBets[_roundId];
124     }
125 
126     function updateRoundStatus(uint16 _id, RoundStatus _status) public onlyCLevel {
127         require(rounds[_id].status != RoundStatus.FINISHED);
128         emit RoundStatusUpdated(_id, rounds[_id].status, _status);
129         rounds[_id].status = _status;
130 
131         if (_status == RoundStatus.CANCELLED) {
132             rounds[_id].finishedAt = now;
133         }
134     }
135 
136     function setRoundFinalScore(uint16 _roundId, bytes32 _resultStatus) public
137     roundIsRunning(_roundId)
138     onlyCLevel
139     payable {
140         rounds[_roundId].status = RoundStatus.FINISHED;
141         rounds[_roundId].finishedAt = now;
142         rounds[_roundId].resultStatus = _resultStatus;
143 
144         emit FinalScoreUpdated(_roundId, _resultStatus);
145     }
146 
147     function bet(uint16 _roundId, bytes32 _status) public
148     roundIsRunning(_roundId)
149     greaterThan(msg.value, MINIMUM_BET_VALUE)
150     isNotExpired(_roundId)
151     payable {
152         Debug(_roundId, rounds[_roundId].expireAt, now, now >= rounds[_roundId].expireAt);
153         uint id = bets.push(Bet(_roundId, msg.sender, msg.value, _status, false)) - 1;
154         roundBets[_roundId].push(id);
155         rounds[_roundId].nbBets++;
156         rounds[_roundId].prizePool += msg.value;
157 
158         emit BetPlaced(id, _roundId, msg.value);
159     }
160 
161     function claimRoundReward(uint16 _roundId, address _owner) public roundIsFinish(_roundId) returns (uint rewardAfterFees, uint rewardFees) {
162         Round memory myRound = rounds[_roundId];
163         uint[] memory betIds = getRoundBets(_roundId);
164 
165         uint totalRewardsOnBet = 0;
166         uint totalBetOnWinResult = 0;
167         uint amountBetOnResultForOwner = 0;
168         for (uint i = 0; i < betIds.length; i++) {
169             Bet storage bet = bets[betIds[i]];
170 
171             if (bet.status == myRound.resultStatus) {
172                 totalBetOnWinResult = SafeMath.add(totalBetOnWinResult, bet.amount);
173                 if (bet.claimed == false && bet.owner == _owner) {
174                     amountBetOnResultForOwner = SafeMath.add(amountBetOnResultForOwner, bet.amount);
175                     bet.claimed = true;
176                 }
177             } else {
178                 totalRewardsOnBet = SafeMath.add(totalRewardsOnBet, bet.amount);
179             }
180         }
181 
182         uint coef = 10000000; // Handle 4 numbers precision
183         uint percentOwnerReward = SafeMath.div(SafeMath.mul(amountBetOnResultForOwner, coef), totalBetOnWinResult);
184 
185         uint rewardToOwner = SafeMath.div(SafeMath.mul(percentOwnerReward, totalRewardsOnBet), coef);
186         rewardAfterFees = SafeMath.div(SafeMath.mul(rewardToOwner, 90), 100);
187         rewardFees = SafeMath.sub(rewardToOwner, rewardAfterFees);
188         rewardAfterFees = SafeMath.add(rewardAfterFees, amountBetOnResultForOwner);
189 
190         fees = SafeMath.add(fees, rewardFees);
191 
192         _owner.transfer(rewardAfterFees);
193     }
194 
195     function claimCancelled(uint16 _roundId, address _owner) public roundIsCancelled(_roundId) returns(uint amountToClaimBack) {
196         uint[] memory betIds = getRoundBets(_roundId);
197 
198         amountToClaimBack = 0;
199         for (uint i = 0; i < betIds.length; i++) {
200             Bet storage bet = bets[betIds[i]];
201 
202             if (bet.owner == _owner && bet.claimed != true) {
203                 amountToClaimBack = SafeMath.add(amountToClaimBack, bet.amount);
204                 bet.claimed = true;
205             }
206         }
207 
208         _owner.transfer(amountToClaimBack);
209     }
210 
211     function claimRewards(uint16[] _roundsToClaim, address _owner) public {
212         for (uint i = 0; i < _roundsToClaim.length; i++) {
213             claimRoundReward(_roundsToClaim[i], _owner);
214         }
215     }
216 
217     function payout(address _to, uint _amount) public onlyOwner {
218         require(fees >= _amount);
219         fees = SafeMath.sub(fees, _amount);
220         _to.transfer(_amount);
221     }
222 
223     modifier onlyOwner() {
224         require(msg.sender == ceoAddress);
225         _;
226     }
227 
228     modifier onlyCLevel() {
229         require(msg.sender == ceoAddress || msg.sender == cooAddress);
230         _;
231     }
232 
233     modifier greaterThan(uint _value, uint _expect) {
234         require(_value >= _expect);
235         _;
236     }
237 
238     modifier isNotExpired(uint16 _roundId) {
239         require(rounds[_roundId].expireAt == 0 || now < rounds[_roundId].expireAt);
240         _;
241     }
242 
243     modifier betStatusPossible(uint16 _roundId, bytes32 _status) {
244         //require(_status < rounds[_roundId].statusPossibility);
245         _;
246     }
247 
248     modifier roundIsCancelled(uint16 _roundId) {
249         require(rounds[_roundId].status == RoundStatus.CANCELLED);
250         _;
251     }
252 
253     modifier roundIsRunning(uint16 _roundId) {
254         require(rounds[_roundId].status == RoundStatus.RUNNING);
255         _;
256     }
257 
258     modifier roundIsFinish(uint16 _roundId) {
259         require(rounds[_roundId].status == RoundStatus.FINISHED);
260         _;
261     }
262 }