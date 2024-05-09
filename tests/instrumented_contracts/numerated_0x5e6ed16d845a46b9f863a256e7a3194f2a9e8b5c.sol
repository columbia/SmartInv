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
39 
40     struct Round {
41         uint id;
42         bool open;
43         uint maxNumberOfBets;
44         uint minAmountByBet;
45         uint blockNumber;
46         bytes32 blockHash;
47         uint8 number;
48         uint prize;
49     }
50 
51     struct Bet {
52         uint id;
53         address origin;
54         uint amount;
55         uint8 bet;
56         uint round;
57     }
58 
59     event RoundOpen(uint indexed id, uint maxNumberOfBets, uint minAmountByBet);
60     event RoundClose(uint indexed id, uint8 number, uint blockNumber, bytes32 blockHash);
61     event MaxNumberOfBetsChanged(uint maxNumberOfBets);
62     event MinAmountByBetChanged(uint minAmountByBet);
63     event BetPlaced(address indexed origin, uint roundId, uint betId);
64     event RoundWinner(address indexed winnerAddress, uint amount);
65 
66     function Lotthereum(uint _blockPointer, uint _maxNumberOfBets, uint _minAmountByBet, uint _prize, bytes32 _hash) {
67         blockPointer = _blockPointer;
68         maxNumberOfBets = _maxNumberOfBets;
69         minAmountByBet = _minAmountByBet;
70         prize = _prize;
71         hash = _hash;
72         currentRound = createRound();
73     }
74 
75     function createRound() internal returns (uint id) {
76         id = rounds.length;
77         rounds.length += 1;
78         rounds[id].id = id;
79         rounds[id].open = false;
80         rounds[id].maxNumberOfBets = maxNumberOfBets;
81         rounds[id].minAmountByBet = minAmountByBet;
82         rounds[id].prize = prize;
83         rounds[id].blockNumber = 0;
84         rounds[id].blockHash = hash;
85         rounds[id].open = true;
86         RoundOpen(id, maxNumberOfBets, minAmountByBet);
87     }
88 
89     function payout() internal {
90         for (uint i = 0; i < bets[currentRound].length; i++) {
91             if (bets[currentRound][i].bet == rounds[currentRound].number) {
92                 balances[bets[currentRound][i].origin] += rounds[currentRound].prize;
93                 RoundWinner(bets[currentRound][i].origin, rounds[currentRound].prize);
94             }
95         }
96     }
97 
98     function closeRound() constant internal {
99         rounds[currentRound].open = false;
100         rounds[currentRound].blockHash = getBlockHash(blockPointer);
101         rounds[currentRound].number = getNumber(rounds[currentRound].blockHash);
102         payout();
103         RoundClose(currentRound, rounds[currentRound].number, rounds[currentRound].blockNumber, rounds[currentRound].blockHash);
104         currentRound = createRound();
105     }
106 
107     function getBlockHash(uint i) constant returns (bytes32 blockHash) {
108         if (i > 256) {
109             i = 256;
110         }
111         uint blockNumber = block.number - i;
112         blockHash = block.blockhash(blockNumber);
113     }
114 
115     function getNumber(bytes32 _a) constant returns (uint8) {
116         uint8 _b = 1;
117         uint8 mint = 0;
118         bool decimals = false;
119         for (uint i = _a.length - 1; i >= 0; i--) {
120             if ((_a[i] >= 48) && (_a[i] <= 57)) {
121                 if (decimals) {
122                     if (_b == 0) {
123                         break;
124                     } else {
125                         _b--;
126                     }
127                 }
128                 mint *= 10;
129                 mint += uint8(_a[i]) - 48;
130                 return mint;
131             } else if (_a[i] == 46) {
132                 decimals = true;
133             }
134         }
135         return mint;
136     }
137 
138     function bet(uint8 bet) public payable returns (bool) {
139         if (!rounds[currentRound].open) {
140             return false;
141         }
142 
143         if (msg.value < rounds[currentRound].minAmountByBet) {
144             return false;
145         }
146 
147         uint id = bets[currentRound].length;
148         bets[currentRound].length += 1;
149         bets[currentRound][id].id = id;
150         bets[currentRound][id].round = currentRound;
151         bets[currentRound][id].bet = bet;
152         bets[currentRound][id].origin = msg.sender;
153         bets[currentRound][id].amount = msg.value;
154         BetPlaced(msg.sender, currentRound, id);
155 
156         if (bets[currentRound].length == rounds[currentRound].maxNumberOfBets) {
157             closeRound();
158         }
159 
160         return true;
161     }
162 
163     function withdraw() public returns (uint) {
164         uint amount = getBalance();
165         if (amount > 0) {
166             balances[msg.sender] = 0;
167             msg.sender.transfer(amount);
168             return amount;
169         }
170         return 0;
171     }
172 
173     function getBalance() constant returns (uint) {
174         uint amount = balances[msg.sender];
175         if ((amount > 0) && (amount < this.balance)) {
176             return amount;
177         }
178         return 0;
179     }
180 
181     function getCurrentRoundId() constant returns(uint) {
182         return currentRound;
183     }
184 
185     function getRoundOpen(uint id) constant returns(bool) {
186         return rounds[id].open;
187     }
188 
189     function getRoundMaxNumberOfBets(uint id) constant returns(uint) {
190         return rounds[id].maxNumberOfBets;
191     }
192 
193     function getRoundMinAmountByBet(uint id) constant returns(uint) {
194         return rounds[id].minAmountByBet;
195     }
196 
197     function getRoundPrize(uint id) constant returns(uint) {
198         return rounds[id].prize;
199     }
200 
201     function getRoundNumberOfBets(uint id) constant returns(uint) {
202         return bets[id].length;
203     }
204 
205     function getRoundBetOrigin(uint roundId, uint betId) constant returns(address) {
206         return bets[roundId][betId].origin;
207     }
208 
209     function getRoundBetAmount(uint roundId, uint betId) constant returns(uint) {
210         return bets[roundId][betId].amount;
211     }
212 
213     function getRoundBetNumber(uint roundId, uint betId) constant returns(uint) {
214         return bets[roundId][betId].bet;
215     }
216 
217     function getRoundNumber(uint id) constant returns(uint8) {
218         return rounds[id].number;
219     }
220 
221     function getRoundBlockNumber(uint id) constant returns(uint) {
222         return rounds[id].blockNumber;
223     }
224 
225     function getBlockPointer() constant returns(uint) {
226         return blockPointer;
227     }
228 
229     function () payable {
230     }
231 }