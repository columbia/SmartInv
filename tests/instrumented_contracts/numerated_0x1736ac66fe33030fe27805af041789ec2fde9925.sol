1 // produced by the Solididy File Flattener (c) David Appleton 2018
2 // contact : dave@akomba.com
3 // released under Apache 2.0 licence
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
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
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipRenounced(address indexed previousOwner);
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to relinquish control of the contract.
79    */
80   function renounceOwnership() public onlyOwner {
81     emit OwnershipRenounced(owner);
82     owner = address(0);
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address _newOwner) public onlyOwner {
90     _transferOwnership(_newOwner);
91   }
92 
93   /**
94    * @dev Transfers control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function _transferOwnership(address _newOwner) internal {
98     require(_newOwner != address(0));
99     emit OwnershipTransferred(owner, _newOwner);
100     owner = _newOwner;
101   }
102 }
103 
104 contract EthBattle is Ownable {
105     using SafeMath for uint256;
106 
107     uint256 constant TOKEN_USE_BONUS = 15; //%, adds weight of win on top of the market price
108     uint256 constant REFERRAL_REWARD = 2 ether; // GTA, 10*19
109     uint256 public MIN_PLAY_AMOUNT = 50 finney; //wei, equal 0.05 ETH
110 
111     uint256 public META_BET_WEIGHT = 10 finney; //wei, equal to 0.01 ETH
112 
113     uint256 public roundIndex = 0;
114     mapping(uint256 => address) public rounds;
115 
116     address[] private currentRewardingAddresses;
117 
118     PlaySeedInterface private playSeedGenerator;
119     GTAInterface public token;
120     AMUStoreInterface public store;
121 
122     address public startersProxyAddress;
123 
124     mapping(address => address) public referralBacklog; //backlog of players and their referrals
125 
126     mapping(address => uint256) public tokens; //map of deposited tokens
127 
128     event RoundCreated(address createdAddress, uint256 index);
129     event Deposit(address user, uint amount, uint balance);
130     event Withdraw(address user, uint amount, uint balance);
131 
132     /**
133     * @dev Default fallback function, just deposits funds to the pot
134     */
135     function () public payable {
136         getLastRound().getDevWallet().transfer(msg.value);
137     }
138 
139     /**
140     * @dev The EthBattle constructor
141     * @param _playSeedAddress address of the play seed generator
142     * @param _tokenAddress GTA address
143     * @param _storeAddress store contract address
144     */
145     constructor (address _playSeedAddress, address _tokenAddress, address _storeAddress, address _proxyAddress) public {
146         playSeedGenerator = PlaySeedInterface(_playSeedAddress);
147         token = GTAInterface(_tokenAddress);
148         store = AMUStoreInterface(_storeAddress);
149         startersProxyAddress = _proxyAddress;
150     }
151 
152     modifier onlyProxy() {
153         require(msg.sender == startersProxyAddress);
154         _;
155     }
156 
157     /**
158     * @dev Try (must be allowed by the seed generator itself) to claim ownership of the seed generator
159     */
160     function claimSeedOwnership() onlyOwner public {
161         playSeedGenerator.claimOwnership();
162     }
163 
164     /**
165     * @dev Inject the new round contract, and sets the round with a new index
166     * NOTE! Injected round must have had transferred ownership to this EthBattle already
167     * @param _roundAddress address of the new round to use
168     */
169     function startRound(address _roundAddress) onlyOwner public {
170         RoundInterface round = RoundInterface(_roundAddress);
171 
172         round.claimOwnership();
173 
174         roundIndex++;
175         rounds[roundIndex] = round;
176         emit RoundCreated(round, roundIndex);
177     }
178 
179     /**
180     * @dev Player starts a new play providing
181     * @param _referral (Optional) referral address is any
182     * @param _gtaBet (Optional) additional bet in GTA
183     */
184     function play(address _referral, uint256 _gtaBet) public payable {
185         address player = msg.sender;
186         uint256 weiAmount = msg.value;
187 
188         require(player != address(0), "Player's address is missing");
189         require(weiAmount >= MIN_PLAY_AMOUNT, "The bet is too low");
190         require(_gtaBet <= balanceOf(player), "Player's got not enough GTA");
191 
192         uint256 _bet = aggregateBet(weiAmount, _gtaBet);
193 
194         playInternal(player, weiAmount, _bet, _referral, _gtaBet);
195     }
196 
197     /**
198     * @dev Etherless player starts a new play, when actually the gas fee is payed
199     * by the sender and the bet is set by the proxy
200     * @param _player The actual player
201     * @param _referral (Optional) referral address is any
202     * @param _gtaBet (Optional) additional bet in GTA
203     */
204     function playMeta(address _player, address _referral, uint256 _gtaBet) onlyProxy public payable {
205         uint256 weiAmount = msg.value;
206 
207         require(_player != address(0), "Player's address is missing");
208         require(_gtaBet <= balanceOf(_player), "Player's got not enough GTA");
209 
210         //Important! For meta plays the 'weight' is not connected the the actual bet (since the bet comes from proxy)
211         //but static and equals META_BET_WEIGHT
212         uint256 _bet = aggregateBet(META_BET_WEIGHT, _gtaBet);
213 
214         playInternal(_player, weiAmount, _bet, _referral, _gtaBet);
215     }
216 
217     function playInternal(address _player, uint256 _weiBet, uint256 _betWeight, address _referral, uint256 _gtaBet) internal {
218         if (_referral != address(0) && referralBacklog[_player] == address(0)) {
219             //new referral for this _player
220             referralBacklog[_player] = _referral;
221             //reward the referral. Tokens remains in this contract
222             //but become available for withdrawal by _referral
223             transferInternally(owner, _referral, REFERRAL_REWARD);
224         }
225 
226         playSeedGenerator.newPlaySeed(_player);
227 
228         if (_gtaBet > 0) {
229             //player's using GTA
230             transferInternally(_player, owner, _gtaBet);
231         }
232 
233         if (referralBacklog[_player] != address(0)) {
234             //ongoing round might not know about the _referral
235             //delegate the knowledge of the referral to the ongoing round
236             getLastRound().setReferral(_player, referralBacklog[_player]);
237         }
238         getLastRound().playRound.value(_weiBet)(_player, _betWeight);
239     }
240 
241     /**
242     * @dev Player claims a win
243     * @param _seed secret seed
244     */
245     function win(bytes32 _seed) public {
246         address player = msg.sender;
247         winInternal(player, _seed);
248     }
249 
250     /**
251     * @dev Player claims a win
252     * @param _player etherless player claims
253     * @param _seed secret seed
254     */
255     function winMeta(address _player, bytes32 _seed) onlyProxy public {
256         winInternal(_player, _seed);
257     }
258 
259     function winInternal(address _player, bytes32 _seed) internal {
260         require(_player != address(0), "Winner's address is missing");
261         require(playSeedGenerator.findSeed(_player) == _seed, "Wrong seed!");
262         playSeedGenerator.cleanSeedUp(_player);
263 
264         getLastRound().win(_player);
265     }
266 
267     function findSeedAuthorized(address player) onlyOwner public view returns (bytes32){
268         return playSeedGenerator.findSeed(player);
269     }
270 
271     function aggregateBet(uint256 _bet, uint256 _gtaBet) internal view returns (uint256) {
272         //get market price of the GTA, multiply by bet, and apply a bonus on it.
273         //since both 'price' and 'bet' are in 'wei', we need to drop 10*18 decimals at the end
274         uint256 _gtaValueWei = store.getTokenBuyPrice().mul(_gtaBet).div(1 ether).mul(100 + TOKEN_USE_BONUS).div(100);
275 
276         //sum up with ETH bet
277         uint256 _resultBet = _bet.add(_gtaValueWei);
278 
279         return _resultBet;
280     }
281 
282     /**
283     * @dev Calculates the prize amount for this player by now
284     * Note: the result is not the final one and a subject to change once more plays/wins occur
285     * @return The prize in wei
286     */
287     function prizeByNow() public view returns (uint256) {
288         return getLastRound().currentPrize(msg.sender);
289     }
290 
291     /**
292     * @dev Calculates the prediction on the prize amount for this player and this bet
293     * Note: the result is not the final one and a subject to change once more plays/wins occur
294     * @param _bet hypothetical bet in wei
295     * @param _gtaBet hypothetical bet in GTA
296     * @return The prediction in wei
297     */
298     function prizeProjection(uint256 _bet, uint256 _gtaBet) public view returns (uint256) {
299         return getLastRound().projectedPrizeForPlayer(msg.sender, aggregateBet(_bet, _gtaBet));
300     }
301 
302 
303     /**
304     * @dev Deposit GTA to the EthBattle contract so it can be spent (used) immediately
305     * Note: this call must follow the approve() call on the token itself
306     * @param _amount amount to deposit
307     */
308     function depositGTA(uint256 _amount) public {
309         require(token.transferFrom(msg.sender, this, _amount), "Insufficient funds");
310         tokens[msg.sender] = tokens[msg.sender].add(_amount);
311         emit Deposit(msg.sender, _amount, tokens[msg.sender]);
312     }
313 
314     /**
315     * @dev Withdraw GTA from this contract to the own (caller) address
316     * @param _amount amount to withdraw
317     */
318     function withdrawGTA(uint256 _amount) public {
319         require(tokens[msg.sender] >= _amount, "Amount exceeds the available balance");
320         tokens[msg.sender] = tokens[msg.sender].sub(_amount);
321         require(token.transfer(msg.sender, _amount), "Amount exceeds the available balance");
322         emit Withdraw(msg.sender, _amount, tokens[msg.sender]);
323     }
324 
325     /**
326     * @dev Internal transfer of the token.
327     * Funds remain in this contract but become available for withdrawal
328     */
329     function transferInternally(address _from, address _to, uint256 _amount) internal {
330         require(tokens[_from] >= _amount, "Too much to transfer");
331         tokens[_from] = tokens[_from].sub(_amount);
332         tokens[_to] = tokens[_to].add(_amount);
333     }
334 
335     /**
336     * @dev Interrupts the round to enable participants to claim funds back
337     */
338     function interruptLastRound() onlyOwner public {
339         getLastRound().enableRefunds();
340     }
341 
342     /**
343     * @dev End last round so no new plays is possible, but ongoing plays are fine to win
344     */
345     function finishLastRound() onlyOwner public {
346         getLastRound().coolDown();
347     }
348 
349     function getLastRound() public view returns (RoundInterface){
350         return RoundInterface(rounds[roundIndex]);
351     }
352 
353     function getLastRoundAddress() external view returns (address){
354         return rounds[roundIndex];
355     }
356 
357     function balanceOf(address _user) public view returns (uint256) {
358         return tokens[_user];
359     }
360 
361     function setPlaySeed(address _playSeedAddress) onlyOwner public {
362         playSeedGenerator = PlaySeedInterface(_playSeedAddress);
363     }
364 
365     function setStore(address _storeAddress) onlyOwner public {
366         store = AMUStoreInterface(_storeAddress);
367     }
368 
369     function getTokenBuyPrice() public view returns (uint256) {
370         return store.getTokenBuyPrice();
371     }
372 
373     function getTokenSellPrice() public view returns (uint256) {
374         return store.getTokenSellPrice();
375     }
376 
377     /**
378     * @dev Recover the history of referrals in case of the contract migration.
379     */
380     function setReferralsMap(address[] _players, address[] _referrals) onlyOwner public {
381         require(_players.length == _referrals.length, "Size of players must be equal to the size of referrals");
382         for (uint i = 0; i < _players.length; ++i) {
383             referralBacklog[_players[i]] = _referrals[i];
384         }
385     }
386 
387     function getStartersProxyAddress() external view returns (address) {
388         return startersProxyAddress;
389     }
390 
391     function setStartersProxyAddress(address _newProxyAddress) onlyOwner public  {
392         startersProxyAddress = _newProxyAddress;
393     }
394 
395     function setMetaBetWeight(uint256 _newMetaBet) onlyOwner public {
396         META_BET_WEIGHT = _newMetaBet;
397     }
398 
399     function setMinBet(uint256 _newMinBet) onlyOwner public {
400         MIN_PLAY_AMOUNT = _newMinBet;
401     }
402 
403 }
404 /**
405  * @title PlaySeed contract interface
406  */
407 interface PlaySeedInterface {
408 
409     function newPlaySeed(address _player) external;
410 
411     function findSeed(address _player) external view returns (bytes32);
412 
413     function cleanSeedUp(address _player) external;
414 
415     function claimOwnership() external;
416 
417 }
418 
419 /**
420  * @title GTA contract interface
421  */
422 interface GTAInterface {
423 
424     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
425 
426     function transfer(address to, uint256 value) external returns (bool);
427 
428 }
429 
430 /**
431  * @title EthBattleRound contract interface
432  */
433 interface RoundInterface {
434 
435     function claimOwnership() external;
436 
437     function setReferral(address _player, address _referral) external;
438 
439     function playRound(address _player, uint256 _bet) external payable;
440 
441     function enableRefunds() external;
442 
443     function coolDown() external;
444 
445     function currentPrize(address _player) external view returns (uint256);
446 
447     function projectedPrizeForPlayer(address _player, uint256 _bet) external view returns (uint256);
448 
449     function win(address _player) external;
450 
451     function getDevWallet() external view returns (address);
452 
453 }
454 
455 /**
456  * @title Ammu-Nation contract interface
457  */
458 interface AMUStoreInterface {
459 
460     function getTokenBuyPrice() external view returns (uint256);
461 
462     function getTokenSellPrice() external view returns (uint256);
463 
464 }