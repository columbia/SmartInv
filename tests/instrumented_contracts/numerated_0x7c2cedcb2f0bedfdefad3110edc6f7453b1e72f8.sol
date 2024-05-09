1 pragma solidity ^0.4.19;
2 
3 // File: contracts/includes/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
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
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts/includes/Claimable.sol
44 
45 /**
46  * @title Claimable
47  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
48  * This allows the new owner to accept the transfer.
49  */
50 contract Claimable is Ownable {
51   address public pendingOwner;
52 
53   /**
54    * @dev Modifier throws if called by any account other than the pendingOwner.
55    */
56   modifier onlyPendingOwner() {
57     require(msg.sender == pendingOwner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to set the pendingOwner address.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     pendingOwner = newOwner;
67   }
68 
69   /**
70    * @dev Allows the pendingOwner address to finalize the transfer.
71    */
72   function claimOwnership() onlyPendingOwner public {
73     // emit OwnershipTransferred(owner, pendingOwner);
74     owner = pendingOwner;
75     pendingOwner = address(0);
76   }
77 }
78 
79 // File: contracts/includes/Pausable.sol
80 
81 /**
82  * @title Pausable
83  * @dev Base contract which allows children to implement an emergency stop mechanism.
84  */
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 // File: contracts/CelebsPartyGate.sol
126 
127 contract CelebsPartyGate is Claimable, Pausable {
128   address public cfoAddress;
129   
130   function CelebsPartyGate() public {
131     cfoAddress = msg.sender;
132   }
133 
134   modifier onlyCFO() {
135     require(msg.sender == cfoAddress);
136     _;
137   }
138 
139   function setCFO(address _newCFO) external onlyOwner {
140     require(_newCFO != address(0));
141     cfoAddress = _newCFO;
142   }
143 }
144 
145 // File: contracts/includes/SafeMath.sol
146 
147 /**
148  * @title SafeMath
149  * @dev Math operations with safety checks that throw on error
150  */
151 library SafeMath {
152 
153   /**
154   * @dev Multiplies two numbers, throws on overflow.
155   */
156   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157     if (a == 0) {
158       return 0;
159     }
160     uint256 c = a * b;
161     assert(c / a == b);
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers, truncating the quotient.
167   */
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     // assert(b > 0); // Solidity automatically throws when dividing by 0
170     uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172     return c;
173   }
174 
175   /**
176   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   /**
184   * @dev Adds two numbers, throws on overflow.
185   */
186   function add(uint256 a, uint256 b) internal pure returns (uint256) {
187     uint256 c = a + b;
188     assert(c >= a);
189     return c;
190   }
191 }
192 
193 // File: contracts/CelebsParty.sol
194 
195 contract CelebsParty is CelebsPartyGate {
196     using SafeMath for uint256;
197 
198     event AgentHired(uint256 identifier, address player, bool queued);
199     event Birth(uint256 identifier, string name, address owner, bool queued);
200     event CategoryCreated(uint256 indexed identifier, string name);
201     event CelebrityBought(uint256 indexed identifier, address indexed oldOwner, address indexed newOwner, uint256 price);
202     event CelebrityReleased(uint256 indexed identifier, address player);
203     event FameAcquired(uint256 indexed identifier, address player, uint256 fame);
204     event PriceUpdated(uint256 indexed identifier, uint256 price);
205     event PrizeAwarded(address player, uint256 amount, string reason);
206     event UsernameUpdated(address player, string username);
207 
208     struct Category {
209         uint256 identifier;
210         string name;
211     }
212 
213     struct Celebrity {
214         uint256 identifier;
215         uint256[] categories;
216         string name;
217         uint256 price;
218         address owner;
219         bool isQueued;
220         uint256 lastQueueBlock;
221         address agent;
222         uint256 agentAwe;
223         uint256 famePerBlock;
224         uint256 lastFameBlock;
225     }
226 
227     mapping(uint256 => Category) public categories;
228     mapping(uint256 => Celebrity) public celebrities;
229     mapping(address => uint256) public fameBalance;
230     mapping(address => string) public usernames;
231     
232     uint256 public categoryCount;
233     uint256 public circulatingFame;
234     uint256 public celebrityCount;
235     uint256 public devBalance;
236     uint256 public prizePool;
237 
238     uint256 public minRequiredBlockQueueTime;
239 
240     function CelebsParty() public {
241         _initializeGame();
242     }
243 
244     function acquireFame(uint256 _identifier) external {
245         Celebrity storage celeb = celebrities[_identifier];
246         address player = msg.sender;
247         require(celeb.owner == player);
248         uint256 acquiredFame = SafeMath.mul((block.number - celeb.lastFameBlock), celeb.famePerBlock);
249         fameBalance[player] = SafeMath.add(fameBalance[player], acquiredFame);
250         celeb.lastFameBlock = block.number;
251         // increase the supply of the fame
252         circulatingFame = SafeMath.add(circulatingFame, acquiredFame);
253         FameAcquired(_identifier, player, acquiredFame);
254     }
255 
256     function becomeAgent(uint256 _identifier, uint256 _agentAwe) public whenNotPaused {
257         Celebrity storage celeb = celebrities[_identifier];
258         address newAgent = msg.sender;
259         address oldAgent = celeb.agent;
260         uint256 currentAgentAwe = celeb.agentAwe;
261         // ensure current agent is not the current player
262         require(oldAgent != newAgent);
263         // ensure the player can afford to become the agent
264         require(fameBalance[newAgent] >= _agentAwe);
265         // ensure the sent fame is more than the current agent sent
266         require(_agentAwe > celeb.agentAwe);
267         // if we are pre-drop, reset timer and give some fame back to previous bidder
268         if (celeb.isQueued) {
269             // reset the queue block timer
270             celeb.lastQueueBlock = block.number;
271             // give the old agent 50% of their fame back (this is a fame burn)
272             if(oldAgent != address(this)) {
273                 uint256 halfOriginalFame = SafeMath.div(currentAgentAwe, 2);
274                 circulatingFame = SafeMath.add(circulatingFame, halfOriginalFame);
275                 fameBalance[oldAgent] = SafeMath.add(fameBalance[oldAgent], halfOriginalFame);
276             }
277         }
278         // set the celebrity's agent to the current player
279         celeb.agent = newAgent;
280         // set the new min required bid
281         celeb.agentAwe = _agentAwe;
282         // deduct the sent fame amount from the current player's balance
283         circulatingFame = SafeMath.sub(circulatingFame, _agentAwe);
284         fameBalance[newAgent] = SafeMath.sub(fameBalance[newAgent], _agentAwe);
285         AgentHired(_identifier, newAgent, celeb.isQueued);
286     }
287 
288     function buyCelebrity(uint256 _identifier) public payable whenNotPaused {
289         Celebrity storage celeb = celebrities[_identifier];
290         // ensure that the celebrity is on the market and not queued
291         require(!celeb.isQueued);
292         address oldOwner = celeb.owner;
293         uint256 salePrice = celeb.price;
294         address newOwner = msg.sender;
295         // ensure the current player is not the current owner
296         require(oldOwner != newOwner);
297         // ensure the current player can actually afford to buy the celebrity
298         require(msg.value >= salePrice);
299         address agent = celeb.agent;
300         // determine how much fame the celebrity has generated
301         uint256 generatedFame = uint256(SafeMath.mul((block.number - celeb.lastFameBlock), celeb.famePerBlock));
302         // 91% of the sale will go the previous owner
303         uint256 payment = uint256(SafeMath.div(SafeMath.mul(salePrice, 91), 100));
304         // 4% of the sale will go to the celebrity's agent
305         uint256 agentFee = uint256(SafeMath.div(SafeMath.mul(salePrice, 4), 100));
306         // 3% of the sale will go to the developer of the game
307         uint256 devFee = uint256(SafeMath.div(SafeMath.mul(salePrice, 3), 100));
308         // 2% of the sale will go to the prize pool
309         uint256 prizeFee = uint256(SafeMath.div(SafeMath.mul(salePrice, 2), 100));
310         // calculate any excess wei that should be refunded
311         uint256 purchaseExcess = SafeMath.sub(msg.value, salePrice);
312         if (oldOwner != address(this)) {
313             // only transfer the funds if the contract doesn't own the celebrity (no pre-mine)
314             oldOwner.transfer(payment);
315         } else {
316             // if this is the first sale, main proceeds go to the prize pool
317             prizePool = SafeMath.add(prizePool, payment);
318         }
319         if (agent != address(this)) {
320             // send the agent their cut of the sale
321             agent.transfer(agentFee);
322         }
323         // new owner gets half of the unacquired, generated fame on the celebrity
324         uint256 spoils = SafeMath.div(generatedFame, 2);
325         circulatingFame = SafeMath.add(circulatingFame, spoils);
326         fameBalance[newOwner] = SafeMath.add(fameBalance[newOwner], spoils);
327         // don't send the dev anything, but make a note of it
328         devBalance = SafeMath.add(devBalance, devFee);
329         // increase the prize pool balance
330         prizePool = SafeMath.add(prizePool, prizeFee);
331         // set the new owner of the celebrity
332         celeb.owner = newOwner;
333         // set the new price of the celebrity
334         celeb.price = _nextPrice(salePrice);
335         // destroy all unacquired fame by resetting the block number
336         celeb.lastFameBlock = block.number;
337         // the fame acquired per block increases by 1 every time the celebrity is purchased
338         // this is capped at 100 fpb
339         if(celeb.famePerBlock < 100) {
340             celeb.famePerBlock = SafeMath.add(celeb.famePerBlock, 1);
341         }
342         // let the world know the celebrity has been purchased
343         CelebrityBought(_identifier, oldOwner, newOwner, salePrice);
344         // send the new owner any excess wei
345         newOwner.transfer(purchaseExcess);
346     }
347 
348     function createCategory(string _name) external onlyOwner {
349         _mintCategory(_name);
350     }
351 
352     function createCelebrity(string _name, address _owner, address _agent, uint256 _agentAwe, uint256 _price, bool _queued, uint256[] _categories) public onlyOwner {
353         require(celebrities[celebrityCount].price == 0);
354         address newOwner = _owner;
355         address newAgent = _agent;
356         if (newOwner == 0x0) {
357             newOwner = address(this);
358         }
359         if (newAgent == 0x0) {
360             newAgent = address(this);
361         }
362         uint256 newIdentifier = celebrityCount;
363         Celebrity memory celeb = Celebrity({
364             identifier: newIdentifier,
365             owner: newOwner,
366             price: _price,
367             name: _name,
368             famePerBlock: 0,
369             lastQueueBlock: block.number,
370             lastFameBlock: block.number,
371             agent: newAgent,
372             agentAwe: _agentAwe,
373             isQueued: _queued,
374             categories: _categories
375         });
376         celebrities[newIdentifier] = celeb;
377         celebrityCount = SafeMath.add(celebrityCount, 1);
378         Birth(newIdentifier, _name, _owner, _queued);
379     }
380     
381     function getCelebrity(uint256 _identifier) external view returns
382     (uint256 id, string name, uint256 price, uint256 nextPrice, address agent, uint256 agentAwe, address owner, uint256 fame, uint256 lastFameBlock, uint256[] cats, bool queued, uint256 lastQueueBlock)
383     {
384         Celebrity storage celeb = celebrities[_identifier];
385         id = celeb.identifier;
386         name = celeb.name;
387         owner = celeb.owner;
388         agent = celeb.agent;
389         price = celeb.price;
390         fame = celeb.famePerBlock;
391         lastFameBlock = celeb.lastFameBlock;
392         nextPrice = _nextPrice(price);
393         cats = celeb.categories;
394         agentAwe = celeb.agentAwe;
395         queued = celeb.isQueued;
396         lastQueueBlock = celeb.lastQueueBlock;
397     }
398 
399     function getFameBalance(address _player) external view returns(uint256) {
400         return fameBalance[_player];
401     }
402 
403     function getUsername(address _player) external view returns(string) {
404         return usernames[_player];
405     }
406 
407     function releaseCelebrity(uint256 _identifier) public whenNotPaused {
408         Celebrity storage celeb = celebrities[_identifier];
409         address player = msg.sender;
410         // ensure that enough blocks have been mined (no one has bid within this time period)
411         require(block.number - celeb.lastQueueBlock >= minRequiredBlockQueueTime);
412         // ensure the celebrity isn't already released!
413         require(celeb.isQueued);
414         // ensure current agent is the current player
415         require(celeb.agent == player);
416         // celebrity is no longer queued and can be displayed on the market
417         celeb.isQueued = false;
418         CelebrityReleased(_identifier, player);
419     }
420 
421     function setCelebrityPrice(uint256 _identifier, uint256 _price) public whenNotPaused {
422         Celebrity storage celeb = celebrities[_identifier];
423         // ensure the current player is the owner of the celebrity
424         require(msg.sender == celeb.owner);
425         // the player can only set a price that is lower than the current asking price
426         require(_price < celeb.price);
427         // set the new price 
428         celeb.price = _price;
429         PriceUpdated(_identifier, _price);
430     }
431 
432     function setRequiredBlockQueueTime(uint256 _blocks) external onlyOwner {
433         minRequiredBlockQueueTime = _blocks;
434     }
435 
436     function setUsername(address _player, string _username) public {
437         // ensure the player to be changed is the current player
438         require(_player == msg.sender);
439         // set the username
440         usernames[_player] = _username;
441         UsernameUpdated(_player, _username);
442     }
443 
444     function sendPrize(address _player, uint256 _amount, string _reason) external onlyOwner {
445         uint256 newPrizePoolAmount = prizePool - _amount;
446         require(prizePool >= _amount);
447         require(newPrizePoolAmount >= 0);
448         prizePool = newPrizePoolAmount;
449         _player.transfer(_amount);
450         PrizeAwarded(_player, _amount, _reason);
451     }
452 
453     function withdrawDevBalance() external onlyOwner {
454         require(devBalance > 0);
455         uint256 withdrawAmount = devBalance;
456         devBalance = 0;
457         owner.transfer(withdrawAmount);
458     }
459 
460     /**************************
461         internal funcs
462     ***************************/
463 
464     function _nextPrice(uint256 currentPrice) internal pure returns(uint256) {
465         if (currentPrice < .1 ether) {
466             return currentPrice.mul(200).div(100);
467         } else if (currentPrice < 1 ether) {
468             return currentPrice.mul(150).div(100);
469         } else if (currentPrice < 10 ether) {
470             return currentPrice.mul(130).div(100);
471         } else {
472             return currentPrice.mul(120).div(100);
473         }
474     }
475 
476     function _mintCategory(string _name) internal {
477         uint256 newIdentifier = categoryCount;
478         categories[newIdentifier] = Category(newIdentifier, _name);
479         CategoryCreated(newIdentifier, _name);
480         categoryCount = SafeMath.add(categoryCount, 1);
481     }
482 
483     function _initializeGame() internal {
484         categoryCount = 0;
485         celebrityCount = 0;
486         minRequiredBlockQueueTime = 1000;
487         paused = true;
488         _mintCategory("business");
489         _mintCategory("film/tv");
490         _mintCategory("music");
491         _mintCategory("personality");
492         _mintCategory("tech");
493     }
494 }