1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   address public admin;
11   uint256 public lockedIn;
12   uint256 public OWNER_AMOUNT;
13   uint256 public OWNER_PERCENT = 2;
14   uint256 public OWNER_MIN = 0.0001 ether;
15   
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor(address addr, uint256 percent, uint256 min) public {
28     require(addr != address(0), 'invalid addr');
29     owner = msg.sender;
30     admin = addr;
31     OWNER_PERCENT = percent;
32     OWNER_MIN = min;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender==owner || msg.sender==admin);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    * @notice Renouncing to ownership will leave the contract without an owner.
46    * It will not be possible to call the functions with the `onlyOwner`
47    * modifier anymore.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(owner);
51     owner = address(0);
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address _newOwner) public onlyOwner {
59     _transferOwnership(_newOwner);
60   }
61 
62   /**
63    * @dev Transfers control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function _transferOwnership(address _newOwner) internal {
67     require(_newOwner != address(0));
68     emit OwnershipTransferred(owner, _newOwner);
69     owner = _newOwner;
70   }
71 
72   function _cash() public view returns(uint256){
73       return address(this).balance;
74   }
75 
76   function kill() onlyOwner public{
77     require(lockedIn == 0, "invalid lockedIn");
78     selfdestruct(owner);
79   }
80   
81   function setAdmin(address addr) onlyOwner public{
82       require(addr != address(0), 'invalid addr');
83       admin = addr;
84   }
85   
86   function setOwnerPercent(uint256 percent) onlyOwner public{
87       OWNER_PERCENT = percent;
88   }
89   
90   function setOwnerMin(uint256 min) onlyOwner public{
91       OWNER_MIN = min;
92   }
93   
94   function _fee() internal returns(uint256){
95       uint256 fe = msg.value*OWNER_PERCENT/100;
96       if(fe < OWNER_MIN){
97           fe = OWNER_MIN;
98       }
99       OWNER_AMOUNT += fe;
100       return fe;
101   }
102   
103   function cashOut() onlyOwner public{
104     require(OWNER_AMOUNT > 0, 'invalid OWNER_AMOUNT');
105     owner.send(OWNER_AMOUNT);
106   }
107 
108   modifier isHuman() {
109       address _addr = msg.sender;
110       uint256 _codeLength;
111       assembly {_codeLength := extcodesize(_addr)}
112       require(_codeLength == 0, "sorry humans only");
113       _;
114   }
115 
116   modifier isContract() {
117       address _addr = msg.sender;
118       uint256 _codeLength;
119       assembly {_codeLength := extcodesize(_addr)}
120       require(_codeLength > 0, "sorry contract only");
121       _;
122   }
123 }
124 
125 /**
126  * luck100.win - Fair Ethereum game platform
127  * 
128  * Multiple dice
129  * 
130  * Winning rules:
131  * 
132  * result = sha3(txhashA + txhashB + blockhash(startN+n*10)) % 6 + 1
133  * 
134  * 1.After the contract is created, the starting block startN is obtained. 
135  * After that, each new 10 blocks in Ethereum automatically generates one game;
136  * 
137  * 2.The player chooses a bet of 1-6 and bets up to 5 digits at the same time;
138  * 
139  * 3.In the same game, player A gets the transaction hash txhashA after successful bet, 
140  * and player B gets the transaction hash txhashB after successful bet...;
141  * 
142  * 4.Take the last block of the board, hash blockhash;
143  * 
144  * 5.TxhashA, txhashB... and blockhash are subjected to sha3 encryption operation, 
145  * and then modulo with 6 to get the result of the lottery.
146  */
147 
148 contract DiceLuck100 is Ownable{
149     event betEvent(uint256 indexed gameIdx, uint256 betIdx, address addr, uint256 betBlockNumber, uint256 betMask, uint256 amount);
150     event openEvent(uint256 indexed gameIdx, uint256 openBlockNumber, uint256 openNumber, bytes32 txhash, uint256 winNum);
151     struct Bet{
152         address addr;
153         uint256 betBlockNumber;
154         uint256 betMask;
155         uint256 amount;
156         uint256 winAmount;
157         bool isWin;
158     }
159     struct Game{
160         uint256 openBlockNumber;
161         uint256 openNumber;
162         uint256 locked;
163         bytes32 txhash;
164         bytes32 openHash;
165         Bet[] bets;
166     }
167     mapping(uint256=>Game) gameList;
168     Game _eg;
169     uint256 public firstBN;
170     uint256 constant MIN_BET = 0.01 ether;
171     uint8 public N = 10;
172     uint8 constant M = 6;
173     uint16[M] public MASKS = [0, 32, 48, 56, 60, 62];
174     uint16[M] public AMOUNTS = [0, 101, 253, 510, 1031, 2660];
175     uint16[M] public ODDS = [0, 600, 300, 200, 150, 120];
176     
177     constructor(address addr, uint256 percent, uint256 min) Ownable(addr, percent, min) public{
178         firstBN = block.number;
179     }
180     
181     function() public payable{
182         uint8 diceNum = uint8(msg.data.length);
183         uint256 betMask = 0;
184         uint256 t = 0;
185         for(uint8 i=0;i<diceNum;i++){
186             t = uint256(msg.data[i]);
187             if(t==0 || t>M){
188                 diceNum--;
189                 continue;
190             }
191             betMask += 2**(t-1);
192         }
193         if(diceNum==0) return ;
194         _placeBet(betMask, diceNum);
195     }
196     
197     function placeBet(uint256 betMask, uint8 diceNum) public payable{
198         _placeBet(betMask, diceNum);
199     }
200     
201     function _placeBet(uint256 betMask, uint8 diceNum) private{
202         require(diceNum>0 && diceNum<M, 'invalid diceNum');
203         uint256 MAX_BET = AMOUNTS[diceNum]/100*(10**18);
204         require(msg.value>=MIN_BET && msg.value<=MAX_BET, 'invalid amount');
205         require(betMask>0 && betMask<=MASKS[diceNum], 'invalid betMask');
206         uint256 fee = _fee();
207         uint256 winAmount = (msg.value-fee)*ODDS[diceNum]/100;
208         lockedIn += winAmount;
209         uint256 gameIdx = (block.number-firstBN-1)/N;
210         if(gameList[gameIdx].openBlockNumber == 0){
211             gameList[gameIdx] = _eg;
212             gameList[gameIdx].openBlockNumber = firstBN + (gameIdx+1)*N;
213         }
214         gameList[gameIdx].locked += winAmount;
215         gameList[gameIdx].bets.push(Bet({
216             addr:msg.sender,
217             betBlockNumber:block.number,
218             betMask:betMask,
219             amount:msg.value,
220             winAmount:winAmount,
221             isWin:false
222         }));
223         emit betEvent(gameIdx, gameList[gameIdx].bets.length-1, msg.sender, block.number, betMask, msg.value);
224     }
225     
226     function setN(uint8 n) onlyOwner public{
227         uint256 gameIdx = (block.number-firstBN-1)/N;
228         firstBN = firstBN + (gameIdx+1)*N;
229         N = n;
230     }
231     
232     function open(uint256 gameIdx, bytes32 txhash, uint256 txNum) onlyOwner public{
233         uint256 openBlockNumber = gameList[gameIdx].openBlockNumber;
234         bytes32 openBlockHash = blockhash(openBlockNumber);
235         require(uint256(openBlockHash)>0, 'invalid openBlockNumber');
236         _open(gameIdx, txhash, openBlockHash, txNum);
237     }
238     
239     function open2(uint256 gameIdx, bytes32 txhash, bytes32 openBlockHash, uint256 txNum) onlyOwner public{
240         _open(gameIdx, txhash, openBlockHash, txNum);
241     }
242     
243     function _open(uint256 gameIdx, bytes32 txhash, bytes32 openBlockHash, uint256 txNum) private{
244         Game storage game = gameList[gameIdx];
245         uint256 betNum = game.bets.length;
246         uint256 openBN = firstBN + (gameIdx+1)*N;
247         require(openBN==game.openBlockNumber && game.openNumber==0 && betNum==txNum, 'invalid bet');
248         lockedIn -= game.locked;
249         bytes32 openHash = keccak256(abi.encodePacked(txhash, openBlockHash));
250         uint256 r = uint256(openHash) % M;
251         uint256 R = 2**r;
252         game.openNumber = r+1;
253         game.txhash = txhash;
254         game.openHash = openHash;
255         uint256 t = 0;
256         uint256 winNum = 0;
257         for(uint256 i=0;i<betNum;i++){
258             t = game.bets[i].betMask & R;
259             if(t > 0){
260                 game.bets[i].isWin = true;
261                 (game.bets[i].addr).send(game.bets[i].winAmount);
262                 winNum++;
263             }
264         }
265         emit openEvent(gameIdx, game.openBlockNumber, game.openNumber, txhash, winNum);
266     }
267     
268     function getGame(uint256 gameIdx) view public returns(uint256,uint256,uint256,uint256,uint256,uint256,bytes32,bytes32){
269         Game memory g = gameList[gameIdx];
270         uint256 amount = 0;
271         uint256 winAmount = 0;
272         uint256 winNum = 0;
273         for(uint256 i=0;i<g.bets.length;i++){
274             amount += g.bets[i].amount;
275             if(g.bets[i].isWin){
276                 winNum++;
277                 winAmount += g.bets[i].winAmount;
278             }
279         }
280         return (g.openBlockNumber, g.openNumber, g.bets.length, winNum, amount, winAmount, g.txhash, g.openHash);
281     }
282     
283     function getBets(uint256 gameIdx) view public returns(address[] addrs,uint256[] bns,uint256[] masks,uint256[] amounts,uint256[] winAmounts,bool[] isWins){
284         uint256 betNum = gameList[gameIdx].bets.length;
285         addrs = new address[](betNum);
286         bns = new uint256[](betNum);
287         masks = new uint256[](betNum);
288         amounts = new uint256[](betNum);
289         winAmounts = new uint256[](betNum);
290         isWins = new bool[](betNum);
291         for(uint256 i=0;i<betNum;i++){
292             Bet memory b = gameList[gameIdx].bets[i];
293             addrs[i] = b.addr;
294             bns[i] = b.betBlockNumber;
295             masks[i] = b.betMask;
296             amounts[i] = b.amount;
297             winAmounts[i] = b.winAmount;
298             isWins[i] = b.isWin;
299         }
300     }
301     
302     
303     function withdraw() onlyOwner public{
304         msg.sender.transfer(address(this).balance);
305     }
306     
307     function output() view public returns(uint256, uint8,uint256,uint256,uint16[M],uint16[M],uint16[M]){
308         return (firstBN, N, OWNER_PERCENT, OWNER_MIN, MASKS, AMOUNTS, ODDS);
309     }
310 }