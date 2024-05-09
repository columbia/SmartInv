1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  *
6  * EthFastDotHost - profitable financial game
7  * Honest, fully automated smart quick turn contract with a jackpot system
8  *
9  * Web              - http://ethfast.host/
10  * Telegram chat    - https://t.me/ethfastx
11  *
12  *  - Contribution allocation schemes:
13  *    -- 90% players
14  *    -- 5% jackpot
15  *    -- 3.25% promotion
16  *    -- 1.75% support
17  *
18  *  - Limits:
19  *    -- Min deposit: 0.01 ETH
20  *    -- Min deposit for jackpot: 0.05 ETH
21  *    -- Max deposit: 7 ETH
22  *    -- Max gas price: 50 GWEI
23  *
24  * Recommended gas limit: 300000
25  * Recommended gas price: https://ethgasstation.info/
26  *
27  */
28  
29  
30 contract EthFastDotHost {
31 
32     uint constant MINIMAL_DEPOSIT = 0.01 ether; // minimum deposit for participation in the game
33     uint constant MAX_DEPOSIT = 7 ether; // maximum possible deposit
34 
35     uint constant JACKPOT_MINIMAL_DEPOSIT = 0.05 ether; // minimum deposit for jackpot
36     uint constant JACKPOT_DURATION = 20 minutes; // the duration of the jackpot after which the winner will be determined
37 
38     uint constant JACKPOT_PERCENTAGE = 500; // jackpot winner gets 5% of all deposits
39     uint constant PROMOTION_PERCENTAGE = 325; // 3.25% will be sent to the promotion of the project
40     uint constant PAYROLL_PERCENTAGE = 175; // 1.75% will be sent to support the project
41 
42     uint constant MAX_GAS_PRICE = 50; // maximum price for gas in gwei
43 
44     // This address, can set a new block number to start the game.
45     address constant MANAGER = 0x490429e7C4C343B3B069c30625404888Bcc8Eb7b;
46 
47     // Address where ETH will be sent for project promotion
48     address constant SUPPORT_AND_PROMOTION_FUND = 0x490429e7C4C343B3B069c30625404888Bcc8Eb7b;
49 
50     struct Deposit {
51         address member;
52         uint amount;
53     }
54 
55     struct Jackpot {
56         address lastMember;
57         uint time;
58         uint amount;
59     }
60 
61     Deposit[] public deposits; // keeps a history of all deposits
62     Jackpot public jackpot; // stores the data for the current jackpot
63 
64     uint public totalInvested; // how many ETH were collected for this game
65     uint public currentIndex; // current deposit index
66     uint public startBlockNumber; // start block number game. If this value is 0, the contract is temporarily stopped
67 
68     // this function called every time anyone sends a transaction to this contract
69     function () public payable {
70 
71         // the contract can only take ETH when the game is running
72         require(isRunning());
73 
74         // gas price check
75         require(tx.gasprice <= MAX_GAS_PRICE * 1000000000);
76 
77         address member = msg.sender; // address of the current player who sent the ETH
78         uint amount = msg.value; // the amount sent by this player
79 
80         // ckeck to jackpot winner
81         if (now - jackpot.time >= JACKPOT_DURATION && jackpot.time > 0) {
82 
83             send(member, amount); // return this deposit to the sender
84 
85             if (!payouts()) { // send remaining payouts
86                 return;
87             }
88 
89             send(jackpot.lastMember, jackpot.amount); // send jackpot to winner
90             startBlockNumber = 0; // stop queue
91             return;
92         }
93 
94         // deposit check
95         require(amount >= MINIMAL_DEPOSIT && amount <= MAX_DEPOSIT);
96 
97         // add member to jackpot
98         if (amount >= JACKPOT_MINIMAL_DEPOSIT) {
99             jackpot.lastMember = member;
100             jackpot.time = now;
101         }
102 
103         // update variables in storage
104         deposits.push( Deposit(member, amount * calcMultiplier() / 100) );
105         totalInvested += amount;
106         jackpot.amount += amount * JACKPOT_PERCENTAGE / 10000;
107 
108         // send fee
109         send(SUPPORT_AND_PROMOTION_FUND, amount * (PROMOTION_PERCENTAGE + PAYROLL_PERCENTAGE) / 10000);
110 
111         // send payouts
112         payouts();
113 
114     }
115 
116     // This function sends amounts to players who are in the current queue
117     // Returns true if all available ETH is sent
118     function payouts() internal returns(bool complete) {
119 
120         uint balance = address(this).balance;
121 
122         // impossible but better to check
123         balance = balance >= jackpot.amount ? balance - jackpot.amount : 0;
124 
125         uint countPayouts;
126 
127         for (uint i = currentIndex; i < deposits.length; i++) {
128 
129             Deposit storage deposit = deposits[currentIndex];
130 
131             if (balance >= deposit.amount) {
132 
133                 send(deposit.member, deposit.amount);
134                 balance -= deposit.amount;
135                 delete deposits[currentIndex];
136                 currentIndex++;
137                 countPayouts++;
138 
139                 // Maximum of one request can send no more than 15 payments
140                 // This was done so that players could not spend too much gas in 1 transaction
141                 if (countPayouts >= 15) {
142                     break;
143                 }
144 
145             } else {
146 
147                 send(deposit.member, balance);
148                 deposit.amount -= balance;
149                 complete = true;
150                 break;
151 
152             }
153         }
154 
155     }
156 
157     // This function safely sends the ETH by the passed parameters
158     function send(address _receiver, uint _amount) internal {
159 
160         if (_amount > 0 && address(_receiver) != 0) {
161             _receiver.transfer(msg.value);
162         }
163 
164     }
165 
166     // This function makes the game restart on a specific date when it is stopped or in waiting mode
167     // (Available only to managers)
168     function restart(uint _blockNumber) public {
169 
170         require(MANAGER == msg.sender);
171         require(!isRunning());
172         require(_blockNumber >= block.number);
173 
174         currentIndex = deposits.length; // skip investors from old queue
175         startBlockNumber = _blockNumber; // set the block number to start the project
176         totalInvested = 0;
177 
178         delete jackpot;
179 
180     }
181 
182     // Returns true if the game is in stopped mode
183     function isStopped() public view returns(bool) {
184         return startBlockNumber == 0;
185     }
186 
187     // Returns true if the game is in waiting mode
188     function isWaiting() public view returns(bool) {
189         return startBlockNumber > block.number;
190     }
191 
192     // Returns true if the game is in running mode
193     function isRunning() public view returns(bool) {
194         return !isWaiting() && !isStopped();
195     }
196 
197     // How many percent for your deposit to be multiplied at now
198     function calcMultiplier() public view returns (uint) {
199 
200         if (totalInvested <= 75 ether) return 120;
201         if (totalInvested <= 200 ether) return 130;
202         if (totalInvested <= 350 ether) return 135;
203 
204         return 140; // max value
205     }
206 
207     // This function returns all active player deposits in the current queue
208     function depositsOfMember(address _member) public view returns(uint[] amounts, uint[] places) {
209 
210         uint count;
211         for (uint i = currentIndex; i < deposits.length; i++) {
212             if (deposits[i].member == _member) {
213                 count++;
214             }
215         }
216 
217         amounts = new uint[](count);
218         places = new uint[](count);
219 
220         uint id;
221         for (i = currentIndex; i < deposits.length; i++) {
222 
223             if (deposits[i].member == _member) {
224                 amounts[id] = deposits[i].amount;
225                 places[id] = i - currentIndex + 1;
226                 id++;
227             }
228 
229         }
230 
231     }
232 
233     // This function returns detailed information about the current game
234     function stats() public view returns(
235         string status,
236         uint timestamp,
237         uint blockStart,
238         uint timeJackpot,
239         uint queueLength,
240         uint invested,
241         uint multiplier,
242         uint jackpotAmount,
243         address jackpotMember
244     ) {
245 
246         if (isStopped()) {
247             status = "stopped";
248         } else if (isWaiting()) {
249             status = "waiting";
250         } else {
251             status = "running";
252         }
253 
254         if (isWaiting()) {
255             blockStart = startBlockNumber - block.number;
256         }
257 
258         if (now - jackpot.time < JACKPOT_DURATION) {
259             timeJackpot = JACKPOT_DURATION - (now - jackpot.time);
260         }
261 
262         timestamp = now;
263         queueLength = deposits.length - currentIndex;
264         invested = totalInvested;
265         jackpotAmount = jackpot.amount;
266         jackpotMember = jackpot.lastMember;
267         multiplier = calcMultiplier();
268 
269     }
270 
271 }