1 pragma solidity >=0.5.0 <0.7.0;
2 
3 /**
4 Owned contract
5  */
6 contract Owned {
7   address payable public owner;
8   address payable public newOwner;
9 
10   event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12   constructor () public {
13     owner = msg.sender;
14   }
15 
16   modifier onlyOwner {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   function transferOwnership(address payable _newOwner) public onlyOwner {
22     newOwner = _newOwner;
23   }
24 
25   function acceptOwnership() public {
26     require(msg.sender == newOwner);
27     emit OwnershipTransferred(owner, newOwner);
28     owner = newOwner;
29     newOwner = address(0);
30   }
31 }
32 
33 contract CryptoLott is Owned {
34 
35   struct Player {
36     address payable playerAddress;
37     string playerName;
38     uint64[] playerNumbers;
39   }
40 
41   enum State {
42     Accepting,
43     Finished
44   }
45 
46   uint64 private constant UINT64_MAX = ~uint64(0);
47 
48   State private state;
49   Player[] private playerList;
50   address[] private winnerAddressList;
51   uint64 private playerInSession;
52   uint64 private lastLuckyNumber;
53   uint256 private totalFund;
54   uint256 private lastTotalFund;
55 
56   address payable private charityAddress;
57   uint256 private minPrice;
58   uint64 private maxPlayerRandom;
59   uint64 private playerRandomPadding;
60   uint64 private maxLuckyNumberRandom;
61   uint64 private luckyNumberRandomPadding;
62   uint8 private charityRate;
63   uint8 private winnerRate;
64   bool private contractActive;
65   bool private hasWinner;
66 
67   uint public startRound;
68   uint public endRound;
69 
70   // @anomous: Event
71   event PlayerRegisterEvent(address indexed _playerAddress);
72   event GameSessionBeginEvent(uint256 _minPrice, uint64 _playerInSession, uint8 _charityRate, uint8 _winnerRate, uint64 _luckyNumberRange);
73   event GameSessionEndEvent(address[] indexed _winnerAddressList, uint64 _luckyNumber, uint256 _totalReward);
74 
75   constructor () public {
76     hasWinner = true;
77     contractActive = true;
78     charityAddress = owner;
79     minPrice = 0.01 ether;
80     maxPlayerRandom = 2;
81     playerRandomPadding = 5;
82     maxLuckyNumberRandom = 255;
83     luckyNumberRandomPadding = 0;
84     charityRate = 15;
85     winnerRate = 60;
86     //-------------
87     gameInit();
88   }
89 
90   function enableContract(bool status) public onlyOwner {
91     contractActive = status;
92     if (status == false && state == State.Accepting && totalFund > 0 && playerList.length > 0) {
93       finishGame();
94     } else if (status == true) {
95       gameInit();
96     }
97   }
98 
99   function upCharityAddress(address payable _charityAddress) public onlyOwner {
100     charityAddress = _charityAddress;
101   }
102 
103   function config(uint256 _minPrice, uint64 _maxPlayerRandom,
104     uint64 _maxLuckyNumberRandom, uint8 _charityRate, uint8 _winnerRate) public onlyOwner {
105     require(contractActive == false, "Need to disable the contract first");
106     require(_minPrice >= 0.005 ether, "minPrice > 0.005");
107     require(_maxPlayerRandom > 1, "maxPlayerRandom >= 2");
108     require(_maxLuckyNumberRandom > 9, "maxLuckyNumberRandom >= 10");
109     minPrice = _minPrice;
110     maxPlayerRandom = _maxPlayerRandom;
111     playerRandomPadding = 5;
112     maxLuckyNumberRandom = _maxLuckyNumberRandom;
113     luckyNumberRandomPadding = 0;
114     charityRate = _charityRate;
115     winnerRate = _winnerRate;
116   }
117 
118   function gameInit() private {
119     require(contractActive == true, "Contract was disabled");
120     if (hasWinner) {
121       totalFund = 0;
122       hasWinner = false;
123     }
124     startRound = now;
125     playerList.length = 0;
126     playerInSession = randomMaxPlayer();
127     state = State.Accepting;
128     emit GameSessionBeginEvent(minPrice, playerInSession, charityRate, winnerRate, maxLuckyNumberRandom);
129   }
130 
131   // Register player
132   function playerRegister(string memory name, uint64[] memory numbers) payable public {
133     require(contractActive == true, "Contract was disabled");
134     require(state == State.Accepting, "Game state is not valid");
135     require(numbers.length > 0, "At least 1 number");
136     require(msg.value >= minPrice * numbers.length, "Value is not valid");
137 
138     for (uint i = 0; i < playerList.length; i++) {
139       require(playerList[i].playerAddress != msg.sender);
140       for (uint j = 0; j < playerList[i].playerNumbers.length; j++) {
141         require(playerList[i].playerNumbers[j] <= maxLuckyNumberRandom);
142       }
143     }
144 
145     totalFund += msg.value;
146     Player memory player = Player(msg.sender, name, numbers);
147     playerList.push(player);
148     emit PlayerRegisterEvent(player.playerAddress);
149 
150     if (playerList.length >= playerInSession) {
151       finishGame();
152 
153       if (contractActive) {
154         // Init new game session
155         gameInit();
156       }
157     }
158   }
159 
160   function getMinPrice() public view returns (uint256) {
161     return uint256(minPrice);
162   }
163 
164   function getCountPlayer() public view returns (uint64) {
165     return uint64(playerList.length);
166   }
167 
168   function getMaxPlayer() public view returns (uint64) {
169     return uint64(playerInSession);
170   }
171 
172   function getMaxLuckyRandomNumber() public view returns (uint64) {
173     return uint64(maxLuckyNumberRandom);
174   }
175 
176   function getLastTotalFund() public view returns (uint256) {
177     return uint256(lastTotalFund);
178   }
179 
180   function getLastLuckyNumber() public view returns (uint64) {
181     return uint64(lastLuckyNumber);
182   }
183 
184   function getCurrentFund() public view returns (uint256) {
185     return uint256(totalFund);
186   }
187 
188   function getCharityAddress() public view returns (address) {
189     return address(charityAddress);
190   }
191 
192   function getOwnerAddress() public view returns (address) {
193     return address(owner);
194   }
195 
196   function getPlayerInfo(address playerAddress) public view returns (string memory playerName, uint64[] memory playerNumbers) {
197     Player memory player;
198     for (uint i = 0; i < playerList.length; i++) {
199       if (playerList[i].playerAddress == playerAddress) {
200         player = playerList[i];
201         break;
202       }
203     }
204     return (player.playerName, player.playerNumbers);
205   }
206 
207   function finishGame() private {
208     state = State.Finished;
209     // Finish session && find winner
210     lastTotalFund = totalFund;
211     lastLuckyNumber = randomLuckyNumber();
212 
213     winnerAddressList.length = 0;
214     // Determine winner
215     for (uint i = 0; i < playerList.length; i++) {
216       for (uint j = 0; j < playerList[i].playerNumbers.length; j++) {
217         if (playerList[i].playerNumbers[j] == lastLuckyNumber) {
218           winnerAddressList.push(playerList[i].playerAddress);
219         }
220       }
221     }
222 
223     // Distribute Funds
224     uint256 winnerFunds = 0;
225     bool success = false;
226     bytes memory _;
227     if (winnerAddressList.length > 0) {
228       uint256 winnerFund = totalFund * winnerRate / 100 / winnerAddressList.length;
229       for (uint i = 0; i < winnerAddressList.length; i++) {
230         (success, _) = winnerAddressList[i].call.value(winnerFund).gas(20317)("");
231         if (!success) {
232           revert();
233         }
234         winnerFunds += winnerFund;
235       }
236       hasWinner = true;
237     } else {
238       winnerFunds = totalFund * 50 / 100;
239     }
240 
241     uint256 charityFund = totalFund * charityRate / 100;
242     if (!hasWinner) {
243       charityFund += totalFund * 5 / 100;
244     }
245 
246     (success, _) = charityAddress.call.value(charityFund).gas(20317)("");
247     if (!success) {
248       revert();
249     }
250     (success, _) = owner.call.value(totalFund - winnerFunds - charityFund).gas(20317)("");
251     if (!success) {
252       revert();
253     }
254     totalFund = winnerFunds;
255 
256     endRound = now;
257     if (endRound - startRound < 2 days) {
258       if (playerRandomPadding < UINT64_MAX) playerRandomPadding ++;
259       if (luckyNumberRandomPadding < UINT64_MAX) luckyNumberRandomPadding ++;
260       if (maxPlayerRandom < 1000) maxPlayerRandom ++;
261     } else if (playerRandomPadding > 5) {
262       playerRandomPadding --;
263     }
264 
265     emit GameSessionEndEvent(winnerAddressList, lastLuckyNumber, lastTotalFund);
266   }
267 
268   function toBytes(uint256 x) internal pure returns (bytes memory b) {
269     b = new bytes(32);
270     assembly {mstore(add(b, 32), x)}
271   }
272 
273   function random() private view returns (uint64) {
274     uint64 randomNumber = uint64(uint256(keccak256(toBytes(block.timestamp + block.difficulty))));
275     for (uint i = 0; i < playerList.length; i++) {
276       for (uint j = 0; j < playerList[i].playerNumbers.length; j++) {
277         randomNumber ^= playerList[i].playerNumbers[j];
278       }
279     }
280     return randomNumber;
281   }
282 
283   function randomLuckyNumber() private view returns (uint64) {
284     return random() % (maxLuckyNumberRandom + 1 + luckyNumberRandomPadding);
285   }
286 
287   function randomMaxPlayer() private view returns (uint64) {
288     return (random() % (maxPlayerRandom + 1)) + playerRandomPadding;
289   }
290 }