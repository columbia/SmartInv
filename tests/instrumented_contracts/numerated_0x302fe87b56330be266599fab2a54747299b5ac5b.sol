1 contract BTCRelay {
2     function getLastBlockHeight() returns (int);
3     function getBlockchainHead() returns (int);
4     function getFeeAmount(int blockHash) returns (int);
5     function getBlockHeader(int blockHash) returns (bytes32[3]);
6 }
7 
8 contract Lottery {
9     int constant LOTTERY_BLOCKS = 7 * 24 * 6;
10     uint constant LOTTERY_INTERVAL = 7 days;
11     int constant CUTOFF_BLOCKS = 6 * 6;
12     uint constant CUTOFF_INTERVAL = 6 hours;
13     uint constant TICKET_PRICE = 10 finney;
14     uint constant FEE_FACTOR = 200; // 0.5 %
15 
16     BTCRelay btcRelay = BTCRelay(0x41f274c0023f83391de4e0733c609df5a124c3d4);
17 
18     struct Bucket {
19         uint numHolders;
20         address[] ticketHolders;
21     }
22 
23     struct Payout {
24         address winner;
25         uint amount;
26         uint blockNumber;
27         uint timestamp;
28         address processor;
29     }
30 
31     int public decidingBlock;
32     int public cutoffBlock;
33     uint public cutoffTimestamp;
34     int public nearestKnownBlock;
35     int public nearestKnownBlockHash;
36 
37     uint public numTickets;
38     uint public numBuckets;
39     mapping (uint => Bucket) buckets;
40     uint public lastSaleTimestamp;
41 
42     Payout[] public payouts;
43     uint public payoutIdx;
44 
45     address public owner;
46 
47     modifier onlyOwner { if (msg.sender == owner) _ }
48 
49     event Activity();
50 
51     function Lottery() {
52         owner = msg.sender;
53         payouts.length = 3;
54         prepareLottery();
55     }
56 
57     function prepareLottery() internal {
58         decidingBlock = btcRelay.getLastBlockHeight() + LOTTERY_BLOCKS;
59         cutoffBlock = decidingBlock - CUTOFF_BLOCKS;
60         cutoffTimestamp = now + LOTTERY_INTERVAL - CUTOFF_INTERVAL;
61         nearestKnownBlock = 0;
62         nearestKnownBlockHash = 0;
63 
64         numTickets = 0;
65         for (uint i = 0; i < numBuckets; i++) {
66             buckets[i].numHolders = 0;
67         }
68         numBuckets = 0;
69         lastSaleTimestamp = 0;
70     }
71 
72     function resetLottery() {
73         if (numTickets > 0) throw;
74         if (!payoutReady()) throw;
75 
76         prepareLottery();
77         Activity();
78     }
79 
80     function () {
81         buyTickets(msg.sender);
82     }
83 
84     function buyTickets(address ticketHolder) {
85         if (msg.value < TICKET_PRICE) throw;
86         if (!ticketsAvailable()) throw;
87 
88         uint n = msg.value / TICKET_PRICE;
89         numTickets += n;
90 
91         // We maintain the list of ticket holders in a number of buckets.
92         // Entries in the first bucket represent one ticket each, in the
93         // second bucket they represent two tickets each, then four tickets
94         // each and so on. This allows us to process the sale of n tickets
95         // with a gas cost of O(log(n)).
96         uint bucket = 0;
97         while (n > 0) {
98             uint inThisBucket = n & (2 ** bucket);
99             if (inThisBucket > 0) {
100                 uint pos = buckets[bucket].numHolders++;
101                 if (buckets[bucket].ticketHolders.length <
102                     buckets[bucket].numHolders) {
103                     buckets[bucket].ticketHolders.length =
104                         buckets[bucket].numHolders;
105                 }
106                 buckets[bucket].ticketHolders[pos] = ticketHolder;
107                 n -= inThisBucket;
108             }
109             bucket += 1;
110         }
111 
112         if (bucket > numBuckets) numBuckets = bucket;
113 
114         int missingBlocks = decidingBlock - btcRelay.getLastBlockHeight();
115         uint betterCutoffTimestamp =
116             now + uint(missingBlocks) * 10 minutes - CUTOFF_INTERVAL;
117         if (betterCutoffTimestamp < cutoffTimestamp) {
118             cutoffTimestamp = betterCutoffTimestamp;
119         }
120 
121         lastSaleTimestamp = now;
122         Activity();
123     }
124 
125     function ticketsAvailable() constant returns (bool) {
126         return now < cutoffTimestamp &&
127             btcRelay.getLastBlockHeight() < cutoffBlock;
128     }
129 
130     function lookupTicketHolder(uint idx) constant returns (address) {
131         uint bucket = 0;
132         while (idx >= buckets[bucket].numHolders * (2 ** bucket)) {
133             idx -= buckets[bucket].numHolders * (2 ** bucket);
134             bucket += 1;
135         }
136 
137         return buckets[bucket].ticketHolders[idx / (2 ** bucket)];
138     }
139 
140     function getNumHolders(uint bucket) constant returns (uint) {
141         return buckets[bucket].numHolders;
142     }
143 
144     function getTicketHolders(uint bucket) constant returns (address[]) {
145         return buckets[bucket].ticketHolders;
146     }
147 
148     function getLastBlockHeight() constant returns (int) {
149         return btcRelay.getLastBlockHeight();
150     }
151 
152     function getOperatingBudget() constant returns (uint) {
153         return this.balance - numTickets * TICKET_PRICE;
154     }
155 
156     function checkDepth(uint n) constant returns (bool) {
157         if (n == 0) return true;
158         return checkDepth(n - 1);
159     }
160 
161     function payoutReady() constant returns (bool) {
162         return decidingBlock <= btcRelay.getLastBlockHeight();
163     }
164 
165     function processPayout() returns (bool done) {
166         if (!payoutReady()) throw;
167         if (getOperatingBudget() < 1 ether) throw;
168         if (numTickets == 0) throw;
169         if (!checkDepth(8)) throw;
170 
171         var (walkingDone, blockHash) = walkTowardsBlock();
172         if (!walkingDone) return false;
173 
174         int winnerIdx = blockHash % int(numTickets);
175         address winner = lookupTicketHolder(uint(winnerIdx));
176         uint fee = (numTickets * TICKET_PRICE) / FEE_FACTOR;
177         uint amount = (numTickets * TICKET_PRICE) - fee;
178 
179         // keep some records
180         payouts[payoutIdx].winner = winner;
181         payouts[payoutIdx].amount = amount;
182         payouts[payoutIdx].blockNumber = block.number;
183         payouts[payoutIdx].timestamp = now;
184         payouts[payoutIdx].processor = msg.sender;
185         payoutIdx = (payoutIdx + 1) % 3;
186 
187         prepareLottery();   // prepare next round
188         var _ = winner.send(amount);
189         Activity();
190 
191         return true;
192     }
193 
194     function walkTowardsBlock() internal returns (bool, int) {
195         int blockHeight;
196         int blockHash;
197         if (nearestKnownBlock == 0) {
198             blockHeight = btcRelay.getLastBlockHeight();
199             blockHash = btcRelay.getBlockchainHead();
200         } else {
201             blockHeight = nearestKnownBlock;
202             blockHash = nearestKnownBlockHash;
203         }
204 
205         // Walk at most 5 steps to keep an upper limit on gas costs.
206         for (uint steps = 0; steps < 5; steps++) {
207             if (blockHeight == decidingBlock) {
208                 return (true, blockHash);
209             }
210 
211             uint fee = uint(btcRelay.getFeeAmount(blockHash));
212             bytes32 blockHeader =
213                 btcRelay.getBlockHeader.value(fee)(blockHash)[2];
214             bytes32 temp;
215 
216             assembly {
217                 let x := mload(0x40)
218                 mstore(x, blockHeader)
219                 temp := mload(add(x, 0x04))
220             }
221 
222             blockHeight -= 1;
223             blockHash = 0;
224             for (int i = 0; i < 32; i++) {
225                 blockHash = blockHash | int(temp[uint(i)]) * (256 ** i);
226             }
227         }
228 
229         // Store the progress to pick up from there next time.
230         nearestKnownBlock = blockHeight;
231         nearestKnownBlockHash = blockHash;
232 
233         return (false, 0);
234     }
235 
236     function accessOperatingBudget(uint amount) onlyOwner {
237         if (getOperatingBudget() < 1 ether) throw;
238 
239         uint safeToAccess = getOperatingBudget() - 1 ether;
240         if (amount > safeToAccess) throw;
241 
242         var _ = owner.send(amount);
243     }
244 
245     function setOwner(address _owner) onlyOwner {
246         owner = _owner;
247     }
248 }