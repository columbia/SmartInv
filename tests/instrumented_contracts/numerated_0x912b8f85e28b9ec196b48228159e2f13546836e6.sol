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
134 	event LogDeposit(address _user, uint _amnt);
135 	event LogWithdrawal(address _user, uint _amnt);
136 
137 	function acceptBid(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _rewardAmount, uint _timeout, bytes32 _adslot, uint8 v, bytes32 r, bytes32 s, uint8 sigMode) public;
138 	function cancelBid(bytes32 _adunit, uint _opened, uint _target, uint _rewardAmount, uint _timeout, uint8 v, bytes32 r, bytes32 s, uint8 sigMode) public;
139 	function giveupBid(bytes32 _bidId) public;
140 	function refundBid(bytes32 _bidId) public;
141 	function verifyBid(bytes32 _bidId, bytes32 _report) public;
142 
143 	function deposit(uint _amount) public;
144 	function withdraw(uint _amount) public;
145 
146 	// constants 
147 	function getBid(bytes32 _bidId) 
148 		constant external 
149 		returns (
150 			uint, uint, uint, uint, uint, 
151 			// advertiser (advertiser, ad unit, confiration)
152 			address, bytes32, bytes32,
153 			// publisher (publisher, ad slot, confirmation)
154 			address, bytes32, bytes32
155 		);
156 
157 	function getBalance(address _user)
158 		constant
159 		external
160 		returns (uint, uint);
161 
162 	function getBidID(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout)
163 		constant
164 		public
165 		returns (bytes32);
166 }
167 
168 
169 contract ADXExchange is ADXExchangeInterface, Drainable {
170 	string public name = "AdEx Exchange";
171 
172 	ERC20 public token;
173 
174 	uint public maxTimeout = 365 days;
175 
176  	mapping (address => uint) balances;
177 
178  	// escrowed on bids
179  	mapping (address => uint) onBids; 
180 
181  	// bid info
182 	mapping (bytes32 => Bid) bids;
183 	mapping (bytes32 => BidState) bidStates;
184 
185 
186 	enum BidState { 
187 		DoesNotExist, // default state
188 
189 		// There is no 'Open' state - the Open state is just a signed message that you're willing to place such a bid
190 		Accepted, // in progress
191 
192 		// the following states MUST unlock the ADX amount (return to advertiser)
193 		// fail states
194 		Canceled,
195 		Expired,
196 
197 		// success states
198 		Completed
199 	}
200 
201 	struct Bid {
202 		// Links on advertiser side
203 		address advertiser;
204 		bytes32 adUnit;
205 
206 		// Links on publisher side
207 		address publisher;
208 		bytes32 adSlot;
209 
210 		// when was it accepted by a publisher
211 		uint acceptedTime;
212 
213 		// Token reward amount
214 		uint amount;
215 
216 		// Requirements
217 		uint target; // how many impressions/clicks/conversions have to be done
218 		uint timeout; // the time to execute
219 
220 		// Confirmations from both sides; any value other than 0 is vconsidered as confirm, but this should usually be an IPFS hash to a final report
221 		bytes32 publisherConfirmation;
222 		bytes32 advertiserConfirmation;
223 	}
224 
225 	// Schema hash 
226 	// keccak256(_advertiser, _adunit, _opened, _target, _amount, _timeout, this)
227 	bytes32 constant public SCHEMA_HASH = keccak256(
228 		"address Advertiser",
229 		"bytes32 Ad Unit ID",
230 		"uint Opened",
231 		"uint Target",
232 		"uint Amount",
233 		"uint Timeout",
234 		"address Exchange"
235 	);
236 
237 	//
238 	// MODIFIERS
239 	//
240 	modifier onlyBidAdvertiser(bytes32 _bidId) {
241 		require(msg.sender == bids[_bidId].advertiser);
242 		_;
243 	}
244 
245 	modifier onlyBidPublisher(bytes32 _bidId) {
246 		require(msg.sender == bids[_bidId].publisher);
247 		_;
248 	}
249 
250 	modifier onlyBidState(bytes32 _bidId, BidState _state) {
251 		require(bidStates[_bidId] == _state);
252 		_;
253 	}
254 
255 	// Functions
256 
257 	function ADXExchange(address _token)
258 		public
259 	{
260 		token = ERC20(_token);
261 	}
262 
263 	//
264 	// Bid actions
265 	// 
266 
267 	// the bid is accepted by the publisher
268 	function acceptBid(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout, bytes32 _adslot, uint8 v, bytes32 r, bytes32 s, uint8 sigMode)
269 		public
270 	{
271 		require(_amount > 0);
272 
273 		// It can be proven that onBids will never exceed balances which means this can't underflow
274 		// SafeMath can't be used here because of the stack depth
275 		require(_amount <= (balances[_advertiser] - onBids[_advertiser]));
276 
277 		// _opened acts as a nonce here
278 		bytes32 bidId = getBidID(_advertiser, _adunit, _opened, _target, _amount, _timeout);
279 
280 		require(bidStates[bidId] == BidState.DoesNotExist);
281 
282 		require(didSign(_advertiser, bidId, v, r, s, sigMode));
283 		
284 		// advertier and publisher cannot be the same
285 		require(_advertiser != msg.sender);
286 
287 		Bid storage bid = bids[bidId];
288 
289 		bid.target = _target;
290 		bid.amount = _amount;
291 
292 		// it is pretty much mandatory for a bid to have a timeout, else tokens can be stuck forever
293 		bid.timeout = _timeout > 0 ? _timeout : maxTimeout;
294 		require(bid.timeout <= maxTimeout);
295 
296 		bid.advertiser = _advertiser;
297 		bid.adUnit = _adunit;
298 
299 		bid.publisher = msg.sender;
300 		bid.adSlot = _adslot;
301 
302 		bid.acceptedTime = now;
303 
304 		bidStates[bidId] = BidState.Accepted;
305 
306 		onBids[_advertiser] += _amount;
307 
308 		// static analysis?
309 		// require(onBids[_advertiser] <= balances[advertiser]);
310 
311 		LogBidAccepted(bidId, _advertiser, _adunit, msg.sender, _adslot, bid.acceptedTime);
312 	}
313 
314 	// The bid is canceled by the advertiser
315 	function cancelBid(bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout, uint8 v, bytes32 r, bytes32 s, uint8 sigMode)
316 		public
317 	{
318 		// _opened acts as a nonce here
319 		bytes32 bidId = getBidID(msg.sender, _adunit, _opened, _target, _amount, _timeout);
320 
321 		require(bidStates[bidId] == BidState.DoesNotExist);
322 
323 		require(didSign(msg.sender, bidId, v, r, s, sigMode));
324 
325 		bidStates[bidId] = BidState.Canceled;
326 
327 		LogBidCanceled(bidId);
328 	}
329 
330 	// The bid is canceled by the publisher
331 	function giveupBid(bytes32 _bidId)
332 		public
333 		onlyBidPublisher(_bidId)
334 		onlyBidState(_bidId, BidState.Accepted)
335 	{
336 		Bid storage bid = bids[_bidId];
337 
338 		bidStates[_bidId] = BidState.Canceled;
339 
340 		onBids[bid.advertiser] -= bid.amount;
341 	
342 		LogBidCanceled(_bidId);
343 	}
344 
345 
346 	// This can be done if a bid is accepted, but expired
347 	// This is essentially the protection from never settling on verification, or from publisher not executing the bid within a reasonable time
348 	function refundBid(bytes32 _bidId)
349 		public
350 		onlyBidAdvertiser(_bidId)
351 		onlyBidState(_bidId, BidState.Accepted)
352 	{
353 		Bid storage bid = bids[_bidId];
354 
355  		// require that we're past the point of expiry
356 		require(now > SafeMath.add(bid.acceptedTime, bid.timeout));
357 
358 		bidStates[_bidId] = BidState.Expired;
359 
360 		onBids[bid.advertiser] -= bid.amount;
361 
362 		LogBidExpired(_bidId);
363 	}
364 
365 
366 	// both publisher and advertiser have to call this for a bid to be considered verified
367 	function verifyBid(bytes32 _bidId, bytes32 _report)
368 		public
369 		onlyBidState(_bidId, BidState.Accepted)
370 	{
371 		Bid storage bid = bids[_bidId];
372 
373 		require(_report != 0);
374 		require(bid.publisher == msg.sender || bid.advertiser == msg.sender);
375 
376 		if (bid.publisher == msg.sender) {
377 			require(bid.publisherConfirmation == 0);
378 			bid.publisherConfirmation = _report;
379 		}
380 
381 		if (bid.advertiser == msg.sender) {
382 			require(bid.advertiserConfirmation == 0);
383 			bid.advertiserConfirmation = _report;
384 		}
385 
386 		LogBidConfirmed(_bidId, msg.sender, _report);
387 
388 		if (bid.advertiserConfirmation != 0 && bid.publisherConfirmation != 0) {
389 			bidStates[_bidId] = BidState.Completed;
390 
391 			onBids[bid.advertiser] = SafeMath.sub(onBids[bid.advertiser], bid.amount);
392 			balances[bid.advertiser] = SafeMath.sub(balances[bid.advertiser], bid.amount);
393 			balances[bid.publisher] = SafeMath.add(balances[bid.publisher], bid.amount);
394 
395 			LogBidCompleted(_bidId, bid.advertiserConfirmation, bid.publisherConfirmation);
396 		}
397 	}
398 
399 	// Deposit and withdraw
400 	function deposit(uint _amount)
401 		public
402 	{
403 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _amount);
404 		require(token.transferFrom(msg.sender, address(this), _amount));
405 
406 		LogDeposit(msg.sender, _amount);
407 	}
408 
409 	function withdraw(uint _amount)
410 		public
411 	{
412 		uint available = SafeMath.sub(balances[msg.sender], onBids[msg.sender]);
413 		require(_amount <= available);
414 
415 		balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
416 		require(token.transfer(msg.sender, _amount));
417 
418 		LogWithdrawal(msg.sender, _amount);
419 	}
420 
421 	function didSign(address addr, bytes32 hash, uint8 v, bytes32 r, bytes32 s, uint8 mode)
422 		public
423 		pure
424 		returns (bool)
425 	{
426 		bytes32 message = hash;
427 		
428 		if (mode == 1) {
429 			// Geth mode
430 			message = keccak256("\x19Ethereum Signed Message:\n32", hash);
431 		} else if (mode == 2) {
432 			// Trezor mode
433 			message = keccak256("\x19Ethereum Signed Message:\n\x20", hash);
434 		}
435 
436 		return ecrecover(message, v, r, s) == addr;
437 	}
438 
439 	//
440 	// Public constant functions
441 	//
442 	function getBid(bytes32 _bidId) 
443 		constant
444 		external
445 		returns (
446 			uint, uint, uint, uint, uint, 
447 			// advertiser (advertiser, ad unit, confiration)
448 			address, bytes32, bytes32,
449 			// publisher (publisher, ad slot, confirmation)
450 			address, bytes32, bytes32
451 		)
452 	{
453 		Bid storage bid = bids[_bidId];
454 		return (
455 			uint(bidStates[_bidId]), bid.target, bid.timeout, bid.amount, bid.acceptedTime,
456 			bid.advertiser, bid.adUnit, bid.advertiserConfirmation,
457 			bid.publisher, bid.adSlot, bid.publisherConfirmation
458 		);
459 	}
460 
461 	function getBalance(address _user)
462 		constant
463 		external
464 		returns (uint, uint)
465 	{
466 		return (balances[_user], onBids[_user]);
467 	}
468 
469 	function getBidID(address _advertiser, bytes32 _adunit, uint _opened, uint _target, uint _amount, uint _timeout)
470 		constant
471 		public
472 		returns (bytes32)
473 	{
474 		return keccak256(
475 			SCHEMA_HASH,
476 			keccak256(_advertiser, _adunit, _opened, _target, _amount, _timeout, this)
477 		);
478 	}
479 }