1 pragma solidity ^0.4.17;
2 
3 ////////////////////////////////////////////////////////////////////////////////////////////////
4 //                                           pyramide type game                                                  //
5 //                  0xc8d40dd5f0967d7de1e65f358c5c7f546b1c09ec                       //
6 //                        https://godstep.ru/ethereum/Circleramide                             //
7 ///////////////////////////////////////////////////////////////////////////////////////////////
8 
9 library SafeMath {
10       function mul(uint a, uint b) internal returns (uint) {
11         uint c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14       }
15       function div(uint a, uint b) internal returns (uint) {
16         assert(b > 0);
17         uint c = a / b;
18         assert(a == b * c + a % b);
19         return c;
20       }
21       function sub(uint a, uint b) internal returns (uint) {
22         assert(b <= a);
23         return a - b;
24       }
25       function add(uint a, uint b) internal returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29       }
30       function assert(bool assertion) internal {
31         if (!assertion) {
32           throw;
33         }
34       }
35     }
36 
37 
38 contract Circleramide {
39     using SafeMath for uint;
40     
41     // events
42     event SendMessage(uint id, string message, address sender);
43     event NewBlock(uint id);
44     event Reward(uint blockID, address player, uint reward);
45     event Withdraw(address player);
46     
47      modifier onlyOwner() {
48         require(msg.sender == owner); _;
49     }
50     
51     // contract owner 
52     address owner;
53 
54     uint public totalBlocks = 0;
55     uint public rewardBalance;
56 
57  
58     uint private constant FIRST_ROW_BLOCKS_COUNT = 128;
59     uint private constant MAXIMUM_ROWS_COUNT = FIRST_ROW_BLOCKS_COUNT - 1;
60     uint private constant FIRST_BLOCK_PRICE = .005 ether;
61 
62 
63     bool public isLive;
64 
65     // jackpot 
66     uint public rewardsCount;
67     
68     uint private constant REWARDED_BLOCK = 100;
69     uint private constant REWARDS_TOTAL = 49; // only 49 rewards (50 reward == 5000 block == jackpot);
70     uint private constant REWARD_DIV = 120; 
71     
72     // jackpot 
73     uint private constant REWARD_FEE_TOP = 70;
74     uint private constant REWARD_FEE_DIV = 100; // 70/100 = 70% goes to rewards;
75     
76     // comission = (2% of each block) = (70% goes of comission to REWARDS and 30% goes owner)
77     uint private constant FEE_TOP = 2;
78     uint private constant FEE_DIV = 100; // 100/2 = 0.2% fee
79     
80      // block price = bottomRowBlockPrice +  0.1% * bottomRowBlockPrice
81     uint private constant NEXT_ROW_PROPORTION_TOP = 25; // 25/100 = 25%
82     uint private constant NEXT_ROW_PROPORTION_DIV = 100;  
83  
84     
85     struct Block {
86         uint x;
87         uint y;
88         string message;
89     }
90     
91     mapping(address => uint) public balances;
92     mapping (uint => mapping(uint => uint)) public blocksCoordinates;
93     mapping (uint => address) public blocksOwners;
94     mapping (uint => uint) public prices;
95     mapping (uint => address) public rewards_id;
96     mapping (uint => uint) public rewards_amount;
97     mapping (uint => Block) public blocks;
98     
99 
100     function Circleramide() {
101         isLive = true;
102         owner = msg.sender;
103         prices[0] = FIRST_BLOCK_PRICE;
104         
105         totalBlocks = 1;
106         calculatePrice(0);
107         placeBlock(owner, 0, 0, 'First Block :)');
108         sendMessage('Welcome to the Circleramide!');
109     }
110 
111     // public function
112     function setBlock(uint x, uint y, string message) external payable {
113         if(isLive) {
114             address sender = msg.sender;
115             
116             uint bet = calculatePrice(y);
117             uint senderBalance = balances[sender] + msg.value;
118             
119             require(bet <= senderBalance);
120             
121             if(checkBlockEmpty(x, y)) {
122                 uint fee = (bet * FEE_TOP)/FEE_DIV;
123                 uint jackpotFee = (fee * REWARD_FEE_TOP)/REWARD_FEE_DIV;
124                 uint amountForOwner = fee - jackpotFee;
125                 uint amountForBlock = bet - fee;
126                 
127     
128                 if(x < FIRST_ROW_BLOCKS_COUNT - y) {
129                    balances[owner] += amountForOwner;
130                    rewardBalance += jackpotFee;
131                    balances[sender] = senderBalance - bet;
132                    
133                    if(y == 0) {
134                         uint firstBlockReward = (amountForBlock * REWARD_FEE_TOP)/REWARD_FEE_DIV;
135                         rewardBalance += firstBlockReward;
136                         balances[owner] += amountForBlock - firstBlockReward; 
137                         placeBlock(sender, x, y, message);
138                    } else {
139                         placeToRow(sender, x, y, message, amountForBlock);
140                    }
141                 } else {
142                     throw;  // outside the blocks field
143                 }
144             } else {
145                 throw;  // block[x, y] is not empty
146             }
147         } else {
148             throw;  // game is over
149         }
150      }
151     
152 
153     
154     // private funtions
155     function placeBlock(address sender, uint x, uint y, string message) private {
156         blocksCoordinates[y][x] = totalBlocks; 
157      
158         blocks[totalBlocks] = Block(x, y, message);
159         blocksOwners[totalBlocks] = sender;
160 
161         NewBlock(totalBlocks);
162     
163 
164         // reward every 100 blocks
165         if(totalBlocks % REWARDED_BLOCK == 0) {
166             uint reward;
167             // block id == 5000 - JACKPOT!!!! GameOVER;
168             if(rewardsCount == REWARDS_TOTAL) {
169                 isLive = false; // GAME IS OVER
170                 rewardsCount++;
171                 reward = rewardBalance; // JACKPOT!
172                 rewardBalance = 0;
173             } else {
174                 rewardsCount++;
175                 reward = calculateReward();
176                 rewardBalance = rewardBalance.sub(reward);
177             }
178             
179             balances[sender] += reward;
180             Reward(rewardsCount, sender, reward);
181             rewards_id[rewardsCount-1] = sender;
182             rewards_amount[rewardsCount-1] = reward;
183         }
184         totalBlocks++;
185     }
186     function placeToRow(address sender, uint x, uint y, string message, uint bet) private {
187        uint parentY = y - 1;
188                         
189        uint parent1_id = blocksCoordinates[parentY][x];
190        uint parent2_id = blocksCoordinates[parentY][x + 1];
191        
192        if(parent1_id != 0 && parent2_id != 0) {
193             address owner_of_block1 = blocksOwners[parent1_id];
194             address owner_of_block2 = blocksOwners[parent2_id];
195             
196             uint reward1 = bet/2;
197             uint reward2 = bet - reward1;
198             balances[owner_of_block1] += reward1;
199             balances[owner_of_block2] += reward2;
200             
201             placeBlock(sender, x, y, message);
202 
203        } else {
204            throw;
205        }
206     }
207     
208     function calculatePrice(uint y) private returns (uint) {
209         uint nextY = y + 1;
210         uint currentPrice = prices[y];
211         if(prices[nextY] == 0) {
212             prices[nextY] = currentPrice + (currentPrice * NEXT_ROW_PROPORTION_TOP)/NEXT_ROW_PROPORTION_DIV;
213             return currentPrice;
214         } else {
215             return currentPrice;
216         }
217     }
218     function withdrawBalance(uint amount) external {
219         require(amount != 0);
220         
221         // The user must have enough balance to withdraw
222         require(balances[msg.sender] >= amount);
223         
224         // Subtract the withdrawn amount from the user's balance
225         balances[msg.sender] = balances[msg.sender].sub(amount);
226         
227         // Transfer the amount to the user's address
228         // If the transfer() call fails an exception will be thrown,
229         // and therefore the user's balance will be automatically restored
230         msg.sender.transfer(amount);
231         
232         Withdraw(msg.sender);
233     }
234     
235     
236     // constants
237     function calculateReward() public constant returns (uint) {
238         return (rewardBalance * rewardsCount) / REWARD_DIV;
239     }
240     function getBlockPrice(uint y)  constant returns (uint) {
241         return prices[y];
242     }
243     function checkBlockEmpty(uint x, uint y) constant returns (bool) {
244         return blocksCoordinates[y][x] == 0;
245     }
246     function Info() constant returns (uint tb, uint bc, uint fbp, uint rc, uint rb, uint rt, uint rf, uint rd, uint mc, uint rew) {
247         tb = totalBlocks;
248         bc = FIRST_ROW_BLOCKS_COUNT;
249         fbp = FIRST_BLOCK_PRICE;
250         rc = rewardsCount;
251         rb = rewardBalance;
252         rt = REWARDS_TOTAL;
253         rf = REWARD_FEE_TOP;
254         rd = REWARD_DIV;
255         mc = messagesCount;
256         rew = REWARDED_BLOCK;
257     }
258     function getBlock(uint id) public constant returns (uint i, uint x, uint y, address owmer, string message) {
259         Block storage block = blocks[id];
260         i = id;
261         x = block.x;
262         y = block.y;
263         owner = blocksOwners[id];
264         message = block.message;
265     }
266     function getRewards(uint c, uint o) public constant returns (uint cursor, uint offset, uint[] array) {
267         uint n;
268         uint[] memory arr = new uint[](o * 2);
269         offset = o; cursor = c;
270         uint l = offset + cursor;
271         for(uint i = cursor; i<l; i++) {
272             arr[n] = uint(rewards_id[i]);
273             arr[n + 1] = rewards_amount[i];
274             n += 2;
275         }
276         array = arr;
277     }
278     function getBlocks(uint c, uint o) public constant returns (uint cursor, uint offset, uint[] array) {
279         uint n;
280         uint[] memory arr = new uint[](o * 3);
281         offset = o; cursor = c;
282         uint l = offset + cursor;
283         for(uint i = cursor; i<l; i++) {
284             Block storage b = blocks[i+1];
285             arr[n] = (b.x);
286             arr[n + 1] = (b.y);
287             arr[n + 2] = uint(blocksOwners[i+1]);
288             n += 3;
289         }
290         array = arr;
291     }
292     function getPrices(uint c, uint o) public constant returns (uint cursor, uint offset, uint[] array) {
293         uint n;
294         uint[] memory arr = new uint[](o);
295         offset = o;  cursor = c;
296         uint l = offset + cursor;
297         for(uint i = cursor; i<l; i++) {
298             arr[n] = prices[i];
299             n++;
300         }
301         array = arr;
302     }
303     
304     
305     //////////
306     // CHAT //
307     //////////
308     
309     struct Message {
310         address sender;
311         string message;
312     }
313     uint private messagesCount;
314     mapping(address => string) public usernames;
315     mapping(uint => Message) public messages;
316     
317     function sendMessage(string message) public returns (uint) {
318         messages[messagesCount] = Message(msg.sender, message);
319         SendMessage(messagesCount, message, msg.sender);
320         messagesCount = messagesCount.add(1);
321         return messagesCount;
322     }
323     function setUserName(string name) public returns (bool) {
324         address sender = msg.sender;
325         
326         bytes memory username = bytes(usernames[sender]);
327         if(username.length == 0) {
328             usernames[sender] = name;
329             return true;
330         }
331         return false;
332     }
333 }