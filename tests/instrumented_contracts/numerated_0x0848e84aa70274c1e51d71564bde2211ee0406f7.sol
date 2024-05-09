1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) constant returns (uint256);
41     function transfer(address to, uint256 value) returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances. 
48  */
49 contract BasicToken is ERC20Basic {
50     using SafeMath for uint256;
51 
52     mapping(address => uint256) balances;
53 
54     /**
55     * @dev transfer token for a specified address
56     * @param _to The address to transfer to.
57     * @param _value The amount to be transferred.
58     */
59     function transfer(address _to, uint256 _value) returns (bool) {
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     /**
67     * @dev Gets the balance of the specified address.
68     * @param _owner The address to query the the balance of. 
69     * @return An uint256 representing the amount owned by the passed address.
70     */
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82     function allowance(address owner, address spender) constant returns (uint256);
83     function transferFrom(address from, address to, uint256 value) returns (bool);
84     function approve(address spender, uint256 value) returns (bool);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 /**
90  * @title Ownable
91  * @dev The Ownable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  */
94 contract Ownable {
95     address public owner;
96 
97     /**
98     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99     * account.
100     */
101     function Ownable() {
102         owner = msg.sender;
103     }
104 
105     /**
106     * @dev Throws if called by any account other than the owner.
107     */
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     /**
114     * @dev Allows the current owner to transfer control of the contract to a newOwner.
115     * @param newOwner The address to transfer ownership to.
116     */
117     function transferOwnership(address newOwner) onlyOwner {
118         if (newOwner != address(0)) {
119             owner = newOwner;
120         }
121     }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardMintableToken is ERC20, BasicToken, Ownable {
133 
134     mapping (address => mapping (address => uint256)) allowed;
135   
136     event Mint(address indexed to, uint256 amount);
137     event MintFinished();
138 
139     bool public mintingFinished = false;
140 
141     modifier canMint() {
142         require(!mintingFinished);
143         _;
144     }
145 
146     /**
147     * @dev Transfer tokens from one address to another
148     * @param _from address The address which you want to send tokens from
149     * @param _to address The address which you want to transfer to
150     * @param _value uint256 the amout of tokens to be transfered
151     */
152     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
153         var _allowance = allowed[_from][msg.sender];
154 
155         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
156         // require (_value <= _allowance);
157 
158         balances[_to] = balances[_to].add(_value);
159         balances[_from] = balances[_from].sub(_value);
160         allowed[_from][msg.sender] = _allowance.sub(_value);
161         Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
167     * @param _spender The address which will spend the funds.
168     * @param _value The amount of tokens to be spent.
169     */
170     function approve(address _spender, uint256 _value) returns (bool) {
171 
172     // To change the approve amount you first have to reduce the addresses`
173     //  allowance to zero by calling `approve(_spender, 0)` if it is not
174     //  already 0 to mitigate the race condition described here:
175     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
177 
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184     * @dev Function to check the amount of tokens that an owner allowed to a spender.
185     * @param _owner address The address which owns the funds.
186     * @param _spender address The address which will spend the funds.
187     * @return A uint256 specifing the amount of tokens still avaible for the spender.
188     */
189     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
190         return allowed[_owner][_spender];
191     }
192   
193    /**
194    * @dev Function to mint tokens
195    * @param _to The address that will receive the minted tokens.
196    * @param _amount The amount of tokens to mint.
197    * @return A boolean that indicates if the operation was successful.
198    */
199     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
200         totalSupply = totalSupply.add(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         Mint(_to, _amount);
203         Transfer(0x0, _to, _amount); // so it is displayed properly on EtherScan
204         return true;
205     }
206     
207     /**
208     * @dev Function to stop minting new tokens.
209     * @return True if the operation was successful.
210     */
211     function finishMinting() onlyOwner returns (bool) {
212         mintingFinished = true;
213         MintFinished();
214         return true;
215     }
216 
217 }
218 
219 /**
220  * @title Slot Ticket
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225  
226 contract SlotTicket is StandardMintableToken {
227 
228     string public name = "Slot Ticket";
229     uint8 public decimals = 0;
230     string public symbol = "TICKET";
231     string public version = "0.6";
232 
233     function destroy() onlyOwner {
234         // Transfer Eth to owner and terminate contract
235         selfdestruct(owner);
236     }
237 }
238 
239 /**  
240  *  @title Slot
241  *  @dev every participant has an account index, the winners are picked from here
242  *  all winners are picked in order from the single random int 
243  *  needs to be cleared after every game 
244  */
245      
246 contract Slot is Ownable {
247     using SafeMath for uint256;
248 
249     uint8   constant public SIZE =           100;        // size of the lottery
250     uint32  constant public JACKPOT_CHANCE = 1000000;    // one in a million
251     uint32  constant public INACTIVITY =     160000;     // blocks after which refunds can be claimed
252     uint256 constant public PRICE =          100 finney;
253     uint256 constant public JACK_DIST =      249 finney;
254     uint256 constant public DIV_DIST =       249 finney;
255     uint256 constant public GAS_REFUND =     2 finney;
256 
257     /* 
258     *  every participant has an account index, the winners are picked from here
259     *  all winners are picked in order from the single random int 
260     *  needs to be cleared after every game
261     */
262     mapping (uint => mapping (uint => address)) public participants; // game number => counter => address
263     SlotTicket public ticket; // this is a receipt for the ticket, it wont affect the prize distribution
264     uint256 public jackpotAmount;
265     uint256 public gameNumber;
266     uint256 public gameStartedAt;
267     address public fund; // address to send dividends
268     uint256[8] public prizes = [4 ether, 
269                                 2 ether,
270                                 1 ether, 
271                                 500 finney, 
272                                 500 finney, 
273                                 500 finney, 
274                                 500 finney, 
275                                 500 finney];
276     uint256 counter;
277 
278     event ParticipantAdded(address indexed _participant, uint256 indexed _game, uint256 indexed _number);
279     event PrizeAwarded(uint256 indexed _game , address indexed _winner, uint256 indexed _amount);
280     event JackpotAwarded(uint256 indexed _game, address indexed _winner, uint256 indexed _amount);
281     event GameRefunded(uint256 _game);
282 
283     function Slot(address _fundAddress) payable { // address _ticketAddress
284         // ticket = SlotTicket(_ticketAddress); // still need to change owner
285         ticket = new SlotTicket();
286         fund = _fundAddress;
287 
288         jackpotAmount = msg.value;
289         gameNumber = 0;
290         counter = 0;
291         gameStartedAt = block.number;
292     }
293 
294     function() payable {
295         // fallback function to buy tickets
296         buyTicketsFor(msg.sender);
297     }
298 
299     function buyTicketsFor(address _beneficiary) public payable {
300         require(_beneficiary != 0x0);
301         require(msg.value >= PRICE);
302 
303         // calculate number of tickets, issue tokens and add participant
304         // every (PRICE) buys a ticket, the rest is returned
305         uint256 change = msg.value%PRICE;
306         uint256 numberOfTickets = msg.value.sub(change).div(PRICE);
307         ticket.mint(_beneficiary, numberOfTickets);
308         addParticipant(_beneficiary, numberOfTickets);
309 
310         // Return change to msg.sender
311         msg.sender.transfer(change);
312     }
313 
314     /* private functions */
315 
316     function addParticipant(address _participant, uint256 _numberOfTickets) private {
317         // if number of tickets exceeds the size of the game, tickets are added to next game
318 
319         for (uint256 i = 0; i < _numberOfTickets; i++) {
320             // using gameNumber instead of counter/SIZE since games can be cancelled
321             participants[gameNumber][counter%SIZE] = _participant; 
322             ParticipantAdded(_participant, gameNumber, counter%SIZE);
323 
324             // msg.sender triggers the drawing of lots
325             if (++counter%SIZE == 0) {
326                 awardPrizes();
327                 // Split the rest, increase game number
328                 distributeRemaining();
329                 increaseGame();
330             }
331             // loop continues if there are more tickets
332         }
333     }
334     
335     function awardPrizes() private {
336         // get the winning number, no need to hash, since it is a deterministical function anyway
337         uint256 winnerIndex = uint256(block.blockhash(block.number-1))%SIZE;
338 
339         // get jackpot winner, hash result of last two digit number (index) with 4 preceding zeroes will win
340         uint256 jackpotNumber = uint256(block.blockhash(block.number-1))%JACKPOT_CHANCE;
341         if (winnerIndex == jackpotNumber) {
342             distributeJackpot(winnerIndex);
343         }
344 
345         // loop throught the prizes 
346         for (uint8 i = 0; i < prizes.length; i++) {
347             // GAS: 21000 Paid for every transaction. (prizes.length)
348             participants[gameNumber][winnerIndex%SIZE].transfer(prizes[i]); // msg.sender pays the gas, he's refunded later, % to wrap around
349             PrizeAwarded(gameNumber, participants[gameNumber][winnerIndex%SIZE], prizes[i]);
350 
351             // increment index to the next winner to receive the next prize
352             winnerIndex++;
353         }
354     }
355 
356     function distributeJackpot(uint256 _winnerIndex) private {
357         uint256 amount = jackpotAmount;
358         jackpotAmount = 0; // later on in the code sequence funds will be added
359 
360         participants[gameNumber][_winnerIndex].transfer(amount);
361         JackpotAwarded(gameNumber,  participants[gameNumber][_winnerIndex], amount);
362     }
363 
364     function distributeRemaining() private {
365         // GAS: 21000 Paid for every transaction. (3)
366         jackpotAmount = jackpotAmount.add(JACK_DIST);   // add to jackpot
367         fund.transfer(DIV_DIST);                        // *cash register sound* dividends are paid to SLOT token owners
368         msg.sender.transfer(GAS_REFUND);                // repay gas to msg.sender
369     }
370 
371     function increaseGame() private {
372         gameNumber++;
373         gameStartedAt = block.number;
374     }
375 
376     // public functions
377 
378     function spotsLeft() public constant returns (uint8 spots) {
379         return SIZE - uint8(counter%SIZE);
380     }
381 
382     function refundGameAfterLongInactivity() public {
383         require(block.number.sub(gameStartedAt) >= INACTIVITY);
384         require(counter%SIZE != 0); // nothing to refund
385         // refunds for everybody can be requested after the game has gone (INACTIVITY) blocks without a conclusion
386         
387         // Checks-Effects-Interactions pattern to avoid re-entrancy
388         uint256 _size = counter%SIZE; // not counter.size, but modulus of SIZE
389         counter -= _size;
390 
391         for (uint8 i = 0; i < _size; i++) {
392             // GAS: default 21000 paid for every transaction.
393             participants[gameNumber][i].transfer(PRICE);
394         }
395 
396         GameRefunded(gameNumber);
397         increaseGame();
398     }
399 
400     function destroy() public onlyOwner {
401         require(jackpotAmount < 25 ether);
402 
403         // Transfer Ether funds to owner and terminate contract
404         // It would be unfair to allow ourselves to destroy a contract with more than 25 ether and claim the jackpot,
405         // lower than that we would consider it still a beta (any Ether would be transfered to the newer contract)
406 
407         ticket.destroy();
408         selfdestruct(owner);
409     }
410     
411     function changeTicketOwner(address _newOwner) public onlyOwner {
412         // in case of new contract, old token can still be used
413         // the token contract owner is the slot contract itself
414         ticket.transferOwnership(_newOwner);
415     }
416     
417     function changeFund(address _newFund) public onlyOwner {
418         fund = _newFund;
419     }
420     
421     function changeTicket(address _newTicket) public onlyOwner {
422         ticket = SlotTicket(_newTicket); // still need to change owner to work
423     }
424 }