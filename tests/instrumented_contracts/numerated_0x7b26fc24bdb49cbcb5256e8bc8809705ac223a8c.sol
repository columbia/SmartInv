1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 
89 /**
90  * @title Helps contracts guard agains reentrancy attacks.
91  * @author Remco Bloemen <remco@2π.com>
92  * @notice If you mark a function `nonReentrant`, you should also
93  * mark it `external`.
94  */
95 contract ReentrancyGuard {
96 
97   /**
98    * @dev We use a single lock for the whole contract.
99    */
100   bool private reentrancy_lock = false;
101 
102   /**
103    * @dev Prevents a contract from calling itself, directly or indirectly.
104    * @notice If you mark a function `nonReentrant`, you should also
105    * mark it `external`. Calling one nonReentrant function from
106    * another is not supported. Instead, you can implement a
107    * `private` function doing the actual work, and a `external`
108    * wrapper marked as `nonReentrant`.
109    */
110   modifier nonReentrant() {
111     require(!reentrancy_lock);
112     reentrancy_lock = true;
113     _;
114     reentrancy_lock = false;
115   }
116 
117 }
118 
119 contract Ethery is Pausable, ReentrancyGuard{
120   event NewBet(uint id, address player, uint wager, uint targetBlock);
121   event BetResolved(uint id, BetStatus status);
122   
123   bytes32 constant byteMask = bytes32(0xF);
124 
125   enum BetStatus { Pending, PlayerWon, HouseWon, Refunded }
126   
127   struct Bet {
128     address player;
129     uint wager;
130     uint digits;
131     bytes32 guess;
132     BetStatus status;
133     uint targetBlock;
134   }
135   
136   Bet[] public bets;
137   
138   mapping (uint => address) public betToOwner;
139   mapping (address => uint) ownerBetCount;
140   
141   uint resolverFee = 0.1 finney;
142   uint maxPayout = 1 ether;
143   uint pendingPay;
144   
145   function setResolverFee(uint _resolverFee) external onlyOwner {
146     resolverFee = _resolverFee;
147   }
148   
149   function getResolverFee() external view returns (uint){
150     return resolverFee;
151   }
152   
153   function setMaxPayout(uint _maxPayout) external onlyOwner {
154     maxPayout = _maxPayout;
155   }
156 
157   function getMaxPayout() external view returns (uint){
158     return maxPayout;
159   }
160   
161   function withDraw(uint _amount) external onlyOwner {
162     require(_amount < this.balance - pendingPay);
163     msg.sender.transfer(_amount);
164   }
165   
166   function () public payable {}
167   
168   function createBet(uint _digits, bytes32 _guess, uint _targetBlock) public payable whenNotPaused {
169     require(
170       msg.value >= resolverFee &&
171       _targetBlock > block.number &&
172       block.number + 256 >= _targetBlock &&
173       payout(msg.value, _digits) <= maxPayout &&
174       payout(msg.value, _digits) <= this.balance - pendingPay
175     );
176     uint id = bets.push(Bet(msg.sender, msg.value, _digits, _guess, BetStatus.Pending, _targetBlock)) - 1;
177     betToOwner[id] = msg.sender;
178     ownerBetCount[msg.sender]++;
179     pendingPay += payout(msg.value, _digits);
180     NewBet(id, msg.sender, msg.value, _targetBlock);
181   }
182   
183   function resolveBet(uint _betId) public nonReentrant {
184     Bet storage myBet = bets[_betId];  
185     require(
186       myBet.status == BetStatus.Pending &&    // only resolve pending bets
187       myBet.targetBlock < block.number        // only resolve targetBlock > current block
188     );
189     
190     pendingPay -= payout(myBet.wager, uint(myBet.digits));
191     
192     if (myBet.targetBlock + 255 < block.number) {    // too late to determine out come issue refund
193       myBet.status = BetStatus.Refunded;
194       betToOwner[_betId].transfer(myBet.wager);
195     } else {
196       bytes32 targetBlockHash = block.blockhash(myBet.targetBlock);
197       if (isCorrectGuess(targetBlockHash, myBet.guess, uint(myBet.digits))) {
198         myBet.status = BetStatus.PlayerWon;
199         betToOwner[_betId].transfer(payout(myBet.wager, uint(myBet.digits)));
200       } else {
201         myBet.status = BetStatus.HouseWon;
202       }
203     }
204     msg.sender.transfer(resolverFee);
205     BetResolved(_betId, myBet.status);
206   }
207   
208   function isCorrectGuess(bytes32 _blockHash, bytes32 _guess, uint _digits) public pure returns (bool) {
209     for (uint i = 0; i < uint(_digits); i++) {
210       if (byteMask & _guess != _blockHash & byteMask) {
211         return false;
212       }
213       _blockHash = _blockHash >> 4;
214       _guess = _guess >> 4;
215     }
216     return true;
217   }
218   
219   function payout(uint _wager, uint _digits) public view returns (uint) {
220     uint baseWager = (100 - houseFee(_digits)) * (_wager - resolverFee) / 100;
221     return baseWager * 16 ** _digits;
222   }
223   
224   function houseFee(uint _digits) public pure returns (uint) {    // in percent
225     require(0 < _digits && _digits <= 4);
226     if (_digits == 1) { return 2; }
227     else if(_digits == 2) { return 3; }
228     else if(_digits == 3) { return 4; }
229     else { return 5; }
230   }
231   
232   function getBet(uint index) public view returns(address, uint, uint, bytes32, BetStatus, uint) {
233     return (bets[index].player, bets[index].wager, bets[index].digits, bets[index].guess, bets[index].status, bets[index].targetBlock);
234   }
235   
236   function getPlayerBets() external view returns(uint[]) {
237     return getBetsByOwner(msg.sender);  
238   }
239   
240   function getBetsByOwner(address _owner) private view returns(uint[]) {
241     uint[] memory result = new uint[](ownerBetCount[_owner]);
242     uint counter = 0;
243     for (uint i = 0; i < bets.length; i++) {
244       if (betToOwner[i] == _owner) {
245         result[counter] = i;
246         counter++;
247       }
248     }
249     return result;
250   }
251   
252   function getTotalWins() external view returns(uint) {
253     uint pays = 0;
254     for (uint i = 0; i < bets.length; i++) {
255       if (bets[i].status == BetStatus.PlayerWon) {
256         pays += payout(bets[i].wager, bets[i].digits);
257       }
258     }
259     return pays;
260   }
261 
262   function recentWinners() external view returns(uint[]) {
263     uint len = 5;
264     uint[] memory result = new uint[](len);
265     uint counter = 0;
266 
267     for (uint i = 1; i <= bets.length && counter < len; i++) {
268       if (bets[bets.length - i].status == BetStatus.PlayerWon) {
269         result[counter] = bets.length - i;
270         counter++;
271       }
272     }
273     return result;
274   }
275 
276 }