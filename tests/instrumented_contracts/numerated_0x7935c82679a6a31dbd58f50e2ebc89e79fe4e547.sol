1 pragma solidity 0.4.24;
2 
3 // Minimal required STAKE token interface
4 contract StakeToken
5 {
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 }
10 
11 contract StakeDiceGame
12 {
13     // Prevent people from losing Ether by accidentally sending it to this contract.
14     function () payable external
15     {
16         revert();
17     }
18     
19     ///////////////////////////////
20     /////// GAME PARAMETERS
21     
22     StakeDice public stakeDice;
23     
24     // Number between 0 and 10 000. Examples:
25     // 700 indicates 7% chance.
26     // 5000 indicates 50% chance.
27     // 8000 indicates 80% chance.
28     uint256 public winningChance;
29     
30     // Examples of multiplierOnWin() return values:
31     // 10 000 indicates 1x returned.
32     // 13 000 indicated 1.3x returned
33     // 200 000 indicates 20x returned
34     function multiplierOnWin() public view returns (uint256)
35     {
36         uint256 beforeHouseEdge = 10000;
37         uint256 afterHouseEdge = beforeHouseEdge - stakeDice.houseEdge();
38         return afterHouseEdge * 10000 / winningChance;
39     }
40     
41     function maximumBet() public view returns (uint256)
42     {
43         uint256 availableTokens = stakeDice.stakeTokenContract().balanceOf(address(stakeDice));
44         return availableTokens * 10000 / multiplierOnWin() / 5;
45     }
46     
47 
48     
49     ///////////////////////////////
50     /////// OWNER FUNCTIONS
51     
52     // Constructor function
53     // Provide a number between 0 and 10 000 to indicate the winning chance and house edge.
54     constructor(StakeDice _stakeDice, uint256 _winningChance) public
55     {
56         // Ensure the parameters are sane
57         require(_winningChance > 0);
58         require(_winningChance < 10000);
59         require(_stakeDice != address(0x0));
60         require(msg.sender == address(_stakeDice));
61         
62         stakeDice = _stakeDice;
63         winningChance = _winningChance;
64     }
65     
66     // Allow the owner to change the winning chance
67     function setWinningChance(uint256 _newWinningChance) external
68     {
69         require(msg.sender == stakeDice.owner());
70         require(_newWinningChance > 0);
71         require(_newWinningChance < 10000);
72         winningChance = _newWinningChance;
73     }
74     
75     // Allow the owner to withdraw STAKE tokens that
76     // may have been accidentally sent here.
77     function withdrawStakeTokens(uint256 _amount, address _to) external
78     {
79         require(msg.sender == stakeDice.owner());
80         require(_to != address(0x0));
81         stakeDice.stakeTokenContract().transfer(_to, _amount);
82     }
83 }
84 
85 
86 contract StakeDice
87 {
88     ///////////////////////////////
89     /////// GAME PARAMETERS
90     
91     StakeToken public stakeTokenContract;
92     mapping(address => bool) public addressIsStakeDiceGameContract;
93     StakeDiceGame[] public allGames;
94     uint256 public houseEdge;
95     uint256 public minimumBet;
96     
97     //////////////////////////////
98     /////// PLAYER STATISTICS
99     
100     address[] public allPlayers;
101     mapping(address => uint256) public playersToTotalBets;
102     mapping(address => uint256[]) public playersToBetIndices;
103     function playerAmountOfBets(address _player) external view returns (uint256)
104     {
105         return playersToBetIndices[_player].length;
106     }
107     
108     function totalUniquePlayers() external view returns (uint256)
109     {
110         return allPlayers.length;
111     }
112     
113     //////////////////////////////
114     /////// GAME FUNCTIONALITY
115     
116     // Events
117     event BetPlaced(address indexed gambler, uint256 betIndex);
118     event BetWon(address indexed gambler, uint256 betIndex);
119     event BetLost(address indexed gambler, uint256 betIndex);
120     event BetCanceled(address indexed gambler, uint256 betIndex);
121     
122     enum BetStatus
123     {
124         NON_EXISTANT,
125         IN_PROGRESS,
126         WON,
127         LOST,
128         CANCELED
129     }
130     
131     struct Bet
132     {
133         address gambler;
134         uint256 winningChance;
135         uint256 betAmount;
136         uint256 potentialRevenue;
137         uint256 roll;
138         BetStatus status;
139     }
140     
141     Bet[] public bets;
142     uint public betsLength = 0;
143     mapping(bytes32 => uint256) public oraclizeQueryIdsToBetIndices;
144     
145     function betPlaced(address gameContract, uint256 _amount) external
146     {
147         // Only StakeDiceGame contracts are allowed to call this function
148         require(addressIsStakeDiceGameContract[gameContract] == true);
149         
150          // Make sure the bet is within the current limits
151         require(_amount >= minimumBet);
152         require(_amount <= StakeDiceGame(gameContract).maximumBet());
153         
154         // Tranfer the STAKE tokens from the user's account to the StakeDice contract
155         stakeTokenContract.transferFrom(msg.sender, this, _amount);
156         
157         
158         // Calculate how much the gambler might win
159         uint256 potentialRevenue = StakeDiceGame(gameContract).multiplierOnWin() * _amount / 10000;
160         
161         // Store the bet
162         emit BetPlaced(msg.sender, bets.length);
163         playersToBetIndices[msg.sender].push(bets.length);
164         bets.push(Bet({gambler: msg.sender, winningChance: StakeDiceGame(gameContract).winningChance(), betAmount: _amount, potentialRevenue: potentialRevenue, roll: 0, status: BetStatus.IN_PROGRESS}));
165         betsLength +=1;
166         // Update statistics
167         if (playersToTotalBets[msg.sender] == 0)
168         {
169             allPlayers.push(msg.sender);
170         }
171         playersToTotalBets[msg.sender] += _amount;
172         //uint _result = 1; //the random number
173         uint256 betIndex = betsLength;
174         Bet storage bet = bets[betIndex];
175         require(bet.status == BetStatus.IN_PROGRESS);
176         // Now that we have generated a random number, let's use it..
177         uint randomNumber = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%100);
178        
179         // Store the roll in the blockchain permanently
180         bet.roll = randomNumber;
181         
182         // If the random number is smaller than the winningChance, the gambler won!
183         if (randomNumber < bet.winningChance/100)
184         {
185             // If we somehow don't have enough tokens to payout their winnings,
186             // cancel the bet and refund the gambler automatically
187             if (stakeTokenContract.balanceOf(this) < bet.potentialRevenue)
188             {
189                 _cancelBet(betIndex);
190             }
191             
192             // Otherwise, (if we do have enough tokens)
193             else
194             {
195                 // The gambler won!
196                 bet.status = BetStatus.WON;
197             
198                 // Send them their winnings
199                 stakeTokenContract.transfer(bet.gambler, bet.potentialRevenue);
200                 
201                 // Trigger BetWon event
202                 emit BetWon(bet.gambler, betIndex);
203             }
204         }
205         else
206         {
207             // The gambler lost!
208             bet.status = BetStatus.LOST;
209             
210             // Send them the smallest possible token unit as consolation prize
211             // and as notification that their bet has lost.
212             stakeTokenContract.transfer(bet.gambler, 1); // Send 0.00000001 STAKE
213             
214             // Trigger BetLost event
215             emit BetLost(bet.gambler, betIndex);
216         }
217     }
218     
219     function _cancelBet(uint256 _betIndex) private
220     {
221         // Only bets that are in progress can be canceled
222         require(bets[_betIndex].status == BetStatus.IN_PROGRESS);
223         
224         // Store the fact that the bet has been canceled
225         bets[_betIndex].status = BetStatus.CANCELED;
226         
227         // Refund the bet amount to the gambler
228         stakeTokenContract.transfer(bets[_betIndex].gambler, bets[_betIndex].betAmount);
229         
230         // Trigger BetCanceled event
231         emit BetCanceled(bets[_betIndex].gambler, _betIndex);
232         
233         // Subtract the bet from their total
234         playersToTotalBets[bets[_betIndex].gambler] -= bets[_betIndex].betAmount;
235     }
236     
237     function amountOfGames() external view returns (uint256)
238     {
239         return allGames.length;
240     }
241     
242     function amountOfBets() external view returns (uint256)
243     {
244         return bets.length-1;
245     }
246     
247     ///////////////////////////////
248     /////// OWNER FUNCTIONS
249     
250     address public owner;
251     
252     // Constructor function
253     constructor(StakeToken _stakeTokenContract, uint256 _houseEdge, uint256 _minimumBet) public
254     {
255         // Bet indices start at 1 because the values of the
256         // oraclizeQueryIdsToBetIndices mapping are by default 0.
257         bets.length = 1;
258         
259         // Whoever deployed the contract is made owner
260         owner = msg.sender;
261         
262         // Ensure that the arguments are sane
263         require(_houseEdge < 10000);
264         require(_stakeTokenContract != address(0x0));
265         
266         // Store the initializing arguments
267         stakeTokenContract = _stakeTokenContract;
268         houseEdge = _houseEdge;
269         minimumBet = _minimumBet;
270     }
271     
272     // Allow the owner to easily create the default dice games
273     function createDefaultGames() public
274     {
275         require(allGames.length == 0);
276         
277         addNewStakeDiceGame(500); // 5% chance
278         addNewStakeDiceGame(1000); // 10% chance
279         addNewStakeDiceGame(1500); // 15% chance
280         addNewStakeDiceGame(2000); // 20% chance
281         addNewStakeDiceGame(2500); // 25% chance
282         addNewStakeDiceGame(3000); // 30% chance
283         addNewStakeDiceGame(3500); // 35% chance
284         addNewStakeDiceGame(4000); // 40% chance
285         addNewStakeDiceGame(4500); // 45% chance
286         addNewStakeDiceGame(5000); // 50% chance
287         addNewStakeDiceGame(5500); // 55% chance
288         addNewStakeDiceGame(6000); // 60% chance
289         addNewStakeDiceGame(6500); // 65% chance
290         addNewStakeDiceGame(7000); // 70% chance
291         addNewStakeDiceGame(7500); // 75% chance
292         addNewStakeDiceGame(8000); // 80% chance
293         addNewStakeDiceGame(8500); // 85% chance
294         addNewStakeDiceGame(9000); // 90% chance
295         addNewStakeDiceGame(9500); // 95% chance
296     }
297     
298     // Allow the owner to cancel a bet when it's in progress.
299     // This will probably never be needed, but it might some day be needed
300     // to refund people if oraclize is not responding.
301     function cancelBet(uint256 _betIndex) public
302     {
303         require(msg.sender == owner);
304         
305         _cancelBet(_betIndex);
306     }
307     
308     // Allow the owner to add new games with different winning chances
309     function addNewStakeDiceGame(uint256 _winningChance) public
310     {
311         require(msg.sender == owner);
312         
313         // Deploy a new StakeDiceGame contract
314         StakeDiceGame newGame = new StakeDiceGame(this, _winningChance);
315         
316         // Store the fact that this new address is a StakeDiceGame contract
317         addressIsStakeDiceGameContract[newGame] = true;
318         allGames.push(newGame);
319     }
320     
321     // Allow the owner to change the house edge
322     function setHouseEdge(uint256 _newHouseEdge) external
323     {
324         require(msg.sender == owner);
325         require(_newHouseEdge < 10000);
326         houseEdge = _newHouseEdge;
327     }
328     
329     // Allow the owner to change the minimum bet
330     // This also allows the owner to temporarily disable the game by setting the
331     // minimum bet to an impossibly high number.
332     function setMinimumBet(uint256 _newMinimumBet) external
333     {
334         require(msg.sender == owner);
335         minimumBet = _newMinimumBet;
336     }
337     
338     // Allow the owner to deposit and withdraw ether
339     // (this contract needs to pay oraclize fees)
340     function depositEther() payable external
341     {
342         require(msg.sender == owner);
343     }
344     function withdrawEther(uint256 _amount) payable external
345     {
346         require(msg.sender == owner);
347         owner.transfer(_amount);
348     }
349     
350     // Allow the owner to make another address the owner
351     function transferOwnership(address _newOwner) external 
352     {
353         require(msg.sender == owner);
354         require(_newOwner != 0x0);
355         owner = _newOwner;
356     }
357     
358     // Allow the owner to withdraw STAKE tokens
359     function withdrawStakeTokens(uint256 _amount) external
360     {
361         require(msg.sender == owner);
362         stakeTokenContract.transfer(owner, _amount);
363     }
364     
365     // Prevent people from losing Ether by accidentally sending it to this contract.
366     function () payable external
367     {
368         revert();
369     }
370     
371 }