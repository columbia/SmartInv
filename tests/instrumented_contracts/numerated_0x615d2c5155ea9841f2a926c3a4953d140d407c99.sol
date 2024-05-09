1 // Welcome to * Bet On Hash *
2 //
3 // this is a round based bet game
4 // a round consists of 6 players
5 // 
6 // you bet on the first byte of the last (6th) players blockhash (unpredictable, 50% chance)
7 // 
8 // ** to join: send one byte data (0x01 or 0x81) with a bet amount of 0.01 ether (10 finney) to the contract address
9 // 
10 // if your data byte is less than 0x80 you bet the blockhashs first byte is < 0x80
11 // if your data byte is greater than or equal 0x80 you bet the blockhashs first byte is >= 0x80
12 // 
13 // if you lose your bet your bet amount goes to the pool for winners
14 // 
15 // if you win your bet:
16 // 	* you will get back 100% of your payment
17 // 	* you will win a proportional part of the winner pool (win amount = winner pool / winners - 1%) 
18 // 
19 // payout is triggered when a player starts the next round
20 // 
21 // additional rules:
22 // each address can only play once per round
23 // every additional payment during the same round will be paid back immediatly
24 // every payment below the bet value is considered as a donation for the winner pool
25 // every amount that is exceeding the bet value will be paid back
26 // if nobody wins in a round, the paid amounts will raise the winner pool for the next round
27 //
28 // ** if you pay to the contract, you agree that you may lose (50% chance!) the paid amount **
29 
30 
31 contract BetOnHashV82 {
32   struct Player {
33     address addr;
34     byte bet;
35   }
36   
37   Player[] public players;
38   bool public active;
39   uint public betAmount;
40   uint public playersPerRound;
41   uint public round;
42   uint public winPool;
43   byte public betByte;
44 
45   uint lastPlayersBlockNumber;
46   address owner;
47   
48   modifier onlyowner { if (msg.sender == owner) _ }
49   
50   function BetOnHashV82() {
51     owner = msg.sender;
52     betAmount = 10 finney;
53     round = 1;
54     playersPerRound = 6;
55     active = true;
56     winPool = 0;
57   }
58   
59   function finishRound() internal {
60     //get block hash of last player
61     bytes32 betHash = block.blockhash(lastPlayersBlockNumber);
62     betByte = byte(betHash);
63     byte bet;
64     uint8 ix; 
65     
66     //check win or loss, calculate winnPool
67     address[] memory winners = new address[](playersPerRound);
68     uint8 numWinners=0;
69     for(ix=0; ix < players.length; ix++) {
70       Player p = players[ix];
71       if(p.bet < 0x80 && betByte < 0x80 || p.bet >= 0x80 && betByte >= 0x80) {
72         //player won
73         winners[numWinners++] = p.addr;
74       } 
75       else winPool += betAmount;
76     }
77     
78     //calculate winners payouts and pay out
79     if(numWinners > 0) {
80       uint winAmount = (winPool / numWinners) * 99 / 100;
81       for(ix = 0; ix < numWinners; ix++) {
82         if(!winners[ix].send(betAmount + winAmount)) throw;
83       }
84       winPool = 0;
85     }
86     
87     //start next round
88     round++;
89     delete players;
90   }
91   
92   function reject() internal {
93     msg.sender.send(msg.value);
94   }
95   
96   function join() internal {
97   
98     //finish round if next players block is above last players block
99     if(players.length >= playersPerRound) { 
100       if(block.number > lastPlayersBlockNumber) finishRound(); 
101       else {reject(); return;}  //too many players in one block -> pay back
102     }
103 
104     //payments below bet amount are considered as donation for the winner pool
105     if(msg.value < betAmount) {
106       winPool += msg.value; 
107       return;
108     }
109     
110     //no data sent -> pay back
111     if(msg.data.length < 1) {reject();return;}
112     
113     //prevent players to play more than once per round:
114     for(uint8 i = 0; i < players.length; i++)
115       if(msg.sender == players[i].addr) {reject(); return;}
116     
117     //to much paid -> pay back all above bet amount
118     if(msg.value > betAmount) {
119       msg.sender.send(msg.value - betAmount);
120     }
121     
122     //register player
123     players.push( Player(msg.sender, msg.data[0]) );
124     lastPlayersBlockNumber = block.number;
125   }
126   
127   function () {
128     if(active) join();
129     else throw;
130   }
131   
132   function forceFinish() onlyowner {
133     if(players.length > 0) finishRound();
134   }
135   
136   function paybackLast() onlyowner returns (bool) {
137     if(players.length == 0) return true;
138     if (players[players.length - 1].addr.send(betAmount)) {
139       players.length--;
140       return true;
141     }
142     return false;
143   }
144   
145   //if something goes wrong, the owner can trigger pay back
146   function paybackAll() onlyowner returns (bool) {
147     while(players.length > 0) {if(!paybackLast()) return false;}
148     return true;
149   }
150   
151   function collectFees() onlyowner {
152     uint playersEther = winPool;
153     uint8 ix;
154     for(ix=0; ix < players.length; ix++) playersEther += betAmount;
155     uint fees = this.balance - playersEther;
156     if(fees > 0) owner.send(fees);
157   }
158   
159   function changeOwner(address _owner) onlyowner {
160     owner = _owner;
161   }
162   
163   function setPlayersPerRound(uint num) onlyowner {
164     if(players.length > 0) finishRound();
165     playersPerRound = num;
166   }
167   
168   function stop() onlyowner {
169     active = false;
170     paybackAll();
171   }
172 
173   //contract can only be destructed if all payments where paid back  
174   function kill() onlyowner {
175     if(!active && paybackAll()) 
176       selfdestruct(owner);
177   }
178 }