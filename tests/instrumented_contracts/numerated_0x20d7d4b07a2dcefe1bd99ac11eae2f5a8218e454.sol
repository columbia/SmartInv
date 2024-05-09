1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value) returns (bool);
85   function approve(address spender, uint256 value) returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157   /**
158    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
159    * account.
160    */
161   function Ownable() {
162     owner = msg.sender;
163   }
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address newOwner) onlyOwner {
178     if (newOwner != address(0)) {
179       owner = newOwner;
180     }
181   }
182 
183 }
184 
185 /**
186  * @title Pausable
187  * @dev Base contract which allows children to implement an emergency stop mechanism.
188  */
189 contract Pausable is Ownable {
190   event Pause();
191   event Unpause();
192 
193   bool public paused = false;
194 
195   /**
196    * @dev modifier to allow actions only when the contract IS paused
197    */
198   modifier whenNotPaused() {
199     require(!paused);
200     _;
201   }
202 
203   /**
204    * @dev modifier to allow actions only when the contract IS NOT paused
205    */
206   modifier whenPaused {
207     require(paused);
208     _;
209   }
210 
211   /**
212    * @dev called by the owner to pause, triggers stopped state
213    */
214   function pause() onlyOwner whenNotPaused returns (bool) {
215     paused = true;
216     Pause();
217     return true;
218   }
219 
220   /**
221    * @dev called by the owner to unpause, returns to normal state
222    */
223   function unpause() onlyOwner whenPaused returns (bool) {
224     paused = false;
225     Unpause();
226     return true;
227   }
228 }
229 
230 /**
231  * @title Slot Ticket token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236  
237 contract SlotTicket is StandardToken, Ownable {
238 
239   string public name = "Slot Ticket";
240   uint8 public decimals = 0;
241   string public symbol = "SLOT";
242   string public version = "0.1";
243 
244   event Mint(address indexed to, uint256 amount);
245 
246   function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
247     totalSupply = totalSupply.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     Mint(_to, _amount);
250     Transfer(0x0, _to, _amount); // so it is displayed properly on EtherScan
251     return true;
252   }
253 
254 function destroy() onlyOwner {
255     // Transfer Eth to owner and terminate contract
256     selfdestruct(owner);
257   }
258 
259 }
260 
261 contract Slot is Ownable, Pausable { // TODO: for production disable tokenDestructible
262     using SafeMath for uint256;
263 
264     // this token is just a gimmick to receive when buying a ticket, it wont affect the prize
265     SlotTicket public token;
266 
267     // every participant has an account index, the winners are picked from here
268     // all winners are picked in order from the single random int 
269     // needs to be cleared after every game
270     mapping (uint => address) participants;
271     uint256[] prizes = [4 ether, 
272                         2 ether,
273                         1 ether, 
274                         500 finney, 
275                         500 finney, 
276                         500 finney, 
277                         500 finney, 
278                         500 finney];
279     uint8 counter = 0;
280 
281     uint8   constant SIZE = 100; // size of the lottery
282     uint32  constant JACKPOT_SIZE = 1000000; // one in a million
283     uint256 constant PRICE = 100 finney;
284     
285     uint256 jackpot = 0;
286     uint256 gameNumber = 0;
287     address wallet;
288 
289     event PrizeAwarded(uint256 game, address winner, uint256 amount);
290     event JackpotAwarded(uint256 game, address winner, uint256 amount);
291 
292     function Slot(address _wallet) {
293         token = new SlotTicket();
294         wallet = _wallet;
295     }
296 
297     function() payable {
298         // fallback function to buy tickets from
299         buyTicketsFor(msg.sender);
300     }
301 
302     function buyTicketsFor(address beneficiary) whenNotPaused() payable {
303         require(beneficiary != 0x0);
304         require(msg.value >= PRICE);
305         require(msg.value/PRICE <= 255); // maximum of 255 tickets, to avoid overflow on uint8
306         // I can't see somebody sending more than the size of the lottery, other than to try to win the jackpot
307         
308         // calculate number of tickets, issue tokens and add participants
309         // every 100 finney buys a ticket, the rest is returned
310         uint8 numberOfTickets = uint8(msg.value/PRICE); 
311         token.mint(beneficiary, numberOfTickets);
312         addParticipant(beneficiary, numberOfTickets);
313 
314         // Return change to msg.sender
315         // TODO: check if change amount correct
316         msg.sender.transfer(msg.value%PRICE);
317 
318     }
319 
320     function addParticipant(address _participant, uint8 _numberOfTickets) private {
321         // TODO: check access of this function, it shouldn't be tampered with
322         // add participants and increment count
323         // should gracefully handle multiple tickets accross games
324 
325         for (uint8 i = 0; i < _numberOfTickets; i++) {
326             participants[counter] = _participant;
327 
328             // msg.sender triggers the drawing of lots
329             if (counter % (SIZE-1) == 0) { 
330                 // takes the participant's address as the seed
331                 awardPrizes(uint256(_participant)); 
332             } 
333             
334             counter++;
335 
336             // loop continues if there are more tickets
337         }
338         
339     }
340     
341     function rand(uint32 _size, uint256 _seed) constant private returns (uint32 randomNumber) {
342       // Providing random numbers within a deterministic system is, naturally, an impossible task.
343       // However, we can approximate with pseudo-random numbers by utilising data which is generally unknowable
344       // at the time of transacting. Such data might include the block’s hash.
345 
346         return uint32(sha3(block.blockhash(block.number-1), _seed))%_size;
347     }
348 
349     function awardPrizes(uint256 _seed) private {
350         uint32 winningNumber = rand(SIZE-1, _seed); // -1 since index starts at 0
351         bool jackpotWon = winningNumber == rand(JACKPOT_SIZE-1, _seed); // -1 since index starts at 0
352 
353         // scope of participants
354         uint256 start = gameNumber.mul(SIZE);
355         uint256 end = start + SIZE;
356 
357         uint256 winnerIndex = start.add(winningNumber);
358 
359         for (uint8 i = 0; i < prizes.length; i++) {
360             
361             if (jackpotWon && i==0) { distributeJackpot(winnerIndex); }
362 
363             if (winnerIndex+i > end) {
364               // to keep within the bounds of participants, wrap around
365                 winnerIndex -= SIZE;
366             }
367 
368             participants[winnerIndex+i].transfer(prizes[i]); // msg.sender pays the gas, he's refunded later
369             
370             PrizeAwarded(gameNumber,  participants[winnerIndex+i], prizes[i]);
371         }
372         
373         // Split the rest
374         jackpot = jackpot.add(245 finney);  // add to jackpot
375         wallet.transfer(245 finney);        // *cash register sound*
376         msg.sender.transfer(10 finney);     // repay gas to msg.sender TODO: check if price is right
377 
378         gameNumber++;
379     }
380 
381     function distributeJackpot(uint256 _winnerIndex) {
382         participants[_winnerIndex].transfer(jackpot);
383         JackpotAwarded(gameNumber,  participants[_winnerIndex], jackpot);
384         jackpot = 0; // later on in the code money will be added
385     }
386 
387     function destroy() onlyOwner {
388         // Transfer Eth to owner and terminate contract
389         token.destroy();
390         selfdestruct(owner);
391   }
392 
393     function changeWallet(address _newWallet) onlyOwner {
394         require(_newWallet != 0x0);
395         wallet = _newWallet;
396   }
397 
398 }