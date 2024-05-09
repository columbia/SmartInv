1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Owned {
33     address public owner;
34 
35     event LogNew(address indexed old, address indexed current);
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     function transferOwnership(address _newOwner) onlyOwner public {
47         emit LogNew(owner, _newOwner);
48         owner = _newOwner;
49     }
50 }
51 
52 contract IMoneyManager {
53     function payTo(address _participant, uint256 _revenue) payable public returns(bool);
54 }
55 
56 contract Game is Owned {
57     using SafeMath for uint256;
58     
59     // The address of the owner 
60     address public ownerWallet;
61     // The address of the activator
62     mapping(address => bool) internal activator;
63     
64     // Constants
65     uint256 public constant BET = 10 finney; //0.01 ETH
66     uint8 public constant ODD = 1;
67     uint8 public constant EVEN = 2;
68     uint8 public constant noBets = 3;
69     uint256 public constant COMMISSION_PERCENTAGE = 10;
70     uint256 public constant END_DURATION_BETTING_BLOCK = 5520;
71     uint256 public constant TARGET_DURATION_BETTING_BLOCK = 5760;
72 	
73 	uint256 public constant CONTRACT_VERSION = 201805311200;
74     
75     // The address of the moneyManager
76     address public moneyManager;
77     
78     // Array which stores the target blocks
79     uint256[] targetBlocks;
80     
81     // Mappings
82     mapping(address => Participant) public participants;
83 
84     mapping(uint256 => mapping(uint256 => uint256)) oddAndEvenBets; // Stores the msg.value for the block and the bet (odd or even)
85 
86     mapping(uint256 => uint256) blockResult; // Stores if the blockhash's last char is odd or even
87     mapping(uint256 => bytes32) blockHash; // Stores the hash of block (block.number)
88 
89     mapping(uint256 => uint256) blockRevenuePerTicket; // Stores the amount of the revenue per person for given block
90     mapping(uint256 => bool) isBlockRevenueCalculated; // Stores if the blocks revenue is calculated
91 
92     mapping(uint256 => uint256) comissionsAtBlock; // Stores the commision amount for given block
93     
94     // Public variables
95     uint256 public _startBetBlock;
96     uint256 public _endBetBlock;
97 
98     uint256 public _targetBlock;
99     
100     // Modifiers
101     modifier afterBlock(uint256 _blockNumber) {
102         require(block.number >= _blockNumber);
103         _;
104     }
105 
106     modifier onlyActivator(address _activator) {
107         require(activator[_activator] == true);
108         _;
109     }
110     
111     // Structures
112     struct Participant {
113         mapping(uint256 => Bet) bets;
114         bool isParticipated;
115     }
116 
117     struct Bet {
118         uint256 ODDBets;
119 		uint256 EVENBets;
120         bool isRevenuePaid;
121     }
122     
123     /** @dev Constructor 
124       * @param _moneyManager The address of the money manager.
125       * @param _ownerWallet The address of the owner.
126       * 
127       */
128     constructor(address _moneyManager, address _ownerWallet) public {
129         setMoneyManager(_moneyManager);
130         setOwnerWallet(_ownerWallet);
131     }
132     
133     /** @dev Fallback function.
134       * Provides functionality for person to bet.
135       */
136     function() payable public {
137         bet(getBlockHashOddOrEven(block.number - 128), msg.value.div(BET));
138     }
139     
140     /** @dev Function which activates the cycle. 
141       * Only the activator can call the function.
142       * @param _startBlock The starting block of the game.
143       * Set the starting block from which the participants can start to bet for target block.
144       * Set the end block to which the participants can bet fot target block. 
145       * Set the target block for which the participants will bet.
146       * @return success Is the activation of the cycle successful.
147       */
148     function activateCycle(uint256 _startBlock) public onlyActivator(msg.sender) returns (bool _success) {
149         if (_startBlock == 0) {
150             _startBlock = block.number;
151         }
152         require(block.number >= _endBetBlock);
153 
154         _startBetBlock = _startBlock;
155         _endBetBlock = _startBetBlock.add(END_DURATION_BETTING_BLOCK);
156 
157         _targetBlock = _startBetBlock.add(TARGET_DURATION_BETTING_BLOCK);
158         targetBlocks.push(_targetBlock);
159 
160         return true;
161     }
162     
163     // Events
164     event LogBet(address indexed participant, uint256 blockNumber, uint8 oddOrEven, uint256 betAmount);
165     event LogNewParticipant(address indexed _newParticipant);
166     
167     /** @dev Function from which everyone can bet 
168       * @param oddOrEven The number on which the participant want to bet (it is 1 - ODD or 2 - EVEN).
169       * @param betsAmount The amount of tickets the participant want to buy.
170       * @return success Is the bet successful.
171       */
172     function bet(uint8 oddOrEven, uint256 betsAmount) public payable returns (bool _success) {
173 		require(betsAmount > 0);
174 		uint256 participantBet = betsAmount.mul(BET);
175 		require(msg.value == participantBet);
176         require(oddOrEven == ODD || oddOrEven == EVEN);
177         require(block.number <= _endBetBlock && block.number >= _startBetBlock);
178 
179 		// @dev - check if participant already betted
180 		if (participants[msg.sender].isParticipated == false) {
181 			// create new participant in memory
182 			Participant memory newParticipant;
183 			newParticipant.isParticipated = true;
184 			//save the participant to state
185 			participants[msg.sender] = newParticipant;
186 			emit LogNewParticipant(msg.sender);
187 		}
188 		
189 		uint256 betTillNowODD = participants[msg.sender].bets[_targetBlock].ODDBets;
190 		uint256 betTillNowEVEN = participants[msg.sender].bets[_targetBlock].EVENBets;
191 		if(oddOrEven == ODD) {
192 			betTillNowODD = betTillNowODD.add(participantBet);
193 		} else {
194 			betTillNowEVEN = betTillNowEVEN.add(participantBet);
195 		}
196 		Bet memory newBet = Bet({ODDBets : betTillNowODD, EVENBets: betTillNowEVEN, isRevenuePaid : false});
197 	
198         //save the bet
199         participants[msg.sender].bets[_targetBlock] = newBet;
200         // save the bet for the block
201         oddAndEvenBets[_targetBlock][oddOrEven] = oddAndEvenBets[_targetBlock][oddOrEven].add(msg.value);
202         address(moneyManager).transfer(msg.value);
203         emit LogBet(msg.sender, _targetBlock, oddOrEven, msg.value);
204 
205         return true;
206     }
207     
208     /** @dev Function which calculates the revenue for block.
209       * @param _blockNumber The block for which the revenie will be calculated.
210       */
211     function calculateRevenueAtBlock(uint256 _blockNumber) public afterBlock(_blockNumber) {
212         require(isBlockRevenueCalculated[_blockNumber] == false);
213         if(oddAndEvenBets[_blockNumber][ODD] > 0 || oddAndEvenBets[_blockNumber][EVEN] > 0) {
214             blockResult[_blockNumber] = getBlockHashOddOrEven(_blockNumber);
215             require(blockResult[_blockNumber] == ODD || blockResult[_blockNumber] == EVEN);
216             if (blockResult[_blockNumber] == ODD) {
217                 calculateRevenue(_blockNumber, ODD, EVEN);
218             } else if (blockResult[_blockNumber] == EVEN) {
219                 calculateRevenue(_blockNumber, EVEN, ODD);
220             }
221         } else {
222             isBlockRevenueCalculated[_blockNumber] = true;
223             blockResult[_blockNumber] = noBets;
224         }
225     }
226 
227     event LogOddOrEven(uint256 blockNumber, bytes32 blockHash, uint256 oddOrEven);
228     
229     /** @dev Function which calculates the hash of the given block.
230       * @param _blockNumber The block for which the hash will be calculated.
231       * The function is called by the calculateRevenueAtBlock()
232       * @return oddOrEven
233       */
234     function getBlockHashOddOrEven(uint256 _blockNumber) internal returns (uint8 oddOrEven) {
235         blockHash[_blockNumber] = blockhash(_blockNumber);
236         uint256 result = uint256(blockHash[_blockNumber]);
237         uint256 lastChar = (result * 2 ** 252) / (2 ** 252);
238         uint256 _oddOrEven = lastChar % 2;
239 
240         emit LogOddOrEven(_blockNumber, blockHash[_blockNumber], _oddOrEven);
241 
242         if (_oddOrEven == 1) {
243             return ODD;
244         } else if (_oddOrEven == 0) {
245             return EVEN;
246         }
247     }
248 
249     event LogRevenue(uint256 blockNumber, uint256 winner, uint256 revenue);
250     
251     /** @dev Function which calculates the revenue of given block.
252       * @param _blockNumber The block for which the revenue will be calculated.
253       * @param winner The winner bet (1 - odd or 2 - even).
254       * @param loser The loser bet (2 even or 1 - odd).
255       * The function is called by the calculateRevenueAtBlock()
256       */
257     function calculateRevenue(uint256 _blockNumber, uint256 winner, uint256 loser) internal {
258         uint256 revenue = oddAndEvenBets[_blockNumber][loser];
259         if (oddAndEvenBets[_blockNumber][ODD] != 0 && oddAndEvenBets[_blockNumber][EVEN] != 0) {
260             uint256 comission = (revenue.div(100)).mul(COMMISSION_PERCENTAGE);
261             revenue = revenue.sub(comission);
262             comissionsAtBlock[_blockNumber] = comission;
263             IMoneyManager(moneyManager).payTo(ownerWallet, comission);
264             uint256 winners = oddAndEvenBets[_blockNumber][winner].div(BET);
265             blockRevenuePerTicket[_blockNumber] = revenue.div(winners);
266         }
267         isBlockRevenueCalculated[_blockNumber] = true;
268         emit LogRevenue(_blockNumber, winner, revenue);
269     }
270 
271     event LogpayToRevenue(address indexed participant, uint256 blockNumber, bool revenuePaid);
272     
273     /** @dev Function which allows the participants to withdraw their revenue.
274       * @param _blockNumber The block for which the participants will withdraw their revenue.
275       * @return _success Is the revenue withdrawn successfully.
276       */
277     function withdrawRevenue(uint256 _blockNumber) public returns (bool _success) {
278         require(participants[msg.sender].bets[_blockNumber].ODDBets > 0 || participants[msg.sender].bets[_blockNumber].EVENBets > 0);
279         require(participants[msg.sender].bets[_blockNumber].isRevenuePaid == false);
280         require(isBlockRevenueCalculated[_blockNumber] == true);
281 
282         if (oddAndEvenBets[_blockNumber][ODD] == 0 || oddAndEvenBets[_blockNumber][EVEN] == 0) {
283 			if(participants[msg.sender].bets[_blockNumber].ODDBets > 0) {
284 				IMoneyManager(moneyManager).payTo(msg.sender, participants[msg.sender].bets[_blockNumber].ODDBets);
285 			}else{
286 				IMoneyManager(moneyManager).payTo(msg.sender, participants[msg.sender].bets[_blockNumber].EVENBets);
287 			}
288             participants[msg.sender].bets[_blockNumber].isRevenuePaid = true;
289             emit LogpayToRevenue(msg.sender, _blockNumber, participants[msg.sender].bets[_blockNumber].isRevenuePaid);
290 
291             return participants[msg.sender].bets[_blockNumber].isRevenuePaid;
292         }
293         // @dev - initial revenue to be paid
294         uint256 _revenue = 0;
295         uint256 counter = 0;
296 		uint256 totalPayment = 0;
297         if (blockResult[_blockNumber] == ODD) {
298 			counter = (participants[msg.sender].bets[_blockNumber].ODDBets).div(BET);
299             _revenue = _revenue.add(blockRevenuePerTicket[_blockNumber].mul(counter));
300         } else if (blockResult[_blockNumber] == EVEN) {
301 			counter = (participants[msg.sender].bets[_blockNumber].EVENBets).div(BET);
302            _revenue = _revenue.add(blockRevenuePerTicket[_blockNumber].mul(counter));
303         }
304 		totalPayment = _revenue.add(BET.mul(counter));
305         // pay the revenue
306         IMoneyManager(moneyManager).payTo(msg.sender, totalPayment);
307         participants[msg.sender].bets[_blockNumber].isRevenuePaid = true;
308 
309         emit LogpayToRevenue(msg.sender, _blockNumber, participants[msg.sender].bets[_blockNumber].isRevenuePaid);
310         return participants[msg.sender].bets[_blockNumber].isRevenuePaid;
311     }
312     
313     /** @dev Function which set the activator of the cycle.
314       * Only owner can call the function.
315       */
316     function setActivator(address _newActivator) onlyOwner public returns(bool) {
317         require(activator[_newActivator] == false);
318         activator[_newActivator] = true;
319         return activator[_newActivator];
320     }
321     
322     /** @dev Function which remove the activator.
323       * Only owner can call the function.
324       */
325     function removeActivator(address _Activator) onlyOwner public returns(bool) {
326         require(activator[_Activator] == true);
327         activator[_Activator] = false;
328         return true;
329     }
330     
331     /** @dev Function which set the owner of the wallet.
332       * Only owner can call the function.
333       * Called when the contract is deploying.
334       */
335     function setOwnerWallet(address _newOwnerWallet) public onlyOwner {
336         emit LogNew(ownerWallet, _newOwnerWallet);
337         ownerWallet = _newOwnerWallet;
338     }
339     
340     /** @dev Function which set the money manager.
341       * Only owner can call the function.
342       * Called when contract is deploying.
343       */
344     function setMoneyManager(address _moneyManager) public onlyOwner {
345         emit LogNew(moneyManager, _moneyManager);
346         moneyManager = _moneyManager;
347     }
348     
349     function getActivator(address _isActivator) public view returns(bool) {
350         return activator[_isActivator];
351     }
352     
353     /** @dev Function for getting the current block.
354       * @return _blockNumber
355       */
356     function getblock() public view returns (uint256 _blockNumber){
357         return block.number;
358     }
359 
360     /** @dev Function for getting the current cycle info
361       * @return startBetBlock, endBetBlock, targetBlock
362       */
363     function getCycleInfo() public view returns (uint256 startBetBlock, uint256 endBetBlock, uint256 targetBlock){
364         return (
365         _startBetBlock,
366         _endBetBlock,
367         _targetBlock);
368     }
369     
370     /** @dev Function for getting the given block hash
371       * @param _blockNumber The block number of which you want to check hash.
372       * @return _blockHash
373       */
374     function getBlockHash(uint256 _blockNumber) public view returns (bytes32 _blockHash) {
375         return blockHash[_blockNumber];
376     }
377     
378     /** @dev Function for getting the bets for ODD and EVEN.
379       * @param _participant The address of the participant whose bets you want to check.
380       * @param _blockNumber The block for which you want to check.
381       * @return _oddBets, _evenBets
382       */
383     function getBetAt(address _participant, uint256 _blockNumber) public view returns (uint256 _oddBets, uint256 _evenBets){
384         return (participants[_participant].bets[_blockNumber].ODDBets, participants[_participant].bets[_blockNumber].EVENBets);
385     }
386     
387     /** @dev Function for getting the block result if it is ODD or EVEN.
388       * @param _blockNumber The block for which you want to get the result.
389       * @return _oddOrEven
390       */
391     function getBlockResult(uint256 _blockNumber) public view returns (uint256 _oddOrEven){
392         return blockResult[_blockNumber];
393     }
394     
395     /** @dev Function for getting the wei amount for given block.
396       * @param _blockNumber The block for which you want to get wei amount.
397       * @param _blockOddOrEven The block which is odd or even.
398       * @return _weiAmountAtStage
399       */
400     function getoddAndEvenBets(uint256 _blockNumber, uint256 _blockOddOrEven) public view returns (uint256 _weiAmountAtStage) {
401         return oddAndEvenBets[_blockNumber][_blockOddOrEven];
402     }
403     
404     /** @dev Function for checking if the given address participated in given block.
405       * @param _participant The participant whose participation we are going to check.
406       * @param _blockNumber The block for which we will check the participation.
407       * @return _isParticipate
408       */
409     function getIsParticipate(address _participant, uint256 _blockNumber) public view returns (bool _isParticipate) {
410         return (participants[_participant].bets[_blockNumber].ODDBets > 0 || participants[_participant].bets[_blockNumber].EVENBets > 0);
411     }
412     
413      /** @dev Function for getting the block revenue per ticket.
414       * @param _blockNumber The block for which we will calculate revenue per ticket.
415       * @return _revenue
416       */
417     function getblockRevenuePerTicket(uint256 _blockNumber) public view returns (uint256 _revenue) {
418         return blockRevenuePerTicket[_blockNumber];
419     }
420     
421     /** @dev Function which tells us is the revenue for given block is calculated.
422       * @param _blockNumber The block for which we will check.
423       * @return _isCalculated
424       */
425     function getIsBlockRevenueCalculated(uint256 _blockNumber) public view returns (bool _isCalculated) {
426         return isBlockRevenueCalculated[_blockNumber];
427     }
428     
429     /** @dev Function which tells us is the revenue for given block is paid.
430       * @param _blockNumber The block for which we will check.
431       * @return _isPaid
432       */
433     function getIsRevenuePaid(address _participant, uint256 _blockNumber) public view returns (bool _isPaid) {
434         return participants[_participant].bets[_blockNumber].isRevenuePaid;
435     }
436     
437     /** @dev Function which will return the block commission.
438       * @param _blockNumber The block for which we will get the commission.
439       * @return _comission
440       */
441     function getBlockComission(uint256 _blockNumber) public view returns (uint256 _comission) {
442         return comissionsAtBlock[_blockNumber];
443     }
444     
445     /** @dev Function which will return the ODD and EVEN bets.
446       * @param _blockNumber The block for which we will get the commission.
447       * @return _ODDBets, _EVENBets
448       */
449     function getBetsEvenAndODD(uint256 _blockNumber) public view returns (uint256 _ODDBets, uint256 _EVENBets) {
450         return (oddAndEvenBets[_blockNumber][ODD], oddAndEvenBets[_blockNumber][EVEN]);
451     }
452 
453     /** @dev Function which will return the count of target blocks.
454       * @return _targetBlockLenght
455       */
456     function getTargetBlockLength() public view returns (uint256 _targetBlockLenght) {
457         return targetBlocks.length;
458     }
459     
460     /** @dev Function which will return the whole target blocks.
461       * @return _targetBlocks Array of target blocks
462       */
463     function getTargetBlocks() public view returns (uint256[] _targetBlocks) {
464         return targetBlocks;
465     }
466     
467     /** @dev Function which will return a specific target block at index.
468       * @param _index The index of the target block which we want to get.
469       * @return _targetBlockNumber
470       */
471     function getTargetBlock(uint256 _index) public view returns (uint256 _targetBlockNumber) {
472         return targetBlocks[_index];
473     }
474 }