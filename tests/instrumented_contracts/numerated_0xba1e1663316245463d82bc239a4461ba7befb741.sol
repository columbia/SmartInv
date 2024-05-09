1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 library ContractHelpers {
77   function isContract(address addr) internal view returns (bool) {
78       uint size;
79       assembly { size := extcodesize(addr) }
80       return size > 0;
81     }
82 }
83 
84 contract BetWinner is Ownable {
85   address owner;
86 
87   // team has name and its total bet amount and bettors
88   struct Team {
89     string name;
90     uint256 bets;
91     address[] bettors;
92     mapping(address => uint256) bettorAmount;
93   }
94 
95   Team[] teams;
96   uint8 public winningTeamIndex = 255; // 255 => not set
97 
98   // payout table for winners
99   mapping(address => uint256) public payOuts;
100 
101   bool public inited;
102 
103   // timestamps
104   uint32 public bettingStart;
105   uint32 public bettingEnd;
106   uint32 public winnerAnnounced;
107 
108   uint8 public feePercentage;
109   uint public minimumBet;
110   uint public totalFee;
111 
112   // events
113   event BetPlaced(address indexed _from, uint8 indexed _teamId, uint _value);
114   event Withdraw(address indexed _to, uint _value);
115   event Started(uint bettingStartTime, uint numberOfTeams);
116   event WinnerAnnounced(uint8 indexed teamIndex);
117 
118   // constructor
119   function BetWinner() public Ownable() {
120     feePercentage = 2;
121     minimumBet = 100 szabo;
122   }
123 
124   // get bettingStart, bettingEnd, winnerAnnounced, winnerIndex, teams count
125   function betInfo() public view returns (uint32, uint32, uint32, uint8, uint) {
126     return (bettingStart, bettingEnd, winnerAnnounced, winningTeamIndex, teams.length);
127   }
128   function bettingStarted() private view returns (bool) {
129     return now >= bettingStart;
130   }
131   function bettingEnded() private view returns (bool) {
132     return now >= bettingEnd;
133   }
134 
135   // remember to add all teams before calling startBetting
136   function addTeam(string _name) public onlyOwner {
137     require(!inited);
138     Team memory t = Team({
139       name: _name,
140       bets: 0,
141       bettors: new address[](0)
142     });
143     teams.push(t);
144   }
145   
146   // set betting start and stop times. after that teams cannot be added
147   function startBetting(uint32 _bettingStart, uint32 _bettingEnd) public onlyOwner {
148     require(!inited);
149 
150     bettingStart = _bettingStart;
151     bettingEnd = _bettingEnd;
152 
153     inited = true;
154 
155     Started(bettingStart, teams.length - 1);
156   }
157 
158   // get total bet amount for address for team
159   function getBetAmount(uint8 teamIndex) view public returns (uint) {
160     return teams[teamIndex].bettorAmount[msg.sender];
161   }
162 
163   // get team data (name, total bets, bettor count)
164   function getTeam(uint8 teamIndex) view public returns (string, uint, uint) {
165     Team memory t = teams[teamIndex];
166     return (t.name, t.bets, t.bettors.length);
167   }
168 
169   // get total bets for every team
170   function totalBets() view public returns (uint) {
171     uint total = 0;
172     for (uint i = 0; i < teams.length; i++) {
173       total += teams[i].bets;
174     }
175     return total;
176   }
177 
178   // place bet to team
179   function bet(uint8 teamIndex) payable public {
180     // betting has to be started and not ended and winningTeamIndex must be 255 (not announced)
181     require(bettingStarted() && !bettingEnded() && winningTeamIndex == 255);
182     // value must be at least minimum bet
183     require(msg.value >= minimumBet);
184     // must not be smart contract address
185     require(!ContractHelpers.isContract(msg.sender));
186     // check that we have team in that index we are betting
187     require(teamIndex < teams.length);
188 
189     // get storage ref
190     Team storage team = teams[teamIndex];
191     // add bet to team
192     team.bets += msg.value;
193 
194     // if new bettor, save address for paying winnings
195     if (team.bettorAmount[msg.sender] == 0) {
196       team.bettors.push(msg.sender);
197     }
198 
199     // send event
200     BetPlaced(msg.sender, teamIndex, msg.value);
201     // add bettor betting amount, so we can pay correct amount if win
202     team.bettorAmount[msg.sender] += msg.value;
203   }
204 
205   // calculate fee from the losing portion of total pot
206   function removeFeeAmount(uint totalPot, uint winnersPot) private returns(uint) {
207     uint remaining = SafeMath.sub(totalPot, winnersPot);
208     // if we only have winners, take no fee
209     if (remaining == 0) {
210       return 0;
211     }
212 
213     // calculate fee
214     uint feeAmount = SafeMath.div(remaining, 100);
215     feeAmount = feeAmount * feePercentage;
216 
217     totalFee = feeAmount;
218     // return loser side pot - fee = winnings
219     return remaining - feeAmount;
220   }
221 
222   // announce winner
223   function announceWinner(uint8 teamIndex) public onlyOwner {
224     // ensure we have a team here
225     require(teamIndex < teams.length);
226     // ensure that betting is ended before announcing winner and winner has not been announced
227     require(bettingEnded() && winningTeamIndex == 255);
228     winningTeamIndex = teamIndex;
229     winnerAnnounced = uint32(now);
230 
231     WinnerAnnounced(teamIndex);
232     // calculate payouts for winners
233     calculatePayouts();
234   }
235 
236   // calculate payouts
237   function calculatePayouts() private {
238     uint totalAmount = totalBets();
239     Team storage wt = teams[winningTeamIndex];
240     uint winTeamAmount = wt.bets;
241     // if we have no winners, no need to do anything
242     if (winTeamAmount == 0) {
243       return;
244     }
245 
246     // substract fee
247     uint winnings = removeFeeAmount(totalAmount, winTeamAmount);
248 
249     // calc percentage of total pot for every winner bettor
250     for (uint i = 0; i < wt.bettors.length; i++) {
251       // get bet amount
252       uint betSize = wt.bettorAmount[wt.bettors[i]];
253       // get bettor percentage of pot
254       uint percentage = SafeMath.div((betSize*100), winTeamAmount);
255       // calculate winnings
256       uint payOut = winnings * percentage;
257       // add winnings and original bet = total payout
258       payOuts[wt.bettors[i]] = SafeMath.div(payOut, 100) + betSize;
259     }
260   }
261 
262   // winner can withdraw payout after winner is announced
263   function withdraw() public {
264     // check that we have winner announced
265     require(winnerAnnounced > 0 && uint32(now) > winnerAnnounced);
266     // check that we have payout calculated for address.
267     require(payOuts[msg.sender] > 0);
268 
269     // no double withdrawals
270     uint po = payOuts[msg.sender];
271     payOuts[msg.sender] = 0;
272 
273     Withdraw(msg.sender, po);
274     // transfer payout to sender
275     msg.sender.transfer(po);
276   }
277 
278   // withdraw owner fee when winner is announced
279   function withdrawFee() public onlyOwner {
280     require(totalFee > 0);
281     // owner cannot withdraw fee before winner is announced. This is incentive for contract owner to announce winner
282     require(winnerAnnounced > 0 && now > winnerAnnounced);
283     // make sure owner cannot withdraw more than fee amount
284     msg.sender.transfer(totalFee);
285     // set total fee to zero, so owner cannot empty whole contract
286     totalFee = 0;
287   }
288 
289   // cancel and set all bets to payouts
290   function cancel() public onlyOwner {
291     require (winningTeamIndex == 255);
292     winningTeamIndex = 254;
293     winnerAnnounced = uint32(now);
294 
295     Team storage t = teams[0];
296     for (uint i = 0; i < t.bettors.length; i++) {
297       payOuts[t.bettors[i]] += t.bettorAmount[t.bettors[i]];
298     }
299     Team storage t2 = teams[1];
300     for (i = 0; i < t2.bettors.length; i++) {
301       payOuts[t2.bettors[i]] += t2.bettorAmount[t2.bettors[i]];
302     }
303   }
304 
305   // can kill contract after winnerAnnounced + 8 weeks
306   function kill() public onlyOwner {
307     // cannot kill contract before winner is announced and it's been announced at least for 8 weeks
308     require(winnerAnnounced > 0 && uint32(now) > (winnerAnnounced + 8 weeks));
309     selfdestruct(msg.sender);
310   }
311 
312   // prevent eth transfers to this contract
313   function () public payable {
314     revert();
315   }
316 }