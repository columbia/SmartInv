1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ECRecovery.sol
4 
5 /**
6  * @title Eliptic curve signature operations
7  *
8  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
9  *
10  * TODO Remove this library once solidity supports passing a signature to ecrecover.
11  * See https://github.com/ethereum/solidity/issues/864
12  *
13  */
14 
15 library ECRecovery {
16 
17   /**
18    * @dev Recover signer address from a message by using their signature
19    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
20    * @param sig bytes signature, the signature is generated using web3.eth.sign()
21    */
22   function recover(bytes32 hash, bytes sig)
23     internal
24     pure
25     returns (address)
26   {
27     bytes32 r;
28     bytes32 s;
29     uint8 v;
30 
31     // Check the signature length
32     if (sig.length != 65) {
33       return (address(0));
34     }
35 
36     // Divide the signature in r, s and v variables
37     // ecrecover takes the signature parameters, and the only way to get them
38     // currently is to use assembly.
39     // solium-disable-next-line security/no-inline-assembly
40     assembly {
41       r := mload(add(sig, 32))
42       s := mload(add(sig, 64))
43       v := byte(0, mload(add(sig, 96)))
44     }
45 
46     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
47     if (v < 27) {
48       v += 27;
49     }
50 
51     // If the version is correct return the signer address
52     if (v != 27 && v != 28) {
53       return (address(0));
54     } else {
55       // solium-disable-next-line arg-overflow
56       return ecrecover(hash, v, r, s);
57     }
58   }
59 
60   /**
61    * toEthSignedMessageHash
62    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
63    * @dev and hash the result
64    */
65   function toEthSignedMessageHash(bytes32 hash)
66     internal
67     pure
68     returns (bytes32)
69   {
70     // 32 is the length in bytes of hash,
71     // enforced by the type signature above
72     return keccak256(
73       "\x19Ethereum Signed Message:\n32",
74       hash
75     );
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers, truncating the quotient.
105   */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     // uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return a / b;
111   }
112 
113   /**
114   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115   */
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   /**
122   * @dev Adds two numbers, throws on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }
130 
131 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
132 
133 /**
134  * @title Ownable
135  * @dev The Ownable contract has an owner address, and provides basic authorization control
136  * functions, this simplifies the implementation of "user permissions".
137  */
138 contract Ownable {
139   address public owner;
140 
141 
142   event OwnershipRenounced(address indexed previousOwner);
143   event OwnershipTransferred(
144     address indexed previousOwner,
145     address indexed newOwner
146   );
147 
148 
149   /**
150    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
151    * account.
152    */
153   constructor() public {
154     owner = msg.sender;
155   }
156 
157   /**
158    * @dev Throws if called by any account other than the owner.
159    */
160   modifier onlyOwner() {
161     require(msg.sender == owner);
162     _;
163   }
164 
165   /**
166    * @dev Allows the current owner to relinquish control of the contract.
167    */
168   function renounceOwnership() public onlyOwner {
169     emit OwnershipRenounced(owner);
170     owner = address(0);
171   }
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param _newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address _newOwner) public onlyOwner {
178     _transferOwnership(_newOwner);
179   }
180 
181   /**
182    * @dev Transfers control of the contract to a newOwner.
183    * @param _newOwner The address to transfer ownership to.
184    */
185   function _transferOwnership(address _newOwner) internal {
186     require(_newOwner != address(0));
187     emit OwnershipTransferred(owner, _newOwner);
188     owner = _newOwner;
189   }
190 }
191 
192 // File: contracts/LuckySeven.sol
193 
194 contract LuckySeven is Ownable {
195 
196   using SafeMath for uint256;
197 
198   uint256 public minBet;
199   uint256 public maxBet;
200   bool public paused;
201   address public signer;
202   address public house;
203 
204   mapping (address => uint256) public balances;
205   mapping (address => bool) public diceRolled;
206   mapping (address => bytes) public betSignature;
207   mapping (address => uint256) public betAmount;
208   mapping (address => uint256) public betValue;
209   mapping (bytes => bool) usedSignatures;
210 
211   mapping (address => uint256) public totalDiceRollsByAddress;
212   mapping (address => uint256) public totalBetsByAddress;
213   mapping (address => uint256) public totalBetsWonByAddress;
214   mapping (address => uint256) public totalBetsLostByAddress;
215 
216   uint256 public pendingBetsBalance;
217   uint256 public belowSevenBets;
218   uint256 public aboveSevenBets;
219   uint256 public luckySevenBets;
220 
221   uint256 public betsWon;
222   uint256 public betsLost;
223 
224   event Event (
225       string name,
226       address indexed _better,
227       uint256 num1,
228       uint256 num2
229   );
230 
231   constructor(uint256 _minBet, uint256 _maxBet, address _signer, address _house) public {
232     minBet = _minBet;
233     maxBet = _maxBet;
234     signer = _signer;
235     house = _house;
236   }
237 
238   function setSigner(address _signer) public onlyOwner {
239     signer = _signer;
240   }
241 
242   function setHouse(address _house) public onlyOwner {
243     // note previous house balance
244     uint256 existingHouseBalance = balances[house];
245 
246     // drain existing house
247     balances[house] = 0;
248 
249     // update house
250     house = _house;
251 
252     // update balance for new house
253     balances[house] = balances[house].add(existingHouseBalance);
254   }
255 
256   function setMinBet(uint256 _minBet) public onlyOwner {
257     minBet = _minBet;
258   }
259 
260   function setMaxBet(uint256 _maxBet) public onlyOwner {
261     maxBet = _maxBet;
262   }
263 
264   function setPaused(bool _paused) public onlyOwner {
265     paused = _paused;
266   }
267 
268   function () external payable {
269     topup();
270   }
271 
272   function topup() payable public {
273     require(msg.value > 0);
274     balances[msg.sender] = balances[msg.sender].add(msg.value);
275   }
276 
277   function withdraw(uint256 amount) public {
278     require(amount > 0);
279     require(balances[msg.sender] >= amount);
280 
281     balances[msg.sender] = balances[msg.sender].sub(amount);
282     msg.sender.transfer(amount);
283   }
284 
285   function rollDice(bytes signature) public {
286     require(!paused);
287 
288     // validate hash is not used before
289     require(!usedSignatures[signature]);
290 
291     // mark the hash as used
292     usedSignatures[signature] = true;
293 
294     // no existing bet placed
295     require(betAmount[msg.sender] == 0);
296 
297     // set dice rolled to true
298     diceRolled[msg.sender] = true;
299     betSignature[msg.sender] = signature;
300 
301     totalDiceRollsByAddress[msg.sender] = totalDiceRollsByAddress[msg.sender].add(1);
302     emit Event('dice-rolled', msg.sender, 0, 0);
303   }
304 
305   function placeBet(uint256 amount, uint256 value) public {
306     require(!paused);
307 
308     // validate inputs
309     require(amount >= minBet && amount <= maxBet);
310     require(value >= 1 && value <= 3);
311 
312     // validate dice rolled
313     require(diceRolled[msg.sender]);
314 
315     // validate no existing bet placed
316     require(betAmount[msg.sender] == 0);
317 
318     // validate user has balance to place the bet
319     require(balances[msg.sender] >= amount);
320 
321     // transfer balance to house
322     balances[msg.sender] = balances[msg.sender].sub(amount);
323     balances[house] = balances[house].add(amount);
324     pendingBetsBalance = pendingBetsBalance.add(amount);
325 
326     // store bet amount and value
327     betValue[msg.sender] = value;
328     betAmount[msg.sender] = amount;
329 
330     totalBetsByAddress[msg.sender] = totalBetsByAddress[msg.sender].add(1);
331     emit Event('bet-placed', msg.sender, amount, 0);
332   }
333 
334   function completeBet(bytes32 hash) public returns (uint256, uint256){
335     // validate there is bet placed
336     require(betAmount[msg.sender] > 0);
337 
338     // validate input hash
339     require(ECRecovery.recover(hash, betSignature[msg.sender]) == signer);
340 
341     // compute dice number and calculate amount won
342     uint256 num1 = (
343       uint256(
344         ECRecovery.toEthSignedMessageHash(
345           keccak256(
346             abi.encodePacked(hash)
347           )
348         )
349       ) % 6
350     ) + 1;
351 
352     uint256 num2 = (
353       uint256(
354         ECRecovery.toEthSignedMessageHash(
355           sha256(
356             abi.encodePacked(hash)
357           )
358         )
359       ) % 6
360     ) + 1;
361     uint256 num = num1 + num2;
362     uint256 value = betValue[msg.sender];
363     uint256 winRate = 0;
364     if (num <= 6) {
365       belowSevenBets = belowSevenBets.add(1);
366       if (value == 1) {
367         winRate = 2;
368       }
369     } else if (num == 7) {
370       luckySevenBets = luckySevenBets.add(1);
371       if (value == 2) {
372         winRate = 3;
373       }
374     } else {
375       aboveSevenBets = aboveSevenBets.add(1);
376       if (value == 3) {
377         winRate = 2;
378       }
379     }
380 
381     uint256 amountWon = betAmount[msg.sender] * winRate;
382 
383     // transfer balance from house
384     if (amountWon > 0) {
385       balances[house] = balances[house].sub(amountWon);
386       balances[msg.sender] = balances[msg.sender].add(amountWon);
387       totalBetsWonByAddress[msg.sender] = totalBetsWonByAddress[msg.sender].add(1);
388       betsWon = betsWon.add(1);
389       emit Event('bet-won', msg.sender, amountWon, num);
390     } else {
391       totalBetsLostByAddress[msg.sender] = totalBetsLostByAddress[msg.sender].add(1);
392       betsLost = betsLost.add(1);
393       emit Event('bet-lost', msg.sender, betAmount[msg.sender], num);
394     }
395     pendingBetsBalance = pendingBetsBalance.sub(betAmount[msg.sender]);
396 
397     // reset diceRolled and amount
398     diceRolled[msg.sender] = false;
399     betAmount[msg.sender] = 0;
400     betValue[msg.sender] = 0;
401     betSignature[msg.sender] = '0x';
402 
403     return (amountWon, num);
404   }
405 }