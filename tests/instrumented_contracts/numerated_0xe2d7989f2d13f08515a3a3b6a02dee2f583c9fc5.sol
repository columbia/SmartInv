1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Read-only ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ReadOnlyToken {
8     uint256 public totalSupply;
9     function balanceOf(address who) public constant returns (uint256);
10     function allowance(address owner, address spender) public constant returns (uint256);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract Token is ReadOnlyToken {
18   function transfer(address to, uint256 value) public returns (bool);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract MintableToken is Token {
26     event Mint(address indexed to, uint256 amount);
27 
28     function mint(address _to, uint256 _amount) public returns (bool);
29 }
30 
31 /**
32  * @title Sale contract for Daonomic platform should implement this
33  */
34 contract Sale {
35     /**
36      * @dev This event should be emitted when user buys something
37      */
38     event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus);
39     /**
40      * @dev Should be emitted if new payment method added
41      */
42     event RateAdd(address token);
43     /**
44      * @dev Should be emitted if payment method removed
45      */
46     event RateRemove(address token);
47 
48     /**
49      * @dev Calculate rate for specified payment method
50      */
51     function getRate(address token) constant public returns (uint256);
52     /**
53      * @dev Calculate current bonus in tokens
54      */
55     function getBonus(uint256 sold) constant public returns (uint256);
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  * @dev this version copied from zeppelin-solidity, constant changed to pure
62  */
63 library SafeMath {
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         assert(c / a == b);
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // assert(b > 0); // Solidity automatically throws when dividing by 0
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 /**
93  * @title Ownable
94  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
95  */
96 contract Ownable {
97     modifier onlyOwner() {
98         checkOwner();
99         _;
100     }
101 
102     function checkOwner() internal;
103 }
104 
105 /**
106  * @title Token represents some external value (for example, BTC)
107  */
108 contract ExternalToken is Token {
109     event Mint(address indexed to, uint256 value, bytes data);
110     event Burn(address indexed burner, uint256 value, bytes data);
111 
112     function burn(uint256 _value, bytes _data) public;
113 }
114 
115 /**
116  * @dev This adapter helps to receive tokens. It has some subcontracts for different tokens:
117  *   ERC20ReceiveAdapter - for receiving simple ERC20 tokens
118  *   ERC223ReceiveAdapter - for receiving ERC223 tokens
119  *   ReceiveApprovalAdapter - for receiving ERC20 tokens when token notifies receiver with receiveApproval
120  *   EtherReceiveAdapter - for receiving ether (onReceive callback will be used). this is needed for handling ether like tokens
121  *   CompatReceiveApproval - implements all these adapters
122  */
123 contract ReceiveAdapter {
124 
125     /**
126      * @dev Receive tokens from someone. Owner of the tokens should approve first
127      */
128     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal;
129 }
130 
131 /**
132  * @dev Helps to receive ERC20-complaint tokens. Owner should call token.approve first
133  */
134 contract ERC20ReceiveAdapter is ReceiveAdapter {
135     function receive(address _token, uint256 _value, bytes _data) public {
136         Token token = Token(_token);
137         token.transferFrom(msg.sender, this, _value);
138         onReceive(_token, msg.sender, _value, _data);
139     }
140 }
141 
142 /**
143  * @title ERC223 TokenReceiver interface
144  * @dev see https://github.com/ethereum/EIPs/issues/223
145  */
146 contract TokenReceiver {
147     function onTokenTransfer(address _from, uint256 _value, bytes _data) public;
148 }
149 
150 /**
151  * @dev Helps to receive ERC223-complaint tokens. ERC223 Token contract should notify receiver.
152  */
153 contract ERC223ReceiveAdapter is TokenReceiver, ReceiveAdapter {
154     function tokenFallback(address _from, uint256 _value, bytes _data) public {
155         onReceive(msg.sender, _from, _value, _data);
156     }
157 
158     function onTokenTransfer(address _from, uint256 _value, bytes _data) public {
159         onReceive(msg.sender, _from, _value, _data);
160     }
161 }
162 
163 contract EtherReceiver {
164 	function receiveWithData(bytes _data) payable public;
165 }
166 
167 contract EtherReceiveAdapter is EtherReceiver, ReceiveAdapter {
168     function () payable public {
169         receiveWithData("");
170     }
171 
172     function receiveWithData(bytes _data) payable public {
173         onReceive(address(0), msg.sender, msg.value, _data);
174     }
175 }
176 
177 /**
178  * @dev This ReceiveAdapter supports all possible tokens
179  */
180 contract CompatReceiveAdapter is ERC20ReceiveAdapter, ERC223ReceiveAdapter, EtherReceiveAdapter {
181 
182 }
183 
184 contract AbstractSale is Sale, CompatReceiveAdapter, Ownable {
185     using SafeMath for uint256;
186 
187     event Withdraw(address token, address to, uint256 value);
188     event Burn(address token, uint256 value, bytes data);
189 
190     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
191         uint256 sold = getSold(_token, _value);
192         require(sold > 0);
193         uint256 bonus = getBonus(sold);
194         address buyer;
195         if (_data.length == 20) {
196             buyer = address(toBytes20(_data, 0));
197         } else {
198             require(_data.length == 0);
199             buyer = _from;
200         }
201         checkPurchaseValid(buyer, sold, bonus);
202         doPurchase(buyer, sold, bonus);
203         Purchase(buyer, _token, _value, sold, bonus);
204         onPurchase(buyer, _token, _value, sold, bonus);
205     }
206 
207     function getSold(address _token, uint256 _value) constant public returns (uint256) {
208         uint256 rate = getRate(_token);
209         require(rate > 0);
210         return _value.mul(rate).div(10**18);
211     }
212 
213     function getBonus(uint256 sold) constant public returns (uint256);
214 
215     function getRate(address _token) constant public returns (uint256);
216 
217     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal;
218 
219     function checkPurchaseValid(address /*buyer*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
220 
221     }
222 
223     function onPurchase(address /*buyer*/, address /*token*/, uint256 /*value*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
224 
225     }
226 
227     function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
228         require(_start + 20 <= b.length);
229         assembly {
230             let from := add(_start, add(b, 0x20))
231             result := mload(from)
232         }
233     }
234 
235     function withdrawEth(address _to, uint256 _value) onlyOwner public {
236         withdraw(address(0), _to, _value);
237     }
238 
239     function withdraw(address _token, address _to, uint256 _value) onlyOwner public {
240         require(_to != address(0));
241         verifyCanWithdraw(_token, _to, _value);
242         if (_token == address(0)) {
243             _to.transfer(_value);
244         } else {
245             Token(_token).transfer(_to, _value);
246         }
247         Withdraw(_token, _to, _value);
248     }
249 
250     function verifyCanWithdraw(address token, address to, uint256 amount) internal;
251 
252     function burnWithData(address _token, uint256 _value, bytes _data) onlyOwner public {
253         ExternalToken(_token).burn(_value, _data);
254         Burn(_token, _value, _data);
255     }
256 }
257 
258 /**
259  * @title This sale mints token when user sends accepted payments
260  */
261 contract MintingSale is AbstractSale {
262     MintableToken public token;
263 
264     function MintingSale(address _token) public {
265         token = MintableToken(_token);
266     }
267 
268     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal {
269         token.mint(buyer, sold.add(bonus));
270     }
271 
272     function verifyCanWithdraw(address, address, uint256) internal {
273 
274     }
275 }
276 
277 /**
278  * @title OwnableImpl
279  * @dev The Ownable contract has an owner address, and provides basic authorization control
280  * functions, this simplifies the implementation of "user permissions".
281  */
282 contract OwnableImpl is Ownable {
283     address public owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289      * account.
290      */
291     function OwnableImpl() public {
292         owner = msg.sender;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     function checkOwner() internal {
299         require(msg.sender == owner);
300     }
301 
302     /**
303      * @dev Allows the current owner to transfer control of the contract to a newOwner.
304      * @param newOwner The address to transfer ownership to.
305      */
306     function transferOwnership(address newOwner) onlyOwner public {
307         require(newOwner != address(0));
308         OwnershipTransferred(owner, newOwner);
309         owner = newOwner;
310     }
311 }
312 
313 contract CappedBonusSale is AbstractSale {
314     uint256 public cap;
315     uint256 public initialCap;
316 
317     function CappedBonusSale(uint256 _cap) public {
318         cap = _cap;
319         initialCap = _cap;
320     }
321 
322     function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
323         super.checkPurchaseValid(buyer, sold, bonus);
324         require(cap >= sold.add(bonus));
325     }
326 
327     function onPurchase(address buyer, address token, uint256 value, uint256 sold, uint256 bonus) internal {
328         super.onPurchase(buyer, token, value, sold, bonus);
329         cap = cap.sub(sold).sub(bonus);
330     }
331 }
332 
333 contract PeriodSale is AbstractSale {
334 	uint256 public start;
335 	uint256 public end;
336 
337 	function PeriodSale(uint256 _start, uint256 _end) public {
338 		start = _start;
339 		end = _end;
340 	}
341 
342 	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
343 		super.checkPurchaseValid(buyer, sold, bonus);
344 		require(now > start && now < end);
345 	}
346 }
347 
348 /**
349  * @title Pausable
350  * @dev Base contract which allows children to implement an emergency stop mechanism.
351  */
352 contract Pausable is Ownable {
353     event Pause();
354     event Unpause();
355 
356     bool public paused = false;
357 
358 
359     /**
360      * @dev Modifier to make a function callable only when the contract is not paused.
361      */
362     modifier whenNotPaused() {
363         require(!paused);
364         _;
365     }
366 
367     /**
368      * @dev Modifier to make a function callable only when the contract is paused.
369      */
370     modifier whenPaused() {
371         require(paused);
372         _;
373     }
374 
375     /**
376      * @dev called by the owner to pause, triggers stopped state
377      */
378     function pause() onlyOwner whenNotPaused public {
379         paused = true;
380         Pause();
381     }
382 
383     /**
384      * @dev called by the owner to unpause, returns to normal state
385      */
386     function unpause() onlyOwner whenPaused public {
387         paused = false;
388         Unpause();
389     }
390 }
391 
392 contract GawooniSale is OwnableImpl, MintingSale, CappedBonusSale, PeriodSale {
393 	address public btcToken;
394 	uint256 public ethRate = 1000 * 10**18;
395 	uint256 public btcEthRate = 10 * 10**10;
396 
397 	function GawooniSale(
398 		address _mintableToken,
399 		address _btcToken,
400 		uint256 _start,
401 		uint256 _end,
402 		uint256 _cap)
403 	MintingSale(_mintableToken)
404 	CappedBonusSale(_cap)
405 	PeriodSale(_start, _end) {
406 		btcToken = _btcToken;
407 		RateAdd(address(0));
408 		RateAdd(_btcToken);
409 	}
410 
411 	function getRate(address _token) constant public returns (uint256) {
412 		if (_token == btcToken) {
413 			return btcEthRate * ethRate;
414 		} else if (_token == address(0)) {
415 			return ethRate;
416 		} else {
417 			return 0;
418 		}
419 	}
420 
421 	event EthRateChange(uint256 rate);
422 
423 	function setEthRate(uint256 _ethRate) onlyOwner public {
424 		ethRate = _ethRate;
425 		EthRateChange(_ethRate);
426 	}
427 
428 	event BtcEthRateChange(uint256 rate);
429 
430 	function setBtcEthRate(uint256 _btcEthRate) onlyOwner public {
431 		btcEthRate = _btcEthRate;
432 		BtcEthRateChange(_btcEthRate);
433 	}
434 
435 	function withdrawBtc(bytes _to, uint256 _value) onlyOwner public {
436 		burnWithData(btcToken, _value, _to);
437 	}
438 
439 	function transferTokenOwnership(address newOwner) onlyOwner public {
440 		OwnableImpl(token).transferOwnership(newOwner);
441 	}
442 
443 	function pauseToken() onlyOwner public {
444 		Pausable(token).pause();
445 	}
446 
447 	function unpauseToken() onlyOwner public {
448 		Pausable(token).unpause();
449 	}
450 
451 	function transfer(address beneficiary, uint256 amount) onlyOwner public {
452 		doPurchase(beneficiary, amount, 0);
453 		Purchase(beneficiary, address(1), 0, amount, 0);
454 		onPurchase(beneficiary, address(1), 0, amount, 0);
455 	}
456 }
457 
458 contract PreSale is GawooniSale {
459 	function PreSale(
460 		address _mintableToken,
461 		address _btcToken,
462 		uint256 _start,
463 		uint256 _end,
464 		uint256 _cap)
465 	GawooniSale(_mintableToken, _btcToken, _start, _end, _cap) {
466 
467 	}
468 
469 	function getBonus(uint256 sold) constant public returns (uint256) {
470 		return getTimeBonus(sold) + getAmountBonus(sold);
471 	}
472 
473 	function getTimeBonus(uint256 sold) internal returns (uint256) {
474 		return sold.div(2);
475 	}
476 
477 	function getAmountBonus(uint256 sold) internal returns (uint256) {
478 		if (sold >= 100000 * 10**18) {
479 			return sold;
480 		} else if (sold >= 50000 * 10 ** 18) {
481 			return sold.mul(75).div(100);
482 		} else {
483 			return 0;
484 		}
485 	}
486 }