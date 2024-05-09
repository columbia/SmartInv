1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title Pausable
80  * @dev Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83   event Pause();
84   event Unpause();
85 
86   bool public paused = false;
87 
88 
89   /**
90    * @dev Modifier to make a function callable only when the contract is not paused.
91    */
92   modifier whenNotPaused() {
93     require(!paused);
94     _;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is paused.
99    */
100   modifier whenPaused() {
101     require(paused);
102     _;
103   }
104 
105   /**
106    * @dev called by the owner to pause, triggers stopped state
107    */
108   function pause() onlyOwner whenNotPaused public {
109     paused = true;
110     Pause();
111   }
112 
113   /**
114    * @dev called by the owner to unpause, returns to normal state
115    */
116   function unpause() onlyOwner whenPaused public {
117     paused = false;
118     Unpause();
119   }
120 }
121 
122 contract DeLottery is Pausable {
123 	using SafeMath for uint256;
124 
125 	uint32 public constant QUORUM = 3;
126 
127 	address[] gamblers;
128 
129 	uint public ticketPrice = 1 ether;
130 
131 	uint public prizeFund = 0;
132 
133 	uint public nextTicketPrice = 0;
134 
135 	uint public stage;
136 
137 	uint public maxTickets = 100;
138 
139 	mapping(address => mapping(address => uint)) prizes;
140 
141 	mapping(address => bool) lotteryRunners;
142 
143 	event Win(uint indexed stage, uint ticketsCount, uint ticketNumber, address indexed winner, uint prize);
144 
145    	modifier canRunLottery() {
146    		require(lotteryRunners[msg.sender]);
147    		_;
148    	}
149 
150 	function DeLottery() public {
151 		lotteryRunners[msg.sender] = true;
152 		gamblers.push(0x0);
153 	}
154 
155 	function () public payable whenNotPaused {
156 		require(!isContract(msg.sender));
157 		require(msg.value >= ticketPrice);
158 		uint availableTicketsToBuy = maxTickets - getTicketsCount();
159 		require(availableTicketsToBuy > 0);
160 
161 		uint ticketsBought = msg.value.div(ticketPrice);
162 
163 		uint ticketsToBuy;
164 		uint refund = 0;
165 		if(ticketsBought > availableTicketsToBuy) {
166 			ticketsToBuy = availableTicketsToBuy;
167 			refund = (ticketsBought - availableTicketsToBuy).mul(ticketPrice);
168 		} else {
169 			ticketsToBuy = ticketsBought;
170 		}
171 
172 		for(uint16 i = 0; i < ticketsToBuy; i++) {
173 			gamblers.push(msg.sender);
174 		}
175 
176 		prizeFund = prizeFund.add(ticketsToBuy.mul(ticketPrice));
177 
178 		//return change
179 		refund = refund.add(msg.value % ticketPrice);
180 		if(refund > 0) {
181 			msg.sender.transfer(refund);
182 		}
183 	}
184 
185 	function calculateWinnerPrize(uint fund, uint winnersCount) public pure returns (uint prize) {
186 		return fund.mul(19).div(winnersCount).div(20);
187 	}
188 
189 	function calculateWinnersCount(uint _ticketsCount) public pure returns (uint count) {
190 		if(_ticketsCount < 10) {
191 			return 1;
192 		} else {
193 			return _ticketsCount.div(10);
194 		}
195 	}
196 
197 	function runLottery() external whenNotPaused canRunLottery {
198 		uint gamblersLength = getTicketsCount();
199 		require(gamblersLength >= QUORUM);
200 
201 		uint winnersCount = calculateWinnersCount(gamblersLength);
202 		uint winnerPrize = calculateWinnerPrize(prizeFund, winnersCount);
203 
204 		int[] memory winners = new int[](winnersCount);
205 
206 		uint lastWinner = 0;
207 		bytes32 rnd = block.blockhash(block.number - 1);
208 		for(uint i = 0; i < winnersCount; i++) {
209 			lastWinner = generateNextWinner(rnd, lastWinner, winners, gamblers.length);
210 			winners[i] = int(lastWinner);
211 			address winnerAddress = gamblers[uint(winners[i])];
212 			winnerAddress.transfer(winnerPrize); //safe because gambler can't be a contract
213 			Win(stage, gamblersLength, lastWinner, winnerAddress, winnerPrize);
214 		}
215 
216 		setTicketPriceIfNeeded();
217 
218 		//set initial state
219 		prizeFund = 0;
220 		gamblers.length = 1;
221 		stage += 1;
222 	}
223 
224 	function getTicketsCount() public view returns (uint) {
225 		return gamblers.length - 1;
226 	}
227 
228 	function setTicketPrice(uint _ticketPrice) external onlyOwner {
229 		if(getTicketsCount() == 0) {
230 			ticketPrice = _ticketPrice;
231 			nextTicketPrice = 0;
232 		} else {
233 			nextTicketPrice = _ticketPrice;
234 		}
235 	}
236 
237 	function setMaxTickets(uint _maxTickets) external onlyOwner {
238 		maxTickets = _maxTickets;
239 	}
240 
241 	function setAsLotteryRunner(address addr, bool isAllowedToRun) external onlyOwner {
242 		lotteryRunners[addr] = isAllowedToRun;
243 	}
244 
245 	function setTicketPriceIfNeeded() private {
246 		if(nextTicketPrice > 0) {
247 			ticketPrice = nextTicketPrice;
248 			nextTicketPrice = 0;
249 		}
250 	}
251 
252 	/**
253 	* @dev Function to get ether from contract
254 	* @param amount Amount in wei to withdraw
255 	*/
256 	function withdrawEther(address recipient, uint amount) external onlyOwner {
257 		recipient.transfer(amount);
258 	}
259 
260 	function generateNextWinner(bytes32 rnd, uint previousWinner, int[] winners, uint gamblersCount) private view returns(uint) {
261 		uint nonce = 0;
262 		uint winner = generateWinner(rnd, previousWinner, nonce, gamblersCount);
263 
264 		while(isInArray(winner, winners)) {
265 			nonce += 1;
266 			winner = generateWinner(rnd, previousWinner, nonce, gamblersCount);
267 		}
268 
269 		return winner;
270 	}
271 
272 	function generateWinner(bytes32 rnd, uint previousWinner, uint nonce, uint gamblersCount) private pure returns (uint winner) {
273 		return uint(keccak256(rnd, previousWinner, nonce)) % gamblersCount;
274 	}
275 
276 	function isInArray(uint element, int[] array) private pure returns (bool) {
277 		for(uint64 i = 0; i < array.length; i++) {
278 			if(uint(array[i]) == element) {
279 				return true;
280 			}
281 		}
282 		return false;
283 	}
284 
285 	function isContract(address _addr) private view returns (bool is_contract) {
286 		uint length;
287 		assembly {
288 			//retrieve the size of the code on target address, this needs assembly
289 			length := extcodesize(_addr)
290 		}
291 		return length > 0;
292 	}
293 
294 }