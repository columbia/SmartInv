1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender) public view returns (uint256);
102   function transferFrom(address from, address to, uint256 value) public returns (bool);
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 contract Drainable is Ownable {
109 	function withdrawToken(address tokenaddr) 
110 		onlyOwner
111 		public
112 	{
113 		ERC20 token = ERC20(tokenaddr);
114 		uint bal = token.balanceOf(address(this));
115 		token.transfer(msg.sender, bal);
116 	}
117 
118 	function withdrawEther() 
119 		onlyOwner
120 		public
121 	{
122 	    require(msg.sender.send(this.balance));
123 	}
124 }
125 
126 contract ADXExchangeInterface {
127 	// events
128 	event LogBidAccepted(bytes32 bidId, address advertiser, bytes32 adunit, address publisher, bytes32 adslot, uint acceptedTime);
129 	event LogBidCanceled(bytes32 bidId);
130 	event LogBidExpired(bytes32 bidId);
131 	event LogBidConfirmed(bytes32 bidId, address advertiserOrPublisher, bytes32 report);
132 	event LogBidCompleted(bytes32 bidId, bytes32 advReport, bytes32 pubReport);
133 
134 	function acceptBid(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _rewardAmount, uint _timeout, bytes32 _adslot, uint8 v, bytes32 r, bytes32 s, uint8 sigMode) public;
135 	function cancelBid(bytes32 _adunit, uint _opened, uint _target, uint _rewardAmount, uint _timeout, uint8 v, bytes32 r, bytes32 s, uint8 sigMode) public;
136 	function giveupBid(bytes32 _bidId) public;
137 	function refundBid(bytes32 _bidId) public;
138 	function verifyBid(bytes32 _bidId, bytes32 _report) public;
139 
140 	function deposit(uint _amount) public;
141 	function withdraw(uint _amount) public;
142 
143 	// constants 
144 	function getBid(bytes32 _bidId) 
145 		constant external 
146 		returns (
147 			uint, uint, uint, uint, uint, 
148 			// advertiser (advertiser, ad unit, confiration)
149 			address, bytes32, bytes32,
150 			// publisher (publisher, ad slot, confirmation)
151 			address, bytes32, bytes32
152 		);
153 
154 	function getBalance(address _user)
155 		constant
156 		external
157 		returns (uint, uint);
158 
159 	function getBidID(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout)
160 		constant
161 		public
162 		returns (bytes32);
163 }
164 
165 
166 contract ADXExchange is ADXExchangeInterface, Drainable {
167 	string public name = "AdEx Exchange";
168 
169 	ERC20 public token;
170 
171 	uint public maxTimeout = 365 days;
172 
173  	mapping (address => uint) balances;
174 
175  	// escrowed on bids
176  	mapping (address => uint) onBids; 
177 
178  	// bid info
179 	mapping (bytes32 => Bid) bids;
180 	mapping (bytes32 => BidState) bidStates;
181 
182 
183 	enum BidState { 
184 		DoesNotExist, // default state
185 
186 		// There is no 'Open' state - the Open state is just a signed message that you're willing to place such a bid
187 		Accepted, // in progress
188 
189 		// the following states MUST unlock the ADX amount (return to advertiser)
190 		// fail states
191 		Canceled,
192 		Expired,
193 
194 		// success states
195 		Completed
196 	}
197 
198 	struct Bid {
199 		// Links on advertiser side
200 		address advertiser;
201 		bytes32 adUnit;
202 
203 		// Links on publisher side
204 		address publisher;
205 		bytes32 adSlot;
206 
207 		// when was it accepted by a publisher
208 		uint acceptedTime;
209 
210 		// Token reward amount
211 		uint amount;
212 
213 		// Requirements
214 		uint target; // how many impressions/clicks/conversions have to be done
215 		uint timeout; // the time to execute
216 
217 		// Confirmations from both sides; any value other than 0 is vconsidered as confirm, but this should usually be an IPFS hash to a final report
218 		bytes32 publisherConfirmation;
219 		bytes32 advertiserConfirmation;
220 	}
221 
222 	// Schema hash 
223 	// keccak256(_advertiser, _adunit, _opened, _target, _amount, _timeout, this)
224 	bytes32 constant public SCHEMA_HASH = keccak256(
225 		"address Advertiser",
226 		"bytes32 Ad Unit ID",
227 		"uint Opened",
228 		"uint Target",
229 		"uint Amount",
230 		"uint Timeout",
231 		"address Exchange"
232 	);
233 
234 	//
235 	// MODIFIERS
236 	//
237 	modifier onlyBidAdvertiser(bytes32 _bidId) {
238 		require(msg.sender == bids[_bidId].advertiser);
239 		_;
240 	}
241 
242 	modifier onlyBidPublisher(bytes32 _bidId) {
243 		require(msg.sender == bids[_bidId].publisher);
244 		_;
245 	}
246 
247 	modifier onlyBidState(bytes32 _bidId, BidState _state) {
248 		require(bidStates[_bidId] == _state);
249 		_;
250 	}
251 
252 	// Functions
253 
254 	function ADXExchange(address _token)
255 		public
256 	{
257 		token = ERC20(_token);
258 	}
259 
260 	//
261 	// Bid actions
262 	// 
263 
264 	// the bid is accepted by the publisher
265 	function acceptBid(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout, bytes32 _adslot, uint8 v, bytes32 r, bytes32 s, uint8 sigMode)
266 		public
267 	{
268 		require(_amount > 0);
269 
270 		// It can be proven that onBids will never exceed balances which means this can't underflow
271 		// SafeMath can't be used here because of the stack depth
272 		require(_amount <= (balances[_advertiser] - onBids[_advertiser]));
273 
274 		// _opened acts as a nonce here
275 		bytes32 bidId = getBidID(_advertiser, _adunit, _opened, _target, _amount, _timeout);
276 
277 		require(bidStates[bidId] == BidState.DoesNotExist);
278 
279 		require(didSign(_advertiser, bidId, v, r, s, sigMode));
280 		
281 		// advertier and publisher cannot be the same
282 		require(_advertiser != msg.sender);
283 
284 		Bid storage bid = bids[bidId];
285 
286 		bid.target = _target;
287 		bid.amount = _amount;
288 
289 		// it is pretty much mandatory for a bid to have a timeout, else tokens can be stuck forever
290 		bid.timeout = _timeout > 0 ? _timeout : maxTimeout;
291 		require(bid.timeout <= maxTimeout);
292 
293 		bid.advertiser = _advertiser;
294 		bid.adUnit = _adunit;
295 
296 		bid.publisher = msg.sender;
297 		bid.adSlot = _adslot;
298 
299 		bid.acceptedTime = now;
300 
301 		bidStates[bidId] = BidState.Accepted;
302 
303 		onBids[_advertiser] += _amount;
304 
305 		// static analysis?
306 		// require(onBids[_advertiser] <= balances[advertiser]);
307 
308 		LogBidAccepted(bidId, _advertiser, _adunit, msg.sender, _adslot, bid.acceptedTime);
309 	}
310 
311 	// The bid is canceled by the advertiser
312 	function cancelBid(bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout, uint8 v, bytes32 r, bytes32 s, uint8 sigMode)
313 		public
314 	{
315 		// _opened acts as a nonce here
316 		bytes32 bidId = getBidID(msg.sender, _adunit, _opened, _target, _amount, _timeout);
317 
318 		require(bidStates[bidId] == BidState.DoesNotExist);
319 
320 		require(didSign(msg.sender, bidId, v, r, s, sigMode));
321 
322 		bidStates[bidId] = BidState.Canceled;
323 
324 		LogBidCanceled(bidId);
325 	}
326 
327 	// The bid is canceled by the publisher
328 	function giveupBid(bytes32 _bidId)
329 		public
330 		onlyBidPublisher(_bidId)
331 		onlyBidState(_bidId, BidState.Accepted)
332 	{
333 		Bid storage bid = bids[_bidId];
334 
335 		bidStates[_bidId] = BidState.Canceled;
336 
337 		onBids[bid.advertiser] -= bid.amount;
338 	
339 		LogBidCanceled(_bidId);
340 	}
341 
342 
343 	// This can be done if a bid is accepted, but expired
344 	// This is essentially the protection from never settling on verification, or from publisher not executing the bid within a reasonable time
345 	function refundBid(bytes32 _bidId)
346 		public
347 		onlyBidAdvertiser(_bidId)
348 		onlyBidState(_bidId, BidState.Accepted)
349 	{
350 		Bid storage bid = bids[_bidId];
351 
352  		// require that we're past the point of expiry
353 		require(now > SafeMath.add(bid.acceptedTime, bid.timeout));
354 
355 		bidStates[_bidId] = BidState.Expired;
356 
357 		onBids[bid.advertiser] -= bid.amount;
358 
359 		LogBidExpired(_bidId);
360 	}
361 
362 
363 	// both publisher and advertiser have to call this for a bid to be considered verified
364 	function verifyBid(bytes32 _bidId, bytes32 _report)
365 		public
366 		onlyBidState(_bidId, BidState.Accepted)
367 	{
368 		Bid storage bid = bids[_bidId];
369 
370 		require(_report != 0);
371 		require(bid.publisher == msg.sender || bid.advertiser == msg.sender);
372 
373 		if (bid.publisher == msg.sender) {
374 			require(bid.publisherConfirmation == 0);
375 			bid.publisherConfirmation = _report;
376 		}
377 
378 		if (bid.advertiser == msg.sender) {
379 			require(bid.advertiserConfirmation == 0);
380 			bid.advertiserConfirmation = _report;
381 		}
382 
383 		LogBidConfirmed(_bidId, msg.sender, _report);
384 
385 		if (bid.advertiserConfirmation != 0 && bid.publisherConfirmation != 0) {
386 			bidStates[_bidId] = BidState.Completed;
387 
388 			onBids[bid.advertiser] = SafeMath.sub(onBids[bid.advertiser], bid.amount);
389 			balances[bid.advertiser] = SafeMath.sub(balances[bid.advertiser], bid.amount);
390 			balances[bid.publisher] = SafeMath.add(balances[bid.publisher], bid.amount);
391 
392 			LogBidCompleted(_bidId, bid.advertiserConfirmation, bid.publisherConfirmation);
393 		}
394 	}
395 
396 	// Deposit and withdraw
397 	function deposit(uint _amount)
398 		public
399 	{
400 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _amount);
401 		require(token.transferFrom(msg.sender, address(this), _amount));
402 	}
403 
404 	function withdraw(uint _amount)
405 		public
406 	{
407 		uint available = SafeMath.sub(balances[msg.sender], onBids[msg.sender]);
408 		require(_amount <= available);
409 
410 		balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
411 		require(token.transfer(msg.sender, _amount));
412 	}
413 
414 	function didSign(address addr, bytes32 hash, uint8 v, bytes32 r, bytes32 s, uint8 mode)
415 		public
416 		pure
417 		returns (bool)
418 	{
419 		bytes32 message = hash;
420 		
421 		if (mode == 1) {
422 			// Geth mode
423 			message = keccak256("\x19Ethereum Signed Message:\n32", hash);
424 		} else if (mode == 2) {
425 			// Trezor mode
426 			message = keccak256("\x19Ethereum Signed Message:\n\x20", hash);
427 		}
428 
429 		return ecrecover(message, v, r, s) == addr;
430 	}
431 
432 	//
433 	// Public constant functions
434 	//
435 	function getBid(bytes32 _bidId) 
436 		constant
437 		external
438 		returns (
439 			uint, uint, uint, uint, uint, 
440 			// advertiser (advertiser, ad unit, confiration)
441 			address, bytes32, bytes32,
442 			// publisher (publisher, ad slot, confirmation)
443 			address, bytes32, bytes32
444 		)
445 	{
446 		Bid storage bid = bids[_bidId];
447 		return (
448 			uint(bidStates[_bidId]), bid.target, bid.timeout, bid.amount, bid.acceptedTime,
449 			bid.advertiser, bid.adUnit, bid.advertiserConfirmation,
450 			bid.publisher, bid.adSlot, bid.publisherConfirmation
451 		);
452 	}
453 
454 	function getBalance(address _user)
455 		constant
456 		external
457 		returns (uint, uint)
458 	{
459 		return (balances[_user], onBids[_user]);
460 	}
461 
462 	function getBidID(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout)
463 		constant
464 		public
465 		returns (bytes32)
466 	{
467 		return keccak256(
468 			SCHEMA_HASH,
469 			keccak256(_advertiser, _adunit, _opened, _target, _amount, _timeout, this)
470 		);
471 	}
472 }