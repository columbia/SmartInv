1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 /**
119  * @title HouseAdmin
120  * @dev The HouseAdmin contract has a signer address and a croupier address, and provides basic authorization control
121  *      functions, this simplifies the implementation of "user permissions"
122  */
123 contract HouseAdmin is Ownable {
124   address public signer;
125   address public croupier;
126 
127   event SignerTransferred(address indexed previousSigner, address indexed newSigner);
128   event CroupierTransferred(address indexed previousCroupier, address indexed newCroupier);
129 
130   /**
131    * @dev Throws if called by any account other than the signer or owner
132    */
133   modifier onlySigner() {
134     require(msg.sender == signer || msg.sender == owner);
135     _;
136   }
137 
138   /**
139    * @dev Throws if called by any account other than the croupier or owner
140    */
141   modifier onlyCroupier() {
142     require(msg.sender == croupier || msg.sender == owner);
143     _;
144   }
145 
146   /**
147    * @dev The Signable constructor sets the original `signer` of the contract to the sender
148    *      account
149    */
150   constructor() public {
151     signer = msg.sender;
152     croupier = msg.sender;
153   }
154 
155   /**
156    * @dev Allows the current signer to transfer control of the contract to a newSigner
157    * @param _newSigner The address to transfer signership to
158    */
159   function transferSigner(address _newSigner) public onlySigner {
160     _transferSigner(_newSigner);
161   }
162 
163   /**
164    * @dev Allows the current croupier to transfer control of the contract to a newCroupier
165    * @param _newCroupier The address to transfer croupiership to
166    */
167   function transferCroupier(address _newCroupier) public onlyCroupier {
168     _transferCroupier(_newCroupier);
169   }
170 
171   /**
172    * @dev Transfers control of the contract to a newSigner.
173    * @param _newSigner The address to transfer signership to.
174    */
175   function _transferSigner(address _newSigner) internal {
176     require(_newSigner != address(0));
177     emit SignerTransferred(signer, _newSigner);
178     signer = _newSigner;
179   }
180 
181   /**
182    * @dev Transfers control of the contract to a newCroupier.
183    * @param _newCroupier The address to transfer croupiership to.
184    */
185   function _transferCroupier(address _newCroupier) internal {
186     require(_newCroupier != address(0));
187     emit CroupierTransferred(croupier, _newCroupier);
188     croupier = _newCroupier;
189   }
190 }
191 
192 
193 contract Casino is Ownable, HouseAdmin {
194   using SafeMath for uint;
195 
196   uint constant HOUSE_EDGE_PERCENT = 1;
197   uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
198 
199   uint constant BET_AMOUNT_MIN = 0.01 ether;
200   uint constant BET_AMOUNT_MAX = 1000 ether;
201 
202   uint constant BET_EXPIRATION_BLOCKS = 250;
203 
204   uint constant MAX_MASKABLE_MODULO = 40;
205   uint constant MAX_BET_MASK = 2 ** MAX_MASKABLE_MODULO;
206 
207   // population count
208   uint constant POPCOUNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
209   uint constant POPCOUNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
210   uint constant POPCOUNT_MODULO = 0x3F;
211 
212   uint public bankFund;
213 
214   struct Bet {
215     uint8 modulo;
216     uint64 choice;
217     uint amount;
218     uint winAmount;
219     uint placeBlockNumber;
220     bool isActive;
221     address player;
222   }
223 
224   mapping (uint => Bet) public bets;
225 
226   event LogParticipant(address indexed player, uint indexed modulo, uint choice, uint amount, uint commit);
227   event LogClosedBet(address indexed player, uint indexed modulo, uint choice, uint reveal, uint result, uint amount, uint winAmount);
228   event LogDistributeReward(address indexed addr, uint reward);
229   event LogRecharge(address indexed addr, uint amount);
230   event LogRefund(address indexed addr, uint amount);
231   event LogDealerWithdraw(address indexed addr, uint amount);
232 
233   constructor() payable public {
234     owner = msg.sender;
235   }
236 
237   function placeBet(uint _choice, uint _modulo, uint _expiredBlockNumber, uint _commit, uint8 _v, bytes32 _r, bytes32 _s) payable external {
238     Bet storage bet = bets[_commit];
239 
240     uint amount = msg.value;
241 
242     require(bet.player == address(0), "this bet is already exist");
243     require(block.number <= _expiredBlockNumber, 'this bet has expired');
244     require(amount >= BET_AMOUNT_MIN && amount <= BET_AMOUNT_MAX, 'bet amount out of range');
245 
246     // verify the signer and _expiredBlockNumber
247     bytes32 msgHash = keccak256(abi.encodePacked(_expiredBlockNumber, _commit));
248     require(ecrecover(msgHash, _v, _r, _s) == signer, "incorrect signer");
249 
250     uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
251     if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
252       houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
253     }
254 
255     uint populationCount;
256     if (_modulo < MAX_MASKABLE_MODULO) {
257       require(_choice < MAX_BET_MASK, "choice too large");
258       populationCount = (_choice * POPCOUNT_MULT & POPCOUNT_MASK) % POPCOUNT_MODULO;
259       require(populationCount < _modulo, "winning rate out of range");
260     } else {
261       require(_choice < _modulo, "choice large than modulo");
262       populationCount = _choice;
263     }
264 
265     uint winAmount = (amount - houseEdge).mul(_modulo) / populationCount;
266     require(bankFund.add(winAmount) <= address(this).balance, 'contract balance is not enough');
267     // lock winAmount into this contract. Make sure contract is solvent
268     bankFund = bankFund.add(winAmount);
269 
270     bet.choice = uint64(_choice);
271     bet.player = msg.sender;
272     bet.placeBlockNumber = block.number;
273     bet.amount = amount;
274     bet.winAmount = winAmount;
275     bet.isActive = true;
276     bet.modulo = uint8(_modulo);
277 
278     emit LogParticipant(msg.sender, _modulo, _choice, amount, _commit);
279   }
280 
281   function closeBet(uint _reveal) external onlyCroupier {
282     uint commit = uint(keccak256(abi.encodePacked(_reveal)));
283     Bet storage bet = bets[commit];
284 
285     require(bet.isActive, 'this bet is not active');
286 
287     uint amount = bet.amount;
288     uint placeBlockNumber = bet.placeBlockNumber;
289     uint modulo = bet.modulo;
290     uint winAmount = 0;
291     uint choice = bet.choice;
292     address player = bet.player;
293 
294     require(block.number > placeBlockNumber, 'close bet block number is too low');
295     require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, 'the block number is too low to query');
296 
297     uint result = uint(keccak256(abi.encodePacked(_reveal, blockhash(placeBlockNumber)))) % modulo;
298 
299     if (modulo <= MAX_MASKABLE_MODULO) {
300       if (2 ** result & choice != 0) {
301         winAmount = bet.winAmount;
302         player.transfer(winAmount);
303         emit LogDistributeReward(player, winAmount);
304       }
305     } else {
306       if (result < choice) {
307         winAmount = bet.winAmount;
308         player.transfer(winAmount);
309         emit LogDistributeReward(player, winAmount);
310       }
311     }
312 
313     // release winAmount deposit
314     bankFund = bankFund.sub(bet.winAmount);
315     bet.isActive = false;
316 
317     emit LogClosedBet(player, modulo, choice, _reveal, result, amount, winAmount);
318   }
319 
320   function refundBet(uint _commit) external onlyCroupier {
321     Bet storage bet = bets[_commit];
322 
323     uint amount = bet.amount;
324     uint placeBlockNumber = bet.placeBlockNumber;
325     address player = bet.player;
326 
327     require(bet.isActive, 'this bet is not active');
328     require(block.number > placeBlockNumber + BET_EXPIRATION_BLOCKS, 'this bet has not expired');
329 
330     player.transfer(amount);
331     // release winAmount deposit
332     bankFund = bankFund.sub(bet.winAmount);
333     bet.isActive = false;
334 
335     emit LogRefund(player, amount);
336   }
337 
338   /**
339    * @dev in order to let more people participant
340    */
341   function recharge() public payable {
342     emit LogRecharge(msg.sender, msg.value);
343   }
344 
345   /**
346    * @dev owner can withdraw the remain ether
347    */
348   function withdraw(uint _amount) external onlyOwner {
349     require(_amount <= address(this).balance - bankFund, 'cannot withdraw amount greater than (balance - bankFund)');
350     owner.transfer(_amount);
351     emit LogDealerWithdraw(owner, _amount);
352   }
353 
354   /**
355    * @dev get the balance which can be used
356    */
357   function getAvailableBalance() view public returns (uint) {
358     return address(this).balance - bankFund;
359   }
360 }