1 pragma solidity ^0.4.18;
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
20 */
21 
22 contract Vitaluck {
23     
24     // Admin
25     address ceoAddress = 0x46d9112533ef677059c430E515775e358888e38b;
26     address cfoAddress = 0x23a49A9930f5b562c6B1096C3e6b5BEc133E8B2E;
27     string MagicKey;
28     uint256 minBetValue = 50000000000000000;
29     uint256 currentJackpot;
30     
31     modifier onlyCeo() {
32         require (msg.sender == ceoAddress);
33         _;
34     }
35     
36     //
37     // Events
38     //
39     
40     event NewPlay(address player, uint number, bool won);
41 
42     //
43     // GAME
44     //
45 
46     struct Bet {
47         uint number;            // The number given to the user
48         bool isWinner;          // Has this bet won the jackpot
49         address player;         // We save the address of the player
50         uint32 timestamp;       // We save the timestamp of this bet
51         uint256 JackpotWon;     // The amount won if the user won the jackpot
52     }
53     Bet[] bets;
54 
55     mapping (address => uint) public ownerBetsCount;    // How many bets have this address made
56 
57     // Stats
58     uint totalTickets;          // The total amount of bets
59     uint256 amountWon;          // The total amount of ETH won by users
60     uint256 amountPlayed;       // The total amount of ETH played by users
61 
62     // The countdown time will be used to reset the winning number after 48 hours if there aren't any new winning number
63     uint cooldownTime = 1 days;
64 
65     // To track the current winner
66     address currentWinningAddress;
67     uint currentWinningNumber;
68     uint currentResetTimer;
69 
70     // Random numbers that can be modified by the CEO to make the game completely random
71     uint randomNumber = 178;
72     uint randomNumber2;
73     
74     function() public payable { 
75         Play();
76     }
77     
78     /*
79     This is the main function of the game. 
80     It is called when a player sends ETH to the contract or play using Metamask.
81     It calculates the amount of tickets bought by the player (according to the amount received by the contract) and generates a random number for each ticket.
82     We keep the best number of all. -> 1 ticket = 0.01 ETH 
83     */
84     function Play() public payable {
85         // We don't run the function if the player paid less than 0.01 ETH
86         require(msg.value >= minBetValue);
87         
88         // If this is the first ticket ever
89         if(totalTickets == 0) {
90             // We save the current Jackpot value
91             totalTickets++;
92             currentJackpot = currentJackpot + msg.value;
93             return;
94         }
95 
96         uint _thisJackpot = currentJackpot;
97         // here we count the number of tickets purchased by the user (each ticket costs 0.01ETH)
98         uint _finalRandomNumber = 0;
99         
100         // We save the current Jackpot value
101         currentJackpot = currentJackpot + msg.value;
102         
103         // We generate a random number for each ticket purchased by the player
104         // Example: 1 ticket costs 0.01 ETH, if a user paid 1 ETH, we will run this function 100 times and save the biggest number of all as its result
105         _finalRandomNumber = (uint(now) - 1 * randomNumber * randomNumber2 + uint(now))%1000 + 1;
106         randomNumber = _finalRandomNumber;
107 
108         // We keep track of the amount played by the users
109         amountPlayed = amountPlayed + msg.value;
110         totalTickets++;
111         ownerBetsCount[msg.sender]++;
112 
113         // We calculate and transfer to the owner a commission of 10%
114         uint256 MsgValue10Percent = msg.value / 10;
115         cfoAddress.transfer(MsgValue10Percent);
116         
117         
118         // We save the current Jackpot value
119         currentJackpot = currentJackpot - MsgValue10Percent;
120 
121         // Now that we have the biggest number of the player we check if this is better than the previous winning number
122         if(_finalRandomNumber > currentWinningNumber) {
123             
124             // we update the cooldown time (when the cooldown time is expired, the owner will be able to reset the game)
125             currentResetTimer = now + cooldownTime;
126 
127             // The player is a winner and wins the jackpot (he/she wins 90% of the balance, we keep some funds for the next game)
128             uint256 JackpotWon = _thisJackpot;
129             
130             msg.sender.transfer(JackpotWon);
131             
132             // We save the current Jackpot value
133             currentJackpot = currentJackpot - JackpotWon;
134         
135             // We keep track of the amount won by the users
136             amountWon = amountWon + JackpotWon;
137             currentWinningNumber = _finalRandomNumber;
138             currentWinningAddress = msg.sender;
139 
140             // We save this bet in the blockchain
141             bets.push(Bet(_finalRandomNumber, true, msg.sender, uint32(now), JackpotWon));
142             NewPlay(msg.sender, _finalRandomNumber, true);
143             
144             // If the user's number is equal to 100 we reset the max number
145             if(_finalRandomNumber >= 900) {
146                 // We reset the winning address and set the current winning number to 1 (the next player will have 99% of chances to win)
147                 currentWinningAddress = address(this);
148                 currentWinningNumber = 1;
149             }
150         } else {
151             // The player is a loser, we transfer 10% of the bet to the current winner and save the rest in the jackpot
152             currentWinningAddress.transfer(MsgValue10Percent);
153         
154             // We save the current Jackpot value
155             currentJackpot = currentJackpot - MsgValue10Percent;
156         
157             // We save this bet in the blockchain
158             bets.push(Bet(_finalRandomNumber, false, msg.sender, uint32(now), 0));
159             NewPlay(msg.sender, _finalRandomNumber, false);
160         }
161     }
162     
163     function TestRandomNumber() public view returns (uint, uint, uint) {
164         uint _randomNumber1;
165         uint _randomNumber2;
166         uint _randomNumber3;
167         
168         _randomNumber1 = (uint(now) - 1 * randomNumber * randomNumber2 + uint(now))%1000 + 1;
169         _randomNumber2 = (uint(now) - 2 * _randomNumber1 * randomNumber2 + uint(now))%1000 + 1;
170         _randomNumber3 = (uint(now) - 3 * _randomNumber2 * randomNumber2 + uint(now))%1000 + 1;
171         
172         return(_randomNumber1,_randomNumber2,_randomNumber3);
173     }
174 
175     /*
176     This function can be called by the contract owner (24 hours after the last game) if the game needs to be reset
177     Example: the last number is 99 but the jackpot is too small for players to want to play.
178     When the owner reset the game it:
179         1. Transfers automatically the remaining jackpot (minus 10% that needs to be kept in the contract for the new jackpot) to the last winner 
180         2. It resets the max number to 5 which will motivate new users to play again
181     
182     It can only be called by the owner 24h after the last winning game.
183     */
184     function manuallyResetGame() public onlyCeo {
185         // We verifiy that 24h have passed since the beginning of the game
186         require(currentResetTimer < now);
187 
188         // The current winning address wins the jackpot (he/she wins 90% of the balance, we keep 10% to fund the next turn)
189         uint256 JackpotWon = currentJackpot - minBetValue;
190         currentWinningAddress.transfer(JackpotWon);
191         
192         // We save the current Jackpot value
193         currentJackpot = currentJackpot - JackpotWon;
194 
195         // We keep track of the amount won by the users
196         amountWon = amountWon + JackpotWon;
197 
198         // We reset the winning address and set the current winning number to 1 (the next player will have 99% of chances to win)
199         currentWinningAddress = address(this);
200         currentWinningNumber = 1;
201     }
202 
203     /*
204     Those functions are useful to return some important data about the game.
205     */
206     function GetCurrentNumbers() public view returns(uint, uint256, uint) {
207         uint _currentJackpot = currentJackpot;
208         return(currentWinningNumber, _currentJackpot, bets.length);
209     }
210     function GetWinningAddress() public view returns(address) {
211         return(currentWinningAddress);
212     }
213     
214     function GetStats() public view returns(uint, uint256, uint256) {
215         return(totalTickets, amountPlayed, amountWon);
216     }
217 
218     // This will returns the data of a bet
219     function GetBet(uint _betId) external view returns (
220         uint number,            // The number given to the user
221         bool isWinner,          // Has this bet won the jackpot
222         address player,         // We save the address of the player
223         uint32 timestamp,       // We save the timestamp of this bet
224         uint256 JackpotWon     // The amount won if the user won the jackpot
225     ) {
226         Bet storage _bet = bets[_betId];
227 
228         number = _bet.number;
229         isWinner = _bet.isWinner;
230         player = _bet.player;
231         timestamp = _bet.timestamp;
232         JackpotWon = _bet.JackpotWon;
233     }
234 
235     // This function will return only the bets id of a certain address
236     function GetUserBets(address _owner) external view returns(uint[]) {
237         uint[] memory result = new uint[](ownerBetsCount[_owner]);
238         uint counter = 0;
239         for (uint i = 0; i < bets.length; i++) {
240           if (bets[i].player == _owner) {
241             result[counter] = i;
242             counter++;
243           }
244         }
245         return result;
246     }
247     // This function will return only the bets id of a certain address
248     function GetLastBetUser(address _owner) external view returns(uint[]) {
249         uint[] memory result = new uint[](ownerBetsCount[_owner]);
250         uint counter = 0;
251         for (uint i = 0; i < bets.length; i++) {
252           if (bets[i].player == _owner) {
253             result[counter] = i;
254             counter++;
255           }
256         }
257         return result;
258     }
259     /*
260     Those functions are useful to modify some values in the game
261     */
262     function modifyRandomNumber2(uint _newRdNum) public onlyCeo {
263         randomNumber2 = _newRdNum;
264     }
265     function modifyCeo(address _newCeo) public onlyCeo {
266         require(msg.sender == ceoAddress);
267         ceoAddress = _newCeo;
268     }
269     function modifyCfo(address _newCfo) public onlyCeo {
270         require(msg.sender == ceoAddress);
271         cfoAddress = _newCfo;
272     }
273 }