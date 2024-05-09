1 pragma solidity 0.4.24;
2 
3 contract Owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0));
17         owner = newOwner;
18     }
19 }
20 
21 contract Lottery is Owned {
22     string constant version = "1.0.0";
23 
24     address admin;
25 
26     mapping (uint => Game) public games;
27 
28     mapping (uint => mapping (address => Ticket[])) public tickets;
29 
30     mapping (address => uint) public withdrawGameIndex;
31 
32     mapping (address => uint) allowed;
33 
34     uint public gameIndex;
35 
36     uint public goldKeyJackpot;
37 
38     uint public firstPrizeJackpot;
39 
40     uint public bonusJackpot;
41 
42     uint public nextPrice;
43 
44     bool public buyEnable = true;
45 
46     mapping(bytes32 => uint) keys;
47 
48     uint currentMappingVersion;
49 
50     struct Ticket {
51         address user;
52         uint[] numbers;
53         uint buyTime;
54     }
55 
56     struct Game {
57         uint startTime;
58         uint price;
59         uint ticketIndex;
60         uint[] winNumbers;
61         uint goldKey;
62         uint blockIndex;
63         string blockHash;
64         uint averageBonus;
65     }
66 
67     modifier onlyAdmin() {
68         require(msg.sender == admin);
69         _;
70     }
71 
72     function depositOwnership(address admin_) public onlyOwner {
73         require(admin_ != address(0));
74         admin = admin_;
75     }
76 
77     constructor() public {
78         nextPrice = 0.01 ether;
79         games[0].price = nextPrice;
80         games[0].startTime = now;
81     }
82 
83     function() public payable {
84         require(buyEnable);
85         require(address(this) != msg.sender);
86         require(msg.data.length > 9);
87         require(msg.data.length % 9 == 1);
88         Game storage game = games[gameIndex];
89         uint count = uint(msg.data[0]);
90         require(msg.value == count * game.price);
91         Ticket[] storage tickets_ = tickets[gameIndex][msg.sender];
92         uint goldCount = 0;
93         uint i = 1;
94         while(i < msg.data.length) {
95             uint[] memory number_ = new uint[](9);
96             for(uint j = 0; j < 9; j++) {
97                 number_[j] = uint(msg.data[i++]);
98             }
99             goldCount += number_[1];
100             tickets_.push(Ticket(msg.sender, number_, now));
101             game.ticketIndex++;
102         }
103         if(goldCount > 0) {
104             uint goldKey_ = getKeys(msg.sender);
105             require(goldKey_ >= goldCount);
106             goldKey_ -= goldCount;
107             bytes32 key = keccak256(abi.encodePacked(currentMappingVersion, msg.sender));
108             keys[key] = goldKey_;
109         }
110         uint amount = msg.value * 4 / 10;
111         firstPrizeJackpot += amount;
112         bonusJackpot += amount;
113         goldKeyJackpot += amount;
114         if(goldKeyJackpot >= 1500 ether) {
115             game.goldKey++;
116             goldKeyJackpot -= 1500 ether;
117         }
118         emit LogBuyTicket(gameIndex, msg.sender, msg.data, firstPrizeJackpot, bonusJackpot);
119     }
120 
121     function getWinNumbers(string blockHash) public pure returns (uint[]){
122         bytes32 random = keccak256(bytes(blockHash));
123         uint[] memory allRedNumbers = new uint[](40);
124         uint[] memory allBlueNumbers = new uint[](10);
125         uint[] memory winNumbers = new uint[](6);
126         for (uint i = 0; i < 40; i++) {
127             allRedNumbers[i] = i + 1;
128             if(i < 10) {
129                 allBlueNumbers[i] = i;
130             }
131         }
132         for (i = 0; i < 5; i++) {
133             uint n = 40 - i;
134             uint r = (uint(random[i * 4]) + (uint(random[i * 4 + 1]) << 8) + (uint(random[i * 4 + 2]) << 16) + (uint(random[i * 4 + 3]) << 24)) % (n + 1);
135             winNumbers[i] = allRedNumbers[r];
136             allRedNumbers[r] = allRedNumbers[n - 1];
137         }
138         uint t = (uint(random[i * 4]) + (uint(random[i * 4 + 1]) << 8) + (uint(random[i * 4 + 2]) << 16) + (uint(random[i * 4 + 3]) << 24)) % 10;
139         winNumbers[5] = allBlueNumbers[t];
140         return winNumbers;
141     }
142 
143     function getTicketsByGameIndex(uint gameIndex_) public view returns (uint[] tickets_){
144         Ticket[] storage ticketArray = tickets[gameIndex_][msg.sender];
145         tickets_ = new uint[](ticketArray.length * 12);
146         uint k;
147         for(uint i = 0; i < ticketArray.length; i++) {
148             Ticket storage ticket = ticketArray[i];
149             tickets_[k++] = i;
150             tickets_[k++] = ticket.buyTime;
151             tickets_[k++] = games[gameIndex_].price;
152             for (uint j = 0; j < 9; j++)
153                 tickets_[k++] = ticket.numbers[j];
154         }
155     }
156 
157     function getGameByIndex(uint _gameIndex, bool lately) public view returns (uint[] res){
158         if(lately) _gameIndex = gameIndex;
159         if(_gameIndex > gameIndex) return res;
160         res = new uint[](15);
161         Game storage game = games[_gameIndex];
162         uint k;
163         res[k++] = _gameIndex;
164         res[k++] = game.startTime;
165         res[k++] = game.price;
166         res[k++] = game.ticketIndex;
167         res[k++] = bonusJackpot;
168         res[k++] = firstPrizeJackpot;
169         res[k++] = game.blockIndex;
170         if (game.winNumbers.length == 0) {
171             for (uint j = 0; j < 6; j++)
172                 res[k++] = 0;
173         } else {
174             for (j = 0; j < 6; j++)
175                 res[k++] = game.winNumbers[j];
176         }
177         res[k++] = game.goldKey;
178         res[k++] = game.averageBonus;
179     }
180 
181 //    function getGames(uint offset, uint count) public view returns (uint[] res){
182 //        if (offset > gameIndex) return res;
183 //        uint k;
184 //        uint n = offset + count;
185 //        if (n > gameIndex + 1) n = gameIndex + 1;
186 //        res = new uint[]((n - offset) * 15);
187 //        for(uint i = offset; i < n; i++) {
188 //            Game storage game = games[i];
189 //            res[k++] = i;
190 //            res[k++] = game.startTime;
191 //            res[k++] = game.price;
192 //            res[k++] = game.ticketIndex;
193 //            res[k++] = bonusJackpot;
194 //            res[k++] = firstPrizeJackpot;
195 //            res[k++] = game.blockIndex;
196 //            if (game.winNumbers.length == 0) {
197 //                for (uint j = 0; j < 6; j++)
198 //                    res[k++] = 0;
199 //            } else {
200 //                for (j = 0; j < 6; j++)
201 //                    res[k++] = game.winNumbers[j];
202 //            }
203 //            res[k++] = game.goldKey;
204 //            res[k++] = game.averageBonus;
205 //        }
206 //    }
207 
208     function stopCurrentGame(uint blockIndex) public onlyOwner {
209         Game storage game = games[gameIndex];
210         buyEnable = false;
211         game.blockIndex = blockIndex;
212         emit LogStopCurrentGame(gameIndex, blockIndex);
213     }
214 
215     function drawNumber(uint blockIndex, string blockHash) public onlyOwner returns (uint[] res){
216         Game storage game = games[gameIndex];
217         require(game.blockIndex > 0);
218         require(blockIndex > game.blockIndex);
219         game.blockIndex = blockIndex;
220         game.blockHash = blockHash;
221         game.winNumbers = getWinNumbers(blockHash);
222         emit LogDrawNumbers(gameIndex, blockIndex, blockHash, game.winNumbers);
223         res = game.winNumbers;
224     }
225 
226     function drawReuslt(uint goldCount, address[] goldKeys, address[] jackpots, uint _jackpot, uint _bonus, uint _averageBonus) public onlyOwner {
227         firstPrizeJackpot -= _jackpot;
228         bonusJackpot -= _bonus;
229         Game storage game = games[gameIndex];
230         if(jackpots.length > 0 && _jackpot > 0) {
231             deleteAllReports();
232             uint amount = _jackpot / jackpots.length;
233             for(uint j = 0; j < jackpots.length; j++) {
234                 allowed[jackpots[j]] += amount;
235             }
236         } else {
237             for(uint i = 0; i < goldKeys.length; i++) {
238                 game.goldKey += goldCount;
239                 rewardKey(goldKeys[i], 1);
240             }
241         }
242         game.averageBonus = _averageBonus;
243         emit LogDrawReuslt(gameIndex, goldCount, goldKeys, jackpots, _jackpot, _bonus, _averageBonus);
244     }
245 
246     function getAllowed(address _address) public onlyOwner view returns(uint) {
247         return allowed[_address];
248     }
249 
250     function withdraw() public payable {
251         uint amount = allowance();
252         require(amount >= 0.05 ether);
253         withdrawGameIndex[msg.sender] = gameIndex;
254         allowed[msg.sender] = 0;
255         msg.sender.transfer(amount);
256         emit LogTransfer(gameIndex, msg.sender, amount);
257     }
258 
259     function allowance() public view returns (uint amount) {
260         uint gameIndex_ = withdrawGameIndex[msg.sender];
261         if(gameIndex_ == gameIndex) return amount;
262         require(gameIndex_ < gameIndex);
263         amount += allowed[msg.sender];
264         for(uint i = gameIndex_; i < gameIndex; i++) {
265             Game storage game = games[i];
266             Ticket[] storage tickets_ = tickets[i][msg.sender];
267             for(uint j = 0; j < tickets_.length; j++) {
268                 Ticket storage ticket = tickets_[j];
269                 if(game.winNumbers[5] != ticket.numbers[8]) {
270                     amount += game.averageBonus * ticket.numbers[2];
271                 }
272             }
273         }
274     }
275 
276     function startNextGame() public onlyOwner {
277         buyEnable = true;
278         gameIndex++;
279         games[gameIndex].startTime = now;
280         games[gameIndex].price = nextPrice;
281         emit LogStartNextGame(gameIndex);
282     }
283 
284     function addJackpotGuaranteed(uint addJackpot) public onlyOwner {
285         firstPrizeJackpot += addJackpot;
286     }
287 
288     function rewardKey(address _user, uint gold) public onlyOwner {
289         uint goldKey = getKeys(_user);
290         goldKey += gold;
291         setKeys(_user, goldKey);
292         emit LogRewardKey(_user, gold);
293     }
294 
295     function getKeys(address _key) public view returns(uint) {
296         bytes32 key = keccak256(abi.encodePacked(currentMappingVersion, _key));
297         return keys[key];
298     }
299 
300     function setKeys(address _key, uint _value) private onlyOwner {
301         bytes32 key = keccak256(abi.encodePacked(currentMappingVersion, _key));
302         keys[key] = _value;
303     }
304 
305     function deleteAllReports() public onlyOwner {
306         Game storage game = games[gameIndex];
307         game.goldKey = 0;
308         currentMappingVersion++;
309         emit LogDeleteAllReports(gameIndex, currentMappingVersion);
310     }
311 
312     function killContract() public onlyOwner {
313         selfdestruct(msg.sender);
314         emit LogKillContract(msg.sender);
315     }
316 
317     function setPrice(uint price) public onlyOwner {
318         nextPrice = price;
319         emit LogSetPrice(price);
320     }
321 
322     function setBuyEnable(bool _buyEnable) public onlyOwner {
323         buyEnable = _buyEnable;
324         emit LogSetBuyEnable(msg.sender, _buyEnable);
325     }
326 
327     function adjustPrizePoolAfterWin(uint _jackpot, uint _bonus) public onlyOwner {
328         firstPrizeJackpot -= _jackpot;
329         bonusJackpot -= _bonus;
330         emit LogAdjustPrizePoolAfterWin(gameIndex, _jackpot, _bonus);
331     }
332 
333     function transferToOwner(uint bonus) public payable onlyOwner {
334         msg.sender.transfer(bonus);
335         emit LogTransfer(gameIndex, msg.sender, bonus);
336     }
337 
338     event LogBuyTicket(uint indexed _gameIndex, address indexed from, bytes numbers, uint _firstPrizeJackpot, uint _bonusJackpot);
339     event LogRewardKey(address indexed _user, uint _gold);
340     event LogAwardWinner(address indexed _user, uint[] _winner);
341     event LogStopCurrentGame(uint indexed _gameIndex, uint indexed _blockIndex);
342     event LogDrawNumbers(uint indexed _gameIndex, uint indexed _blockIndex, string _blockHash, uint[] _winNumbers);
343     event LogStartNextGame(uint indexed _gameIndex);
344     event LogDeleteAllReports(uint indexed _gameIndex, uint _currentMappingVersion);
345     event LogKillContract(address indexed _owner);
346     event LogSetPrice(uint indexed _price);
347     event LogSetBuyEnable(address indexed _owner, bool _buyEnable);
348     event LogTransfer(uint indexed _gameIndex, address indexed from, uint value);
349     event LogApproval(address indexed _owner, address indexed _spender, uint256 _value);
350     event LogAdjustPrizePoolAfterWin(uint indexed _gameIndex, uint _jackpot, uint _bonus);
351     event LogDrawReuslt(uint indexed _gameIndex, uint _goldCount, address[] _goldKeys, address[] _jackpots, uint _jackpot, uint _bonus, uint _averageBonus);
352 }