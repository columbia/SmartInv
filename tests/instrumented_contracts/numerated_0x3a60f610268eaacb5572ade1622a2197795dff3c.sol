1 // SPDX-License-Identifier: NONE
2 // © mia.bet
3 pragma solidity 0.7.3;
4 
5 contract owned {
6     address payable public owner;
7     constructor() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner, "Only owner can call this function.");
13         _;
14     }
15 }
16 
17 /**
18  * @author The Mia.bet team
19  * @title Bet processing contract for mia.bet
20  */
21 contract MultiPot is owned {
22     enum Color {red, green, blue, yellow, white, orange, black}
23     enum State {seeding, accepting_bets, race_in_progress, paying_out, refunding}
24     Color public lastWinningColor;
25     State public current_state;
26     uint8 constant public numPots = 7;
27     uint16 public workoutTresholdMeters = 2000;
28     uint32 public workoutDeziMeters = 0;
29     uint32 public round = 0;
30     uint64 public roundStartTime = 0;
31     uint public minimumBetAmount = 1000000 gwei; // 0.001 ether
32 
33     struct Pot {
34         uint amount;
35         address payable[] uniqueGamblers;
36         mapping (address => uint) stakes;
37     }
38 
39     mapping (uint => Pot) pots;
40 
41 
42     /**
43      * state: seeding
44      */
45 
46     function setMinimumBetAmount(uint amount) external onlyOwner {
47         require(current_state == State.seeding, "Not possible in current state");
48         minimumBetAmount = amount;
49     }
50 
51     function setWorkoutThresholdMeters(uint16 meters) external onlyOwner {
52         require(current_state == State.seeding, "Not possible in current state");
53         workoutTresholdMeters = meters;
54     }
55 
56     function kill() external onlyOwner {
57         require(current_state == State.seeding, "Not possible in current state");
58         selfdestruct(owner);
59     }
60 
61     function startNewRound(uint seedAmount) internal {
62         roundStartTime = uint64(block.timestamp); // security/no-block-members: see remark at the bottom
63         round += 1;
64         workoutDeziMeters = 0;
65         emit RoundStarted(round, seedAmount);
66     }
67 
68     function seedPots() external payable onlyOwner {
69         require(current_state == State.seeding, "Not possible in current state");
70         require(msg.value >= numPots * 1 wei, "Pots must not have amount 0");
71         uint offset = numPots * round;
72         delete pots[offset + uint8(Color.red)];
73         delete pots[offset + uint8(Color.green)];
74         delete pots[offset + uint8(Color.blue)];
75         delete pots[offset + uint8(Color.yellow)];
76         delete pots[offset + uint8(Color.white)];
77         delete pots[offset + uint8(Color.orange)];
78         delete pots[offset + uint8(Color.black)];
79         startNewRound(msg.value);
80         offset = offset + numPots;
81         uint seedAmount = msg.value / numPots;
82         for(uint8 j = 0; j < numPots; j++) {
83            pots[offset + j].amount = seedAmount;
84         }
85         transitionTo(State.accepting_bets);
86     }
87 
88 
89     /**
90      * state: accepting_bets
91      */
92 
93     function placeBet(Color potColor, uint32 bet_round) external payable {
94         require(current_state == State.accepting_bets, "Game has not started yet or a race is already in progress.");
95         require(round == bet_round, "Bets can only be placed for the current round.");
96         require(msg.value >= minimumBetAmount, "Your bet must be greater than or equal to the minimum bet amount.");
97         address payable gambler = msg.sender;
98         Pot storage pot = pots[uint8(potColor) + numPots * round];
99         if (pot.stakes[gambler] == 0) {
100             pot.uniqueGamblers.push(gambler);
101         }
102         pot.stakes[gambler] += msg.value;
103         pot.amount += msg.value;
104         emit BetPlaced(potColor, msg.value);
105     }
106 
107     function miaFinishedWorkout(uint32 dezi_meters) external onlyOwner {
108         require(current_state == State.accepting_bets, "Not possible in current state");
109         emit HamsterRan(dezi_meters);
110         workoutDeziMeters += dezi_meters;
111 
112         if (workoutDeziMeters / 10 >= workoutTresholdMeters) {
113             transitionTo(State.race_in_progress);
114             emit RaceStarted(round);
115         }
116     }
117 
118 
119     /**
120      * state: race_in_progress
121      */
122 
123     function setWinningMarble(Color color, uint64 video_id, string calldata photo_id) external onlyOwner {
124         require(current_state == State.race_in_progress, "Not possible in current state");
125         lastWinningColor = color;
126         emit WinnerChosen(round, color, video_id, photo_id);
127         transitionTo(State.paying_out);
128     }
129 
130 
131     /**
132      * state: paying_out
133      */
134 
135     function payoutWinners() external returns (uint pendingPayouts) {
136         require(current_state == State.paying_out, "Not possible in current state.");
137         Pot storage winningPot = pots[uint8(lastWinningColor) + numPots * round];
138         uint totalPayoutAmount = 0;
139         for(uint8 j = 0; j < numPots; j++) {
140             // sum up original payout amount (self.balance changes during payouts)
141             totalPayoutAmount += pots[j + numPots * round].amount;
142         }
143         totalPayoutAmount = totalPayoutAmount * 80 / 100; // 20% house fee
144         uint winningPotAmount = winningPot.amount;
145         for(uint i = winningPot.uniqueGamblers.length; i >= 1; i--) {
146             address payable gambler = winningPot.uniqueGamblers[i - 1];
147             winningPot.uniqueGamblers.pop();
148             uint stake = winningPot.stakes[gambler];
149             /* profit = totalPayoutAmount * (stake / winningPotAmount)
150                but do the multiplication before the division: */
151             uint profit = totalPayoutAmount * stake / winningPotAmount;
152             profit = profit >= stake ? profit : stake; // ensure no loss for player (reduces house profit)
153             winningPot.stakes[gambler] = 0; // checks-effects-interactions pattern
154             if (gambler.send(profit)) { // security/no-send: see remark at the bottom
155                 emit PayoutSuccessful(gambler, profit, round);
156             } else {
157                 emit PayoutFailed(gambler, profit, round);
158             }
159             if(!(gasleft() > 26000)) {
160                 pendingPayouts = i - 1;
161                 break;
162             }
163         }
164 
165         assert(current_state == State.paying_out);
166         if(gasleft() > 400000) { // 400_000 gas for 7 pots
167             // payout house fee
168             owner.transfer(address(this).balance);
169             emit WinnersPaid(round, totalPayoutAmount, lastWinningColor, winningPotAmount);
170             // transition to next state
171             transitionTo(State.seeding);
172         }
173         return pendingPayouts;
174     }
175 
176 
177     /**
178      * state: refunding
179      */
180 
181     function claimRefund() external {
182         require(block.timestamp > roundStartTime + 2 days, "Only possible 2 day after round started."); // security/no-block-members: see remark at the bottom
183         require(current_state == State.accepting_bets || current_state == State.race_in_progress, "Not possible in current state.");
184         transitionTo(State.refunding);
185     }
186 
187     function refundAll() external returns (uint pendingRefunds) {
188         require(current_state == State.refunding, "Only possible after a successful claimRefund()");
189         for(uint8 i = 0; i < numPots; i++) {
190            pendingRefunds = refundPot(pots[i + numPots * round]);
191            if (pendingRefunds != 0) break;
192         }
193         assert(current_state == State.refunding); // assure no state changes in re-entrancy attacks
194         if (pendingRefunds == 0) {
195             transitionTo(State.seeding);
196         }
197         return pendingRefunds;
198     }
199 
200     function refundPot(Pot storage pot) internal returns (uint pendingRefunds) {
201         for(uint i = pot.uniqueGamblers.length; i >= 1; i--) {
202             address payable gambler = pot.uniqueGamblers[i - 1];
203             pot.uniqueGamblers.pop();
204             uint amount = pot.stakes[gambler];
205             pot.stakes[gambler] = 0;
206             if (gambler.send(amount)) { // security/no-send: see remark at the bottom
207                 emit RefundSuccessful(gambler, amount);
208             } else {
209                 emit RefundFailed(gambler, amount);
210             }
211             if(gasleft() < 26000) {
212                 // stop execution here to let state be saved
213                 // call function again to continue
214                 break;
215             }
216         }
217         return pot.uniqueGamblers.length;
218     }
219 
220     /**
221      * state transition method
222      */
223     function transitionTo(State newState) internal {
224       emit StateChanged(current_state, newState);
225       current_state = newState;
226     }
227 
228     /**
229      * stateless functions
230      */
231 
232     function getPotAmounts() external view returns (uint[numPots] memory amounts) {
233         for(uint8 j = 0; j < numPots; j++) {
234             amounts[j] = pots[j + numPots * round].amount;
235         }
236         return amounts;
237     }
238 
239 
240     /* events */
241     event StateChanged(State from, State to);
242     event WinnerChosen(uint32 indexed round, Color color, uint64 video_id, string photo_id);
243     event WinnersPaid(uint32 indexed round, uint total_amount, Color color, uint winningPotAmount);
244     event PayoutSuccessful(address winner, uint amount, uint32 round);
245     event PayoutFailed(address winner, uint amount, uint32 round);
246     event RefundSuccessful(address gambler, uint amount);
247     event RefundFailed(address gambler, uint amount);
248     event RoundStarted(uint32 indexed round, uint total_seed_amount);
249     event RaceStarted(uint32 indexed round);
250     event BetPlaced(Color pot, uint amount);
251     event HamsterRan(uint32 dezi_meters);
252 }
253 
254 /** Further Remarks
255  * ----------------
256  *
257  * Warnings
258  * - "security/no-send: Consider using 'transfer' in place of 'send'." => We use send, transfer could throw/revert and thus be used in a DOS attack.
259  * - "security/no-block-members: Avoid using 'block.timestamp'." => Using block.timestamp is safe for time periods greather than 900s [1]. We use 1 day.
260  *
261  * Sources
262  * [1] Is block.timestamp safe for longer time periods? https://ethereum.stackexchange.com/a/9752/44462
263  */