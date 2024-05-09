1 /*
2 Welcome to * Bet On Hash *
3 
4 this is a round based bet game
5 a round consists of 6 players
6 
7 you bet on the first byte of the 6th players block hash (unpredictable, 50% chance)
8 
9 ** to join: send one byte data (0x01 or 0x81) with a bet amount of 1 ether to the contract address
10 
11 if your data byte is less than 0x80 you bet the last players block hash first byte is less than 0x80
12 if your data byte is greater than or equal 0x80 you bet the last players block hash first byte is greater than or equal 0x80
13 
14 if you lose your bet your bet amount goes to the pool for winners
15 
16 if you win your bet:
17 	* you will get back 100% of your payment
18 	* you will win a proportional part of the winner pool (win amount = winner pool / winners - 1%) 
19 
20   ** in the best case you can win 4.95 Ether **
21 
22 payout is triggered when a player starts the next round
23 
24 additional rules:
25 each address can only play once per round
26 every additional payment during the same round will be paid back immediatly
27 every payment below the bet value is considered as a donation for the winner pool
28 every amount that is exceeding the bet value will be paid back
29 if nobody wins in a round, the paid amounts will raise the winner pool for the next round
30 
31 ** if you pay to the contract, you agree that you may lose (50% chance!) the paid amount **
32 
33 */
34 
35 contract BetOnHashV84 {
36   struct Player {
37     address addr;
38     byte bet;
39   }
40   
41   Player[] public players;
42   bool public active;
43   uint public betAmount;
44   uint public playersPerRound;
45   uint public round;
46   uint public winPool;
47   byte public betByte;
48 
49   uint lastPlayersBlockNumber;
50   address owner;
51   
52   modifier onlyowner { if (msg.sender == owner) _ }
53   
54   function BetOnHashV84() {
55     owner = msg.sender;
56     betAmount = 1 ether;
57     round = 1;
58     playersPerRound = 6;
59     active = true;
60     winPool = 0;
61   }
62   
63   function finishRound() internal {
64     //get block hash of last player
65     bytes32 betHash = block.blockhash(lastPlayersBlockNumber);
66     betByte = byte(betHash);
67     byte bet;
68     uint8 ix; 
69     
70     //check win or loss, calculate winnPool
71     address[] memory winners = new address[](playersPerRound);
72     uint8 numWinners=0;
73     for(ix=0; ix < players.length; ix++) {
74       Player p = players[ix];
75       if(p.bet < 0x80 && betByte < 0x80 || p.bet >= 0x80 && betByte >= 0x80) {
76         //player won
77         winners[numWinners++] = p.addr;
78       } 
79       else winPool += betAmount;
80     }
81     
82     //calculate winners payouts and pay out
83     if(numWinners > 0) {
84       uint winAmount = (winPool / numWinners) * 99 / 100;
85       for(ix = 0; ix < numWinners; ix++) {
86         if(!winners[ix].send(betAmount + winAmount)) throw;
87       }
88       winPool = 0;
89     }
90     
91     //start next round
92     round++;
93     delete players;
94   }
95   
96   function reject() internal {
97     msg.sender.send(msg.value);
98   }
99   
100   function join() internal {
101     //finish round if next players block is above last players block
102     if(players.length >= playersPerRound) { 
103       if(block.number > lastPlayersBlockNumber) finishRound(); 
104       else {reject(); return;}  //too many players in one block -> pay back
105     }
106 
107     //payments below bet amount are considered as donation for the winner pool
108     if(msg.value < betAmount) {
109       winPool += msg.value; 
110       return;
111     }
112     
113     //no data sent -> pay back
114     if(msg.data.length < 1) {reject();return;}
115     
116     //prevent players to play more than once per round:
117     for(uint8 i = 0; i < players.length; i++)
118       if(msg.sender == players[i].addr) {reject(); return;}
119     
120     //to much paid -> pay back all above bet amount
121     if(msg.value > betAmount) {
122       msg.sender.send(msg.value - betAmount);
123     }
124     
125     //register player
126     players.push( Player(msg.sender, msg.data[0]) );
127     lastPlayersBlockNumber = block.number;
128   }
129   
130   function () {
131     if(active) join();
132     else throw;
133   }
134   
135   function paybackLast() onlyowner returns (bool) {
136     if(players.length == 0) return true;
137     if (players[players.length - 1].addr.send(betAmount)) {
138       players.length--;
139       return true;
140     }
141     return false;
142   }
143   
144   //if something goes wrong, the owner can trigger pay back
145   function paybackAll() onlyowner returns (bool) {
146     while(players.length > 0) {if(!paybackLast()) return false;}
147     return true;
148   }
149   
150   function collectFees() onlyowner {
151     uint playersEther = winPool;
152     uint8 ix;
153     for(ix=0; ix < players.length; ix++) playersEther += betAmount;
154     uint fees = this.balance - playersEther;
155     if(fees > 0) owner.send(fees);
156   }
157   
158   function changeOwner(address _owner) onlyowner {
159     owner = _owner;
160   }
161   
162   function setPlayersPerRound(uint num) onlyowner {
163     if(players.length > 0) finishRound();
164     playersPerRound = num;
165   }
166   
167   function stop() onlyowner {
168     active = false;
169     paybackAll();
170   }
171   
172   function numberOfPlayersInCurrentRound() constant returns (uint count) {
173     count = players.length;
174   }
175 
176   //contract can only be destructed if all payments where paid back  
177   function kill() onlyowner {
178     if(!active && paybackAll()) 
179       selfdestruct(owner);
180   }
181 }