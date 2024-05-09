1 pragma solidity 0.4.15;
2 
3 contract owned {
4     
5     address public owner;
6     
7     event ContractOwnershipTransferred(address newOwner);
8     
9     function owned() { owner = msg.sender; }
10     
11     modifier onlyOwner { 
12         require(msg.sender == owner); 
13         _; 
14     }
15     
16     function setContractOwner(address newOwner) external onlyOwner  {
17         owner = newOwner;
18         ContractOwnershipTransferred(newOwner);
19     }
20 }
21 
22 /// Cillionaire is a lottery where people can participate until a pot limit is reached. Then, a random participant is chosen to be the winner.
23 /// 
24 /// Randomness is achieved by XOR'ing the following two numbers:
25 /// ownerRandomNumber ... a random number supplied by the contract owner and submitted upon `start` as a hash, much like a concealed bid in an auction.
26 /// minerRandomNumber ... timestamp of the block that contains the last participant's `particpate` transaction.
27 /// Neither can the owner know the minerRandomNumber, nor can the miner know the ownerRandomNumber (unless the owner supplies a breakable hash, e.h. keccak256(1)).
28 ///
29 /// Many safeguards are in place to prevent loss of participants' stakes and ensure fairness:
30 /// - The owner can `cancel`, in which case participants must be refunded.
31 /// - If the owner does not end the game via `chooseWinner` within 24 hours after PARTICIPATION `state` ended, then anyone can `cancel`.
32 /// - The contract has no `kill` function which would allow the owner to run off with the pot.
33 /// - Game parameters cannot be changed when a game is ongoing
34 /// - Logging of relevant events to increase transparency
35 contract Cillionaire is owned {
36     
37     enum State { ENDED, PARTICIPATION, CHOOSE_WINNER, REFUND }
38 
39     /// Target amount of ether. As long as the `potTarget` is not reached, people can `participate` when the contract is in PARTICIPATION `state`.
40     uint public potTarget;
41     /// Amount of ether that will be used to `participate`.
42     uint public stake;
43     /// Amount of ether that will be taken from `stake` as a fee for the owner.
44     uint public fee;
45     
46     State public state;
47     address[] public participants;
48     bytes32 public ownerRandomHash;
49     uint public minerRandomNumber;
50     uint public ownerRandomNumber;
51     uint public participationEndTimestamp;
52     uint public pot;
53     address public winner;
54     mapping (address => uint) public funds;
55     uint public fees;
56     uint public lastRefundedIndex;
57     
58     event StateChange(State newState);
59     event NewParticipant(address participant, uint total, uint stakeAfterFee, uint refundNow);
60     event MinerRandomNumber(uint number);
61     event OwnerRandomNumber(uint number);
62     event RandomNumber(uint randomNumber);
63     event WinnerIndex(uint winnerIndex);
64     event Winner(address _winner, uint amount);
65     event Refund(address participant, uint amount);
66     event Cancelled(address cancelledBy);
67     event ParametersChanged(uint newPotTarget, uint newStake, uint newFee);
68     
69     modifier onlyState(State _state) { 
70         require(state == _state); 
71         _; 
72     }
73     
74     // Taken from: https://solidity.readthedocs.io/en/develop/common-patterns.html
75     // This modifier requires a certain
76     // fee being associated with a function call.
77     // If the caller sent too much, he or she is
78     // refunded, but only after the function body.
79     // This was dangerous before Solidity version 0.4.0,
80     // where it was possible to skip the part after `_;`.
81     modifier costs(uint _amount) {
82         require(msg.value >= _amount);
83         _;
84         if (msg.value > _amount) {
85             msg.sender.transfer(msg.value - _amount);
86         }
87     }
88     
89     function Cillionaire() {
90         state = State.ENDED;
91         potTarget = 0.1 ether;
92         stake = 0.05 ether;
93         fee = 0;
94     }
95     
96     function setState(State _state) internal {
97         state = _state;
98         StateChange(state);
99     }
100     
101     /// Starts the game, i.e. resets game variables and transitions to state `PARTICIPATION`
102     /// `_ownerRandomHash` is the owner's concealed random number. 
103     /// It must be a keccak256 hash that can be verfied in `chooseWinner`.
104     function start(bytes32 _ownerRandomHash) external onlyOwner onlyState(State.ENDED) {
105         ownerRandomHash = _ownerRandomHash;
106         minerRandomNumber = 0;
107         ownerRandomNumber = 0;
108         participationEndTimestamp = 0;
109         winner = 0;
110         pot = 0;
111         lastRefundedIndex = 0;
112         delete participants;
113         setState(State.PARTICIPATION);
114     }
115     
116     /// Participate in the game.
117     /// You must send at least `stake` amount of ether. Surplus ether is refunded automatically and immediately.
118     /// This function will only work when the contract is in `state` PARTICIPATION.
119     /// Once the `potTarget` is reached, the `state` transitions to CHOOSE_WINNER.
120     function participate() external payable onlyState(State.PARTICIPATION) costs(stake) {
121         participants.push(msg.sender);
122         uint stakeAfterFee = stake - fee;
123         pot += stakeAfterFee;
124         fees += fee;
125         NewParticipant(msg.sender, msg.value, stakeAfterFee, msg.value - stake);
126         if (pot >= potTarget) {
127             participationEndTimestamp = block.timestamp;
128             minerRandomNumber = block.timestamp;
129             MinerRandomNumber(minerRandomNumber);
130             setState(State.CHOOSE_WINNER);
131         }
132     }
133     
134     /// Reveal the owner's random number and choose a winner using all three random numbers.
135     /// The winner is credited the pot and can get their funds using `withdraw`.
136     /// This function will only work when the contract is in `state` CHOOSE_WINNER.
137     function chooseWinner(string _ownerRandomNumber, string _ownerRandomSecret) external onlyOwner onlyState(State.CHOOSE_WINNER) {
138         require(keccak256(_ownerRandomNumber, _ownerRandomSecret) == ownerRandomHash);
139         require(!startsWithDigit(_ownerRandomSecret)); // This is needed because keccak256("12", "34") == keccak256("1", "234") to prevent owner from changing his initially comitted random number
140         ownerRandomNumber = parseInt(_ownerRandomNumber);
141         OwnerRandomNumber(ownerRandomNumber);
142         uint randomNumber = ownerRandomNumber ^ minerRandomNumber;
143         RandomNumber(randomNumber);
144         uint winnerIndex = randomNumber % participants.length;
145         WinnerIndex(winnerIndex);
146         winner = participants[winnerIndex];
147         funds[winner] += pot;
148         Winner(winner, pot);
149         setState(State.ENDED);
150     }
151     
152     /// Cancel the game.
153     /// Participants' stakes (including fee) are refunded. Use the `withdraw` function to get the refund.
154     /// Owner can cancel at any time in `state` PARTICIPATION or CHOOSE_WINNER
155     /// Anyone can cancel 24h after `state` PARTICIPATION ended. This is to make sure no funds get locked up due to inactivity of the owner.
156     function cancel() external {
157         if (msg.sender == owner) {
158             require(state == State.PARTICIPATION || state == State.CHOOSE_WINNER);
159         } else {
160             require((state == State.CHOOSE_WINNER) && (participationEndTimestamp != 0) && (block.timestamp > participationEndTimestamp + 1 days));
161         }
162         Cancelled(msg.sender);
163         // refund index 0 so lastRefundedIndex=0 is correct
164         if (participants.length > 0) {
165             funds[participants[0]] += stake;
166             fees -= fee;
167             lastRefundedIndex = 0;
168             Refund(participants[0], stake);
169             if (participants.length == 1) {
170                 setState(State.ENDED);
171             } else {
172                 setState(State.REFUND);
173             }
174         } else {
175             // nothing to refund
176             setState(State.ENDED);
177         }
178     }
179     
180     /// Refund a number of accounts specified by `_count`, beginning at the next un-refunded index which is lastRefundedIndex`+1.
181     /// This is so that refunds can be dimensioned such that they don't exceed block gas limit.
182     /// Once all participants are refunded `state` transitions to ENDED.
183     /// Any user can do the refunds.
184     function refund(uint _count) onlyState(State.REFUND) {
185         require(participants.length > 0);
186         uint first = lastRefundedIndex + 1;
187         uint last = lastRefundedIndex + _count;
188         if (last > participants.length - 1) {
189             last = participants.length - 1;
190         }
191         for (uint i = first; i <= last; i++) {
192             funds[participants[i]] += stake;
193             fees -= fee;
194             Refund(participants[i], stake);
195         }
196         lastRefundedIndex = last;
197         if (lastRefundedIndex >= participants.length - 1) {
198             setState(State.ENDED);
199         }
200     }
201 
202     /// Withdraw your funds, i.e. winnings and refunds.
203     /// This function can be called in any state and will withdraw all winnings as well as refunds. 
204     function withdraw() external {
205         uint amount = funds[msg.sender];
206         funds[msg.sender] = 0;
207         msg.sender.transfer(amount);
208     }
209     
210     /// Withdraw accumulated fees. 
211     /// Usable by contract owner when `state` is ENDED.
212     function withdrawFees() external onlyOwner onlyState(State.ENDED) {
213         uint amount = fees;
214         fees = 0;
215         msg.sender.transfer(amount);
216     }
217     
218     /// Adjust game parameters. All parameters are in Wei.
219     /// Can be called by the contract owner in `state` ENDED.
220     function setParams(uint _potTarget, uint _stake, uint _fee) external onlyOwner onlyState(State.ENDED) {
221         require(_fee < _stake);
222         potTarget = _potTarget;
223         stake = _stake; 
224         fee = _fee;
225         ParametersChanged(potTarget, stake, fee);
226     }
227     
228     function startsWithDigit(string str) internal returns (bool) {
229         bytes memory b = bytes(str);
230         return b[0] >= 48 && b[0] <= 57; // 0-9; see http://dev.networkerror.org/utf8/
231     }
232     
233     // parseInt 
234     // Copyright (c) 2015-2016 Oraclize SRL
235     // Copyright (c) 2016 Oraclize LTD
236     // Source: https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
237     function parseInt(string _a) internal returns (uint) {
238         return parseInt(_a, 0);
239     }
240 
241     // parseInt(parseFloat*10^_b)
242     // Copyright (c) 2015-2016 Oraclize SRL
243     // Copyright (c) 2016 Oraclize LTD
244     // Source: https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
245     function parseInt(string _a, uint _b) internal returns (uint) {
246         bytes memory bresult = bytes(_a);
247         uint mint = 0;
248         bool decimals = false;
249         for (uint i=0; i<bresult.length; i++){
250             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
251                 if (decimals){
252                    if (_b == 0) break;
253                     else _b--;
254                 }
255                 mint *= 10;
256                 mint += uint(bresult[i]) - 48;
257             } else if (bresult[i] == 46) decimals = true;
258         }
259         if (_b > 0) mint *= 10**_b;
260         return mint;
261     }
262 
263 }