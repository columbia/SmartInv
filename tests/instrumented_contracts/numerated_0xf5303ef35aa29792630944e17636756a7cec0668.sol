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
57     uint maxBlockNumber = 500;
58     uint buildFee = 10 finney;
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
82         gameStartTimestamp = 1535968800;  // set gameStartTimestamp
83     }
84 
85     function getBlockBuildFee(uint currentBlockNumber) public view returns(uint) {
86         if (currentBlockNumber <= 10) {
87             return 0;
88         }
89         if (currentBlockNumber <= 20) {
90             return buildFee.div(4);
91         }
92 		if (currentBlockNumber <= 100) {
93 			return buildFee.div(2);  // 50 percent
94 		}
95 		if (currentBlockNumber <= 200) {
96 			return buildFee.mul(3).div(4);  // 75 percent
97 		}
98 		return buildFee; // 100 percent
99     }
100 
101     function buildLeft(address inviteAddress, uint blockNumber) public payable onlyInGame {
102     	uint totalMoney = buildFee.mul(blockNumber);
103     	require(msg.value >= totalMoney);
104         require(blockNumber > 0);
105         uint excess = msg.value.sub(totalMoney);
106         uint totalBuildFee = 0;
107         for (uint i=leftBlockNumber;i<leftBlockNumber+blockNumber;i++) {
108     		totalBuildFee = totalBuildFee.add(getBlockBuildFee(i+1));
109         }
110         excess = excess.add(totalMoney.sub(totalBuildFee));
111         if (excess > 0) {
112         	msg.sender.transfer(excess);
113         }
114         // handle ether
115         uint devFee = 0;
116         uint inviteFee = 0;
117         devFee = totalBuildFee.mul(3).div(100);
118         if (inviteAddress != address(0)) {
119     		inviteFee = totalBuildFee.mul(2).div(100);
120         } else {
121     		devFee = totalBuildFee.mul(5).div(100);  // 7% percent if not invite
122         }
123         owner.transfer(devFee);
124         if (inviteFee > 0) {
125     		inviteAddress.transfer(inviteFee);
126         }
127         leftBlockNumber = leftBlockNumber.add(blockNumber);
128         gamePrizePool = gamePrizePool.add(totalBuildFee.sub(devFee).sub(inviteFee));
129 
130         // record user block number
131         leftUserBlockNumber[currentRound][msg.sender] += blockNumber;
132        	// try trigger game end
133        	trigger_game_end(totalBuildFee);
134     }
135 
136     function buildRight(address inviteAddress, uint blockNumber) public payable onlyInGame {
137 		uint totalMoney = buildFee.mul(blockNumber);
138 		require(msg.value >= totalMoney);
139         require(blockNumber > 0);
140         uint excess = msg.value.sub(totalMoney);
141         uint totalBuildFee = 0;
142         for (uint i=rightBlockNumber;i<rightBlockNumber+blockNumber;i++) {
143     		totalBuildFee = totalBuildFee.add(getBlockBuildFee(i+1));
144         }
145         excess = excess.add(totalMoney.sub(totalBuildFee));
146         if (excess > 0) {
147         	msg.sender.transfer(excess);
148         }
149         // handle ether
150         uint devFee = 0;
151         uint inviteFee = 0;
152         devFee = totalBuildFee.mul(3).div(100);
153         if (inviteAddress != address(0)) {
154     		inviteFee = totalBuildFee.mul(2).div(100);
155         } else {
156     		devFee = totalBuildFee.mul(5).div(100);  // 5% percent if not invite
157         }
158         owner.transfer(devFee);
159         if (inviteFee > 0) {
160     		inviteAddress.transfer(inviteFee);
161         }
162         rightBlockNumber = rightBlockNumber.add(blockNumber);
163         gamePrizePool = gamePrizePool.add(totalBuildFee.sub(devFee).sub(inviteFee));
164 
165         // record user block number
166         rightUserBlockNumber[currentRound][msg.sender] += blockNumber;
167        	// try trigger game end
168        	trigger_game_end(totalBuildFee);
169     }
170 
171     function trigger_game_end(uint totalBuildFee) private onlyInGame {
172 		// game end
173 		bool gameEnd = false;
174 		if (rightBlockNumber > maxBlockNumber) {
175 				gameEnd = true;
176 		}
177 		if (leftBlockNumber > maxBlockNumber) {
178 				gameEnd = true;
179 		}
180 		if (now.sub(gameStartTimestamp) > gameLength) {
181 				gameEnd = true;
182 		}
183 		if (gameEnd) {
184 			uint maxUserPrize = gamePrizePool.mul(3).div(100);
185 			uint nextGamePrizePool = gamePrizePool.div(10);
186 			if (gamePrizePool > 0) {
187 					msg.sender.transfer(maxUserPrize);
188 			}
189 			gamePrizePool = gamePrizePool.sub(maxUserPrize).sub(nextGamePrizePool);
190 			uint prizePerBlock = 0;
191 			if (leftBlockNumber > maxBlockNumber) {
192 				// right win
193 				if (rightBlockNumber > 0) {
194 				    prizePerBlock = gamePrizePool/rightBlockNumber;
195 				} else {
196 				    owner.transfer(gamePrizePool);
197 				    prizePerBlock = 0;
198 				}
199 				mapGameLeftWin[currentRound] = false;
200 			} else if (rightBlockNumber > maxBlockNumber) {
201 				// left win
202 				if (leftBlockNumber > 0) {
203 				    prizePerBlock = gamePrizePool/leftBlockNumber;
204 				} else {
205 				    owner.transfer(gamePrizePool);
206 				    prizePerBlock = 0;
207 				}
208 				mapGameLeftWin[currentRound] = true;
209 			} else {
210 				if (leftBlockNumber >= rightBlockNumber) {
211 					// left win
212 					prizePerBlock = gamePrizePool/leftBlockNumber;
213 					mapGameLeftWin[currentRound] = true;
214 				} else {
215 					// right win
216 					prizePerBlock = gamePrizePool/rightBlockNumber;
217 					mapGameLeftWin[currentRound] = false;
218 				}
219 			}
220 			// record game prize
221 			mapGamePrizePerBlock[currentRound] = prizePerBlock;
222 			// start next game
223 			gamePrizePool = nextGamePrizePool;
224 			gameStartTimestamp = now + gameIntervalTimestamp;  // new game start
225 			currentRound += 1;
226 			leftBlockNumber = 0;
227 			rightBlockNumber = 0;
228 		}
229     }
230 
231     function getUserMoney(address userAddress) public view returns(uint){
232 		uint userTotalPrize = 0;
233 		for (uint i=userWithdrawRound[userAddress]; i<currentRound;i++) {
234 			if (mapGameLeftWin[i]) {
235 				userTotalPrize = userTotalPrize.add(leftUserBlockNumber[i][userAddress].mul(mapGamePrizePerBlock[i]));
236 			} else {
237 				userTotalPrize = userTotalPrize.add(rightUserBlockNumber[i][userAddress].mul(mapGamePrizePerBlock[i]));
238 			}
239 		}
240 		return userTotalPrize;
241     }
242 
243     function withdrawUserPrize() public {
244 		require(currentRound > 0);
245 		uint userTotalPrize = getUserMoney(msg.sender);
246 		userWithdrawRound[msg.sender] = currentRound;
247 		if (userTotalPrize > 0) {
248 			msg.sender.transfer(userTotalPrize);
249 		}
250     }
251 
252     function daCall() public {
253         doCallNumber += 1;
254     }
255 
256     function getGameStats() public view returns(uint[]) {
257         // 1. currentRound
258         // 2. gameStartTimestamp
259         // 3. leftBlockNumber
260         // 4. rightBlockNumber
261         // 5. gamePrizePool
262         // 6. userPrize
263         uint[] memory result = new uint[](8);
264         uint userPrize = getUserMoney(msg.sender);
265         result[0] = currentRound;
266         result[1] = gameStartTimestamp;
267         result[2] = leftBlockNumber;
268         result[3] = rightBlockNumber;
269         result[4] = gamePrizePool;
270         result[5] = userPrize;
271         result[6] = leftUserBlockNumber[currentRound][msg.sender];
272         result[7] = rightUserBlockNumber[currentRound][msg.sender];
273         return result;
274     }
275 }