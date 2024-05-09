1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract BlockWar {
47     using SafeMath for uint256;
48     address owner;
49     mapping (uint => mapping(address => uint)) public leftUserBlockNumber;
50     mapping (uint => mapping(address => uint)) public rightUserBlockNumber;
51     mapping (uint => bool) public mapGameLeftWin;  // 0 for left, 1 for right
52     mapping (uint => uint) public mapGamePrizePerBlock;  // gamePrizePerBlock
53     mapping (address => uint) public userWithdrawRound;  //round lower than userWithdrawRound has withdraw
54     uint currentRound = 0;
55     uint leftBlockNumber = 0;
56     uint rightBlockNumber = 0;
57     uint maxBlockNumber = 1000;  
58     uint buildFee = 100 finney;
59     uint gameStartTimestamp;  // if gameEnded and currentRound==0 wait gameStartTimestamp
60     uint gameIntervalTimestamp = 600;  // how many seconds game start after game end
61     uint gamePrizePool = 0;  // game prize pool
62     uint public gameLength = 10800;  
63     uint public doCallNumber;
64     /* Modifiers */
65     modifier onlyOwner() {
66         require(owner == msg.sender);
67         _;
68     }
69 
70     modifier onlyInGame() {
71         require(now > gameStartTimestamp);
72         _;
73     }
74 
75     /* Owner */
76     function setOwner (address _owner) onlyOwner() public {
77         owner = _owner;
78     }
79 
80     function BlockWar() public {
81         owner = msg.sender;
82         gameStartTimestamp = 1535547600;  // set gameStartTimestamp
83     }
84 
85     function getBlockBuildFee(uint currentBlockNumber) public view returns(uint) {
86 		if (currentBlockNumber <= 100) {
87 			return buildFee.div(2);  // 50 percent
88 		}
89 		if (currentBlockNumber <= 200) {
90 			return buildFee.mul(3).div(4);  // 75 percent
91 		}
92 		return buildFee; // 100 percent
93     }
94 
95     function buildLeft(address inviteAddress, uint blockNumber) public payable onlyInGame {
96     	uint totalMoney = buildFee.mul(blockNumber);
97     	require(msg.value >= totalMoney);
98         require(blockNumber > 0);
99         uint excess = msg.value.sub(totalMoney);
100         uint totalBuildFee = 0;
101         for (uint i=leftBlockNumber;i<leftBlockNumber+blockNumber;i++) {
102     		totalBuildFee = totalBuildFee.add(getBlockBuildFee(i+1));
103         }
104         excess = excess.add(totalMoney.sub(totalBuildFee));
105         if (excess > 0) {
106         	msg.sender.transfer(excess);
107         }
108         // handle ether
109         uint devFee = 0;
110         uint inviteFee = 0;
111         devFee = totalBuildFee.mul(4).div(100);
112         if (inviteAddress != address(0)) {
113     		inviteFee = totalBuildFee.mul(3).div(100);
114         } else {
115     		devFee = totalBuildFee.mul(7).div(100);  // 7% percent if not invite
116         }
117         owner.transfer(devFee);
118         if (inviteFee > 0) {
119     		inviteAddress.transfer(inviteFee);
120         }
121         leftBlockNumber = leftBlockNumber.add(blockNumber);
122         gamePrizePool = gamePrizePool.add(totalBuildFee.sub(devFee).sub(inviteFee));
123 
124         // record user block number
125         leftUserBlockNumber[currentRound][msg.sender] += blockNumber;
126        	// try trigger game end
127        	trigger_game_end(totalBuildFee);
128     }
129 
130     function buildRight(address inviteAddress, uint blockNumber) public payable onlyInGame {
131 		uint totalMoney = buildFee.mul(blockNumber);
132 		require(msg.value >= totalMoney);
133         require(blockNumber > 0);
134         uint excess = msg.value.sub(totalMoney);
135         uint totalBuildFee = 0;
136         for (uint i=rightBlockNumber;i<rightBlockNumber+blockNumber;i++) {
137     		totalBuildFee = totalBuildFee.add(getBlockBuildFee(i+1));
138         }
139         excess = excess.add(totalMoney.sub(totalBuildFee));
140         if (excess > 0) {
141         	msg.sender.transfer(excess);
142         }
143         // handle ether
144         uint devFee = 0;
145         uint inviteFee = 0;
146         devFee = totalBuildFee.mul(4).div(100);
147         if (inviteAddress != address(0)) {
148     		inviteFee = totalBuildFee.mul(3).div(100);
149         } else {
150     		devFee = totalBuildFee.mul(7).div(100);  // 7% percent if not invite
151         }
152         owner.transfer(devFee);
153         if (inviteFee > 0) {
154     		inviteAddress.transfer(inviteFee);
155         }
156         rightBlockNumber = rightBlockNumber.add(blockNumber);
157         gamePrizePool = gamePrizePool.add(totalBuildFee.sub(devFee).sub(inviteFee));
158 
159         // record user block number
160         rightUserBlockNumber[currentRound][msg.sender] += blockNumber;
161        	// try trigger game end
162        	trigger_game_end(totalBuildFee);
163     }
164 
165     function trigger_game_end(uint totalBuildFee) private onlyInGame {
166 		// game end
167 		bool gameEnd = false;
168 		if (rightBlockNumber > maxBlockNumber) {
169 				gameEnd = true;
170 		}
171 		if (leftBlockNumber > maxBlockNumber) {
172 				gameEnd = true;
173 		}
174 		if (now.sub(gameStartTimestamp) > gameLength) {
175 				gameEnd = true;
176 		}
177 		if (gameEnd) {
178 			uint maxUserPrize = gamePrizePool.mul(5).div(100);
179 			uint nextGamePrizePool = gamePrizePool.div(10);
180 			if (gamePrizePool > 0) {
181 					msg.sender.transfer(maxUserPrize);
182 			}
183 			gamePrizePool = gamePrizePool.sub(maxUserPrize).sub(nextGamePrizePool);
184 			uint prizePerBlock = 0;
185 			if (leftBlockNumber > maxBlockNumber) {
186 				// right win
187 				if (rightBlockNumber > 0) {
188 				    prizePerBlock = gamePrizePool/rightBlockNumber;
189 				} else {
190 				    owner.transfer(gamePrizePool);
191 				    prizePerBlock = 0;
192 				}
193 				mapGameLeftWin[currentRound] = false;
194 			} else if (rightBlockNumber > maxBlockNumber) {
195 				// left win
196 				if (leftBlockNumber > 0) {
197 				    prizePerBlock = gamePrizePool/leftBlockNumber;
198 				} else {
199 				    owner.transfer(gamePrizePool);
200 				    prizePerBlock = 0;
201 				}
202 				mapGameLeftWin[currentRound] = true;
203 			} else {
204 				if (leftBlockNumber >= rightBlockNumber) {
205 					// left win
206 					prizePerBlock = gamePrizePool/leftBlockNumber;
207 					mapGameLeftWin[currentRound] = true;
208 				} else {
209 					// right win
210 					prizePerBlock = gamePrizePool/rightBlockNumber;
211 					mapGameLeftWin[currentRound] = false;
212 				}
213 			}
214 			// record game prize
215 			mapGamePrizePerBlock[currentRound] = prizePerBlock;
216 			// start next game
217 			gamePrizePool = nextGamePrizePool;
218 			gameStartTimestamp = now + gameIntervalTimestamp;  // new game start
219 			currentRound += 1;
220 			leftBlockNumber = 0;
221 			rightBlockNumber = 0;
222 		}
223     }
224 
225     function getUserMoney(address userAddress) public view returns(uint){
226 		uint userTotalPrize = 0;
227 		for (uint i=userWithdrawRound[userAddress]; i<currentRound;i++) {
228 			if (mapGameLeftWin[i]) {
229 				userTotalPrize = userTotalPrize.add(leftUserBlockNumber[i][userAddress].mul(mapGamePrizePerBlock[i]));
230 			} else {
231 				userTotalPrize = userTotalPrize.add(rightUserBlockNumber[i][userAddress].mul(mapGamePrizePerBlock[i]));
232 			}
233 		}
234 		return userTotalPrize;
235     }
236 
237     function withdrawUserPrize() public {
238 		require(currentRound > 0);
239 		uint userTotalPrize = getUserMoney(msg.sender);
240 		userWithdrawRound[msg.sender] = currentRound;
241 		if (userTotalPrize > 0) {
242 			msg.sender.transfer(userTotalPrize);
243 		}
244     }
245 
246     function daCall() public {
247         doCallNumber += 1;
248     }
249 
250     function getGameStats() public view returns(uint[]) {
251         // 1. currentRound
252         // 2. gameStartTimestamp
253         // 3. leftBlockNumber
254         // 4. rightBlockNumber
255         // 5. gamePrizePool
256         // 6. userPrize
257         uint[] memory result = new uint[](8);
258         uint userPrize = getUserMoney(msg.sender);
259         result[0] = currentRound;
260         result[1] = gameStartTimestamp;
261         result[2] = leftBlockNumber;
262         result[3] = rightBlockNumber;
263         result[4] = gamePrizePool;
264         result[5] = userPrize;
265         result[6] = leftUserBlockNumber[currentRound][msg.sender];
266         result[7] = rightUserBlockNumber[currentRound][msg.sender];
267         return result;
268     }
269 }