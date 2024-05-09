1 pragma solidity ^0.4.24;
2 
3 /*
4  _    _      _                              _        
5 | |  | |    | |                            | |       
6 | |  | | ___| | ___ ___  _ __ ___   ___    | |_ ___  
7 | |/\| |/ _ | |/ __/ _ \| '_ ` _ \ / _ \   | __/ _ \ 
8 \  /\  |  __| | (_| (_) | | | | | |  __/   | || (_) |
9  \/  \/ \___|_|\___\___/|_| |_| |_|\___|    \__\___/            
10 
11 
12 $$\    $$\ $$\   $$\               $$\                     $$\       
13 $$ |   $$ |\__|  $$ |              $$ |                    $$ |      
14 $$ |   $$ |$$\ $$$$$$\    $$$$$$\  $$ |$$\   $$\  $$$$$$$\ $$ |  $$\ 
15 \$$\  $$  |$$ |\_$$  _|   \____$$\ $$ |$$ |  $$ |$$  _____|$$ | $$  |
16  \$$\$$  / $$ |  $$ |     $$$$$$$ |$$ |$$ |  $$ |$$ /      $$$$$$  / 
17   \$$$  /  $$ |  $$ |$$\ $$  __$$ |$$ |$$ |  $$ |$$ |      $$  _$$<  
18    \$  /   $$ |  \$$$$  |\$$$$$$$ |$$ |\$$$$$$  |\$$$$$$$\ $$ | \$$\ 
19     \_/    \__|   \____/  \_______|\__| \______/  \_______|\__|  \__|
20 
21 
22 This is the main contract for the Vitaluck button game. 
23 You can access it here: https://vitaluck.com
24 */
25 
26 contract Vitaluck {
27     
28     //
29     // Admin
30     //
31 
32     address ownerAddress = 0x3dcd6f0d7860f93b8bb7d6dcb85346c814243d63;
33     address cfoAddress = 0x5b665218efCE2a15BD64Bd1dE50a27286f456863;
34     
35     modifier onlyCeo() {
36         require (msg.sender == ownerAddress);
37         _;
38     }
39     
40     //
41     // Events
42     //
43     
44     event NewPress(address player, uint countPress, uint256 pricePaid, uint32 _timerEnd);
45 
46     //
47     // Game
48     //
49 
50     uint countPresses;
51     uint256 countInvestorDividends;
52 
53     uint amountPlayed;
54 
55     uint32 timerEnd;                                        // The timestamp for the end after this time stamp, the winner can withdraw its reward
56     uint32 timerInterval = 21600;                           // We set the interval of 3h
57 
58     address winningAddress;
59     uint256 buttonBasePrice = 20000000000000000;              // This is the current price for a button press (this is updated every 100 presses)
60     uint256 buttonPriceStep = 2000000000000000;
61     //
62     // Mapping for the players
63     //
64     struct Player {
65         address playerAddress;                              // We save the address of the player
66         uint countVTL;                                      // The count of VTL Tokens (should be the same as the count of presses)
67     }
68     Player[] players;
69     mapping (address => uint) public playersToId;      // We map the player address to its id to make it easier to retrieve
70 
71     //
72     // Core
73     //
74 
75     // This function is called when a player sends ETH directly to the contract
76     function() public payable {
77         // We calculate the correct amount of presses
78         uint _countPress = msg.value / getButtonPrice();
79         
80         // We call the function
81         Press(_countPress, 0);
82     }
83         
84     // We use this function to initially fund the contract
85     function FundContract() public payable {
86         
87     }
88     
89     // This function is being called when a user presses the button on the website (or call it directly from the contract)
90     function Press(uint _countPresses, uint _affId) public payable {
91         // We verify that the _countPress value is not < 1
92         require(_countPresses >= 1);
93         
94         // We double check that the players aren't trying to send small amount of ETH to press the button
95         require(msg.value >= buttonBasePrice);
96         
97         // We verify that the game is not finished.
98         require(timerEnd > now);
99 
100         // We verify that the value paid is correct.
101         uint256 _buttonPrice = getButtonPrice();
102         require(msg.value >= safeMultiply(_buttonPrice, _countPresses));
103 
104         // Process the button press
105         timerEnd = uint32(now + timerInterval);
106         winningAddress = msg.sender;
107 
108         // Transfer the commissions to affiliate, investor, pot and dev
109         uint256 TwoPercentCom = (msg.value / 100) * 2;
110         uint256 TenPercentCom = msg.value / 10;
111         uint256 FifteenPercentCom = (msg.value / 100) * 15;
112         
113 
114         // Commission #1. Affiliate
115         if(_affId > 0 && _affId < players.length) {
116             // If there is an affiliate we transfer his commission otherwise we keep the commission in the pot
117             players[_affId].playerAddress.transfer(TenPercentCom);
118         }
119         // Commission #2. Main investor
120         uint[] memory mainInvestors = GetMainInvestor();
121         uint mainInvestor = mainInvestors[0];
122         players[mainInvestor].playerAddress.transfer(FifteenPercentCom);
123         countInvestorDividends = countInvestorDividends + FifteenPercentCom;
124         
125         // Commission #3. 2 to 10 main investors
126         // We loop through all of the top 10 investors and send them their commission
127         for(uint i = 1; i < mainInvestors.length; i++) {
128             if(mainInvestors[i] != 0) {
129                 uint _investorId = mainInvestors[i];
130                 players[_investorId].playerAddress.transfer(TwoPercentCom);
131                 countInvestorDividends = countInvestorDividends + TwoPercentCom;
132             }
133         }
134 
135         // Commission #4. Dev
136         cfoAddress.transfer(FifteenPercentCom);
137 
138         // Update or create the player and issue the VTL Tokens
139         if(playersToId[msg.sender] > 0) {
140             // Player exists, update data
141             players[playersToId[msg.sender]].countVTL = players[playersToId[msg.sender]].countVTL + _countPresses;
142         } else {
143             // Player doesn't exist create it
144             uint playerId = players.push(Player(msg.sender, _countPresses)) - 1;
145             playersToId[msg.sender] = playerId;
146         }
147 
148         // Send event
149         emit NewPress(msg.sender, _countPresses, msg.value, timerEnd);
150         
151         // Increment the total count of presses
152         countPresses = countPresses + _countPresses;
153         amountPlayed = amountPlayed + msg.value;
154     }
155 
156     // This function can be called only by the winner once the timer has ended
157     function withdrawReward() public {
158         // We verify that the game has ended and that the address asking for the withdraw is the winning address
159         require(timerEnd < now);
160         require(winningAddress == msg.sender);
161         
162         // Send the balance to the winning player
163         winningAddress.transfer(address(this).balance);
164     }
165     
166     // This function returns the details for the players by id (instead of by address)
167     function GetPlayer(uint _id) public view returns(address, uint) {
168         return(players[_id].playerAddress, players[_id].countVTL);
169     }
170     
171     // Return the player id and the count of VTL for the connected player
172     function GetPlayerDetails(address _address) public view returns(uint, uint) {
173         uint _playerId = playersToId[_address];
174         uint _countVTL = 0;
175         if(_playerId > 0) {
176             _countVTL = players[_playerId].countVTL;
177         }
178         return(_playerId, _countVTL);
179     }
180 
181     // We loop through all of the players to get the main investor (the one with the largest amount of VTL Token)
182     function GetMainInvestor() public view returns(uint[]) {
183         uint depth = 10;
184         bool[] memory _checkPlayerInRanking = new bool[] (players.length);
185         
186         uint[] memory curWinningVTLAmount = new uint[] (depth);
187         uint[] memory curWinningPlayers = new uint[] (depth);
188         
189         // Loop through the depth to find the player for each rank
190         for(uint j = 0; j < depth; j++) {
191             // We reset some value
192             curWinningVTLAmount[j] = 0;
193             
194             // We loop through all of the players
195             for (uint8 i = 0; i < players.length; i++) {
196                 // Iterate through players and insert the current best at the correct position
197                 if(players[i].countVTL > curWinningVTLAmount[j] && _checkPlayerInRanking[i] != true) {
198                     curWinningPlayers[j] = i;
199                     curWinningVTLAmount[j] = players[i].countVTL;
200                 }
201             }
202             // We record that this player is in the ranking to make sure we don't integrate it multiple times in the ranking
203             _checkPlayerInRanking[curWinningPlayers[j]] = true;
204         }
205 
206         // We return the winning player
207         return(curWinningPlayers);
208     }
209     
210     // This function returns the current important stats of the game such as the timer, current balance and current winner, the current press prices...
211     function GetCurrentNumbers() public view returns(uint, uint256, address, uint, uint256, uint256, uint256) {
212         return(timerEnd, address(this).balance, winningAddress, countPresses, amountPlayed, getButtonPrice(), countInvestorDividends);
213     }
214     
215     // This is the initial function called when we create the contract 
216     constructor() public onlyCeo {
217         timerEnd = uint32(now + timerInterval);
218         winningAddress = ownerAddress;
219         
220         // We create the initial player to avoid any bugs
221         uint playerId = players.push(Player(0x0, 0)) - 1;
222         playersToId[msg.sender] = playerId;
223     }
224     
225     // This function returns the current price of the button according to the amount pressed.
226     function getButtonPrice() public view returns(uint256) {
227         // Get price multiplier according to the amount of presses
228         uint _multiplier = 0;
229         if(countPresses > 100) {
230             _multiplier = buttonPriceStep * (countPresses / 100);
231         }
232         
233         // Calculate final button price
234         uint256 _buttonPrice = buttonBasePrice + _multiplier;
235         return(_buttonPrice);
236         
237     }
238     
239     //
240     // Safe Math
241     //
242 
243      // Guards against integer overflows.
244     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
245         if (a == 0) {
246             return 0;
247         } else {
248             uint256 c = a * b;
249             assert(c / a == b);
250             return c;
251         }
252     }
253     
254 }