1 pragma solidity ^0.4.11;
2 
3 
4 contract Owned {
5     address owner;
6 
7     modifier onlyowner() {
8         if (msg.sender == owner) {
9             _;
10         }
11     }
12 
13     function Owned() {
14         owner = msg.sender;
15     }
16 }
17 
18 
19 contract Mortal is Owned {
20     
21     function kill() {
22         if (msg.sender == owner)
23             selfdestruct(owner);
24     }
25 }
26 
27 
28 contract Lotthereum is Mortal {
29     uint blockPointer;
30     uint maxNumberOfBets;
31     uint minAmountByBet;
32     uint prize;
33     uint currentRound;
34     bytes32 private hash;
35 
36     Round[] private rounds;
37     mapping (uint => Bet[]) bets;
38     mapping (address => uint) private balances;
39     mapping (uint => address[]) winners;
40 
41     struct Round {
42         uint id;
43         bool open;
44         uint maxNumberOfBets;
45         uint minAmountByBet;
46         uint blockNumber;
47         bytes32 blockHash;
48         uint8 number;
49         uint prize;
50     }
51 
52     struct Bet {
53         uint id;
54         address origin;
55         uint amount;
56         uint8 bet;
57         uint round;
58     }
59 
60     event RoundOpen(uint indexed id, uint maxNumberOfBets, uint minAmountByBet);
61     event RoundClose(uint indexed id, uint8 number, uint blockNumber, bytes32 blockHash);
62     event MaxNumberOfBetsChanged(uint maxNumberOfBets);
63     event MinAmountByBetChanged(uint minAmountByBet);
64     event BetPlaced(address indexed origin, uint roundId, uint betId);
65     event RoundWinner(address indexed winnerAddress, uint amount);
66 
67     function Lotthereum(uint _blockPointer, uint _maxNumberOfBets, uint _minAmountByBet, uint _prize, bytes32 _hash) {
68         blockPointer = _blockPointer;
69         maxNumberOfBets = _maxNumberOfBets;
70         minAmountByBet = _minAmountByBet;
71         prize = _prize;
72         hash = _hash;
73         currentRound = createRound();
74     }
75 
76     function createRound() internal returns (uint id) {
77         id = rounds.length;
78         rounds.length += 1;
79         rounds[id].id = id;
80         rounds[id].open = false;
81         rounds[id].maxNumberOfBets = maxNumberOfBets;
82         rounds[id].minAmountByBet = minAmountByBet;
83         rounds[id].prize = prize;
84         rounds[id].blockNumber = 0;
85         rounds[id].blockHash = hash;
86         rounds[id].open = true;
87         RoundOpen(id, maxNumberOfBets, minAmountByBet);
88     }
89 
90     function payout() internal {
91         for (uint i = 0; i < bets[currentRound].length; i++) {
92             if (bets[currentRound][i].bet == rounds[currentRound].number) {
93                 uint id = winners[currentRound].length;
94                 winners[currentRound].length += 1;
95                 winners[currentRound][id] = bets[currentRound][i].origin;
96             }
97         }
98 
99         if (winners[currentRound].length > 0) {
100             uint prize = rounds[currentRound].prize / winners[currentRound].length;
101             for (i = 0; i < winners[currentRound].length; i++) {
102                 balances[winners[currentRound][i]] += prize;
103                 RoundWinner(winners[currentRound][i], prize);
104             }
105         }
106     }
107 
108     function closeRound() constant internal {
109         rounds[currentRound].open = false;
110         rounds[currentRound].blockHash = getBlockHash(blockPointer);
111         rounds[currentRound].number = getNumber(rounds[currentRound].blockHash);
112         payout();
113         RoundClose(currentRound, rounds[currentRound].number, rounds[currentRound].blockNumber, rounds[currentRound].blockHash);
114         currentRound = createRound();
115     }
116 
117     function getBlockHash(uint i) constant returns (bytes32 blockHash) {
118         if (i > 256) {
119             i = 256;
120         }
121         uint blockNumber = block.number - i;
122         blockHash = block.blockhash(blockNumber);
123     }
124 
125     function getNumber(bytes32 _a) constant returns (uint8) {
126         uint8 _b = 1;
127         uint8 mint = 0;
128         bool decimals = false;
129         for (uint i = _a.length - 1; i >= 0; i--) {
130             if ((_a[i] >= 48) && (_a[i] <= 57)) {
131                 if (decimals) {
132                     if (_b == 0) {
133                         break;
134                     } else {
135                         _b--;
136                     }
137                 }
138                 mint *= 10;
139                 mint += uint8(_a[i]) - 48;
140                 return mint;
141             } else if (_a[i] == 46) {
142                 decimals = true;
143             }
144         }
145         return mint;
146     }
147 
148     function bet(uint8 bet) public payable returns (bool) {
149         if (!rounds[currentRound].open) {
150             return false;
151         }
152 
153         if (msg.value < rounds[currentRound].minAmountByBet) {
154             return false;
155         }
156 
157         uint id = bets[currentRound].length;
158         bets[currentRound].length += 1;
159         bets[currentRound][id].id = id;
160         bets[currentRound][id].round = currentRound;
161         bets[currentRound][id].bet = bet;
162         bets[currentRound][id].origin = msg.sender;
163         bets[currentRound][id].amount = msg.value;
164         BetPlaced(msg.sender, currentRound, id);
165 
166         if (bets[currentRound].length == rounds[currentRound].maxNumberOfBets) {
167             closeRound();
168         }
169 
170         return true;
171     }
172 
173     function withdraw() public returns (uint) {
174         uint amount = getBalance();
175         if (amount > 0) {
176             balances[msg.sender] = 0;
177             msg.sender.transfer(amount);
178             return amount;
179         }
180         return 0;
181     }
182 
183     function getBalance() constant returns (uint) {
184         uint amount = balances[msg.sender];
185         if ((amount > 0) && (amount < this.balance)) {
186             return amount;
187         }
188         return 0;
189     }
190 
191     function getCurrentRoundId() constant returns(uint) {
192         return currentRound;
193     }
194 
195     function getRoundOpen(uint id) constant returns(bool) {
196         return rounds[id].open;
197     }
198 
199     function getRoundMaxNumberOfBets(uint id) constant returns(uint) {
200         return rounds[id].maxNumberOfBets;
201     }
202 
203     function getRoundMinAmountByBet(uint id) constant returns(uint) {
204         return rounds[id].minAmountByBet;
205     }
206 
207     function getRoundPrize(uint id) constant returns(uint) {
208         return rounds[id].prize;
209     }
210 
211     function getRoundNumberOfBets(uint id) constant returns(uint) {
212         return bets[id].length;
213     }
214 
215     function getRoundBetOrigin(uint roundId, uint betId) constant returns(address) {
216         return bets[roundId][betId].origin;
217     }
218 
219     function getRoundBetAmount(uint roundId, uint betId) constant returns(uint) {
220         return bets[roundId][betId].amount;
221     }
222 
223     function getRoundBetNumber(uint roundId, uint betId) constant returns(uint) {
224         return bets[roundId][betId].bet;
225     }
226 
227     function getRoundNumber(uint id) constant returns(uint8) {
228         return rounds[id].number;
229     }
230 
231     function getRoundBlockNumber(uint id) constant returns(uint) {
232         return rounds[id].blockNumber;
233     }
234 
235     function getBlockPointer() constant returns(uint) {
236         return blockPointer;
237     }
238 
239     function () payable {
240     }
241 }