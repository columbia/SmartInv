1 pragma solidity ^0.4.21;
2 
3 
4 /// @title A base contract to control ownership
5 /// @author cuilichen
6 contract OwnerBase {
7 
8     // The addresses of the accounts that can execute actions within each roles.
9     address public ceoAddress;
10     address public cfoAddress;
11     address public cooAddress;
12 
13     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
14     bool public paused = false;
15     
16     /// constructor
17     function OwnerBase() public {
18        ceoAddress = msg.sender;
19        cfoAddress = msg.sender;
20        cooAddress = msg.sender;
21     }
22 
23     /// @dev Access modifier for CEO-only functionality
24     modifier onlyCEO() {
25         require(msg.sender == ceoAddress);
26         _;
27     }
28 
29     /// @dev Access modifier for CFO-only functionality
30     modifier onlyCFO() {
31         require(msg.sender == cfoAddress);
32         _;
33     }
34     
35     /// @dev Access modifier for COO-only functionality
36     modifier onlyCOO() {
37         require(msg.sender == cooAddress);
38         _;
39     }
40 
41     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
42     /// @param _newCEO The address of the new CEO
43     function setCEO(address _newCEO) external onlyCEO {
44         require(_newCEO != address(0));
45 
46         ceoAddress = _newCEO;
47     }
48 
49 
50     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
51     /// @param _newCFO The address of the new COO
52     function setCFO(address _newCFO) external onlyCEO {
53         require(_newCFO != address(0));
54 
55         cfoAddress = _newCFO;
56     }
57     
58     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
59     /// @param _newCOO The address of the new COO
60     function setCOO(address _newCOO) external onlyCEO {
61         require(_newCOO != address(0));
62 
63         cooAddress = _newCOO;
64     }
65 
66     /// @dev Modifier to allow actions only when the contract IS NOT paused
67     modifier whenNotPaused() {
68         require(!paused);
69         _;
70     }
71 
72     /// @dev Modifier to allow actions only when the contract IS paused
73     modifier whenPaused {
74         require(paused);
75         _;
76     }
77 
78     /// @dev Called by any "C-level" role to pause the contract. Used only when
79     ///  a bug or exploit is detected and we need to limit damage.
80     function pause() external onlyCOO whenNotPaused {
81         paused = true;
82     }
83 
84     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
85     ///  one reason we may pause the contract is when CFO or COO accounts are
86     ///  compromised.
87     /// @notice This is public rather than external so it can be called by
88     ///  derived contracts.
89     function unpause() public onlyCOO whenPaused {
90         // can't unpause if contract was upgraded
91         paused = false;
92     }
93 	
94 	
95 	/// @dev check wether target address is a contract or not
96     function isNormalUser(address addr) internal view returns (bool) {
97 		if (addr == address(0)) {
98 			return false;
99 		}
100         uint size = 0;
101         assembly { 
102 		    size := extcodesize(addr) 
103 		} 
104         return size == 0;
105     }
106 }
107 
108 
109 /**
110  * Math operations with safety checks
111  */
112 contract SafeMath {
113     function safeMul(uint a, uint b) internal pure returns (uint) {
114         uint c = a * b;
115         assert(a == 0 || c / a == b);
116         return c;
117     }
118 
119     function safeDiv(uint a, uint b) internal pure returns (uint) {
120         assert(b > 0);
121         uint c = a / b;
122         assert(a == b * c + a % b);
123         return c;
124     }
125 
126     function safeSub(uint a, uint b) internal pure returns (uint) {
127         assert(b <= a);
128         return a - b;
129     }
130 
131     function safeAdd(uint a, uint b) internal pure returns (uint) {
132         uint c = a + b;
133         assert(c>=a && c>=b);
134         return c;
135     }
136 
137     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
138         return a >= b ? a : b;
139     }
140 
141     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
142         return a < b ? a : b;
143     }
144 
145     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a >= b ? a : b;
147     }
148 
149     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a < b ? a : b;
151     }
152  
153 }
154 
155 
156 
157 /// @title Interface of contract for partner
158 /// @author cuilichen
159 contract PartnerHolder {
160     //
161     function isHolder() public pure returns (bool);
162     
163     // Required methods
164     function bonusAll() payable public ;
165 	
166 	
167 	function bonusOne(uint id) payable public ;
168     
169 }
170 
171 /// @title Contract for partner. Holds all partner structs, events and base variables.
172 /// @author cuilichen
173 contract Partners is OwnerBase, SafeMath, PartnerHolder {
174 
175     event Bought(uint16 id, address newOwner, uint price, address oldOwner);
176     
177 	// data of Casino
178     struct Casino {
179 		uint16 id;
180 		uint16 star;
181 		address owner;
182 		uint price;
183 		string name;
184 		string desc;
185     }
186 	
187 	// address to balance.
188 	mapping(address => uint) public balances;
189 	
190 	
191 	mapping(uint => Casino) public allCasinos; // key is id
192 	
193 	// all ids of casinos
194 	uint[] public ids;
195 	
196 	
197 	uint public masterCut = 200;
198 	
199 	// master balance;
200 	uint public masterHas = 0;
201 	
202 	
203 	function Partners() public {
204 		ceoAddress = msg.sender;
205         cooAddress = msg.sender;
206         cfoAddress = msg.sender;
207 		
208 	}
209 	
210 	function initCasino() public onlyCOO {
211 		addCasino(5, 100000000000000000, 'Las Vegas Bellagio Casino', 'Five star Casino');
212 		addCasino(4, 70000000000000000, 'London Ritz Club Casino', 'Four star Casino');
213 		addCasino(4, 70000000000000000, 'Las Vegas Metropolitan Casino', 'Four star Casino');
214 		addCasino(4, 70000000000000000, 'Argentina Park Hyatt Mendoza Casino', 'Four star Casino');
215 		addCasino(3, 30000000000000000, 'Canada Golf Thalasso & Casino Resort', 'Three star Casino');
216 		addCasino(3, 30000000000000000, 'Monaco Monte-Carlo Casino', 'Three star Casino');
217 		addCasino(3, 30000000000000000, 'Las Vegas Flamingo Casino', 'Three star Casino');
218 		addCasino(3, 30000000000000000, 'New Jersey Bogota Casino', 'Three star Casino');
219 		addCasino(3, 30000000000000000, 'Atlantic City Taj Mahal Casino', 'Three star Casino');
220 		addCasino(2, 20000000000000000, 'Dubai Atlantis Casino', 'Two star Casino');
221 		addCasino(2, 20000000000000000, 'Germany Baden-Baden Casino', 'Two star Casino');
222 		addCasino(2, 20000000000000000, 'South Korea Paradise Walker Hill Casino', 'Two star Casino');
223 		addCasino(2, 20000000000000000, 'Las Vegas Paris Casino', 'Two star Casino');
224 		addCasino(2, 20000000000000000, 'Las Vegas Caesars Palace Casino', 'Two star Casino');
225 		addCasino(1, 10000000000000000, 'Las Vegas Riviera Casino', 'One star Casino');
226 		addCasino(1, 10000000000000000, 'Las Vegas Mandalay Bay Casino', 'One star Casino');
227 		addCasino(1, 10000000000000000, 'Las Vegas MGM Casino', 'One star Casino');
228 		addCasino(1, 10000000000000000, 'Las Vegas New York Casino', 'One star Casino');
229 		addCasino(1, 10000000000000000, 'Las Vegas  Renaissance Casino', 'One star Casino');
230 		addCasino(1, 10000000000000000, 'Las Vegas Venetian Casino', 'One star Casino');
231 		addCasino(1, 10000000000000000, 'Melbourne Crown Casino', 'One star Casino');
232 		addCasino(1, 10000000000000000, 'Macao Grand Lisb Casino', 'One star Casino');
233 		addCasino(1, 10000000000000000, 'Singapore Marina Bay Sands Casino', 'One star Casino');
234 		addCasino(1, 10000000000000000, 'Malaysia Cloud Top Mountain Casino', 'One star Casino');
235 		addCasino(1, 10000000000000000, 'South Africa Sun City Casino', 'One star Casino');
236 		addCasino(1, 10000000000000000, 'Vietnam Smear Peninsula Casino', 'One star Casino');
237 		addCasino(1, 10000000000000000, 'Macao Sands Casino', 'One star Casino');
238 		addCasino(1, 10000000000000000, 'Bahamas Paradise Island Casino', 'One star Casino');
239 		addCasino(1, 10000000000000000, 'Philippines Manila Casinos', 'One star Casino');
240 	}
241 	///
242 	function () payable public {
243 		//receive ether.
244 		masterHas = safeAdd(masterHas, msg.value);
245 	}
246 	
247 	/// @dev add a new casino 
248 	function addCasino(uint16 _star, uint _price, string _name, string _desc) internal 
249 	{
250 		uint newID = ids.length + 1;
251 		Casino memory item = Casino({
252 			id:uint16(newID),
253 			star:_star,
254 			owner:cooAddress,
255 			price:_price,
256 			name:_name,
257 			desc:_desc
258 		});
259 		allCasinos[newID] = item;
260 		ids.push(newID);
261 	}
262 	
263 	/// @dev set casino name and description by coo
264 	function setCasinoName(uint16 id, string _name, string _desc) public onlyCOO 
265 	{
266 		Casino storage item = allCasinos[id];
267 		require(item.id > 0);
268 		item.name = _name;
269 		item.desc = _desc;
270 	}
271 	
272 	/// @dev check wether the address is a casino owner.
273 	function isOwner( address addr) public view returns (uint16) 
274 	{
275 		for(uint16 id = 1; id <= 29; id++) {
276 			Casino storage item = allCasinos[id];
277 			if ( item.owner == addr) {
278 				return id;
279 			}
280 		}
281 		return 0;
282 	}
283 	
284 	/// @dev identify this contract is a partner holder.
285 	function isHolder() public pure returns (bool) {
286 		return true;
287 	}
288 	
289 	
290 	/// @dev give bonus to all partners, and the owners can withdraw it soon.
291 	function bonusAll() payable public {
292 		uint total = msg.value;
293 		uint remain = total;
294 		if (total > 0) {
295 			for (uint i = 0; i < ids.length; i++) {
296 				uint id = ids[i];
297 				Casino storage item = allCasinos[id];
298 				uint fund = 0;
299 				if (item.star == 5) {
300 					fund = safeDiv(safeMul(total, 2000), 10000);
301 				} else if (item.star == 4) {
302 					fund = safeDiv(safeMul(total, 1000), 10000);
303 				} else if (item.star == 3) {
304 					fund = safeDiv(safeMul(total, 500), 10000);
305 				} else if (item.star == 2) {
306 					fund = safeDiv(safeMul(total, 200), 10000);
307 				} else {
308 					fund = safeDiv(safeMul(total, 100), 10000);
309 				}
310 				
311 				if (remain >= fund) {
312 					remain -= fund;
313 					address owner = item.owner;
314 					if (owner != address(0)) {
315 						uint oldVal = balances[owner];
316 						balances[owner] = safeAdd(oldVal, fund);
317 					}
318 				}
319 			}
320 		}
321 		
322 	}
323 	
324 	
325 	/// @dev bonus to casino which has the specific id
326 	function bonusOne(uint id) payable public {
327 		Casino storage item = allCasinos[id];
328 		address owner = item.owner;
329 		if (owner != address(0)) {
330 			uint oldVal = balances[owner];
331 			balances[owner] = safeAdd(oldVal, msg.value);
332 		} else {
333 			masterHas = safeAdd(masterHas, msg.value);
334 		}
335 	}
336 	
337 	
338 	/// @dev user withdraw, 
339 	function userWithdraw() public {
340 		uint fund = balances[msg.sender];
341 		require (fund > 0);
342 		delete balances[msg.sender];
343 		msg.sender.transfer(fund);
344 	}
345 	
346 	
347     
348     /// @dev buy a casino without any agreement.
349     function buy(uint16 _id) payable public returns (bool) {
350 		Casino storage item = allCasinos[_id];
351 		uint oldPrice = item.price;
352 		require(oldPrice > 0);
353 		require(msg.value >= oldPrice);
354 		
355 		address oldOwner = item.owner;
356 		address newOwner = msg.sender;
357 		require(oldOwner != address(0));
358 		require(oldOwner != newOwner);
359 		require(isNormalUser(newOwner));
360 		
361 		item.price = calcNextPrice(oldPrice);
362 		item.owner = newOwner;
363 		emit Bought(_id, newOwner, oldPrice, oldOwner);
364 		
365 		// Transfer payment to old owner minus the developer's cut.
366 		uint256 devCut = safeDiv(safeMul(oldPrice, masterCut), 10000);
367 		oldOwner.transfer(safeSub(oldPrice, devCut));
368 		masterHas = safeAdd(masterHas, devCut);
369 		
370 		uint256 excess = msg.value - oldPrice;
371 		if (excess > 0) {
372 			newOwner.transfer(excess);
373 		}
374     }
375 	
376 	
377 	
378 	/// @dev calculate next price 
379 	function calcNextPrice (uint _price) public pure returns (uint nextPrice) {
380 		if (_price >= 5 ether ) {
381 			return safeDiv(safeMul(_price, 110), 100);
382 		} else if (_price >= 2 ether ) {
383 			return safeDiv(safeMul(_price, 120), 100);
384 		} else if (_price >= 500 finney ) {
385 			return safeDiv(safeMul(_price, 130), 100);
386 		} else if (_price >= 20 finney ) {
387 			return safeDiv(safeMul(_price, 140), 100);
388 		} else {
389 			return safeDiv(safeMul(_price, 200), 100);
390 		}
391 	}
392 	
393 	
394 	// @dev Allows the CFO to capture the balance.
395     function cfoWithdraw() external onlyCFO {
396 		cfoAddress.transfer(masterHas);
397 		masterHas = 0;
398     }
399 	
400 	
401 	
402 	/// @dev cfo withdraw dead ether. 
403     function withdrawDeadFund( address addr) external onlyCFO {
404         uint fund = balances[addr];
405         require (fund > 0);
406         delete balances[addr];
407         cfoAddress.transfer(fund);
408     }
409 	
410 	
411 }