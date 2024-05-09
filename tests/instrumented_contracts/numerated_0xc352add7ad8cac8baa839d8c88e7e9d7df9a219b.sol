1 pragma solidity ^0.4.15;
2 
3 contract Fibonzi{
4 
5     address owner;
6     
7     uint8 public poolCount = 0;
8     uint8 public playersCount = 0;
9     uint8 public transactionsCount = 0;
10     uint8 public fibonacciIndex = 0;
11     uint8 public fibokenCreatedCount = 0;
12     uint8 public fibokenUsedCount = 0;
13     uint fibonacciMax = 18;
14     uint public poolsToCreate = 0;
15     address[] public playersList;
16     
17     struct Player{
18         address wallet;
19         uint balance;
20     }
21     
22     struct Pool{
23         uint8 poolId;
24         uint price;
25         address owner;
26     }
27     
28     struct Fiboken{
29         uint8 fibokenId;
30         address owner;
31         bool isUsed;
32     }
33     
34     mapping(address => Player) players;
35     mapping(address => Fiboken[]) playersFibokens;
36     mapping(address => uint) playersBalance;
37     mapping(uint8 => Pool) pools;
38     
39     event PlayerCreated(address indexed wallet, uint timestamp);
40     event PlayerBalance(address playerWallet, uint playerBalance, uint timestamp);
41     event FibokenCreated(uint8 tokenId, address wallet, uint timestamp);
42     event FibokenUsed(uint8 tokenId,address wallet, uint timestamp);
43     event PoolCreated(uint8 indexed poolId,uint price,uint timestamp);
44     event PoolJoined(uint8 indexed poolId, address indexed wallet,uint price,uint timestamp);
45     
46     
47     function Fibonzi(){
48         owner = msg.sender;
49         createPlayer();
50         createPool();
51         fibonacciIndex++;
52     }
53     
54     function openPool(uint8 poolId) payable{
55         assert(poolCount >= poolId);
56         assert(isPlayer());
57         assert(msg.value >= pools[poolId].price);
58         assert(getUsablePlayerFibokens(msg.sender) > 0);
59         assert(usePlayerFiboken());
60         
61         uint price = pools[poolId].price;
62         owner.transfer(price);
63         pools[poolId].owner = msg.sender;
64         
65         if(msg.value > pools[poolId].price){
66             msg.sender.transfer(msg.value - pools[poolId].price);
67         }
68         
69         pools[poolId].price = 4*price;
70         PoolJoined(poolId,msg.sender,pools[poolId].price,now);
71         ++transactionsCount;
72         
73         if(fibonacciIndex <= fibonacciMax){
74             createPoolsIfNeeded();
75         }
76         getPoolPrices();
77     }
78     
79     function joinPool(uint8 poolId) payable{
80         assert(poolCount >= poolId);
81         assert(msg.sender != pools[poolId].owner);
82         assert(msg.value >= pools[poolId].price);
83         assert( ( pools[poolId].owner == owner && poolCount == 1) || (pools[poolId].owner != owner) );
84         
85         //Register the player if not registered
86         if(!isPlayer()){
87             createPlayer();   
88         }
89         
90         if(msg.value > pools[poolId].price){
91             msg.sender.transfer(msg.value - pools[poolId].price);
92         }
93         
94         uint price = pools[poolId].price;
95         pools[poolId].owner.transfer((price * 80)/100);
96         
97         splitComissions((price *20)/100);
98         pools[poolId].owner = msg.sender;
99         pools[poolId].price = 2*price;
100         
101         PoolJoined(poolId,msg.sender,pools[poolId].price,now);
102         ++transactionsCount;
103         
104         if(fibonacciIndex <= fibonacciMax){
105             createPoolsIfNeeded();
106         }
107         
108         rewardFiboken();
109         getPoolPrices();
110     }
111     
112     function withdrawComission(){
113         assert(isPlayer());
114         assert(players[msg.sender].balance > 0);
115         assert(getUsablePlayerFibokens(msg.sender) >= 10);
116         
117         for(uint i=0;i<10;i++){
118             usePlayerFiboken();
119         }
120         
121         msg.sender.transfer(players[msg.sender].balance);
122         players[msg.sender].balance = 0;
123         PlayerBalance(msg.sender,players[msg.sender].balance,now);
124     }
125     
126     function isPlayer() internal returns (bool){
127         bool isPlayerFlag = false;
128         for(uint8 i=0; i< playersCount;i++){
129             if(playersList[i] == msg.sender){
130                 isPlayerFlag = true;
131             }
132         }
133         return isPlayerFlag;
134     }
135     
136     function createPlayer() internal{
137         if(!isPlayer()){
138             playersCount++;
139             players[msg.sender] = Player(msg.sender,0);
140             PlayerCreated(msg.sender,now);
141             playersList.push(msg.sender);
142         }
143         getFibonziPlayers();   
144     }
145     
146     function createPool() internal{
147         poolCount++;
148         pools[poolCount] = Pool(poolCount, 1e15,owner);
149         PoolCreated(poolCount,1e15,now);
150     }
151     
152     function createPoolsIfNeeded() internal{
153         uint currentFibonacci = getFibonacci(fibonacciIndex);
154         if(transactionsCount == currentFibonacci){
155             if(currentFibonacci > poolCount){
156                 poolsToCreate = currentFibonacci - poolCount;
157                 for(uint8 i =0; i < poolsToCreate; i++ ){
158                     createPool();
159                     rewardFiboken();
160                 }
161             }
162         }
163         else if(transactionsCount > currentFibonacci){
164             fibonacciIndex++;
165             createPoolsIfNeeded();
166         }
167     }
168     
169     function splitComissions(uint price) internal{
170         if(fibokenCreatedCount > fibokenUsedCount){
171             uint share = price/(fibokenCreatedCount - fibokenUsedCount);
172             for(uint8 i=0; i< playersCount;i++){
173                 uint8 usableTokens = getUsablePlayerFibokens(playersList[i]);
174                 if(usableTokens > 0){
175                     players[playersList[i]].balance += share*usableTokens;
176                     PlayerBalance(playersList[i],players[playersList[i]].balance,now);
177                 }
178             }
179         }
180         else{
181             players[owner].balance += price;
182             PlayerBalance(owner,players[owner].balance,now);
183         }
184     }
185     
186     function rewardFiboken() internal{
187         fibokenCreatedCount++;
188         playersFibokens[msg.sender].push(Fiboken(fibokenCreatedCount,msg.sender,false));
189         FibokenCreated(fibokenCreatedCount,msg.sender,now);
190         if(fibokenCreatedCount % 9 == 0){
191             ++fibokenCreatedCount;
192             playersFibokens[owner].push(Fiboken(fibokenCreatedCount,owner,false));
193             FibokenCreated(fibokenCreatedCount,owner,now);
194         }
195     }
196     
197     function usePlayerFiboken() internal returns (bool){
198         var used = false;
199         for(uint8 i=0; i<playersFibokens[msg.sender].length;i++){
200             if(!playersFibokens[msg.sender][i].isUsed && !used){
201                 playersFibokens[msg.sender][i].isUsed = true;
202                 used = true;
203                 ++fibokenUsedCount;
204                 FibokenUsed(playersFibokens[msg.sender][i].fibokenId,msg.sender,now);
205             }
206         }
207         
208         return used;
209     }
210     
211     function getUsablePlayerFibokens(address someAddress) internal returns (uint8){
212         uint8 playerFibokens = 0;
213         for(uint8 i=0; i< playersFibokens[someAddress].length;i++){
214             if(!playersFibokens[someAddress][i].isUsed){
215                 ++playerFibokens;       
216             }
217         }
218         return playerFibokens;
219     }
220     
221     function getFibonacci(uint n) internal returns (uint){
222         if(n<=1){
223             return n;
224         }
225         else{
226             return getFibonacci(n-1) + getFibonacci(n-2);
227         }
228     }
229     
230     function getPoolIds() constant returns(uint8[]){
231         uint8[] memory poolIds = new uint8[](poolCount);
232         for(uint8 i = 1; i< poolCount+1; i++){
233             poolIds[i-1] = pools[i].poolId;
234         }
235         return poolIds;
236     }
237     
238     function getPoolPrices() constant returns(uint[]){
239         uint[] memory poolPrices = new uint[](poolCount);
240         for(uint8 i = 1; i< poolCount+1; i++){
241             poolPrices[i-1] = pools[i].price;
242         }
243         return poolPrices;
244     }
245     
246     function getPoolOwners() constant returns(address[]){
247         address[] memory poolOwners = new address[](poolCount);
248         for(uint8 i = 1; i< poolCount+1; i++){
249             poolOwners[i-1] = pools[i].owner;
250         }
251         return poolOwners;
252     }
253     
254     function getFibonziPlayers() constant returns(address[]){
255         address[] memory fibonziPlayers = new address[](playersCount);
256         for(uint8 i = 0; i< playersCount ; i++){
257             fibonziPlayers[i] = playersList[i];
258         }
259         return fibonziPlayers;
260     }
261     
262     function getPlayersBalances() constant returns(uint[]){
263         uint[] memory playersBalances = new uint[](playersCount);
264         for(uint8 i = 0; i< playersCount ; i++){
265             playersBalances[i] = players[playersList[i]].balance;
266         }
267         return playersBalances;
268     }
269     
270     function getPlayersFibokens() constant returns(uint[]){
271         uint[] memory playersTokens = new uint[](playersCount);
272         for(uint8 i = 0; i< playersCount ; i++){
273             uint sum = 0;
274             for(uint j = 0; j <playersFibokens[playersList[i]].length;j++){
275                 if(!playersFibokens[playersList[i]][j].isUsed){
276                     sum++;
277                 }
278             }
279             playersTokens[i] = sum;
280         }
281         return playersTokens;
282     }
283     
284 }