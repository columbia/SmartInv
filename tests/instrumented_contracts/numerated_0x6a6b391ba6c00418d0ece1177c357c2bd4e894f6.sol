1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 	function mul(uint a, uint b) internal pure returns (uint) {
5 		uint c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint a, uint b) internal pure returns (uint) {
11 		// assert(b > 0); // Solidity automatically throws when dividing by 0
12 		uint c = a / b;
13 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
14 		return c;
15 	}
16 
17 	function sub(uint a, uint b) internal pure returns (uint) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint a, uint b) internal pure returns (uint) {
23 		uint c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 
28 	function diff(uint a, uint b) internal pure returns (uint) {
29 		return a > b ? sub(a, b) : sub(b, a);
30 	}
31 
32 	function gt(uint a, uint b) internal pure returns(bytes1) {
33 		bytes1 c;
34 		c = 0x00;
35 		if (a > b) {
36 			c = 0x01;
37 		}
38 		return c;
39 	}
40 }
41 
42 interface IMultiSigManager {
43 	function provideAddress(address origin, uint poolIndex) external returns (address payable);
44 	function passedContract(address) external returns (bool);
45 	function moderator() external returns(address);
46 }
47 
48 contract Managed {
49 	IMultiSigManager roleManager;
50 	address public roleManagerAddress;
51 	address public operator;
52 	uint public lastOperationTime;
53 	uint public operationCoolDown;
54 	uint constant BP_DENOMINATOR = 10000;
55 
56 	event UpdateRoleManager(address newManagerAddress);
57 	event UpdateOperator(address updater, address newOperator);
58 
59 	modifier only(address addr) {
60 		require(msg.sender == addr);
61 		_;
62 	}
63 
64 	modifier inUpdateWindow() {
65 		uint currentTime = getNowTimestamp();
66 		require(currentTime - lastOperationTime >= operationCoolDown);
67 		_;
68 		lastOperationTime = currentTime;
69 	}
70 
71 	constructor(
72 		address roleManagerAddr,
73 		address opt, 
74 		uint optCoolDown
75 	) public {
76 		roleManagerAddress = roleManagerAddr;
77 		roleManager = IMultiSigManager(roleManagerAddr);
78 		operator = opt;
79 		operationCoolDown = optCoolDown;
80 	}
81 
82 	function updateRoleManager(address newManagerAddr) 
83 		inUpdateWindow() 
84 		public 
85 	returns (bool) {
86 		require(roleManager.passedContract(newManagerAddr));
87 		roleManagerAddress = newManagerAddr;
88 		roleManager = IMultiSigManager(roleManagerAddress);
89 		require(roleManager.moderator() != address(0));
90 		emit UpdateRoleManager(newManagerAddr);
91 		return true;
92 	}
93 
94 	function updateOperator() public inUpdateWindow() returns (bool) {	
95 		address updater = msg.sender;	
96 		operator = roleManager.provideAddress(updater, 0);
97 		emit UpdateOperator(updater, operator);	
98 		return true;
99 	}
100 
101 	function getNowTimestamp() internal view returns (uint) {
102 		return now;
103 	}
104 }
105 
106 /// @title Magi - oracle contract accepts price commit
107 /// @author duo.network
108 contract Magi is Managed {
109 	using SafeMath for uint;
110 
111 	/*
112      * Storage
113      */
114 	struct Price {
115 		uint priceInWei;
116 		uint timeInSecond;
117 		address source;
118 	}
119 	Price public firstPrice;
120 	Price public secondPrice;
121 	Price public lastPrice;
122 	address public priceFeed1; 
123 	address public priceFeed2; 
124 	address public priceFeed3;
125 	uint public priceTolInBP = 500; 
126 	uint public priceFeedTolInBP = 100;
127 	uint public priceFeedTimeTol = 1 minutes;
128 	uint public priceUpdateCoolDown;
129 	uint public numOfPrices = 0;
130 	bool public started = false;
131 
132 	/*
133      * Modifier
134      */
135 	modifier isPriceFeed() {
136 		require(msg.sender == priceFeed1 || msg.sender == priceFeed2 || msg.sender == priceFeed3);
137 		_;
138 	}
139 
140 	/*
141      * Events
142      */
143 	event CommitPrice(uint indexed priceInWei, uint indexed timeInSecond, address sender, uint index);
144 	event AcceptPrice(uint indexed priceInWei, uint indexed timeInSecond, address sender);
145 	event SetValue(uint index, uint oldValue, uint newValue);
146 	event UpdatePriceFeed(address updater, address newPriceFeed);
147 
148 	/*
149      * Constructor
150      */
151 	constructor(
152 		address opt,
153 		address pf1,
154 		address pf2,
155 		address pf3,
156 		address roleManagerAddr,
157 		uint pxCoolDown,
158 		uint optCoolDown
159 		) 
160 		public
161 		Managed(roleManagerAddr, opt, optCoolDown) 
162 	{
163 		priceFeed1 = pf1;
164 		priceFeed2 = pf2;
165 		priceFeed3 = pf3;
166 		priceUpdateCoolDown = pxCoolDown;
167 		roleManagerAddress = roleManagerAddr;
168 		roleManager = IMultiSigManager(roleManagerAddr);
169 		emit UpdateRoleManager(roleManagerAddress);
170 	}
171 
172 
173 	/*
174      * Public Functions
175      */
176 	function startOracle(
177 		uint priceInWei, 
178 		uint timeInSecond
179 	)
180 		public 
181 		isPriceFeed() 
182 		returns (bool success) 
183 	{
184 		require(!started && timeInSecond <= getNowTimestamp());
185 		lastPrice.timeInSecond = timeInSecond;
186 		lastPrice.priceInWei = priceInWei;
187 		lastPrice.source = msg.sender;
188 		started = true;
189 		emit AcceptPrice(priceInWei, timeInSecond, msg.sender);
190 		return true;
191 	}
192 
193 
194 	function getLastPrice() public view returns(uint, uint) {
195 		return (lastPrice.priceInWei, lastPrice.timeInSecond);
196 	}
197 
198 	// start of oracle
199 	function commitPrice(uint priceInWei, uint timeInSecond) 
200 		public 
201 		isPriceFeed()
202 		returns (bool success)
203 	{	
204 		require(started && timeInSecond <= getNowTimestamp() && timeInSecond >= lastPrice.timeInSecond.add(priceUpdateCoolDown));
205 		uint priceDiff;
206 		if (numOfPrices == 0) {
207 			priceDiff = priceInWei.diff(lastPrice.priceInWei);
208 			if (priceDiff.mul(BP_DENOMINATOR).div(lastPrice.priceInWei) <= priceTolInBP) {
209 				acceptPrice(priceInWei, timeInSecond, msg.sender);
210 			} else {
211 				// wait for the second price
212 				firstPrice = Price(priceInWei, timeInSecond, msg.sender);
213 				emit CommitPrice(priceInWei, timeInSecond, msg.sender, 0);
214 				numOfPrices++;
215 			}
216 		} else if (numOfPrices == 1) {
217 			if (timeInSecond > firstPrice.timeInSecond.add(priceUpdateCoolDown)) {
218 				if (firstPrice.source == msg.sender)
219 					acceptPrice(priceInWei, timeInSecond, msg.sender);
220 				else
221 					acceptPrice(firstPrice.priceInWei, timeInSecond, firstPrice.source);
222 			} else {
223 				require(firstPrice.source != msg.sender);
224 				// if second price times out, use first one
225 				if (firstPrice.timeInSecond.add(priceFeedTimeTol) < timeInSecond || 
226 					firstPrice.timeInSecond.sub(priceFeedTimeTol) > timeInSecond) {
227 					acceptPrice(firstPrice.priceInWei, firstPrice.timeInSecond, firstPrice.source);
228 				} else {
229 					priceDiff = priceInWei.diff(firstPrice.priceInWei);
230 					if (priceDiff.mul(BP_DENOMINATOR).div(firstPrice.priceInWei) <= priceTolInBP) {
231 						acceptPrice(firstPrice.priceInWei, firstPrice.timeInSecond, firstPrice.source);
232 					} else {
233 						// wait for the third price
234 						secondPrice = Price(priceInWei, timeInSecond, msg.sender);
235 						emit CommitPrice(priceInWei, timeInSecond, msg.sender, 1);
236 						numOfPrices++;
237 					} 
238 				}
239 			}
240 		} else if (numOfPrices == 2) {
241 			if (timeInSecond > firstPrice.timeInSecond + priceUpdateCoolDown) {
242 				if ((firstPrice.source == msg.sender || secondPrice.source == msg.sender))
243 					acceptPrice(priceInWei, timeInSecond, msg.sender);
244 				else
245 					acceptPrice(secondPrice.priceInWei, timeInSecond, secondPrice.source);
246 			} else {
247 				require(firstPrice.source != msg.sender && secondPrice.source != msg.sender);
248 				uint acceptedPriceInWei;
249 				// if third price times out, use first one
250 				if (firstPrice.timeInSecond.add(priceFeedTimeTol) < timeInSecond || 
251 					firstPrice.timeInSecond.sub(priceFeedTimeTol) > timeInSecond) {
252 					acceptedPriceInWei = firstPrice.priceInWei;
253 				} else {
254 					// take median and proceed
255 					// first and second price will never be equal in this part
256 					// if second and third price are the same, they are median
257 					if (secondPrice.priceInWei == priceInWei) {
258 						acceptedPriceInWei = priceInWei;
259 					} else {
260 						acceptedPriceInWei = getMedian(firstPrice.priceInWei, secondPrice.priceInWei, priceInWei);
261 					}
262 				}
263 				acceptPrice(acceptedPriceInWei, firstPrice.timeInSecond, firstPrice.source);
264 			}
265 		} else {
266 			return false;
267 		}
268 
269 		return true;
270 	}
271 
272 	/*Internal Functions
273      */
274 	function acceptPrice(uint priceInWei, uint timeInSecond, address source) internal {
275 		lastPrice.priceInWei = priceInWei;
276 		lastPrice.timeInSecond = timeInSecond;
277 		lastPrice.source = source;
278 		numOfPrices = 0;
279 		emit AcceptPrice(priceInWei, timeInSecond, source);
280 	}
281 
282 	function getMedian(uint a, uint b, uint c) internal pure returns (uint) {
283 		if (a.gt(b) ^ c.gt(a) == 0x0) {
284 			return a;
285 		} else if(b.gt(a) ^ c.gt(b) == 0x0) {
286 			return b;
287 		} else {
288 			return c;
289 		}
290 	}
291 	// end of oracle
292 
293 	// start of operator function
294 	function updatePriceFeed(uint index) 
295 		inUpdateWindow() 
296 		public 
297 	returns (bool) {
298 		require(index < 3);
299 		address updater = msg.sender;
300 		address newAddr = roleManager.provideAddress(updater, 1);
301 		if(index == 0) 
302 			priceFeed1 = newAddr;
303 		else if (index == 1)
304 			priceFeed2 = newAddr;
305 		else // index == 2
306 			priceFeed3 = newAddr;
307 		
308 		emit UpdatePriceFeed(updater, newAddr);
309 		return true;
310 	}
311 
312 	function setValue(
313 		uint idx, 
314 		uint newValue
315 	) 
316 		public 
317 		only(operator) 
318 		inUpdateWindow() 
319 	returns (bool success) {
320 		uint oldValue;
321 		if (idx == 0) {
322 			oldValue = priceTolInBP;
323 			priceTolInBP = newValue;
324 		} else if (idx == 1) {
325 			oldValue = priceFeedTolInBP;
326 			priceFeedTolInBP = newValue;
327 		} else if (idx == 2) {
328 			oldValue = priceFeedTimeTol;
329 			priceFeedTimeTol = newValue;
330 		} else if (idx == 3) {
331 			oldValue = priceUpdateCoolDown;
332 			priceUpdateCoolDown = newValue;
333 		} else {
334 			revert();
335 		}
336 
337 		emit SetValue(idx, oldValue, newValue);
338 		return true;
339 	}
340 	// end of operator function
341 
342 }