1 // produced by the Solididy File Flattener (c) David Appleton 2018
2 // contact : dave@akomba.com
3 // released under Apache 2.0 licence
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipRenounced(address indexed previousOwner);
9   event OwnershipTransferred(
10     address indexed previousOwner,
11     address indexed newOwner
12   );
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to relinquish control of the contract.
33    */
34   function renounceOwnership() public onlyOwner {
35     emit OwnershipRenounced(owner);
36     owner = address(0);
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param _newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address _newOwner) public onlyOwner {
44     _transferOwnership(_newOwner);
45   }
46 
47   /**
48    * @dev Transfers control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function _transferOwnership(address _newOwner) internal {
52     require(_newOwner != address(0));
53     emit OwnershipTransferred(owner, _newOwner);
54     owner = _newOwner;
55   }
56 }
57 
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
65     // benefit is lost if 'b' is also tested.
66     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67     if (a == 0) {
68       return 0;
69     }
70 
71     c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     // uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return a / b;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 contract EthBattle is Ownable {
105     using SafeMath for uint256;
106 
107     uint256 constant TOKEN_USE_BONUS = 15; //%, adds weight of win on top of the market price
108     uint256 constant REFERRAL_REWARD = 2 ether; // GTA, 10*19
109     uint256 constant MIN_PLAY_AMOUNT = 50 finney; //wei, equal 0.05 ETH
110 
111     uint256 public roundIndex = 0;
112     mapping(uint256 => address) public rounds;
113 
114     address[] private currentRewardingAddresses;
115 
116     PlaySeedInterface private playSeedGenerator;
117     GTAInterface public token;
118     AMUStoreInterface public store;
119 
120     mapping(address => address) public referralBacklog; //backlog of players and their referrals
121 
122     mapping(address => uint256) public tokens; //map of deposited tokens
123 
124     event RoundCreated(address createdAddress, uint256 index);
125     event Deposit(address user, uint amount, uint balance);
126     event Withdraw(address user, uint amount, uint balance);
127 
128     /**
129     * @dev Default fallback function, just deposits funds to the pot
130     */
131     function () public payable {
132         getLastRound().getDevWallet().transfer(msg.value);
133     }
134 
135     /**
136     * @dev The EthBattle constructor
137     * @param _playSeedAddress address of the play seed generator
138     * @param _tokenAddress GTA address
139     * @param _storeAddress store contract address
140     */
141     constructor (address _playSeedAddress, address _tokenAddress, address _storeAddress) public {
142         playSeedGenerator = PlaySeedInterface(_playSeedAddress);
143         token = GTAInterface(_tokenAddress);
144         store = AMUStoreInterface(_storeAddress);
145     }
146 
147     /**
148     * @dev Try (must be allowed by the seed generator itself) to claim ownership of the seed generator
149     */
150     function claimSeedOwnership() onlyOwner public {
151         playSeedGenerator.claimOwnership();
152     }
153 
154     /**
155     * @dev Inject the new round contract, and sets the round with a new index
156     * NOTE! Injected round must have had transferred ownership to this EthBattle already
157     * @param _roundAddress address of the new round to use
158     */
159     function startRound(address _roundAddress) onlyOwner public {
160         RoundInterface round = RoundInterface(_roundAddress);
161 
162         round.claimOwnership();
163 
164         roundIndex++;
165         rounds[roundIndex] = round;
166         emit RoundCreated(round, roundIndex);
167     }
168 
169 
170     /**
171     * @dev Interrupts the round to enable participants to claim funds back
172     */
173     function interruptLastRound() onlyOwner public {
174         getLastRound().enableRefunds();
175     }
176 
177     /**
178     * @dev End last round so no new plays is possible, but ongoing plays are fine to win
179     */
180     function finishLastRound() onlyOwner public {
181         getLastRound().coolDown();
182     }
183 
184     function getLastRound() public view returns (RoundInterface){
185         return RoundInterface(rounds[roundIndex]);
186     }
187 
188     function getLastRoundAddress() external view returns (address){
189         return rounds[roundIndex];
190     }
191 
192     /**
193     * @dev Player starts a new play providing
194     * @param _referral (Optional) referral address is any
195     * @param _gtaBet (Optional) additional bet in GTA
196     */
197     function play(address _referral, uint256 _gtaBet) public payable {
198         address player = msg.sender;
199         uint256 weiAmount = msg.value;
200 
201         require(player != address(0), "Player's address is missing");
202         require(weiAmount >= MIN_PLAY_AMOUNT, "The bet is too low");
203         require(_gtaBet <= balanceOf(player), "Player's got not enough GTA");
204 
205         if (_referral != address(0) && referralBacklog[player] == address(0)) {
206             //new referral for this player
207             referralBacklog[player] = _referral;
208             //reward the referral. Tokens remains in this contract
209             //but become available for withdrawal by _referral
210             transferInternally(owner, _referral, REFERRAL_REWARD);
211         }
212 
213         playSeedGenerator.newPlaySeed(player);
214 
215         uint256 _bet = aggregateBet(weiAmount, _gtaBet);
216 
217         if (_gtaBet > 0) {
218             //player's using GTA
219             transferInternally(player, owner, _gtaBet);
220         }
221 
222         if (referralBacklog[player] != address(0)) {
223             //ongoing round might not know about the _referral
224             //delegate the knowledge of the referral to the ongoing round
225             getLastRound().setReferral(player, referralBacklog[player]);
226         }
227         getLastRound().playRound.value(msg.value)(player, _bet);
228     }
229 
230     /**
231     * @dev Player claims a win
232     * @param _seed secret seed
233     */
234     function win(bytes32 _seed) public {
235         address player = msg.sender;
236 
237         require(player != address(0), "Winner's address is missing");
238         require(playSeedGenerator.findSeed(player) == _seed, "Wrong seed!");
239         playSeedGenerator.cleanSeedUp(player);
240 
241         getLastRound().win(player);
242     }
243 
244     function findSeedAuthorized(address player) onlyOwner public view returns (bytes32){
245         return playSeedGenerator.findSeed(player);
246     }
247 
248     function aggregateBet(uint256 _bet, uint256 _gtaBet) internal view returns (uint256) {
249         //get market price of the GTA, multiply by bet, and apply a bonus on it.
250         //since both 'price' and 'bet' are in 'wei', we need to drop 10*18 decimals at the end
251         uint256 _gtaValueWei = store.getTokenBuyPrice().mul(_gtaBet).div(1 ether).mul(100 + TOKEN_USE_BONUS).div(100);
252 
253         //sum up with ETH bet
254         uint256 _resultBet = _bet.add(_gtaValueWei);
255 
256         return _resultBet;
257     }
258 
259     /**
260     * @dev Calculates the prize amount for this player by now
261     * Note: the result is not the final one and a subject to change once more plays/wins occur
262     * @return The prize in wei
263     */
264     function prizeByNow() public view returns (uint256) {
265         return getLastRound().currentPrize(msg.sender);
266     }
267 
268     /**
269     * @dev Calculates the prediction on the prize amount for this player and this bet
270     * Note: the result is not the final one and a subject to change once more plays/wins occur
271     * @param _bet hypothetical bet in wei
272     * @param _gtaBet hypothetical bet in GTA
273     * @return The prediction in wei
274     */
275     function prizeProjection(uint256 _bet, uint256 _gtaBet) public view returns (uint256) {
276         return getLastRound().projectedPrizeForPlayer(msg.sender, aggregateBet(_bet, _gtaBet));
277     }
278 
279 
280     /**
281     * @dev Deposit GTA to the EthBattle contract so it can be spent (used) immediately
282     * Note: this call must follow the approve() call on the token itself
283     * @param _amount amount to deposit
284     */
285     function depositGTA(uint256 _amount) public {
286         require(token.transferFrom(msg.sender, this, _amount), "Insufficient funds");
287         tokens[msg.sender] = tokens[msg.sender].add(_amount);
288         emit Deposit(msg.sender, _amount, tokens[msg.sender]);
289     }
290 
291     /**
292     * @dev Withdraw GTA from this contract to the own (caller) address
293     * @param _amount amount to withdraw
294     */
295     function withdrawGTA(uint256 _amount) public {
296         require(tokens[msg.sender] >= _amount, "Amount exceeds the available balance");
297         tokens[msg.sender] = tokens[msg.sender].sub(_amount);
298         require(token.transfer(msg.sender, _amount), "Amount exceeds the available balance");
299         emit Withdraw(msg.sender, _amount, tokens[msg.sender]);
300     }
301 
302     /**
303     * @dev Internal transfer of the token.
304     * Funds remain in this contract but become available for withdrawal
305     */
306     function transferInternally(address _from, address _to, uint256 _amount) internal {
307         require(tokens[_from] >= _amount, "Too much to transfer");
308         tokens[_from] = tokens[_from].sub(_amount);
309         tokens[_to] = tokens[_to].add(_amount);
310     }
311 
312     function balanceOf(address _user) public view returns (uint256) {
313         return tokens[_user];
314     }
315 
316     function setPlaySeed(address _playSeedAddress) onlyOwner public {
317         playSeedGenerator = PlaySeedInterface(_playSeedAddress);
318     }
319 
320     function setStore(address _storeAddress) onlyOwner public {
321         store = AMUStoreInterface(_storeAddress);
322     }
323 
324     function getTokenBuyPrice() public view returns (uint256) {
325         return store.getTokenBuyPrice();
326     }
327 
328     function getTokenSellPrice() public view returns (uint256) {
329         return store.getTokenSellPrice();
330     }
331 
332     /**
333     * @dev Recover the history of referrals in case of the contract migration.
334     */
335     function setReferralsMap(address[] _players, address[] _referrals) onlyOwner public {
336         require(_players.length == _referrals.length, "Size of players must be equal to the size of referrals");
337         for (uint i = 0; i < _players.length; ++i) {
338             referralBacklog[_players[i]] = _referrals[i];
339         }
340     }
341 
342 }
343 
344 /**
345  * @title PlaySeed contract interface
346  */
347 interface PlaySeedInterface {
348 
349     function newPlaySeed(address _player) external;
350 
351     function findSeed(address _player) external view returns (bytes32);
352 
353     function cleanSeedUp(address _player) external;
354 
355     function claimOwnership() external;
356 
357 }
358 
359 /**
360  * @title GTA contract interface
361  */
362 interface GTAInterface {
363 
364     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
365 
366     function transfer(address to, uint256 value) external returns (bool);
367 
368 }
369 
370 /**
371  * @title EthBattleRound contract interface
372  */
373 interface RoundInterface {
374 
375     function claimOwnership() external;
376 
377     function setReferral(address _player, address _referral) external;
378 
379     function playRound(address _player, uint256 _bet) external payable;
380 
381     function enableRefunds() external;
382 
383     function coolDown() external;
384 
385     function currentPrize(address _player) external view returns (uint256);
386 
387     function projectedPrizeForPlayer(address _player, uint256 _bet) external view returns (uint256);
388 
389     function win(address _player) external;
390 
391     function getDevWallet() external view returns (address);
392 
393 }
394 
395 /**
396  * @title Ammu-Nation contract interface
397  */
398 interface AMUStoreInterface {
399 
400     function getTokenBuyPrice() external view returns (uint256);
401 
402     function getTokenSellPrice() external view returns (uint256);
403 
404 }