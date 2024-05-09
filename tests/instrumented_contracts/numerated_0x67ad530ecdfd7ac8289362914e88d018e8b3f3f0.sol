1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Best Multiplier - profitable financial game
6  * Honest, fully automated smart quick turn contract with a jackpot system
7  *
8  * Web              - https://bestmultiplier.biz
9  * Telegram channel - https://t.me/bestMultiplierNews
10  * Telegram chat    - https://t.me/bestMultiplier
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
28 contract BestMultiplier {
29 
30     uint constant MINIMAL_DEPOSIT = 0.01 ether; // minimum deposit for participation in the game
31     uint constant MAX_DEPOSIT = 7 ether; // maximum possible deposit
32 
33     uint constant JACKPOT_MINIMAL_DEPOSIT = 0.05 ether; // minimum deposit for jackpot
34     uint constant JACKPOT_DURATION = 20 minutes; // the duration of the jackpot after which the winner will be determined
35 
36     uint constant JACKPOT_PERCENTAGE = 500; // jackpot winner gets 5% of all deposits
37     uint constant PROMOTION_PERCENTAGE = 325; // 3.25% will be sent to the promotion of the project
38     uint constant PAYROLL_PERCENTAGE = 175; // 1.75% will be sent to support the project
39 
40     uint constant MAX_GAS_PRICE = 50; // maximum price for gas in gwei
41 
42     // These 2 addresses, one of which is a backup, can set a new time to start the game.
43     address constant MANAGER = 0x6dACb074D55909e3a477B926404A3a3A5BeF0d39;
44     address constant RESERVE_MANAGER = 0xE33c7B34c6113Fb066F16660791a0bB38f416cb8;
45 
46     // Address where ETH will be sent for project promotion
47     address constant PROMOTION_FUND = 0x8026F25c6f898b4afE03d05F87e6c2AFeaaC3a3D;
48 
49     // Address where ETH will be sent to support the project
50     address constant SUPPORT_FUND = 0x8a3F4DCb5c59b555a54Ee171c6e98320547Dd4F4;
51 
52     struct Deposit {
53         address member;
54         uint amount;
55     }
56 
57     struct Jackpot {
58         address lastMember;
59         uint time;
60         uint amount;
61     }
62 
63     Deposit[] public deposits; // keeps a history of all deposits
64     Jackpot public jackpot; // stores the data for the current jackpot
65 
66     uint public totalInvested; // how many ETH were collected for this game
67     uint public currentIndex; // current deposit index
68     uint public startTime; // start time game. If this value is 0, the contract is temporarily stopped
69 
70     // this function called every time anyone sends a transaction to this contract
71     function () public payable {
72 
73         // the contract can only take ETH when the game is running
74         require(isRunning());
75 
76         // gas price check
77         require(tx.gasprice <= MAX_GAS_PRICE * 1000000000);
78 
79         address member = msg.sender; // address of the current player who sent the ETH
80         uint amount = msg.value; // the amount sent by this player
81 
82         // ckeck to jackpot winner
83         if (now - jackpot.time >= JACKPOT_DURATION && jackpot.time > 0) {
84 
85             send(member, amount); // return this deposit to the sender
86 
87             if (!payouts()) { // send remaining payouts
88                 return;
89             }
90 
91             send(jackpot.lastMember, jackpot.amount); // send jackpot to winner
92             startTime = 0; // stop queue
93             return;
94         }
95 
96         // deposit check
97         require(amount >= MINIMAL_DEPOSIT && amount <= MAX_DEPOSIT);
98 
99         // add member to jackpot
100         if (amount >= JACKPOT_MINIMAL_DEPOSIT) {
101             jackpot.lastMember = member;
102             jackpot.time = now;
103         }
104 
105         // update variables in storage
106         deposits.push( Deposit(member, amount * calcMultiplier() / 100) );
107         totalInvested += amount;
108         jackpot.amount += amount * JACKPOT_PERCENTAGE / 10000;
109 
110         // send fee
111         send(PROMOTION_FUND, amount * PROMOTION_PERCENTAGE / 10000);
112         send(SUPPORT_FUND, amount * PAYROLL_PERCENTAGE / 10000);
113 
114         // send payouts
115         payouts();
116 
117     }
118 
119     // This function sends amounts to players who are in the current queue
120     // Returns true if all available ETH is sent
121     function payouts() internal returns(bool complete) {
122 
123         uint balance = address(this).balance;
124 
125         // impossible but better to check
126         balance = balance >= jackpot.amount ? balance - jackpot.amount : 0;
127 
128         uint countPayouts;
129 
130         for (uint i = currentIndex; i < deposits.length; i++) {
131 
132             Deposit storage deposit = deposits[currentIndex];
133 
134             if (balance >= deposit.amount) {
135 
136                 send(deposit.member, deposit.amount);
137                 balance -= deposit.amount;
138                 delete deposits[currentIndex];
139                 currentIndex++;
140                 countPayouts++;
141 
142                 // Maximum of one request can send no more than 15 payments
143                 // This was done so that players could not spend too much gas in 1 transaction
144                 if (countPayouts >= 15) {
145                     break;
146                 }
147 
148             } else {
149 
150                 send(deposit.member, balance);
151                 deposit.amount -= balance;
152                 complete = true;
153                 break;
154 
155             }
156         }
157 
158     }
159 
160     // This function safely sends the ETH by the passed parameters
161     function send(address _receiver, uint _amount) internal {
162 
163         if (_amount > 0 && address(_receiver) != 0) {
164             _receiver.send(_amount);
165         }
166 
167     }
168 
169     // This function makes the game restart on a specific date when it is stopped or in waiting mode
170     // (Available only to managers)
171     function restart(uint _time) public {
172 
173         require(MANAGER == msg.sender || RESERVE_MANAGER == msg.sender);
174         require(!isRunning());
175         require(_time >= now + 10 minutes);
176 
177         currentIndex = deposits.length; // skip investors from old queue
178         startTime = _time; // set the time to start the project
179         totalInvested = 0;
180 
181         delete jackpot;
182 
183     }
184 
185     // Returns true if the game is in stopped mode
186     function isStopped() public view returns(bool) {
187         return startTime == 0;
188     }
189 
190     // Returns true if the game is in waiting mode
191     function isWaiting() public view returns(bool) {
192         return startTime > now;
193     }
194 
195     // Returns true if the game is in running mode
196     function isRunning() public view returns(bool) {
197         return !isWaiting() && !isStopped();
198     }
199 
200     // How many percent for your deposit to be multiplied at now
201     function calcMultiplier() public view returns (uint) {
202 
203         if (totalInvested <= 75 ether) return 120;
204         if (totalInvested <= 200 ether) return 130;
205         if (totalInvested <= 350 ether) return 135;
206 
207         return 140; // max value
208     }
209 
210     // This function returns all active player deposits in the current queue
211     function depositsOfMember(address _member) public view returns(uint[] amounts, uint[] places) {
212 
213         uint count;
214         for (uint i = currentIndex; i < deposits.length; i++) {
215             if (deposits[i].member == _member) {
216                 count++;
217             }
218         }
219 
220         amounts = new uint[](count);
221         places = new uint[](count);
222 
223         uint id;
224         for (i = currentIndex; i < deposits.length; i++) {
225 
226             if (deposits[i].member == _member) {
227                 amounts[id] = deposits[i].amount;
228                 places[id] = i - currentIndex + 1;
229                 id++;
230             }
231 
232         }
233 
234     }
235 
236     // This function returns detailed information about the current game
237     function stats() public view returns(
238         string status,
239         uint timestamp,
240         uint timeStart,
241         uint timeJackpot,
242         uint queueLength,
243         uint invested,
244         uint multiplier,
245         uint jackpotAmount,
246         address jackpotMember
247     ) {
248 
249         if (isStopped()) {
250             status = "stopped";
251         } else if (isWaiting()) {
252             status = "waiting";
253         } else {
254             status = "running";
255         }
256 
257         if (isWaiting()) {
258             timeStart = startTime - now;
259         }
260 
261         if (now - jackpot.time < JACKPOT_DURATION) {
262             timeJackpot = JACKPOT_DURATION - (now - jackpot.time);
263         }
264 
265         timestamp = now;
266         queueLength = deposits.length - currentIndex;
267         invested = totalInvested;
268         jackpotAmount = jackpot.amount;
269         jackpotMember = jackpot.lastMember;
270         multiplier = calcMultiplier();
271 
272     }
273 
274 }