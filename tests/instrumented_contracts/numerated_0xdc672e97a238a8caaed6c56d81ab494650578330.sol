1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 	address public owner;
10 
11 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 	/**
14 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15 	 * account.
16 	 */
17 	function Ownable() public {
18 		require(msg.sender != address(0));
19 
20 		owner = msg.sender;
21 	}
22 
23 
24 	/**
25 	 * @dev Throws if called by any account other than the owner.
26 	 */
27 	modifier onlyOwner() {
28 		require(msg.sender == owner);
29 		_;
30 	}
31 
32 	/**
33 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
34 	 * @param newOwner The address to transfer ownership to.
35 	 */
36 	function transferOwnership(address newOwner) public onlyOwner {
37 		require(newOwner != address(0));
38 		OwnershipTransferred(owner, newOwner);
39 		owner = newOwner;
40 	}
41 
42 }
43 
44 contract EthernalBridge is Ownable {
45 
46 	/// Buy is emitted when a lock is bought
47 	event Buy(
48 		uint indexed id,
49 		address owner,
50 		uint x,
51 		uint y,
52 		uint sizeSkin,
53 		bytes16 names,
54 		bytes32 message
55 	);
56 
57 	/// We reserve 1 thousand skins per type until premium
58 
59 	// 0-1000 CHEAP_TYPE
60 	uint constant MEDIUM_TYPE = 1001;
61 	uint constant PREMIUM_TYPE = 2001;
62 
63 	/// Bridge max width & height: This can be increased later to make the bridge bigger
64 	uint public maxBridgeHeight = 24; // 480px
65 	uint public maxBridgeWidth = 400; // 8000px
66 
67 	/// Price by size
68 	uint public smallPrice = 3 finney;
69 	uint public mediumPrice = 7 finney;
70 	uint public bigPrice = 14 finney;
71 
72 	/// Price modifiers
73 	uint8 public mediumMod = 2;
74 	uint8 public premiumMod = 3;
75 
76 	/// Locks position
77 	mapping (uint => uint) public grid;
78 
79 
80 	/// withdrawWallet is the fixed destination of funds to withdraw. It might
81 	/// differ from owner address to allow for a cold storage address.
82 	address public withdrawWallet;
83 
84 	struct Lock {
85 		address owner;
86 
87 		uint32 x;
88 		uint16 y;
89 
90 		// last digit is lock size
91 		uint32 sizeSkin;
92 
93 		bytes16 names;
94 		bytes32 message;
95 		uint time;
96 
97 	}
98 
99 	/// All bought locks
100 	Lock[] public locks;
101 
102 	function () public payable { }
103 
104 	function EthernalBridge() public {
105 		require(msg.sender != address(0));
106 
107 		withdrawWallet = msg.sender;
108 	}
109 
110 	/// @dev Set address withdaw wallet
111 	/// @param _address The address where the balance will be withdrawn
112 	function setWithdrawWallet(address _address) external onlyOwner {
113 		withdrawWallet = _address;
114 	}
115 
116 	/// @dev Set small lock price
117 	/// This will be used if ether value increase a lot
118 	/// @param _price The new small lock price
119 	function setSmallPrice(uint _price) external onlyOwner {
120 		smallPrice = _price;
121 	}
122 
123 	/// @dev Set medium lock price
124 	/// This will be used if ether value increase a lot
125 	/// @param _price The new medium lock price
126 	function setMediumPrice(uint _price) external onlyOwner {
127 		mediumPrice = _price;
128 	}
129 
130 	/// @dev Set big lock price
131 	/// This will be used if ether value increase a lot
132 	/// @param _price The new big lock price
133 	function setBigPrice(uint _price) external onlyOwner {
134 		bigPrice = _price;
135 	}
136 
137 	/// @dev Set new bridge height
138 	/// @param _height The bridge height
139 	function setBridgeHeight(uint _height) external onlyOwner {
140 		maxBridgeHeight = _height;
141 	}
142 
143 	/// @dev Set new bridge width
144 	/// @param _width The bridge width
145 	function setBridgeWidth(uint _width) external onlyOwner {
146 		maxBridgeWidth = _width;
147 	}
148 
149 	/// Withdraw out the balance of the contract to the given withdraw wallet.
150 	function withdraw() external onlyOwner {
151 		require(withdrawWallet != address(0));
152 
153 		withdrawWallet.transfer(this.balance);
154 	}
155 
156 	/// @notice The the total number of locks
157 	function getLocksLength() external view returns (uint) {
158 		return locks.length;
159 	}
160 
161 	/// @notice Get a lock by its id
162 	/// @param id The lock id
163 	function getLockById(uint id) external view returns (uint, uint, uint, uint, bytes16, bytes32, address) {
164 		return (
165 			locks[id].x,
166 			locks[id].y,
167 			locks[id].sizeSkin,
168 			locks[id].time,
169 			locks[id].names,
170 			locks[id].message,
171 			locks[id].owner
172 		);
173 	}
174 
175 
176 	/// @notice Locks must be purchased in 20x20 pixel blocks.
177 	/// Each coordinate represents 20 pixels. So _x=15, _y=10, _width=1, _height=1
178 	/// Represents a 20x20 pixel lock at 300x, 200y
179 	function buy(
180 		uint32 _x,
181 		uint16 _y,
182 		uint32 _sizeSkin,
183 		bytes16 _names,
184 		bytes32 _message
185 	)
186 		external
187 		payable
188 		returns (uint)
189 	{
190 
191 		_checks(_x, _y, _sizeSkin);
192 
193 		uint id = locks.push(
194 			Lock(msg.sender, _x, _y, _sizeSkin, _names, _message, block.timestamp)
195 		) - 1;
196 
197 		// Trigger buy event
198 		Buy(id, msg.sender, _x, _y, _sizeSkin, _names, _message);
199 
200 		return id;
201 	}
202 
203 
204 	function _checks(uint _x, uint _y, uint _sizeSkin) private {
205 
206 		uint _size = _sizeSkin % 10; // Size & skin are packed together. Last digit is the size. (1, 2, 3)
207 		uint _skin = (_sizeSkin - _size) / 10;
208 
209 		/// Size must be 20 / 40 / 60 pixels
210 		require(_size == 1 || _size == 2 || _size == 3);
211 
212 		require(maxBridgeHeight >= (_y + _size) && maxBridgeWidth >= (_x + _size));
213 
214 		require(msg.value >= calculateCost(_size, _skin));
215 
216 		// Check if lock position is available
217 		_checkGrid(_x, _y, _size);
218 	}
219 
220 	/// @dev calculate the cost of the lock by its size and skin
221 	/// @param _size The lock size
222 	/// @param _skin The lock skin
223 	function calculateCost(uint _size, uint _skin) public view returns (uint cost) {
224 		// Calculate cost by size
225 
226 		if(_size == 2)
227 			cost = mediumPrice;
228 		else if(_size == 3)
229 			cost = bigPrice;
230 		else
231 			cost = smallPrice;
232 
233 		// Apply price modifiers
234 		if(_skin >= PREMIUM_TYPE)
235 			cost = cost * premiumMod;
236 		else if(_skin >= MEDIUM_TYPE)
237 			cost = cost * mediumMod;
238 
239 		return cost;
240 	}
241 
242 
243 	/// @dev check if a lock can be set in the given positions
244 	/// @param _x The x coord
245 	/// @param _y The y coord
246 	/// @param _size The lock size
247 	function _checkGrid(uint _x, uint _y, uint _size) public {
248 
249 		for(uint i = 0; i < _size; i++) {
250 
251 			uint row = grid[_x + i];
252 
253 			for(uint j = 0; j < _size; j++) {
254 
255 				// if (_y + j) bit is set in row
256 				if((row >> (_y + j)) & uint(1) == uint(1)) {
257 					// lock exists in this slot
258 					revert();
259 				}
260 
261 				// set bit (_y + j)
262 				row = row | (uint(1) << (_y + j));
263 			}
264 
265 			grid[_x + i] = row;
266 		}
267 	}
268 
269 }