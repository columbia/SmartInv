1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: contracts/HeapTycoon.sol
120 
121 contract HeapTycoon is Ownable
122 {
123 	using SafeMath for uint256;
124 
125 	uint8 PAGE_SIZE = 25;
126 
127 //0.005
128 	uint256 MASTER_FEE = 5000000000000000;
129 
130 //0.01
131 	uint256 MIN_TICKET = 10000000000000000;
132 
133 //10
134 	uint256 MAX_TICKET = 10000000000000000000;
135 
136 	address public master;
137 
138 	struct Heap
139 	{
140 		uint256 ticket;
141 		uint256 time;
142 		bytes32 name;
143 		uint256 fee;
144 		address owner;
145 		uint256 cap;
146 		uint256 timer;
147 		uint256 timer_inc;
148 		uint256 bonus;
149 		uint256 bonus_fee;
150 		address cur_addr;
151 		address[] players;
152 	}
153 
154 	Heap[] heaps;
155 
156 	mapping(bytes32 => bool) used_names;
157 
158 
159 	constructor(address addr) public
160 	{
161 		master = addr;
162 
163 		used_names[bytes32(0)] = true;
164 	}
165 
166 
167 	function set_master(address addr) public onlyOwner
168 	{
169 		require(addr != address(0));
170 
171 		master = addr;
172 	}
173 
174 
175 	function create(uint256 ticket, bytes32 name, uint256 fee, uint256 timer_inc, uint256 bonus_fee) public payable
176 	{
177 		require(msg.sender == tx.origin);
178 		require(msg.value >= ticket.mul(20));
179 		require(ticket >= MIN_TICKET);
180 		require(ticket <= MAX_TICKET);
181 		require(used_names[name] == false);
182 		require(fee <= ticket.div(10));
183 		require(fee >= ticket.div(10000));
184 		require(timer_inc >= 30);
185 		require(timer_inc <= 10 days);
186 		require(bonus_fee <= ticket.div(10));
187 		require(bonus_fee >= ticket.div(10000));
188 		require(msg.sender != address(0));
189 		require(msg.sender != address(this));
190 		require(msg.sender != address(master));
191 		require(msg.sender != address(owner));
192 
193 		address[] memory players;
194 
195 		Heap memory heap = Heap(ticket, now, name, fee, msg.sender, 0, now.add(timer_inc), timer_inc, 0, bonus_fee, address(0), players);
196 
197 		used_names[name] = true;
198 
199 		heaps.push(heap);
200 
201 		master.transfer(msg.value);
202 	}
203 
204 
205 	function buy(uint256 id) public payable
206 	{
207 		require(msg.sender == tx.origin);
208 		require(id < heaps.length);
209 		require(msg.value >= heaps[id].ticket);
210 		require(msg.sender != address(0));
211 		require(msg.sender != address(this));
212 		require(msg.sender != address(master));
213 		require(msg.sender != address(owner));
214 
215 		bytes32 hash;
216 
217 		uint256 index;
218 
219 		uint256 val;
220 
221 		bool res;
222 
223 		uint256 bonus_val;
224 
225 
226 		val = heaps[id].ticket.sub(heaps[id].fee).sub(MASTER_FEE).sub(heaps[id].bonus_fee).div(10);
227 
228 		heaps[id].players.push(msg.sender);
229 
230 		if(now < heaps[id].timer)
231 		{
232 			heaps[id].cur_addr = msg.sender;
233 			heaps[id].timer = heaps[id].timer.add(heaps[id].timer_inc);
234 			heaps[id].bonus = heaps[id].bonus.add(heaps[id].bonus_fee);
235 		}
236 		else
237 		{
238 			bonus_val = heaps[id].bonus;
239 			heaps[id].bonus = heaps[id].bonus_fee;
240 			heaps[id].timer = now.add(heaps[id].timer_inc);
241 		}
242 
243 		heaps[id].cap = heaps[id].cap.add(msg.value);
244 
245 		res = master.send(MASTER_FEE);
246 
247 		for(uint8 i = 0; i < 10; i++)
248 		{
249 			hash = keccak256(abi.encodePacked(uint256(blockhash(block.number - (i + 1))) + uint256(msg.sender) + uint256(heaps.length)));
250 			index = uint256(hash) % heaps[id].players.length;
251 			res = heaps[id].players[index].send(val);
252 		}
253 
254 		if(bonus_val > 0)
255 			res = heaps[id].cur_addr.send(bonus_val);
256 
257 		res = heaps[id].owner.send(heaps[id].fee);
258 	}
259 
260 
261 	function get_len() external view returns (uint256)
262 	{
263 		return heaps.length;
264 	}
265 
266 
267 	function get_heaps(uint256 page) external view returns (uint256[] ids, uint256[] tickets, bytes32[] names, uint256[] caps, uint256[] timers, uint256[] bonuses)
268 	{
269 		ids = new uint256[](PAGE_SIZE);
270 		tickets = new uint256[](PAGE_SIZE);
271 		names = new bytes32[](PAGE_SIZE);
272 		caps = new uint256[](PAGE_SIZE);
273 		timers = new uint256[](PAGE_SIZE);
274 		bonuses = new uint256[](PAGE_SIZE);
275 
276 		uint256 start = page.mul(PAGE_SIZE);
277 
278 		uint256 timer;
279 
280 		for(uint256 i = 0; i < PAGE_SIZE; i++)
281 		{
282 			if(start + i < heaps.length)
283 			{
284 				timer = 0;
285 
286 				if(now < heaps[start + i].timer)
287 					timer = heaps[start + i].timer - now;
288 
289 				ids[i] = start + i;
290 				tickets[i] = heaps[start + i].ticket;
291 				names[i] = heaps[start + i].name;
292 				caps[i] = heaps[start + i].cap;
293 				timers[i] = timer;
294 				bonuses[i] = heaps[start + i].bonus;
295 			}
296 		}
297 	}
298 
299 
300 	function is_name_used(bytes32 name) external view returns(bool)
301 	{
302 		return used_names[name];
303 	}
304 
305 
306 	function get_heap(uint256 id) external view returns(uint256[] data, bytes32 name, address owner, address cur_addr)
307 	{
308 		data = new uint256[](11);
309 
310 		if(id >= heaps.length)
311 			return;
312 
313 		name = heaps[id].name;
314 		owner = heaps[id].owner;
315 		cur_addr = heaps[id].cur_addr;
316 
317 		uint timer;
318 
319 		if(now < heaps[id].timer)
320 			timer = heaps[id].timer - now;
321 
322 		data[0] = heaps[id].ticket;
323 		data[1] = heaps[id].time;
324 		data[2] = heaps[id].fee;
325 		data[3] = heaps[id].cap;
326 		data[4] = timer;
327 		data[5] = heaps[id].timer_inc;
328 		data[6] = heaps[id].bonus;
329 		data[7] = heaps[id].bonus_fee;
330 		data[8] = heaps[id].ticket.sub(heaps[id].fee).sub(MASTER_FEE).sub(heaps[id].bonus_fee).div(10);
331 	}
332 }