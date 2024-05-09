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
22  *
23  * Recommended gas limit: 300000
24  * Recommended gas price: https://ethgasstation.info/
25  *
26  */
27 contract BestMultiplier {
28 
29     uint constant MINIMAL_DEPOSIT = 0.01 ether; // minimum deposit for participation in the game
30     uint constant MAX_DEPOSIT = 7 ether; // maximum possible deposit
31 
32     uint constant JACKPOT_MINIMAL_DEPOSIT = 0.05 ether; // minimum deposit for jackpot
33     uint constant JACKPOT_DURATION = 20 minutes; // the duration of the jackpot after which the winner will be determined
34 
35     uint constant JACKPOT_PERCENTAGE = 500; // jackpot winner gets 5% of all deposits
36     uint constant PROMOTION_PERCENTAGE = 325; // 3.25% will be sent to the promotion of the project
37     uint constant PAYROLL_PERCENTAGE = 175; // 1.75% will be sent to support the project
38 
39     // These 2 addresses, one of which is a backup, can set a new time to start the game.
40     address constant MANAGER = 0x6dACb074D55909e3a477B926404A3a3A5BeF0d39;
41     address constant RESERVE_MANAGER = 0xE33c7B34c6113Fb066F16660791a0bB38f416cb8;
42 
43     // Address where ETH will be sent for project promotion
44     address constant PROMOTION_FUND = 0x8026F25c6f898b4afE03d05F87e6c2AFeaaC3a3D;
45 
46     // Address where ETH will be sent to support the project
47     address constant SUPPORT_FUND = 0x8a3F4DCb5c59b555a54Ee171c6e98320547Dd4F4;
48 
49     struct Deposit {
50         address member;
51         uint amount;
52     }
53 
54     struct Jackpot {
55         address lastMember;
56         uint time;
57         uint amount;
58     }
59 
60     Deposit[] public deposits; // keeps a history of all deposits
61     Jackpot public jackpot; // stores the data for the current jackpot
62 
63     uint public totalInvested; // how many ETH were collected for this game
64     uint public currentIndex; // current deposit index
65     uint public startTime; // start time game. If this value is 0, the contract is temporarily stopped
66 
67     // this function called every time anyone sends a transaction to this contract
68     function () public payable {
69 
70         // the contract can only take ETH when the game is running
71         require(isRunning());
72 
73         address member = msg.sender; // address of the current player who sent the ETH
74         uint amount = msg.value; // the amount sent by this player
75 
76         // ckeck to jackpot winner
77         if (now - jackpot.time >= JACKPOT_DURATION && jackpot.time > 0) {
78 
79             send(member, amount); // return this deposit to the sender
80 
81             if (!payouts()) { // send remaining payouts
82                 return;
83             }
84 
85             send(jackpot.lastMember, jackpot.amount); // send jackpot to winner
86             startTime = 0; // stop queue
87             return;
88         }
89 
90         // deposit check
91         require(amount >= MINIMAL_DEPOSIT && amount <= MAX_DEPOSIT);
92 
93         // add member to jackpot
94         if (amount >= JACKPOT_MINIMAL_DEPOSIT) {
95             jackpot.lastMember = member;
96             jackpot.time = now;
97         }
98 
99         // update variables in storage
100         deposits.push( Deposit(member, amount * calcMultiplier() / 100) );
101         totalInvested += amount;
102         jackpot.amount += amount * JACKPOT_PERCENTAGE / 10000;
103 
104         // send fee
105         send(PROMOTION_FUND, amount * PROMOTION_PERCENTAGE / 10000);
106         send(SUPPORT_FUND, amount * PAYROLL_PERCENTAGE / 10000);
107 
108         // send payouts
109         payouts();
110 
111     }
112 
113     // This function sends amounts to players who are in the current queue
114     // Returns true if all available ETH is sent
115     function payouts() internal returns(bool complete) {
116 
117         uint balance = address(this).balance;
118 
119         // impossible but better to check
120         balance = balance >= jackpot.amount ? balance - jackpot.amount : 0;
121 
122         uint countPayouts;
123 
124         for (uint i = currentIndex; i < deposits.length; i++) {
125 
126             Deposit storage deposit = deposits[currentIndex];
127 
128             if (balance >= deposit.amount) {
129 
130                 send(deposit.member, deposit.amount);
131                 balance -= deposit.amount;
132                 delete deposits[currentIndex];
133                 currentIndex++;
134                 countPayouts++;
135 
136                 // Maximum of one request can send no more than 15 payments
137                 // This was done so that players could not spend too much gas in 1 transaction
138                 if (countPayouts >= 15) {
139                     break;
140                 }
141 
142             } else {
143 
144                 send(deposit.member, balance);
145                 deposit.amount -= balance;
146                 complete = true;
147                 break;
148 
149             }
150         }
151 
152     }
153 
154     // This function safely sends the ETH by the passed parameters
155     function send(address _receiver, uint _amount) internal {
156 
157         if (_amount > 0 && address(_receiver) != 0) {
158             _receiver.send(_amount);
159         }
160 
161     }
162 
163     // This function makes the game restart on a specific date when it is stopped or in waiting mode
164     // (Available only to managers)
165     function restart(uint _time) public {
166 
167         require(MANAGER == msg.sender || RESERVE_MANAGER == msg.sender);
168         require(!isRunning());
169         require(_time >= now + 10 minutes);
170 
171         currentIndex = deposits.length; // skip investors from old queue
172         startTime = _time; // set the time to start the project
173         totalInvested = 0;
174 
175         delete jackpot;
176 
177     }
178 
179     // Returns true if the game is in stopped mode
180     function isStopped() public view returns(bool) {
181         return startTime == 0;
182     }
183 
184     // Returns true if the game is in waiting mode
185     function isWaiting() public view returns(bool) {
186         return startTime > now;
187     }
188 
189     // Returns true if the game is in running mode
190     function isRunning() public view returns(bool) {
191         return !isWaiting() && !isStopped();
192     }
193 
194     // How many percent for your deposit to be multiplied at now
195     function calcMultiplier() public view returns (uint) {
196 
197         if (totalInvested <= 75 ether) return 120;
198         if (totalInvested <= 200 ether) return 130;
199         if (totalInvested <= 350 ether) return 135;
200 
201         return 140; // max value
202     }
203 
204     // This function returns all active player deposits in the current queue
205     function depositsOfMember(address _member) public view returns(uint[] amounts, uint[] places) {
206 
207         uint count;
208         for (uint i = currentIndex; i < deposits.length; i++) {
209             if (deposits[i].member == _member) {
210                 count++;
211             }
212         }
213 
214         amounts = new uint[](count);
215         places = new uint[](count);
216 
217         uint id;
218         for (i = currentIndex; i < deposits.length; i++) {
219 
220             if (deposits[i].member == _member) {
221                 amounts[id] = deposits[i].amount;
222                 places[id] = i - currentIndex + 1;
223                 id++;
224             }
225 
226         }
227 
228     }
229 
230     // This function returns detailed information about the current game
231     function stats() public view returns(
232         string status,
233         uint timestamp,
234         uint timeStart,
235         uint timeJackpot,
236         uint queueLength,
237         uint invested,
238         uint multiplier,
239         uint jackpotAmount,
240         address jackpotMember
241     ) {
242 
243         if (isStopped()) {
244             status = "stopped";
245         } else if (isWaiting()) {
246             status = "waiting";
247         } else {
248             status = "running";
249         }
250 
251         if (isWaiting()) {
252             timeStart = startTime - now;
253         }
254 
255         if (now - jackpot.time < JACKPOT_DURATION) {
256             timeJackpot = JACKPOT_DURATION - (now - jackpot.time);
257         }
258 
259         timestamp = now;
260         queueLength = deposits.length - currentIndex;
261         invested = totalInvested;
262         jackpotAmount = jackpot.amount;
263         jackpotMember = jackpot.lastMember;
264         multiplier = calcMultiplier();
265 
266     }
267 
268 }