1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity: 1.8.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
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
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 contract ChampionSimple is Ownable {
92   using SafeMath for uint;
93 
94   event LogDistributeReward(address addr, uint reward);
95   event LogParticipant(address addr, uint choice, uint betAmount);
96   event LogModifyChoice(address addr, uint oldChoice, uint newChoice);
97   event LogRefund(address addr, uint betAmount);
98   event LogWithdraw(address addr, uint amount);
99   event LogWinChoice(uint choice, uint reward);
100 
101   uint public minimumBet = 5 * 10 ** 16;
102   uint public deposit = 0;
103   uint public totalBetAmount = 0;
104   uint public startTime;
105   uint public winChoice;
106   uint public winReward;
107   uint public numberOfBet;
108   bool public betClosed = false;
109 
110   struct Player {
111     uint betAmount;
112     uint choice;
113   }
114 
115   address [] public players;
116   mapping(address => Player) public playerInfo;
117   mapping(uint => uint) public numberOfChoice;
118   mapping(uint => mapping(address => bool)) public addressOfChoice;
119   mapping(address => bool) public withdrawRecord;
120  
121   modifier beforeTimestamp(uint timestamp) {
122     require(now < timestamp);
123     _;
124   }
125 
126   modifier afterTimestamp(uint timestamp) {
127     require(now >= timestamp);
128     _;
129   }
130 
131   /**
132    * @dev the construct function
133    * @param _startTime the deadline of betting
134    * @param _minimumBet the minimum bet amount
135    */
136   function ChampionSimple(uint _startTime, uint _minimumBet) payable public {
137     require(_startTime > now);
138     deposit = msg.value;
139     startTime = _startTime;
140     minimumBet = _minimumBet;
141   }
142 
143   /**
144    * @dev find a player has participanted or not
145    * @param player the address of the participant
146    */
147   function checkPlayerExists(address player) public view returns (bool) {
148     if (playerInfo[player].choice == 0) {
149       return false;
150     }
151     return true;
152   }
153 
154   /**
155    * @dev to bet which team will be the champion
156    * @param choice the choice of the participant(actually team id)
157    */
158   function placeBet(uint choice) payable beforeTimestamp(startTime) public {
159     require(choice > 0);
160     require(!checkPlayerExists(msg.sender));
161     require(msg.value >= minimumBet);
162 
163     playerInfo[msg.sender].betAmount = msg.value;
164     playerInfo[msg.sender].choice = choice;
165     totalBetAmount = totalBetAmount.add(msg.value);
166     numberOfBet = numberOfBet.add(1);
167     players.push(msg.sender);
168     numberOfChoice[choice] = numberOfChoice[choice].add(1);
169     addressOfChoice[choice][msg.sender] = true;
170     LogParticipant(msg.sender, choice, msg.value);
171   }
172 
173   /**
174    * @dev allow user to change their choice before a timestamp
175    * @param choice the choice of the participant(actually team id)
176    */
177   function modifyChoice(uint choice) beforeTimestamp(startTime) public {
178     require(choice > 0);
179     require(checkPlayerExists(msg.sender));
180 
181     uint oldChoice = playerInfo[msg.sender].choice;
182     numberOfChoice[oldChoice] = numberOfChoice[oldChoice].sub(1);
183     numberOfChoice[choice] = numberOfChoice[choice].add(1);
184     playerInfo[msg.sender].choice = choice;
185 
186     addressOfChoice[oldChoice][msg.sender] = false;
187     addressOfChoice[choice][msg.sender] = true;
188     LogModifyChoice(msg.sender, oldChoice, choice);
189   }
190 
191   /**
192    * @dev close who is champion bet with the champion id
193    */
194   function saveResult(uint teamId) onlyOwner public {
195     winChoice = teamId;
196     betClosed = true;
197     winReward = deposit.add(totalBetAmount).div(numberOfChoice[winChoice]);
198     LogWinChoice(winChoice, winReward);
199   }
200 
201   /**
202    * @dev every user can withdraw his reward
203    */
204   function withdrawReward() public {
205     require(betClosed);
206     require(!withdrawRecord[msg.sender]);
207     require(winChoice > 0);
208     require(winReward > 0);
209     require(addressOfChoice[winChoice][msg.sender]);
210 
211     msg.sender.transfer(winReward);
212     withdrawRecord[msg.sender] = true;
213     LogDistributeReward(msg.sender, winReward);
214   }
215 
216   /**
217    * @dev anyone could recharge deposit
218    */
219   function rechargeDeposit() payable public {
220     deposit = deposit.add(msg.value);
221   }
222 
223   /**
224    * @dev get player bet information
225    * @param addr indicate the bet address
226    */
227   function getPlayerBetInfo(address addr) view public returns (uint, uint) {
228     return (playerInfo[addr].choice, playerInfo[addr].betAmount);
229   }
230 
231   /**
232    * @dev get the bet numbers of a specific choice
233    * @param choice indicate the choice
234    */
235   function getNumberByChoice(uint choice) view public returns (uint) {
236     return numberOfChoice[choice];
237   }
238 
239   /**
240    * @dev if there are some reasons lead game postpone or cancel
241    *      the bet will also cancel and refund every bet
242    */
243   function refund() onlyOwner public {
244     for (uint i = 0; i < players.length; i++) {
245       players[i].transfer(playerInfo[players[i]].betAmount);
246       LogRefund(players[i], playerInfo[players[i]].betAmount);
247     }
248   }
249 
250   /**
251    * @dev get the players
252    */
253   function getPlayers() view public returns (address[]) {
254     return players;
255   }
256 
257   /**
258    * @dev dealer can withdraw the remain ether if distribute exceeds max length
259    */
260   function withdraw() onlyOwner public {
261     uint _balance = address(this).balance;
262     owner.transfer(_balance);
263     LogWithdraw(owner, _balance);
264   }
265 }