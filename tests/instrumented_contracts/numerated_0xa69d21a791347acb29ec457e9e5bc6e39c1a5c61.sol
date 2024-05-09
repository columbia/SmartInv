1 pragma solidity 0.4.24;
2 
3 // </ORACLIZE_API>
4 // Minimal required STAKE token interface
5 contract StakeToken
6 {
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10 }
11 
12 contract StakeDiceGame
13 {
14     // Prevent people from losing Ether by accidentally sending it to this contract.
15     function () payable external
16     {
17         revert();
18     }
19     
20     ///////////////////////////////
21     /////// GAME PARAMETERS
22     
23     StakeDice public stakeDice;
24     
25     // Number between 0 and 10 000. Examples:
26     // 700 indicates 7% chance.
27     // 5000 indicates 50% chance.
28     // 8000 indicates 80% chance.
29     uint256 public winningChance;
30     
31     // Examples of multiplierOnWin() return values:
32     // 10 000 indicates 1x returned.
33     // 13 000 indicated 1.3x returned
34     // 200 000 indicates 20x returned
35     function multiplierOnWin() public view returns (uint256)
36     {
37         uint256 beforeHouseEdge = 10000;
38         uint256 afterHouseEdge = beforeHouseEdge - stakeDice.houseEdge();
39         return afterHouseEdge * 10000 / winningChance;
40     }
41     
42     function maximumBet() public view returns (uint256)
43     {
44         uint256 availableTokens = stakeDice.stakeTokenContract().balanceOf(address(stakeDice));
45         return availableTokens * 10000 / multiplierOnWin() / 5;
46     }
47     
48     ///////////////////////////////
49     /////// GAME FUNCTIONALITY
50     
51     // If we receive approval to transfer a gambler's tokens
52     /*function receiveApproval(address _gambler, uint256 _amount, address _tokenContract, bytes) external returns (bool)
53     {
54         // Make sure that we are receiving STAKE tokens, and not some other token
55         require(_tokenContract == address(stakeDice.stakeTokenContract()));
56         require(msg.sender == _tokenContract);
57         
58         // Make sure the bet is within the current limits
59         require(_amount >= stakeDice.minimumBet());
60         require(_amount <= maximumBet());
61         
62         // Tranfer the STAKE tokens from the user's account to the StakeDice contract
63         stakeDice.stakeTokenContract().transferFrom(_gambler, stakeDice, _amount);
64         
65         // Notify the StakeDice contract that a bet has been placed
66         stakeDice.betPlaced(_gambler, _amount, winningChance);
67     }*/
68     
69     ///////////////////////////////
70     /////// OWNER FUNCTIONS
71     
72     // Constructor function
73     // Provide a number between 0 and 10 000 to indicate the winning chance and house edge.
74     constructor(StakeDice _stakeDice, uint256 _winningChance) public
75     {
76         // Ensure the parameters are sane
77         require(_winningChance > 0);
78         require(_winningChance < 10000);
79         require(_stakeDice != address(0x0));
80         require(msg.sender == address(_stakeDice));
81         
82         stakeDice = _stakeDice;
83         winningChance = _winningChance;
84     }
85     
86     // Allow the owner to change the winning chance
87     function setWinningChance(uint256 _newWinningChance) external
88     {
89         require(msg.sender == stakeDice.owner());
90         require(_newWinningChance > 0);
91         require(_newWinningChance < 10000);
92         winningChance = _newWinningChance;
93     }
94     
95     // Allow the owner to withdraw STAKE tokens that
96     // may have been accidentally sent here.
97     function withdrawStakeTokens(uint256 _amount, address _to) external
98     {
99         require(msg.sender == stakeDice.owner());
100         require(_to != address(0x0));
101         stakeDice.stakeTokenContract().transfer(_to, _amount);
102     }
103 }
104 
105 
106 contract StakeDice
107 {
108     ///////////////////////////////
109     /////// GAME PARAMETERS
110     
111     StakeToken public stakeTokenContract;
112     mapping(address => bool) public addressIsStakeDiceGameContract;
113     StakeDiceGame[] public allGames;
114     uint256 public houseEdge;
115     uint256 public minimumBet;
116     
117     //////////////////////////////
118     /////// PLAYER STATISTICS
119     
120     address[] public allPlayers;
121     mapping(address => uint256) public playersToTotalBets;
122     mapping(address => uint256[]) public playersToBetIndices;
123     function playerAmountOfBets(address _player) external view returns (uint256)
124     {
125         return playersToBetIndices[_player].length;
126     }
127     
128     function totalUniquePlayers() external view returns (uint256)
129     {
130         return allPlayers.length;
131     }
132     
133     //////////////////////////////
134     /////// GAME FUNCTIONALITY
135     
136     // Events
137     event BetPlaced(address indexed gambler, uint256 betIndex);
138     event BetWon(address indexed gambler, uint256 betIndex);
139     event BetLost(address indexed gambler, uint256 betIndex);
140     event BetCanceled(address indexed gambler, uint256 betIndex);
141     
142     enum BetStatus
143     {
144         NON_EXISTANT,
145         IN_PROGRESS,
146         WON,
147         LOST,
148         CANCELED
149     }
150     
151     struct Bet
152     {
153         address gambler;
154         uint256 winningChance;
155         uint256 betAmount;
156         uint256 potentialRevenue;
157         uint256 roll;
158         BetStatus status;
159     }
160     
161     Bet[] public bets;
162     uint public betsLength = 0;
163     mapping(bytes32 => uint256) public oraclizeQueryIdsToBetIndices;
164     
165     function betPlaced(address gameContract, uint256 _amount) external
166     {
167         // Only StakeDiceGame contracts are allowed to call this function
168         require(addressIsStakeDiceGameContract[gameContract] == true);
169         
170          // Make sure the bet is within the current limits
171         require(_amount >= minimumBet);
172         require(_amount <= StakeDiceGame(gameContract).maximumBet());
173         
174         // Tranfer the STAKE tokens from the user's account to the StakeDice contract
175         stakeTokenContract.transferFrom(msg.sender, this, _amount);
176         
177         
178         // Calculate how much the gambler might win
179         uint256 potentialRevenue = StakeDiceGame(gameContract).multiplierOnWin() * _amount / 10000;
180         
181         // Store the bet
182         emit BetPlaced(msg.sender, bets.length);
183         playersToBetIndices[msg.sender].push(bets.length);
184         bets.push(Bet({gambler: msg.sender, winningChance: StakeDiceGame(gameContract).winningChance(), betAmount: _amount, potentialRevenue: potentialRevenue, roll: 0, status: BetStatus.IN_PROGRESS}));
185         betsLength +=1;
186         // Update statistics
187         if (playersToTotalBets[msg.sender] == 0)
188         {
189             allPlayers.push(msg.sender);
190         }
191         playersToTotalBets[msg.sender] += _amount;
192         //uint _result = 1; //the random number
193         uint256 betIndex = betsLength;
194         Bet storage bet = bets[betIndex];
195         require(bet.status == BetStatus.IN_PROGRESS);
196         // Now that we have generated a random number, let's use it..
197         uint randomNumber = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%100);
198        
199         // Store the roll in the blockchain permanently
200         bet.roll = randomNumber;
201         
202         // If the random number is smaller than the winningChance, the gambler won!
203         if (randomNumber < bet.winningChance/100)
204         {
205             // If we somehow don't have enough tokens to payout their winnings,
206             // cancel the bet and refund the gambler automatically
207             if (stakeTokenContract.balanceOf(this) < bet.potentialRevenue)
208             {
209                 _cancelBet(betIndex);
210             }
211             
212             // Otherwise, (if we do have enough tokens)
213             else
214             {
215                 // The gambler won!
216                 bet.status = BetStatus.WON;
217             
218                 // Send them their winnings
219                 stakeTokenContract.transfer(bet.gambler, bet.potentialRevenue);
220                 
221                 // Trigger BetWon event
222                 emit BetWon(bet.gambler, betIndex);
223             }
224         }
225         else
226         {
227             // The gambler lost!
228             bet.status = BetStatus.LOST;
229             
230             // Send them the smallest possible token unit as consolation prize
231             // and as notification that their bet has lost.
232             stakeTokenContract.transfer(bet.gambler, 1); // Send 0.00000001 STAKE
233             
234             // Trigger BetLost event
235             emit BetLost(bet.gambler, betIndex);
236         }
237     }
238     
239     function _cancelBet(uint256 _betIndex) private
240     {
241         // Only bets that are in progress can be canceled
242         require(bets[_betIndex].status == BetStatus.IN_PROGRESS);
243         
244         // Store the fact that the bet has been canceled
245         bets[_betIndex].status = BetStatus.CANCELED;
246         
247         // Refund the bet amount to the gambler
248         stakeTokenContract.transfer(bets[_betIndex].gambler, bets[_betIndex].betAmount);
249         
250         // Trigger BetCanceled event
251         emit BetCanceled(bets[_betIndex].gambler, _betIndex);
252         
253         // Subtract the bet from their total
254         playersToTotalBets[bets[_betIndex].gambler] -= bets[_betIndex].betAmount;
255     }
256     
257     function amountOfGames() external view returns (uint256)
258     {
259         return allGames.length;
260     }
261     
262     function amountOfBets() external view returns (uint256)
263     {
264         return bets.length-1;
265     }
266     
267     ///////////////////////////////
268     /////// OWNER FUNCTIONS
269     
270     address public owner;
271     
272     // Constructor function
273     constructor(StakeToken _stakeTokenContract, uint256 _houseEdge, uint256 _minimumBet) public
274     {
275         // Bet indices start at 1 because the values of the
276         // oraclizeQueryIdsToBetIndices mapping are by default 0.
277         bets.length = 1;
278         
279         // Whoever deployed the contract is made owner
280         owner = msg.sender;
281         
282         // Ensure that the arguments are sane
283         require(_houseEdge < 10000);
284         require(_stakeTokenContract != address(0x0));
285         
286         // Store the initializing arguments
287         stakeTokenContract = _stakeTokenContract;
288         houseEdge = _houseEdge;
289         minimumBet = _minimumBet;
290     }
291     
292     // Allow the owner to easily create the default dice games
293     function createDefaultGames() public
294     {
295         require(allGames.length == 0);
296         
297         addNewStakeDiceGame(500); // 5% chance
298         addNewStakeDiceGame(1000); // 10% chance
299         addNewStakeDiceGame(1500); // 15% chance
300         addNewStakeDiceGame(2000); // 20% chance
301         addNewStakeDiceGame(2500); // 25% chance
302         addNewStakeDiceGame(3000); // 30% chance
303         addNewStakeDiceGame(3500); // 35% chance
304         addNewStakeDiceGame(4000); // 40% chance
305         addNewStakeDiceGame(4500); // 45% chance
306         addNewStakeDiceGame(5000); // 50% chance
307         addNewStakeDiceGame(5500); // 55% chance
308         addNewStakeDiceGame(6000); // 60% chance
309         addNewStakeDiceGame(6500); // 65% chance
310         addNewStakeDiceGame(7000); // 70% chance
311         addNewStakeDiceGame(7500); // 75% chance
312         addNewStakeDiceGame(8000); // 80% chance
313         addNewStakeDiceGame(8500); // 85% chance
314         addNewStakeDiceGame(9000); // 90% chance
315         addNewStakeDiceGame(9500); // 95% chance
316     }
317     
318     // Allow the owner to cancel a bet when it's in progress.
319     // This will probably never be needed, but it might some day be needed
320     // to refund people if oraclize is not responding.
321     function cancelBet(uint256 _betIndex) public
322     {
323         require(msg.sender == owner);
324         
325         _cancelBet(_betIndex);
326     }
327     
328     // Allow the owner to add new games with different winning chances
329     function addNewStakeDiceGame(uint256 _winningChance) public
330     {
331         require(msg.sender == owner);
332         
333         // Deploy a new StakeDiceGame contract
334         StakeDiceGame newGame = new StakeDiceGame(this, _winningChance);
335         
336         // Store the fact that this new address is a StakeDiceGame contract
337         addressIsStakeDiceGameContract[newGame] = true;
338         allGames.push(newGame);
339     }
340     
341     // Allow the owner to change the house edge
342     function setHouseEdge(uint256 _newHouseEdge) external
343     {
344         require(msg.sender == owner);
345         require(_newHouseEdge < 10000);
346         houseEdge = _newHouseEdge;
347     }
348     
349     // Allow the owner to change the minimum bet
350     // This also allows the owner to temporarily disable the game by setting the
351     // minimum bet to an impossibly high number.
352     function setMinimumBet(uint256 _newMinimumBet) external
353     {
354         require(msg.sender == owner);
355         minimumBet = _newMinimumBet;
356     }
357     
358     // Allow the owner to deposit and withdraw ether
359     // (this contract needs to pay oraclize fees)
360     function depositEther() payable external
361     {
362         require(msg.sender == owner);
363     }
364     function withdrawEther(uint256 _amount) payable external
365     {
366         require(msg.sender == owner);
367         owner.transfer(_amount);
368     }
369     
370     // Allow the owner to make another address the owner
371     function transferOwnership(address _newOwner) external 
372     {
373         require(msg.sender == owner);
374         require(_newOwner != 0x0);
375         owner = _newOwner;
376     }
377     
378     // Allow the owner to withdraw STAKE tokens
379     function withdrawStakeTokens(uint256 _amount) external
380     {
381         require(msg.sender == owner);
382         stakeTokenContract.transfer(owner, _amount);
383     }
384     
385     // Prevent people from losing Ether by accidentally sending it to this contract.
386     function () payable external
387     {
388         revert();
389     }
390     
391 }