1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *__/\\\\\\\\\\\\\__________________________________________________/\\\\\\\\\\\\\______________________________________________
6 * _\/\\\/////////\\\_______________________________________________\/\\\/////////\\\_______________________________/\\\_________
7 *  _\/\\\_______\/\\\__/\\\___/\\\\\\\\____/\\\\\\\\_____/\\\__/\\\_\/\\\_______\/\\\______________________________\/\\\_________
8 *   _\/\\\\\\\\\\\\\/__\///___/\\\////\\\__/\\\////\\\___\//\\\/\\\__\/\\\\\\\\\\\\\\___/\\\\\\\\\_____/\\/\\\\\\___\/\\\\\\\\____
9 *    _\/\\\/////////_____/\\\_\//\\\\\\\\\_\//\\\\\\\\\____\//\\\\\___\/\\\/////////\\\_\////////\\\___\/\\\////\\\__\/\\\////\\\__
10 *     _\/\\\_____________\/\\\__\///////\\\__\///////\\\_____\//\\\____\/\\\_______\/\\\___/\\\\\\\\\\__\/\\\__\//\\\_\/\\\\\\\\/___
11 *      _\/\\\_____________\/\\\__/\\_____\\\__/\\_____\\\__/\\_/\\\_____\/\\\_______\/\\\__/\\\/////\\\__\/\\\___\/\\\_\/\\\///\\\___
12 *       _\/\\\_____________\/\\\_\//\\\\\\\\__\//\\\\\\\\__\//\\\\/______\/\\\\\\\\\\\\\/__\//\\\\\\\\/\\_\/\\\___\/\\\_\/\\\_\///\\\_
13 *        _\///______________\///___\////////____\////////____\////________\/////////////_____\////////\//__\///____\///__\///____\///__
14 */
15 
16 library SafeMath {
17     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (_a == 0) {
22             return 0;
23         }
24 
25         uint256 c = _a * _b;
26         require(c / _a == _b);
27 
28         return c;
29     }
30 
31     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
32         require(_b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = _a / _b;
34         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
40         require(_b <= _a);
41         uint256 c = _a - _b;
42 
43         return c;
44     }
45 
46     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a);
49 
50         return c;
51     }
52 
53     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
54         require(b != 0);
55         return a % b;
56     }
57 }
58 
59 contract Ownable {
60     address public owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     modifier onlyThisOwner(address _owner) {
74         require(owner == _owner);
75         _;
76     }
77 
78     function transferOwnership(address newOwner) public onlyOwner {
79         require(newOwner != address(0));
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82     }
83 
84 }
85 
86 contract Betting {
87 
88     uint8 public constant betsCount = 28;
89     uint8 public constant betKillCount = 2;
90     struct Bet {
91         uint256 minSum;     // min value eth for choose this bet
92         uint256 cooldown;   // time for reset timer
93     }
94 
95     Bet[] public bets;
96 
97     constructor() public {
98         bets.push(Bet(0.01 ether, 86400));  // 24 hour
99         bets.push(Bet(0.02 ether, 82800));  // 23 hour
100         bets.push(Bet(0.03 ether, 79200));  // 22 hour
101         bets.push(Bet(0.04 ether, 75600));  // 21 hour
102         bets.push(Bet(0.05 ether, 72000));  // 20 hour
103         bets.push(Bet(0.06 ether, 68400));  // 19 hour
104         bets.push(Bet(0.07 ether, 64800));  // 18 hour
105         bets.push(Bet(0.08 ether, 61200));  // 17 hour
106         bets.push(Bet(0.09 ether, 57600));  // 16 hour
107         bets.push(Bet(0.1 ether, 54000));   // 15 hour
108         bets.push(Bet(0.11 ether, 50400));  // 14 hour
109         bets.push(Bet(0.12 ether, 46800));  // 13 hour
110         bets.push(Bet(0.13 ether, 43200));  // 12 hour
111         bets.push(Bet(0.14 ether, 39600));  // 11 hour
112         bets.push(Bet(0.15 ether, 36000));  // 10 hour
113         bets.push(Bet(0.16 ether, 32400));  // 9 hour
114         bets.push(Bet(0.17 ether, 28800));  // 8 hour
115         bets.push(Bet(0.18 ether, 25200));  // 7 hour
116         bets.push(Bet(0.19 ether, 21600));  // 6 hour
117         bets.push(Bet(0.2 ether, 18000));   // 5 hour
118         bets.push(Bet(0.21 ether, 14400));  // 4 hour
119         bets.push(Bet(0.22 ether, 10800));  // 3 hour
120         bets.push(Bet(0.25 ether, 7200));   // 2 hour
121         bets.push(Bet(0.5 ether, 3600));    // 1 hour
122         bets.push(Bet(1 ether, 2400));      // 40 min
123         bets.push(Bet(5 ether, 1200));      // 20 min
124         bets.push(Bet(10 ether, 600));      // 10 min
125         bets.push(Bet(50 ether, 300));      // 5 min
126     }
127 
128     function getBet(uint256 _betIndex) public view returns(uint256, uint256) {
129         Bet memory bet = bets[_betIndex];
130         return (bet.minSum, bet.cooldown);
131     }
132 
133     function getBetIndex(uint256 _sum) public view returns(uint256) {
134         for (uint256 i = betsCount - 1; i >= 0; i--) {
135             if (_sum >= bets[i].minSum) return i;
136         }
137 
138         revert('Bet not found');
139     }
140 
141     function getMinBetIndexForKill(uint256 _index) public view returns(uint256) {
142         if (_index < betKillCount) return 0;
143 
144         return _index - betKillCount;
145     }
146 
147 }
148 
149 contract PiggyBank is Ownable, Betting {
150 
151     using SafeMath for uint256;
152 
153     event NewRound(uint256 _roundId, uint256 _endTime);
154     event CloseRound(uint256 _roundId);
155     event UpdateRound(uint256 _roundId, uint256 _sum, address _winner, uint256 _endTime, uint256 _cap);
156     event PayWinCap(uint256 _roundId, address _winner, uint256 _cap);
157 
158     struct Round {
159         uint256 endTime;
160         uint256 cap;
161         uint256 lastBetIndex;
162         uint256 countBets;
163         address winner;
164         bool isPaid;
165     }
166 
167     Round[] public rounds;
168     uint256 public currentRound;
169     uint256 public constant defaultRoundTime = 86400;   // 24 hours
170     uint256 public constant freeBetsCount = 5;
171     uint256 public constant ownerDistribution = 15;     // 15%
172     uint256 public constant referrerDistribution = 5;   // 5%
173     mapping (address => address) public playerToReferrer;
174 
175     constructor() public {
176 
177     }
178 
179     function getRoundInfo(uint256 _roundId) public view returns(uint256, uint256, uint256, address) {
180         Round memory round = rounds[_roundId];
181         return (round.endTime, round.cap, round.lastBetIndex, round.winner);
182     }
183 
184     function payWinCap(uint256 _roundId) {
185         require(rounds[_roundId].endTime < now, 'Round is not closed');
186         require(rounds[_roundId].isPaid == false, 'Round is paid');
187 
188         rounds[_roundId].isPaid = true;
189         rounds[_roundId].winner.transfer(rounds[_roundId].cap);
190 
191         emit PayWinCap(_roundId, rounds[_roundId].winner, rounds[_roundId].cap);
192     }
193 
194     function _startNewRoundIfNeeded() private {
195         if (rounds.length > currentRound) return;
196 
197         uint256 roundId = rounds.push(Round(now + defaultRoundTime, 0, 0, 0, 0x0, false)) - 1;
198         emit NewRound(roundId, now);
199     }
200 
201     function _closeRoundIfNeeded() private {
202         if (rounds.length <= currentRound) return;
203         if (now <= rounds[currentRound].endTime) return;
204 
205         currentRound = currentRound.add(1);
206         emit CloseRound(currentRound - 1);
207     }
208 
209     function depositRef(address _referrer) payable public {
210         uint256 betIndex = getBetIndex(msg.value);
211         // close if needed
212         _closeRoundIfNeeded();
213 
214         // for new rounds
215         _startNewRoundIfNeeded();
216 
217         require(betIndex >= getMinBetIndexForKill(rounds[currentRound].lastBetIndex), "More bet value required");
218         Bet storage bet = bets[betIndex];
219 
220         // work with actual
221         rounds[currentRound].countBets++;
222         rounds[currentRound].lastBetIndex = betIndex;
223         rounds[currentRound].endTime = now.add(bet.cooldown);
224         rounds[currentRound].winner = msg.sender;
225 
226         // distribution
227         uint256 ownerPercent = 0;
228         uint256 referrerPercent = 0;
229         if (rounds[currentRound].countBets > freeBetsCount) {
230             ownerPercent = ownerDistribution;
231             if (playerToReferrer[msg.sender] == 0x0 && _referrer != 0x0 && _referrer != msg.sender) playerToReferrer[msg.sender] = _referrer;
232             if (playerToReferrer[msg.sender] != 0x0) referrerPercent = referrerDistribution;
233         }
234 
235         ownerPercent = ownerPercent.sub(referrerPercent);
236         if (ownerPercent > 0) owner.transfer(msg.value * ownerPercent / 100);
237         if (referrerPercent > 0 && playerToReferrer[msg.sender] != 0x0) playerToReferrer[msg.sender].transfer(msg.value * referrerPercent / 100);
238 
239         rounds[currentRound].cap = rounds[currentRound].cap.add(msg.value * (100 - (ownerPercent + referrerPercent)) / 100);
240 
241         emit UpdateRound(currentRound, msg.value * (100 - (ownerPercent + referrerPercent)) / 100, rounds[currentRound].winner, rounds[currentRound].endTime, rounds[currentRound].cap);
242     }
243 
244     function deposit() payable public {
245         depositRef(0x0);
246     }
247 
248 }