1 pragma solidity ^0.4.15;
2 
3 contract Fibonzi{
4     
5     address owner;
6     uint8 poolCount = 0;
7     uint8 playerCount = 0;
8     uint8 poolJoinedCount = 0;
9     uint fiboIndex = 0;
10     uint poolToCreate = 0;
11     uint8 tokenCount = 0;
12     uint8 tokenUsed = 0;
13     uint8 fiboMax = 0;
14     uint8 tokenToReward = 0;
15     uint currentShare = 0;
16     
17     struct Player{
18         uint8 playerId;
19         address wallet;
20         uint playerBalance;
21     }
22     
23     struct Pool{
24         uint8 poolId;
25         uint price;
26         uint8 owner;
27     }
28     
29     struct Token{
30         uint8 tokenId;
31         uint8 playerId;
32         bool used;
33     }
34 
35     mapping(uint8 => Player) players;
36     mapping(uint8 => Pool) pools;
37     mapping(address => uint8) playersWallets;
38     mapping(address => Token[]) playersToken;
39     mapping(address => uint) playersBalance;
40     
41     event PlayerCreated(uint8 indexed playerId, address indexed wallet,uint timestamp);
42     event PlayerBalance(uint8 indexed playerId, uint playerBalance, uint timestamp);
43     event PoolCreated(uint8 indexed poolId,uint price, uint timestamp);
44     event PoolJoined(uint8 indexed poolId, uint8 indexed playerId, uint256 price, uint timestamp);
45     event PoolPrize(uint8 indexed poolId, uint8 indexed playerId, uint prize, uint timestamp);
46     event TokenCreated(uint8 indexed tokenId, uint8 indexed playerId);
47     event TokenUsed(uint8 indexed tokenId, uint8 indexed playerId);
48     
49     function Fibonzi(){
50         owner = msg.sender;
51         createPlayer();
52         createPool();
53         fiboIndex++;
54         fiboMax = 18;
55     }
56     
57     function openPool(uint8 poolId) payable{
58         assert(poolCount >= poolId);
59         assert(playersWallets[msg.sender] > 0);
60         assert(msg.sender == players[playersWallets[msg.sender]].wallet);
61         assert(msg.value >= pools[poolId].price);
62         assert(getPlayerUsableTokensCount() > 0);
63         assert(usePlayerToken());
64         
65         var price = pools[poolId].price;
66         owner.transfer(price);
67         PoolPrize(poolId,pools[poolId].owner,2*price,now);
68         //change the owner of the pool as the current player
69         pools[poolId].owner = players[playersWallets[msg.sender]].playerId;
70         
71         //return the change if any
72         if(msg.value > pools[poolId].price){
73             players[playersWallets[msg.sender]].wallet.transfer(msg.value - pools[poolId].price);
74         }
75         
76         //double the price of the pool
77         pools[poolId].price = 2*price;
78         PoolJoined(poolId,playersWallets[msg.sender],pools[poolId].price,now);
79         poolJoinedCount++;
80         
81         if(fiboIndex <= fiboMax){
82             createPoolIfNeeded();
83         }
84     }
85     
86     function joinPool(uint8 poolId) payable{
87         assert(poolCount >= poolId);
88         assert(playersWallets[msg.sender] > 0);
89         assert(msg.sender == players[playersWallets[msg.sender]].wallet);
90         assert(players[playersWallets[msg.sender]].playerId != pools[poolId].owner);
91         assert(msg.value >= pools[poolId].price);
92         assert( (pools[poolId].owner == owner && poolCount == 1) || (pools[poolId].owner != players[0].playerId));
93         
94         //send the amount to the owner
95         uint price = pools[poolId].price;
96         players[pools[poolId].owner].wallet.transfer((price * 80)/100);
97         //distribute the 20% to all token holders
98         distributeReward(price);
99         
100         PoolPrize(poolId,pools[poolId].owner,2*price,now);
101         //change the owner of the pool as the current player
102         pools[poolId].owner = players[playersWallets[msg.sender]].playerId;
103         
104         //return the change if any
105         if(msg.value > pools[poolId].price){
106             players[playersWallets[msg.sender]].wallet.transfer(msg.value - pools[poolId].price);
107         }
108         
109         //double the price of the pool
110         pools[poolId].price = 2*price;
111         PoolJoined(poolId,playersWallets[msg.sender],pools[poolId].price,now);
112         poolJoinedCount++;
113         
114         if(fiboIndex <= fiboMax){
115             createPoolIfNeeded();
116         }
117         //give token to the current player
118         createPlayerToken();
119     }
120     
121     function distributeReward(uint price) internal{
122         if(tokenCount - tokenUsed > 0){
123             tokenToReward = tokenCount - tokenUsed;
124             uint share = (price*20/100)/(tokenCount - tokenUsed);
125             currentShare = share;
126             for(uint8 i=0; i< playerCount;i++){
127                 uint count = 0;
128                 for(uint8 j=0;j< playersToken[players[i+1].wallet].length;j++){
129                     if(!playersToken[players[i+1].wallet][j].used){
130                        count++; 
131                     }
132                 }
133                 if(count > 0){
134                     players[i+1].playerBalance += share*count;
135                     playersBalance[players[i+1].wallet] = players[i+1].playerBalance;
136                     PlayerBalance(players[i+1].playerId,players[i+1].playerBalance,now);   
137                 }
138             }
139         }
140         else{
141             // no token owner => send to owner
142             players[playersWallets[owner]].playerBalance += (price*20/100);
143             playersBalance[owner] = players[playersWallets[owner]].playerBalance;
144             PlayerBalance(players[playersWallets[owner]].playerId,players[playersWallets[owner]].playerBalance,now);   
145         }
146     }
147     
148     function withdraw(){
149         assert(playersWallets[msg.sender] > 0);
150         assert(getPlayerUsableTokensCount()>10);
151         assert(playersBalance[msg.sender] >0);
152         
153         players[playersWallets[msg.sender]].wallet.transfer(playersBalance[msg.sender]);
154         for(uint i=0;i<10;i++){
155             usePlayerToken();
156         }
157         players[playersWallets[msg.sender]].playerBalance = 0;
158         playersBalance[players[playersWallets[msg.sender]].wallet] = 0;
159         PlayerBalance(players[playersWallets[msg.sender]].playerId,0,now);   
160     }
161     
162     //someone has to call create pool
163     function createPool() internal{
164         poolCount++;
165         pools[poolCount] = Pool(poolCount,1e16,players[1].playerId);
166         PoolCreated(poolCount,1e16,now);
167         
168     }
169     
170     function createPlayer() returns (uint256){
171         for(uint8 i=0; i< playerCount;i++){
172             assert(players[i+1].wallet != msg.sender);
173         }
174         
175         playerCount++;
176         players[playerCount] = Player(playerCount,msg.sender,0);
177         playersWallets[msg.sender] = playerCount;
178         PlayerCreated(playersWallets[msg.sender],msg.sender,now);
179         return playerCount;
180     }
181     
182     function createPoolIfNeeded() internal{
183         var currentFibo = getFibo(fiboIndex);
184         if(poolJoinedCount > currentFibo){
185             fiboIndex++;
186             createPoolIfNeeded();
187         }
188         else if(poolJoinedCount == currentFibo){
189             if(currentFibo > poolCount){
190                 poolToCreate = currentFibo - poolCount;
191                 for(uint i=0; i< poolToCreate; i++){
192                     createPool();
193                     //add Token to the player who generates the pools
194                     createPlayerToken();
195                 }
196                 poolToCreate = 0;
197             }
198         }
199     }
200     
201     function createPlayerToken() internal{
202         tokenCount++;
203         playersToken[msg.sender].push(Token(tokenCount,players[playersWallets[msg.sender]].playerId,false));
204         TokenCreated(tokenCount,players[playersWallets[msg.sender]].playerId);
205         if(tokenCount % 9 == 0){
206             tokenCount++;
207             playersToken[owner].push(Token(tokenCount,players[playersWallets[owner]].playerId,false));
208             TokenCreated(tokenCount,players[playersWallets[owner]].playerId);
209         }
210     }
211     
212     function getFibo(uint n) internal returns (uint){
213         if(n<=1){
214             return n;
215         }
216         else{
217             return getFibo(n-1) + getFibo(n-2);
218         }
219     }
220     
221     function getPlayerUsableTokensCount() internal returns (uint8){
222         uint8 count = 0;
223         for(uint8 i=0;i< playersToken[msg.sender].length;i++){
224             if(!playersToken[msg.sender][i].used){
225                count++; 
226             }
227         }
228         return count;
229     }
230     
231     function usePlayerToken() internal returns (bool){
232         var used = false;
233         for(uint8 i=0;i< playersToken[msg.sender].length;i++){
234             if(!playersToken[msg.sender][i].used && !used){
235                 playersToken[msg.sender][i].used = true;
236                 used = true;
237                 tokenUsed++;
238                 TokenUsed(playersToken[msg.sender][i].tokenId,playersToken[msg.sender][i].playerId);
239             }
240         }
241         return used;
242     }
243 }