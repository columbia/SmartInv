1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint256 a, uint256 b) internal pure returns(uint256) {
24         assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      */
33     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns(uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47      /**
48      * @dev x to the power of y 
49      */
50     function pwr(uint256 x, uint256 y)
51         internal 
52         pure 
53         returns (uint256)
54     {
55         if (x==0)
56             return (0);
57         else if (y==0)
58             return (1);
59         else{
60             uint256 z = x;
61             for (uint256 i = 1; i < y; i++)
62                 z = mul(z,x);
63             return (z);
64         }
65     }
66 }
67 
68 
69 interface shareProfit {
70     function increaseProfit() external payable returns(bool);
71 }
72 
73 contract RobTheBank{
74     using SafeMath for uint256;
75     
76     uint256 public constant BASE_PRICE = 0.003 ether;
77     address public owner;
78     address public service;
79     struct Big {
80         uint256 totalKey;
81         uint256 jackpotBalance;
82         uint256 KeyProfit;
83         mapping (address=>uint256) received;
84         address winner;
85         uint256 winnerProfit;
86     }
87     struct Small {
88         uint256 totalKey;
89         address winner;
90         uint256 startTime;
91         uint256 endTime;
92         uint256 winKey;
93         uint256 winnerProfit;
94     }
95     struct KeyPurchases {
96         KeyPurchase[] keysBought;
97         uint256 numPurchases;
98     }
99     struct KeyPurchase {
100         uint256 startId;
101         uint256 endId;
102     }
103     mapping (uint256=>Big) public bigRound;
104     mapping (uint256=>mapping (uint256=>Small)) public smallRound;
105     shareProfit public RTB1;
106     shareProfit public RTB2;
107     mapping (uint256=>mapping (uint256=>mapping (address=>uint256))) public userSmallRoundkey;
108     mapping (uint256=>mapping (address=>uint256)) public userBigRoundKey;
109     mapping (uint256=>mapping (uint256=>mapping (address=>KeyPurchases))) public userXkeyPurchases;
110     uint256 keysBought;
111     mapping (address=>uint256) public recommender;
112     mapping (address=>bool) public recommenderAllow;
113     uint256 public allowPrice;
114     uint256 devFee;
115     uint256 public smallId;
116     uint256 public bigId;
117     bool public isPaused = false;
118     
119     event buyEvent(address indexed _buyer, uint256 _amount, uint256 _total, uint256 _bigRound, uint256 _smallRound, uint256 _startId, uint256 _endId, uint256 _index);
120     event lotteryEvent(address indexed _winner, uint256 _bigRound, uint256 _smallRound, uint256 _money, uint256 _type);
121     event withdrawEvent(address indexed _winner, uint256 _amount, uint256 _round);
122     event RecommenderAllow(address indexed _user, bool _status);
123     event createKey(uint256 _winkey, uint256 _bigRound, uint256 _smallRound);
124 
125     modifier onlyOwner() {
126         require(msg.sender == owner, "only owner");
127         _;
128     }
129 
130     modifier onlyService() {
131         require(msg.sender == service, "only service");
132         _;
133     }
134 
135     modifier whenNotPaused() {
136         require(!isPaused, "is Paused");
137         _;
138     }
139 
140     modifier isHuman() {
141         address _addr = msg.sender;
142         uint256 _codeLength;
143         
144         assembly {_codeLength := extcodesize(_addr)}
145         require(_codeLength == 0, "sorry humans only");
146         _;
147     }
148 
149     constructor (address _rtb1, address _rtb2) public {
150         owner = msg.sender;
151         service = msg.sender;
152         bigId = 1;
153         smallId = 1;
154         allowPrice = 0.01 ether;
155         RTB1 = shareProfit(_rtb1);
156         RTB2 = shareProfit(_rtb2);
157     }
158 
159     function() external payable{
160         require(msg.value > 0);
161         bigRound[bigId].jackpotBalance = bigRound[bigId].jackpotBalance.add(msg.value);
162     }
163     
164     ///@dev Start new game
165     function startGame() public onlyOwner{
166         uint256 time = block.timestamp;
167         smallRound[bigId][smallId].startTime = time;
168         smallRound[bigId][smallId].endTime = time + 41400;
169     }
170     
171     ///@dev Buy key
172     function buy(uint256 _amount, address _invite) public isHuman whenNotPaused payable{
173         require(smallRound[bigId][smallId].startTime < block.timestamp, "The game has not started yet");
174         require(smallRound[bigId][smallId].endTime > block.timestamp, "The game is over");
175         uint256 _money = _amount.mul(getPrice());
176         require(_amount > 0 && _money > 0);
177         require(_money == msg.value, "The amount is incorrect");
178 
179         if (_invite != address(0) && _invite != msg.sender && recommenderAllow[_invite] == true){
180             recommender[_invite] = _money.mul(10).div(100).add(recommender[_invite]);
181             _money = _money.mul(90).div(100);
182         }
183 
184         _buy(_amount, _money);
185     }
186     
187     ///@dev Use vault
188     function buyAgain(uint256 _amount) public isHuman whenNotPaused {
189         require(smallRound[bigId][smallId].startTime < block.timestamp, "The game has not started yet");
190         require(smallRound[bigId][smallId].endTime > block.timestamp, "The game is over");
191         uint256 _money = _amount.mul(getPrice());
192         uint256 profit = getMyProfit(bigId);
193         require(_amount > 0 && _money > 0);
194         require(profit >= _money);
195         bigRound[bigId].received[msg.sender] = _money.add(bigRound[bigId].received[msg.sender]);
196         _buy(_amount, _money);
197     }
198     
199     function _buy(uint256 _amount, uint256 _money) internal whenNotPaused{
200         //Number of record keys
201         userBigRoundKey[bigId][msg.sender] = userBigRoundKey[bigId][msg.sender].add(_amount);
202         userSmallRoundkey[bigId][smallId][msg.sender] = userSmallRoundkey[bigId][smallId][msg.sender].add(_amount);
203         
204         //Record player's key
205         KeyPurchases storage purchases = userXkeyPurchases[bigId][smallId][msg.sender];
206         if (purchases.numPurchases == purchases.keysBought.length) {
207             purchases.keysBought.length += 1;
208         }
209         purchases.keysBought[purchases.numPurchases] = KeyPurchase(keysBought, keysBought + (_amount - 1)); // (eg: buy 10, get id's 0-9)
210         purchases.numPurchases++;
211         emit buyEvent(msg.sender, _amount, msg.value, bigId, smallId, keysBought, keysBought + (_amount - 1), purchases.numPurchases);
212         keysBought = keysBought.add(_amount);
213 
214         //40% for all players
215         uint256 _playerFee = _money.mul(40).div(100);
216         if(bigRound[bigId].totalKey > 0){
217             bigRound[bigId].KeyProfit = _playerFee.div(bigRound[bigId].totalKey).add(bigRound[bigId].KeyProfit);
218             bigRound[bigId].received[msg.sender] = bigRound[bigId].KeyProfit.mul(_amount).add(bigRound[bigId].received[msg.sender]);
219         }else{
220             devFee = devFee.add(_playerFee);
221         }
222 
223         //35% for jackpot
224         bigRound[bigId].jackpotBalance = _money.mul(35).div(100).add(bigRound[bigId].jackpotBalance);
225         
226         //15% for RTB1 and RTB2
227         uint256 _shareFee = _money.mul(15).div(100);
228         RTB1.increaseProfit.value(_shareFee.mul(3).div(10))(); // 300/1000 = 30%
229         RTB2.increaseProfit.value(_shareFee.mul(7).div(10))(); // 700/1000 = 70%
230         
231         //10% for winner
232         smallRound[bigId][smallId].winnerProfit = _money.mul(10).div(100).add(smallRound[bigId][smallId].winnerProfit);
233 
234         bigRound[bigId].totalKey = bigRound[bigId].totalKey.add(_amount);
235         smallRound[bigId][smallId].totalKey = smallRound[bigId][smallId].totalKey.add(_amount);
236     }
237     
238     ///@dev Create a winner
239     function createWinner() public onlyService whenNotPaused{
240         require(smallRound[bigId][smallId].endTime < block.timestamp);
241         require(smallRound[bigId][smallId].winKey == 0);
242         uint256 seed = _random();
243         smallRound[bigId][smallId].winKey = addmod(uint256(blockhash(block.number-1)), seed, smallRound[bigId][smallId].totalKey);
244         emit createKey(smallRound[bigId][smallId].winKey, bigId, smallId);
245     }
246 
247     ///@dev Lottery
248     function lottery(address _winner, uint256 _checkIndex) external onlyService whenNotPaused{
249         require(_winner != address(0));
250         require(address(this).balance > smallRound[bigId][smallId].winnerProfit);
251         
252         KeyPurchases storage keys = userXkeyPurchases[bigId][smallId][_winner];
253         if(keys.numPurchases > 0 && _checkIndex < keys.numPurchases){
254             KeyPurchase storage checkKeys = keys.keysBought[_checkIndex];
255             if(smallRound[bigId][smallId].winKey >= checkKeys.startId && smallRound[bigId][smallId].winKey <= checkKeys.endId){
256                 smallRound[bigId][smallId].winner = _winner;
257                 _winner.transfer(smallRound[bigId][smallId].winnerProfit);
258                 emit lotteryEvent(_winner, bigId, smallId, smallRound[bigId][smallId].winnerProfit, 1);
259                 
260                 _bigLottery(_winner);
261             }
262         }
263     }
264     
265     function _bigLottery(address _winner) internal whenNotPaused{
266         uint256 seed = _random();
267         uint256 mod;
268         if(smallId < 50){
269             mod = (51 - smallId) * 3 - 4;
270         }else{
271             mod = 1;
272         }
273         uint256 number =  addmod(uint256(blockhash(block.number-1)), seed, mod);
274         if(number == 0){
275             //Congratulations, win the grand prize
276             require(address(this).balance >= bigRound[bigId].jackpotBalance);
277 
278             //10% for all player
279             uint256 _playerFee = bigRound[bigId].jackpotBalance.mul(10).div(100);
280             bigRound[bigId].KeyProfit = _playerFee.div(bigRound[bigId].totalKey).add(bigRound[bigId].KeyProfit);
281             
282             //10% for next jackpot
283             uint256 _jackpotFee = bigRound[bigId].jackpotBalance.mul(10).div(100);
284             
285             //10% for RTB1 and RTB2
286             uint256 _shareFee =  bigRound[bigId].jackpotBalance.mul(10).div(100);
287             RTB1.increaseProfit.value(_shareFee.mul(3).div(10))(); // 300/1000 = 30%
288             RTB2.increaseProfit.value(_shareFee.mul(7).div(10))(); // 700/1000 = 70%
289             
290             //8% for dev
291             devFee = bigRound[bigId].jackpotBalance.mul(8).div(100).add(devFee);
292             
293             //62% for winner
294             uint256 _winnerProfit = bigRound[bigId].jackpotBalance.mul(62).div(100);
295             _winner.transfer(_winnerProfit);
296             emit lotteryEvent(_winner, bigId, smallId, _winnerProfit, 2);
297             bigRound[bigId].winnerProfit = _winnerProfit;
298             
299             //Start a new round
300             bigId++;
301             smallId = 1;
302             bigRound[bigId].jackpotBalance = _jackpotFee;
303         }else{
304             //You didn't win the grand prize
305             //Start new round
306             smallId++;
307         }
308         keysBought = 0;
309     }
310 
311     function withdraw(uint256 _round) public whenNotPaused{
312         uint profit = getMyProfit(_round);
313         uint256 money = recommender[msg.sender].add(profit);
314         require(money > 0);
315         recommender[msg.sender] = 0;
316         bigRound[_round].received[msg.sender] = bigRound[_round].received[msg.sender].add(profit);
317         msg.sender.transfer(money);
318         emit withdrawEvent(msg.sender, money, _round);
319     }
320     
321     function devWithdraw() public onlyOwner{
322         owner.transfer(devFee);
323         emit withdrawEvent(owner, devFee, 0);
324         devFee = 0;
325     }
326     
327     function getMyProfit(uint256 _round) public view returns(uint256){
328         return bigRound[_round].KeyProfit.mul(userBigRoundKey[_round][msg.sender]).sub(bigRound[_round].received[msg.sender]);
329     }
330 
331     function getPrice() public view returns(uint256) {
332         require(smallId >= 1 && smallId <= 50);
333         uint256 _round = smallId.sub(1);
334         return _round.mul(_round).mul(1200000000000000).div(25).add(BASE_PRICE);
335     }
336 
337      //random
338     function _random() internal view returns(uint256){
339         uint256 seed = uint256(keccak256( (
340             (block.timestamp).add
341             (block.difficulty).add
342             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
343             (block.gaslimit).add
344             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
345             (block.number)
346         )));
347 
348         return seed;
349     }
350     
351     function setAllowPrice(uint256 _price) public onlyOwner{
352         allowPrice = _price;
353     }
354     
355     function setRecommenderAllow() public payable{
356         require(msg.value == allowPrice);
357         require(recommenderAllow[msg.sender] == false);
358         devFee = devFee.add(msg.value);
359         emit RecommenderAllow(msg.sender, true);
360         recommenderAllow[msg.sender] = true;
361     }
362     
363     function setGame(bool _bool) public onlyOwner{
364         isPaused = _bool;
365     }
366 
367     function setService(address _addr) public onlyOwner{
368         service = _addr;
369     }
370 }