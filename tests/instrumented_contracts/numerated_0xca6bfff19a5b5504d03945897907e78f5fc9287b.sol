1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
6  */
7 contract Ownable {
8     modifier onlyOwner() {
9         checkOwner();
10         _;
11     }
12 
13     function checkOwner() internal;
14 }
15 
16 /**
17  * @title Pausable
18  * @dev Base contract which allows children to implement an emergency stop mechanism.
19  */
20 contract Pausable is Ownable {
21     event Pause();
22     event Unpause();
23 
24     bool public paused = false;
25 
26 
27     /**
28      * @dev Modifier to make a function callable only when the contract is not paused.
29      */
30     modifier whenNotPaused() {
31         require(!paused);
32         _;
33     }
34 
35     /**
36      * @dev Modifier to make a function callable only when the contract is paused.
37      */
38     modifier whenPaused() {
39         require(paused);
40         _;
41     }
42 
43     /**
44      * @dev called by the owner to pause, triggers stopped state
45      */
46     function pause() onlyOwner whenNotPaused public {
47         paused = true;
48         Pause();
49     }
50 
51     /**
52      * @dev called by the owner to unpause, returns to normal state
53      */
54     function unpause() onlyOwner whenPaused public {
55         paused = false;
56         Unpause();
57     }
58 }
59 
60 /**
61  * @title OwnableImpl
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract OwnableImpl is Ownable {
66     address public owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     function OwnableImpl() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     function checkOwner() internal {
82         require(msg.sender == owner);
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address newOwner) onlyOwner public {
90         require(newOwner != address(0));
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93     }
94 }
95 
96 /**
97  * @title Read-only ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ReadOnlyToken {
101     uint256 public totalSupply;
102     function balanceOf(address who) public constant returns (uint256);
103     function allowance(address owner, address spender) public constant returns (uint256);
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract Token is ReadOnlyToken {
111   function transfer(address to, uint256 value) public returns (bool);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 contract MintableToken is Token {
119     event Mint(address indexed to, uint256 amount);
120 
121     function mint(address _to, uint256 _amount) public returns (bool);
122 }
123 
124 /**
125  * @title Sale contract for Daonomic platform should implement this
126  */
127 contract Sale {
128     /**
129      * @dev This event should be emitted when user buys something
130      */
131     event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus);
132     /**
133      * @dev Should be emitted if new payment method added
134      */
135     event RateAdd(address token);
136     /**
137      * @dev Should be emitted if payment method removed
138      */
139     event RateRemove(address token);
140 
141     /**
142      * @dev Calculate rate for specified payment method
143      */
144     function getRate(address token) constant public returns (uint256);
145     /**
146      * @dev Calculate current bonus in tokens
147      */
148     function getBonus(uint256 sold) constant public returns (uint256);
149 }
150 
151 /**
152  * @title SafeMath
153  * @dev Math operations with safety checks that throw on error
154  * @dev this version copied from zeppelin-solidity, constant changed to pure
155  */
156 library SafeMath {
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         if (a == 0) {
159             return 0;
160         }
161         uint256 c = a * b;
162         assert(c / a == b);
163         return c;
164     }
165 
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // assert(b > 0); // Solidity automatically throws when dividing by 0
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170         return c;
171     }
172 
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         assert(b <= a);
175         return a - b;
176     }
177 
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         assert(c >= a);
181         return c;
182     }
183 }
184 
185 /**
186  * @title Token represents some external value (for example, BTC)
187  */
188 contract ExternalToken is Token {
189     event Mint(address indexed to, uint256 value, bytes data);
190     event Burn(address indexed burner, uint256 value, bytes data);
191 
192     function burn(uint256 _value, bytes _data) public;
193 }
194 
195 /**
196  * @dev This adapter helps to receive tokens. It has some subcontracts for different tokens:
197  *   ERC20ReceiveAdapter - for receiving simple ERC20 tokens
198  *   ERC223ReceiveAdapter - for receiving ERC223 tokens
199  *   ReceiveApprovalAdapter - for receiving ERC20 tokens when token notifies receiver with receiveApproval
200  *   EtherReceiveAdapter - for receiving ether (onReceive callback will be used). this is needed for handling ether like tokens
201  *   CompatReceiveApproval - implements all these adapters
202  */
203 contract ReceiveAdapter {
204 
205     /**
206      * @dev Receive tokens from someone. Owner of the tokens should approve first
207      */
208     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal;
209 }
210 
211 /**
212  * @dev Helps to receive ERC20-complaint tokens. Owner should call token.approve first
213  */
214 contract ERC20ReceiveAdapter is ReceiveAdapter {
215     function receive(address _token, uint256 _value, bytes _data) public {
216         Token token = Token(_token);
217         token.transferFrom(msg.sender, this, _value);
218         onReceive(_token, msg.sender, _value, _data);
219     }
220 }
221 
222 /**
223  * @title ERC223 TokenReceiver interface
224  * @dev see https://github.com/ethereum/EIPs/issues/223
225  */
226 contract TokenReceiver {
227     function onTokenTransfer(address _from, uint256 _value, bytes _data) public;
228 }
229 
230 /**
231  * @dev Helps to receive ERC223-complaint tokens. ERC223 Token contract should notify receiver.
232  */
233 contract ERC223ReceiveAdapter is TokenReceiver, ReceiveAdapter {
234     function tokenFallback(address _from, uint256 _value, bytes _data) public {
235         onReceive(msg.sender, _from, _value, _data);
236     }
237 
238     function onTokenTransfer(address _from, uint256 _value, bytes _data) public {
239         onReceive(msg.sender, _from, _value, _data);
240     }
241 }
242 
243 contract EtherReceiver {
244 	function receiveWithData(bytes _data) payable public;
245 }
246 
247 contract EtherReceiveAdapter is EtherReceiver, ReceiveAdapter {
248     function () payable public {
249         receiveWithData("");
250     }
251 
252     function receiveWithData(bytes _data) payable public {
253         onReceive(address(0), msg.sender, msg.value, _data);
254     }
255 }
256 
257 /**
258  * @dev This ReceiveAdapter supports all possible tokens
259  */
260 contract CompatReceiveAdapter is ERC20ReceiveAdapter, ERC223ReceiveAdapter, EtherReceiveAdapter {
261 
262 }
263 
264 contract AbstractSale is Sale, CompatReceiveAdapter, Ownable {
265     using SafeMath for uint256;
266 
267     event Withdraw(address token, address to, uint256 value);
268     event Burn(address token, uint256 value, bytes data);
269 
270     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
271         uint256 sold = getSold(_token, _value);
272         require(sold > 0);
273         uint256 bonus = getBonus(sold);
274         address buyer;
275         if (_data.length == 20) {
276             buyer = address(toBytes20(_data, 0));
277         } else {
278             require(_data.length == 0);
279             buyer = _from;
280         }
281         checkPurchaseValid(buyer, sold, bonus);
282         doPurchase(buyer, sold, bonus);
283         Purchase(buyer, _token, _value, sold, bonus);
284         onPurchase(buyer, _token, _value, sold, bonus);
285     }
286 
287     function getSold(address _token, uint256 _value) constant public returns (uint256) {
288         uint256 rate = getRate(_token);
289         require(rate > 0);
290         return _value.mul(rate).div(10**18);
291     }
292 
293     function getBonus(uint256 sold) constant public returns (uint256);
294 
295     function getRate(address _token) constant public returns (uint256);
296 
297     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal;
298 
299     function checkPurchaseValid(address /*buyer*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
300 
301     }
302 
303     function onPurchase(address /*buyer*/, address /*token*/, uint256 /*value*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
304 
305     }
306 
307     function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
308         require(_start + 20 <= b.length);
309         assembly {
310             let from := add(_start, add(b, 0x20))
311             result := mload(from)
312         }
313     }
314 
315     function withdrawEth(address _to, uint256 _value) onlyOwner public {
316         withdraw(address(0), _to, _value);
317     }
318 
319     function withdraw(address _token, address _to, uint256 _value) onlyOwner public {
320         require(_to != address(0));
321         verifyCanWithdraw(_token, _to, _value);
322         if (_token == address(0)) {
323             _to.transfer(_value);
324         } else {
325             Token(_token).transfer(_to, _value);
326         }
327         Withdraw(_token, _to, _value);
328     }
329 
330     function verifyCanWithdraw(address token, address to, uint256 amount) internal;
331 
332     function burnWithData(address _token, uint256 _value, bytes _data) onlyOwner public {
333         ExternalToken(_token).burn(_value, _data);
334         Burn(_token, _value, _data);
335     }
336 }
337 
338 /**
339  * @title This sale mints token when user sends accepted payments
340  */
341 contract MintingSale is AbstractSale {
342     MintableToken public token;
343 
344     function MintingSale(address _token) public {
345         token = MintableToken(_token);
346     }
347 
348     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal {
349         token.mint(buyer, sold.add(bonus));
350     }
351 
352     function verifyCanWithdraw(address, address, uint256) internal {
353 
354     }
355 }
356 
357 contract CappedSale is AbstractSale {
358     uint256 public cap;
359     uint256 public initialCap;
360 
361     function CappedSale(uint256 _cap) public {
362         cap = _cap;
363         initialCap = _cap;
364     }
365 
366     function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
367         super.checkPurchaseValid(buyer, sold, bonus);
368         require(cap >= sold);
369     }
370 
371     function onPurchase(address buyer, address token, uint256 value, uint256 sold, uint256 bonus) internal {
372         super.onPurchase(buyer, token, value, sold, bonus);
373         cap = cap.sub(sold);
374     }
375 }
376 
377 contract PeriodSale is AbstractSale {
378 	uint256 public start;
379 	uint256 public end;
380 
381 	function PeriodSale(uint256 _start, uint256 _end) public {
382 		start = _start;
383 		end = _end;
384 	}
385 
386 	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
387 		super.checkPurchaseValid(buyer, sold, bonus);
388 		require(now > start && now < end);
389 	}
390 }
391 
392 contract Eticket4Sale is MintingSale, PeriodSale, OwnableImpl, CappedSale {
393     address public btcToken;
394 
395     uint256 public btcEthRate = 10 * 10**10;
396     uint256 public constant ethEt4Rate = 1000 * 10**18;
397 
398     function Eticket4Sale(
399         address _mintableToken,
400         address _btcToken,
401         uint256 _start,
402         uint256 _end,
403         uint256 _cap)
404     MintingSale(_mintableToken)
405     PeriodSale(_start, _end)
406     CappedSale(_cap) {
407         btcToken = _btcToken;
408         RateAdd(address(0));
409         RateAdd(_btcToken);
410     }
411 
412     function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
413         super.checkPurchaseValid(buyer, sold, bonus);
414         require(now > start && now < end);
415     }
416 
417     function getRate(address _token) constant public returns (uint256) {
418         if (_token == btcToken) {
419             return btcEthRate * ethEt4Rate;
420         } else if (_token == address(0)) {
421             return ethEt4Rate;
422         } else {
423             return 0;
424         }
425     }
426 
427     event BtcEthRateChange(uint256 btcEthRate);
428 
429     function setBtcEthRate(uint256 _btcEthRate) onlyOwner public {
430         btcEthRate = _btcEthRate;
431         BtcEthRateChange(_btcEthRate);
432     }
433 
434     function withdrawBtc(bytes _to, uint256 _value) onlyOwner public {
435         burnWithData(btcToken, _value, _to);
436     }
437 
438     function transferTokenOwnership(address newOwner) onlyOwner public {
439         OwnableImpl(token).transferOwnership(newOwner);
440     }
441 
442     function pauseToken() onlyOwner public {
443         Pausable(token).pause();
444     }
445 
446     function unpauseToken() onlyOwner public {
447         Pausable(token).unpause();
448     }
449 
450     function transferWithBonus(address beneficiary, uint256 amount) onlyOwner public {
451         uint256 bonus = getBonus(amount);
452         doPurchase(beneficiary, amount, bonus);
453         Purchase(beneficiary, address(1), 0, amount, bonus);
454         onPurchase(beneficiary, address(1), 0, amount, bonus);
455     }
456 
457     function transfer(address beneficiary, uint256 amount) onlyOwner public {
458         doPurchase(beneficiary, amount, 0);
459         Purchase(beneficiary, address(1), 0, amount, 0);
460         onPurchase(beneficiary, address(1), 0, amount, 0);
461     }
462 }
463 
464 contract DaoxCommissionSale is AbstractSale {
465 	function getSold(address _token, uint256 _value) constant public returns (uint256) {
466 		return super.getSold(_token, _value).div(99).mul(100);
467 	}
468 }
469 
470 /**
471  * @title Secured
472  * @dev Adds only(role) modifier. Subcontracts should implement checkRole to check if caller is allowed to do action.
473  */
474 contract Secured {
475     modifier only(string role) {
476         require(msg.sender == getRole(role));
477         _;
478     }
479 
480     function getRole(string role) constant public returns (address);
481 }
482 
483 contract SecuredImpl is Ownable, Secured {
484 	mapping(string => address) users;
485 	event RoleTransferred(address indexed previousUser, address indexed newUser, string role);
486 
487 	function getRole(string role) constant public returns (address) {
488 		return users[role];
489 	}
490 
491 	function transferRole(string role, address to) onlyOwner public {
492 		require(to != address(0));
493 		RoleTransferred(users[role], to, role);
494 		users[role] = to;
495 	}
496 }
497 
498 contract Whitelist is Secured {
499 	mapping(address => bool) whitelist;
500 	event WhitelistChange(address indexed addr, bool allow);
501 
502 	function isInWhitelist(address addr) constant public returns (bool) {
503 		return whitelist[addr];
504 	}
505 
506 	function setWhitelist(address addr, bool allow) only("operator") public {
507 		setWhitelistInternal(addr, allow);
508 	}
509 
510 	function setWhitelistInternal(address addr, bool allow) internal {
511 		whitelist[addr] = allow;
512 		WhitelistChange(addr, allow);
513 	}
514 }
515 
516 contract PublicSale is SecuredImpl, Whitelist, Eticket4Sale, DaoxCommissionSale {
517 	function PublicSale(
518 		address _mintableToken,
519 		address _btcToken,
520 		uint256 _start,
521 		uint256 _end,
522 		uint256 _cap)
523 	Eticket4Sale(_mintableToken, _btcToken, _start, _end, _cap) {
524 
525 	}
526 
527 	function getBonus(uint256 sold) constant public returns (uint256) {
528 		return getTimeBonus(sold) + getAmountBonus(sold);
529 	}
530 
531 	function getTimeBonus(uint256 sold) internal returns (uint256) {
532 		uint256 interval = (now - start) / (86400 * 5);
533 		if (interval == 0) {
534 			return sold.mul(6).div(100);
535 		} else if (interval == 1) {
536 			return sold.mul(4).div(100);
537 		} else if (interval == 2 || interval == 3) {
538 			return sold.mul(3).div(100);
539 		} else {
540 			return sold.mul(1).div(100);
541 		}
542 	}
543 
544 	function getAmountBonus(uint256 sold) internal returns (uint256) {
545 		if (sold > 20000 * 10 ** 18) {
546 			return sold.mul(25).div(100);
547 		} else if (sold > 15000 * 10 ** 18) {
548 			return sold.mul(20).div(100);
549 		} else if (sold > 10000 * 10 ** 18) {
550 			return sold.mul(15).div(100);
551 		} else if (sold > 5000 * 10 ** 18) {
552 			return sold.mul(10).div(100);
553 		} else if (sold > 1000 * 10 ** 18) {
554 			return sold.mul(5).div(100);
555 		} else {
556 			return 0;
557 		}
558 	}
559 
560 	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
561 		super.checkPurchaseValid(buyer, sold, bonus);
562 		if (sold >= 10000 * 10 ** 18) {
563 			require(isInWhitelist(buyer));
564 		}
565 	}
566 }